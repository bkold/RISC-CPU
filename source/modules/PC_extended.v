module PCreg_extended(
	input [31:0]muxLane,
	input pcOut,
	input clk,
	input load,
	input reset,
	output reg [31:0]PC,
	output reg runtime);

	always @(negedge clk or  posedge reset or posedge load) begin
		if(reset) begin
			PC<=0;
		end
		else if(load)begin
			 PC<=muxLane;
			 runtime<=pcOut;
		end
		else if(clk==0) begin
			PC<=muxLane;
			runtime<=pcOut;
		end
	end
endmodule
