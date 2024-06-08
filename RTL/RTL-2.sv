//After fixing logical error

 module wptr_handler #(parameter PTR_WIDTH=3) (
   input wrclk, wrst_n, wr_en,                //condition checked is wr_en not rd_en
   input [PTR_WIDTH:0] g_rptr_sync,
   output reg [PTR_WIDTH:0] b_wptr, g_wptr,
   output reg fifo_full
   );

   reg [PTR_WIDTH:0] b_wptr_next;
   reg [PTR_WIDTH:0] g_wptr_next;
   
   reg wrap_around;
   wire wfull;
  
   assign b_wptr_next = b_wptr+(wr_en & !fifo_full);
   assign g_wptr_next = (b_wptr_next >>1)^b_wptr_next;
  
   always@(posedge wrclk or negedge wrst_n) begin
     if(!wrst_n) begin
       b_wptr <= 0; // set default value  //Default Value shoud be 0 not 4
       g_wptr <= 0;							//Default Value shoud be 0 not 2
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

   assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_WIDTH:PTR_WIDTH-1], g_rptr_sync[PTR_WIDTH-2:0]});    //g_wptr_next should be compared instead of b_wptr_next 

 endmodule


module rptr_handler #(parameter PTR_WIDTH=3) (
    input rdclk, rrst_n, rd_en,   //rd_en should be ip not wr_en
    input [PTR_WIDTH:0] g_wptr_sync,
    output reg [PTR_WIDTH:0] b_rptr, g_rptr,
    output reg fifo_empty
    );

    reg [PTR_WIDTH:0] b_rptr_next;
    reg [PTR_WIDTH:0] g_rptr_next;

    assign b_rptr_next = b_rptr+(rd_en & !fifo_empty);   // condition checked is rd_en not wr_en
    assign g_rptr_next = (b_rptr_next >>1)^b_rptr_next;
    assign rempty = (g_wptr_sync == g_rptr_next);       //g_rptr_next should be compared instead of b_rptr_next
  
    always@(posedge rdclk or negedge rrst_n) begin
     if(!rrst_n) begin
       b_rptr <= 0;
       g_rptr <= 0;
     end
     else begin
       b_rptr <= b_rptr_next;
       g_rptr <= g_rptr_next;
     end
    end
  
    always@(posedge rdclk or negedge rrst_n) begin
      if(!rrst_n) fifo_empty <= 1;
     else        fifo_empty <= rempty;
    end
  endmodule

module synchronizer #(parameter WIDTH=3) (input clk, rst_n, [WIDTH:0] d_in, output reg [WIDTH:0] d_out);
   reg [WIDTH:0] q1;
   always@(posedge clk) begin
     if(!rst_n) begin
       q1 <= 0;
       d_out <= 0;
     end
     else begin
       q1 <= d_in;
       d_out <= q1;
     end
    end
 endmodule


module fifo_mem #(parameter FIFO_DEPTH=8, FIFO_WIDTH=64, PTR_WIDTH=3) ( //mismatching FIFO width was mentioned
   input wrclk, wr_en, rdclk, rd_en,
   input [PTR_WIDTH:0] b_wptr, b_rptr,
   input [FIFO_WIDTH-1:0] data_in,
   input fifo_full, fifo_empty,
   output reg [FIFO_WIDTH-1:0] data_out
   );
   reg [FIFO_WIDTH-1:0] fifo[0:FIFO_DEPTH-1];
  
   always@(posedge wrclk) begin
     if(wr_en & !fifo_full) begin                    //if(wr_en & fifo_empty) begin
       fifo[b_wptr[PTR_WIDTH-1:0]] <= data_in;
     end
   end
  
   
   always@(posedge rdclk) begin
     if(rd_en & !fifo_empty) begin                      
       data_out <= fifo[b_rptr[PTR_WIDTH-1:0]];
     end
    end
   
  // assign data_out = fifo[b_rptr[PTR_WIDTH-1:0]];
 endmodule


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
  reg [PTR_WIDTH:0] g_wptr, g_rptr;    //Comma present instead of semicolon

   //binary write and read pointer 
   reg [PTR_WIDTH:0] b_wptr, b_rptr;
  

  wire [PTR_WIDTH-1:0] waddr, raddr;//   Semicolon Missing

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
     //.wr_en		(wr_en),    wr_en isn't a port in write_handler
     //.rd_en(rd_en) ,     //This port was missing
     .wr_en		(wr_en),
					.g_rptr_sync	(g_rptr_sync),
					.b_wptr		(b_wptr),
					.g_wptr		(g_wptr),
					.fifo_full	(fifo_full)
				       );

   rptr_handler #(PTR_WIDTH) rdptr_h   (
					.rdclk		(rdclk), 
					.rrst_n		(rrst_n),
     //.rd_en		(rd_en),    this is not a valid port
     //.wr_en(wr_en),   //this port was missing
     .rd_en		(rd_en),
					.g_wptr_sync	(g_wptr_sync),
					.b_rptr		(b_rptr),
					.g_rptr		(g_rptr),
     .fifo_empty	(fifo_empty)    //Dot missing
				       );

  fifo_mem fifom		      (    //Module name was written incorrectly
    .wrclk		(wrclk),    //Dot missing 
					.wr_en		(wr_en),
				        .rdclk		(rdclk), 
					.rd_en		(rd_en),
					.b_wptr		(b_wptr), 
					.b_rptr		(b_rptr), 
					.data_in	(data_in),
					.fifo_full	(fifo_full),
					.fifo_empty	(fifo_empty), 
    .data_out	(data_out)     //Extra Comma was there
				       );

 endmodule