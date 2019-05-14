`include "timescale.v"
module tb_spi_top();

  reg         clk;
  reg         rst;
  wire [31:0] adr;
  wire [31:0] dat_i, dat_o;
  wire        we;
  wire  [3:0] sel;
  wire        stb;
  wire        cyc;
  wire        ack;
  wire        err;
  wire        int;

  wire  [7:0] ss;
  wire        sclk;
  wire        mosi;
  wire        miso;

  reg  [31:0] q;
  reg  [31:0] q1;
  reg  [31:0] q2;
  reg  [31:0] q3;
  reg  [31:0] result;

  //寄存器地址
  parameter SPI_RX_0   = 5'h0;
  parameter SPI_RX_1   = 5'h4;
  parameter SPI_RX_2   = 5'h8;
  parameter SPI_RX_3   = 5'hc;
  parameter SPI_TX_0   = 5'h0;
  parameter SPI_TX_1   = 5'h4;
  parameter SPI_TX_2   = 5'h8;
  parameter SPI_TX_3   = 5'hc;
  parameter SPI_CTRL   = 5'h10;
  parameter SPI_DIVIDE = 5'h14;
  parameter SPI_SS     = 5'h18;

  // Generate clock
  always #5 clk = ~clk;

  // Wishbone master model
  wb_master_model #(32, 32) i_wb_master (
    .clk(clk), .rst(rst),
    .adr(adr), .din(dat_i), .dout(dat_o),
    .cyc(cyc), .stb(stb), .we(we), .sel(sel), .ack(ack), .err(err), .rty(1'b0)
  );

  // SPI master core
  spi_top i_spi_top (
    .wb_clk_i(clk), .wb_rst_i(rst), 
    .wb_adr_i(adr[4:0]), .wb_dat_i(dat_o), .wb_dat_o(dat_i), 
    .wb_sel_i(sel), .wb_we_i(we), .wb_stb_i(stb), 
    .wb_cyc_i(cyc), .wb_ack_o(ack), .wb_err_o(err), .wb_int_o(int),
    .ss_pad_o(ss), .sclk_pad_o(sclk), .mosi_pad_o(mosi), .miso_pad_i(miso) 
  );

  // SPI slave model
  spi_slave_model i_spi_slave (
    .rst(rst), .ss(ss[0]), .sclk(sclk), .mosi(mosi), .miso(miso)
  );

  initial
    begin
      $display("\nstatus: %t Testbench started\n\n", $time);
      $dumpfile("bench.vcd");
      $dumpvars(1, tb_spi_top);
      $dumpvars(1, tb_spi_top.i_spi_slave);

      // Initial reg values
      clk = 0;

      i_spi_slave.rx_negedge = 1'b0;
      i_spi_slave.tx_negedge = 1'b0;

      result = 32'h0;

      // Reset system
      rst = 1'b0; // negate reset
      #2;
      rst = 1'b1; // assert reset
      //等待20个时钟周期完成复位
      repeat(20) @(posedge clk);
      rst = 1'b0; // negate reset

      $display("status: %t done reset", $time);
      
      @(posedge clk);
    //////////////////////////////////////////////////////////////////////
    //case list
    //////////////////////////////////////////////////////////////////////
    //参数：延时，地址，数据

    //////////////////////
    //case 1
    /////////////////////
      
      //配置寄存器
      i_wb_master.wb_write(0, SPI_DIVIDE, 32'h01); // set devider register
      i_wb_master.wb_write(0, SPI_TX_0, 32'h800950);   // set tx register to 0x5a
      i_wb_master.wb_write(0, SPI_CTRL, 32'h218);   // set 24 bit transfer
      i_wb_master.wb_write(0, SPI_SS, 32'h01);     // set ss 0
      $display("status: %t programmed registers", $time);
      
      //校验寄存器
      i_wb_master.wb_cmp(0, SPI_DIVIDE, 32'h01);   // verify devider register
      i_wb_master.wb_cmp(0, SPI_TX_0, 32'h800950);     // verify tx register
      i_wb_master.wb_cmp(0, SPI_CTRL, 32'h218);     // verify tx register
      i_wb_master.wb_cmp(0, SPI_SS, 32'h01);       // verify ss register
      $display("status: %t verified registers", $time);

      //读取MISO
      i_spi_slave.rx_negedge = 1'b1;
      i_spi_slave.tx_negedge = 1'b0;
      i_spi_slave.data[31:0] = 32'h5a;
      i_wb_master.wb_write(0, SPI_CTRL, 32'h318);   // set 24 bit transfer, start transfer
      $display("status: %t generate transfer:  24 bit, msb first, tx posedge, rx negedge", $time);

      // Check bsy bit
      i_wb_master.wb_read(0, SPI_CTRL, q);
      while (q[8])
        i_wb_master.wb_read(1, SPI_CTRL, q);

      i_wb_master.wb_read(1, SPI_RX_0, q);
      result = result + q;

      if (i_spi_slave.data[7:0] == 8'h5a && q == 32'h000000a5)
        $display("status: %t transfer completed: ok", $time);
      else
        $display("status: %t transfer completed: not ok", $time);
    end

endmodule


