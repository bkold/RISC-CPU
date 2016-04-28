module Registers_extended(
	input [5:0]R0,//RS
	input [5:0]R1,//RT
	input [31:0]EWD,//Data to be written in E stage for $ra
	input [5:0]MWR,//register number for reg write in M stage, for W stage bypass
	input [31:0]MWD,//data for above
	input [5:0]WR,//reg number for regular W stage write
	input [31:0]WD,//data for above
	input [1:0]EWrite, //lsb is write or not, msb is which runtime
	input [1:0]SWrite,//for special JAL to backup PC
	input MWrite,
	input WWrite,
	input clk,
	output reg [31:0]D0,
	output reg [31:0]D1);

	reg [31:0] RegBlock [63:0];

	always @(*) begin
		if(clk==0) begin//on negitive edge, write
			if(SWrite[0]) begin
				RegBlock[{SWrite[1], 5'd1}]<=EWD;
			end
			if(EWrite[0]) begin
				RegBlock[{EWrite[1], 5'd31}]<=EWD;
			end
			if(MWrite && MWR!=0 && MWR!=32) begin
				RegBlock[MWR]<=MWD;
			end
			if(WWrite && WR!=0 && MWR!=32 && MWR!=WR) begin
				RegBlock[WR]<=WD;
			end
			RegBlock[0]<=0;
			RegBlock[32]<=0;
		end
		else begin //on positive edge, read
			D0<=RegBlock[R0];
			D1<=RegBlock[R1];
		end
	end

endmodule