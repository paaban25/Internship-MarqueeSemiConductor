class transaction;
  localparam int FIFO_DEPTH = 8;
  localparam int FIFO_WIDTH = 64;

  bit wrclk;
  bit rdclk;
  bit wrst_n;
  bit rrst_n;
  bit wr_en;
  bit rd_en;
  rand bit [FIFO_WIDTH-1:0] data_in;  
  bit [FIFO_WIDTH-1:0] data_out;
  bit fifo_full;
  bit fifo_empty;
  
  
  
  


  
  
//   function void display();
//     $display("wrst_n=%0b , rrst_n=%0b, wr_en=%0b, rd_en=%0b, data_in=%0h, data_out=%0h, fifo_full=%0b, fifo_empty=%0b " ,wrst_n,rrst_n,wr_en,rd_en,data_in, data_out,fifo_full,fifo_empty);
//   endfunction
  
  
endclass

  