class w_driver;
  
  w_transaction t;
  virtual fifo.w_dr vif;
  mailbox #(w_transaction) from_gen;
  event done;

  
  function new(mailbox #(w_transaction) from_gen,virtual fifo.w_dr vif,event done);
    
    this.from_gen=from_gen;
    this.vif=vif;
    this.done=done;
    
  endfunction
  
  task d_run();
    begin
      forever begin 
        t=new();
        from_gen.get(t);
        @(vif.w_cb_drv);
          vif.w_cb_drv.data_in<=t.data_in;
          vif.w_cb_drv.w_en<=t.w_en;
        $display("[time=%0t] DRIVER [WRITE]: w_reset=%b | write_enable=%b | data_in =%d | ",$time, t.w_rst,t.w_en,t.data_in);
        ->done;
      end
    end
  endtask
  
  task rst_synchronize();
    repeat(5)begin
          vif.w_rst<=1;
          #20;
          vif.w_rst<=0;
          #1000;
    end
  endtask
  
endclass
