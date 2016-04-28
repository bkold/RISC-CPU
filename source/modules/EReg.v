module EReg(
	input [4:0]controls,
	input [31:0]aluOut,
	input [31:0]rtData,
	input [4:0]regNum,
	input clk,
	input wipe,
	output reg [73:0]out);

	always @(negedge clk) begin
		if(wipe==1) begin
			out<={5'b00000, rtData, aluOut, 5'b00000};//add $0, $0, $0
		end
		else begin
			out<={regNum, rtData, aluOut, controls};
		end
	end

endmodule