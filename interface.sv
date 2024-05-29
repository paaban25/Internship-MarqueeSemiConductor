interface fifo_intf(
  input logic wrclk,
  input logic rdclk,
  input logic wrst_n,
  input logic rrst_n
);
  
  logic wr_en;
  logic rd_en;
  logic [63:0] data_in;
  logic [63:0] data_out;
  logic fifo_full;
  logic fifo_empty;
  
  
   
    
endinterface