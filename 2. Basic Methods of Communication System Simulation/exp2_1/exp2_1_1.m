close all
fs=10;
ts=1/fs;
N=200;
df=0.01;
t=0:ts:(N-1)*ts;
x=5*sin(6*pi*t)+3*sin(8*pi*t);

%% original signal
figure
plot(t,x)
xlim([0 10])
title('original signal time-base')
xlabel('time')
ylabel('altitude')

[X,x0,df1]=fftseq(x,ts,df);
X1=X/N;
f=[0:df1:5*df1*length(x0)-1*df1]-5*fs/2;
figure
P=[X1 X1 X1 X1 X1];
plot(f,fftshift(abs(P)))
title('original signal frequency-base')
xlabel('frequency')
ylabel('altitude')

%% singal passes LPF
P1=[X1];
f1=[0:df1:df1*length(x0)-df1]-fs/2;
figure
plot(f1,fftshift(abs(P1)))
title('singal passes LPF')
xlabel('frequency')
ylabel('altitude')

%% restored signal
I=ifft(X1);
figure
plot(t,x,t,I(1:length(t))*N)
xlim([0 10])
title('restored signal')
xlabel('time')
ylabel('altitude')
