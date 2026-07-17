class r_agent;
  
  mailbox #(r_transaction) r_gen_dri;
  mailbox #(r_transaction) r_mon_scb;
  mailbox #(r_transaction) r_mon_cov;
  
   r_generator g;
   r_driver d;
   r_monitor m;
  
  event done;
  
  virtual fifo.r_dr vif;
  virtual fifo.r_mtr vif1;
  
  function new(mailbox #(r_transaction) r_mon_scb,mailbox #(r_transaction) r_mon_cov,virtual fifo.r_dr vif,virtual fifo.r_mtr vif1);
    
    this.r_mon_scb=r_mon_scb;
    this.r_mon_cov=r_mon_cov;
    this.vif=vif;
    this.vif1=vif1;

    r_gen_dri=new();
    
    g=new(r_gen_dri,done);
    d=new(r_gen_dri,vif,done);
    m=new(r_mon_scb,r_mon_cov,vif1);
    
  endfunction
  
  
  task a2_run();
    begin
        fork
          g.g_gn();
          d.d_rn();
          d.rst_synchronize();
          m.m_rn();
        join_none
    end
  endtask

  
endclass
