`include "environment.sv"
program test(fifo_intf vif);
  
  environment env;
  
  initial begin
    env = new(vif);
    
    env.gen.repeat_count = 10;
    
    env.run();
    
  end
endprogram