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

figure(1);
plot(t1(1:50),SII(1:50));
title('改变采样率后SI时域');
figure(2);
plot(w1(1:600),20*log10(fftshift(abs(fft(SII)))));
title('改变采样率后SI幅频');
figure(3);
plot(w1(1:600),20*log10(fftshift(angle(fft(SII)))));
title('改变采样率后SI相频');

figure(4);
plot(t1(1:50),SQQ(1:50));
title('改变采样率后SQ时域');
figure(5);
plot(w1(1:600),20*log10(fftshift(abs(fft(SQQ)))));
title('改变采样率后SQ幅频');
figure(6);
plot(w1(1:600),20*log10(fftshift(angle(fft(SQQ)))));
title('改变采样率后SQ相频');


