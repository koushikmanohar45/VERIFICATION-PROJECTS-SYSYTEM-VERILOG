class w_monitor;
  
  w_transaction t;
  mailbox #(w_transaction) to_scoreboard;
  mailbox #(w_transaction) to_coverage;
 
  virtual fifo.w_mtr vif;
  
  function new(mailbox #(w_transaction) to_scoreboard,mailbox #(w_transaction) to_coverage,virtual fifo.w_mtr vif);
    this.to_scoreboard=to_scoreboard;
    this.to_coverage=to_coverage;
    this.vif=vif;
  endfunction
  
  task m_run();
    begin
      forever begin
        t=new();
        t.full=vif.w_cb_mon.full;
        
        @(vif.w_cb_mon);
        t.data_in=vif.w_cb_mon.data_in;
        t.w_rst=vif.w_rst;
        t.w_en=vif.w_cb_mon.w_en;
        t.w_ptr=vif.w_cb_mon.w_ptr;
        to_scoreboard.put(t);
        to_coverage.put(t);
        $display("[time=%0t] MONITOR[WRITE]: w_reset=%b | write_enable=%b | data_in=%d |full=%b ",$time, t.w_rst,t.w_en,t.data_in,t.full);
      end
    end
  endtask
endclass
