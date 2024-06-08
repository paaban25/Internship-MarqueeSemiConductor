interface fifo_intf(
  input logic wrclk,
  input logic rdclk,
  input logic wrst_n,rrst_n
  
);
  
  localparam int FIFO_WIDTH = 64;

  logic [FIFO_WIDTH-1:0] data_in;
  logic [FIFO_WIDTH-1:0] data_out;
  logic fifo_full;
  logic fifo_empty; 
  logic wr_en,rd_en;
  
  function void display();
    $display("Data Passes through interface");
  endfunction
endinterface