class scoreboard;
  
  mailbox #(transaction) from_monitor;
  transaction t;
  
  function new(mailbox #(transaction) from_monitor);
    this.from_monitor=from_monitor;
  endfunction
  
  bit [7:0] expected_data_out;
  reg[7:0]mem[63:0];
  reg [5:0] wptr,rptr;
  bit full=0,empty=1;
  
  real total,pass,fail;
  
  task s_run();
    begin
      forever begin
        t=new();
        from_monitor.get(t);
        
        total++;
        
        if(t.rst)begin
          expected_data_out=0;
          wptr=0;
          rptr=0;
          empty=1;
          full=0;
        end
        else begin
          if(t.wt_en && ! full)begin
            mem[wptr]=t.data_in;
            wptr=wptr+1;
          end
          else
            wptr=wptr;
          
          if(t.rd_en && !empty)begin
            expected_data_out=mem[rptr];
            rptr=rptr+1;
          end
          else
            rptr=rptr;
        end
        empty= wptr==rptr;
          
        full=(rptr==(wptr+1));
        
        $display("                      +------------------+-------------------+");
        $display("                      | Actual_data =%d | Expected_data =%d|",t.data_out,expected_data_out);
        $display("[time=%0t] SCOREBOARD | Actual_full =%b   | Expected_full =%b  |",$time,t.full,full);
        $display("                      | Actual_empty=%b   | Expected_empty=%b  |",t.empty,empty);
        $display("                      +------------------+-------------------+");
        
        if(expected_data_out==t.data_out && full==t.full && empty==t.empty)begin
          $display("=>|PASS|<=");
           pass++;
        end
        else begin
          $display("=>|FAIL|<=");
          fail++;
        end
        $display("======================================================================================================");
      end
    end
  endtask
  
endclass
