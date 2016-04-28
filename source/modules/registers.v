module Registers(
	input [4:0]R0,//RS
	input [4:0]R1,//RT
	input [31:0]EWD,//Data to be written in E stage for $ra
	input [31:0]EWDCPU,//data from storedPC of branchCPU
	input [4:0]MWR,//register number for reg write in M stage, for W stage bypass
	input [31:0]MWD,//data for above
	input [4:0]WR,//reg number for regular W stage write
	input [31:0]WD,//data for above
	input EWrite,
	input CWrite,
	input MWrite,
	input WWrite,
	input clk,
	output reg [31:0]D0,
	output reg [31:0]D1);

	reg [31:0] RegBlock [31:0];

	always @(*) begin
		if(clk==0) begin//on negitive edge, write
			if(EWrite) begin
				RegBlock[31]<=EWD;
			end
			if(CWrite) begin
				RegBlock[30]<=EWDCPU;
			end
			if(MWrite && MWR!=0) begin
				RegBlock[MWR]<=MWD;
			end
			if(WWrite && WR!=0 && MWR!=WR) begin
				RegBlock[WR]<=WD;
			end
			RegBlock[0]<=0;
		end
		else begin //on positive edge, read
			D0<=RegBlock[R0];
			D1<=RegBlock[R1];
		end
	end

endmodule