//////////////////////////////////////////////////////////////////////////////////////////////////
//TITLE : 32-Bit Carry Look Ahead Adder 
//FILE : cla32.v
//TESTBENCH : 
//ORGANIZATION : Kwangwoon Univ. Computer Engineering
//STUDENT ID : 2009720054
//STUDENT NAME : HyeonKi Lim(ddkook12@daum.net)
//PLATFORM : Windows 8
//SIMULATOR : ModelSim-Altera 10.1d
//COMPILER : Altera Quartus II 13.0 SP1
//TARGET BOARD : Altera DE2-70
//DESCRIPTION : This module is defined as 32-Bit Carry Look Ahead Adder 
//				    This module add two 32-Bit Inputs and 1-Bit Carry_in using eight 4-Bit CLA
//					 Then this module output 32-bit result and carry out
//LAST UPDATE : Dec. 5, 2013
///////////////////////////////////////////////////////////////////////////////////////////////////

//Declare 32-Bit Carry Look Ahead Adder 
module cla32(a, b, ci, s, co);
	//declare in/output varialbes
	input [31:0] a, b;
	input ci;
	output [31:0] s;
	output co;
	
	//declare carrys
	wire c1, c2, c3, c4, c5, c6, c7;
	
	//instance eight 4-bit carry look ahead adder
	cla4 U0_cla4(.a(a[3:0]), .b(b[3:0]), .ci(ci), .s(s[3:0]), .co(c1));
	cla4 U1_cla4(.a(a[7:4]), .b(b[7:4]), .ci(c1), .s(s[7:4]), .co(c2));
	cla4 U2_cla4(.a(a[11:8]), .b(b[11:8]), .ci(c2), .s(s[11:8]), .co(c3));
	cla4 U3_cla4(.a(a[15:12]), .b(b[15:12]), .ci(c3), .s(s[15:12]), .co(c4));
	cla4 U4_cla4(.a(a[19:16]), .b(b[19:16]), .ci(c4), .s(s[19:16]), .co(c5));
	cla4 U5_cla4(.a(a[23:20]), .b(b[23:20]), .ci(c5), .s(s[23:20]), .co(c6));
	cla4 U6_cla4(.a(a[27:24]), .b(b[27:24]), .ci(c6), .s(s[27:24]), .co(c7));
	cla4 U7_cla4(.a(a[31:28]), .b(b[31:28]), .ci(c7), .s(s[31:28]), .co(co));

endmodule
