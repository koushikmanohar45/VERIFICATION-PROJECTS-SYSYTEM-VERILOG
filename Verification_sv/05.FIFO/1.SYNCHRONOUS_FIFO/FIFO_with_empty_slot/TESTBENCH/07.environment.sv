class environment;
  
  mailbox #(transaction) gen_dri;
  mailbox #(transaction) mon_scb;
  
  virtual fifo.dr vif;
  virtual fifo.mtr vif1;
  
  generator g;
  driver d;
  monitor m;
  scoreboard s;
  
  event done;
  
  real per;

  function new(virtual fifo.dr vif,virtual fifo.mtr vif1);
    
    this.vif1=vif1;
    this.vif=vif;
    
    gen_dri=new();
    mon_scb=new();
    
    g=new(gen_dri,done);
    d=new(gen_dri,vif,done);
    m=new(mon_scb,vif1);
    s=new(mon_scb);
    
  endfunction
  
  task e_run();
    begin
      forever begin
        fork
            g.gen();
            d.d_run();
            m.m_run();
            s.s_run();
        join_any
        
        disable fork;
          
          per=(s.pass/s.total)*100;
          
          $display("#####################################################");
          $display("#     TOTAL NO OF TEST_CASES=%0d                    #",s.total);
          $display("#     PASSED=%0d                                    #",s.pass);
          $display("#     FAILED=%0d                                      #",s.fail);
          $display("#     SUCCESS RATE=%0f                       #",per);
          $display("#####################################################");
          #1;
          $finish;
      end
    end
  endtask
  
endclass
