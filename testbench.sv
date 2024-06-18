`include "interface.sv"
`include "random_test.sv"
// `include "directed_write.sv"


module tb_top;
  
  bit rdclk;
  bit wrclk;
  bit wrst_n, rrst_n;
//   bit wr_en, rd_en;
  parameter RD_CLK_T=20;
  parameter WR_CLK_T=30;

  
  
  

  initial begin
    rdclk=1'b0;
    wrclk=1'b1;
    wrst_n=1'b0;
    rrst_n=1'b0;
    #30wrst_n=1'b1;
    #5 rrst_n=1'b1;
    
//     #120 wrst_n=1'b0;
//     #120 wrst_n=1'b1;  		To check for wrst actions    
    
//     #300 rrst_n=1'b0;      To check for rrst actions
//     #40 wrst_n=1'b0; 
//     #5 rrst_n=1'b0;
//      #10 wrst_n=1'b1;
//     #5 rrst_n=1'b1;
    
//     #150 wrst_n=1'b0;  rrst_n=1'b0;   To check for rst_n signal actions
    
  end
  
  always begin  #(RD_CLK_T/2) rdclk= ~rdclk; end     
  always begin  #(WR_CLK_T/2) wrclk= ~wrclk; end

  //Enable Signals
  //initial begin
//     #35 rd_en=1'b1; wr_en=1'b0;
//     #35 rd_en=1'b0; wr_en=1'b1;
//     #35 rd_en=1'b1; wr_en=1'b0;
//     #35 rd_en=1'b0; wr_en=1'b1;
//     #35 rd_en=1'b1; wr_en=1'b0;
//     #35 rd_en=1'b0; wr_en=1'b1;
//     #35 rd_en=1'b1; wr_en=1'b0;
//     #35 rd_en=1'b0; wr_en=1'b1;
//     #35 rd_en=1'b1; wr_en=1'b0;
    
//      #40 wr_en=1'b1;
//     #60 rd_en = 1'b1; 
    
  //end

  
  fifo_intf vif(wrclk,rdclk,wrst_n,rrst_n);
  test t1(vif);
  
  asynchronous_fifo fifo_instance  (
    .wrclk(vif.wrclk),
    .rdclk(vif.rdclk),
    .wrst_n(vif.wrst_n),
    .rrst_n(vif.rrst_n),
    .wr_en(vif.wr_en),
    .rd_en(vif.rd_en),
    .data_in(vif.data_in),
    .data_out(vif.data_out),
    .fifo_full(vif.fifo_full),
    .fifo_empty(vif.fifo_empty)
  );
  
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
    #600 $finish;
  end
 
endmodule