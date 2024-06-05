//29-6

`include "interface.sv"
`include "random_test.sv"

module tb_top;
  
  bit rdclk;
  bit wrclk;
  bit wrst_n, rrst_n;
  bit wr_en, rd_en;

  //Clock signals
  always begin  #12 rdclk= ~rdclk; end     
  always begin  #5 wrclk= ~wrclk; end
  
  
  //Reset Signals
  initial begin
    wrst_n=1'b0;
    rrst_n=1'b0;
    #10 wrst_n=1'b1;
    #5 rrst_n=1'b1;
//     #40 wrst_n=1'b0; 
//     #5 rrst_n=1'b0;
//      #10 wrst_n=1'b1;
//     #5 rrst_n=1'b1;
  end

  //Enable Signals
  initial begin
//     #35 rd_en=1'b1; wr_en=1'b0;
//     #35 rd_en=1'b0; wr_en=1'b1;
//     #35 rd_en=1'b1; wr_en=1'b0;
//     #35 rd_en=1'b0; wr_en=1'b1;
//     #35 rd_en=1'b1; wr_en=1'b0;
//     #35 rd_en=1'b0; wr_en=1'b1;
//     #35 rd_en=1'b1; wr_en=1'b0;
//     #35 rd_en=1'b0; wr_en=1'b1;
//     #35 rd_en=1'b1; wr_en=1'b0;
    
     #40 wr_en=1'b1;
    #60 rd_en = 1'b1; 
    
  end

  
  fifo_intf i_intf(wrclk,rdclk,wrst_n,rrst_n,wr_en,rd_en);
  test t1(i_intf);
  
  asynchronous_fifo fifo_instance  (
    .wrclk(wrclk),
    .rdclk(rdclk),
    .wrst_n(wrst_n),
    .rrst_n(rrst_n),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(i_intf.data_in),
    .data_out(i_intf.data_out),
    .fifo_full(i_intf.fifo_full),
    .fifo_empty(i_intf.fifo_empty)
  );
  
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
 
endmodule