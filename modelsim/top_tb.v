`include "../timescale.v"
`include "../spi_defines.v"
module top_tb();

reg  clk_in;   
reg  rst;      
reg  enable;   
reg  go;       
reg  last_clk; 
reg  [`SPI_DIVIDER_LEN-1:0] divider;  
wire clk_out;  
wire pos_edge; 
wire neg_edge;

spi_clgen   spi_clgen(
    .clk_in     (clk_in),
    .rst        (rst),
    .enable     (enable),
    .go         (go),
    .last_clk   (last_clk),
    .divider    (divider),
    .clk_out    (clk_out),
    .pos_edge   (pos_edge),
    .neg_edge   (neg_edge)
);


initial begin
        clk_in = 1'b0;
        rst = 1'b1;
        enable = 1'b1;
        last_clk = 1'b0;
        go  = 1'b1;
        divider = 8'd4;
    #20 rst = 1'b0;
    #10  divider = 8'd8;
    #1000 divider = 8'd3;
    #1000 divider = 8'd4;
    #1000 divider = 8'd5;
    #1000 divider = 8'd1;
    #1000 divider = 8'd7;
    #1000 divider = 8'd2;
    #1000 divider = 8'd4;
    #1000 divider = 8'd0;
   // #500 enable = 1'b0;
end

always #1 clk_in = ~clk_in;
endmodule // 