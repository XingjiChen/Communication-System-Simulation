clear all

t = 0:0.001:0.6; 
x = 6*cos(240*pi*t+2*sin(24*pi*t));
z = hilbert(x);
x1= fft(z.*exp(-j*2*pi*100*t));
m = abs(x1);
f = (0:length(x1)-1)*99/length(x1);

subplot(2,1,1);
plot(f,m);
title('amplitude of X~(f)');
xlabel('frequency')
ylabel('amplitude')

p=angle(x1);
subplot(2,1,2);
plot(f,p);
title('phase of X~(f)');
xlabel('frequency')
ylabel('phase')