class scoreboard;
  
  mailbox mon2scb;
  mailbox driv2scb;
  transaction trans;
  transaction trans_ref;
  int no_transactions;
  
  function new(mailbox mon2scb,mailbox driv2scb);
    
    this.mon2scb = mon2scb;
    this.driv2scb = driv2scb;
  endfunction
  

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
      driv2scb.get(trans);
      
      
    end
  endtask
  
endclass