
class r_generator;
  
  r_transaction t;
  mailbox #(r_transaction) to_driver;
 
  event done;
  
  function new(mailbox #(r_transaction) to_driver,event done);
    this.to_driver=to_driver;
    this.done=done;
  endfunction
  
  task g_gn();
    begin
      
      //write only
      repeat(8)begin
        t=new();
        t.count=0;
        assert(t.randomize());
        to_driver.put(t);
        @(done);
      end
      
      //full
      
      repeat(40)begin
        t=new();
        t.count=1;
        assert(t.randomize());
        to_driver.put(t);
        @(done);
      end
      
      //read only
      repeat(2)begin
        t=new();
        t.count=2;
        assert(t.randomize());
        to_driver.put(t);
        @(done);
      end
      
      //empty
      repeat(20)begin
        t=new();
        t.count=3;
        assert(t.randomize());
        to_driver.put(t);
        @(done);
      end
      
      //simultanous read and write
      repeat(100)begin
        t=new();
        t.count=4;
        assert(t.randomize());
        to_driver.put(t);
        @(done);
      end
      
      //no read and write
      repeat(4)begin
        t=new();
        t.count=5;
        assert(t.randomize());
        to_driver.put(t);
        @(done);
      end

    end
  endtask
  
endclass
