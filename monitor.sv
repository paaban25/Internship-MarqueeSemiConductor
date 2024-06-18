class monitor;
  
  virtual fifo_intf vif;
  
  mailbox mon2scb;
  
  function new(virtual fifo_intf vif,mailbox mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task main;
    forever begin
      transaction trans;
      trans = new();

      
      @(posedge vif.rdclk);
      trans.fifo_empty   <= vif.fifo_empty;
      trans.data_out   <= vif.data_out;
      
//       $display("fifo_empty and data_out signal from interface to monitor");
      
      //@(posedge vif.wrclk);
      trans.fifo_full   <= vif.fifo_full;
//       $display("fifo_full signal from interface to monitor");

      
      
      //@(posedge fifo_vif.wrclk or posedge fifo_vif.rdclk);
      mon2scb.put(trans);
//       $display("Monitor put the received data into mon2scb");
//       $display("Monitor");
      trans.display();
      
      
      
      
    end
  endtask

  
endclass