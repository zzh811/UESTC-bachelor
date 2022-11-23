module PN_1023_gen_1  (sysclk,reset,pnclk, 
							  pnxs1_allone,pnxs1_code,							     
		                 pnclkpos);
					    
	
	input sysclk,reset,pnclk;
	output pnxs1_allone,pnxs1_code; 
	reg    pnxs1_allone,pnxs1_code;
	  
	output pnclkpos;
	wire pnclkpos;
	
	reg [9:0]  gxs1regshift;	  
	
	wire polyvalgxs1;
	
	reg [9:0]  gxs1_counter;
	reg [1:0]  tempa,tempb;
	
	parameter  gxs1_poly = 407;	
	parameter  gxs1_ip   = 1023;
	parameter  jdxs_cnt  = 1023;
	
	
/*-------------------------------------code clk gen---------------------------*/
always @(posedge sysclk)
	begin
		if(reset)
			begin
				tempb<=2'd0;
			end
		else
			begin
				tempb<={ tempb[0],pnclk };
			end
	end
assign	pnclkpos=( tempb[0] & ~tempb[1] );


/*-----------------------------------------short(1023) code gen------------------*/
assign polyvalgxs1=^(gxs1_poly & gxs1regshift);
							
always @(posedge sysclk)
	begin
		if(reset)
			begin
				gxs1regshift<=gxs1_ip;		
				gxs1_counter<=0;
			end
		else
			begin
				if(pnclkpos)
					begin
						if(gxs1_counter < jdxs_cnt-1)
							begin
								gxs1regshift<={polyvalgxs1,gxs1regshift[9:1]};																
								gxs1_counter<=gxs1_counter+18'd1;
							end
						else
							begin
								gxs1regshift<=gxs1_ip;								
								gxs1_counter<=0;
							end
					end
				else
					begin
						gxs1regshift<=gxs1regshift;						
						gxs1_counter<=gxs1_counter;
					end
			end
	end
	
always @(posedge sysclk)
	begin
		if(reset)
			begin
				pnxs1_code<=0;
				pnxs1_allone<=1;				
			end
		else
			begin
				pnxs1_code<=gxs1regshift[0];
				pnxs1_allone<=(gxs1regshift==gxs1_ip);				
			end
	end

	

endmodule  