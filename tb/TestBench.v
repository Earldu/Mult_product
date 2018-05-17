//----------------------------------------------
//File Name		:TestBench.v
//Project		:EDA工具及设计实践课程作业一
//Designer		:Earl Du
//Version		:0.3
//Description	:可配置多功能运算单元Testbench
//----------------------------------------------
//Revision History:
//
//Date			Rev.	By			Description
//----------------------------------------------
//04/01/2018	0.1		Earl Du		first draft	
//04/11/2018	0.2		Earl Du		new approach
//04/13/2018	0.3		Earl Du		new approach
//----------------------------------------------

`timescale 1ns/1ps

module TestBench;

wire	[63:0] 	t_Mout;
reg		[2:0]	t_op;
reg		[1:0]	t_ctrl;
reg		[1:0]	t_ww;
reg		[31:0]	t_A, t_B;
reg				clk, n_rst;

reg [31:0] oper_a;
reg [31:0] oper_b;

reg [7:0] a1;
reg [7:0] a2;
reg [7:0] a3;
reg [7:0] a4;

reg [7:0] b1;
reg [7:0] b2;
reg [7:0] b3;
reg [7:0] b4;

reg [15:0] ca1;
reg [15:0] ca2;
reg [15:0] cb1;
reg [15:0] cb2;

wire [31:0] complex_sumhi;
wire [31:0] complex_sumlo;

top inst_top(
			.clk(clk),
			.n_rst(n_rst),
			.op(t_op),
			.ctrl(t_ctrl),
			.ww(t_ww),
			.A(t_A),
			.B(t_B),
			.Mout(t_Mout)
);

initial
begin
	clk = 0;
	#2
	forever #1 clk = ~clk;
end

initial
begin
	n_rst = 1;
	#2
	n_rst = 0;
	#2
	n_rst = 1;
end

always @(*) begin
	case(t_op)
		3'b001: begin
			t_A = oper_a;
			t_B = oper_b;
		end
		3'b010: begin
			t_A = {a1, a2, a3, a4};
			t_B = {b1, b2, b3, b4};
		end
		3'b100: begin
			t_A = {ca1, ca2};
			t_B = {cb1, cb2};
		end
	endcase
end

assign complex_sumhi = t_Mout[63:32];
assign complex_sumlo = t_Mout[31:0];

initial
begin
	#2
	n_rst = 0;

	a1=8'h00;
	a2=8'h00;
	a3=8'h00;
	a4=8'h00;

	b1=8'h00;
	b2=8'h00;
	b3=8'h00;
	b4=8'h00;

	ca1=16'h0000;
	ca2=16'h0000;
	cb1=16'h0000;
	cb2=16'h0000;

	t_ctrl = 2'b00;
	t_op = 3'b000;
	oper_a = 32'h0000;
	oper_b = 32'h0000;
	t_ww = 2'b00;

//func one test
	#2
	n_rst = 1;
	t_op = 3'b001;
	oper_a = 32'h0000_01ff;
	oper_b = 32'h0000_01ff;		//expect: res=3fc01
	#2
	oper_a = 32'h0030_0001;
	oper_b = 32'h0020_0001;		//expect: res=600_0053_fc02
	#2
	oper_a = 32'h8020_0001;    
	oper_b = 32'h8010_0001;     //expect: res=3fe8_07ff_0083_fc03
	#6

//func two test
	#3
	n_rst = 0;
	oper_a = 32'h0;
	oper_b = 32'h0;
	#3
	n_rst = 1;
	#2
	t_op = 3'b010;

	a1=8'h12;
	a2=8'h03;
	a3=8'h04;
	a4=8'h21;

	b1=8'h42;
	b2=8'h11;
	b3=8'h56;
	b4=8'hf1;	//   expect: res=440
	#6

//func three test
	#3
	n_rst = 0;
	t_A = 32'b0;
	t_B = 32'b0;
	#2
	n_rst = 1;
	#2
	t_op = 3'b100;

	t_ctrl=2'b01;

	ca1=16'h0200;
	ca2=16'hf000;
	cb1=16'hf020;
	cb2=16'h0230;         //   expect: res=102_6000_fffc_c000

	#6
	t_ctrl=2'b10;

	ca1=16'h0200;
	ca2=16'hf000;
	cb1=16'hf020;
	cb2=16'h0230;         //   expect: res=fefd_a000_0003_4000

	#300
	$finish;

end

// dump wave
initial begin

  $fsdbDumpon;
  $fsdbDumpfile("TestBench.fsdb");
  $fsdbDumpvars(0,TestBench);

end




endmodule
