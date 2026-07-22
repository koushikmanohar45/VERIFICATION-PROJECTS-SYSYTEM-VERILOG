class scoreboard #(parameter N=32,A=16) ;
  transaction t;
  
  mailbox #(transaction) from_mon;
  
  
  bit signed [15:0] x;
  bit signed [15:0] y;
  bit [3:0] opcode;
  bit signed [N-1:0]exp_out;
  bit signed [N-1:0]act_out;
  bit [3:0] flag;
  bit overflow_flag,zero_flag,sign_flag,NAN_flag;
  
  //slave change 
  bit [7:0] current_psel;
  bit first = 1;
  bit drop_transaction = 0;
  int invalid_count = 0;
  
  //pass and fail count
  int total;
  int pass;
  int fail;
  
  function new(mailbox #(transaction) from_mon);
    this.from_mon=from_mon;
  endfunction
  
  task s_run();
    begin
      //$display("==================================SCOREBOARD===================================");
      forever begin
        t=new();
        from_mon.get(t);
        if(first) begin
            current_psel=t.PSEL;
            first=0;
        end

        if(t.PSEL!=current_psel) begin
            $display("========================================================");
            $display("SLAVE CHANGED : %b -> %b", current_psel, t.PSEL);
            $display("Dropping current transaction");
            $display("========================================================");
            current_psel=t.PSEL;
            drop_transaction=1;
            invalid_count++;
        end
        
        if(t.PADDR[A-5:0]==0)begin
          x=t.PWDATA[15:0];
      //    t.display();
        end
        
        if(t.PADDR[A-5:0]==4)begin
          y=t.PWDATA[15:0];
       //   t.display();
        end
        
        if(t.PADDR[A-5:0]==8)begin
          opcode=t.PWDATA[3:0];
         // t.display();
        end
        
        if(t.PADDR[A-5:0]==12)begin
          act_out=t.PRDATA;
         // t.display();
               case(opcode)
                  4'b0000:exp_out=x+y;
                  4'b0001:exp_out=x-y;
                  4'b0010:exp_out=x*y;
                  4'b0011:exp_out=(y!=0)?x/y:0;
                  4'b0100:exp_out=(y!=0)?x%y:0;
                  4'b0101:exp_out=x+1;
                  4'b0110:exp_out=x<<y[4:0];
                  4'b0111:exp_out=x>>y[4:0];
                  4'b1000:exp_out=x&y;
                  4'b1001:exp_out=x|y;
                  4'b1010:exp_out=x^y;
                  4'b1011:exp_out=~(x&y);
                  4'b1100:exp_out=~(x|y);
                  4'b1101:exp_out=~(x^y);
                  4'b1110:exp_out=~x;
                  4'b1111:begin
                    exp_out=0;
                    for(int i=0;i<N/2;i=i+1)
                      exp_out[i]=x[(N/2)-1-i];  
                   end
                  default:exp_out=0;
                endcase 
          
        end
        
        if(t.PADDR[A-5:0]==16)begin
          
          if(drop_transaction) begin
             $display("********** TRANSACTION DROPPED **********");
             drop_transaction = 0;
           end
          
          else begin
             case (opcode)
               4'b0000:overflow_flag =(x[15]==y[15]) && (exp_out[N-1]!=x[15]);
               4'b0001:overflow_flag =(x[15] != y[15]) && (exp_out[N-1] != x[15]);
               4'b0010:overflow_flag =(exp_out>32'sd2147483647) || (exp_out<-32'sd2147483648);
               4'b0011:overflow_flag =(x==-16'sd32768) && (y==-16'sd1);
               4'b0101:overflow_flag =(x==16'sd32767);
               4'b0110:overflow_flag =1'b0;
               default:overflow_flag =1'b0;
             endcase
             
        
             zero_flag=(exp_out==0);
             sign_flag=exp_out[N-1];
            NAN_flag=(opcode==4'b0011 && y==0)||(exp_out[31]==1 && exp_out[30:0]==0);
                flag={overflow_flag,zero_flag,sign_flag,NAN_flag};
          
            // t.display();
          
             total++;
          
             if(exp_out==act_out && flag==t.PRDATA[3:0])begin
            
               //$display("PASS");
              // $display("exp_out=%0d, actual=%0d  | exp_flag=%0d  act_flag=%0d",exp_out,act_out,flag,t.PRDATA[3:0]);
               //$display("============================================================================");
               pass++;
              end
             else begin
               $display("FAIL");
               $display("operand A=%0d operand B=%0d Upcode=%b exp_out=%0d, actual=%0d  | exp_flag=%0d  act_flag=%0d",x,y,opcode,exp_out,act_out,flag,t.PRDATA[3:0]);
                fail++;
               //$display("============================================================================");
             end
          end
        end
      end
    end
  endtask
  
endclass
