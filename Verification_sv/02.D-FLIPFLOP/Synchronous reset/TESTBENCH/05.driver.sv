class driver;
  transaction t;
  mailbox #(transaction) from_gen;
  event done;
  
  virtual dff_itf.drive vif;
  
  function new(mailbox #(transaction) from_gen,virtual dff_itf.drive vif,event done);
    this.from_gen=from_gen;
    this.vif=vif;
    this.done=done;
  endfunction
  
  task driv();
    begin
      forever begin
        t=new();
        from_gen.get(t);
        
        @(vif.drv_clk);
        
        vif.drv_clk.rst<=t.rst;
        vif.drv_clk.d<=t.d;
        
        $display("          DRIVER: rst=%b d=%b", t.rst, t.d);
        ->done;
      end
    end
  endtask
  
endclass
