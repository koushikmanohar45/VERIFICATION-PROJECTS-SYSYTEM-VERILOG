class r_driver;
  
  r_transaction t;
  virtual fifo.r_dr vif;
  mailbox #(r_transaction) from_gen;
  event done;
  
  function new(mailbox #(r_transaction) from_gen,virtual fifo.r_dr vif,event done);
    
    this.from_gen=from_gen;
    this.vif=vif;
    this.done=done;
    
  endfunction
  
  task d_rn;
    begin
      forever begin 
        t=new();
        from_gen.get(t);
        @(vif.r_cb_drv);
        
          vif.r_cb_drv.r_en<=t.r_en;
        $display("[time=%0t] DRIVER[READ]  : r_reset=%b | read_enable=%b  ",$time, t.r_rst,t.r_en);
        ->done;
      end
    end
  endtask
  
  task rst_synchronize();
    repeat(5)begin
          vif.r_rst<=1;
          #19;
          vif.r_rst<=0;
          #1000;
    end
  endtask
  
endclass
