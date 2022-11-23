function X = DSB
fs1 = 150*1e3;%% 调制信号采样频率
fs2 = 15*1e6;%% 载波信号采样频率
fc = 4*218014;
t1 = 0:1/fs1:0.001;
t2 = 0:1/fs2:0.00001;
n1 = length(t1);
n2 = length(t2);
N1 = 0:fs1/(n1-1):fs1;
N2 = 0:fs2/(n2-1):fs2;
f1 = sin(2*pi*2*1000.*t1) ;
f2 = sin(2*pi*3*1000.*t1);
c = cos(2*pi*fc*t2); %% 载波信号
f = f1+f2; %% 原始信号
fn = abs(fft(f1)) + abs(fft(f2));
f12 = f1 .* cos(2*pi*fc*t2);
f22 = f2 .* cos(2*pi*fc*t2);
X = f12 + f22; 

figure(1);
stem(t1,f);
title('原始信号波形');

figure(2);
stem(t2,c);
title('载波信号波形');



figure(3);
stem(t2,X);
title('载波后的输出信号时域');

figure(4);
Xn = abs(fft(X));
plot(N2,Xn);
title('载波后的输出信号频谱');

figure(5);
plot(N1,fn);
axis([1000 4000,0 100]);
title('原始信号频谱');


end
