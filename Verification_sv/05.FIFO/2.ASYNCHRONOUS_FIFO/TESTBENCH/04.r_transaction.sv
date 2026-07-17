class r_transaction #(parameter width=8, depth=16);
  

  rand bit r_en;
  bit r_rst;
  bit[width-1:0] data_out;
  bit empty;
  bit [$clog2(depth):0]r_ptr;
  int count;

  
  constraint c1{
                if(count==0)
                   r_en==0;//write only
                if(count==1)
                   r_en==0;//full
                if(count==2)
                   r_en==1;//read only
                if(count==3)
                   r_en==1;//empty
                if(count==4)
                   r_en==1;//simultanious read and write
                if(count==5)
                   r_en==0;//no read and write
               }

endclass
