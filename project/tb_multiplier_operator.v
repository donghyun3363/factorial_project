`timescale 1ns/100ps
module tb_multiplier_operator();
	reg clk, tb_reset_n, tb_op_start, tb_op_clear;
	reg [63:0] tb_multiplicand, tb_multiplier;
	wire [127:0] tb_result;
	wire [1:0] tb_state;
	
	//instance multiplier_operator module
	multiplier_operator U0_multiplier_operator(.clk(clk),
															 .reset_n(tb_reset_n),
															 .op_start(tb_op_start),
															 .op_clear(tb_op_clear),
															 .multiplicand(tb_multiplicand),
															 .multiplier(tb_multiplier),
															 .result(tb_result),
															 .state(tb_state));
	
	always #10 clk=~clk;	//generate clock
	
	initial
		begin
			#0		clk=1'b0;	tb_reset_n=1'b0;	tb_op_start=1'b0;	tb_op_clear=1'b0;	tb_multiplicand=64'h00;	tb_multiplier=64'h00;
			#25					tb_reset_n=1'b1;
			#40																							tb_multiplicand=2147483647;	tb_multiplier=-1431655766;
			#40											tb_op_start=1'b1;
			#700											tb_op_start=1'b0;
			#60	$stop;
		end
	
endmodule
