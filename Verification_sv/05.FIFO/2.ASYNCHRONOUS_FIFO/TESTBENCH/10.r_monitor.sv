class r_monitor;
  
  r_transaction t;
  mailbox #(r_transaction) to_scoreboard;
  mailbox #(r_transaction) to_coverage;
 
  virtual fifo.r_mtr vif;
  
  function new(mailbox #(r_transaction) to_scoreboard,mailbox #(r_transaction) to_coverage,virtual fifo.r_mtr vif);
    this.to_scoreboard=to_scoreboard;
    this.to_coverage=to_coverage;
    this.vif=vif;
  endfunction
  
  task m_rn();
    begin
      forever begin
        t=new();
        
        @(vif.r_cb_mon);
        
        t.r_en=vif.r_cb_mon.r_en;
        t.r_rst=vif.r_rst;
        t.data_out=vif.r_cb_mon.data_out;
        t.empty=vif.r_cb_mon.empty;
        t.r_ptr=vif.r_cb_mon.r_ptr;
        to_scoreboard.put(t);
        to_coverage.put(t);
        $display("[time=%0t] MONITOR[READ] : r_reset=%b | read_enable=%b  | data_out=%d |empty=%b ",$time, t.r_rst,t.r_en,t.data_out,t.empty);
      end
    end
  endtask
  
endclass
