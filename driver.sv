class driver;
  
   int no_transactions;
  
  virtual fifo_intf vif;
  
  mailbox gen2driv;
  mailbox driv2scb;
  
  event next;
  
  function new(virtual fifo_intf vif,mailbox gen2driv,mailbox driv2scb, event next);
    this.vif = vif;
    this.gen2driv = gen2driv;
    this.driv2scb=driv2scb;
    this.next = next;
  endfunction
  
  
  task reset();
    vif.data_in=64'h0;
//     vif.data_out=64'h1234567890abcdef;
    vif.fifo_full=1'b0;
    vif.fifo_empty=1'b0;
//     vif.wr_en=1'b0;
//     vif.rd_en=1'b0;
  endtask
  
transaction trans = new();
  
  
  task main;
    forever begin
      
      gen2driv.get(trans);
      driv2scb.put(trans);
//       $display("Driver got generated data from gen2driv");
//       gen2driv.get(trans);
      @(posedge vif.wrclk iff !vif.fifo_full);
      vif.rd_en<=trans.rd_en;
//       $display("rd_en signal from driver to interface");
      //@(posedge vif.wrclk);
      vif.wr_en<=trans.wr_en;
      vif.data_in<=trans.data_in;
//       $display("wr_en and data_in signal from driver to interface");
      no_transactions++;
//       -> next;
      //vif.wrst_n<=trans.wrst_n;
      
      //@(posedge vif.wrclk);
      //trans.fifo_full<= vif.fifo_full;
      
//       $display("Driver");
      trans.display();
      
    end
  endtask


  
endclass