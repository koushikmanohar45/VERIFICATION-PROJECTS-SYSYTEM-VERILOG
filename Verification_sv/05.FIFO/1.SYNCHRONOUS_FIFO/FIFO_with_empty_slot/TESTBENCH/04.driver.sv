class driver;
  
  transaction t;
  virtual fifo.dr vif;
  mailbox #(transaction) from_gen;
  event done;
  
  bit [7:0] data_in;
  
  function new(mailbox #(transaction) from_gen,virtual fifo.dr vif,event done);
    this.from_gen=from_gen;
    this.vif=vif;
    this.done=done;
  endfunction
  
  task d_run();
    begin
      forever begin 
        t=new();
        from_gen.get(t);
        repeat(t.duration)begin
          @(vif.drv);
          data_in=$urandom_range(0,255);
          vif.drv.data_in<=data_in;
          
          vif.drv.rd_en<=t.rd_en;
          vif.drv.wt_en<=t.wt_en;
          vif.drv.rst<=t.rst;
          #1;
          $display("[time=%0t] DRIVER:   |reset=%b | read_enable=%b | write_enable=%b | data_in=%d | ",$time, t.rst,t.rd_en,t.wt_en,data_in);
        end
        ->done;
      end
    end
  endtask
  
endclass
  
