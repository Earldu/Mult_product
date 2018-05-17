//-----------------------------------------------
//File Name		:Multiplication.v
//Project		:EDA工具及设计实践课程作业一
//Designer		:Earl Du
//Version		:1.1
//Description	:功能1：单纯乘累加
//-----------------------------------------------
//Revision History:
//
//Date			Rev.	By			Description
//-----------------------------------------------
//04/04/2018	0.1		Earl Du		first draft
//04/09/2018	0.2		Earl Du		fix overflow
//04/11/2018	1.0		Earl Du		new approach
//04/13/2018	1.1		Earl Du		new approach
//-----------------------------------------------

module Multiplication #(parameter DW = 32)
(
	input clk,
	input n_rst,

	input  [2*DW+1:0] res_t,
	
	output [2*DW-1:0] Mout
);

wire	[2*DW-1:0]  res;


assign res = res_t[2*DW-1:0];

//64bits add, you should contain add overflow
reg		[2*DW:0]	Mout_reg;
always@(posedge clk or negedge n_rst)
begin
	if (~n_rst)
		Mout_reg <= 65'h0;
	else
		begin
			if(Mout_reg[2*DW:2*DW-1] == 2'b10 || Mout_reg == 64'h8000_0000_0000_0000)//N+N=P overflow
				Mout_reg <= {1'b0, 64'h8000_0000_0000_0000};
			else if(Mout_reg[2*DW:2*DW-1] == 2'b01 || Mout_reg == 64'h7FFF_FFFF_FFFF_FFFF)//P+P=N overflow
				Mout_reg <= {1'b0, 64'h7FFF_FFFF_FFFF_FFFF};
			else
				Mout_reg <= Mout_reg + res;
		end
end

assign Mout = Mout_reg[2*DW-1:0];

endmodule