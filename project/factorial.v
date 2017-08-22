//////////////////////////////////////////////////////////////////////////////////////////////////
//TITLE : Factorial hardware
//FILE : factorial.v
//TESTBENCH : tb_factorial.v
//ORGANIZATION : Kwangwoon Univ. Computer Engineering
//STUDENT ID : 2010720149
//STUDENT NAME : DONGHYUN LEE
//PLATFORM : Windows 8
//SIMULATOR : ModelSim-Altera 10.1d
//COMPILER : Altera Quartus II 13.0 SP1
//TARGET BOARD : Altera DE2-70
//DESCRIPTION : This module is defined as operate to factorial calculation
//				    This module is operating that call multiplier hardware through bus 
//					 As a result, generate interrupt to inform completion of calculation
//LAST UPDATE : Dec. 11, 2013
///////////////////////////////////////////////////////////////////////////////////////////////////

module factorial(clk,
					  reset_n,
					  S_sel,
					  S_wr,
					  S_address,
					  S_din,
					  M_grant,
					  M_din,
					  m_interrupt,
					  S_dout,
					  M_req,
					  M_wr,
					  M_address,
					  M_dout,
					  f_interrupt);
	
	//delcare input & output variables
	input clk, reset_n, S_sel, S_wr, M_grant, m_interrupt;	
	input [7:0] S_address;		//input address
	input [31:0] S_din, M_din;	//32bits input data
	output reg M_req, M_wr, f_interrupt;
	output reg [7:0] M_address;	//output address for multiplier
	output reg [31:0] S_dout, M_dout;	//32bits output data
	
	//declare reg variables to using registers
	reg [31:0] NValue, Next_NValue;
	reg [4:0] Cur_State, Next_State;
	reg [31:0] InterruptEnable, Next_InterruptEnable;
	reg [31:0] OperationStart, Next_OperationStart;
	reg [31:0] OperationClear, Next_OperationClear;
	reg [31:0] Result0, Result1;
	reg [63:0] Next_Result;
	reg [3:0] count, Next_count;	//count variables for compute 10cycle
	reg F_count;	//count first loop
	reg Correct;	//signal to check N
	
	//define state to parameter 
	parameter IDLE_STATE=5'h00;
	parameter DONE_STATE=5'h01;
	parameter CHECK_STATE=5'h02;
	parameter REQUEST0_STATE=5'h03;
	parameter COUNT0_STATE=5'h04;
	parameter READSTATE0_STATE=5'h05;
	parameter READSTATE1_STATE=5'h14;
	parameter SEND0_STATE=5'h06;
	parameter SEND1_STATE=5'h07;
	parameter SEND2_STATE=5'h08;
	parameter SEND3_STATE=5'h09;
	parameter SEND4_STATE=5'h0a;
	parameter SEND5_STATE=5'h0b;
	parameter M_EXEC_STATE=5'h0c;
	parameter REQUEST1_STATE=5'h0d;
	parameter COUNT1_STATE=5'h0e;
	parameter GET0_STATE=5'h0f;
	parameter GET1_STATE=5'h10;
	parameter CLEAR_STATE=5'h11;
	parameter GRANT0_STATE=5'h12;
	parameter GRANT1_STATE=5'h13;
	
	///////////////////////////////////////////////////////////////////////////////
	always@(S_sel, S_wr, Cur_State, S_address, S_din, OperationClear, OperationStart, Correct, count, M_grant, m_interrupt, M_din)
		begin
			case(Cur_State)
				IDLE_STATE			:	begin		//if currnt state is idle,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;		//if clear signal is 1, next state set idle 
					else if(OperationStart[0]==1'b1)	Next_State<=CHECK_STATE;	//if start signal is 1, next state set check state
					else 										Next_State<=IDLE_STATE;		//else maintain current state
				end
			   DONE_STATE		   :	begin		//if currnt state is done
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=DONE_STATE;	//else maintain current state
				end	
			   CHECK_STATE	      :	begin		//if currnt state is check,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else if(Correct==1'b0)				Next_State<=REQUEST0_STATE;	//if correct signal is 0, next state request0 state
					else 										Next_State<=DONE_STATE;	//else next state set done state
				end	
				REQUEST0_STATE    :	begin		//if currnt state is request0,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=GRANT0_STATE;	//else next state set grant0 state
				end	
				GRANT0_STATE		:	begin		//if currnt state is grant0,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else if(M_grant==1'b1)				Next_State<=READSTATE0_STATE;	//if grant is 1, next state set readstate0 state
					else 										Next_State<=COUNT0_STATE;	//else next state set count0 state
				end	
				COUNT0_STATE	   :	begin		//if currnt state is count0,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else if(count==4'h9)					Next_State<=REQUEST0_STATE;	//if count is 9, next state set request0 state
					else										Next_State<=COUNT0_STATE;	//else maintain current state
				end	
				READSTATE0_STATE	:	begin		//if currnt state is readstate0,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=READSTATE1_STATE;	//else next state set readstate1 state
				end
				READSTATE1_STATE	:	begin		//if currnt state is readstate1,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else if(M_din==32'h00) 				Next_State<=SEND0_STATE;	//if multiplier state is idle, next state set send0 state
					else 										Next_State<=READSTATE0_STATE;	//else return readstate1 state
				end		
				SEND0_STATE	      :	begin		//if currnt state is send0,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=SEND1_STATE; //else next state set send1 state
				end	
				SEND1_STATE	      :	begin		//if currnt state is send1,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=SEND2_STATE;	//else next state set send2 state
				end	
				SEND2_STATE	      :	begin		//if currnt state is send2,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=SEND3_STATE;	//else next state set send3 state
				end	
				SEND3_STATE	      :	begin		//if currnt state is send3,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=SEND4_STATE;	//else next state set send4 state
				end	
				SEND4_STATE	      :	begin		//if currnt state is send4,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=SEND5_STATE;	//else next state set send5 state
				end	
				SEND5_STATE	      :	begin		//if currnt state is send5,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=M_EXEC_STATE;	//else next state set m_exec state
				end	
				M_EXEC_STATE	   :	begin		//if currnt state is m_exec,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else if(m_interrupt==1'b1)			Next_State<=REQUEST1_STATE;	//if generate m_interrupt, next state set request1 state
					else										Next_State<=M_EXEC_STATE;	//else maintain current state
				end	
				REQUEST1_STATE    :	begin		//if currnt state is request1,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=GRANT1_STATE;	//else next state set grant1 state
				end	
				GRANT1_STATE		:	begin		//if currnt state is grant1,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else if(M_grant==1'b1)				Next_State<=GET0_STATE;	//if grant is 1, next state set get0 state
					else 										Next_State<=COUNT1_STATE;	//else next state set count1 state
				end	
				COUNT1_STATE	   :	begin		//if currnt state is count1,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else if(count==4'h9)					Next_State<=REQUEST1_STATE;	//if count is 9, next state set request1 state
					else										Next_State<=COUNT1_STATE;	//else maintain current state
				end	
				GET0_STATE		   :	begin		//if currnt state is get0,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=GET1_STATE;	//else next state set get1 state
				end	
				GET1_STATE		   :	begin		//if currnt state is get1,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=CLEAR_STATE;	//else next state set clear state
				end	
				CLEAR_STATE	      :	begin		//if currnt state is clear,
					if(OperationClear[0]==1'b1)		Next_State<=IDLE_STATE;	//if clear signal is 1, next state set idle 
					else 										Next_State<=CHECK_STATE;	//else next state set check state
				end
				default	:	Next_State<=5'hxx;	//else next state sets unknown value
			endcase
		end
		
	////////////////////////////////////////////////////////////////////////////////////
	  always@(posedge clk, negedge reset_n)
		begin
			case(S_address[4:0])
				5'h00	:	begin			//if lower 5bits address is 0, 
					if(reset_n==1'b0)							S_dout<=32'h00;		//if reset signal is 0, output 0
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=NValue;		//if selected factorial and order to read, output Nvalue
					else 											S_dout<=32'h00;		//else output 0
				end
				5'h01	:	begin			//if lower 5bits address is 1, 
					if(reset_n==1'b0)							S_dout<=32'h00;				//if reset signal is 0, output 0
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=InterruptEnable;	//if selected factorial and order to read, output interrupt enable
					else 											S_dout<=32'h00;				//else output 0
				end
				5'h02	:	begin			//if lower 5bits address is 2, 
					if(reset_n==1'b0)							S_dout<=32'h00;		//if reset signal is 0, output 0
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Cur_State;	//if selected factorial and order to read, output current state
					else 											S_dout<=32'h00;		//else output 0
				end
				5'h05	:	begin			//if lower 5bits address is 5, 
					if(reset_n==1'b0)							S_dout<=32'h00;		//if reset signal is 0, output 0
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Result0;		//if selected factorial and order to read, output lower 32bits result
					else 											S_dout<=32'h00;		//else output 0
				end
				5'h06	:	begin			//if lower 5bits address is 6, 
					if(reset_n==1'b0)							S_dout<=32'h00;		//if reset signal is 0, output 0
					else if(S_sel==1'b1 && S_wr==1'b0)	S_dout<=Result1;		//if selected factorial and order to read, output upper 32bits result
					else 											S_dout<=32'h00;		//else output 0
				end
				default	:	S_dout<=32'h00;	//else output 0
			endcase
		end
	
	///////////////////////////////////////////////////////////////////////////////
	
	always@(Cur_State, F_count)
		begin
			if(Cur_State==5'h00)										F_count<=1'b0;	//if current state is idle, f_count set 0
			else if(Cur_State==5'h02 && F_count==1'b0)		F_count<=1'b0;	//if current state is check and not one round, f_count set 0
			else if(Cur_State==5'h02 && F_count==1'b1)		F_count<=1'b1;	//if urrent state is check and one round, f_count set 1
			else 															F_count<=1'b1;	//else, f_count set 1
		end
	
	always@(Cur_State, count)
		begin
			if(Cur_State==5'h04 || Cur_State==5'h0e)	Next_count<=count+1'b1;	//if current state is count0 or count1m, count++
			else 													Next_count<=4'h0;			//else count set 0
		end
	
	always@(Cur_State, InterruptEnable)
		begin
			if(Cur_State==5'h01 && InterruptEnable[0]==1'b1)	f_interrupt<=1'b1;	//if current state is done and interrupt_enable is 1, generate f_interrupt
			else 																f_interrupt<=1'b0;	//else f_interrupt sets 0
		end
		
	always@(Cur_State, F_count, NValue, Result1, Result0, OperationClear, M_din)
		begin
			if(OperationClear[0]==1'b1)																		Next_Result<=64'h00;					//if operationclear signal is 1, result set 0
			else if(Cur_State==5'h02 && F_count==1'b0 && (NValue==32'h01 || NValue==32'h00))	Next_Result<=64'h01;					//if first input N is 1 or 0, result set 1 
			else if(Cur_State==5'h02 && F_count==1'b0)													Next_Result<={32'h00, NValue};	//if first input N isn't 1 or 0, lower 32bits result set N
			else if(Cur_State==5'h10)																			Next_Result<={32'h00, M_din};		//if current state is get1, write input in result0
			else if(Cur_State==5'h11)																			Next_Result<={M_din, Result0};	//if current state is clear, write input in result1
			else																										Next_Result<={Result1, Result0};	//else maintain current value
		end
	
	always@(Cur_State, F_count, NValue)
		begin
			if(Cur_State==5'h02 && F_count==1'b0 && (NValue==32'h01 || NValue==32'h00))	Correct<=1'b1;	//if first input n is 0 or 1, correct set 1
			else if(Cur_State==5'h02 && F_count==1'b1 && NValue==32'h02)						Correct<=1'b1;	//if current state is check and n is 2, correct set 1
			else																									Correct<=1'b0;	//else correct set 0
		end
	
	always@(Cur_State, Result0, Result1, NValue)
		begin
			case(Cur_State)
				READSTATE0_STATE	:	begin	//if current state is READSTATE0, read multiplier state
					M_address<=8'h49;
					M_dout<=32'h00;
				end
				SEND0_STATE	:	begin			//if current state is SEND0, write multiplicand0 of multiplier to Result0
					M_address<=8'h40;
					M_dout<=Result0;
				end
				SEND1_STATE	:	begin			//if current state is SEND1, write multiplicand1 of multiplier to Result1
					M_address<=8'h41;
					M_dout<=Result1;
				end
				SEND2_STATE	:	begin			//if current state is SEND2, write multiplier0 of multiplier to N
					M_address<=8'h42;
					M_dout<=NValue;
				end
				SEND3_STATE	:	begin			//if current state is SEND3, write multiplier1 of multiplier to 0
					M_address<=8'h43;
					M_dout<=32'h00;
				end
				SEND4_STATE	:	begin			//if current state is SEND4, write interrupt enable of multiplier to 1
					M_address<=8'h48;       
					M_dout<=32'h01;         
				end                        
				SEND5_STATE	:	begin       //if current state is SEND5, order to start multiplication
					M_address<=8'h4a;       
					M_dout<=32'h01;         
				end                        
				GET0_STATE	:	begin       //if current state is GET0, read result of multiplier
					M_address<=8'h44;       
					M_dout<=32'h00;         
				end                        
				GET1_STATE	:	begin       //if current state is GET1, read result of multiplier
					M_address<=8'h45;       
					M_dout<=32'h00;         
				end                        
				CLEAR_STATE	:	begin       //if current state is CLEAR, clear multiplier
					M_address<=8'h4b;
					M_dout<=32'h01;
				end
				default		:	begin			//else, set address & dout to ff and 0
					M_address<=8'hff;
					M_dout<=32'h00;	
				end
			endcase
		end
	
	always@(Cur_State)
		begin
			//this always statement is setting M_req varialbe as current state
			case(Cur_State)
				REQUEST0_STATE		:	M_req<=1'b1;
				GRANT0_STATE		:	M_req<=1'b1;
				READSTATE0_STATE	:	M_req<=1'b1;
				READSTATE1_STATE	:	M_req<=1'b1;
				SEND0_STATE			:	M_req<=1'b1;
				SEND1_STATE			:	M_req<=1'b1;
				SEND2_STATE			:	M_req<=1'b1;
				SEND3_STATE			:	M_req<=1'b1;
				SEND4_STATE			:	M_req<=1'b1;
				SEND5_STATE			:	M_req<=1'b1;
				REQUEST1_STATE		:	M_req<=1'b1;
				GRANT1_STATE		:	M_req<=1'b1;
				GET0_STATE			:	M_req<=1'b1;
				GET1_STATE			:	M_req<=1'b1;
				CLEAR_STATE			:	M_req<=1'b1;
				default				:	M_req<=1'b0;	//else m_req is 0
			endcase
		end
	
	always@(Cur_State)
		begin
			//this always statement is setting M_wr variable as current state
			case(Cur_State)
				SEND0_STATE		:	M_wr<=1'b1;
				SEND1_STATE		:	M_wr<=1'b1;
				SEND2_STATE		:	M_wr<=1'b1;
				SEND3_STATE		:	M_wr<=1'b1;
				SEND4_STATE		:	M_wr<=1'b1;
				SEND5_STATE		:	M_wr<=1'b1;
				CLEAR_STATE		:	M_wr<=1'b1;
				default			:	M_wr<=1'b0;	//else m_wr is 0
			endcase
		end
	
	always@(S_sel, S_wr, Cur_State, S_address, S_din, OperationClear, NValue)
		begin
			if(OperationClear[0]==1'b1)																		Next_NValue<=32'h00;		//if clear, set 0
			else if(Cur_State==5'h00 && S_address[4:0]==5'h00 && S_sel==1'b1 && S_wr==1'b1)	Next_NValue<=S_din;		//if first idle state, write N value
			else if(Cur_State==5'h02)																			Next_NValue<=NValue-1;	//if check state, N--
			else 																										Next_NValue<=NValue;		//else maintain value
		end
	
	always@(S_sel, S_wr, Cur_State, S_address, S_din, InterruptEnable, OperationClear)
		begin
			if(OperationClear[0]==1'b1)																		Next_InterruptEnable<=32'h00;				//if clear, set 0
			else if(S_address[4:0]==5'h01 && S_sel==1'b1 && S_wr==1'b1)								Next_InterruptEnable<=S_din;				//interrupt enable set input value 
			else 																										Next_InterruptEnable<=InterruptEnable;	//else maintain value
		end
	
	always@(S_sel, S_wr, Cur_State, S_address, S_din, OperationStart, OperationClear)
		begin
			if(OperationClear[0]==1'b1)																		Next_OperationStart<=32'h00;				//if clear, set 0
			else if(S_address[4:0]==5'h03 && S_sel==1'b1 && S_wr==1'b1)								Next_OperationStart<=S_din;				//operation start signal is set to input value
			else 																										Next_OperationStart<=OperationStart;	//else maintain value
		end
	
	always@(S_sel, S_wr, S_address, S_din, OperationClear, OperationClear, Cur_State)
		begin
			if(OperationClear[0]==1'b1 || Cur_State==5'h00)					Next_OperationClear<=32'h00;				//if clear signal is 1 or idle state, initial to 0
			else if(S_address[4:0]==5'h04 && S_sel==1'b1 && S_wr==1'b1)	Next_OperationClear<=S_din;				//set operation clear signal
			else																		 	Next_OperationClear<=OperationClear;	//else maintain value
		end
	
	///////////////////////////////////////////////////////////////////////////////
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	NValue<=32'h00;									//if reset signal is 0, initial to 0
			else					NValue<=Next_NValue;								//else set to next value
		end
	
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	InterruptEnable<=32'h00;						//if reset signal is 0, initial to 0
			else					InterruptEnable<=Next_InterruptEnable;		//else set to next value
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	OperationStart<=32'h00;							//if reset signal is 0, initial to 0
			else					OperationStart<=Next_OperationStart;		//else set to next value	
		end	
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	OperationClear<=32'h00;							//if reset signal is 0, initial to 0
			else					OperationClear<=Next_OperationClear;		//else set to next value
		end	
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	Cur_State<=IDLE_STATE;							//if reset signal is 0, initial to 0
			else					Cur_State<=Next_State;							//else set to next value
		end	
	
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)						Result0<=32'h00;						//if reset signal is 0 or clear signal is 1, initial to 0
			else if(OperationClear[0]==1'b1)	Result0<=32'h00;
			else										Result0<=Next_Result[31:0];		//else set to next value
		end
		
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)						Result1<=32'h00;						//if reset signal is 0 clear signal is 1, initial to 0
			else if(OperationClear[0]==1'b1)	Result1<=32'h00;
			else										Result1<=Next_Result[63:32];		//else set to next value
		end
	always@(posedge clk, negedge reset_n)
		begin
			if(reset_n==1'b0)	count<=4'h0;												//if reset signal is 0, initial to 0
			else 					count<=Next_count;										//else set to next value
		end
		
endmodule
