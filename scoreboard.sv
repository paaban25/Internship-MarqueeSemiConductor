class scoreboard;
  
  localparam int FIFO_WIDTH = 64;
  localparam int FIFO_DEPTH = 8;
  mailbox mon2scb;
  mailbox driv2scb;
  transaction trans;
  transaction trans_ref;
  
  bit [FIFO_WIDTH-1:0] memory[$];
  bit [FIFO_WIDTH-1:0] temp;
  
  
  
  int no_transactions;
  
  function new(mailbox mon2scb,mailbox driv2scb);
    
    this.mon2scb = mon2scb;
    this.driv2scb = driv2scb;
  endfunction
  
  task compare();
    if(trans_ref.wr_en ) begin
      if(memory.size()==FIFO_DEPTH) 
        $display("FIFO is Full");
      else memory.push_front(trans_ref.data_in);
    end
    else if(trans_ref.rd_en) begin 
      
      if(memory.size()==0) 
        $display("FIFO is Empty");
      else 
        begin
          temp=memory.pop_back();
          if(temp==trans.data_out)
            $display("Correct Data is Read");
          else $display("Data Read is Wrong");
        end
    end
  endtask
  

  task main;
    
//     forever begin
//       mon2scb.get(trans);
//       $display("Scoreboard Received Data from mon2scb");
//       if(1'b1/* Expected Result is correct logic */)
//           $display("Result is as Expected");
//         else
//           $display("Result is as Wrong");
//           $error("Wrong Result.\n\tExpeced: %0d Actual: %0d");
//         no_transactions++;
//       $display("[ Scoreboard ]");
//       trans.display();
//     end
    
    forever begin
      
      trans=new();
      trans_ref=new();
      mon2scb.get(trans);
      driv2scb.get(trans_ref);
      compare();
      
      
    end
  endtask
  
endclass