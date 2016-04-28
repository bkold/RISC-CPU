module FReg(
	input [31:0]instr,
	input [31:0]pc,
	input clk,
	input wipe,
	input jumpWipe,
	input reset, 
	input [31:0]jumpAddr,
	output reg [63:0]out);

	always @(negedge clk or posedge reset) begin
		if(reset) begin
			out<={32'd0, 32'h00000008};//add $0, $0, $0
		end
		else if(wipe==1) begin
			out<={pc, 32'h00000008};//add $0, $0, $0
		end
		else if(jumpWipe==1) begin
			out<={jumpAddr, instr};
		end
		else begin
			out<={pc, instr};
		end		
	end

endmodule