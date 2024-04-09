k = 50;
nsamp = 50000;
snrdb = zeros(1,17);
snrdb_triangle=zeros(1,17);
x = 4:20;

for m = 4:20
    signal = 0;
    noise = 0;
    f_fold = k*m/2;
 for j = 1:f_fold
     term = (sin(pi*j/k)/(2*pi*j/k))^2;
     signal = signal+term;
 end
 for j = (f_fold+1):nsamp
     term = (sin(pi*j/k)/(2*pi*j/k))^2;
     noise = noise+term;
 end
     snrdb(m-3) = 10*log10(signal/noise); 
end

plot(x,snrdb)
xlabel('Samples per symbol')
ylabel('Signal-to-aliasing noise ratio')
