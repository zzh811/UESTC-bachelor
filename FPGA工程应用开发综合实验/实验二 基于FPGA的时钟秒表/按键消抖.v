module adjust_test(clk,reset,press,updwnout);
	
	input clk,reset,press;
	output updwnout;

	reg updwnout;
	reg [31:0]cnt;
	
//-----------------------------
reg press_cnt;
localparam time_20ms = 1_000_000;

always @(posedge clk or negedge reset)
begin
    if(reset == 0)
        updwnout <=0;
    else if(cnt == time_20ms - 1)
        updwnout <= press;
end
always @(posedge clk or negedge reset)
begin
    if(reset == 0)
        cnt <= 0;
    else if (press_cnt)
        cnt <= cnt +1'b1;
    else
        cnt <= 0;
end
always @(posedge clk or negedge reset)
begin
    if (reset == 0)
        press_cnt <= 0;
    else if (press_cnt == 0 && press != updwnout)
        press_cnt <= 1;
    else if (cnt == time_20ms - 1)
        press_cnt <= 0;
end
//-----------------------------

endmodule
