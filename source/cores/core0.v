module core0(
	input sclk, 
	input reset,
	input load,
	input [31:0]loadAddress,
	input [31:0]loadInstruction,
	input CPU1Exit,
	input [31:0]PCformCPU1,
	output wake1,
	output RegRuntime1,
	output [31:0]PC1,
	output PC1Load);

	wire clk;
	//F Stage
	wire [31:0]newPC;
	wire [31:0]currentAddress;
	wire [31:0]instruction;
	wire [31:0]currentAddress_4;
	wire [63:0]FRegOut;
	wire wipe;
	wire [73:0]ERegOut;
	wire [31:0]ramRead;
	wire jumpSig;
	PCreg pc(newPC, clk, reset, currentAddress);
	RAM ram(currentAddress, ERegOut[36:5], ERegOut[68:37], clk, load, loadAddress, loadInstruction, ERegOut[3], ERegOut[2], instruction, ramRead);
	FReg freg(instruction, currentAddress_4, clk, wipe, jumpSig, reset, newPC, FRegOut);
	Adder4 adder4(currentAddress, currentAddress_4);

	//D Stage-save brachCPU
	wire [31:0]extenderOut;
	wire [31:0]D0;
	wire [31:0]D1;
	wire [25:0]controls;
	wire [185:0]DRegOut;
	wire [70:0]MRegOut;
	wire [31:0]mux4Out;
	wire [31:0]mux5Out;
	wire [31:0]PC1Stored;
	multiplexer2 mux5({4'b0000, FRegOut[25:0], 2'b00}, D0, controls[17], mux5Out);
	BranchCPU branchcpu(FRegOut[20:16], FRegOut[25:21], mux5Out, reset, controls[18], controls[19], CPU1Exit, sclk, PCformCPU1, wake1, RegRuntime1, PC1, PC1Load, PC1Stored);
	Registers registers(FRegOut[25:21], FRegOut[20:16], DRegOut[79:48], DRegOut[47:16], ERegOut[73:69], ERegOut[36:5],MRegOut[70:66], mux4Out, DRegOut[15], DRegOut[14], ERegOut[4], MRegOut[1], clk, D0, D1);
	Signextender extender(FRegOut[15:0], controls[16], extenderOut);
	Control control(FRegOut[31:0], reset, controls);
	ClockWait clockwait(controls[16], FRegOut[15:0], FRegOut[15:11], sclk, 1'b1, reset, clk);
	BJComp bjcomp(controls[25:21], FRegOut[25:0], extenderOut, D0, D1, FRegOut[63:32], newPC, jumpSig);
	DReg dreg(controls[15:0], FRegOut[63:32], PC1Stored, D0, D1, extenderOut, FRegOut[20:16], FRegOut[15:11], clk, wipe, DRegOut);

	//E Stage
	wire [31:0]aluOut;
	wire [31:0]accOut;
	wire [31:0]mux1Out; 
	wire [31:0]mux2Out;
	wire [4:0]mux3Out;
	ALU alu(mux1Out, mux2Out, DRegOut[10:5], aluOut, wipe);
	//accumulator acc(aluOut, clk, accOut);
	multiplexer2 mux1(DRegOut[111:80], ERegOut[36:5], DRegOut[13],mux1Out);
	multiplexer2 mux2(DRegOut[175:144], DRegOut[143:112], DRegOut[12],mux2Out);
	multiplexer2 #(.size(5)) mux3(DRegOut[180:176], DRegOut[185:181], DRegOut[11],mux3Out);
	EReg ereg(DRegOut[4:0], aluOut, DRegOut[175:144], mux3Out, clk, wipe, ERegOut);

	//M Stage
	MReg mreg(ERegOut[1:0], ramRead, ERegOut[36:5], ERegOut[73:69], clk, MRegOut);

	//W Stage
	multiplexer2 mux4(MRegOut[33:2], MRegOut[65:34], MRegOut[0], mux4Out);

endmodule