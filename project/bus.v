//////////////////////////////////////////////////////////////////////////////////////////////////
//TITLE : Bus hardware
//FILE : bus.v
//TESTBENCH : tb_bus.v
//ORGANIZATION : Kwangwoon Univ. Computer Engineering
//STUDENT ID : 2009720054
//STUDENT NAME : HyeonKi Lim(ddkook12@daum.net)
//PLATFORM : Windows 8
//SIMULATOR : ModelSim-Altera 10.1d
//COMPILER : Altera Quartus II 13.0 SP1
//TARGET BOARD : Altera DE2-70
//DESCRIPTION : This module is defined as transmission line to each components
//				    This module is operating as request & grant signal value
//					 As a result, two master is requested bus, and bus decides who allocate is grant
//					 Therefore this module is very important as hardware of transfer data in process
//LAST UPDATE : Dec. 11, 2013
///////////////////////////////////////////////////////////////////////////////////////////////////

module bus (clk, 
				reset_n, 
				M0_req, 
				M0_wr, 
				M0_address, 
				M0_dout, 
				M1_req, 
				M1_wr, 
				M1_address, 
				M1_dout, 
				S0_dout, 
				S1_dout, 
				S2_dout, 
				M0_grant, 
				M1_grant, 
				M_din, 
				S0_sel, 
				S1_sel, 
				S2_sel, 
				S_address, 
				S_wr, 
				S_din);
	
	//delcare in/output variables
	input clk, reset_n, M0_req, M0_wr, M1_req, M1_wr;
	input [7:0] M0_address, M1_address;		//master address
	input [31:0] M0_dout, M1_dout, S0_dout, S1_dout, S2_dout;	//components output
	output M0_grant, M1_grant, S0_sel, S1_sel, S2_sel, S_wr;		//grant & select, R/W signal
	reg S0_sel, S1_sel, S2_sel, S_wr;
	output reg [7:0] S_address;		//slave address
	output reg [31:0] S_din, M_din;	//slave inputs
	
	//combination select signals
	reg [2:0] w_S;
	
	always@(M0_wr, M1_wr, M0_grant)
		begin
			case(M0_grant)
				1'b0	:	S_wr<=M1_wr;		//R/W signal sets as master0 grant value
				1'b1	:	S_wr<=M0_wr;
				default	:	S_wr<=1'bx;		//default /R/W signal sets unknown value
			endcase
		end
		
	always@(M0_address, M1_address, M0_grant)
		begin
			case(M0_grant)
				1'b0	:	S_address<=M1_address;	//slave address sets as master0 grant value
				1'b1	:	S_address<=M0_address;
				default	:	S_address<=1'bx;		//if default, slave address sets unknown value
			endcase
		end
		
	always@(M0_dout, M1_dout, M0_grant)
		begin
			case(M0_grant)
				1'b0	:	S_din<=M1_dout;			//slave input data sets as master0 grant value
				1'b1	:	S_din<=M0_dout;
				default	:	S_din<=1'bx;			//if default, slave input data sets unknown value
			endcase
		end
	
	always@(S0_dout, S1_dout, S2_dout, w_S)
		begin
			case(w_S)
				3'b001	:	M_din<=S0_dout;		//if w_S 001, M_din sets to slave0 output 
				3'b010	:	M_din<=S1_dout;		//else if w_S 010, M_din sets to slave1 output
				3'b100	:	M_din<=S2_dout;		//else if w_S 100, M_din sets to slave2 output
				default	:	M_din<=32'h0000;		//else, M_din sets 0
			endcase
		end
	
	always@(S_address)
		begin
			if(S_address[7:5]==3'b000)			{S2_sel, S1_sel, S0_sel}<=3'b001; //if upper address 3-bit is 000, slave0 select
			else if(S_address[7:5]==3'b001)	{S2_sel, S1_sel, S0_sel}<=3'b010; //else if upper address 3-bit is 001, slave1 select
			else if(S_address[7:5]==3'b010)	{S2_sel, S1_sel, S0_sel}<=3'b100; //else if upper address 3-bit is 010, slave2 select 
			else 										{S2_sel, S1_sel, S0_sel}<=3'b000; //else, not select
		end
		
	//////////////////////////////////////////////////////////////////////////
	//declare reg of wire variables using arbiter 
	reg  	need_fair, next_grant, state_fair, current_grant;
	reg 	w_M0_req, w_M1_req;
	wire 	eor_fair;
	wire 	[3:0] req_4bit;
	
	//assign request combination
	assign req_4bit={w_M0_req, w_M1_req, M0_req, M1_req};
	
	always@(req_4bit)
		begin
			//if previous request signals are 0 & current request signals are 1, need_fair sets 1
			if(req_4bit==4'b0011)	need_fair<=1'b1;
			else							need_fair<=1'b0;	//else, need_fair sets 0
		end
	
	//assign eor_fair as exclusive or need_fair, state_fair
	assign eor_fair=need_fair^state_fair;
	
	always@(M0_req, M1_req, state_fair, current_grant, need_fair)
		begin
			case(need_fair)
				1'b1	:	begin	//if need fair,
					if(state_fair==1'b0) 		next_grant<=1'b0;	//if state fair is 0, next_grant sets 0
					else if(state_fair==1'b1) 	next_grant<=1'b1;	//else if state fair is 1, next_grant sets 1
					else 								next_grant<=1'bx;	//else next_grant sets unknown value
				end
				1'b0	:	begin	//if not need fair,
					if(M0_req==M1_req)							next_grant<=current_grant;	//maintain grant if the case
					else if(M0_req==1'b1 && M1_req==1'b0)	next_grant<=1'b0;				//master0 gets grant if the case
					else if(M0_req==1'b0 && M1_req==1'b1)	next_grant<=1'b1;				//master1 gets grant if the case
					else 												next_grant<=1'bx;				//else sets unknown value
				end
				default	:	next_grant<=1'bx;	//else sets unknown value
			endcase
		end
	
	//assign master0 & master1 grant below	
	assign M0_grant = ~current_grant;	//sets as complement of current grant 
	assign M1_grant = current_grant;
	
	/////////////////////////////////////////////////////////////////////////
	always @(posedge clk or negedge reset_n)
		begin
			if(reset_n==1'b0)	w_S<=3'b000;	//if reset_n signal is 0, reset w_S
			else 					w_S<={S2_sel, S1_sel, S0_sel};	//else, w_S sets to concentrate each sel signals 	
		end
	
	always @(posedge clk or negedge reset_n)
		begin
			if(reset_n==1'b0)	w_M0_req<=1'b0;	//if reset_n signal is 0, reset w_M0_req
			else 					w_M0_req<=M0_req;	//else, w_m0_req sets m0_req  
		end
	
	always @(posedge clk or negedge reset_n)
		begin
			if(reset_n==1'b0)	w_M1_req<=1'b0;	//if reset_n signal is 0, reset w_M1_req
			else 					w_M1_req<=M1_req;	//else, w_m1_req sets m1_req 
		end
	
	always @(posedge clk or negedge reset_n)
		begin
			if(reset_n==1'b0)	state_fair<=1'b0;	//if reset_n signal is 0, reset state_fair
			else 					state_fair<=eor_fair;	//else, state_fair sets eor fair
		end
	
	always @(posedge clk or negedge reset_n)
		begin
			if(reset_n==1'b0)	current_grant<=1'b0;	//if reset_n signal is 0, reset current_grant
			else 					current_grant<=next_grant;	//else, current grant sets next grant 
		end	
	
endmodule
