module FReg_extended(
	input [31:0]instr,	
	input [31:0]pc,
	input runtime,
	input runtimeBranch,
	input clk,
	input wake,
	input wipe,
	input jumpWipe,
	input bcpuWipe,
	input reset, 
	input [31:0]jumpAddr, //from BJComp, confusingly called newPC on upper level
	input [31:0]newPC, //from BranchCPU
	output reg [64:0]out);

	always @(negedge clk or posedge reset or posedge bcpuWipe) begin
		if(reset) begin
			out<={1'b0, 32'd0, 32'h00000008};//add $0, $0, $0
		end
		else if(bcpuWipe) begin
			out<={runtimeBranch, newPC, 32'h00000008};
		end
		else if(wipe==1) begin
			out<={runtime, pc, 32'h00000008};//add $0, $0, $0
		end
		else if(jumpWipe==1) begin
			out<={runtime, jumpAddr, instr};
		end
		else begin
			out<={runtime, pc, instr};
		end		
	end

endmodule