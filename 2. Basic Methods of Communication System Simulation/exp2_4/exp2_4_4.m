clear all

t = 0:0.001:0.7; 
x = 6*cos(240*pi*t+2*sin(24*pi*t));
z = hilbert(x);
xl= z.*exp(-j*2*pi*120*t);
xd= real(xl);
xq= -j*(xl-xd);

subplot(2,1,1)
plot(t,xd);
title('practical xd')
xlabel('time')
ylabel('amplitude')

subplot(2,1,2);
plot(t,xq);
title('practical xq')
xlabel('time')
ylabel('amplitude')
