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
      @(posedge fifo_vif.wrclk);
      //wait(vif.wr_en);
      trans.wr_en   <= vif.wr_en;
      trans.data_in   <= vif.data_in;
      @(posedge fifo_vif.wrclk);
      trans.fifo_full   = vif.fifo_full;
      
      @(posedge fifo_vif.rdclk);
      //wait(vif.rd_en);
      trans.rd_en   <= vif.rd_en;
      
      @(posedge fifo_vif.rdclk);
      trans.fifo_empty   <= vif.fifo_empty;
      trans.data_out   <= vif.data_out;
      
      
      @(posedge vif.wrclk or posedge vif.rdclk);
      mon2scb.put(trans);
      trans.display("[ Monitor ]");
      
      
      
    end
  endtask

  
endclass