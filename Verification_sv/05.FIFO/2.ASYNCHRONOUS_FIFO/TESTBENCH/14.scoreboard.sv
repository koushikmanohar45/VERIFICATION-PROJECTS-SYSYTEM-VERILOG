class scoreboard #(parameter depth=32);
  
  w_transaction t;
  r_transaction t1;
  
  mailbox #(w_transaction) from_w_monitor;
  mailbox #(r_transaction) from_r_monitor;
  
  
  function new(mailbox #(w_transaction) from_w_monitor,mailbox #(r_transaction) from_r_monitor);
    this.from_w_monitor=from_w_monitor;
    this.from_r_monitor=from_r_monitor;
  endfunction
  
  bit [7:0] ref_q[$];
  bit [7:0] expected,prev_expected;
  bit prev_full,prev_empty;
  bit full,empty;

  
  real total,pass,fail;
  
  task s_run();
    begin
      fork
        
        forever begin 
            t=new();
            from_w_monitor.get(t);
          
           if(t.w_rst) begin
            ref_q.delete();
           end
          else if(t.w_en && !t.full) begin
            if(ref_q.size()<= depth)begin
               ref_q.push_back(t.data_in);
               total++;
              $display("[time=%0t] SCOREBOARD write operation sucessful! ------------------------------------------------->size=%0d q=%p",$time,ref_q.size(),ref_q);
              pass++;
              $display("                      +------------------+-------------------+");
              $display("[time=%0t] SCOREBOARD | Actual_full =%b   | Expected_full =%b  |",$time,t.full,full);
              $display("                      | Actual_empty=%b   | Expected_empty=%b  |",t1.empty,empty);
              $display("                      +------------------+-------------------+");
//               if(full==t.full && empty==t1.empty)begin
//                 pass++;
//                 $display("=>|pass|<=");
//                 $display("--------------------------------------------------------------------------------------------------");
//               end
//               else begin
//                 fail++;
//                 $display("=>|fail|<=");
//                 $display("--------------------------------------------------------------------------------------------------");
//               end
            end
          end
          else if(t.full) begin
            $display("[time=%0t] SCOREBOARD write operation failed due to full! ------------------------------------------------>size=%0d q=%p",$time,ref_q.size(),ref_q);
            $display("--------------------------------------------------------------------------------------------------");
            end
           full=(ref_q.size()==depth);
          end
        
        
        
        forever begin
          t1=new();
          from_r_monitor.get(t1);
          
          expected=prev_expected;
          
          if(t1.r_en && !t1.empty && !t1.r_rst) begin
            
            if(ref_q.size()>0) begin
              prev_expected=ref_q.pop_front();
              $display("[time=%0t] SCOREBOARD read operation successful! ------------------------------------------------>size=%0d  q=%p",$time,ref_q.size(),ref_q);
               total++;
            
              $display("                      +------------------+-------------------+");
              $display("                      | Actual_data =%d | Expected_data =%d|",t1.data_out,expected);
              $display("[time=%0t] SCOREBOARD | Actual_full =%b   | Expected_full =%b  |",$time,t.full,full);
              $display("                      | Actual_empty=%b   | Expected_empty=%b  |",t1.empty,empty);
              $display("                      +------------------+-------------------+");
            
              if(expected==t1.data_out && full==t.full && empty==t1.empty)begin
                $display("=>|PASS|<=");
                pass++;
              end
              else begin
                $display("=>|FAIL|<=");
                fail++;
              
              end 
             $display("======================================================================================================");
          end
            else
              $display("[time=%0t] SCOREBOARD read operation failed due to empty! ----------------------------------------->size=%0d  q=%p",$time,ref_q.size(),ref_q);
        end
        empty=(ref_q.size()==0);
      end
        
        
     join 
    end
  endtask
  
endclass
