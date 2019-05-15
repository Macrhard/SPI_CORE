`include "spi_defines.v"
`include "timescale.v"

module spi_top
(
  // Wishbone signals
  input                            i_clk,         // master clock input
  input                            i_rst,         // synchronous active high reset
  input                      [4:0] i_adr,         // lower address bits
  input                   [32-1:0] i_dat,         // databus input
  output  reg             [32-1:0] o_dat,         // databus output  to soc
  input                      [3:0] i_sel,         // byte select inputs
  input                            i_we,           // write enable input
  input                            i_stb,         // stobe/core select signal
  input                            i_cyc,         // valid bus cycle input
  output  reg                      o_ack,         // bus cycle acknowledge output
  output                           o_err,         // termination w/ error
  output  reg                      o_intrup,         // interrupt request signal output
                                                     
  // SPI signals                                     
  output          [`SPI_SS_NB-1:0] o_pad_ss,         // slave select
  output                           o_pad_sclk,       // serial clock
  output                           o_pad_mosi,       // master out slave in
  input                            i_pad_miso        // master in slave out
 );   

  parameter Tp = `TP;   
                                  
  // Internal signals
  reg       [`SPI_CTRL_BIT_NB-1:0] ctrl;             // Control and status register
  reg       [`SPI_DIVIDER_LEN-1:0] divider;          // Divider register
  reg             [`SPI_SS_NB-1:0] ss;               // Slave select register


  reg                     [32-1:0] r_rx_dat;           // wb data out  rx data to soc
  wire         [`SPI_MAX_CHAR-1:0] rx;               // Rx register

  //ctrl 寄存器各个控制位
  wire                             rx_negedge;       // miso is sampled on negative edge
  wire                             tx_negedge;       // mosi is driven on negative edge
  wire    [`SPI_CHAR_LEN_BITS-1:0] char_len;         // char len
  wire                             go;               // go
  wire                             lsb;              // lsb first on line
  wire                             ie;               // interrupt enable
  wire                             ass;              // automatic slave select

  wire                             spi_divider_sel;  // divider register select
  wire                             spi_ctrl_sel;     // ctrl register select
  wire                       [3:0] spi_tx_sel;       // tx_l register select
  wire                             spi_ss_sel;       // ss register select
  wire                             tip;              // transfer in progress
  wire                             pos_edge;         // recognize posedge of sclk
  wire                             neg_edge;         // recognize negedge of sclk
  wire                             last_bit;         // marks last character bit
  
  // Address decoder
  assign spi_divider_sel = i_cyc & i_stb & (i_adr[`SPI_OFS_BITS] == `SPI_DEVIDE);
  assign spi_ctrl_sel    = i_cyc & i_stb & (i_adr[`SPI_OFS_BITS] == `SPI_CTRL);
  assign spi_tx_sel[0]   = i_cyc & i_stb & (i_adr[`SPI_OFS_BITS] == `SPI_TX_0);
  assign spi_tx_sel[1]   = i_cyc & i_stb & (i_adr[`SPI_OFS_BITS] == `SPI_TX_1);
  assign spi_tx_sel[2]   = i_cyc & i_stb & (i_adr[`SPI_OFS_BITS] == `SPI_TX_2);
  assign spi_tx_sel[3]   = i_cyc & i_stb & (i_adr[`SPI_OFS_BITS] == `SPI_TX_3);
  assign spi_ss_sel      = i_cyc & i_stb & (i_adr[`SPI_OFS_BITS] == `SPI_SS);
  
  // Read from registers
  always @(i_adr or rx or ctrl or divider or ss)
  begin
    case (i_adr[`SPI_OFS_BITS])
