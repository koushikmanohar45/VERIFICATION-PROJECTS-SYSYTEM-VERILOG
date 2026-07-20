class transaction  #(parameter N=32,A=16);
    
  rand bit PRESETn;
  rand bit signed [N-1:0] PWDATA;
  rand bit [A-1:0] PADDR;
  rand bit transfer;
  rand bit PWRITE;
  bit signed [N-1:0] PRDATA;
  bit PSLVERR;
  bit [7:0]PSEL;
  bit PENABLE;
  
  bit [1:0] sign;
  bit contin_trans;
  bit [2:0] counter;
  bit [2:0] slave_sel;
  bit c;
  
  static bit [7:0] prev_psel;
  static bit [3:0] upcode;
  
  constraint data {
                    !PRESETn -> (PWDATA==0);

    PRESETn && (PADDR[A-5:0]==0) -> (PWDATA[N-1]==sign[1]);
    PRESETn && (PADDR[A-5:0]==0) -> (PWDATA<255);
    PRESETn && (PADDR[A-5:0]==0) -> (PWDATA>-255);

    PRESETn && (PADDR[A-5:0]==4) -> (PWDATA[N-1]==sign[0]);
    PRESETn && (PADDR[A-5:0]==4) -> (PWDATA<255);
    PRESETn && (PADDR[A-5:0]==4) -> (PWDATA>-255);
                  }
  
  constraint upcod{
    if(PRESETn && PADDR[A-5:0]==8){
                           PWDATA<16;
                           PWDATA>=0;
                    }
                   }
                    
  constraint trans{ 
                   if(!contin_trans)
                         transfer==1;
                   else{ 
                          PENABLE -> transfer==1;
                         !PENABLE -> transfer==0;
                       }
                  }
   
  constraint ADDR{
                   if(counter==0)
                     PADDR[A-5:0]==0;
                   else if(counter==1)
                     PADDR[A-5:0]==4;
                   else if(counter==2)
                     PADDR[A-5:0]==8;
                   else if(counter==3)
                     PADDR[A-5:0]==12;
                   else if(counter==4)
                     PADDR[A-5:0]==16;
                 }
                     
  constraint write{
    (PADDR[A-5:0]==0) -> PWRITE==1;
    (PADDR[A-5:0]==4) -> PWRITE==1;
    (PADDR[A-5:0]==8) -> PWRITE==1;
    (PADDR[A-5:0]==12) -> PWRITE==0;
    (PADDR[A-5:0]==16) -> PWRITE==0;   
                   }
                     
                     constraint slave{(slave_sel==0) -> PADDR[(A-1) -:4]==0;
                                      (slave_sel==1) -> PADDR[(A-1) -:4]==1;
                                      (slave_sel==2) -> PADDR[(A-1) -:4]==2;
                                      (slave_sel==3) -> PADDR[(A-1) -:4]==3;
                                      (slave_sel==4) -> PADDR[(A-1) -:4]==4;
                                      (slave_sel==5) -> PADDR[(A-1) -:4]==5;
                                      (slave_sel==6) -> PADDR[(A-1) -:4]==6;
                                      (slave_sel==7) -> PADDR[(A-1) -:4]==7;
                                     }
  
                     
  function void display();
    begin
      
      if(PADDR[A-5:0]==0)
        $display("Operand A=%0d",PWDATA);
      else if(PADDR[A-5:0]==4)
        $display("Operand B=%0d",PWDATA);
      else if(PADDR[A-5:0]==8)begin
        upcode=PWDATA[N-29:0];
        case(upcode)
          0:$display("Opcode=ADDITION(%b)",PWDATA[N-29:0]);
          1:$display("Opcode=SUBRACTION(%b)",PWDATA[N-29:0]);
          2:$display("Opcode=MULTIPLICATION(%b)",PWDATA[N-29:0]);
          3:$display("Opcode=DIVISION(%b)",PWDATA[N-29:0]);
          4:$display("Opcode=REMAINDER(%b)",PWDATA[N-29:0]);
          5:$display("Opcode=INCREMENTER(%b)",PWDATA[N-29:0]);
          6:$display("Opcode=A LEFT SHIFT BY LAST 4 LSB BIT B(%b)",PWDATA[N-29:0]);
          7:$display("Opcode=A RIGHT SHIFT BY LAST 4 LSB BIT B(%b)",PWDATA[N-29:0]);
          8:$display("Opcode=AND(%b)",PWDATA[N-29:0]);
          9:$display("Opcode=OR(%b)",PWDATA[N-29:0]);
          10:$display("Opcode=XOR(%b)",PWDATA[N-29:0]);
          11:$display("Opcode=NAND(%b)",PWDATA[N-29:0]);
          12:$display("Opcode=NOR%b)",PWDATA[N-29:0]);
          13:$display("Opcode=XNOR(%b)",PWDATA[N-29:0]);
          14:$display("Opcode=NOT(%b)",PWDATA[N-29:0]);
          15:$display("Opcode=REVERSE BITS(%b)",PWDATA[N-29:0]);
          default:$display("invalid opcode");
        endcase
      end
      else if(PADDR[A-5:0]==12)begin
        case(upcode)
          0:$display("A+B=%0d",PRDATA);
          1:$display("A-B=%0d",PRDATA);
          2:$display("A*B=%0d",PRDATA);
          3:$display("A/B=%0d",PRDATA);
          4:$display("A modulus B=%0d",PRDATA);
          5:$display("A++=%0d",PRDATA);
          6:$display("A<<B[4:0]=%0d",PRDATA);
          7:$display("A>>B[4:0]=%0d",PRDATA);
          8:$display("A&B=%0d",PRDATA);
          9:$display("A|B=%0d",PRDATA);
          10:$display("A^B=%0d",PRDATA);
          11:$display("NAND=%0d",PRDATA);
          12:$display("NOR=%0d",PRDATA);
          13:$display("XNOR=%0d",PRDATA);
          14:$display("NOT[A]=%0d",PRDATA);
          15:$display("REVERSE BITS[A]=%0d",PRDATA);
          default:$display("invalid opcode");
        endcase
      end
      
      else if(PADDR[A-5:0]==16)begin
        case(PRDATA[N-29:0])
          0:$display("NO FLAG");
          
          1:$display("NAN FLAG ARISES");
          
          2:$display("SIGN FLAG ARISES");
          
          3:begin 
              $display("SIGN FLAG ARISES");
              $display("NAN FLAG ARISES");
            end
          
          4:$display("ZERO FLAG ARISES");
          
          5:begin
              $display("NAN FLAG ARISES");
              $display("ZERO FLAG ARISES");
            end
          
          6:begin
             $display("SIGN FLAG ARISES");
             $display("ZERO FLAG ARISES");
            end
          
          7:begin
             $display("NAN FLAG ARISES");
             $display("SIGN FLAG ARISES");
             $display("ZERO FLAG ARISES");
            end
          
          8:$display("OVERFLOW FLAG ARISES");
          
          9:begin
             $display("NAN FLAG ARISES");
             $display("OVERFLOW FLAG ARISES");
            end
          
          10:begin
              $display("SIGN FLAG ARISES");
              $display("OVERFLOW FLAG ARISES");
             end
          
          11:begin
              $display("NAN FLAG ARISES");
              $display("SIGN FLAG ARISES");
              $display("OVERFLOW FLAG ARISES");
             end
          
          12:begin
              $display("ZERO FLAG ARISES");
              $display("OVERFLOW FLAG ARISES");
             end
          
          13:begin
              $display("NAN FLAG ARISES");
              $display("ZERO FLAG ARISES");
              $display("OVERFLOW FLAG ARISES");
             end
          14:begin
              $display("SIGN FLAG ARISES");
              $display("ZERO FLAG ARISES");
              $display("OVERFLOW FLAG ARISES");
             end
          
          15:begin
              $display("NAN FLAG ARISES");
              $display("SIGN FLAG ARISES");
              $display("ZERO FLAG ARISES");
              $display("OVERFLOW FLAG ARISES");
             end
          default:$display("Invalid FLAG");
        endcase
      end
      else
        $display("invalid function");
      
      if (PSEL!=prev_psel) begin
         prev_psel=PSEL;
         case (PSEL)
           8'b00000001: $display("SLAVE 1 is SELECTED");
           8'b00000010: $display("SLAVE 2 is SELECTED");
           8'b00000100: $display("SLAVE 3 is SELECTED");
           8'b00001000: $display("SLAVE 4 is SELECTED");
           8'b00010000: $display("SLAVE 5 is SELECTED");
           8'b00100000: $display("SLAVE 6 is SELECTED");
           8'b01000000: $display("SLAVE 7 is SELECTED");
           8'b10000000: $display("SLAVE 8 is SELECTED");
           default: $display("Invalid slave");
         endcase
      end
      
    end
  endfunction
    
  
endclass
