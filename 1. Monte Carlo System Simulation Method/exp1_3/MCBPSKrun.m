function [BER,Errors]=MCBPSKrun(N,EbNo,delay,FilterSwitch)
SamplesPerSymbol = 10; 
BlockSize = 1000; 
NoiseSigma = sqrt(SamplesPerSymbol/(2*EbNo)); 
DetectedSymbols = zeros(1,BlockSize); 
NumberOfBlocks = floor(N/BlockSize); 
[BTx,ATx] = butter(5,2/SamplesPerSymbol); 
[TxOutput,TxFilterState] = filter(BTx,ATx,0); 
BRx = ones(1,SamplesPerSymbol); ARx=1; 
Errors = 0; 
for Block=1:NumberOfBlocks 
    [SymbolSamples,TxSymbols] =random_binary(BlockSize,SamplesPerSymbol);
    if FilterSwitch==0
        TxOutput = SymbolSamples;
    else 
        [TxOutput,TxFilterState] =filter(BTx,ATx,SymbolSamples,TxFilterState);
    end
    NoiseSamples = NoiseSigma*randn(size(TxOutput));
    RxInput = TxOutput + NoiseSamples; 
    IntegratorOutput = filter(BRx,ARx,RxInput);
    for k=1:BlockSize,
        m = k*SamplesPerSymbol+delay;
        if (m < length(IntegratorOutput))
            DetectedSymbols(k) = (1-sign(IntegratorOutput(m)))/2;
          if (DetectedSymbols(k) ~= TxSymbols(k))
            Errors = Errors + 1;
          end
        end
    end 
end 
BER = Errors/(BlockSize*NumberOfBlocks); 
% End of function file.