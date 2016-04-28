module RAM(
	input [31:0]PC1,
	input [31:0]addressIn1,//address of 
	input [31:0]dataIn1,//data to be written in M stage
	input clk,
	input load,
	input [31:0]loadAddress,
	input [31:0]loadInstruction,
	input memEn,//Is the Block Enabled? From Control
	input WR,//Write'/Read From Control
	output reg [31:0]instruction1,
	output reg [31:0]readData1);

	reg [7:0]memory[512:0];

	always @(*) begin
		if(clk==1 && load==0) begin
			instruction1<={memory[PC1], memory[PC1+1], memory[PC1+2], memory[PC1+3]};
		end
	end

	always @(*) begin
		if(load==1) begin
			memory[loadAddress]<=loadInstruction[31:24];
			memory[loadAddress+1]<=loadInstruction[23:16];
			memory[loadAddress+2]<=loadInstruction[15:8];
			memory[loadAddress+3]<=loadInstruction[7:0];
		end
		else if(clk==0 && memEn==1 && WR==0) begin //write
			memory[addressIn1]<=dataIn1[31:24];
			memory[addressIn1+1]<=dataIn1[23:16];
			memory[addressIn1+2]<=dataIn1[15:8];
			memory[addressIn1+3]<=dataIn1[7:0];
		end
		else if(clk==1 && memEn==1 && WR==1) begin //read
			readData1<={memory[addressIn1], memory[addressIn1+1], memory[addressIn1+2], memory[addressIn1+3]};
		end
	end

endmodule