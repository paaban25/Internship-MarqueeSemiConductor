class generator;
  rand transaction trans;
  mailbox gen2driv;  
  int repeat_count;  
  event ended, next;  
  
  function new(mailbox gen2driv, event ended, next);
    this.gen2driv = gen2driv;
    this.ended = ended;
    this.next = next;
  endfunction
  
  task main();
    repeat (repeat_count) begin
      trans = new();
      if (!trans.randomize()) $fatal("Gen:: trans randomization failed"); 
      gen2driv.put(trans);
      $display("Generated Signal put into mailbox gen2driv");
      trans.display();
//       @(next.triggered);
    end
    -> ended;
  endtask

endclass