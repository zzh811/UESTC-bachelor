/*
	main.c
	点亮LED
*/


#include <reg51.h>	          //包含8051的SFR寄存器定义头文件
#include <ABSACC.H>
sbit LED = P2^4;
void main()
{	P0=0x77;               //点亮LED（规定LED是低电平点亮的）
for (;;);	              //停机（在C51的main函数里，一般不允许执行返回操作）
}                                