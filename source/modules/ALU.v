module ALU(
	input signed [31:0]D0,
	input signed [31:0]D1,
	input [5:0]OpCode,
	output reg [31:0]out,
	output reg error); //sends signal to interuptmodule and wipes EReg with noop instruction
	
	reg [31:0]temp;
	wire [31:0]D0_unsigned;
	wire [31:0]D1_unsigned;

	assign D0_unsigned = D0;
	assign D1_unsigned = D1;

	always @(*) begin
		error<=0;
		case (OpCode)		 	
			//ADD-ADDI
			6'b001000 : begin
				temp<=(D0[31:0] + D1[31:0]);
				if ((D0[31]&&D1[31]&&~temp[31]) || (~D0[31]&&~D1[31]&&temp[31])) begin
					error<=1;
				end
				else begin
					out<=temp;
				end
			end
			//ADDU
			6'b001001 : out<=D0+D1;
			//DIV
			6'b000100 : out<=D0/D1;
			//DIVU
			6'b000101 : out<=D0_unsigned/D1_unsigned;
			//MOD
			6'b000110 : out<=D0%D1;
			//MODU
			6'b000111 : out<=D0_unsigned%D1_unsigned;
			//MUL
			6'b100110 : out<=D0*D1;
			//MULU
			6'b100111 : out<=D0_unsigned*D1_unsigned;
			//SUB
			6'b001100 : begin
				temp<=(D0[31:0] - D1[31:0]);
				if ((D0[31]&&~D1[31]&&~temp[31]) || (~D0[31]&&D1[31]&&temp[31])) begin
					error<=1;
				end
				else begin
					out<=temp;
				end
			end
			//SUBU
			6'b001101 : out<=D0-D1;
			//SLT
			6'b101100 : out<=D0<D1;
			//SLTU
			6'b101101 : out<=D0_unsigned<D1_unsigned;
			//AND
			6'b100000 : out<=D0&D1;
			//NAND
			6'b100001 : out<=~(D0&D1);
			//NOR
			6'b010000 : out<=~(D0|D1);
			//OR
			6'b110000 : out<=D0|D1;
			//XOR
			6'b111000 : out<=D0^D1;
			//SLL
			6'b100100 : out<=D0<<D1_unsigned;
			//SRA
			6'b000011 : out<=D0>>>D1_unsigned;
			//SRL
			6'b000010 : out<=D0>>D1_unsigned;
			//LUI
			6'b111100 : out<={D1[15:0], 16'h0000};

			default : out<=0;

		endcase
	end

endmodule