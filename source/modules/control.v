module Control(
	input [31:0]instruction,
	input reset,
	output reg [25:0]out);

	reg [5:0]reg1;
	reg bypass;

	always @(instruction) begin
		//REGUALR ALU
		if(instruction[31:26]==6'b000000) begin 
			//move instruction[5:0] as the opcode--Remember that immen does not matter
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={12'b000000000000, bypass, 2'b00, instruction[5:0], 5'b10000};
			reg1={1'b0, instruction[15:11]};
		end
		//REGULAR BRANCHES
		else if(instruction[31:26]==6'b000001) begin 
			out={1'b0, instruction[19:16], 5'b00000, instruction[20], 10'b0000000000, 5'b00000};
			reg1=6'b000001;
		end
		//SPECIAL BRANCHES
		else if(instruction[31:26]==6'b000011) begin //BEQ
			out={5'b10001, 7'b0000000, 9'b000000000, 5'b00000};
			reg1=6'b000001;
		end
		else if(instruction[31:26]==6'b000101 || instruction[31:26]==6'b000111) begin //J+AL
			//turn bit 14(EWrite) of control to instruction[27], saves hardware.
			out={5'b00111, 5'b00000, instruction[27], 10'b0000000000, 5'b00000};
			reg1=6'b000001;
		end
		//MEMORY INSTRUCTIONS
		else if(instruction[31:26]==6'b010000) begin //LB
			//maybe remove this instruction
		end
		else if(instruction[31:26]==6'b011000) begin //LL
			//I don't know what this is
		end
		else if(instruction[31:26]==6'b011001) begin //LUI
			out={5'b00000, 10'b0000000011, 6'b111100, 5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:26]==6'b010001) begin //LW
			out={5'b00000, 10'b0001000011, 6'b001000, 5'b01111};
			reg1=6'b000001;
		end
		else if(instruction[31:26]==6'b010010) begin //SB
			//maybe remove this instruction
		end
		else if(instruction[31:26]==6'b010011) begin //SW
			out={5'b00000, 10'b0001000011, 6'b001000, 5'b01000};
			reg1=6'b000001;
		end
		//IMMEDIATE ALU
		else if(instruction[31:27]==5'b10100) begin //ADDI+U
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 3'b000, instruction[26], 3'b000, bypass, 2'b11, 5'b00100, instruction[26], 5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:27]==5'b10110) begin //SLTI+U
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 3'b000, instruction[26], 3'b000, bypass, 2'b11, 5'b10110, instruction[26], 5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:27]==5'b10111) begin //SUBI+U
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 3'b000, instruction[26], 3'b000, bypass, 2'b11, 5'b00110, instruction[26], 5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:26]==6'b110000) begin //ANDI
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 7'b0000000, bypass, 2'b11, 6'b100000,  5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:26]==6'b110001) begin //NORI
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 7'b0000000, bypass, 2'b11, 6'b010000,  5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:26]==6'b110010) begin //ORI
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 7'b0000000, bypass, 2'b11, 6'b110000,  5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:26]==6'b110011) begin //XORI
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 7'b0000000, bypass, 2'b11, 6'b111000,  5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:26]==6'b110100) begin //SLLI
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 7'b0000000, bypass, 2'b11, 6'b100100,  5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:26]==6'b110101) begin //SRAI
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 7'b0000000, bypass, 2'b11, 6'b000011,  5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		else if(instruction[31:26]==6'b110110) begin //SRLI
			if(reg1=={1'b0, instruction[25:21]}) begin
				bypass=1;
			end
			else begin
				bypass=0;
			end
			out={5'b00000, 7'b0000000, bypass, 2'b11, 6'b000010,  5'b10000};
			reg1={1'b0, instruction[20:16]};
		end
		//SYSTEM CALLS
		else if(instruction[31:26]==6'b001000) begin //SLEEP
			out={5'b00000, 10'b0000100000, 6'b000000, 5'b00000};
			reg1=6'b000001;
		end
		else if(instruction[31:26]==6'b001001) begin //EXIT
			out={5'b00000, 10'b1000000000, 6'b000000, 5'b00000};
			reg1=6'b000001;
		end
		else if(instruction[31:26]==6'b001100) begin //BCPU
			out={5'b00000, 10'b0010001000, 6'b000000, 5'b00000};
			reg1=6'b000001;
		end
		else if(instruction[31:26]==6'b001101) begin //BCPUJ
			out={5'b00000, 10'b0100000000, 6'b000000, 5'b00000};
			reg1=6'b000001;
		end
		else if(instruction[31:26]==6'b001111) begin //BCPUJR
			out={5'b00000, 10'b0101000000, 6'b000000, 5'b00000};
			reg1=6'b000001;
		end
		else begin
			out=25'd0;
		 	reg1=6'b000001;
		end
	end

endmodule