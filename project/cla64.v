//////////////////////////////////////////////////////////////////////////////////////////////////
//TITLE : 64-Bit Carry Look Ahead Adder 
//FILE : cla64.v
//TESTBENCH : 
//ORGANIZATION : Kwangwoon Univ. Computer Engineering
//STUDENT ID : 2010720149
//STUDENT NAME : DONGHYUN LEE
//PLATFORM : Windows 8
//SIMULATOR : ModelSim-Altera 10.1d
//COMPILER : Altera Quartus II 13.0 SP1
//TARGET BOARD : Altera DE2-70
//DESCRIPTION : This module is defined as 64-Bit Carry Look Ahead Adder 
//				    This module add two 64-Bit Inputs and 1-Bit Carry_in using two 32-Bit CLA
//					 Then this module output 64-bit result and carry out
//LAST UPDATE : Dec. 5, 2013
///////////////////////////////////////////////////////////////////////////////////////////////////

//Declare 64-Bit Carry Look Ahead Adder 
module cla64(a, b, ci, s, co);

	input [63:0] a, b;	//declare two 64-bit input variables
	input ci;            //declare 1-bit carry in variable
	output [63:0] s;     //declare 64-bit output sum variable
	output co;				//declare 1-bit carry output varialbe
	
	wire c1;	//declare carry varialbe
	
	//instace 32-Bit Carry Look Ahead Adder with three input variables and output variables 
	cla32 U0_cla32(.a(a[31:0]), .b(b[31:0]), .ci(ci), .s(s[31:0]), .co(c1));
	cla32 U1_cla32(.a(a[63:32]), .b(b[63:32]), .ci(c1), .s(s[63:32]), .co(co));


endmodule
