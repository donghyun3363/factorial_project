//Declare Carry Look Ahead 4-Bit Block
module clb4(a, b, ci, c1, c2, c3, co);

input [3:0] a, b;		//declare two 4-bit input variable
input ci;            //declare 1-bit carry in variable
output c1, c2, c3, co;	//declare 1~3bit carrys and carry out variable

wire [3:0] p, g;		//declare 4-bit wire variable

//declare each bit wires
wire w0_c1;
wire w0_c2, w1_c2;
wire w0_c3, w1_c3, w2_c3;
wire w0_co, w1_co, w2_co, w3_co;

//Calculate each bit Generate variables with instances
_and2 U0_and2(.a(a[0]), .b(b[0]), .y(g[0]));		//four instance _and2 module with input a, b
_and2 U1_and2(.a(a[1]), .b(b[1]), .y(g[1]));
_and2 U2_and2(.a(a[2]), .b(b[2]), .y(g[2]));
_and2 U3_and2(.a(a[3]), .b(b[3]), .y(g[3]));

//Calculate each bit Propagate variables with instances
_or2 U0_or2(.a(a[0]), .b(b[0]), .y(p[0]));		//four instance _or2 module with input a, b
_or2 U1_or2(.a(a[1]), .b(b[1]), .y(p[1]));
_or2 U2_or2(.a(a[2]), .b(b[2]), .y(p[2]));
_or2 U3_or2(.a(a[3]), .b(b[3]), .y(p[3]));

//Calculate 1-bit position carry out with instances
_and2 I0_and2(.a(p[0]), .b(ci), .y(w0_c1));		//instance _and2 or _or2 to calculate 1-bit position carry out
_or2	I1_or2(.a(w0_c1), .b(g[0]), .y(c1));

//Calculate 2-bit position carry out with instances
_and2 N0_and2(.a(p[1]), .b(g[0]), .y(w0_c2));		//instance _and2, _and3 or _or3 to calculate 2-bit position carry out
_and3 N1_and3(.a(p[1]), .b(p[0]), .c(ci), .y(w1_c2));
_or3 	N2_or3(.a(w0_c2), .b(w1_c2), .c(g[1]), .y(c2));

//Calculate 3-bit position carry out with instances
_and2 S0_and2(.a(p[2]), .b(g[1]), .y(w0_c3));				//instance _and2, _and3, _and4 or _or4 to calculate 3-bit position carry out
_and3 S1_and3(.a(p[2]), .b(p[1]), .c(g[0]), .y(w1_c3));
_and4 S2_and4(.a(p[2]), .b(p[1]), .c(p[0]), .d(ci), .y(w2_c3));
_or4	S3_or4(.a(w0_c3), .b(w1_c3), .c(w2_c3), .d(g[2]), .y(c3));

//Calculate 4-bit position carry out with instances
_and2 T0_and2(.a(p[3]), .b(g[2]), .y(w0_co));				//instance _and2, _and3, _and4, _and5 or _or5 to calculate 4-bit position carry out
_and3 T1_and3(.a(p[3]), .b(p[2]), .c(g[1]), .y(w1_co));		
_and4 T2_and4(.a(p[3]), .b(p[2]), .c(p[1]), .d(g[0]), .y(w2_co));
_and5 T3_and5(.a(p[3]), .b(p[2]), .c(p[1]), .d(p[0]), .e(ci), .y(w3_co));
_or5	T4_or5(.a(w0_co), .b(w1_co), .c(w2_co), .d(w3_co), .e(g[3]), .y(co));

endmodule
