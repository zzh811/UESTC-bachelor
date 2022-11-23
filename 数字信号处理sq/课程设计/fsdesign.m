clear;clc;clf;
%1、设计fs
%参数：中心频率f0 = 134 MHz
%      调制带宽B = 10 MHz
%      截止频率fc = 139 MHz
%      设计采样率fs = 500 MHz
%      时宽T = 50 微秒
f0 = 134000000;
B = 10000000;

n0 = 25000;
sprate = 500000000;
t0 = n0/sprate;
fc = 139000000;

t = linspace(0,t0,n0);
ipsig = sin((2*pi*(f0-B/2)*t)+(pi*(B/t0)*t.*t));

figure(1);
plot(t(1:100),ipsig(1:100));
title('时域');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(2);
w = linspace(-1,1,n0);
plot(w,20*log10(fftshift(abs(fft(ipsig)))));
title('幅频');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(3);
plot(w,20*log10(fftshift(angle(fft(ipsig)))));
title('相频');
xlabel('w');ylabel('∠X(ejw)');
grid on;
legend('modulated signal');
