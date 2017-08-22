`timescale 1ns/100ps

module tb_bus();
	reg 			clk, reset_n, tb_M0_req, tb_M0_wr, tb_M1_req, tb_M1_wr;
	reg [7:0]	tb_M0_address, tb_M1_address;
	reg [31:0] 	tb_M0_dout, tb_M1_dout, tb_S0_dout, tb_S1_dout, tb_S2_dout;
	wire 			tb_M0_grant, tb_M1_grant, tb_S0_sel, tb_S1_sel, tb_S2_sel, tb_S_wr;
	wire [7:0] 	tb_S_address;
	wire [31:0] tb_S_din, tb_M_din;
	
	//instance bus module
	bus	U0_bus  (.clk(clk), 
						.reset_n(reset_n), 
						.M0_req(tb_M0_req), 
						.M0_wr(tb_M0_wr), 
						.M0_address(tb_M0_address), 
						.M0_dout(tb_M0_dout), 
						.M1_req(tb_M1_req), 
						.M1_wr(tb_M1_wr), 
						.M1_address(tb_M1_address), 
						.M1_dout(tb_M1_dout), 
						.S0_dout(tb_S0_dout), 
						.S1_dout(tb_S1_dout), 
						.S2_dout(tb_S2_dout), 
						.M0_grant(tb_M0_grant), 
						.M1_grant(tb_M1_grant), 
						.M_din(tb_M_din), 
						.S0_sel(tb_S0_sel), 
						.S1_sel(tb_S1_sel), 
						.S2_sel(tb_S2_sel), 
						.S_address(tb_S_address), 
						.S_wr(tb_S_wr), 
						.S_din(tb_S_din));
	
	always #10 clk=~clk;	//generate clock
	
	initial
		begin
			#0		clk=1'b0;	reset_n=1'b0;	tb_M0_req=1'b0;	tb_M0_wr=1'b0;	tb_M1_req=1'b0;	tb_M1_wr=1'b0;	tb_M0_address=8'h00;	tb_M1_address=8'h00;	tb_M0_dout=32'h0000;	tb_M1_dout=32'h0000;	tb_S0_dout=32'h0000;	tb_S1_dout=32'h0000;	tb_S2_dout=32'h0000;
			//test of address decoder
			#25					reset_n=1'b1;	
			#20										tb_M0_req=1'b1;																																													tb_S0_dout=32'h0001;	tb_S1_dout=32'h0002;	tb_S2_dout=32'h0003;
			#20																tb_M0_wr=1'b1;
			#20																																tb_M0_address=8'h01;								tb_M0_dout=32'h0002;
			#20																																tb_M0_address=8'h02;								tb_M0_dout=32'h0004;
			#20																																tb_M0_address=8'h03;								tb_M0_dout=32'h0006;
			#20																																tb_M0_address=8'h20;								tb_M0_dout=32'h0020;
			#20																																tb_M0_address=8'h21;								tb_M0_dout=32'h0022;
			#20																																tb_M0_address=8'h22;								tb_M0_dout=32'h0024;
			#20																																tb_M0_address=8'h23;								tb_M0_dout=32'h0026;
			#20																																tb_M0_address=8'h40;								tb_M0_dout=32'h0040;
			#20																																tb_M0_address=8'h41;								tb_M0_dout=32'h0042;
			#20																																tb_M0_address=8'h42;								tb_M0_dout=32'h0044;
			#20																																tb_M0_address=8'h43;								tb_M0_dout=32'h0046;
			#20																																tb_M0_address=8'ha0;								tb_M0_dout=32'h00ff;
			//test of arbitrator
			#80					reset_n=1'b0;	tb_M0_req=1'b0;	tb_M0_wr=1'b0;	tb_M1_req=1'b0;	tb_M1_wr=1'b0;	tb_M0_address=8'h00;	tb_M1_address=8'h00;	tb_M0_dout=32'h0000;	tb_M1_dout=32'h0000;	tb_S0_dout=32'h0000;	tb_S1_dout=32'h0000;	tb_S2_dout=32'h0000;	
			#20					reset_n=1'b1;	
			#40										tb_M0_req=1'b1;
			#30										tb_M0_req=1'b0;
			#30																					tb_M1_req=1'b1;
			#30																					tb_M1_req=1'b0;
			#20										tb_M0_req=1'b1;						tb_M1_req=1'b1;
			#40										tb_M0_req=1'b0;						tb_M1_req=1'b0;
			#40										tb_M0_req=1'b1;						tb_M1_req=1'b1;
			#40										tb_M0_req=1'b0;						tb_M1_req=1'b0;
			#40										tb_M0_req=1'b1;						tb_M1_req=1'b1;
			#40										tb_M0_req=1'b0;						tb_M1_req=1'b0;
			#40										tb_M0_req=1'b1;						tb_M1_req=1'b1;
			#40										tb_M0_req=1'b0;						tb_M1_req=1'b0;
			#40										tb_M0_req=1'b1;						tb_M1_req=1'b1;
			#40										tb_M0_req=1'b0;						tb_M1_req=1'b0;
			#20										tb_M0_req=1'b1;
			#20																					tb_M1_req=1'b1;
			#30										tb_M0_req=1'b0;
			#30																					tb_M1_req=1'b0;
			#30	$stop;
			
		end

endmodule
