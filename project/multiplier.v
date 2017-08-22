//////////////////////////////////////////////////////////////////////////////////////////////////
//TITLE : Multiplier hardware
//FILE : multiplier.v
//TESTBENCH : tb_multiplier.v
//ORGANIZATION : Kwangwoon Univ. Computer Engineering
//STUDENT ID : 2009720054
//STUDENT NAME : HyeonKi Lim(ddkook12@daum.net)
//PLATFORM : Windows 8
//SIMULATOR : ModelSim-Altera 10.1d
//COMPILER : Altera Quartus II 13.0 SP1
//TARGET BOARD : Altera DE2-70
//DESCRIPTION : This module is defined as operate to multiplication calculation
//				    This module is operating using radix-4 booth algorithm during 32cycle
//					 As a result, generate interrupt to inform completion of calculation
//LAST UPDATE : Dec. 11, 2013
///////////////////////////////////////////////////////////////////////////////////////////////////

module multiplier(clk,
						reset_n,
						S_sel,
						S_wr,
						S_address,
						S_din,
						S_dout,
						m_interrupt);
	
	//declare in/output variables
	input clk, reset_n, S_sel, S_wr;
	input [7:0] S_address;	//input address
	input [31:0] S_din;		//input data
	output [31:0] S_dout;	//result of multiplication
	output m_interrupt;		//interrupt
	
	//instance multiplier_master (register i/o)
	multiplier_master		U0_master(.clk(clk),
											 .reset_n(reset_n),
											 .S_sel(S_sel),
											 .S_wr(S_wr),
											 .S_address(S_address),
											 .S_din(S_din),
											 .S_dout(S_dout),
											 .m_interrupt(m_interrupt));
										 
endmodule


