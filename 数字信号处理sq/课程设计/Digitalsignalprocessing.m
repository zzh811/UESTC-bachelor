clear;clc;clf;

f0 = 134000000;
B = 10000000;

n0 = 25000;
sprate = 500000000;
t0 = n0/sprate;
fc = 139000000;

t = linspace(0,t0,n0);
ipsig = sin((2*pi*(f0-B/2)*t)+(pi*(B/t0)*t.*t));

figure(1);
subplot(3,1,1);
plot(t(1:250),ipsig(1:250));
title('输入信号时域');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(1);
subplot(3,1,2);
w = linspace(-1,1,n0);
plot(w,(20*log10(fftshift(abs(fft(ipsig))))));
title('输入信号幅频');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(1);
subplot(3,1,3);
plot(w,(20*log10(fftshift(angle(fft(ipsig))))));
title('输入信号相频');
xlabel('w');ylabel('∠X(ejw)');
grid on;
legend('modulated signal');

%2、设计NCO频率
SI = ipsig.*cos(2*pi*f0*t);
figure(2);
subplot(3,1,1);
plot(t(1:250),SI(1:250));
title('SI时域');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(2);
subplot(3,1,2);
plot(w,20*log10(fftshift(abs(fft(SI)))));
title('SI幅频');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(2);
subplot(3,1,3);
plot(w,20*log10(fftshift(angle(fft(SI)))));
title('SI相频');
xlabel('w');ylabel('∠X(ejw)');
grid on;
legend('modulated signal');


SQ = ipsig.*sin(2*pi*f0*t);
figure(3);
subplot(3,1,1);
plot(t(1:250),SQ(1:250));
title('SQ时域');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(3);
subplot(3,1,2);
plot(w,20*log10(fftshift(abs(fft(SQ)))));
title('SQ幅频');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(3);
subplot(3,1,3);
plot(w,20*log10(fftshift(angle(fft(SQ)))));
title('SQ相频');
xlabel('w');ylabel('∠X(ejw)');
grid on;
legend('modulated signal');

%3、滤波器设计
window = kaiser(16,5.653);
b = fir1(15,0.62,window);
[H,W] = freqz(b,1);
figure(4);
plot(W,20*log10(abs(H)));
title('滤波器幅频');
xlabel('w');ylabel('dB');
grid on;
figure(5);
plot(W,20*log10(angle(H)));
title('滤波器相频');
xlabel('w');ylabel('dB');
grid on;

%群延时
grd = -1*diff(angle(H));
grd = padarray(grd,[1 0],'replicate','post') ;
% ee = linspace(-1,1,511);
figure(6);
plot(W,20*log10(grd));
title('群延时');
xlabel('w');ylabel('dB');
grid on;


%I
y1 = fftfilt(b,SI);
figure(7);

plot(t(1:25000),y1(1:25000));
title('SI滤波后时域');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(8);

plot(w,20*log10(fftshift(abs(fft(y1)))));
title('SI滤波后幅频');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(9);

plot(w,20*log10(fftshift(angle(fft(y1)))));
title('SI滤波后相频');
xlabel('w');ylabel('∠X(ejw)');
grid on;
legend('modulated signal');

%Q
y2 = fftfilt(b,SQ);
figure(10);

plot(t(1:100),y1(1:100));
title('SQ滤波后时域');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(11);

plot(w,20*log10(fftshift(abs(fft(y2)))));
title('SQ滤波后幅频');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(12);

plot(w,20*log10(fftshift(angle(fft(y2)))));
title('SQ滤波后相频');
xlabel('w');ylabel('∠X(ejw)');
grid on;
legend('modulated signal');

%抽取或内插
SII = resample(y1,12000000,500000000);
figure(13);
t1 = linspace(0,t0,600);
plot(t1(1:600),SII(1:600));
title('改变采样率后SI时域');
SQQ = resample(y2,12000000,500000000);
figure(14);
w1 = linspace(-1,1,600);
plot(w1(1:600),20*log10(fftshift(abs(fft(SQQ)))));
title('改变采样率后SQ幅频');



Y = y1 + 1i*y2;
figure(15);
plot(w,20*log10(fftshift(abs(fft(Y)))));

F = SII +1i*SQQ;
figure(16);
plot(w1(1:600),20*log10(fftshift(abs(fft(F)))));









