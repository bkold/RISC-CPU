module PCreg(
	input [31:0]PCin,
	input clk,
	input reset,
	output reg [31:0]PCout);

	always @(negedge clk or posedge reset) begin
		if(reset) begin
			PCout<=0;
		end
		else begin
			 PCout<=PCin;
		end
	end
endmodule
