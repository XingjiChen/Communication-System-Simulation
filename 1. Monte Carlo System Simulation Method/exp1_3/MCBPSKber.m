EbNodB = 0:10; 
z = 10.^(EbNodB/10); 
delay = 5; 
BER = zeros(1,length(z)); 
Errors = zeros(1,length(z)); 
BER_T = q(sqrt(2*z)); 
N = round(20./BER_T); 
FilterSwitch = 1; 
for k=1:length(z)
    N(k) = max(1000,N(k)); 
    [BER(k),Errors(k)] = MCBPSKrun(N(k),z(k),delay,FilterSwitch) ;
end
semilogy(EbNodB,BER,'o',EbNodB,BER_T) ;
xlabel('E_b/N_0 - dB'); ylabel('Bit Error Rate'); 
grid
legend('System Under Study','AWGN Reference') ;
% End of script file.
