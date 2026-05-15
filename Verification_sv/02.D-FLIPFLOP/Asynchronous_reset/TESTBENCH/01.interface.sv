interface dff_itf(input clk);
  
  logic rst;
  logic d;
  logic q;
  
  clocking drv_clk @(posedge  clk);
    default input #0 output #0;
    input q;
    output d; 
  endclocking
  
  clocking mon_clk @(posedge clk);
    default input #0 output #0;
    input q,d;
  endclocking

  modport drive(input clk,output rst,clocking drv_clk);
  modport mon(input clk,input rst,d,q,clocking mon_clk);
  
endinterface
