class coverage #(parameter N=32,A=16);
  transaction t;
  
  bit signed [15:0] x;
  bit signed [15:0] y;
  
  mailbox #(transaction) from_mon;
  
  covergroup cov_apbtoalu;
    
    RESET:coverpoint t.PRESETn;
    
    OPERAND_A:coverpoint x { 
                             bins neg={[-255:-1]};
                             bins pos={[0:255]};
                           }
    
    OPERAND_B:coverpoint y { 
                             bins neg={[-255:-1]};                                                                   
                             bins pos={[0:255]};
                           }
    
    OPERAND_AXB:cross OPERAND_A,OPERAND_B;
    
    OPCODE:coverpoint t.PWDATA iff(t.PADDR[A-5:0]==8){ bins b[]={[0:15]};}
    
    OUTPUT:coverpoint t.PRDATA iff(t.PADDR[A-5:0]==16){ bins neg={[-255:-1]};
                                                 bins pos={[0:255]}; 
                                               }
    
    FLAG:coverpoint t.PRDATA iff(t.PADDR[A-5:0]==16){ bins neg={[-65025:-1]};
                                                     bins pos={[0:65025]}; 
                                                    }
    
    PADDR:coverpoint t.PADDR[A-5:0]{bins p[]={0,4,8,16,12};}
    
    Transfer:coverpoint t.transfer{bins b={1};}
    
    w_en1:coverpoint t.PWRITE iff(t.PADDR[A-5:0]==0){bins w={1};}
    
    w_en2:coverpoint t.PWRITE iff(t.PADDR[A-5:0]==4){bins w={1};}
    
    w_en3:coverpoint t.PWRITE iff(t.PADDR[A-5:0]==8){bins w={1};}
    
    w_en4:coverpoint t.PWRITE iff(t.PADDR[A-5:0]==12){bins w={0};}
    
    w_en5:coverpoint t.PWRITE iff(t.PADDR[A-5:0]==16){bins w={0};}
    
    SLAVE_SEL:coverpoint t.PSEL {bins slv[]={1,2,4,8,16,32,64,128};}
    
    PENABLE: coverpoint t.PENABLE {
                                   bins access_phase={1};
                                   bins setup_phase={0};
                                  }
    
    FULL_SLAVE_CHECK: cross OPCODE,SLAVE_SEL;
    
  endgroup
    
    
    
  
  function new(mailbox #(transaction) from_mon);
    this.from_mon=from_mon;
    cov_apbtoalu=new();
  endfunction
  
  
  task c_run;
    begin
      forever begin
        from_mon.get(t);
        if(t.PADDR[A-5:0]==0)begin
          x=t.PWDATA[15:0];
        end
        
        if(t.PADDR[A-5:0]==4)begin
          y=t.PWDATA[15:0];
        end
        
        cov_apbtoalu.sample();
      end
    end
  endtask
  
  
endclass
