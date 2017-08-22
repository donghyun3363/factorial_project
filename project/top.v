//////////////////////////////////////////////////////////////////////////////////////////////////
//TITLE : Top module
//FILE : top.v
//TESTBENCH : tb_top.v
//ORGANIZATION : Kwangwoon Univ. Computer Engineering
//STUDENT ID : 2010720149
//STUDENT NAME : DONGHYUN LEE
//PLATFORM : Windows 8
//SIMULATOR : ModelSim-Altera 10.1d
//COMPILER : Altera Quartus II 13.0 SP1
//TARGET BOARD : Altera DE2-70
//DESCRIPTION : This module is defined as manager hardware
//				    This module manager to four component such as bus, factorial, multiplier and ram
//					 Therefore this module instance all component for connecting each other
//LAST UPDATE : Dec. 11, 2013
///////////////////////////////////////////////////////////////////////////////////////////////////

module top(clk,
			  reset_n,
			  M_req,
			  M_wr,
			  M_address,
			  M_dout,
			  M_grant,
			  M_din,
			  f_interrupt,
			  m_interrupt);
	
	//delcare input valriables
	input clk, reset_n;
	input M_req, M_wr;
	input [7:0] M_address;
	input [31:0] M_dout;
	output M_grant;	//delcare output grant variable
	
	//delcare wire variables
	wire M1_req, M1_wr;
	wire [7:0] M1_address;
	wire [31:0] M1_dout;
	wire M1_grant;
	
	output [31:0] M_din;	//declare output input variable
	
	//declare wire variables
	wire S0_sel, S1_sel, S2_sel;
	wire S_wr;
	wire [31:0] S_din;
	wire [7:0] S_address;
	wire [31:0] S0_dout, S1_dout, S2_dout;
	
	//declare interrupt variables
	output f_interrupt;
	output m_interrupt;
	
	//instance bus
	bus			U0_BUS(.clk(clk),
							 .reset_n(reset_n),
							 .M0_req(M_req),
							 .M0_address(M_address),
							 .M0_wr(M_wr),
							 .M0_dout(M_dout),
							 .M0_grant(M_grant),
							 .M1_req(M1_req),
							 .M1_address(M1_address),
							 .M1_wr(M1_wr),
							 .M1_dout(M1_dout),
							 .M1_grant(M1_grant),
							 .M_din(M_din),
							 .S0_sel(S0_sel),
							 .S1_sel(S1_sel),
							 .S2_sel(S2_sel),
							 .S_address(S_address),
							 .S_wr(S_wr),	
							 .S_din(S_din),		
							 .S0_dout(S0_dout),
							 .S1_dout(S1_dout),
							 .S2_dout(S2_dout));
	
	//instance ram
	ram			U1_RAM(.clk(clk),
							 .cen(S0_sel),
							 .wen(S_wr),
							 .addr(S_address[4:0]),
							 .din(S_din),
							 .dout(S0_dout));
	
	//instance factorial
	factorial	U2_FAC(.clk(clk),
							 .reset_n(reset_n),
							 .m_interrupt(m_interrupt),
							 .f_interrupt(f_interrupt),
//Slave	 
							 .S_sel(S1_sel),
							 .S_wr(S_wr),
							 .S_address(S_address),
							 .S_din(S_din),
							 .S_dout(S1_dout),
//Master  	 
							 .M_req(M1_req),
							 .M_wr(M1_wr),
							 .M_address(M1_address),
							 .M_dout(M1_dout),
							 .M_grant(M1_grant),
							 .M_din(M_din));

	//instance multiplier						 
	multiplier	U3_MUL(.clk(clk),
							 .reset_n(reset_n),
							 .S_sel(S2_sel),
							 .S_wr(S_wr),
							 .S_address(S_address),
							 .S_din(S_din),
							 .m_interrupt(m_interrupt),
							 .S_dout(S2_dout));
	
			  
endmodule
			  