class driver;
  
  transaction t;
  
  mailbox #(transaction) from_gen;
  
  event ev;
  virtual atoa.m_dr vif1;
  
  function new(mailbox #(transaction) from_gen,event ev,virtual atoa.m_dr vif1);
    this.from_gen=from_gen;
    this.vif1=vif1;
    this.ev=ev;
  endfunction
  
  task d_run();
    begin
      forever begin
        t=new();
        from_gen.get(t);
        @(vif1.cb_dr);
        //t.display("DRIVER");
        vif1.cb_dr.PWDATA<=t.PWDATA;
        vif1.cb_dr.PADDR<=t.PADDR;
        vif1.cb_dr.transfer<=t.transfer;
        vif1.cb_dr.PWRITE<=t.PWRITE;
        @(vif1.cb_dr);
        @(vif1.cb_dr);
        ->ev;
      end
    end
  endtask
  
endclass
