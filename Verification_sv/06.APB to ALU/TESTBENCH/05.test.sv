`include "environment.sv"
class test;
  
  environment e;
   
  function new(virtual atoa vif1,virtual atoa vif2);
    e=new(vif1,vif2);
  endfunction
  
  task t_run();
    e.e_run();
  endtask
  
endclass  
