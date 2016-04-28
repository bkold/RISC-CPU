module DReg_extended(
	input [17:0]controls,
	input [31:0]pc,
	input [31:0]rsData,
	input [31:0]rtData,	
	input [31:0]imm,
	input [5:0]rt,
	input [5:0]rd,
	input clk,
	input wipe,
	output reg [157:0]out);

	always @(negedge clk) begin
		if(wipe==1) begin
			out<={rt, 6'b000000, rtData, imm, rsData, pc, 18'd0};//add $0, $0, $0
		end
		else begin
			out<={rt, rd, rtData, imm, rsData, pc, controls};
		end	
	end

endmodule