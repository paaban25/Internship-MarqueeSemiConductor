`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;

  generator gen;
  driver    driv;
  monitor mon;
  scoreboard scb;
  
  mailbox gen2driv;
  mailbox mon2scb;
  
  event ended;
  
  virtual fifo_intf vif;
  
  function new(virtual fifo_intf vif);
    this.vif = vif;
    
    gen2driv = new();
    mon2scb  = new();
    
    gen = new(gen2driv,ended);
    driv = new(vif,gen2driv);
    mon  = new(vif,mon2scb);
    scb  = new(mon2scb);
    
  endfunction
  
    task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
      gen.main();
      driv.main();
      mon.main();
      scb.main();
    join_any
  endtask
  
  task post_test();
    wait(ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
  endtask 
  
  
  task run;
    //pre_test();
    test();
    post_test();
    $finish;
  endtask
  
  
endclass