

/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. 
 * File Name     : fifo_top.sv
 
 * Description   :
 _._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._*/
//`include "synchronizer.sv"
// `include "wrptr_handler.sv"
// `include "rdptr_handler.sv"
// `include "fifo_memory.sv"

 module asynchronous_fifo #(parameter FIFO_DEPTH=8, FIFO_WIDTH=64) (
   input wrclk, wrst_n,
   input rdclk, rrst_n,
   input wr_en, rd_en,
   input [FIFO_WIDTH-1:0] data_in,
   output reg [FIFO_WIDTH-1:0] data_out,
   output reg fifo_full, fifo_empty
   );
  
   parameter PTR_WIDTH = $clog2(FIFO_DEPTH);
  
   //gray-coded write pointer and read pointer
   reg [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
   reg [PTR_WIDTH:0] g_wptr, g_rptr,

   //binary write and read pointer 
   reg [PTR_WIDTH:0] b_wptr, b_rptr;
  

   wire [PTR_WIDTH-1:0] waddr, raddr

   //write pointer to read clock domain
   synchronizer #(PTR_WIDTH) sync_wptr (
					.clk		(rdclk), 
					.rst_n 	        (rrst_n), 
					.d_in		(g_wptr), 
					.d_out  	(g_wptr_sync)
				       ); 

   //read pointer to write clock domain
   synchronizer #(PTR_WIDTH) sync_rptr (
					.clk		(wrclk), 
					.rst_n		(wrst_n), 
					.d_in		(g_rptr), 
					.d_out  	(g_rptr_sync)
				       );  
  
   wptr_handler #(PTR_WIDTH) wrptr_h   (
					.wrclk		(wrclk), 
					.wrst_n		(wrst_n), 
					.wr_en		(wr_en),
					.g_rptr_sync	(g_rptr_sync),
					.b_wptr		(b_wptr),
					.g_wptr		(g_wptr),
					.fifo_full	(fifo_full)
				       );

   rptr_handler #(PTR_WIDTH) rdptr_h   (
					.rdclk		(rdclk), 
					.rrst_n		(rrst_n),
					.rd_en		(rd_en),
					.g_wptr_sync	(g_wptr_sync),
					.b_rptr		(b_rptr),
					.g_rptr		(g_rptr),
					 fifo_empty	(fifo_empty)
				       );

  fifo_memory fifom		      (
					 wrclk		(wrclk), 
					.wr_en		(wr_en),
				        .rdclk		(rdclk), 
					.rd_en		(rd_en),
					.b_wptr		(b_wptr), 
					.b_rptr		(b_rptr), 
					.data_in	(data_in),
					.fifo_full	(fifo_full),
					.fifo_empty	(fifo_empty), 
					.data_out	(data_out),
				       );

 endmodule
