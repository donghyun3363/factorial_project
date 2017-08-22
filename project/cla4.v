//////////////////////////////////////////////////////////////////////////////////////////////////
//TITLE : Carry Look Ahead Adder 
//FILE : cla4.v
//TESTBENCH : tb_cla4.v
//ORGANIZATION : Kwangwoon Univ. Computer Engineering
//STUDENT ID : 2010720149
//STUDENT NAME : DONGHYUN LEE
//PLATFORM : Windows 8
//SIMULATOR : ModelSim-Altera 10.1d
//COMPILER : Altera Quartus II 13.0 SP1
//TARGET BOARD : Altera DE2-70
//DESCRIPTION : This module is defined as 4-Bit Carry Look Ahead Adder 
//				    This module add two 4-Bit Inputs and 1-Bit Carry_in using four Full Adder and propagate, generate
//					 And Print results that Carry_out and 4-Bit Sum
//LAST UPDATE : Oct. 9, 2013
///////////////////////////////////////////////////////////////////////////////////////////////////

//Declare 4-Bit Carry Look Ahead Adder 
module cla4(a, b, ci, s, co);

input [3:0] a, b;		//declare two 4-bit input variable
input ci;				//declare 1-bit carry in variable
output [3:0] s;		//declare 4-bit output sum	variable
output co;				//declare 1-bit carry out variable

wire c1, c2, c3;		//declare three wire carry

fa_v2 U0_fa_v2(.a(a[0]), .b(b[0]), .ci(ci), .s(s[0]));	//instance full adder wite 1-bit & carry in
fa_v2 U1_fa_v2(.a(a[1]), .b(b[1]), .ci(c1), .s(s[1]));	//instance full adder wite 2-bit & carry
fa_v2 U2_fa_v2(.a(a[2]), .b(b[2]), .ci(c2), .s(s[2]));	//instance full adder wite 3-bit & carry 
fa_v2 U3_fa_v2(.a(a[3]), .b(b[3]), .ci(c3), .s(s[3]));	//instance full adder wite 4-bit & carry
clb4 	U4_clb4(.a(a), .b(b), .ci(ci), .c1(c1), .c2(c2), .c3(c3), .co(co));	//instance clb4 with three inputs and carrys

endmodule
