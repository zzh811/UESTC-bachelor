
module DDS_ACC(clk,reset,delta,phaseout);
	
	input [31:0] delta;
	input clk,reset;
	output[31:0] phaseout;	
		
	reg [31:0] phaseout;	
		
//-----------------ACC-------------------------//	
	
always @(posedge clk)
	begin
	   if (!reset)
		   phaseout<=0;
		else
		   phaseout=phaseout+delta;
	end

endmodule
