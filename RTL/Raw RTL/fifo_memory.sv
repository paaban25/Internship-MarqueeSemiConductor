

/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. 
 * File Name     : fifo_memory.sv
 
 * Creation Date : 18-04-2024
 
 
 * Description   :
 _._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._*/
 module fifo_mem #(parameter FIFO_DEPTH=8, FIFO_WIDTH=16, PTR_WIDTH=3) (
   input wrclk, wr_en, rdclk, rd_en,
   input [PTR_WIDTH:0] b_wptr, b_rptr,
   input [FIFO_WIDTH-1:0] data_in,
   input fifo_full, fifo_empty,
   output reg [FIFO_WIDTH-1:0] data_out
   );
   reg [FIFO_WIDTH-1:0] fifo[0:FIFO_DEPTH-1];
  
   always@(posedge wrclk) begin
     if(wr_en & fifo_empty) begin
       fifo[b_wptr[PTR_WIDTH-1:0]] <= data_in;
     end
   end
  
   
   always@(posedge rdclk) begin
     if(rd_en & fifo_full) begin
       data_out <= fifo[b_rptr[PTR_WIDTH-1:0]];
     end
   end
   
   //assign data_out = fifo[b_rptr[PTR_WIDTH-1:0]];
 endmodule
