module auto_reset(sysclk,locked,reset,en);
	
	input sysclk;
	input locked;
	output reset,en;
	
	reg reset;
	reg en;
	
	reg [31:0] counter;

	
	always @(posedge sysclk)
	begin
		if(!locked)
		begin
			counter=0;
			reset=1;
			en=0;
		end
		else
		begin		
			if(counter<5000000)//wait 5 seconds
			begin
				counter=counter+1;
				reset=1;
				en=0;
			end
			else
			begin
				counter=5000000;
				reset=0;
				en=1;
			end
		end
	end
	
endmodule	
			
	