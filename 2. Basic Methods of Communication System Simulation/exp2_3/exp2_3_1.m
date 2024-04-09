clear all

t=-10:1/100:10;
xdt=8./(pi.*t).*sin(20.*pi.*t);

figure
plot(t,xdt)
xlim([-1 1])
xlabel('xd(t)')
ylabel('amplitude')

xdt(isnan(xdt))=0;
xdf=fft(xdt);
f=(0:length(xdf)-1)*99/length(xdf); 

figure
plot(f-50,abs(fftshift(xdf)))
xlabel('Xd(f)')
ylabel('amplitude')
