class transaction;
  
  rand logic [15:0] data1;
  rand logic [15:0] data2;
  rand logic [13:0] addr1;
  rand logic [13:0] addr2;
  rand logic w_e1;
  rand logic w_e2;
  logic [15:0]data_out1;
  logic [15:0]data_out2;
  
  constraint c1  {
                   data1>0;
                   data2>0;
                   addr2 !=addr1;
                 }
  
  constraint c2  {
                    addr1 inside {[1:50]};
                    addr2 inside {[1:50]};
                 }
  
  constraint c3  {
                   w_e1 dist {1:=10,0:=10};
                   w_e2 dist {1:=10,0:=10};
                 }

endclass
