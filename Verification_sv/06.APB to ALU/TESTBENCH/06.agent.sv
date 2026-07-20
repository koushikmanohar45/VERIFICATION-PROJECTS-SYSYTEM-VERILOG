`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class agent;
  
  mailbox #(transaction) gen_dri;
  mailbox #(transaction) mon_scb;
  mailbox #(transaction) mon_cov;
  
  event ev;
   
  generator g;
  driver d;
  monitor m;
  
  virtual atoa.m_dr vif1;
  virtual atoa.m_mon vif2;
  
  function new(mailbox #(transaction) mon_scb,mailbox #(transaction) mon_cov,virtual atoa vif1,virtual atoa vif2);
    this.mon_scb=mon_scb;
    this.mon_cov=mon_cov;
    this.vif1=vif1;
    this.vif2=vif2;
    
    gen_dri=new();
    
    g=new(gen_dri,ev);
    d=new(gen_dri,ev,vif1);
    m=new(mon_scb,mon_cov,vif2);
    
  endfunction
  
  task a_run;
    begin
      fork
       d.d_run();
       g.g_run();
       m.m_run();
      join
    end
  endtask
  
endclass
  
