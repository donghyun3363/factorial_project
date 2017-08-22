`timescale 1ns/100ps
module tb_factorial();
	reg clk, tb_reset_n, tb_S_sel, tb_S_wr, tb_M_grant, tb_m_interrupt;
	reg [7:0] tb_S_address;
	reg [31:0] tb_S_din, tb_M_din;
	wire tb_M_req, tb_M_wr, tb_f_interrupt;
	wire [7:0] tb_M_address;
	wire [31:0] tb_S_dout, tb_M_dout;
	
	//instance factorial module
	factorial U0_factorial(.clk(clk),
								  .reset_n(tb_reset_n),
								  .S_sel(tb_S_sel),
								  .S_wr(tb_S_wr),
								  .S_address(tb_S_address),
								  .S_din(tb_S_din),
								  .M_grant(tb_M_grant),
								  .M_din(tb_M_din),
								  .m_interrupt(tb_m_interrupt),
								  .S_dout(tb_S_dout),
								  .M_req(tb_M_req),
								  .M_wr(tb_M_wr),
								  .M_address(tb_M_address),
								  .M_dout(tb_M_dout),
								  .f_interrupt(tb_f_interrupt));
	
	always #10 clk=~clk;	//generate clock
	
	initial
		begin
			//test 5!
			#0		clk=1'b1;	tb_reset_n=1'b0;	tb_S_sel=1'b0;	tb_S_wr=1'b0;	tb_M_grant=1'b0;	tb_m_interrupt=1'b0;	tb_S_address=8'h00;	tb_S_din=32'h00;	tb_M_din=32'h00;
			#20					tb_reset_n=1'b1;
			#20											tb_S_sel=1'b1;																			tb_S_address=8'h02;
			#40																tb_S_wr=1'b1;														tb_S_address=8'h00;	tb_S_din=5;
			#20																																		tb_S_address=8'h01;	tb_S_din=1;
			#20																																		tb_S_address=8'h03;	tb_S_din=1;
			#20											tb_S_sel=1'b0;																			tb_S_address=8'h00;	tb_S_din=0;
			#100																					tb_M_grant=1'b1;
			#480																					tb_M_grant=1'b0;
			
			#500																											tb_m_interrupt=1'b1;
			#35																					tb_M_grant=1'b1;
			#45																																															tb_M_din=20;
			#20																																															tb_M_din=0;		
			#40																					tb_M_grant=1'b0;	tb_m_interrupt=1'b0;
			#20																					tb_M_grant=1'b1;
			#180																					tb_M_grant=1'b0;
			
			#500																											tb_m_interrupt=1'b1;
			#40																					tb_M_grant=1'b1;
			#40																																															tb_M_din=60;
			#20																																															tb_M_din=0;
			#40																					tb_M_grant=1'b0;	tb_m_interrupt=1'b0;
			#20																					tb_M_grant=1'b1;
			#180																					tb_M_grant=1'b0;
	
			#500																											tb_m_interrupt=1'b1;
			#40																					tb_M_grant=1'b1;
			#40																																															tb_M_din=120;
			#20																																															tb_M_din=0;
			#40																					tb_M_grant=1'b0;	tb_m_interrupt=1'b0;
			#20											tb_S_sel=1'b1;	tb_S_wr=1'b0;														tb_S_address=8'h05;
			#20																																		tb_S_address=8'h06;
			#20																tb_S_wr=1'b1;														tb_S_address=8'h04;	tb_S_din=1;
			#20																																		tb_S_address=8'h00;	tb_S_din=0;
			
			//test 4! & more
			#40					tb_reset_n=1'b0;
			#20					tb_reset_n=1'b1;
			#20											tb_S_sel=1'b1;																			tb_S_address=8'h02;
			#40																tb_S_wr=1'b1;														tb_S_address=8'h00;	tb_S_din=4;
			#20																																		tb_S_address=8'h01;	tb_S_din=1;
			#20																																		tb_S_address=8'h03;	tb_S_din=1;
			#20											tb_S_sel=1'b0;																			tb_S_address=8'h00;	tb_S_din=0;
			#60																					tb_M_grant=1'b1;
			#200																					tb_M_grant=1'b0;
			
			#800																											tb_m_interrupt=1'b1;
			#35																					tb_M_grant=1'b1;
			#45																																															tb_M_din=12;
			#20																																															tb_M_din=0;		
			#40																					tb_M_grant=1'b0;	tb_m_interrupt=1'b0;
			#20																					tb_M_grant=1'b1;
			#180																					tb_M_grant=1'b0;
			
			#500																											tb_m_interrupt=1'b1;
			#40																					tb_M_grant=1'b1;
			#40																																															tb_M_din=24;
			#20																																															tb_M_din=0;
			#40																					tb_M_grant=1'b0;	tb_m_interrupt=1'b0;
			#20											tb_S_sel=1'b1;	tb_S_wr=1'b0;														tb_S_address=8'h05;
			#20																																		tb_S_address=8'h06;
			#20																tb_S_wr=1'b1;														tb_S_address=8'h04;	tb_S_din=1;
			#20																																		tb_S_address=8'h00;	tb_S_din=0;
			
			//test 0!
			#40					tb_reset_n=1'b0;
			#20					tb_reset_n=1'b1;
			#20											tb_S_sel=1'b1;																			tb_S_address=8'h02;
			#40																tb_S_wr=1'b1;														tb_S_address=8'h00;	tb_S_din=0;
			#20																																		tb_S_address=8'h01;	tb_S_din=1;
			#20																																		tb_S_address=8'h03;	tb_S_din=1;
			#20											tb_S_sel=1'b0;																			tb_S_address=8'h00;	tb_S_din=0;
			
			#60											tb_S_sel=1'b1;	tb_S_wr=1'b0;														tb_S_address=8'h05;
			#20																																		tb_S_address=8'h06;
			#20																tb_S_wr=1'b1;														tb_S_address=8'h04;	tb_S_din=1;
			#20																																		tb_S_address=8'h00;	tb_S_din=0;
			
			//test 1!
			#40					tb_reset_n=1'b0;
			#20					tb_reset_n=1'b1;
			#20											tb_S_sel=1'b1;																			tb_S_address=8'h02;
			#40																tb_S_wr=1'b1;														tb_S_address=8'h00;	tb_S_din=1;
			#20																																		tb_S_address=8'h01;	tb_S_din=1;
			#20																																		tb_S_address=8'h03;	tb_S_din=1;
			#20											tb_S_sel=1'b0;																			tb_S_address=8'h00;	tb_S_din=0;
			
			#60											tb_S_sel=1'b1;	tb_S_wr=1'b0;														tb_S_address=8'h05;
			#20																																		tb_S_address=8'h06;
			#20																tb_S_wr=1'b1;														tb_S_address=8'h04;	tb_S_din=1;
			#20																																		tb_S_address=8'h00;	tb_S_din=0;
			#60	$stop;
			
		end

endmodule
