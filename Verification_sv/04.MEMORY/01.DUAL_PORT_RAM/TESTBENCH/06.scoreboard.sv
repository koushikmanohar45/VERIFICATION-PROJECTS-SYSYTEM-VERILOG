class scoreboard;
  
   transaction t;

   mailbox #(transaction) from_monitor;
  
  reg [15:0] expected_dataout1,expected_dataout2;
   int total,pass,fail;
   reg [15:0] mem [256];
  
  function new(mailbox #(transaction) from_monitor);
    this.from_monitor=from_monitor;
  endfunction
  
  task sb();
    begin
      
      forever begin
        t=new();
       
        from_monitor.get(t);
            
        $display("................................................................................");
        $display(".[time=%0t]                     SCOREBOARD                                    .",$time);
        $display("................................................................................");
        if(t.w_e1)begin
           
          mem[t.addr1]=t.data1;
          $display(".            Data1 Written sucessfully                                         .");
          
         end
        
        else begin
          
          expected_dataout1=mem[t.addr1];
          total++;
          $display(".            Data1 read sucessfully                                            .");
          $display(".                                   Expected_data1=%d   Actual_data1 =%d .",expected_dataout1,t.data_out1);
          
          if(t.data_out1===expected_dataout1 )begin
          pass++;
            $display(".                                ==> DATA1 PASS                                .");
         end
        else begin
          fail++;
          $display(".                                ==> DATA1 FAIL                                .");
        end
          
        end
          
        if(t.w_e2 && !(t.w_e1 && t.addr1==t.addr2)) begin 
          mem[t.addr2]=t.data2;
          $display(".            Data2 Written sucessfully                                         .");
         end
        else if(!t.w_e2)begin
          total++;
          expected_dataout2=mem[t.addr2];
          $display(".            Data2 read sucessfully                                            .");
          $display(".                                   Expected_data2=%d   Actual_data2 =%d .",expected_dataout2,t.data_out2);
          
          if(t.data_out1===expected_dataout1 )begin
            pass++;
            $display(".                                ==> DATA2 PASS                                .");
           end  
          else begin
            fail++;
            $display(".                                ==> DATA2 FAIL                                .");
            
           end
        end
        
         $display("................................................................................");
        $display("==================================================================================================================================================================================================================================");
      end
    end
  endtask
     
endclass
