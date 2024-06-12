`include "environment.sv"
program test(fifo_intf vif);
  
  environment env;
  
  initial begin
    env = new(vif);
    
    env.gen.repeat_count = 3;
    
    env.run();
    
  end
endprogram