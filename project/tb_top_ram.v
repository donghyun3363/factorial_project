`timescale 1ns/100ps
module tb_top_ram();
	reg clk, tb_reset_n;
	reg tb_M_req, tb_M_wr;
	reg [7:0] tb_M_address;
	reg [31:0] tb_M_dout;
	wire tb_M_grant;
	wire [31:0] tb_M_din;
	wire tb_f_interrupt;
	wire tb_m_interrupt;
	
	//Instance top module
	top	U0_TOP(	.clk(clk),
						.reset_n(tb_reset_n),
						.M_req(tb_M_req),
						.M_wr(tb_M_wr),
						.M_address(tb_M_address),
						.M_dout(tb_M_dout),
						.M_grant(tb_M_grant),
						.M_din(tb_M_din),
						.f_interrupt(tb_f_interrupt),
						.m_interrupt(tb_m_interrupt));
	
	always #10 clk=~clk;	//generate clock
	
	initial
		begin
			//data write to memory 00~1f(h)
			#0		clk=1'b0;	tb_reset_n=1'b0;	tb_M_req=1'b0;	tb_M_wr=1'b0;	tb_M_address=8'h00;	tb_M_dout=32'h00;
			#25					tb_reset_n=1'b1;
			#20											tb_M_req=1'b1;	tb_M_wr=1'b1;
			#20																					tb_M_address=8'h01;	tb_M_dout=32'h01;
			#20																					tb_M_address=8'h02;	tb_M_dout=32'h02;
			#20																					tb_M_address=8'h03;	tb_M_dout=32'h03;
			#20																					tb_M_address=8'h04;	tb_M_dout=32'h04;
			#20																					tb_M_address=8'h05;	tb_M_dout=32'h05;
			#20																					tb_M_address=8'h06;	tb_M_dout=32'h06;
			#20																					tb_M_address=8'h07;	tb_M_dout=32'h07;
			#20																					tb_M_address=8'h08;	tb_M_dout=32'h08;
			#20																					tb_M_address=8'h09;	tb_M_dout=32'h09;
			#20																					tb_M_address=8'h0a;	tb_M_dout=32'h0a;
			#20																					tb_M_address=8'h0b;	tb_M_dout=32'h0b;
			#20																					tb_M_address=8'h0c;	tb_M_dout=32'h0c;
			#20																					tb_M_address=8'h0d;	tb_M_dout=32'h0d;
			#20																					tb_M_address=8'h0e;	tb_M_dout=32'h0e;
			#20																					tb_M_address=8'h0f;	tb_M_dout=32'h0f;
			#20																					tb_M_address=8'h10;	tb_M_dout=32'h10;
			#20																					tb_M_address=8'h11;	tb_M_dout=32'h11;
			#20																					tb_M_address=8'h12;	tb_M_dout=32'h12;
			#20																					tb_M_address=8'h13;	tb_M_dout=32'h13;
			#20																					tb_M_address=8'h14;	tb_M_dout=32'h14;
			#20																					tb_M_address=8'h15;	tb_M_dout=32'h15;
			#20																					tb_M_address=8'h16;	tb_M_dout=32'h16;
			#20																					tb_M_address=8'h17;	tb_M_dout=32'h17;
			#20																					tb_M_address=8'h18;	tb_M_dout=32'h18;
			#20																					tb_M_address=8'h19;	tb_M_dout=32'h19;
			#20																					tb_M_address=8'h1a;	tb_M_dout=32'h1a;
			#20																					tb_M_address=8'h1b;	tb_M_dout=32'h1b;
			#20																					tb_M_address=8'h1c;	tb_M_dout=32'h1c;
			#20																					tb_M_address=8'h1d;	tb_M_dout=32'h1d;
			#20																					tb_M_address=8'h1e;	tb_M_dout=32'h1e;
			#20																					tb_M_address=8'h1f;	tb_M_dout=32'h1f;
			
			// data read 00~1f(h)
			#20																tb_M_wr=1'b0;	tb_M_address=8'h00;	tb_M_dout=32'h00;
			#20																					tb_M_address=8'h01;
			#20																					tb_M_address=8'h02;
			#20																					tb_M_address=8'h03;
			#20																					tb_M_address=8'h04;
			#20																					tb_M_address=8'h05;
			#20																					tb_M_address=8'h06;
			#20																					tb_M_address=8'h07;
			#20																					tb_M_address=8'h08;
			#20																					tb_M_address=8'h09;
			#20																					tb_M_address=8'h0a;
			#20																					tb_M_address=8'h0b;
			#20																					tb_M_address=8'h0c;
			#20																					tb_M_address=8'h0d;
			#20																					tb_M_address=8'h0e;
			#20																					tb_M_address=8'h0f;
			#20																					tb_M_address=8'h10;
			#20																					tb_M_address=8'h11;
			#20																					tb_M_address=8'h12;
			#20																					tb_M_address=8'h13;
			#20																					tb_M_address=8'h14;
			#20																					tb_M_address=8'h15;
			#20																					tb_M_address=8'h16;
			#20																					tb_M_address=8'h17;
			#20																					tb_M_address=8'h18;
			#20																					tb_M_address=8'h19;
			#20																					tb_M_address=8'h1a;
			#20																					tb_M_address=8'h1b;
			#20																					tb_M_address=8'h1c;
			#20																					tb_M_address=8'h1d;
			#20																					tb_M_address=8'h1e;
			#20																					tb_M_address=8'h1f;
			#40					tb_reset_n=1'b0;	tb_M_req=1'b0;	tb_M_wr=1'b0;	tb_M_address=8'h00;	
	
			#60	$stop;
			
		end                                                                  
	                                                                        
endmodule                                                                                          