//////////////////////////////Register i/o//////////////////////////////////
module multiplier_master(clk,
								 reset_n,
								 S_sel,
								 S_wr,
								 S_address,
								 S_din,
								 S_dout,
								 m_interrupt);
	
	//declare in/output variables corresponding to multiplier module
	input clk, reset_n, S_sel, S_wr;
	input [7:0] S_address;
	input [31:0] S_din;
	output reg [31:0] S_dout;
	output reg m_interrupt;
	
	//define state to parameter
	parameter IDLE_STATE=2'b00;
	parameter EXEC_STATE=2'b10;
	parameter DONE_STATE=2'b01;
	
	//declare various reg variables for register 
	reg [31:0] Multiplicand0, Next_Multiplicand0;		//lower 32bits of multiplicand 
	reg [31:0] Multiplicand1, Next_Multiplicand1;		//upper 32bits of multiplicand 
	reg [31:0] Multiplier0, Next_Multiplier0;				//lower 32bits of multiplier
	reg [31:0] Multiplier1, Next_Multiplier1;          //upper 32bits of multiplier
	reg [31:0] Result0, Result1, Result2, Result3;		//128bits results
	reg [31:0] InterruptEnable, Next_InterruptEnable;	//interrupt enable signal
	reg [31:0] OperationStart, Next_OperationStart;		//operation start signal
	reg [31:0] OperationClear, Next_OperationClear;		//operation clear signal
	reg S_start;
	reg [1:0] State, Next_State;
	
	//input of multiplier_operator output
	wire [127:0] S_result;
	wire [1:0] S_state;
	
	//instance  multiplier_operator that perform multiplication
	multiplier_operator	U0_operator(.clk(clk),
											   .reset_n(reset_n),
											   .op_start(State[1]),
											   .op_clear(OperationClear[0]),
											   .multiplicand({Multiplicand1, Multiplicand0}),
											   .multiplier({Multiplier1, Multiplier0}),
											   .result(S_result),
											   .state(S_state));
											  
	always@(State, OperationClear, OperationStart, InterruptEnable, S_state, S_start)
		begin
			case(State)
				IDLE_STATE	:	begin			//if currnt state is idle,
					if(OperationClear[0]==1'b1)	Next_State<=IDLE_STATE;		//if clear signal is 1, next state set idle 
					else if(S_start==1'b1)			Next_State<=EXEC_STATE;    //if start signal is 1, next state set exec state
					else									Next_State<=IDLE_STATE;		//else maintain current state
				end
				EXEC_STATE	:	begin			//if currnt state is exec,
					if(OperationClear[0]==1'b1)	Next_State<=IDLE_STATE;		//if clear signal is 1, next state set idle 
					else if(S_state==2'b01)			Next_State<=DONE_STATE;		//if state signal is 01, next state set done state
					else 									Next_State<=EXEC_STATE;		//else maintain current state
				end
				DONE_STATE	:	begin			//if currnt state is done,
					if(OperationClear[0]==1'b1)	Next_State<=IDLE_STATE;		//if clear signal is 1, next state set idle 
					else 									Next_State<=DONE_STATE;		//else maintain current state
				end
				default	: Next_State<=2'bxx;		//else next state sets unknown value
			endcase
		end
		
	always@(S_start, Next_OperationStart, OperationStart, OperationClear)
		begin
			if(OperationClear[0]==1'b1)													S_start<=1'b0;		//if clear signal is 1, S_start set 0
			else if(S_start==1'b1)															S_start<=1'b1;		//if start signal is 1, S_start set 1
			else if(Next_OperationStart[0]==1'b1 && OperationStart[0]==1'b0) 	S_start<=1'b1;		//if next op_start==1 && current op_start==0, S_start set 0
			else 																					S_start<=1'b0;		//else S_start set 0
		end
	
	always@(State, InterruptEnable)
		begin
			if(State==2'b01 && InterruptEnable[0]==1'b1)	m_interrupt<=1'b1;		//if current state is done & interruptEnable is 1, generate m_interrupt
			else 														m_interrupt<=1'b0;		//else not generate m_interrupt
		end
	
	always@(S_sel, S_wr, State, S_address, S_din, Multiplicand0, OperationClear)
		begin
			if(OperationClear[0]==1'b1)																	Next_Multiplicand0<=32'h00;			//if clear, set 0
			else if(S_address[4:0]==5'h00 && S_sel==1'b1 && S_wr==1'b1 && State==2'b00)	Next_Multiplicand0<=S_din;				//multiplicand loewr 32bits set input value
			else 																									Next_Multiplicand0<=Multiplicand0;	//else maintain value
		end
		
	always@(S_sel, S_wr, State, S_address, S_din, Multiplicand1, OperationClear)
		begin
			if(OperationClear[0]==1'b1)																	Next_Multiplicand1<=32'h00;			//if clear, set 0
			else if(S_address[4:0]==5'h01 && S_sel==1'b1 && S_wr==1'b1 && State==2'b00)	Next_Multiplicand1<=S_din;				//multiplicand higher 32bits set input value
			else 																									Next_Multiplicand1<=Multiplicand1;	//else maintain value
		end
		
	always@(S_sel, S_wr, State, S_address, S_din, Multiplier0, OperationClear)
		begin
			if(OperationClear[0]==1'b1)																	Next_Multiplier0<=32'h00;			//if clear, set 0
			else if(S_address[4:0]==5'h02 && S_sel==1'b1 && S_wr==1'b1 && State==2'b00)	Next_Multiplier0<=S_din;			//multiplier loewr 32bits set input value
			else 																									Next_Multiplier0<=Multiplier0;	//else maintain value
		end
		
	always@(S_sel, S_wr, State, S_address, S_din, Multiplier1, OperationClear)
		begin
			if(OperationClear[0]==1'b1)																	Next_Multiplier1<=32'h00;			//if clear, set 0
			else if(S_address[4:0]==5'h03 && S_sel==1'b1 && S_wr==1'b1 && State==2'b00)	Next_Multiplier1<=S_din;			//multiplier higher 32bits set input value
			else 																									Next_Multiplier1<=Multiplier1;	//else maintain value
		end
	
	always@(S_sel, S_wr, State, S_address, S_din, InterruptEnable, OperationClear)
		begin
			if(OperationClear[0]==1'b1)											Next_InterruptEnable<=32'h00;				//if clear, set 0
			else if(S_address[4:0]==5'h08 && S_sel==1'b1 && S_wr==1'b1)	Next_InterruptEnable<=S_din;           //interrupt enable set input value
			else 																			Next_InterruptEnable<=InterruptEnable; //else maintain value
		end
		
	always@(S_sel, S_wr, State, S_address, S_din, OperationStart, OperationClear)
		begin
			if(OperationClear[0]==1'b1)											Next_OperationStart<=32'h00;				//if clear, set 0
			else if(S_address[4:0]==5'h0a && S_sel==1'b1 && S_wr==1'b1)	Next_OperationStart<=S_din;            //operation start signal is set to input value
			else																			Next_OperationStart<=OperationStart;   //else maintain value
		end
	
	always@(S_sel, S_wr, S_address, S_din, OperationClear, OperationClear)
		begin
			if(OperationClear[0]==1'b1)											Next_OperationClear<=32'h00;				//if clear signal is 1, initial to 0
			else if(S_address[4:0]==5'h0b && S_sel==1'b1 && S_wr==1'b1)	Next_OperationClear<=S_din;            //set operation clear signal
			else 																			Next_OperationClear<=OperationClear;   //else maintain value
		end
	
	  always@(posedge clk, negedge reset_n)
		begin
			case(S_address[4:0])
			///all case///if reset signal is 0, initial to 0
			///all case///if S_sel is 1 & S_wr is 0, output corresponding to register value
			///all case///else output 0
				5'h00	:	begin
					if(reset_n==1'b0)							S_dout<=32'h00;				
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Multiplicand0;
					else						 					S_dout<=32'h00;
				end
				5'h01	:	begin
					if(reset_n==1'b0)							S_dout<=32'h00;
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Multiplicand1;
					else 											S_dout<=32'h00;
				end
				5'h02	:	begin
					if(reset_n==1'b0)							S_dout<=32'h00;
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Multiplier0;
					else 											S_dout<=32'h00;
				end
				5'h03	:	begin
					if(reset_n==1'b0)							S_dout<=32'h00;
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Multiplier1;
					else 											S_dout<=32'h00;
				end
				5'h04	:	begin
					if(reset_n==1'b0)							S_dout<=32'h00;
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Result0;
					else 											S_dout<=32'h00;
				end
				5'h05	:	begin
					if(reset_n==1'b0)							S_dout<=32'h00;
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Result1;
					else 											S_dout<=32'h00;
				end
				5'h06	:	begin
					if(reset_n==1'b0)							S_dout<=32'h00;
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Result2;
					else 											S_dout<=32'h00;
				end
				5'h07	:	begin
					if(reset_n==1'b0)							S_dout<=32'h00;
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Result3;
					else 											S_dout<=32'h00;
				end
				5'h09	:	begin
					if(reset_n==1'b0)							S_dout<=32'h00;
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<={30'h0000, State};
					else 											S_dout<=32'h00;
				end
				default	:	S_dout<=32'h00;	
			endcase
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Multiplicand0<=32'h00;					//if reset signal is 0, initial to 0
			else					Multiplicand0<=Next_Multiplicand0;  //else set to next value
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Multiplicand1<=32'h00;						//if reset signal is 0, initial to 0
			else					Multiplicand1<=Next_Multiplicand1;     //else set to next value
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Multiplier0<=32'h00;						//if reset signal is 0, initial to 0
			else					Multiplier0<=Next_Multiplier0;      //else set to next value
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Multiplier1<=32'h00;						//if reset signal is 0, initial to 0
			else					Multiplier1<=Next_Multiplier1;      //else set to next value
		end
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	InterruptEnable<=32'h00;						//if reset signal is 0, initial to 0
			else					InterruptEnable<=Next_InterruptEnable;    //else set to next value
		end                                                            
		                                                               
	always@(posedge clk, negedge reset_n)                             
		begin                                                          
			if(reset_n==1'b0)	OperationStart<=32'h00;                   //if reset signal is 0, initial to 0
			else					OperationStart<=Next_OperationStart;      //else set to next value	
		end	                                                         
		                                                               
	always@(posedge clk, negedge reset_n)                             
		begin                                                          
			if(reset_n==1'b0)	OperationClear<=32'h00;                   //if reset signal is 0, initial to 0
			else					OperationClear<=Next_OperationClear;      //else set to next value
		end	                                                         
		                                                               
	always@(posedge clk, negedge reset_n)                             
		begin                                                          
			if(reset_n==1'b0)	State<=IDLE_STATE;                        //if reset signal is 0, initial to idle
			else					State<=Next_State;                        //else set to next value
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Result0<=32'h00;				//if reset signal is 0, initial to 0
			else					Result0<=S_result[31:0];   //else set to lower 32bit of S_result
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Result1<=32'h00;				//if reset signal is 0, initial to 0
			else					Result1<=S_result[63:32];  //else set to lower 32bit of S_result
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Result2<=32'h00;				//if reset signal is 0, initial to 0
			else					Result2<=S_result[95:64];  //else set to higher 32bit of S_result
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Result3<=32'h00;				//if reset signal is 0, initial to 0
			else					Result3<=S_result[127:96]; //else set to higher 32bit of S_result
		end	
	
endmodule


/////////////////////////////Operator////////////////////////////////////
module multiplier_operator(clk,
								   reset_n,
									op_start,
									op_clear,
									multiplicand,
									multiplier,
									result,
									state);
	
	//declare input * output reg variables
	input clk, reset_n, op_start, op_clear;
	input [63:0] multiplicand, multiplier;
	output reg [127:0] result;
	output reg [1:0] state;
	
	//delcare reg & wire vairalbe for using register and addition
	reg [63:0] next_multiplier, r_multiplier;
	reg [2:0] Y, Next_Y;
	reg [7:0] count, next_count;
	reg [127:0] Product, Next_Product;
	wire [63:0] w_Add, w_inv_Add;
	wire [63:0] w1_Add, w1_inv_Add;
	wire c1, c2;
										
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0) Product<=128'h00;			 //if reset signal is 0, initial to 0
			else					Product<=Next_Product;   //else set to next value
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Y<=3'b000;			 //if reset signal is 0, initial to 0
			else  				Y<=Next_Y;         //else set to next value
		end
	
	always@(op_start, op_clear, count, Y, multiplier, next_multiplier)
		begin
			if(op_clear==1'b1)								Next_Y<={multiplier[1:0], 1'b0};			//if clear signal is 1, initialize
			else if(op_start==1'b1 && count==8'h00)	Next_Y<={multiplier[1:0], 1'b0};			//if start signal is 1 && count 0, initialize
			else if(op_start==1'b1 && count==8'd33)	Next_Y<=Y;										//if start signal is 1 && count 33, maintain current value
			else if(op_start==1'b1)							Next_Y<={next_multiplier[1:0], Y[2]};	//if start signal is 1, set next multiplier value
			else 													Next_Y<=Y;										//else, maintain current value
		end
	
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	count<=8'h00;			 //if reset signal is 0, initial to 0
			else					count<=next_count;    //else set to next value
		end
		
	
	always@(Next_Y, Product, w_inv_Add, w_Add, w1_Add, w1_inv_Add, c1, c2, op_clear, op_start, count)
		begin
			if(op_clear==1'b1)	Next_Product<=128'h00;
			else if(op_start==1'b1 && count<8'd32)	begin
				case(Next_Y)
					//if operation is 0, only right shift 2 
					3'b000 	: 	Next_Product<={Product[127], Product[127], Product[127:2]};
					3'b111 	: 	Next_Product<={Product[127], Product[127], Product[127:2]};
					//if operation is A or -A, add or sub and right shift 2
					3'b001 	: 	Next_Product<={w_Add[63], w_Add[63], w_Add[63:0], Product[63:2]};
					3'b110 	:	Next_Product<={w_inv_Add[63], w_inv_Add[63], w_inv_Add[63:0], Product[63:2]}; 
					//if operation is 2A-A or -2A+A, add or sub and right shift 2
					3'b010 	: 	begin
						if(w_Add[63]==1'b0 && c1==1'b1)	Next_Product<={c1, c1, w_Add[63:0], Product[63:2]};
						else 										Next_Product<={w_Add[63], w_Add[63], w_Add[63:0], Product[63:2]};
					end
					3'b101 	: 	begin
						if(w_inv_Add[63]==1'b0 && c2==1'b1)	Next_Product<={c2, c2, w_inv_Add[63:0], Product[63:2]};
						else 											Next_Product<={w_inv_Add[63], w_inv_Add[63], w_inv_Add[63:0], Product[63:2]};
					end
					//if operation is 2A or -2A, shift and add and shift
					3'b011 	: 	Next_Product<={w1_Add[63], w1_Add[63:0], Product[64:2]};
					3'b100 	: 	Next_Product<={w1_inv_Add[63], w1_inv_Add[63:0], Product[64:2]};  
					default	:	Next_Product<=128'hxx;
				endcase
			end
	
			else	Next_Product<=Product;		//else, maintain current value
		end
		
	always@(count, op_start, op_clear)
		begin
			if(op_clear==1'b1)		next_count<=8'h00;			//if clear signal is 1, initialize
			else if(count==8'd33)	next_count<=8'd33;			//if count 33, maintain 
			else if(op_start==1'b1)	next_count<=count+1'b1;		//if start signal is 1, count++
			else 							next_count<=8'h00;			//else set 0
		end
	
	always@(count)
		begin
			if(count==8'd33)	state<=2'b01;		//if count 33, state is done
			else					state<=2'b10;		//else state is exec
		end
	
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	result<=128'h00;	//if reset signal is 0, initial to 0
			else					result<=Product;	//else, set Product value
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	next_multiplier<=64'h00;			//if reset signal is 0, initial to 0
			else 					next_multiplier<=r_multiplier;	//else set r_multiplier value
		end
		
	always@(op_start, next_multiplier, multiplier)
		begin
			if(op_start==1'b0)	r_multiplier<=multiplier;				//if start signal is 0, initialize
			else						r_multiplier<=next_multiplier>>2;	//else right shift 2
		end
	
	//instance cla64 module for add to partical product when Y is A operation
	cla64 U0_cla64(.a(Product[127:64]), .b(multiplicand), .ci(1'b0), .s(w_Add), .co(c1));	
	//instance cla64 module for add to partical product when Y is -A operation
	cla64 U1_cla64(.a(Product[127:64]), .b(~multiplicand), .ci(1'b1), .s(w_inv_Add), .co(c2));
	//instance cla64 module for add to partical product when Y is 2A operation
	cla64 U2_cla64(.a({Product[127],Product[127:65]}), .b(multiplicand), .ci(1'b0), .s(w1_Add));
	//instance cla64 module for add to partical product when Y is -2A operation
	cla64 U3_cla64(.a({Product[127],Product[127:65]}), .b(~multiplicand), .ci(1'b1), .s(w1_inv_Add));						
	
endmodule
