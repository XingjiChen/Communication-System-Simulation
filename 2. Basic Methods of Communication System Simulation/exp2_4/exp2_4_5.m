clear all

t = 0:0.001:0.7;
xd1= 6*cos(2*sin(24*pi*t));
xq1= 6*sin(2*sin(24*pi*t));

x = 6*cos(240*pi*t+2*sin(24*pi*t));
z = hilbert(x);
xl= z.*exp(-j*2*pi*120*t);
xd2= real(xl);
xq2= -j*(xl-xd2);

subplot(2,1,1)
plot(t,xd1,t,xd2)
title('xd')
xlabel('time')
ylabel('amplitude')
legend('theoretical xd','practical xd')

subplot(2,1,2)
plot(t,xq1,t,xq2)
title('xq')
xlabel('time')
ylabel('amplitude')
legend('theoretical xq','practical xq')
