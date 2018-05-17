//-----------------------------------------------
//File Name		:mult.v
//Project		:EDA工具及设计实践课程作业
//Designer		:Earl Du
//Version		:0.3
//Description	:8*8, 8*8_x4, mult乘法单元
//-----------------------------------------------
//Revision History:
//
//Date			Rev.	By			Description
//-----------------------------------------------
//04/04/2018	0.1		Earl Du		first draft
//04/11/2018	0.2		Earl Du		second draft
//04/13/2018	0.3		Earl Du		third draft		 
//-----------------------------------------------

/*
							8*8
																	AAAAAAAA
															x		AAAAAAAA
															----------------
														   AAAAAAAA AAAAAAAA

							16*16
														   AAAAAAAA AAAAAAAA
													x	   AAAAAAAA AAAAAAAA
													------------------------
														   AAAAAAAA AAAAAAAA
												  AAAAAAAA AAAAAAAA
												  AAAAAAAA AAAAAAAA
									+	 AAAAAAAA AAAAAAAA
							------------------------------------------------
										 AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA

							32*8
										 AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA
									x								AAAAAAAA
							------------------------------------------------
														   AAAAAAAA AAAAAAAA
												  AAAAAAAA AAAAAAAA
										 AAAAAAAA AAAAAAAA
							+	AAAAAAAA AAAAAAAA
							------------------------------------------------
								AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA

							32*32
										 AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA 	A
									x	 AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA 	B
	    --------------------------------------------------------------------
				                AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA
					   AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA
			  AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA
    +AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA
    ------------------------------------------------------------------------
     AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA AAAAAAAA
*/

module mult_8x8 #(parameter DW = 8)
(
	input	[DW-1:0]	a,
	input	[DW-1:0]	b,
	output	[2*DW-1:0]	p
);

assign p = a*b;

endmodule

/*
module mult_8x8_x4 #(parameter DW = 8)
(
	input	[DW-1:0]	a1,
	input	[DW-1:0]	a2,
	input	[DW-1:0]	a3,
	input	[DW-1:0]	a4,
	
	input	[DW-1:0]	b1,
	input	[DW-1:0]	b2,
	input	[DW-1:0]	b3,
	input	[DW-1:0]	b4,
	
	output	[2*DW-1:0]	p1,
	output	[2*DW-1:0]	p2,
	output	[2*DW-1:0]	p3,
	output	[2*DW-1:0]	p4
);

mult_8x8 u1(.a(a1), .b(b1), .p(p1));
mult_8x8 u2(.a(a2), .b(b2), .p(p2));
mult_8x8 u3(.a(a3), .b(b3), .p(p3));
mult_8x8 u4(.a(a4), .b(b4), .p(p4));

endmodule*/

module mult_8x8_x4 #(parameter DW = 32)
(
	input	[DW-1:0]	a,
	input	[DW-1:0]	b,
	
	output	[2*DW-1:0]	p
);

wire [DW/2-1:0] p1, p2, p3, p4;

mult_8x8 u1(.a(a[7:0]), .b(b[7:0]), .p(p1));
mult_8x8 u2(.a(a[15:8]), .b(b[15:8]), .p(p2));
mult_8x8 u3(.a(a[23:16]), .b(b[23:16]), .p(p3));
mult_8x8 u4(.a(a[31:24]), .b(b[31:24]), .p(p4));

assign p = {p4, p3, p2, p1};

endmodule

module mult #(parameter DW = 32)
(
	input clk,
	input n_rst,
	
	input [2:0] op,
	
	input [DW-1:0] a,
	input [DW-1:0] b,
	
//	output [2*DW-1:0] res,
//	output [DW/2+1:0] Sum,
	output [2*DW+1:0] p
);

parameter MULT = 3'b001;//function one
parameter PIXL = 3'b010;//function two
parameter COMP = 3'b100;//function three

//two's-Complement to Sign-magnitude for func one
wire [DW-2:0] a_t;
wire [DW-1:0] a_w;
assign a_t = ~a[DW-2:0] + 1'b1;
assign a_w = a[DW-1] ? {a[DW-1], a_t} : a;

