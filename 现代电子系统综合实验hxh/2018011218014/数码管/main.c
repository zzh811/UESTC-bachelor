/*
	main.c
	数码管的动态扫描显示
*/


#include <reg51.h>
#include <absacc.h>
#include <ctype.h>


//定义显示缓冲区（由定时中断程序自动扫描）
unsigned char DispBuf[8];


/*
函数：T1INTSVC()
功能：定时器T1的中断服务函数
*/
void T1INTSVC() interrupt 3
{
	code unsigned char com[] = {0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};
	static unsigned char n = 0;
	TR1 = 0;
	TH1 = 0xFC;
	TL1 = 0x66;
	TR1 = 1;
	XBYTE[0x7800] = 0xFF;		//暂停显示
	XBYTE[0x7801] = ~DispBuf[n];	//更新扫描数据
	XBYTE[0x7800] = ~com[n];	//重新显示
	n++;
	n &= 0x07;
}


/*
函数：DispClear()
功能：清除数码管的所有显示
*/
void DispClear()
{
	unsigned char i;
	for ( i=0; i<8; i++ )
	{
		DispBuf[i] = 0x00;
	}
}


/*
函数：DispChar()
功能：在数码管上显示字符
参数：
	x：数码管的坐标位置（0～7）
	c：要显示的字符（仅限16进制数字和减号）
	dp：是否显示小数点，0－不显示，1－显示
*/
void DispChar(unsigned char x, unsigned char c, bit dp)
{
	code unsigned char Tab[] =
	{//定义0123456789AbCdEF的数码管字型数据
		0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,
		0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71
	};
	unsigned char t;	//临时变量
//防止显示位置超出范围
	x &= 0x07;
	x = 7 - x;
//分析字符c，取得对应的数码管字型数据
	if ( c == '-' )
	{
		t = 0x40;
	}
	else
	{
		t = toint(c);	//toint()为库函数，详见C:\Keil\C51\HLP\C51.pdf
		if ( t < 16 )	//如果是16进制字符
		{
			t = Tab[t];	//查表，取得数码管字型数据
		}
		else
		{
			t = 0x00;	//如果是其它字符则显示为空白
		}
	}
//检查是否显示小数点
	if ( dp )
	{
		t |= 0x80;
	}
	else
	{
		t &= 0x7F;
	}
//送到显示缓冲区显示
	DispBuf[x] = t;
}


/*
函数：DispInit()
功能：数码管扫描显示初始化
*/
void DispInit()
{
	DispClear();	//初始为全灭
	EA = 0;
	TMOD &= 0x0F;
	TMOD |= 0x10;
	TH1 = 0xFC;
	TL1 = 0x66;
	TR1 = 1;
	ET1 = 1;
	EA = 1;
}


/*
函数：Delay()
功能：延时0.001～65.536s
参数：
	t>0时，延时(t*0.001)s
	t=0时，延时65.536s
*/
void Delay(unsigned int t)
{
	do
	{
		TH0 = 0xFA;
		TL0 = 0x24;
		TR0 = 1;
		while ( !TF0 );
		TR0 = 0;
		TF0 = 0;
	} while ( --t != 0 );
}


/*
函数：SysInit()
功能：系统初始化
*/
void SysInit()
{
	TMOD &= 0xF0;
	TMOD |= 0x01;	//设置定时器T0为16位定时器
	DispInit();		//数码管扫描显示初始化
}


void main()
{
	code unsigned char s[] = "0123456789abcdef";
	unsigned char i;
	unsigned char x;
	bit dp;
	SysInit();
	dp = 0;
	for (;;)
	{

		 
    	for ( i=0; i<16; i++ )
		{
			for ( x=0; x<8; x++ )
			{
			DispChar(x,s[i],dp);
			}
			Delay(1000);
		}  
		dp = !dp; 
	}
}

