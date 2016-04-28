module InteruptModule(
	input signal,//from ALU
	input finished,//From control, signals that the interupt is done
	input [31:0]PC,
	input enable, //from control, activates module
	input reset, //button, sets en to 0
	output reg [31:0]interuptPC,
	output reg loadPC); //tells PC to load interuptPC, also wipes D reg and F reg to a noop
	
	reg en;
	reg [31:0]savedPC;

	always @(signal or posedge reset or posedge enable or finished) begin
		loadPC<=0;
		if (reset) begin //reset button pressed
			en<=0; //disable the module	
		end
		else if (enable) begin //enable instruction activating module; from control
			en<=1; //activate the module
		end
		else if (signal && en) begin //ALU sends overflow error and interupts are enabled
			interuptPC<=32'h00000004;//the address of a J pointing to an interupt routine
			savedPC<=PC-4;
			loadPC<=1;
			en<=0;
		end
		else if (finished) begin
			interuptPC<=savedPC;
			en<=1;
			loadPC<=1;
		end
	end

endmodule