module core1(
	input sclk, 
	input reset,
	input load,
	input [31:0]loadAddress,
	input [31:0]loadInstruction,
	input wake1,
	input RegRuntime1,
	input [31:0]PC1,
	input PC1Load,
	output CPU1Exit,
	output currentAddress);
	
	wire clk;
	//F Stage
	wire [31:0]newPC;
	wire [31:0]currentAddress;
	wire [31:0]instruction;
	wire [31:0]currentAddress_4;
	wire [64:0]FRegOut;
	wire wipe;
	wire [74:0]ERegOut;
	wire [31:0]ramRead;
	wire jumpSig;
	wire [31:0]PCMuxOut;
	wire runtime;
	assign CPU1Exit = controls[23];
	multiplexer2 muxX(newPC, PC1, PC1Load, PCMuxOut);
	PCreg_extended pc(PCMuxOut, RegRuntime1, clk, PC1Load, reset, currentAddress, runtime);
	RAM ram(currentAddress, ERegOut[36:5], ERegOut[68:37], clk, load, loadAddress, loadInstruction, ERegOut[3], ERegOut[2], instruction, ramRead);
	FReg_extended freg(instruction, currentAddress_4, runtime, RegRuntime1, clk, wake1, wipe, jumpSig, PC1Load, reset, newPC, PC1, FRegOut);
	Adder4 adder4(currentAddress, currentAddress_4);

	wire [31:0]extenderOut;
	wire [31:0]D0;
	wire [31:0]D1;
	wire [28:0]controls;
	wire [157:0]DRegOut;
	wire [71:0]MRegOut;
	wire [31:0]mux4Out;
	Registers_extended registers({FRegOut[64], FRegOut[25:21]}, {FRegOut[64], FRegOut[20:16]}, DRegOut[49:18], ERegOut[74:69], ERegOut[36:5], MRegOut[71:66], mux4Out, DRegOut[17:16], 2'b00, ERegOut[4], MRegOut[1], clk, D0, D1);
	Signextender extender(FRegOut[15:0], controls[16], extenderOut);
	Control_extended control(FRegOut[31:0], FRegOut[64], reset, controls);
	ClockWait clockwait(controls[15], FRegOut[15:0], FRegOut[15:11], sclk, wake1, reset, clk);
	BJComp bjcomp(controls[28:24], FRegOut[25:0], extenderOut, D0, D1, FRegOut[63:32], newPC, jumpSig);
	DReg_extended dreg(controls[17:0], FRegOut[63:32], D0, D1, extenderOut, {FRegOut[64], FRegOut[20:16]}, {FRegOut[64], FRegOut[15:11]}, clk, wipe, DRegOut);

	wire [31:0]aluOut;
	wire [31:0]accOut;
	wire [31:0]mux1Out; 
	wire [31:0]mux2Out;
	wire [5:0]mux3Out;
	ALU alu(mux1Out, mux2Out, DRegOut[10:5], aluOut, wipe);
	//accumulator acc(aluOut, clk, accOut);
	multiplexer2 mux1(DRegOut[81:50], ERegOut[36:5], DRegOut[13],mux1Out);
	multiplexer2 mux2(DRegOut[145:114], DRegOut[113:82], DRegOut[12],mux2Out);
	multiplexer2 #(.size(6)) mux3(DRegOut[151:146], DRegOut[157:152], DRegOut[11],mux3Out);
	EReg_extended ereg(DRegOut[4:0], aluOut, DRegOut[145:114], mux3Out, clk, wipe, ERegOut);

	//M Stage
	MReg_extended mreg(ERegOut[1:0], ramRead, ERegOut[36:5], ERegOut[74:69], clk, MRegOut);

	//W Stage
	multiplexer2 mux4(MRegOut[33:2], MRegOut[65:34], MRegOut[0], mux4Out);
endmodule