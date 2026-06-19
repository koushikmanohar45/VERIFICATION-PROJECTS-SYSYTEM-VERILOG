class w_generator;
  
  w_transaction t;
  
  mailbox #(w_transaction) to_driver;
  
  event done;
  
  function new(mailbox #(w_transaction) to_driver,event done);
    this.to_driver=to_driver;
    this.done=done;
    t=new();
  endfunction
  
  task g_gen();
    begin
      //write only
      $display("=======================");
      $display("       write only");
      $display("=======================");
      repeat(4)begin
        t=new();
        t.count=0;
        t.randomize();
        to_driver.put(t);
        @(done);
      end
      
      //full
      $display("");
      $display("");
      $display("");
      $display("=======================");
      $display("  full condition check");
      $display("=======================");
      
      repeat(20)begin
        t=new();
        t.count=1;
        t.randomize();
        to_driver.put(t);
        @(done);
      end
      
      //read only
      $display("");
      $display("");
      $display("");
      $display("=======================");
      $display("        read only      ");
      $display("=======================");
      repeat(1)begin
        t=new();
        t.count=2;
        t.randomize();
        to_driver.put(t);
        @(done);
      end
      
      //empty
      $display("");
      $display("");
      $display("");
      $display("=======================");
      $display("          empty        ");
      $display("=======================");
      repeat(10)begin
        t=new();
        t.count=3;
        t.randomize();
        to_driver.put(t);
        @(done);
      end
      
      //simultanous read and write
      $display("");
      $display("");
      $display("");
      $display("=======================");
      $display("   read and write      ");
      $display("=======================");
      repeat(50)begin
        t=new();
        t.count=4;
        t.randomize();
        to_driver.put(t);
        @(done);
      end
      
      //no read and write
      $display("");
      $display("");
      $display("");
      $display("=======================");
      $display("       NO operation    ");
      $display("=======================");
      repeat(4)begin
        t=new();
        t.count=5;
        t.randomize();
        to_driver.put(t);
        @(done);
      end
      
    end
  endtask
  
endclass