wire [DW-2:0] b_t;
wire [DW-1:0] b_w;
assign b_t = ~b[DW-2:0] + 1'b1;
assign b_w = b[DW-1] ? {b[DW-1], b_t} : b;

//two's-Complement to Sign-magnitude for func two
wire [DW/4-1:0]	a1_t, a2_t, a3_t, a4_t;
wire [DW/4-1:0] b1_t, b2_t, b3_t, b4_t;
wire [DW/4-1:0]	a1, a2, a3, a4;
wire [DW/4-1:0] b1, b2, b3, b4;

assign a1_t = ~a[6:0] + 1'b1;
assign a1 = a[7] ? {1'b1, a1_t} : a[7:0];
assign a2_t = ~a[14:8] + 1'b1;
assign a2 = a[15] ? {1'b1, a2_t} : a[15:8];
assign a3_t = ~a[22:16] + 1'b1;
assign a3 = a[23] ? {1'b1, a3_t} : a[23:16];
assign a4_t = ~a[30:24] + 1'b1;
assign a4 = a[31] ? {1'b1, a4_t} : a[31:24];

assign b1_t = ~b[6:0] + 1'b1;
assign b1 = b[7] ? {1'b1, b1_t} : b[7:0];
assign b2_t = ~b[14:8] + 1'b1;
assign b2 = b[15] ? {1'b1, b2_t} : b[15:8];
assign b3_t = ~b[22:16] + 1'b1;
assign b3 = b[23] ? {1'b1, b3_t} : b[23:16];
assign b4_t = ~b[30:24] + 1'b1;
assign b4 = b[31] ? {1'b1, b4_t} : b[31:24];

//two's-Complement to Sign-magnitude for func three
wire [DW/2-1:0] ca1_t, ca2_t;
wire [DW/2-1:0] cb1_t, cb2_t;
wire [DW/2-1:0] ca1, ca2;
wire [DW/2-1:0] cb1, cb2;

assign ca1_t = ~a[14:0] + 1'b1;
assign ca1 = a[15] ? {1'b1, ca1_t} : a[15:0];
assign ca2_t = ~a[30:16] + 1'b1;
assign ca2 = a[31] ? {1'b1, ca2_t} : a[31:16];

assign cb1_t = ~b[14:0] + 1'b1;
assign cb1 = b[15] ? {1'b1, cb1_t} : b[15:0];
assign cb2_t = ~b[30:16] + 1'b1;
assign cb2 = b[31] ? {1'b1, cb2_t} : b[31:16];


//The data organization for multiplication operation
reg [DW-1:0] 	tmp_a1, tmp_a2, tmp_a3, tmp_a4;
reg [DW-1:0] 	tmp_b1, tmp_b2, tmp_b3, tmp_b4;
wire [2*DW-1:0] tmp_r1, tmp_r2, tmp_r3, tmp_r4;
always @(*)
begin
	case(op)
	MULT://32*32 using 16 8*8
	begin
		tmp_a1 = {1'b0, a_w[DW-2:0]};
		tmp_a2 = {1'b0, a_w[DW-2:0]};
		tmp_a3 = {1'b0, a_w[DW-2:0]};
		tmp_a4 = {1'b0, a_w[DW-2:0]};
		tmp_b1 = {b_w[7:0], b_w[7:0], b_w[7:0], b_w[7:0]};
		tmp_b2 = {b_w[15:8], b_w[15:8], b_w[15:8], b_w[15:8]};
		tmp_b3 = {b_w[23:16], b_w[23:16], b_w[23:16], b_w[23:16]};
		tmp_b4 = {{1'b0,b_w[DW-2:24]}, {1'b0,b_w[DW-2:24]}, {1'b0,b_w[DW-2:24]}, {1'b0,b_w[DW-2:24]}};
	end
	PIXL://8*8 using 4 8*8
	begin
		tmp_a1 = {{1'b0, a4[6:0]}, {1'b0, a3[6:0]}, {1'b0, a2[6:0]}, {1'b0, a1[6:0]}};
		tmp_a2 = 32'b0;
		tmp_a3 = 32'b0;
		tmp_a4 = 32'b0;
		tmp_b1 = {{1'b0, b4[6:0]}, {1'b0, b3[6:0]}, {1'b0, b2[6:0]}, {1'b0, b1[6:0]}};
		tmp_b2 = 32'b0;
		tmp_b3 = 32'b0;
		tmp_b4 = 32'b0;
	end
	COMP://16*16 using 16 8*8
	begin
		tmp_a1 = {{1'b0,ca2[14:0]}, {1'b0,ca2[14:0]}};
		tmp_a2 = {{1'b0,ca1[14:0]}, {1'b0,ca1[14:0]}};
		tmp_a3 = {{1'b0,ca1[14:0]}, {1'b0,ca1[14:0]}};
		tmp_a4 = {{1'b0,ca2[14:0]}, {1'b0,ca2[14:0]}};
		tmp_b1 = {{1'b0,cb1[14:8]}, {1'b0,cb1[14:8]}, cb1[7:0], cb1[7:0]};
		tmp_b2 = {{1'b0,cb2[14:8]}, {1'b0,cb2[14:8]}, cb2[7:0], cb2[7:0]};
		tmp_b3 = {{1'b0,cb1[14:8]}, {1'b0,cb1[14:8]}, cb1[7:0], cb1[7:0]};
		tmp_b4 = {{1'b0,cb2[14:8]}, {1'b0,cb2[14:8]}, cb2[7:0], cb2[7:0]};
	end
	default:
	begin
		tmp_a1 = 32'b0;
		tmp_a2 = 32'b0;
		tmp_a3 = 32'b0;
		tmp_a4 = 32'b0;
		tmp_b1 = 32'b0;
		tmp_b2 = 32'b0;
		tmp_b3 = 32'b0;
		tmp_b4 = 32'b0;
	end
	endcase
end


/*
mult_8x8_x4 u1(.a1(), .a2(), .a3(), .a4(), .b1(), .b2(), .b3(), .b4(), .p1(), .p2(), .p3(), .p4());
mult_8x8_x4 u2(.a1(), .a2(), .a3(), .a4(), .b1(), .b2(), .b3(), .b4(), .p1(), .p2(), .p3(), .p4());
mult_8x8_x4 u3(.a1(), .a2(), .a3(), .a4(), .b1(), .b2(), .b3(), .b4(), .p1(), .p2(), .p3(), .p4());
mult_8x8_x4 u4(.a1(), .a2(), .a3(), .a4(), .b1(), .b2(), .b3(), .b4(), .p1(), .p2(), .p3(), .p4());*/

//Multiplication using 16 8*8 multiplers
mult_8x8_x4 u1(.a(tmp_a1), .b(tmp_b1), .p(tmp_r1));
mult_8x8_x4 u2(.a(tmp_a2), .b(tmp_b2), .p(tmp_r2));
mult_8x8_x4 u3(.a(tmp_a3), .b(tmp_b3), .p(tmp_r3));
mult_8x8_x4 u4(.a(tmp_a4), .b(tmp_b4), .p(tmp_r4));

//Multiplication operation result
reg [39:0]		tmp_p1, tmp_p2, tmp_p3, tmp_p4;
reg [2*DW-1:0] 	tmp_p,tmp_pt;
reg [DW/2+1:0]	tmp_s;
reg [DW-1:0]	tmp_u1, tmp_u2, tmp_u3, tmp_u4;
reg [DW:0]		tmp_u5, tmp_u6;
reg [2*DW+1:0]	tmp_u;

reg [DW/2-1:0]	c1, c2, c3, c4;
reg [2*DW-1:0]	cc1, cc2, cc3, cc4;
always @(*)
begin
	case(op)
	MULT: 
	begin
		tmp_p1 = {{24{1'b0}},tmp_r1[15:0]} + {{16{1'b0}},tmp_r1[31:16],{8{1'b0}}} + {{8{1'b0}},tmp_r1[47:32],{16{1'b0}}} + {tmp_r1[63:48],{24{1'b0}}};
		tmp_p2 = {{24{1'b0}},tmp_r2[15:0]} + {{16{1'b0}},tmp_r2[31:16],{8{1'b0}}} + {{8{1'b0}},tmp_r2[47:32],{16{1'b0}}} + {tmp_r2[63:48],{24{1'b0}}};
		tmp_p3 = {{24{1'b0}},tmp_r3[15:0]} + {{16{1'b0}},tmp_r3[31:16],{8{1'b0}}} + {{8{1'b0}},tmp_r3[47:32],{16{1'b0}}} + {tmp_r3[63:48],{24{1'b0}}};
		tmp_p4 = {{24{1'b0}},tmp_r4[15:0]} + {{16{1'b0}},tmp_r4[31:16],{8{1'b0}}} + {{8{1'b0}},tmp_r4[47:32],{16{1'b0}}} + {tmp_r4[63:48],{24{1'b0}}};
		tmp_pt = {{24{1'b0}},tmp_p1} + {{16{1'b0}},tmp_p2,{8{1'b0}}} + {{8{1'b0}},tmp_p3,{16{1'b0}}} + {tmp_p4,{24{1'b0}}};
		tmp_p  = a_w[DW-1]^b_w[DW-1] ? {1'b1, ~tmp_pt[2*DW-2:0]+1'b1} : tmp_pt;
	end
	PIXL:
	begin
		c4 = a4[7]^b4[7] ? {1'b1, ~tmp_r1[62:48]+1'b1} : tmp_r1[63:48];
		c3 = a3[7]^b3[7] ? {1'b1, ~tmp_r1[46:32]+1'b1} : tmp_r1[47:32];
		c2 = a2[7]^b2[7] ? {1'b1, ~tmp_r1[30:16]+1'b1} : tmp_r1[31:16];
		c1 = a1[7]^b1[7] ? {1'b1, ~tmp_r1[14:0]+1'b1}  : tmp_r1[15:0];
		tmp_s  = c4 + c3 + c2 + c1;
	end
	COMP:
	begin
		tmp_u1 = {{16{1'b0}},tmp_r1[15:0]} + {{8{1'b0}},tmp_r1[31:16],{8{1'b0}}} + {{8{1'b0}},tmp_r1[47:32],{8{1'b0}}} + {tmp_r1[63:48],{16{1'b0}}};
		tmp_u2 = {{16{1'b0}},tmp_r2[15:0]} + {{8{1'b0}},tmp_r2[31:16],{8{1'b0}}} + {{8{1'b0}},tmp_r2[47:32],{8{1'b0}}} + {tmp_r2[63:48],{16{1'b0}}};
		tmp_u3 = {{16{1'b0}},tmp_r3[15:0]} + {{8{1'b0}},tmp_r3[31:16],{8{1'b0}}} + {{8{1'b0}},tmp_r3[47:32],{8{1'b0}}} + {tmp_r3[63:48],{16{1'b0}}};
		tmp_u4 = {{16{1'b0}},tmp_r4[15:0]} + {{8{1'b0}},tmp_r4[31:16],{8{1'b0}}} + {{8{1'b0}},tmp_r4[47:32],{8{1'b0}}} + {tmp_r4[63:48],{16{1'b0}}};
		cc1 = ca2[15]^cb1[15] ? {1'b1, ~tmp_u1[30:0]+1'b1} : tmp_u1;
		cc2 = ca1[15]^cb2[15] ? {1'b1, ~tmp_u2[30:0]+1'b1} : tmp_u2;
		cc3 = ca1[15]^cb1[15] ? {1'b1, ~tmp_u3[30:0]+1'b1} : tmp_u3;
		cc4 = ca2[15]^cb2[15] ? tmp_u4 : {1'b1, ~tmp_u4[30:0]+1'b1};
		tmp_u5 = cc1 + cc2;
		tmp_u6 = cc3 + cc4;
		tmp_u  = {tmp_u5, tmp_u6};
	end
	default:
	begin
		tmp_p = 64'b0;
		tmp_s = 18'b0;
		tmp_u = 66'b0;
	end
	endcase
end

/*reg [2*DW+1:0] p_reg;
always @(posedge clk or negedge n_rst) 
begin
	if (~n_rst) 
		p_reg <= 66'h0;
	else
		p_reg <= op == MULT ? {2'b0,tmp_p} : (op == PIXL ? {48'b0,tmp_s} : (op == COMP ? tmp_u : 66'b0));
end

assign p = p_reg;*/

assign p = op == MULT ? {2'b0,tmp_p} : (op == PIXL ? {48'b0,tmp_s} : (op == COMP ? tmp_u : 66'b0));

endmodule