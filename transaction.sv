class transaction#(int FIFO_DEPTH = 8, FIFO_WIDTH = 64);
  bit rand wrclk;
  bit rand rdclk;
  bit rand wrst_n;
  bit rand rrst_n;
  bit rand wr_en;
  bit rand rd_en;
  bit [63:0] rand data_in;
  bit [63:0] data_out;
  bit fifo_full;
  bit fifo_empty;
  
  constraint wr_rd_c { wr_en != rd_en; };
  
endclass
  