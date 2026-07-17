module asynchronus_fifo #(parameter depth=16,width=8)
  (
    input [width-1:0]data_in,
    input w_clk,r_clk,
    input w_rst,r_rst,
    input w_en,r_en,
    output [width-1:0] data_out,
    output full,empty,
    output [$clog2(depth):0] b_wptr,b_rptr
  );
  localparam addr=$clog2(depth);
  wire [addr:0]g_wptr,g_rptr;
  wire [addr:0]g_wptr_nxt,g_rptr_nxt;
  wire [addr:0]g_wptr_sync,g_rptr_sync; 
   
  synchronizer_2ff #(.A(addr)) m1(.clk(w_clk),.rst(w_rst),.data_in(g_rptr),.data_out(g_rptr_sync));
  synchronizer_2ff #(.A(addr)) m2(.clk(r_clk),.rst(r_rst),.data_in(g_wptr),.data_out(g_wptr_sync));
  wptr_handler #(.A(addr)) m3(.w_clk(w_clk),.w_rst(w_rst),.g_rptr_sync(g_rptr_sync),.w_en(w_en),.g_wptr(g_wptr),.b_wptr(b_wptr),.full(full));
  rptr_handler#(.A(addr)) m4(.r_clk(r_clk),.r_rst(r_rst),.g_wptr_sync(g_wptr_sync),.g_rptr(g_rptr),.b_rptr(b_rptr),.r_en(r_en),.empty(empty));
  fifo_memory#(.W(width),.D(depth),.A(addr)) m5(.data_in(data_in),.w_clk(w_clk),.r_clk(r_clk),.w_rst(w_rst),.r_rst(r_rst),.w_en(w_en),.r_en(r_en),.full(full),.empty(empty),.b_wptr(b_wptr),.b_rptr(b_rptr),.data_out(data_out)); 

endmodule

module fifo_memory#(parameter W,D,A)
(
  input [W-1:0]data_in,
    input w_clk,r_clk,
    input w_rst,r_rst,
    input w_en,r_en,
    input full,empty,
    input[A:0] b_wptr,b_rptr,
  output reg [W-1:0] data_out
);
  reg [W-1:0]mem[0:D-1];
  always@(posedge w_clk or posedge w_rst) begin
   if(w_en && !full) 
     mem[b_wptr[A-1:0]]<=data_in; 
    end
  always@(posedge r_clk or posedge r_rst) begin
    if(r_en && !empty) 
      data_out<=mem[b_rptr[A-1:0]]; 
    end
endmodule

module rptr_handler #(parameter A)
 (
  input r_clk,r_rst,
  input r_en,
   input[A:0] g_wptr_sync,
   output reg [A:0] g_rptr,b_rptr,
  output reg empty
);
  wire t_empty;
  wire[A:0]b_rptr_nxt,g_rptr_nxt;
  assign b_rptr_nxt=b_rptr+(r_en && !empty);
  assign g_rptr_nxt=(b_rptr_nxt^(b_rptr_nxt>>1));
  always @(posedge r_clk or posedge r_rst) begin
    if(r_rst) begin
      g_rptr<=0;
      b_rptr<=0;
      empty<=1;
    end
    else begin
      g_rptr<=g_rptr_nxt;
      b_rptr<=b_rptr_nxt;
      empty<=t_empty;     
    end
  end
  assign t_empty=(g_rptr_nxt==g_wptr_sync);
endmodule



module synchronizer_2ff #(parameter A)
(
  input clk,rst,
  input[A:0]data_in,
  output reg[A:0] data_out
);
  reg[A:0]temp;
  always@(posedge clk) begin
    if(rst) begin 
      temp<=0;
      data_out<=0;
    end
    else begin
      temp<=data_in;
      data_out<=temp;
    end
  end
endmodule

module wptr_handler #(parameter A)
 (
    input w_clk,w_rst,
    input w_en,
    input [A:0] g_rptr_sync,
    output reg [A:0] g_wptr,b_wptr,
    output reg full
  );
   wire t_full;
   wire [A:0]b_wptr_nxt,g_wptr_nxt;
   assign b_wptr_nxt=b_wptr+(w_en && !full);
   assign g_wptr_nxt=b_wptr_nxt^(b_wptr_nxt>>1);
   always@(posedge w_clk or posedge w_rst) begin
     if(w_rst) begin
      g_wptr<=0;
      b_wptr<=0;
      full<=0;
     end    
    else begin
      g_wptr<=g_wptr_nxt;
      b_wptr<=b_wptr_nxt;
      full<=t_full;
     end
   end
  assign t_full=(g_wptr_nxt=={~g_rptr_sync[A:A-1],g_rptr_sync[A-2:0]});
 endmodule
