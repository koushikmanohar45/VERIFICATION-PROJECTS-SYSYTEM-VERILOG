class driver;
  
  virtual ram_itf.dr vif;
  event done;
  mailbox #(transaction) from_gen;
  transaction t;
  
  function new(mailbox #(transaction) from_gen,virtual ram_itf.dr vif,event done);
    this.vif=vif;
    this.done=done;
    this.from_gen=from_gen;
  endfunction
  
  task drv();
    begin
      forever
        begin
          t=new();
          from_gen.get(t);
          @(vif.dr_clk);
          vif.dr_clk.data1<=t.data1;
          vif.dr_clk.data2<=t.data2;
          vif.dr_clk.addr1<=t.addr1;
          vif.dr_clk.addr2<=t.addr2;
          vif.dr_clk.w_e1<=t.w_e1;
          vif.dr_clk.w_e2<=t.w_e2;
          
          $display("................................................................................");
          $display(". [time=%0t]              DRIVER                                              .",$time);
          $display("................................................................................");
          $display(".  DATA       .   Data1        =%d         .   Data2         =%d         .",t.data1,t.data2);
          $display(".  ADDRESS    .   Address1     =%d         .   Address2      =%d         .",t.addr1,t.addr2);
          $display(".  ENABLE     .   Write_enable1=    %b         .   Write_enable2 =    %b         .",t.w_e1,t.w_e2);
          $display("................................................................................");
          ->done;
        end
    end
  endtask
  
endclass
