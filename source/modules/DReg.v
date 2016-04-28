module DReg(
	input [15:0]controls,
	input [31:0]pc,
	input [31:0]PC1Stored,
	input [31:0]rsData,
	input [31:0]rtData,	
	input [31:0]imm,
	input [4:0]rt,
	input [4:0]rd,
	input clk,
	input wipe,
	output reg [185:0]out);

	always @(negedge clk) begin
		if(wipe==1) begin
			out<={rt, 5'b00000, rtData, imm, rsData, pc, 15'd0};//add $0, $0, $0
		end
		else begin
			out<={rt, rd, rtData, imm, rsData, pc, PC1Stored, controls};
		end	
	end

endmodule