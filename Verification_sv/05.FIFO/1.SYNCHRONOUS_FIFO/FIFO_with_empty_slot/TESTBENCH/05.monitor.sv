class monitor;
  
  mailbox #(transaction) to_scoreboard;
  transaction t;
  virtual fifo.mtr vif;
  
  function new(mailbox #(transaction) to_scoreboard,virtual fifo.mtr vif);
    this.to_scoreboard=to_scoreboard;
    this.vif=vif;
  endfunction
  
  task m_run();
    begin
      forever begin
        t=new();
        
        @(vif.mon);

        t.data_in=vif.mon.data_in;
        t.rst=vif.mon.rst;
        t.rd_en=vif.mon.rd_en;
        t.wt_en=vif.mon.wt_en;
        t.data_out=vif.mon.data_out;
        t.full=vif.mon.full;
        t.empty=vif.mon.empty;
        to_scoreboard.put(t);
        $display("[time=%0t] MONITOR:  |reset=%b | read_enable=%b | write_enable=%b | data_in=%d | ",$time, t.rst,t.rd_en,t.wt_en,t.data_in);
      end
    end
  endtask
endclass
