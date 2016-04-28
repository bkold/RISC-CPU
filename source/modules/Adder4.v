module Adder4(
	input [31:0]oldPC,
	output [31:0]newPC);

	assign newPC = oldPC+4;

endmodule
