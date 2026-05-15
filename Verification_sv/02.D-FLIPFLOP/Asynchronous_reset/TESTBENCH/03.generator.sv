class generator;
  
  mailbox #(transaction) to_drive;
  transaction t;
  event done;
  
  function new(mailbox #(transaction) to_drive,event done);
    this.to_drive=to_drive;
    this.done=done;
  endfunction
  
  task gen();
    begin
      forever begin
        t=new();
        t.randomize();
        to_drive.put(t);
       // $display("GENERATOR: rst=%b d=%b", t.rst, t.d);
        @(done);
      end
     end
  endtask
  
endclass
