/*
	main.c
	加减计数器
*/


#include <reg51.h>
#include <absacc.h>
#include <ctype.h>


//定义按键
sbit KEY2 = P2^0;		//按键1
sbit KEY3 = P2^1;		//按键2


/*
函数：KeyScan()
功能：键盘扫描
返回：扫描到的键值
*/
unsigned char KeyScan()
{
	unsigned char k = '\0';
	if ( KEY2 == 0 ) k = '+';
	if ( KEY3== 0 ) k = '-';
	return k;
}


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
函数：DispStr()
功能：在数码管上显示字符串
参数：
	x：显示的起始位置（0～7）
	*s：要显示的字符串（内容仅限16进制数字和减号）
*/
void DispStr(unsigned char x, unsigned char idata *s)
{
	unsigned char c;
	for (;;)
	{
		c = *s++;
		if ( c == '\0' ) break;
		DispChar(x++,c,0);
	}
}


/*
函数：ByteToStr()
功能：字节型变量c转换为十进制字符串
*/
void ByteToStr(unsigned char idata *s, unsigned char c)
{
	code unsigned char Tab[] = {100,10};
	unsigned char i;
	unsigned char t;
	for ( i=0; i<2; i++ )
	{
		t = c / Tab[i];
		*s++ = '0' + t;
		c -= t * Tab[i];
	}
	*s++ = '0' + c;
	*s = '\0';
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
说明：
	晶振用18MHz
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
	unsigned char idata s[4];
	unsigned char k;		//定义键值变量
	unsigned char cnt = 18;	//定义计数器变量
	SysInit();				//系统初始化
	ByteToStr(s,cnt);
	DispStr(5,s);		//先显示数值n
	for (;;)
	{
		for (;;)
		{
			Delay(50);		//延时50ms
			k = KeyScan();	//键盘扫描
			if ( k != '\0' ) break;		//如果有键按下，退出循环
		}
		switch ( k )		//判断键值，执行具体功能
		{
		case '+':
			if ( cnt < 31 ) cnt++;
			break;
		case '-':
			if ( cnt > 0 ) cnt--;
			break;
		default:
			break;
		}
		ByteToStr(s,cnt);
		DispStr(5,s);	//显示计数器值
		for (;;)
		{
			Delay(50);		//延时50ms
			if ( KeyScan() == '\0' ) break;	//如果按键抬起，退出循环
		}
	}
}

