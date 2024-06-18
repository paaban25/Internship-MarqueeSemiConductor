`include "environment.sv"

program test(fifo_intf intf);
  
  class write_trans extends transaction;
    
    
    function void pre_randomize();
      wr_en.rand_mode(0);
      rd_en.rand_mode(0);
      this.wr_en=1'b1;
      this.rd_en=1'b0;
      $display("pre-randomise function executed");
    endfunction
    
  endclass
  
  environment env;
  write_trans wr_tr;
  
  initial begin
    
    env=new(intf);
    wr_tr=new();
//    wr_tr.pre_randomize();
    env.gen.repeat_count=2;
    env.gen.trans=wr_tr;
    
    env.run();
    
  end
  
endprogram
  
  
  