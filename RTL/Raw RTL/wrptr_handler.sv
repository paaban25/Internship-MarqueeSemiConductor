

/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. 
 * File Name     : wrptr_handler.sv
 
* Description   :
 _._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._*/

 module wptr_handler #(parameter PTR_WIDTH=3) (
   input wrclk, wrst_n, rd_en,
   input [PTR_WIDTH:0] g_rptr_sync,
   output reg [PTR_WIDTH:0] b_wptr, g_wptr,
   output reg fifo_full
   );

   reg [PTR_WIDTH:0] b_wptr_next;
   reg [PTR_WIDTH:0] g_wptr_next;
   
   reg wrap_around;
   wire wfull;
  
   assign b_wptr_next = b_wptr+(rd_en & !fifo_full);
   assign g_wptr_next = (b_wptr_next >>1)^b_wptr_next;
  
   always@(posedge wrclk or negedge wrst_n) begin
     if(!wrst_n) begin
       b_wptr <= 4; // set default value
       g_wptr <= 2;
     end
     else begin
       b_wptr <= b_wptr_next; // incr binary write pointer
       g_wptr <= g_wptr_next; // incr gray write pointer
     end
   end
  
   always@(posedge wrclk or negedge wrst_n) begin
     if(!wrst_n) fifo_full <= 0;
     else        fifo_full <= wfull;
   end

   assign wfull = (b_wptr_next == {~g_rptr_sync[PTR_WIDTH:PTR_WIDTH-1], g_rptr_sync[PTR_WIDTH-2:0]});

 endmodule
