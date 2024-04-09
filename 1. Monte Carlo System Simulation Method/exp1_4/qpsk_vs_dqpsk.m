PhaseError = 0:5:360;               % Phase Error at Receiver
Eb = 24; No = -50;                  % Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70;            % dB
EbNo = 10.^((Eb-ChannelAttenuation-No)/10); 
BER_T1 = 0.25*erfc(sqrt(EbNo)*ones(size(PhaseError)));
N1 = round(100./BER_T1); 
BER_T2 = 0.5*erfc(sqrt(EbNo)*ones(size(PhaseError)));
N2 = round(100./BER_T2);
BER_MC1 = zeros(size(PhaseError)); 
BER_MC2 = zeros(size(PhaseError)); 
 
for k1=1:length(PhaseError)
  BER_MC1(k1) = c214_MCQPSKrun01(N1(k1),Eb,No,ChannelAttenuation,0,0,...
    PhaseError(k1),0);
  disp(['Simulation ',num2str(k1*100/length(PhaseError)),'% Complete']);
end
 
for k2=1:length(PhaseError)
  BER_MC2(k2) = c214_MCQPSKrun(N2(k2),Eb,No,ChannelAttenuation,0,0,...
    PhaseError(k2),0);
  disp(['Simulation ',num2str(k2*100/length(PhaseError)),'% Complete']);
end
 
semilogy(PhaseError,BER_MC1,PhaseError,2*BER_T1,'-',...
    PhaseError,BER_MC2,'*',PhaseError,2*BER_T2,'-')
line(PhaseError,BER_MC1,'color','[0 0.4470 0.7410]','Marker','o');
line(PhaseError,BER_MC2,'color','[0.9290 0.6940 0.1250]','Marker','*');
xlabel('Phase Error (Degrees)'); 
ylabel('Bit Error Rate'); 
legend('QPSK MC BER Estimate','QPSK Theoretical BER',...
    'DQPSK MC BER Estimate','DQPSK Theoretical BER'); 
grid on;
 % End of script file.
