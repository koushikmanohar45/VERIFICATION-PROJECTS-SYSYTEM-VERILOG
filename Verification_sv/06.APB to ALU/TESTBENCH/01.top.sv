`include "interface.sv"
`include "test.sv"

module top #(parameter N=32,A=16);
  
  reg PCLK=0;
  
  always #5 PCLK=~PCLK;
  
  atoa itf(PCLK);

  apb #(.N(N),.A(A)) dut(.PCLK(PCLK),.PRESETn(itf.PRESETn),.PWDATA(itf.PWDATA),.PADDR(itf.PADDR),.transfer(itf.transfer),.PWRITE(itf.PWRITE),.PRDATA(itf.PRDATA),.PSLVERR(itf.PSLVERR),.PSEL(itf.PSEL),.PENABLE(itf.PENABLE));

  test t;
  
  initial begin
    $dumpfile("V.vcd");
    $dumpvars(0,top);
    $display("==================================================================================================");
    $display("                            APB TO ALU VERIFICATION  IN SV TESTBENCH                              ");
    $display("==================================================================================================");
   fork 
    begin:block_a
      itf.PRESETn=0;
      #10;
      itf.PRESETn=1;
    end:block_a
    
    begin:block_b
      t=new(itf,itf);
      t.t_run();
    end:block_b
   join
    
  end
      
endmodule
