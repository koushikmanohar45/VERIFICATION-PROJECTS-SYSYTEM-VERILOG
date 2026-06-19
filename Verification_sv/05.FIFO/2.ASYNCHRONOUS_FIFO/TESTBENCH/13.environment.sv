`include "w_agent.sv"
`include "r_agent.sv"

class environment;
  
  mailbox #(w_transaction) w_mon_scb;
  mailbox #(r_transaction) r_mon_scb;
  
  virtual fifo.w_dr vif;
  virtual fifo.w_mtr vif1;
  
  virtual fifo.r_dr vif2;
  virtual fifo.r_mtr vif3;
  
  w_agent a1;
  r_agent a2;
  scoreboard s;

  
  real per;

  function new(virtual fifo.w_dr vif,virtual fifo.w_mtr vif1,virtual fifo.r_dr vif2,virtual fifo.r_mtr vif3);
    
    this.vif1=vif1;
    this.vif=vif;
    this.vif2=vif2;
    this.vif3=vif3;
    
    w_mon_scb=new();
    r_mon_scb=new();
    
    a1=new(w_mon_scb,vif,vif1);
    a2=new(r_mon_scb,vif2,vif3);
    s=new(w_mon_scb,r_mon_scb);
    
  endfunction
  
  task e_run();
    begin
        fork
          a1.a1_run();
          a2.a2_run();
          s.s_run();
        join_none
          #1800;
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
  endtask
  
endclass
