class generator;
  
  transaction t;
  
  mailbox #(transaction) to_driver;
  
  event ev;
  

  int c;
  bit [2:0] counter;
  bit [2:0] slave_sel;
  bit [1:0] sign;
  
  function new(mailbox #(transaction) to_driver,event ev);
    this.to_driver=to_driver;
    this.ev=ev;
  endfunction
  

        
  
  task g_run();
    begin
      
      forever begin
        t=new();
        
        t.counter= counter;
        t.slave_sel= slave_sel;
        t.sign= sign;
        
        if(c==0) begin
          $display("==============================");
          $display(" testcase 1:  A=+ve  B=+ve   ");
          $display("==============================");
         end
        
        assert(t.randomize());
        
        to_driver.put(t);
        
        @(ev);
      
        
        if(c==100) begin
          $display("==============================");
          $display(" testcase 2: A=+ve  B=-ve");
          $display("==============================");
          sign=2'b01;
         end

        else if(c==200) begin
          $display("==============================");
          $display(" testcase 3:  A=-ve  B=+ve");
          $display("==============================");
          sign = 2'b10;
         end

        else if(c==300) begin
          $display("==============================");
          $display(" testcase 4:  A=-ve  B=-ve");
          $display("==============================");
          sign=2'b11;
         end

        else if(c == 400) begin
          $display("==============================");
          $display("      Changing Slave");
          $display("==============================");
          c=0;
          t.contin_trans++;
          sign=2'b00;

          if(slave_sel==7)
            slave_sel=0;
          else
            slave_sel++;
        end
        
        if(counter == 4)
          counter = 0;
        else
          counter++;
        c++;
      end
      case(counter)
           0: $display("[GENERATOR] Sending Operand A");
           1: $display("[GENERATOR] Sending Operand B");
           2: $display("[GENERATOR] Sending Opcode");
           3: $display("[GENERATOR] Receiving Output");
           4: $display("[GENERATOR] Receiving Flag");
        endcase
    end
  endtask
  
endclass
