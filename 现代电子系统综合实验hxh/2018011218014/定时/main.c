/*
	main.c
	简单的定时
*/


#include <reg51.h>	//包含8051的SFR寄存器定义头文件
#include <ABSACC.H>
sbit LED=P0^0;
sbit LED1=P0^2;
sbit LED2=P0^4;
sbit LED3=P0^6;


/*
函数：Delay()
功能：延时0.001 S～65.536 S
参数：t>0时，延时(t*0.001) S；    t=0时，延时65.536S
说明：晶振频率18MHz，定时1ms的定时器初值＝65536-0.001*(f/12))，f为晶振频率
*/

void Delay(unsigned int t)
{
	do
	{
		TH0 = 0xFA;
		TL0 = 0x24;		//设置定时器初值（对应0.001s）
		TR0 = 1;		//启动定时器
		while ( !TF0 );	//等待定时器溢出
		TR0 = 0;		//停止定时器
		TF0 = 0;		//清除溢出标志
	} while ( --t != 0 );	//循环t次
}


void main()
{
	TMOD &= 0x0F;
	TMOD |= 0x01;	//将定时器T0设置为方式1，即16位定时器
	for (;;)
	{
		LED=0;	//点亮LED
		LED1=0;	//点亮LED
		LED2=0;	//点亮LED
		LED3=0;	//点亮LED
		Delay(100);	//延时100ms
		LED=1;	//熄灭LED
		LED1=1;	//点亮LED
		LED2=1;	//点亮LED
		LED3=1;	//点亮LED
 		Delay(900);	//延时900ms
	}
}

