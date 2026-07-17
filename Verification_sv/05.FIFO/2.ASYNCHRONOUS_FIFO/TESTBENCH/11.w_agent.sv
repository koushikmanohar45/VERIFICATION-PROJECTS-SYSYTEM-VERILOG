class w_agent;
  
  mailbox #(w_transaction) w_gen_dri;
  mailbox #(w_transaction) w_mon_scb;
  mailbox #(w_transaction) w_mon_cov;
  
   w_generator g;
   w_driver d;
   w_monitor m;
  
  event done;
  
  virtual fifo.w_dr vif;
  virtual fifo.w_mtr vif1;
  
  function new(mailbox #(w_transaction) w_mon_scb,mailbox #(w_transaction) w_mon_cov,virtual fifo.w_dr vif,virtual fifo.w_mtr vif1);
    
    this.w_mon_scb=w_mon_scb;
    this.w_mon_cov=w_mon_cov;
    this.vif=vif;
    this.vif1=vif1;
    
    w_gen_dri=new();
    
    g=new(this.w_gen_dri,done);
    d=new(this.w_gen_dri,vif,done);
    m=new(w_mon_scb,w_mon_cov,vif1);
    
  endfunction
  
  
  task a1_run();
    begin
        fork
          g.g_gen();
          d.d_run();
          d.rst_synchronize();
          m.m_run();
        join_none
    end
  endtask

  
endclass
