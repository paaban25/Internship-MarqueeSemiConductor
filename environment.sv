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
  
  event gen_ended;
  
  virtual fifo_intf fifo_vif;
  
  function new(virtual fifo_intf fifo_vif);
    this.fifo_vif = fifo_vif;
    
    gen2driv = new();
    mon2scb  = new();
    
    gen = new(gen2driv,gen_ended);
    driv = new(fifo_vif,gen2driv);
    mon  = new(fifo_vif,mon2scb);
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
    wait(gen_ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
  endtask 
  
  
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
  
endclass