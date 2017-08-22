//////////////////////////////////////////////////////////////////////////////////////////////////
//TITLE : Memory hardware(RAM)
//FILE : ram.v
//TESTBENCH : tb_ram.v
//ORGANIZATION : Kwangwoon Univ. Computer Engineering
//STUDENT ID : 2009720054
//STUDENT NAME : HyeonKi Lim(ddkook12@daum.net)
//PLATFORM : Windows 8
//SIMULATOR : ModelSim-Altera 10.1d
//COMPILER : Altera Quartus II 13.0 SP1
//TARGET BOARD : Altera DE2-70
//DESCRIPTION : This module is defined as storage facilities
//				    This module is made up 32*32 matrix storage space
//					 As a result, operate read & write as input cen, wen signal
//LAST UPDATE : Dec. 11, 2013
///////////////////////////////////////////////////////////////////////////////////////////////////

module ram(clk, 
			  cen, 
			  wen, 
			  addr, 
			  din, 
			  dout);
	
	//declare inputs & output variables
	input clk, cen, wen;
	input [4:0] addr;
	input [31:0] din;
	output reg [31:0] dout;

	//declare mem variables to matrix
	reg [31:0] mem [0:31];
	
	integer i;
	
	//define initial mem variables
	initial
		begin
			for(i=0; i<32; i=i+1) begin
				mem[i]=32'h00;
			end
		end
	
	always@(posedge clk)
		begin
			if(cen & wen) begin	//if selected ram and write signal is 1, write in memory
				mem[addr]=din;
				dout=32'h00;
			end
			else if(cen & !wen)	dout=mem[addr];	//if selected ram and read signal is 1, output the address data
			else if(!cen)			dout=32'h00;		//if ram isn't ram, output 0
			else						dout=32'hxx;		//else output unknown value
		end

endmodule



