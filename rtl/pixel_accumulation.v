//---------------------------------------------
//File Name		:pixel_accumulation.v
//Project		:EDA工具及设计实践课程作业一
//Designer		:Earl Du
//Version		:1.1
//Description	:功能2：4个8*8像素点积累加
//---------------------------------------------
//Revision History:
//
//Date			Rev.	By			Description
//---------------------------------------------
//04/04/2018	0.1		Earl Du		first draft
//04/09/2018	0.2		Earl Du		fix overflow
//04/11/2018	1.0		Earl Du		new approach
//04/13/2018	1.1		Earl Du		new approach		 
//---------------------------------------------

module pixel_accumulation #(parameter DW = 32)
(
	input				clk,
	input				n_rst,
	input	[1:0]		ww,
	input	[2*DW+1:0]	Sum,

	output	[2*DW-1:0]	Mout
);


reg [17:0] Mout_reg1,Mout_reg2,Mout_reg3,Mout_reg4;
reg [63:0] Mout_tmp;
always @(posedge clk or negedge n_rst)
begin
	if (~n_rst)
		begin
			Mout_reg1 <= 18'b0;
			Mout_reg2 <= 18'b0;
			Mout_reg3 <= 18'b0;
			Mout_reg4 <= 18'b0;
			Mout_tmp  <= 64'b0;
		end
	else
		begin
			case(ww)
				2'b11:
					begin
						Mout_reg1 <= Mout_reg1 + Sum[15:0];
						if(Mout_reg1[17:16] == 2'b10 || Mout_reg1[15:0] == 16'h8000)
						begin
							Mout_reg1[15:0] <= 18'h28000;
							Mout_tmp[63:48] <= 16'h8000;
						end
						else if(Mout_reg1[17:16] == 2'b01 || Mout_reg1[15:0] == 16'h7fff)
						begin
							Mout_reg1[15:0] <= 18'h17fff;
							Mout_tmp[63:48] <= 16'h7fff;
						end
						else
							Mout_tmp[63:48] <= Mout_reg1[15:0];
					end
				2'b10:
					begin
						Mout_reg2 <= Mout_reg2 + Sum[15:0];
						if(Mout_reg2[17:16] == 2'b10 || Mout_reg2[15:0] == 16'h8000)
							begin
							Mout_reg2[15:0] <= 18'h28000;
							Mout_tmp[47:32] <= 16'h8000;
						end
						else if(Mout_reg2[17:16] == 2'b01 || Mout_reg2[15:0] == 16'h7fff)
							begin
							Mout_reg2[15:0] <= 18'h17fff;
							Mout_tmp[47:32] <= 16'h7fff;
						end
						else
							Mout_tmp[47:32] <= Mout_reg2[15:0];
					end
				2'b01:
					begin
						Mout_reg3 <= Mout_reg3 + Sum[15:0];
						if(Mout_reg3[17:16] == 2'b10 || Mout_reg3[15:0] == 16'h8000)
							begin
							Mout_reg3[15:0] <= 18'h28000;
							Mout_tmp[31:16] <= 16'h8000;
						end
						else if(Mout_reg3[17:16] == 2'b01 || Mout_reg3[15:0] == 16'h7fff)
							begin
							Mout_reg3[15:0] <= 18'h17fff;
							Mout_tmp[31:16] <= 16'h7fff;
						end
						else
							Mout_tmp[31:16] <= Mout_reg3[15:0];
					end
				2'b00:
					begin
						Mout_reg4 <= Mout_reg4 + Sum[15:0];
						if(Mout_reg4[17:16] == 2'b10 || Mout_reg4[15:0] == 16'h8000)
							begin
							Mout_reg4[17:0] <= 19'h28000;
							Mout_tmp[15:0] <= 16'h8000;
						end
						else if(Mout_reg4[17:16] == 2'b01 || Mout_reg4[15:0] == 16'h7fff)
							begin
							Mout_reg4[17:0] <= 19'h17fff;
							Mout_tmp[15:0] <= 16'h7fff;
						end
						else
							Mout_tmp[15:0] <= Mout_reg4[15:0];
					end
				default: Mout_tmp <= 64'h0;
			endcase
		end
end

assign Mout = Mout_tmp;

endmodule
