module multiplexer2(in0, in1, sel, out);
	parameter size=32;
	input [size-1:0]in0;
	input [size-1:0]in1;
	input sel;
	output [size-1:0]out;

	assign out = (sel) ? in1 : in0; //if sel==0, then in0

endmodule