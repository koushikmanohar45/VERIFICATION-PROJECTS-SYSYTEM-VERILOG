`include "transaction.sv"
`include "interface.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"

module testbench();
  
  reg clk=0;
  always #5 clk=~clk;
     
  fifo itf(clk);
  sync_fifo dut(.clk(clk),.rst(itf.rst),.data_in(itf.data_in),.rd_en(itf.rd_en),.wt_en(itf.wt_en),.data_out(itf.data_out),.full(itf.full),.empty(itf.empty));
  
  environment e;

  initial begin
    $dumpfile("v.vcd");
    $dumpvars(0,testbench);
    $display("===========================================================================");
    $display("                         SYNCHRONOUS FIFO IN SV                   ");
    $display("===========================================================================");
    itf.rst=1;
    #10;
    e=new(itf,itf);
    e.e_run();
   end

endmodule
