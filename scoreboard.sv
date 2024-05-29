class scoreboard;
  
  mailbox mon2scb;
  int no_transactions;
  
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
    //Compares the Actual result with the expected result
  task main;
    transaction trans;
    forever begin
      mon2scb.get(trans);
      if(/* Expected Result is correct logic */)
          $display("Result is as Expected");
        else
          $error("Wrong Result.\n\tExpeced: %0d Actual: %0d");
        no_transactions++;
      trans.display("[ Scoreboard ]");
    end
  endtask
  
endclass