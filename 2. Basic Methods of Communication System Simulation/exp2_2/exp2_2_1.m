k=50;
nsamp=50000;
snrdb=zeros(1,17);
snrdb_triangle=zeros(1,17);
x=4:20;

for m=4:20
    signal=0;
    noise=0;
    signal_triangle=0;
    noise_triangle=0;
    f_fold=k*m/2;
 for j=1:f_fold
     term=(sin(pi*j/k)/(pi*j/k))^2;
     term_triangle=(cos(2*pi*j/k))^2/(pi^2*(1-(4*j/k)^2)^2);
     signal=signal+term;
     signal_triangle=signal_triangle+term_triangle;
 end
 for j=(f_fold+1):nsamp
     term=(sin(pi*j/k)/(pi*j/k))^2;
     term_triangle=(cos(2*pi*j/k))^2/(pi^2*(1-(4*j/k)^2)^2);
     noise=noise+term;
     noise_triangle= noise_triangle+term_triangle;
 end
     snrdb(m-3)=10*log10(signal/noise);
     snrdb_triangle(m-3)=10*log10(signal_triangle/noise_triangle);
end

plot(x,snrdb,x,snrdb_triangle);
xlabel('Samples per symbol');
ylabel('signal-to-aliasing noise ratio');
legend('MSK ( rectangular pulse )','MSK ( triangle pulse )')
