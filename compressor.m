% Kunal Jathal
% N19194426
% DST 2 - Assignment 2
% 
% Question 2 (a)
%

function compressor(inputSignal, threshold, slope, gainMatching)

% Error check the threshold and slope
if ((abs(threshold) > 1) || (abs(slope) > 1))
    error('Both the threshold and slope need to be under 1');
end

% Get the original signal
[originalSignal, fs] = wavread(inputSignal);

% I mono-fy the signal to simplify some of the matrix arithmetic later on 
% and to make life a bit easier when gain matching and plotting
originalSignal = mean(originalSignal, 2);

% Listen to the original sound
sound(originalSignal, fs);

% Construct the final signal
finalSignal = zeros(length(originalSignal), 1);

% Store the original polarity; use absolute values for processing. Also
% store the original signal for plotting later.
savedOriginalSignal = originalSignal;
originalSign = sign(originalSignal);
originalSignal = abs(originalSignal);

% Get the DC offset (Y intercept) that needs to be factored in during
% compression
intercept = threshold - (slope * threshold);

% Time for some compression
for i = 1:length(originalSignal)
    if originalSignal(i) > threshold
        % Compress
        finalSignal(i) = ((slope * originalSignal(i)) + intercept) * originalSign(i);
    else
        % No need to compress
        finalSignal(i) = originalSignal(i) * originalSign(i);
    end
end

% Optional Gain Matching
if (gainMatching)
    ratio = max(originalSignal)/max(finalSignal);
    finalSignal = ratio * finalSignal;
end

% Difference Signal
differenceSignal = savedOriginalSignal - finalSignal;

% Get plots ready:

% Original Signal Spectrum
lengthOriginalSignal = length(originalSignal);
NFFT1 = 2^nextpow2(lengthOriginalSignal);
originalSignalFFT = fft(originalSignal, NFFT1)/lengthOriginalSignal;
freqAxis1 = fs/2*linspace(0,1,NFFT1/2 + 1);
originalSignalPlot = abs(originalSignalFFT(1:NFFT1/2+1));
originalSignalPlot = originalSignalPlot/max(originalSignalPlot);

% Compressed Signal Spectrum
lengthFinalSignal = length(finalSignal);
NFFT2 = 2^nextpow2(lengthFinalSignal);
finalSignalFFT = fft(finalSignal, NFFT2)/lengthFinalSignal;
freqAxis2 = fs/2*linspace(0,1,NFFT2/2+1);
finalSignalPlot = abs(finalSignalFFT(1:NFFT2/2+1));
finalSignalPlot = finalSignalPlot/max(finalSignalPlot);

% Plotting time
figure
subplot(3,2,1)
plot(savedOriginalSignal)
grid on
title('Original Signal')
ylabel('Amplitude')
xlabel('Time')

subplot(3,2,2)
grid on
plot(finalSignal)
grid on
title('Compressed Signal')
ylabel('Amplitude')
xlabel('Time')

subplot(3,2,3)
plot(differenceSignal)
grid on
title('Difference Signal')
ylabel('Amplitude')
xlabel('Time')

subplot(3,2,4)
plot(freqAxis1, originalSignalPlot)
grid on
title('Original Signal Spectrum')
ylabel('Magnitude')
xlabel('Frequency')

subplot(3,2,5)
plot(freqAxis2, finalSignalPlot)
grid on
title('Compressed Signal Spectrum')
ylabel('Magnitude')
xlabel('Frequency')

% Listen to the compressed sound
sound(finalSignal, fs);

end
