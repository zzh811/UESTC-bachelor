module	LCD_TEST (	//	Host Side
					      iCLK,iRST_N,mLCD_Done,
					     // LCD Side
					      mLCD_DATA,mLCD_RS,mLCD_Start);
//	Host Side
input			iCLK,iRST_N,mLCD_Done;
//	LCD Side
output	[7:0]	mLCD_DATA;
output			mLCD_RS,mLCD_Start;
//	Internal Wires/Registers
reg	[5:0]	LUT_INDEX;
reg	[8:0]	LUT_DATA;
reg	[5:0]	mLCD_ST;
reg	[17:0]	mDLY;
reg			mLCD_Start;
reg	[7:0]	mLCD_DATA;
reg			mLCD_RS;
wire		mLCD_Done;

parameter	LCD_INTIAL	=	0;
parameter	LCD_LINE1	=	5;//初始化
parameter	LCD_CH_LINE	=	LCD_LINE1+16;
parameter	LCD_LINE2	=	LCD_LINE1+16+1;
parameter	LUT_SIZE	=	LCD_LINE1+32+1;

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LUT_INDEX	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
	end
	else
	begin
		if(LUT_INDEX<LUT_SIZE)
		begin
			case(mLCD_ST)
			0:	begin//描述此行代码含义
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
			1:	begin//描述此行代码含义
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;					
					end
				end
			2:	begin//描述此行代码含义
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	3;
					end
				end
			3:	begin//描述此行代码含义
					LUT_INDEX	<=	LUT_INDEX+1;
					mLCD_ST	<=	0;
				end
			endcase
		end
	end
end

always
begin
	case(LUT_INDEX)
	//	Initial
	LCD_INTIAL+0:	LUT_DATA	<=	9'h038;//描述此行代码含义
	LCD_INTIAL+1:	LUT_DATA	<=	9'h00C;//描述此行代码含义
	LCD_INTIAL+2:	LUT_DATA	<=	9'h001;//描述此行代码含义
	LCD_INTIAL+3:	LUT_DATA	<=	9'h006;//描述此行代码含义
	LCD_INTIAL+4:	LUT_DATA	<=	9'h080;//描述此行代码含义
	//	Line 1
	LCD_LINE1+0:	LUT_DATA	<=	9'h120;	//	Welcome to the
	LCD_LINE1+1:	LUT_DATA	<=	9'h157;
	LCD_LINE1+2:	LUT_DATA	<=	9'h165;
	LCD_LINE1+3:	LUT_DATA	<=	9'h16C;
	LCD_LINE1+4:	LUT_DATA	<=	9'h163;
	LCD_LINE1+5:	LUT_DATA	<=	9'h16F;
	LCD_LINE1+6:	LUT_DATA	<=	9'h16D;
	LCD_LINE1+7:	LUT_DATA	<=	9'h165;
	LCD_LINE1+8:	LUT_DATA	<=	9'h120;
	LCD_LINE1+9:	LUT_DATA	<=	9'h174;
	LCD_LINE1+10:	LUT_DATA	<=	9'h16F;
	LCD_LINE1+11:	LUT_DATA	<=	9'h120;
	LCD_LINE1+12:	LUT_DATA	<=	9'h174;
	LCD_LINE1+13:	LUT_DATA	<=	9'h168;
	LCD_LINE1+14:	LUT_DATA	<=	9'h165;
	LCD_LINE1+15:	LUT_DATA	<=	9'h120;
	//	Change Line
	LCD_CH_LINE:	LUT_DATA	<=	9'h0C0;//描述此行代码含义
	//	Line 2
	LCD_LINE2+0:	LUT_DATA	<=	9'h145;	//	ETCEIS of UESTC
	LCD_LINE2+1:	LUT_DATA	<=	9'h154;	
	LCD_LINE2+2:	LUT_DATA	<=	9'h143;
	LCD_LINE2+3:	LUT_DATA	<=	9'h145;
	LCD_LINE2+4:	LUT_DATA	<=	9'h149;
	LCD_LINE2+5:	LUT_DATA	<=	9'h153;
	LCD_LINE2+6:	LUT_DATA	<=	9'h120;
	LCD_LINE2+7:	LUT_DATA	<=	9'h16F;
	LCD_LINE2+8:	LUT_DATA	<=	9'h166;
	LCD_LINE2+9:	LUT_DATA	<=	9'h120;
	LCD_LINE2+10:	LUT_DATA	<=	9'h155;
	LCD_LINE2+11:	LUT_DATA	<=	9'h145;
	LCD_LINE2+12:	LUT_DATA	<=	9'h153;
	LCD_LINE2+13:	LUT_DATA	<=	9'h154;
	LCD_LINE2+14:	LUT_DATA	<=	9'h143;
	LCD_LINE2+15:	LUT_DATA	<=	9'h121;//Space
	default:		LUT_DATA	<=	9'h120;
	endcase
end
endmodule