clear;clc;clf;

f0 = 134000000;
B = 10000000;

n0 = 25000;
sprate = 500000000;
t0 = n0/sprate;
fc = 139000000;

t = linspace(0,t0,n0);
ipsig = sin((2*pi*(f0-B/2)*t)+(pi*(B/t0)*t.*t));
w = linspace(-1,1,n0);
SI = ipsig.*cos(2*pi*f0*t);
SQ = ipsig.*sin(2*pi*f0*t);

window = kaiser(16,5.653);
b = fir1(15,0.62,window);
[H,W] = freqz(b,1);
y1 = fftfilt(b,SI);
y2 = fftfilt(b,SQ);

SII = resample(y1,12000000,500000000);
SQQ = resample(y2,12000000,500000000);

t1 = linspace(0,t0,600);
w1 = linspace(-1,1,600);

Y1 = SI + 1i*SQ;
Y2 = y1 + 1i*y2;
Y3 = SII + 1i*SQQ;

figure(1);
subplot(3,1,1);
% plot(w,20*log10(fftshift(abs(fft(Y1)))));
plot(t(1:6250),Y1(1:6250));
title('基础信号');
grid on;
figure(1);
subplot(3,1,2);
% plot(w,20*log10(fftshift(abs(fft(Y2)))));
plot(t(1:6250),Y2(1:6250));
title('滤波后信号');
grid on;
figure(1);
subplot(3,1,3);
% plot(w1,20*log10(fftshift(abs(fft(Y3)))));
plot(t1(1:150),Y3(1:150));
title('改变采样率后的信号');
grid on;
figure(2);
plot(w1,20*log10(fftshift(abs(fft(Y3)))));
title('最终得到的复信号频谱');
grid on;

