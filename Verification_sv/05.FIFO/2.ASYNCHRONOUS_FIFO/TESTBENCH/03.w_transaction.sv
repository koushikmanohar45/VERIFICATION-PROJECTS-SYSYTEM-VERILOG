
class w_transaction #(parameter width=8);
  
  rand bit[width-1:0] data_in;
  rand bit w_en;
  bit w_rst;
  bit full; 
  int count;
  
  constraint c1{
                if(count==0)
                   w_en==1;//write only
                if(count==1)
                   w_en==1;//full
                if(count==2)
                   w_en==0;//read only
                if(count==3)
                   w_en==0;//empty
                if(count==4)
                   w_en==1;//simultanious read and write
                if(count==5)
                   w_en==0;//no read and write
               }
  
endclass
