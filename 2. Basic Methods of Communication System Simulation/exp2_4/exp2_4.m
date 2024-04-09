close all

N=1000;
fs=1000;
t=0:1/fs:(N-1)/fs;
ts=1/fs;
x=6*cos(240*pi*t+2*sin(24*pi*t));
df=0.01;
xd=6*cos(2*sin(24*pi*t));
xq=6*sin(2*sin(24*pi*t));

figure 
plot(t,xd)
title('theoretical xd')

figure
plot(t,xq)
title('theoretical xq')

[X,x0,df1]=fftseq(x,ts,df);
X1=X/N;
P=[X1];
f=[0:df1:df1*length(x0)-1*df1]-fs/2;

figure
plot(f,fftshift(abs(P)))
title('amplitude of X(f)')

figure
plot(f,fftshift(angle(P)))
title('phase of X(f)')

SB=(x+j*hilbert(x)).*exp(-j*240*pi*t);
xd1=real(SB);
xs1=imag(SB);
[XB,xb,df1]=fftseq(SB,ts,df);
f1=[0:df1:df1*length(x0)-1*df1]-fs/2+100;

figure
plot(f1,fftshift(abs(XB))/N)
title('equivalent low-pass signal')

figure
plot(t,xd1)
title('practical xd')

figure
plot(t,xs1)
title('practical xq')
