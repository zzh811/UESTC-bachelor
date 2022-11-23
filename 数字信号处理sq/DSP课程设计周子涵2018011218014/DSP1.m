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

plot(t(1:200),ipsig(1:200));
title('输入信号时域');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(2);

w = linspace(-1,1,n0);
plot(w,fftshift(abs(fft(ipsig))));
title('输入信号幅频');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(3);

plot(w,fftshift(angle(fft(ipsig))));
title('输入信号相频');
xlabel('w');ylabel('∠X(ejw)');
grid on;
legend('modulated signal');
