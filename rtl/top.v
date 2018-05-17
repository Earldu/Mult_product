//------------------------------------------------
//File Name		:top.v
//Project		:EDA工具及设计实践课程作业一
//Designer		:Earl Du
//Version		:0.2
//Description	:顶层文件
//------------------------------------------------
//Revision History:
//
//Date			Rev.	By			Description
//------------------------------------------------
//04/11/2018	0.1		Earl Du		first draft
//04/13/2018	0.2		Earl Du		second draft		 
//------------------------------------------------

module top #(parameter DW = 32)
(
	input				clk,
	input				n_rst,
	input	[2:0]		op,//function selection
	input	[1:0]		ww,
	input	[1:0]		ctrl,
	input	[DW-1:0]	A,
	input	[DW-1:0]	B,
	output	[2*DW-1:0]	Mout
);

parameter MULT 	 = 3'b001;//func one
parameter PIXL 	 = 3'b010;//func two
parameter PLURAL = 3'b100;//func three

//The multiplication result
wire [2*DW+1:0] res;
mult u1(.clk(clk), .n_rst(n_rst), .op(op), .a(A), .b(B), .p(res));

//Instantiation
wire	[2*DW-1:0]	Mout_1, Mout_2, Mout_3;
Multiplication inst_Multiplication(
			.clk(clk), 
			.n_rst(n_rst), 
			.res_t(res), 
			.Mout(Mout_1)
);

pixel_accumulation inst_pixel_accumulation(
			.clk(clk),
			.n_rst(n_rst),
			.ww(ww),
			.Sum(res),
			.Mout(Mout_2)
);

Plural_operation inst_Plural_operation(
			.clk(clk),
			.n_rst(n_rst),
			.ctrl(ctrl),
			.tmp(res),
			.Mout(Mout_3)
);

reg [2*DW-1:0] Mout_w;
always @(*)
begin
	case(op)
	MULT:		Mout_w = Mout_1;
	PIXL:		Mout_w = Mout_2;
	PLURAL:		Mout_w = Mout_3;
	default: 	Mout_w = 64'b0;
	endcase
end

assign Mout = Mout_w;

endmodule