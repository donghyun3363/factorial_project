//Declare full adder to calculate sum
module fa_v2(a, b, ci, s);

input a, b, ci;	//declare 2-input & carry in variable
output s;			//declare 1-bit sum

//instance _xor3 with three inputs & sum
_xor3 U0_xor3(.a(a), .b(b), .c(ci), .y(s));

endmodule
