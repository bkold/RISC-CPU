module MReg_extended(
	input [1:0]controls,
	input [31:0]ramOut,
	input [31:0]aluOut,
	input [5:0]regNum,
	input clk,
	output reg [71:0]out);

	always @(negedge clk) begin
		out<={regNum, ramOut, aluOut, controls};
	end

endmodule