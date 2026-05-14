class environment;

  generator g;
  driver d;
  monitor m;
  scoreboard s;
  event done;

  mailbox #(transaction) gen_drv;
  mailbox #(transaction) mon_scb;

  virtual dff_itf.drive vif;
  virtual dff_itf.mon vif1;

  function new(virtual dff_itf.drive vif,virtual dff_itf.mon vif1);

    this.vif = vif;
    this.vif1=vif1;

    gen_drv=new();
    mon_scb=new();

    g=new(gen_drv,done);
    d=new(gen_drv, vif,done);
    m=new(mon_scb, vif1);
    s=new(mon_scb);

  endfunction

  task run();
    
    fork
      g.gen();
      d.driv();
      m.mtr();
      s.sb();
    join_none

  endtask

endclass
