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

window = kaiser(25,5.653);
b = fir1(24,0.59,window);
[H,W] = freqz(b,1);
figure(1);
plot(W,20*log10(abs(H)));
title('滤波器幅频');
xlabel('w');ylabel('dB');
grid on;
figure(2);
plot(W,20*log10(angle(H)));
title('滤波器相频');
xlabel('w');ylabel('dB');
grid on;

%群延时
grd = -1*diff(angle(H));
grd = padarray(grd,[1 0],'replicate','post') ;
% ee = linspace(-1,1,511);
figure(3);
plot(W,20*log10(grd));
title('群延时');
xlabel('w');ylabel('dB');
grid on;


%I
y1 = fftfilt(b,SI);
figure(4);

plot(t(1:1000),y1(1:1000));
title('SI滤波后时域');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(5);

plot(w,fftshift(abs(fft(y1))));
title('SI滤波后幅频');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(6);

plot(w,fftshift(angle(fft(y1))));
title('SI滤波后相频');
xlabel('w');ylabel('∠X(ejw)');
grid on;
legend('modulated signal');

%Q
y2 = fftfilt(b,SQ);
figure(7);

plot(t(1:1000),y1(1:1000));
title('SQ滤波后时域');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(8);

plot(w,fftshift(abs(fft(y2))));
title('SQ滤波后幅频');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(9);

plot(w,fftshift(angle(fft(y2))));
title('SQ滤波后相频');
xlabel('w');ylabel('∠X(ejw)');
grid on;
legend('modulated signal');