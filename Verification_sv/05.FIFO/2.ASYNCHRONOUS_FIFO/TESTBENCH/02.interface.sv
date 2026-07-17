interface fifo #(parameter depth=16,width=8 ) (input r_clk,input w_clk) ;  
  
  logic r_rst;
  logic w_rst; 
  logic [width-1:0] data_in;
  logic r_en;
  logic w_en;
  logic [width-1:0] data_out;
  logic full;
  logic empty;
  logic [$clog2(depth):0] w_ptr;
  logic [$clog2(depth):0] r_ptr;
  
  clocking r_cb_drv @(negedge r_clk);
    default input #1 output #0;
    input data_out,empty,r_ptr;
    output r_en;
  endclocking
  
  clocking w_cb_drv @(negedge w_clk );
    default input #1 output #0;
    input full,w_ptr;
    output data_in,w_en;
  endclocking
  
  clocking w_cb_mon @(posedge w_clk);
    default input #1 output #0;
    input data_in,w_en,w_ptr;
    input #0 full;
  endclocking
  
  clocking r_cb_mon @(posedge r_clk);
    default input #1 output #0;
    input data_out,r_en,r_ptr;
    input #1 empty;
  endclocking
  
  modport w_mtr(input w_clk,w_rst,clocking w_cb_mon);
  modport r_mtr(input r_clk,r_rst,clocking r_cb_mon); 
  modport w_dr(input w_clk,output w_rst,clocking w_cb_drv);
  modport r_dr(input r_clk,output r_rst,clocking r_cb_drv);
  
endinterface
