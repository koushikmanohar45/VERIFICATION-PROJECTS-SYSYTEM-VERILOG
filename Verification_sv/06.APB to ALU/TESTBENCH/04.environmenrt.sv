`include "transaction.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "coverage.sv"


class environment #(parameter N=32,A=16);
  
  mailbox #(transaction) mon_scb;
  mailbox #(transaction) mon_cov;
  
  agent a;
  scoreboard s;
  coverage c;
  
  real per;
  
  function new(virtual atoa vif1,virtual atoa vif2);
    
    mon_scb=new();
    mon_cov=new();
    
    a=new(mon_scb,mon_cov,vif1,vif2);
    s=new(mon_scb);
    c=new(mon_cov);
    
  endfunction
  
  task e_run;
    begin
     fork
      a.a_run();
      s.s_run();
      c.c_run();
     join_none
      #900000;
      per=(s.pass*100)/s.total;
          
      $display("#####################################################");
      $display("#     TOTAL NO OF TEST_CASES=%0d                    #",s.total);
      $display("#     PASSED=%0d                                    #",s.pass);
      $display("#     FAILED=%0d                                      #",s.fail);
      $display("#     SUCCESS RATE=%0f                       #",per);
      $display("#####################################################");
      #1;
      $stop;
    end
    
  endtask
endclass
