`timescale 1ns/100ps
module tb_multiplier();
	reg clk, tb_reset_n, tb_S_sel, tb_S_wr;
	reg [7:0] tb_S_address;
	reg [31:0] tb_S_din;
	wire [31:0] tb_S_dout;
	wire tb_m_interrupt;

	//instance multiplier module
	multiplier U0_multiplier(.clk(clk), .reset_n(tb_reset_n), .S_sel(tb_S_sel), .S_wr(tb_S_wr), .S_address(tb_S_address), .S_din(tb_S_din), .S_dout(tb_S_dout), .m_interrupt(tb_m_interrupt));
	
	always #10 clk=~clk;	//generate clock
	
	initial
		begin
			//test product of each positive integers
			#0		clk=1'b0;	tb_reset_n=1'b0;	tb_S_sel=1'b0;	tb_S_wr=1'b0;	tb_S_address=8'h00;	tb_S_din=32'h00;
			#25					tb_reset_n=1'b1;
			#40											tb_S_sel=1'b1; tb_S_wr=1'b1;								tb_S_din=20;
			#20																					tb_S_address=8'h01;	tb_S_din=0;
			#20																					tb_S_address=8'h02;	tb_S_din=20;
			#20																					tb_S_address=8'h03;	tb_S_din=0;
			#20																					tb_S_address=8'h08;	tb_S_din=1;
			#20																					tb_S_address=8'h0a;	
			#20																												tb_S_din=32'h0;
			#685																tb_S_wr=1'b0;	tb_S_address=8'h04;
			#20																					tb_S_address=8'h05;
			#20																					tb_S_address=8'h06;
			#20																					tb_S_address=8'h07;
			#20																tb_S_wr=1'b1;	tb_S_address=8'h0b;	tb_S_din=32'h1;
			#40					tb_reset_n=1'b0;	tb_S_sel=1'b0;	tb_S_wr=1'b0;	tb_S_address=8'h00;	tb_S_din=32'h00;
			
			//test product of each negative integers
			#20					tb_reset_n=1'b1;
			#40											tb_S_sel=1'b1; tb_S_wr=1'b1;	tb_S_address=8'h00;	tb_S_din=-20;
			#20																					tb_S_address=8'h01;	tb_S_din=-1;
			#20																					tb_S_address=8'h02;	tb_S_din=-20;
			#20																					tb_S_address=8'h03;	tb_S_din=-1;
			#20																					tb_S_address=8'h08;	tb_S_din=1;
			#20																					tb_S_address=8'h0a;	
			#20																												tb_S_din=32'h0;
			#685																tb_S_wr=1'b0;	tb_S_address=8'h04;
			#20																					tb_S_address=8'h05;
			#20																					tb_S_address=8'h06;
			#20																					tb_S_address=8'h07;
			#20																tb_S_wr=1'b1;	tb_S_address=8'h0b;	tb_S_din=32'h1;
			#40					tb_reset_n=1'b0;	tb_S_sel=1'b0;	tb_S_wr=1'b0;	tb_S_address=8'h00;	tb_S_din=32'h00;
			
			//test product of positive & negative integers
			#20					tb_reset_n=1'b1;
			#40											tb_S_sel=1'b1; tb_S_wr=1'b1;	tb_S_address=8'h00;	tb_S_din=20;
			#20																					tb_S_address=8'h01;	tb_S_din=0;
			#20																					tb_S_address=8'h02;	tb_S_din=-20;
			#20																					tb_S_address=8'h03;	tb_S_din=-1;
			#20																					tb_S_address=8'h08;	tb_S_din=1;
			#20																					tb_S_address=8'h0a;	
			#20																												tb_S_din=32'h0;
			#685																tb_S_wr=1'b0;	tb_S_address=8'h04;
			#20																					tb_S_address=8'h05;
			#20																					tb_S_address=8'h06;
			#20																					tb_S_address=8'h07;
			#20																tb_S_wr=1'b1;	tb_S_address=8'h0b;	tb_S_din=32'h1;
			#40					tb_reset_n=1'b0;	tb_S_sel=1'b0;	tb_S_wr=1'b0;	tb_S_address=8'h00;	tb_S_din=32'h00;
			
			//test product of negative & positive integers
			#20					tb_reset_n=1'b1;
			#40											tb_S_sel=1'b1; tb_S_wr=1'b1;	tb_S_address=8'h00;	tb_S_din=-20;
			#20																					tb_S_address=8'h01;	tb_S_din=-1;
			#20																					tb_S_address=8'h02;	tb_S_din=20;
			#20																					tb_S_address=8'h03;	tb_S_din=0;
			#20																					tb_S_address=8'h08;	tb_S_din=1;
			#20																					tb_S_address=8'h0a;	
			#20																												tb_S_din=32'h0;
			#685																tb_S_wr=1'b0;	tb_S_address=8'h04;
			#20																					tb_S_address=8'h05;
			#20																					tb_S_address=8'h06;
			#20																					tb_S_address=8'h07;
			#20																tb_S_wr=1'b1;	tb_S_address=8'h0b;	tb_S_din=32'h1;
			#40					tb_reset_n=1'b0;	tb_S_sel=1'b0;	tb_S_wr=1'b0;	tb_S_address=8'h00;	tb_S_din=32'h00;
			
			//test product of integers & zero
			#20					tb_reset_n=1'b1;
			#40											tb_S_sel=1'b1; tb_S_wr=1'b1;	tb_S_address=8'h00;	tb_S_din=20;
			#20																					tb_S_address=8'h01;	tb_S_din=0;
			#20																					tb_S_address=8'h02;	tb_S_din=0;
			#20																					tb_S_address=8'h03;	tb_S_din=0;
			#20																					tb_S_address=8'h08;	tb_S_din=1;
			#20																					tb_S_address=8'h0a;	
			#20																												tb_S_din=32'h0;
			#685																tb_S_wr=1'b0;	tb_S_address=8'h04;
			#20																					tb_S_address=8'h05;
			#20																					tb_S_address=8'h06;
			#20																					tb_S_address=8'h07;
			#20																tb_S_wr=1'b1;	tb_S_address=8'h0b;	tb_S_din=32'h1;
			#40					tb_reset_n=1'b0;	tb_S_sel=1'b0;	tb_S_wr=1'b0;	tb_S_address=8'h00;	tb_S_din=32'h00;
			
			#40	$stop;
			
		end
		
endmodule
