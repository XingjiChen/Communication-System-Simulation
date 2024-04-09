% File: c9_MCBPSK.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.

clear all

snrdB_min = -3; snrdB_max = 8;	        % SNR (in dB) limits 
snrdB = snrdB_min:1:snrdB_max;
Nsymbols = input('Enter number of symbols > ');
snr = 10.^(snrdB/10);				    % convert from dB
len_snr = length(snrdB);

for j1=1:len_snr						% increment SNR
   sigma1 = sqrt(1/(2*snr(j1)));	    % noise standard deviation
   error_count1 = 0;
   for k1=1:Nsymbols					% simulation loop begins
      d1 = round(rand(1));			    % data
      x_d1 = 2*d1 - 1;				    % transmitter output
      n_d1 = sigma1*randn(1);		    % noise
      y_d1 = x_d1 + n_d1;		        % receiver input
      if y_d1 > 0					    % test condition
         d_est1 = 1;				    % conditional data estimate
      else
         d_est1 = 0;				    % conditional data estimate
      end
      if (d_est1 ~= d1)
         error_count1 = error_count1 + 1;	% error counter
      end
   end									    % simulation loop ends
   errors1(j1) = error_count1;		        % store error count for plot
end
ber_sim1 = errors1/Nsymbols;			    % BER estimate
ber_theor1 = qfunc(sqrt(2*snr));		    % theoretical BER
semilogy(snrdB,ber_theor1,snrdB,ber_sim1,'o')
hold on
axis([snrdB_min snrdB_max 0.0001 1])
xlabel('SNR in dB')
ylabel('BER')

for j2=1:len_snr						% increment SNR
   sigma2 = sqrt(1/(2*snr(j2)));	    % noise standard deviation
   error_count2 = 0;
   for k2=1:Nsymbols					% simulation loop begins
      d2 = round(rand(1));			    % data
      x_d2 = d2;				        % transmitter output
      n_d2 = sigma2*randn(1);		    % noise
      y_d2 = x_d2 + n_d2;		        % receiver input
      if y_d2 > 0.5					    % test condition
         d_est2 = 1;				    % conditional data estimate
      else
         d_est2 = 0;				    % conditional data estimate
      end
      if (d_est2 ~= d2)
         error_count2 = error_count2 + 1;	% error counter
      end
   end									    % simulation loop ends
   errors2(j2) = error_count2;		        % store error count for plot
end
ber_sim2 = errors2/Nsymbols;			    % BER estimate
ber_theor2 = qfunc(sqrt(snr/2));		    % theoretical BER
semilogy(snrdB,ber_theor2,snrdB,ber_sim2,'x')
hold on

for j3=1:len_snr						    % increment SNR
   sigma3 = sqrt(1/(2*snr(j3)));	        % noise standard deviation
   error_count3 = 0;
   for k3=1:Nsymbols					    % simulation loop begins
      d3 = round(rand(1));			        % data
      if d3 ==0
         x_d3 = 1;						    % direct transmitter output	
         x_q3 = 0;						    % quadrature transmitter output	
      else
         x_d3 = 0;						    % direct transmitter output
         x_q3 = 1;						    % quadrature transmitter output
      end   
      n_d3 = sigma3*randn(1);		        % direct noise component
      n_q3 = sigma3*randn(1);		        % quadrature noise component
      y_d3 = x_d3 + n_d3;				    % direct receiver input
      y_q3 = x_q3 + n_q3;				    % quadrature receiver input
      if y_d3 > y_q3					    % test condition						
         d_est3 = 0;					    % conditional data estimate
      else
         d_est3 = 1;					    % conditional data estimate
      end
      if (d_est3 ~= d3)				
         error_count3 = error_count3 + 1;	% error counter
      end
   end									    % simulation loop ends
   errors3(j3) = error_count3;		        % store error count for plot
end
ber_sim3 = errors3/Nsymbols;			    % BER estimate
ber_theor3 = qfunc(sqrt(snr));			    % theoretical BER
semilogy(snrdB,ber_theor3,snrdB,ber_sim3,'*')
hold on

for j4=1:len_snr						% increment SNR
   sigma4 = sqrt(1/(2*snr(j4)));	    % noise standard deviation
   error_count4 = 0;
   for k4=1:Nsymbols					% simulation loop begins
      d4 = round(rand(1));			    % data
      if d4 == 0
          x_d4 = sqrt(3)/2;             % direct transmitter output
          x_q4 = 0;                     % quadrature transmitter output
      else
          x_d4 = 0;                     % direct transmitter output
          x_q4 = 1/2;                   % quadrature transmitter output
      end
      n_d4 = sigma4*randn(1);		    % direct noise
      n_q4 = sigma4*randn(1);		    % quadrature noise
      y_d4 = x_d4 + n_d4;				% direct receiver input
      y_q4 = x_q4 + n_q4;				% quadrature receiver input    
      if y_q4 < sqrt(3)*y_d4-0.5		% test condition
         d_est4 = 0;					% conditional data estimate
      else
         d_est4 = 1;					% conditional data estimate
      end
      if (d_est4 ~= d4)
         error_count4 = error_count4 + 1;	% error counter
      end
   end									    % simulation loop ends
   errors4(j4) = error_count4;		        % store error count for plot
end

ber_sim4 = errors4/Nsymbols;			    % BER estimate
ber_theor4 = qfunc(sqrt(snr/2));		    % theoretical BER
semilogy(snrdB,ber_theor4,snrdB,ber_sim4,'md')
legend('Theoretical 1','Simulation 1','Theoretical 2','Simulation 2','Theoretical 3','Simulation 3','Theoretical 4','Simulation 4')
