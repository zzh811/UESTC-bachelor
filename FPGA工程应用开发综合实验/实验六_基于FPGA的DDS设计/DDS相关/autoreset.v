
	module autoreset(sysclk,enable,reset,reset_n);
	
	input sysclk;
	input enable;
	output reset,reset_n;
	
	reg reset;
	wire reset_n;
	
	reg [31:0] counter;
	
	assign reset_n = ~reset;
	
	always @(posedge sysclk)
	begin
		if(!enable)
		begin
			counter=0;
			reset=0;
		end
		else
		begin		
			if(counter<18000000)
			begin
				counter=counter+1;
				reset=1;
			end
			else
			begin
				counter=18000000;
				reset=0;
			end
		end
	end
	
endmodule	
			
	