class monitor;
  
  virtual fifo_intf fifo_vif;
  
  mailbox mon2scb;
  
  function new(virtual fifo_intf fifo_vif,mailbox mon2scb);
    this.fifo_vif = fifo_vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task main;
    forever begin
      transaction trans;
      trans = new();

      
      @(posedge fifo_vif.rdclk);
      trans.fifo_empty   <= fifo_vif.fifo_empty;
      trans.data_out   <= fifo_vif.data_out;
      
      @(posedge fifo_vif.wrclk);
      trans.fifo_full   <= fifo_vif.fifo_full;

      
      
      @(posedge fifo_vif.wrclk or posedge fifo_vif.rdclk);
      mon2scb.put(trans);
      //$display("Monitor");
      //trans.display();
      
      
      
      
    end
  endtask

  
endclass