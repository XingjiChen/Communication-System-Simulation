
semilogy(EbNodB,BER_T,'b-',EbNodB,BER_MC,'ro-',EbNodB1,pesystem_rayleigh,'g*-',EbNodB,pesystem,'m^-')
grid on;
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate'); 
hold on
legend('Theoretical BER','MC BER Estimate','System Under Rayleigh','System Under Doppler'); 

axis([2 8 0 1])
