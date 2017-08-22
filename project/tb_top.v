`timescale 1ns/100ps
module tb_top();
	reg clk, tb_reset_n;
	reg tb_M_req, tb_M_wr;
	reg [7:0] tb_M_address;
	reg [31:0] tb_M_dout;
	wire tb_M_grant;
	wire [31:0] tb_M_din;
	wire tb_f_interrupt;
	wire tb_m_interrupt;
	
	//instance top mudule
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
			#0		clk=1'b0;	tb_reset_n=1'b0;	tb_M_req=1'b0;	tb_M_wr=1'b0;	tb_M_address=8'h00;	tb_M_dout=32'h00;
			//test of factorial
			#25					tb_reset_n=1'b1;
			#20											tb_M_req=1'b1;
			#20																					tb_M_address=8'h22;
			#40																tb_M_wr=1'b1;	tb_M_address=8'h20;	tb_M_dout=32'h04;
			#20																					tb_M_address=8'h21;	tb_M_dout=32'h01;
			#20																					tb_M_address=8'h23;	tb_M_dout=32'h01;
			#20											tb_M_req=1'b0;						tb_M_address=8'h00;	tb_M_dout=32'h00;
			#2085											tb_M_req=1'b1;
			#45																tb_M_wr=1'b0;	tb_M_address=8'h25;
			#20																					tb_M_address=8'h26;
			#20																tb_M_wr=1'b1;	tb_M_address=8'h24;	tb_M_dout=32'h01;
			#20											tb_M_req=1'b0;						
			#20											tb_M_req=1'b1;
			#100					tb_reset_n=1'b0;
			//test of memory(ram) - write
			#40					tb_reset_n=1'b1;
			#20																tb_M_wr=1'b1;	tb_M_address=8'h01;	tb_M_dout=32'h01;
			#20																					tb_M_address=8'h02;	tb_M_dout=32'h02;
			#20																					tb_M_address=8'h03;	tb_M_dout=32'h03;
			#20																					tb_M_address=8'h04;	tb_M_dout=32'h04;
			#20																					tb_M_address=8'h05;	tb_M_dout=32'h05;
			#20																					tb_M_address=8'h07;	tb_M_dout=32'h07;
			#20																					tb_M_address=8'h08;	tb_M_dout=32'h08;
			#20																					tb_M_address=8'h09;	tb_M_dout=32'h09;
			#20																					tb_M_address=8'h0a;	tb_M_dout=32'h0a;
			#20																					tb_M_address=8'h0b;	tb_M_dout=32'h0b;
			#20																					tb_M_address=8'h0c;	tb_M_dout=32'h0c;
			#20																					tb_M_address=8'h0d;	tb_M_dout=32'h0d;
			#20																					tb_M_address=8'h0e;	tb_M_dout=32'h0e;
			#20																					tb_M_address=8'h0f;	tb_M_dout=32'h0f;
			//test of memory(ram) - read
			#40																tb_M_wr=1'b0;	
			#20																					tb_M_address=8'h01;	tb_M_dout=32'h00;
         #20																					tb_M_address=8'h02;
         #20																					tb_M_address=8'h03;
         #20																					tb_M_address=8'h04;
         #20																					tb_M_address=8'h05;
         #20																					tb_M_address=8'h07;
         #20																					tb_M_address=8'h08;
         #20																					tb_M_address=8'h09;
         #20																					tb_M_address=8'h0a;
         #20																					tb_M_address=8'h0b;
         #20																					tb_M_address=8'h0c;
         #20																					tb_M_address=8'h0d;
         #20																					tb_M_address=8'h0e;
         #20																					tb_M_address=8'h0f;
			#40					tb_reset_n=1'b0;						tb_M_wr=1'b0;	
			//test of multiplier(two positive number)
			#40					tb_reset_n=1'b1;						tb_M_wr=1'b1;	tb_M_address=8'h40;	tb_M_dout=20;
			#20																					tb_M_address=8'h41;	tb_M_dout=0;
			#20																					tb_M_address=8'h42;	tb_M_dout=20;
			#20																					tb_M_address=8'h43;	tb_M_dout=0;
			#20																					tb_M_address=8'h48;	tb_M_dout=32'h01;
			#20																					tb_M_address=8'h4a;	tb_M_dout=32'h01;
			#40																					tb_M_address=8'h40;	tb_M_dout=5;
			#40											tb_M_req=1'b0;	tb_M_wr=1'b0;
			#640											tb_M_req=1'b1;	
			#20																					tb_M_address=8'h44;
			#20																					tb_M_address=8'h45;
			#20																					tb_M_address=8'h46;
			#20																					tb_M_address=8'h47;
			#20																tb_M_wr=1'b1;	tb_M_address=8'h4b;	tb_M_dout=32'h01;
			#20																tb_M_wr=1'b0;								tb_M_dout=32'h00;
			//test of multiplier(positive & negative number)
			#20																tb_M_wr=1'b1;	tb_M_address=8'h40;	tb_M_dout=20;
			#20																					tb_M_address=8'h41;	tb_M_dout=0;
			#20																					tb_M_address=8'h42;	tb_M_dout=-20;
			#20																					tb_M_address=8'h43;	tb_M_dout=-1;
			#20																					tb_M_address=8'h48;	tb_M_dout=32'h01;
			#20																					tb_M_address=8'h4a;	tb_M_dout=32'h01;
			#40											tb_M_req=1'b0;	tb_M_wr=1'b0;
			#675											tb_M_req=1'b1;	
			#20																					tb_M_address=8'h44;
			#20																					tb_M_address=8'h45;
			#20																					tb_M_address=8'h46;
			#20																					tb_M_address=8'h47;
			#20																tb_M_wr=1'b1;	tb_M_address=8'h4b;	tb_M_dout=32'h01;
			#20																tb_M_wr=1'b0;								tb_M_dout=32'h00;
			#160	$stop;
			
		end                                                                  
	                                                                        
endmodule                                                                                          
