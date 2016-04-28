module CPU(
	input sclk,
	input reset,
	input load,
	input [31:0]addr,
	input [31:0]instr
	);
	
	//wire [31:0]addr = 0;
    //wire [31:0]instr = 0;
	wire exit;
	wire wake1;
	wire RegRuntime1;
	wire [31:0]PC1;
	wire PC1Load;
	wire [31:0]PCfromCPU1;
	core0 c0 (sclk, reset, load, addr, instr, exit, PCfromCPU1, wake1, RegRuntime1, PC1, PC1Load);
	core1 c1 (sclk, reset, load, addr, instr, wake1, RegRuntime1, PC1, PC1Load, exit, PCfromCPU1);
	//core0 c0 (sclk, reset, load, 0, 0, exit, 0, wake1, RegRuntime1, PC1, PC1Load);
    //core1 c1 (sclk, reset, load, 0, 0, wake1, RegRuntime1, PC1, PC1Load, exit, PCfromCPU1);
endmodule