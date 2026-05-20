class transaction;
  
  typedef enum{READ_ONLY,WRITE_ONLY,READ_WRITE,NO_READ_WRITE} mode;
  
  rand mode m;
  bit[7:0] data_in;
  rand bit rd_en;
  rand bit wt_en;
  rand bit rst;
  bit[7:0] data_out;
  bit full; 
  bit empty;
  
  rand int duration;
  
  constraint c1{ 
    rst dist {0:=20,1:=1};
 
    duration inside {[16:20]};
    
                data_in<1000;
               }
  
  constraint c2{
                if(m==READ_ONLY) {rd_en==1;wt_en==0;}
                if(m==WRITE_ONLY) {rd_en==0;wt_en==1;}
                if(m==READ_WRITE) {rd_en==1;wt_en==1;}
                if(m==NO_READ_WRITE) {rd_en==0;wt_en==0;} 
               }
  
  
endclass
