class scoreboard;
  
   transaction t1;

   mailbox #(transaction) from_monitor;
  
   reg expected_q;
  
  function new(mailbox #(transaction) from_monitor);
    this.from_monitor=from_monitor;
  endfunction
  
  task sb();
    begin
      
      forever begin
        t1=new();
       
        from_monitor.get(t1);
              
        if(t1.rst)
          expected_q=0;
        else begin
          expected_q=t1.d;
        end
        $display("          Time=[%0t] SCOREBOARD: rst=%b d=%b,q=%b",$time,t1.rst,t1.d,t1.q);
        $display("          +-----------------+");
        $display("          |   SCOREBOARD    |");
        $display("          +-----------------+");	
        $display("          |   actual_q=%b    |",t1.q);
        $display("          |  expected_q=%b   |",expected_q);  
      
        if(t1.q==expected_q )begin
          $display("          |   +--------+    |");
          $display("          |   |  PASS  |    |");
          $display("          |   +--------+    |");
          $display("          +-----------------+");
        end
        else begin
          $display("          |   +--------+    |");
          $display("          |   |  FAIL  |    |");
          $display("          |   +--------+    |");
          $display("          +-----------------+");
        end
        $display("=========================================================================");
        
      end
    end
  endtask
     
endclass
