
`timescale 1ns/1ps

module tb_hwalu (); /* this is automatically generated */


	reg rst;
	reg clk;

	// clock
	initial begin
		clk = 1;
		forever #1 clk = ~clk;
	end

	// reset
	initial begin

		rst = 0;
		#2
		rst = 1;
		#1
		rst = 0;

	end

	// (*NOTE*) replace reset, clock, others

	wire [63:0] result;
	reg [31:0] operanda;
	reg [31:0] operandb;
	reg        accmu;
	reg  ctrl;
	reg  [3:0] opcode;




	reg [31:0] operanda1;
	reg [31:0] operandb1;


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



	hwalu inst_hwalu
		(
			//output
			.result   (result),
			//input
			.clk      (clk),
			.rst      (rst),
			.ctrl     (ctrl),
			.operanda (operanda1),
			.operandb (operandb1),
			.accmu    (accmu),
			.opcode   (opcode)
		);



	// ortoco #(.WIDTH(32)) cov1(/*autoinst*/
	// 		.out(operanda1),
	// 		.in(operanda));	

	// ortoco #(.WIDTH(32)) cov2(/*autoinst*/
	// 		.out(operandb1),
	// 		.in(operandb));

always @(*) begin
casex(opcode[3:2])
	2'b00: begin
		operanda1 = operanda;
		operandb1 = operandb;
		end
	2'b01: begin 
		operanda1 = {a1,a2,a3,a4};
		operandb1 = {b1,b2,b3,b4};

		end
	2'b10: begin
		operanda1 = {ca1,ca2};
		operandb1 = {cb1,cb2};
		end 
endcase
end

assign complex_sumhi = result[63:32] ;
assign complex_sumlo = result[31:0] ;

//
//  opcode[3:2]:
//		00   muladd
//		01   dotsum
//		10   complex 16x16
//
//  opcode[1:0]:
//      11  :  63:48	
//		10  :  47:32
//		01  :  31:16
//      00  :  15:0


	initial begin

//   this muladd test
	#2
	rst=1;


	///
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


	///

	
	
	ctrl=0;
	opcode[3:0]=4'b0000;
	operanda=32'h0;
	operandb=32'h0;
	accmu=1;
	#2
	rst=0;
	opcode[3:0]=4'b0000;
	accmu=1;
	operanda=32'h0000_01ff;
	operandb=32'h0000_01ff;    ///   expect: res=3fc01;
	#2
	operanda=32'h0030_0001;    
	operandb=32'h0020_0001;    ///   expect: res=600_0053_fc02
	#2
	operanda=32'h8020_0001;    
	operandb=32'h8010_0001;    ///   expect: res=3fe8_07ff_0083_fc03

	#3
	


	
//  this is dot
	#3
	rst=1;
	accmu=0;
	#2
	rst=0;
	#2
	
	opcode[3:0]=4'b0100;

	a1=8'h12;
	a2=8'h03;
	a3=8'h04;
	a4=8'h21;

	b1=8'h42;
	b2=8'h11;
	b3=8'h56;
	b4=8'hf1;
	//operanda=32'h1000_00ff;
	//operandb=32'h1000_00ff;     ///   expect: res=440
	#6                            ///   expect: res=880

// complex

	#2
	rst=1;
	#2
	rst=0;
	#2
	opcode[3:0]=4'b1000;
	
	ctrl=0;
	//operanda=32'h1000_00ff;
	//operandb=32'h1000_00ff;

	ca1=16'h0200;
	ca2=16'hf000;
	cb1=16'hf020;
	cb2=16'h0230;         ///   expect: res=102_6000_fffc_c000

	#4
	ctrl=1;
	//operanda=32'h1000_00ff;
	//operandb=32'h1000_00ff;
	ca1=16'h0200;
	ca2=16'hf000;
	cb1=16'hf020;
	cb2=16'h0230;         ///   expect: res=fefd_a000_0003_4000

	#100
		$finish;
	end


	// dump wave
	initial begin
		  $fsdbDumpon;
          $fsdbDumpfile("tb_hwalu.fsdb");
          $fsdbDumpvars(0,tb_hwalu);
	end

endmodule
