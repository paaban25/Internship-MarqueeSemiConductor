class scoreboard;
  
  mailbox mon2scb;
  int no_transactions;
  
  function new(mailbox mon2scb);
    
    this.mon2scb = mon2scb;
  endfunction
  

  task main;
    transaction trans;
    forever begin
      mon2scb.get(trans);
      $display("Scoreboard Received Data from mon2scb");
      //if(1'b1/* Expected Result is correct logic */)
          //$display("Result is as Expected");
        //else
          //$display("Result is as Wrong");
          //$error("Wrong Result.\n\tExpeced: %0d Actual: %0d");
        no_transactions++;
//       $display("[ Scoreboard ]");
      trans.display();
    end
  endtask
  
endclass