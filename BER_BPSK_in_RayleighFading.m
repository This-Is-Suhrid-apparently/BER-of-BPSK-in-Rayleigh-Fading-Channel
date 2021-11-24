
% Total Number of Bits
N = 100000;

%Simulation Range
Eb_No_dB = 0: 1: 40;


for l = 1: 1: length(Eb_No_dB)
    Total_Errors = 0;
    Total_bits = 0;
    
    %Calculating until I get 1000 errors
   while Total_Errors < 1000
    
        %% Random bits generation
        m  = round(rand(1,N));

        %% Polar Line Coding
        x = -2*(m-0.5);
    
        %% Noise Power Calculation
        N0 = 1/10^(Eb_No_dB(l)/10);
        sigma=sqrt(N0/2);
        
        %% Rayleigh channel fading
        h = 1/sqrt(2)*[randn(1,length(x)) + j*randn(1,length(x))]; 

        %% The net signal sent over the Rayleigh Channel
        r = h.*x + sigma*(randn(1,length(x))+i*randn(1,length(x)));
        
%---------------------------------------------------------------

        %% Equalisation
        r = r./h;
        
        %% BPSK demodulation
        rx2 = r < 0;
    
        %% Counting number of bits in error
        d = m - rx2;
        Total_Errors = Total_Errors + sum(abs(d));
        Total_bits = Total_bits + length(m);
        
   end
    %% Calculation of BER
    BER(l) = Total_Errors / Total_bits;
    disp(sprintf('For SNR: %f, the BER= %f',Eb_No_dB(l),BER(l)));

end
  
%------------------------------------------------------------

%% PLOTTING

%Theoretical BER: Rayleigh
Eb_No = 10.^(Eb_No_dB/10);
theoryBer = 0.5.*(1-sqrt(Eb_No./(Eb_No+1)));
figure(1);
semilogy(Eb_No_dB,theoryBer,'or');
hold on;

%Simulated BER
figure(1);
semilogy(Eb_No_dB,BER,'g-');
hold on;

xlabel('Eb/No (in dB)');
ylabel('BER');



%Theoretical BER: AWGN
figure(1);
theoryBerAWGN = 0.5*erfc(sqrt(Eb_No));
semilogy(Eb_No_dB,theoryBerAWGN,'b->');
legend('Rayleigh Theory','BER Simulated', 'AWGN Theory');
axis([0 60 10^-5 10]);
grid on;
