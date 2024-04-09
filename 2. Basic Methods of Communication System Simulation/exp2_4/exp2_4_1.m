clear all

t = 0:0.005:0.7;
xd= 6*cos(2*sin(24*pi*t));
xq= 6*sin(2*sin(24*pi*t));

subplot(2,1,1)
plot(t,xd)
title('theoretical xd')
xlabel('time')
ylabel('amplitude')

subplot(2,1,2)
plot(t,xq)
title('theoretical xq')
xlabel('time')
ylabel('amplitude')