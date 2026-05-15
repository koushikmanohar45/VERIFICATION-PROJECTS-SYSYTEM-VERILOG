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
        
        vif.drv_clk.d<=t.d;
        
        $display("          Time=[%0t] DRIVER:  d=%b",$time,t.d);
        ->done;
      end
    end
  endtask
  
  task reset();

   forever 
     begin
      #($urandom_range(10,40));
        vif.rst<=1;
      #($urandom_range(2,8));
        vif.rst<=0;
   end
endtask
  
  
  task run();

   fork
      reset();
      driv();
   join

endtask
  
endclass
