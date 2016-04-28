module BJComp(
	input [4:0]EN, //opcode/enable from control
	input signed [25:0]value, //[25:0] from instruction from FReg
	input signed [31:0]IMM,//from instruction from FReg
	input signed [31:0]D0,
	input signed [31:0]D1,
	input signed [31:0]PC, //PC from FReg
	output reg signed [31:0]newPC,
	output reg jumpSig);
	
	always @(*) begin
		if(EN==5'b10001 && D0==D1) begin //BEQ
			newPC<=PC+(IMM<<2);
			jumpSig<=1;
		end 
		else if(EN==5'b00001) begin //BAL
			newPC<=PC+(IMM<<2);
			jumpSig<=1;
		end
		else if((EN==5'b00010) && D0>=0) begin //BGEZ or BGEZAL
			newPC<=PC+(IMM<<2);
			jumpSig<=1;
		end
		else if((EN==5'b00011) && D0>0) begin //BGTZ or BGTZAL
			newPC<=PC+(IMM<<2);
			jumpSig<=1;
		end
		else if((EN==5'b00100) && D0<0) begin //BLTZ or BLTZAL
			newPC<=PC+(IMM<<2);
			jumpSig<=1;
		end
		else if((EN==5'b00101) && D0<=0) begin //BLEZ or BLEZAL
			newPC<=PC+(IMM<<2);
			jumpSig<=1;
		end
		else if((EN==5'b00111)) begin //J or JAL
			newPC<={PC[31:28],value,2'b00};
			jumpSig<=1;
		end
		else if(EN==5'b01000) begin //JR or JALR
			newPC<=D0;
			jumpSig<=1;
		end
		else begin //not a jump
			newPC<=PC+4;
			jumpSig<=0;
		end
	end
	
endmodule
