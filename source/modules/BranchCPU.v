module BranchCPU(
	input [4:0]CPURuntime,//which instance of registers to use for CPUNum
	input [4:0]CPUNum,//which CPU to activate
	input [31:0]CPUAddress,//address to be loaded to CPUNum
	input reset,
	input CPUB,//branch control signal from CPU0
	input LoadAddress,//load address from cpu0
	input CPU1Exit,//set CPU1 to sleep control signal, from CPU1
	input sclk,//system clock
	input [31:0]inPC1, //from CPU1 pc, the pc before branching 
	output wake1,//value determining if clockwait is active
	output RegRuntime1,//which runtime to run CPUNum
	output [31:0]PC1,//PC to run CPUNum from
	output PC1Load,//signal to load PC1, connected to mux
	output [31:0]storedPC
	);
	
	reg wake1;
	reg RegRuntime1;
	reg [31:0]PC1;
	reg PC1Load;
	reg [31:0]storedPC;

	always @(*) begin
		if(reset) begin
			wake1<=0;
			storedPC<=0;
			PC1Load<=0;
		end
		else if(sclk==0) begin
			PC1Load<=0;
		end		
		else if(LoadAddress) begin // BCPUJ, stores PC1 for Branch
			storedPC<=inPC1;
			PC1<=CPUAddress;
		end
		else if(CPUB) begin //BCPU, load in PC1
			if(CPUNum==1) begin
				wake1<=1;
				RegRuntime1<=CPURuntime[0];
				PC1Load<=1;
			end		
			//other CPU Numbers go here				
		end
		else if(CPU1Exit) begin
			wake1<=0;
		end
	end

endmodule
