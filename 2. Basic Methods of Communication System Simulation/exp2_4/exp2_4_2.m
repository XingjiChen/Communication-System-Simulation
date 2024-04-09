clear all

t = 0:0.001:0.5; 
x = 6*cos(240*pi*t+2*sin(24*pi*t));
y = fft(x); 
m = abs(y); 
p = angle(y); 
f = (0:length(y)-1)*99/length(y); 

subplot(2,1,1);
plot(f,m); 
title('amplitude of X(f)');
xlabel('frequency')
ylabel('amplitude')
set(gca,'XTick',[15 40 60 85]);

subplot(2,1,2);
plot(f,p); 
title('phase of X(f)');
xlabel('frequency')
ylabel('phase')
set(gca,'XTick',[15 40 60 85]); 