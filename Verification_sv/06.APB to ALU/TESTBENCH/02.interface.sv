interface atoa #(parameter N=32,A=16) (input PCLK);
  
    logic PRESETn;
    logic signed [N-1:0] PWDATA; 
    logic [A-1:0]PADDR;
    logic transfer;
    logic PWRITE;
    logic signed [N-1:0]PRDATA;
    logic PSLVERR;
    logic [7:0]PSEL;
    logic PENABLE;
  
  
  clocking cb_dr @(negedge PCLK);
    
    default input #1 output #0;
    
    input PENABLE;
    input PSLVERR;
    input PRDATA;
    input PSEL;
    output PWDATA;
    output PADDR;
    output PWRITE;
    output transfer;
  endclocking
  
  
  
  clocking cb_mon @(posedge PCLK);
    default input #1 output #0;
    
    input PENABLE;
    input PSLVERR;
    input #0 PRDATA;
    input PSEL;
    input PWDATA;
    input PADDR;
    input PWRITE;
    input transfer;
    
  endclocking
  
  
  modport m_dr(input PCLK,output PRESETn,clocking cb_dr);
  modport m_mon(input PCLK,PRESETn,clocking cb_mon);
    
endinterface
    
    
