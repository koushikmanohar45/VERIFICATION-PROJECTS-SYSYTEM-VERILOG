class coverage;
  
  w_transaction t;
  r_transaction t1;
  
  
  mailbox #(w_transaction) from_w_scb;
  mailbox #(r_transaction) from_r_scb;
  
  
  covergroup async_wr;
    
    rst:coverpoint t.w_rst;
    
    data_in:coverpoint t.data_in iff(!t.w_rst){
                                                bins low={[1:85]};
                                                bins med={[86:170]};
                                                bins high={[171:255]};
                                              }
    wen:coverpoint t.w_en;
    
    write_only: coverpoint t.w_en{
                                   bins b=(1[*15]);
                                 }
    
    ful:coverpoint t.full iff(t.w_en){
                                       bins f={1};
                                     }
    
    wptr_check: coverpoint  t.w_ptr iff(t.w_en && !t.full) { 
                                                             bins b1=(0=>1);
                                                             bins b2=(1=>2);
                                                             bins b3=(2=>3);
                                                             bins b4=(3=>4);
                                                             bins b5=(4=>5);
                                                             bins b6=(5=>6);
                                                             bins b7=(6=>7);
                                                             bins b8=(7=>8);
                                                             bins b9=(8=>9);
                                                             bins b10=(9=>10);
                                                             bins b11=(10=>11);
                                                             bins b12=(11=>12);
                                                             bins b13=(12=>13);
                                                             bins b14=(13=>14);
                                                             bins b15=(14=>15);
                                                          }
    
    wptr_wrap: coverpoint  t.w_ptr iff(t.w_en && !t.full){ 
                                                           bins b=(15=>16);
                                                         }
    
    endgroup
  
  
  covergroup async_rd;
    
    rst:coverpoint t1.r_rst;
    
    dataout:coverpoint t1.data_out iff(!t1.r_rst){
                                                   bins low={[1:85]};
                                                   bins med={[86:170]};
                                                   bins high={[171:255]};
                                                 }
     
    emty:coverpoint t1.empty;
    
    empty_check:coverpoint t1.empty iff(t.w_ptr==t1.r_ptr){
                                                            bins b={1};
                                                          }
    
    ren:coverpoint t1.r_en;
    
    read_only:coverpoint t1.r_en{
                                  bins b=(1[*15]);
                                }
    
    rptr_check:coverpoint t1.r_ptr iff(t1.r_en && !t1.empty) { 
                                                               bins b1=(0=>1);
                                                               bins b2=(1=>2);
                                                               bins b3=(2=>3);
                                                               bins b4=(3=>4);
                                                               bins b5=(4=>5);
                                                               bins b6=(5=>6);
                                                               bins b7=(6=>7);
                                                               bins b8=(7=>8);
                                                               bins b9=(8=>9);
                                                               bins b10=(9=>10);
                                                               bins b11=(10=>11);
                                                               bins b12=(11=>12);
                                                               bins b13=(12=>13);
                                                               bins b14=(13=>14);
                                                            }
    
    rptr_wrap:coverpoint t1.r_ptr iff(t1.r_en && !t1.empty) { 
                                                               bins b=(15=>16);
                                                            }
    
    simul_w_r:cross t.w_en,t1.r_en iff(!t.w_rst && !t1.r_rst);
    
    underflow:coverpoint {t1.r_en,t1.empty}
                                           {
                                             bins underflow={2'b11};
                                           }
    overflow:coverpoint {t.w_en,t.full}
                                       {
                                         bins overflow = {2'b11};
                                       }
    
    endgroup
  
  
  
  function new(mailbox #(w_transaction) from_w_scb,mailbox #(r_transaction) from_r_scb);
     this.from_w_scb=from_w_scb;
     this.from_r_scb=from_r_scb;
    
      async_wr=new();
      async_rd=new();
    
  endfunction
  
    
  

  
  
  task run();
    forever begin
      
      from_w_scb.get(t);
      async_wr.sample();
      $display("| coverage_w=%0.2f%%       |",async_wr.get_inst_coverage());
      
      from_r_scb.get(t1);
      async_rd.sample();
      $display("| coverage_R=%0.2f%%      |",async_rd.get_inst_coverage());
      
    end
  endtask
  
  
endclass
