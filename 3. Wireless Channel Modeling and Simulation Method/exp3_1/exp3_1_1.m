% File: c13_tiv1.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%
f1 = 128;					% default signal frequency
f2 = 512;
bdoppler = 64;				% default doppler sampling
fs = 8192; 					% default sampling frequency
tduration = 1;				% default duration   
%
ts = 1.0/fs;				% sampling period 
n = tduration*fs;			% number of samples
t = ts*(0:n-1);			    % time vector
x = exp(i*2*pi*f1*t)+exp(i*2*pi*f2*t);	    % complex signal
zz1 = zeros(1,n);
zz2 = zeros(1,n);
%
% Generate Uncorrelated seq of Complex Gaussian Samples
%
z1 = randn(1,n)+ i*randn(1,n);
z2 = randn(1,n)+ i*randn(1,n);
%
% Filter the uncorrelated samples to generate correlated samples
%
coefft = exp(-bdoppler*2*pi*ts);
h = waitbar(0,'Filtering Loop in Progress');
for k=2:n
   zz1(k) = (ts*z1(k))+coefft*zz1(k-1);
   zz2(k) = (ts*z2(k))+coefft*zz2(k-1);
   waitbar(k/n)
end
close(h)
y1 = x.*zz1; 			% filtered output of LTV system
y2 = x.*zz2;
%
% Plot the results in time domain and frequency domain
%
[psdzz,freq] = log_psd(zz1,n,ts);

figure;
plot(freq,psdzz); grid;
ylabel('Impulse Response in dB')
xlabel('Frequency')
title('PSD of the Impulse Response');

zzz = abs(zz1.^2)/(mean(abs(zz1.^2)));
figure; 
plot(10*log10(zzz)); grid;
ylabel('Sq. Mag. of h(t) in dB')
xlabel('Time Sample Index')
title('Normalized Magnitude Square of the Impulse Response in dB');

[psdx1,freq] = log_psd(x,n,ts); 
figure; 
plot(freq,psdx1); grid;
ylabel('PSD of Tone Input in dB')
xlabel('Frequency')
title('PSD of Tone Input to the LTV System');

[psdy1,freq] = log_psd(y1,n,ts);
figure; 
plot(freq,psdy1); grid;
ylabel('PSD of Output in dB')
xlabel('Frequency')
title('Spread Output of the LTV System');
% End of script file.