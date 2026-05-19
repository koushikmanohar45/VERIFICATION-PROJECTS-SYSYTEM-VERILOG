class monitor;
  
  transaction t;
  
  mailbox #(transaction) to_scoreboard;
  
  virtual ram_itf.mon vif;
  
  function new(mailbox #(transaction) to_scoreboard,virtual ram_itf.mon vif );
    this.to_scoreboard= to_scoreboard;
    this.vif= vif;
  endfunction
  
  task mon();
    begin
      forever 
        begin
          t=new();
          @(vif.mon_clk);
          t.data1=vif.mon_clk.data1;
          t.data2=vif.mon_clk.data2;
          t.addr1=vif.mon_clk.addr1;
          t.addr2=vif.mon_clk.addr2;
          t.w_e1=vif.mon_clk.w_e1;
          t.w_e2=vif.mon_clk.w_e2;
          t.data_out1=vif.mon_clk.data_out1;
          t.data_out2=vif.mon_clk.data_out2;
          to_scoreboard.put(t);
      
          $display("................................................................................");
          $display(". [time=%0t]              MONITOR                                              .",$time);
          $display("................................................................................");
          $display(".  DATA       .   Data1        =%d         .   Data2         =%d         .",t.data1,t.data2);
          $display(".  ADDRESS    .   Address1     =%d         .   Address2      =%d         .",t.addr1,t.addr2);
          $display(".  ENABLE     .   Write_enable1=    %b         .   Write_enable2 =    %b         .",t.w_e1,t.w_e2);
          $display(".  DATA_OUT   .   Data_out1    =%d         .   Data_out2     =%d         .",t.data_out1,t.data_out2);
          $display("................................................................................");
        end
    end
  endtask
  
  
endclass
