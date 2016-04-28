module MReg(
	input [1:0]controls,
	input [31:0]ramOut,
	input [31:0]aluOut,
	input [4:0]regNum,
	input clk,
	output reg [70:0]out);

	always @(negedge clk) begin
		out<={regNum, ramOut, aluOut, controls};
	end

endmodule