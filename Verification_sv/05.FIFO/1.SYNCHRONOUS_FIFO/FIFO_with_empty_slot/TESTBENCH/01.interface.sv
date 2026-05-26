interface fifo(input clk);
  
  logic rst;
  logic [7:0] data_in;
  logic rd_en;
  logic wt_en;
  logic [7:0] data_out;
  logic full;
  logic empty;
  
  clocking drv @(posedge clk);
    default input #1 output #0;
    input data_out,full,empty;
    output data_in,rd_en,wt_en,rst;
  endclocking
  
  clocking mon @(posedge clk);
    default input #0 output #0;
    input data_out,data_in,rd_en,wt_en,rst,full,empty;
  endclocking
  
  modport mtr(input clk,clocking mon);
    
  modport dr(input clk,clocking drv);
  
endinterface
