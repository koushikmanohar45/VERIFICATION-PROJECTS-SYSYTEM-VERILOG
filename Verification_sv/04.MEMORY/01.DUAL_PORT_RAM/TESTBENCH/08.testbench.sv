`include "transaction.sv"
`include "interface.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"

module testbench();
  
  logic clk=0;
  
  always #5 clk=~clk;
  
  ram_itf itf(clk);
  
  dual_port_ram dut
  (
    .clk(clk),
    .data1(itf.data1),
    .data2(itf.data2),
    .addr1(itf.addr1),
    .addr2(itf.addr2),
    .w_e1(itf.w_e1),
    .w_e2(itf.w_e2),
    .q1(itf.data_out1),
    .q2(itf.data_out2)
  );
  
  environment e;
  
  initial begin 
    $dumpfile("v.vcd");
    $dumpvars(0,testbench);
    $display("==============================================================================================================================================================================================================================");
    $display("                      VERIFICATION JHONSON COUNTER IN SV                   ");
    $display("==============================================================================================================================================================================================================================");
   
    e=new(itf,itf);
    e.run();
  end
endmodule
