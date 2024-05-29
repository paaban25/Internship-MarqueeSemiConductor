class driver;
  
   int no_transactions;
  
  virtual fifo_intf vif;
  
  mailbox gen2driv;
  
  function new(virtual fifo_intf vif,mailbox gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
  endfunction
  
  
  task reset;
    wait(vif.reset);
    $display("[ DRIVER ] ----- Reset Started -----");
    vif.wr_en<=1'b0;
    vif.rd_en<=1'b0;
    vif.data_in<=64'b0;
    wait(!vif.reset);
    $display("[ DRIVER ] ----- Reset Ended   -----");
    
  endtask
  
  
  task main;
    forever begin
      transaction trans;
      gen2driv.get(trans);
      @(posedge vif.wrclk);
      vif.wr_en<=trans.wr_en;
      vif.data_in<=trans.data_in;
      @(posedge vif.wrclk);

      trans.fifo_full<= vif.fifo_full;

      
      
      @(posedge vif.rdclk);
      vif.rd_en<=trans.rd_en;
      
      @(posedge vif.rdclk);
      trans.data_out<=vif.data_out;
      trans.fifo_empty<= vif.fifo_empty;
      
      @(posedge vif.rdclk or posedge vif.wrclk);
      trans.display("[ Driver ]");
      no_transactions++;
    end
  endtask


  
endclass
