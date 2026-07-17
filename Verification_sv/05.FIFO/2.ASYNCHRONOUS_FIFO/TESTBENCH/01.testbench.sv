`include "w_transaction.sv"
`include "r_transaction.sv"
`include "interface.sv"
`include "w_generator.sv"
`include "w_driver.sv"
`include "w_monitor.sv"
`include "r_generator.sv"
`include "r_driver.sv"
`include "r_monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"
`include "environment.sv"


module testbench #(parameter depth=16,width=8);
  
  parameter READ_CLK_PERIOD=10,WRITE_CLK_PERIOD=20;
  
  reg w_clk=0;
  always #(WRITE_CLK_PERIOD/2) w_clk=~w_clk;
  
  reg r_clk=0;
  always #(READ_CLK_PERIOD/2) r_clk=~r_clk;
  
    
  fifo itf(r_clk,w_clk);
  asynchronus_fifo #(.width(width),.depth(depth))dut(.w_clk(w_clk),.r_clk(r_clk),.w_rst(itf.w_rst),.r_rst(itf.r_rst),.data_in(itf.data_in),.r_en(itf.r_en),.w_en(itf.w_en),.data_out(itf.data_out),.full(itf.full),.empty(itf.empty),.b_wptr(itf.w_ptr),.b_rptr(itf.r_ptr));
  
  environment e;
 
  initial begin
    $dumpfile("v.vcd");
    $dumpvars(0,testbench);
    $display("=====================================================================================");
    $display("                     ASYNCHRONOUS FIFO VERIFICATION IN SV                   ");
    $display("=====================================================================================");
    itf.r_rst=1;
    itf.w_rst=1;
    #15;
    e=new(itf,itf,itf,itf);
    e.e_run();
   end
  
endmodule
