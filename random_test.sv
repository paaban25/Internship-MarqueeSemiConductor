`include "environment.sv"
program test(fifo_intf intf);
  
  environment env;
  
  initial begin
    env = new(intf);
    
    env.gen.repeat_count = 20;
    
    env.run();
    
  end
endprogram