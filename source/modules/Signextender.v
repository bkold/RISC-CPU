module Signextender(
	input [15:0]in,
	input extend,
	output reg [31:0]out);
	
	always @(*) begin
		if(extend) begin
			out = {{16{in[15]}}, in};
		end
		else begin
			out = in;
		end
	end 
	
endmodule