`ifdef SPI_MAX_CHAR_128
      `SPI_RX_0:    r_rx_dat = rx[31:0];
      `SPI_RX_1:    r_rx_dat = rx[63:32];
      `SPI_RX_2:    r_rx_dat = rx[95:64];
      `SPI_RX_3:    r_rx_dat = {{128-`SPI_MAX_CHAR{1'b0}}, rx[`SPI_MAX_CHAR-1:96]};
`else
`ifdef SPI_MAX_CHAR_64
      `SPI_RX_0:    r_rx_dat = rx[31:0];
      `SPI_RX_1:    r_rx_dat = {{64-`SPI_MAX_CHAR{1'b0}}, rx[`SPI_MAX_CHAR-1:32]};
      `SPI_RX_2:    r_rx_dat = 32'b0;
      `SPI_RX_3:    r_rx_dat = 32'b0;
`else
      `SPI_RX_0:    r_rx_dat = {{32-`SPI_MAX_CHAR{1'b0}}, rx[`SPI_MAX_CHAR-1:0]};
      `SPI_RX_1:    r_rx_dat = 32'b0;
      `SPI_RX_2:    r_rx_dat = 32'b0;
      `SPI_RX_3:    r_rx_dat = 32'b0;
`endif
`endif
      `SPI_CTRL:    r_rx_dat = {{32-`SPI_CTRL_BIT_NB{1'b0}}, ctrl};
      `SPI_DEVIDE:  r_rx_dat = {{32-`SPI_DIVIDER_LEN{1'b0}}, divider};
      `SPI_SS:      r_rx_dat = {{32-`SPI_SS_NB{1'b0}}, ss};
      default:      r_rx_dat = 32'bx;
    endcase
  end
  
  // Wb data out
  always @(posedge i_clk or posedge i_rst)
  begin
    if (i_rst)
      o_dat <= #Tp 32'b0;
    else
      o_dat <= #Tp r_rx_dat;
  end
  
  // Wb acknowledge
  always @(posedge i_clk or posedge i_rst)
  begin
    if (i_rst)
      o_ack <= #Tp 1'b0;
    else
      o_ack <= #Tp i_cyc & i_stb & ~o_ack;
  end
  
  // Wb error
  assign o_err = 1'b0;
  
  // Interrupt
  always @(posedge i_clk or posedge i_rst)
  begin
    if (i_rst)
      o_intrup <= #Tp 1'b0;
    else if (ie && tip && last_bit && pos_edge)
      o_intrup <= #Tp 1'b1;
    else if (o_ack)
      o_intrup <= #Tp 1'b0;
  end
  
  // Divider register
  always @(posedge i_clk or posedge i_rst)
  begin
    if (i_rst)
        divider <= #Tp {`SPI_DIVIDER_LEN{1'b0}};
    else if (spi_divider_sel && i_we && !tip)
      begin
      `ifdef SPI_DIVIDER_LEN_8
        if (i_sel[0])
          divider <= #Tp i_dat[`SPI_DIVIDER_LEN-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_16
        if (i_sel[0])
          divider[7:0] <= #Tp i_dat[7:0];
        if (i_sel[1])
          divider[`SPI_DIVIDER_LEN-1:8] <= #Tp i_dat[`SPI_DIVIDER_LEN-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_24
        if (i_sel[0])
          divider[7:0] <= #Tp i_dat[7:0];
        if (i_sel[1])
          divider[15:8] <= #Tp i_dat[15:8];
        if (i_sel[2])
          divider[`SPI_DIVIDER_LEN-1:16] <= #Tp i_dat[`SPI_DIVIDER_LEN-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_32
        if (i_sel[0])
          divider[7:0] <= #Tp i_dat[7:0];
        if (i_sel[1])
          divider[15:8] <= #Tp i_dat[15:8];
        if (i_sel[2])
          divider[23:16] <= #Tp i_dat[23:16];
        if (i_sel[3])
          divider[`SPI_DIVIDER_LEN-1:24] <= #Tp i_dat[`SPI_DIVIDER_LEN-1:24];
      `endif
      end
  end
  
  // Ctrl register
  always @(posedge i_clk or posedge i_rst)
  begin
    if (i_rst)
      ctrl <= #Tp {`SPI_CTRL_BIT_NB{1'b0}};
    else if(spi_ctrl_sel && i_we && !tip)
      begin
        if (i_sel[0])
          ctrl[7:0] <= #Tp i_dat[7:0] | {7'b0, ctrl[0]};
        if (i_sel[1])
          ctrl[`SPI_CTRL_BIT_NB-1:8] <= #Tp i_dat[`SPI_CTRL_BIT_NB-1:8];
      end
    else if(tip && last_bit && pos_edge)
      ctrl[`SPI_CTRL_GO] <= #Tp 1'b0;
  end
  
  assign rx_negedge = ctrl[`SPI_CTRL_RX_NEGEDGE];
  assign tx_negedge = ctrl[`SPI_CTRL_TX_NEGEDGE];
  assign go         = ctrl[`SPI_CTRL_GO];
  assign char_len   = ctrl[`SPI_CTRL_CHAR_LEN];
  assign lsb        = ctrl[`SPI_CTRL_LSB];
  assign ie         = ctrl[`SPI_CTRL_IE];
  assign ass        = ctrl[`SPI_CTRL_ASS];
  
  // Slave select register
  always @(posedge i_clk or posedge i_rst)
  begin
    if (i_rst)
      ss <= #Tp {`SPI_SS_NB{1'b0}};
    else if(spi_ss_sel && i_we && !tip)
      begin
      `ifdef SPI_SS_NB_8
        if (i_sel[0])
          ss <= #Tp i_dat[`SPI_SS_NB-1:0];
      `endif
      `ifdef SPI_SS_NB_16
        if (i_sel[0])
          ss[7:0] <= #Tp i_dat[7:0];
        if (i_sel[1])
          ss[`SPI_SS_NB-1:8] <= #Tp i_dat[`SPI_SS_NB-1:8];
      `endif
      `ifdef SPI_SS_NB_24
        if (i_sel[0])
          ss[7:0] <= #Tp i_dat[7:0];
        if (i_sel[1])
          ss[15:8] <= #Tp i_dat[15:8];
        if (i_sel[2])
          ss[`SPI_SS_NB-1:16] <= #Tp i_dat[`SPI_SS_NB-1:16];
      `endif
      `ifdef SPI_SS_NB_32
        if (i_sel[0])
          ss[7:0] <= #Tp i_dat[7:0];
        if (i_sel[1])
          ss[15:8] <= #Tp i_dat[15:8];
        if (i_sel[2])
          ss[23:16] <= #Tp i_dat[23:16];
        if (i_sel[3])
          ss[`SPI_SS_NB-1:24] <= #Tp i_dat[`SPI_SS_NB-1:24];
      `endif
      end
  end
  //ass 置1后 的作用是传输完成后自动拉高片选信号
  assign o_pad_ss = ~((ss & {`SPI_SS_NB{tip & ass}}) | (ss & {`SPI_SS_NB{!ass}}));
  
  spi_clgen clgen (.clk_in(i_clk), .rst(i_rst), .go(go), .enable(tip), .last_clk(last_bit),
                   .divider(divider), .clk_out(o_pad_sclk), .pos_edge(pos_edge), 
                   .neg_edge(neg_edge));
  
  spi_shift shift (.clk(i_clk), .rst(i_rst), .len(char_len[`SPI_CHAR_LEN_BITS-1:0]),
                   .latch(spi_tx_sel[3:0] & {4{i_we}}), .byte_sel(i_sel), .lsb(lsb), 
                   .go(go), .pos_edge(pos_edge), .neg_edge(neg_edge), 
                   .rx_negedge(rx_negedge), .tx_negedge(tx_negedge),
                   .tip(tip), .last(last_bit), 
                   .p_in(i_dat), .p_out(rx), 
                   .s_clk(o_pad_sclk), .s_in(i_pad_miso), .s_out(o_pad_mosi));
endmodule
  
