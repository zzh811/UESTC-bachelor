module myclock(RESET,CLK,FLAG,UP,DWN,Centi_second,Second,Minute,Hour);
	input RESET,CLK,UP,DWN;
	output [7:0] Hour,Minute,Second,Centi_second;
	input [1:0] FLAG;
	
	reg [5:0] m_H,m_M,m_S;   
	reg [6:0] m_MS;
	
	assign Hour=m_H;
	assign Minute=m_M;
	assign Second=m_S;
	assign Centi_second=m_MS;

always@(posedge CLK)
	if(!RESET)
		begin
			m_H<=8'd23;
         m_M<=8'd59;
         m_S<=8'b00110010;
         m_MS<=8'b0;
		end 
	
	else if(FLAG==2'b01)//校时
		begin
			if(UP)
				begin
					if(m_H==8'd23)
						m_H<=8'd0;
					else
						m_H<=m_H+1'b1;
				end
			else if(DWN)
				begin
					if(m_H==8'd00)
						m_H<=8'd23;
					else
						m_H<=m_H-1'b1;
				end
		end
	else if(FLAG==2'b10)//校分
		begin
			if(UP)
				begin
					if(m_M==8'd59)
						m_M<=8'd0;
					else
						m_M<=m_M+1'b1;
				end
			else if(DWN)
				begin
					if(m_M==8'd00)
						m_M<=8'd59;
					else
						m_M<=m_M-1'b1;
				end
		end
	else if(FLAG==2'b11)//校秒
		begin
			if(UP)
				begin
					if(m_S==8'd59)
						m_S<=8'd0;
					else
						m_S<=m_S+1'b1;
				end
			else if(DWN)
				begin
					if(m_S==8'd00)
						m_S<=8'd59;
					else
						m_S<=m_S-1'b1;
				end
		end
	
	
	else //正常计时
		begin
			if(m_MS==8'd99)
				begin
					m_MS<=8'd0; 
						if(m_S==8'd59)
							begin
								m_S<=8'd0;
								if(m_M==8'd59)
									begin
										m_M<=8'd0;
											if(m_H==8'd23)
												m_H<=0;
											else
												m_H<=m_H+1'b1;
									end
								else
									m_M<=m_M+8'd1;
							end
						else
							m_S<=m_S+1'b1;
				end
			else
				m_MS<=m_MS+1'b1; 
		end
endmodule