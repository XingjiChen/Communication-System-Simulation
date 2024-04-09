clear all
clc

%% 带积分清除接收机的普通AWGN信道

Eb = 22:1:28; 
No = -50;					                % Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70;					% Channel attenuation in dB
EbNodB = (Eb-ChannelAttenuation)-No;	    % Eb/No in dB
EbNo = 10.^(EbNodB./10);					% Eb/No in linear units
BER_T = 0.5*erfc(sqrt(EbNo)); 			    % BER (theoretical)
N = round(20./BER_T);          			    % Symbols to transmit
BER_MC = zeros(size(Eb)); 					% Initialize BER vector

for k=1:length(Eb)        					% Main Loop
    BER_MC(k) = MyQPSKrun_usualQPSK(N(k),Eb(k),No,ChannelAttenuation,0,0,0,0);
    disp(['Simulation ',num2str(k*100/length(Eb)),'% Complete']);
end

semilogy(EbNodB,BER_T,'b-',EbNodB,BER_MC,'ro-')%理论误码率
grid on;
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate'); 
legend('Theoretical BER','MC BER Estimate'); 


%% 瑞利信道+AWGN

NN = 2^15;								% number of symbols
tb = 0.5;								% bit time
fs = 16;                                % samples/symbol
EbNodB1 = 0:1:10;						% Eb/N0 vector
% Establish QPSK signals
x = random_binary(NN,fs)+1i*random_binary(NN,fs);   % QPSK signal
% Input powers and delays
%瑞利信道
p0 = 0;
p1 = 0.2;
%delay = input('Enter tau > ');%平坦衰落，delay全为0
delay0 = 0;
delay1 = 0;
delay2 = 0;
% Set up the Complex Gaussian (Rayleigh) gains
gain1 = sqrt(p1)*abs(randn(1,NN) + 1i*randn(1,NN));

for k = 1:NN
   for kk=1:fs
       index=(k-1)*fs+kk;
       ggain1(1,index)=gain1(1,k);
   end
end

y1 = x;

for k=1:delay2 
    y2(1,k) = y1(1,k)*sqrt(p0);
end

for k=(delay2+1):(NN*fs)
    y2(1,k)= y1(1,k)*sqrt(p0)+y1(1,k-delay1)*ggain1(1,k);
end

% Matched filter
b = ones(1,fs); b = b/fs; a = 1;
y = filter(b,a,y2);

% End of simulation 
% Use the semianalytic BER estimator. The following sets 
% up the semi analytic estimator. Find the maximum magnitude 
% of the cross correlation and the corresponding lag.
[cor lags] = vxcorr(x,y);
[cmax nmax] = max(abs(cor));
timelag = lags(nmax);
theta = angle(cor(nmax));
y = y*exp(-1i*theta);

% Noise BW calibration
hh = impz(b,a);
ts = 1/16;
nbw = (fs/2)*sum(hh.^2);

% Delay the input, and do BER estimation on the last 128 bits. 
% Use middle sample. Make sure the index does not exceed number 
% of input points. Eb should be computed at the receiver input. 
index = (10*fs+8:fs:(NN-10)*fs+8);
xx = x(index);
yy = y(index-timelag+1);
[n1 n2] = size(y2); ny2=n1*n2;
eb = tb*sum(sum(abs(y2).^2))/ny2;
eb = eb/2;
[peideal_rayleigh,pesystem_rayleigh] = qpsk_berest(xx,yy,EbNodB1,eb,tb,nbw);

figure(2)
semilogy(EbNodB1,peideal_rayleigh,EbNodB1,pesystem_rayleigh,'ro-')
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Probability of Error');
legend('AWGN Reference','System Under Rayleigh')


%% 多普勒+AWGN

% Generate tapweights. 
fd = 100;
impw = jakes_filter(fd);

% Generate tap input processes and Run through doppler filter.
x1 = randn(1,256)+1i*randn(1,256);
y1 = filter(impw,1,x1);
x2 = randn(1,256)+1i*randn(1,256);
y2 = filter(impw,1,x2);

% Discard the first 128 points since the FIR filter transient.
% Scale them for power and Interpolate weight values.
% Interpolation factor=100 for the QPSK sampling rate of 160000/sec.
z1(1:128) = y1(129:256);
z2(1:128) = y2(129:256);
z2 = sqrt(0.5)*z2;
m = 100;
tw1 = linear_interp(z1,m);
tw2 = linear_interp(z2,m);

% Generate QPSK signal and filter it.
nbits = 512; 
nsamples = 16; 
ntotal = 8192;
qpsk_sig = random_binary(nbits,nsamples)+1i*random_binary(nbits,nsamples);
[b,a] = butter(5,1/16);					 % transmitter filter parameters

y2 = filter(b,a,qpsk_sig);			     % filtered signalv

% Genrate output of tap1 (size the vectors first). 
%input1 = qpsk_sig(1:8184); output1 = tw1(1:8184).*input1;
% Delay the input by eight samples (this is the delay specified 
% in term of number of samples at the sampling rate of 
% 16,000 samples/sec and genrate the output of tap 2.
%input2 = qpsk_sig(9:8192); output2 = tw2(9:8192).*input2;
% Add the two outptus and genrate overall output.
qpsk_output = tw1(1:8192).*y2;

% Matched filter
b = ones(1,nsamples);
b = b/nsamples; a = 1;	                  % matched filter parameters
y = filter(b,a,qpsk_output);			  % matched filter output

%基带信号解调，半解析法求误码率
[cor lags] = vxcorr(qpsk_sig,y);
cmax = max(abs(cor));
nmax = find(abs(cor)==cmax);
timelag = lags(nmax);
theta = angle(cor(nmax));
y = y*exp(-1i*theta);     				% derotate 

% Noise BW calibration
hh = impz(b,a);							% receiver impulse response
nbw = (nsamples/2)*sum(hh.^2);			% noise bandwidth

% Delay the input, and do BER estimation on the last 128 bits. 
% Use middle sample. Make sure the index does not exceed number 
% of input points. Eb should be computed at the receiver input. 
index = (10*nsamples+8:nsamples:(nbits-10)*nsamples+8);
xx = qpsk_sig(index);
yy = y(index-timelag+1);
[n1 n2] = size(y2);
ny2=n1*n2;
eb = tb*sum(sum(abs(y2).^2))/ny2;
eb = eb/2;
[peideal,pesystem] = qpsk_berest(xx,yy,EbNodB,eb,tb,nbw);

figure(3)
semilogy(EbNodB,peideal,EbNodB,pesystem,'ro-'); 
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate');
legend('AWGN Reference','System Under Doppler')
