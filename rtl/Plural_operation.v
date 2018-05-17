//------------------------------------------------
//File Name		:Plural_operation.v
//Project		:EDA工具及设计实践课程作业一
//Designer		:Earl Du
//Version		:0.2
//Description	:功能3： 16位复数条件控制乘累加减
//------------------------------------------------
//Revision History:
//
//Date			Rev.	By			Description
//------------------------------------------------
//04/11/2018	0.1		Earl Du		first draft
//04/13/2018	0.2		Earl Du		second draft	
//------------------------------------------------

module Plural_operation #(parameter DW = 32)(
	input				clk,
	input				n_rst,
	input	[1:0]		ctrl,
	input	[2*DW+1:0]	tmp,

	output	[2*DW-1:0]	Mout
);

reg [DW+1:0] M_reg1, M_reg2;
reg [DW+1:0] M_reg3, M_reg4;
reg [2*DW-1:0] Mout_reg;

always @(posedge clk or negedge n_rst) 
begin
	if (~n_rst) 
	begin
		M_reg1 <= 34'b0;
		M_reg2 <= 34'b0;
		Mout_reg <= 64'h0;
	end
	case(ctrl)
	2'b01:
	begin
		M_reg1 <= M_reg1 + tmp[65:33];
		if(M_reg1[33:32] == 2'b10 || Mout_reg[63:32] == 32'h8000_0000)
			Mout_reg[63:32] = 32'h8000_0000;
		else if(M_reg1[33:32] == 2'b01 || Mout_reg[63:32] == 32'h7fff_ffff)
			Mout_reg[63:32] = 32'h7fff_ffff;
		else
			Mout_reg[63:32] = M_reg1[31:0];
	end
	2'b10:
	begin
		M_reg2 <= M_reg2 + ((tmp[65:64] == 2'b10 || tmp[65:64] == 2'b01) ? {3'b000, ~tmp[63:33]+1'b1} : {3'b111, ~tmp[63:33]+1'b1});
		if(M_reg2[33:32] == 2'b10 || Mout_reg[63:32] == 32'h8000_0000)
			Mout_reg[63:32] = 32'h8000_0000;
		else if(M_reg2[33:32] == 2'b01 || Mout_reg[63:32] == 32'h7fff_ffff)
			Mout_reg[63:32] = 32'h7fff_ffff;
		else
			Mout_reg[63:32] = M_reg2[31:0];		
	end
	default:
	begin
		M_reg1 <= 34'b0;
		M_reg2 <= 34'b0;
		Mout_reg <= 64'h0;
	end
	endcase

end

always @(posedge clk or negedge n_rst) 
begin
	if (~n_rst) 
	begin
		M_reg3 <= 34'b0;
		M_reg4 <= 34'b0;
		Mout_reg <= 64'h0;	
	end
	case(ctrl)
	2'b01:
	begin
		M_reg3 <= M_reg3  + tmp[32:0];
		if(M_reg3[33:32] == 2'b10 || Mout_reg[31:0] == 32'h8000_0000)
			Mout_reg[31:0] = 32'h8000_0000;
		else if(M_reg3[33:32] == 2'b01 || Mout_reg[31:0] == 32'h7fff_ffff)
			Mout_reg[31:0] = 32'h7fff_ffff;
		else
			Mout_reg[31:0] = M_reg3[31:0];
	end
	2'b10:
	begin
		M_reg4  <= M_reg4  + ((tmp[32:31] == 2'b10 || tmp[32:31] == 2'b01) ? {3'b000, ~tmp[30:0]+1'b1} : {3'b111, ~tmp[30:0]+1'b1});
		if(M_reg4[33:32] == 2'b10 || Mout_reg[31:0] == 32'h8000_0000)
			Mout_reg[31:0] = 32'h8000_0000;
		else if(M_reg4[33:32] == 2'b01 || Mout_reg[31:0] == 32'h7fff_ffff)
			Mout_reg[31:0] = 32'h7fff_ffff;
		else
			Mout_reg[31:0] = M_reg4[31:0];			
	end
	default:
	begin
		M_reg3 <= 34'b0;
		M_reg4 <= 34'b0;
		Mout_reg <= 64'h0;
	end
	endcase
end

assign Mout = Mout_reg;


endmodule