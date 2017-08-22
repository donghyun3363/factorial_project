`timescale 1ns/100ps

module tb_ram();
	reg clk, tb_cen, tb_wen;
	reg [7:0] tb_addr;
	reg [31:0] tb_din;
	wire [31:0] tb_dout;
	
	//instance ram module
	ram	U0_ram(.clk(clk), .cen(tb_cen), .wen(tb_wen), .addr(tb_addr), .din(tb_din), .dout(tb_dout));
					 
	always #10	clk=~clk;	//generate clock
	
	initial
		begin
			#0	clk=1'b0;	tb_cen=1'b0;	tb_wen=1'b0;	tb_addr=8'h00;	tb_din=32'h0000;
			//test of write
			#20				tb_cen=1'b1;	tb_wen=1'b1;
			#20														tb_addr=8'h01;	tb_din=32'h0001;
			#20														tb_addr=8'h02;	tb_din=32'h0002;
			#20														tb_addr=8'h03;	tb_din=32'h0003;
			#20														tb_addr=8'h04;	tb_din=32'h0004;
			#20														tb_addr=8'h05;	tb_din=32'h0005;
			#20														tb_addr=8'h06;	tb_din=32'h0006;
			#20														tb_addr=8'h07;	tb_din=32'h0007;
			#20														tb_addr=8'h08;	tb_din=32'h0008;
			#20														tb_addr=8'h09;	tb_din=32'h0009;
			#20														tb_addr=8'h0a;	tb_din=32'h000a;
			#20														tb_addr=8'h0b;	tb_din=32'h000b;
			#20														tb_addr=8'h0c;	tb_din=32'h000c;
			#20														tb_addr=8'h0d;	tb_din=32'h000d;
			#20														tb_addr=8'h0e;	tb_din=32'h000e;
			#20														tb_addr=8'h0f;	tb_din=32'h000f;
			#20														tb_addr=8'h10;	tb_din=32'h0010;
			#20														tb_addr=8'h11;	tb_din=32'h0011;
			#20														tb_addr=8'h12;	tb_din=32'h0012;
			#20														tb_addr=8'h13;	tb_din=32'h0013;
			#20														tb_addr=8'h14;	tb_din=32'h0014;
			#20														tb_addr=8'h15;	tb_din=32'h0015;
			#20														tb_addr=8'h16;	tb_din=32'h0016;
			#20														tb_addr=8'h17;	tb_din=32'h0017;
			#20														tb_addr=8'h18;	tb_din=32'h0018;
			#20														tb_addr=8'h19;	tb_din=32'h0019;
			#20														tb_addr=8'h1a;	tb_din=32'h001a;
			#20														tb_addr=8'h1b;	tb_din=32'h001b;
			#20														tb_addr=8'h1c;	tb_din=32'h001c;
			#20														tb_addr=8'h1d;	tb_din=32'h001d;
			#20														tb_addr=8'h1e;	tb_din=32'h001e;
			#20														tb_addr=8'h1f;	tb_din=32'h001f;
			//test of read
			#40				tb_cen=1'b0;	tb_wen=1'b0;	tb_addr=8'h00;	tb_din=32'h0000;
			#40				tb_cen=1'b1;
			#40														tb_addr=8'h01;
			#20														tb_addr=8'h02;
		   #20														tb_addr=8'h03;
			#20														tb_addr=8'h04;
			#20														tb_addr=8'h05;
			#20														tb_addr=8'h06;
         #20														tb_addr=8'h07;
         #20														tb_addr=8'h08;
         #20														tb_addr=8'h09;
         #20														tb_addr=8'h0a;
         #20														tb_addr=8'h0b;
         #20														tb_addr=8'h0c;
         #20														tb_addr=8'h0d;
         #20														tb_addr=8'h0e;
         #20														tb_addr=8'h0f;
         #20														tb_addr=8'h10;
         #20														tb_addr=8'h11;
         #20														tb_addr=8'h12;
         #20														tb_addr=8'h13;
         #20														tb_addr=8'h14;
         #20														tb_addr=8'h15;
         #20														tb_addr=8'h16;
         #20														tb_addr=8'h17;
         #20														tb_addr=8'h18;
         #20														tb_addr=8'h19;
         #20														tb_addr=8'h1a;
         #20														tb_addr=8'h1b;
         #20														tb_addr=8'h1c;
         #20														tb_addr=8'h1d;
         #20														tb_addr=8'h1e;
         #20														tb_addr=8'h1f;
			#40				tb_cen=1'b0;
			#40	$stop;
		end
         	      
endmodule
