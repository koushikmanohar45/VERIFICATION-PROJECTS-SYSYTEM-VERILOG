class monitor;
  transaction t;
  
  mailbox #(transaction) to_scb;
  mailbox #(transaction) to_cov;
  
  virtual atoa.m_mon vif2;
  
  function new(mailbox #(transaction) to_scb,mailbox #(transaction) to_cov,virtual atoa.m_mon vif2);
    this.to_scb=to_scb;
    this.to_cov=to_cov;
    this.vif2=vif2;
  endfunction
  
  task m_run();
    begin
      forever begin
        t=new();
      
        @(vif2.cb_mon);
        t.PRESETn=vif2.PRESETn;
        t.PWDATA=vif2.cb_mon.PWDATA;
        t.PADDR=vif2.cb_mon.PADDR;
        t.PRDATA=vif2.cb_mon.PRDATA;
        t.PWRITE=vif2.cb_mon.PWRITE;
        t.PENABLE=vif2.cb_mon.PENABLE;
        t.PSEL=vif2.cb_mon.PSEL;
        t.PSLVERR=vif2.cb_mon.PSLVERR;
        t.transfer=vif2.cb_mon.transfer;
        to_cov.put(t);
        
        t=new();
        @(vif2.cb_mon);
        t.PRESETn=vif2.PRESETn;
        t.PWDATA=vif2.cb_mon.PWDATA;
        t.PADDR=vif2.cb_mon.PADDR;
        t.PRDATA=vif2.cb_mon.PRDATA;
        t.PWRITE=vif2.cb_mon.PWRITE;
        t.PENABLE=vif2.cb_mon.PENABLE;
        t.PSEL=vif2.cb_mon.PSEL;
        t.PSLVERR=vif2.cb_mon.PSLVERR;
        t.transfer=vif2.cb_mon.transfer;
        to_cov.put(t);
      
        t=new();
        @(vif2.cb_mon);
        t.PRESETn=vif2.PRESETn;
        t.PWDATA=vif2.cb_mon.PWDATA;
        t.PADDR=vif2.cb_mon.PADDR;
        t.PRDATA=vif2.cb_mon.PRDATA;
        t.PWRITE=vif2.cb_mon.PWRITE;
        t.PENABLE=vif2.cb_mon.PENABLE;
        t.PSEL=vif2.cb_mon.PSEL;
        t.PSLVERR=vif2.cb_mon.PSLVERR;
        t.transfer=vif2.cb_mon.transfer;
        //$display("[time=%0t]PRDATA=%0D",$time,t.PRDATA);
       // t.display("MONITOR");
        to_scb.put(t);
        to_cov.put(t);
      end
    end
  endtask
  
endclass
