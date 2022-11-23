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
figure(1);
subplot(3,1,1);
plot(t(1:250),SI(1:250));
title('SI ±”Ú');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(1);
subplot(3,1,2);
plot(w,20*log10(fftshift(abs(fft(SI)))));
title('SI∑˘∆µ');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(1);
subplot(3,1,3);
plot(w,20*log10(fftshift(angle(fft(SI)))));
title('SIœ‡∆µ');
xlabel('w');ylabel('°œX(ejw)');
grid on;
legend('modulated signal');


SQ = ipsig.*sin(2*pi*f0*t);
figure(2);
subplot(3,1,1);
plot(t(1:250),SQ(1:250));
title('SQ ±”Ú');
xlabel('t');ylabel('voltage');
grid on;
legend('modulated signal');

figure(2);
subplot(3,1,2);
plot(w,20*log10(fftshift(abs(fft(SQ)))));
title('SQ∑˘∆µ');
xlabel('w');ylabel('|X(eiw)|');
grid on;
legend('modulated signal');

figure(2);
subplot(3,1,3);
plot(w,20*log10(fftshift(angle(fft(SQ)))));
title('SQœ‡∆µ');
xlabel('w');ylabel('°œX(ejw)');
grid on;
legend('modulated signal');