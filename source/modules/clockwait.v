module ClockWait(
	input sleep, //from internel control, loads control
	input [15:0] value,
	input [4:0] divider,
	input sclk,
	input wake,//from BranchCPU, activates cpu
	input reset,
	output reg clk);

	reg [20:0] count;
	reg set;

	always @(sclk) begin
	   if(reset) begin
	       count<=0;
	       set<=0;
	   end
		else if (count>0 && sclk==0 && wake==1) begin
			//count down
			count=count-1;
			clk<=0;
		end
		else if(sleep==1 && sclk==1 && wake==1 && set==0) begin
			//load count
			count=value*(divider+1)+1;
			set<=1;
		end
		else if(count==0 && wake==1)begin
			clk <= sclk;
			set<=0;
		end
		else if(wake==0)begin
			clk<=0;
		end
	end

endmodule
	
