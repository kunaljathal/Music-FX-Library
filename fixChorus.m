% Kunal Jathal

% Fixed Delay Chorus
% ===================

% We want to implement a simple chorus filter i.e. just the following 
% difference equation:

% y[n] = x[n] + b0 * x[n - K]

% We want to take in the following arguments:
% Delay Coefficient (b0)
% Input Signal (x[n])
% Delay Amount (K) (in MILLISECONDS) - this is fixed for this function 

function fixChorus(input, delayCoefficient, delayAmount)

% Read input signal
[inputSignal, fs] = wavread(input);

% Play original sound
sound(inputSignal, fs);

% Convert delay from milliseconds to samples
delayAmount = round((delayAmount/1000) * fs);

% Create padding of zeroes for coefficients that don't exist
padding = zeros(1, delayAmount - 1);

% X coefficients for numerator
b = [1, padding, delayCoefficient];

% Y coefficients for denominator
a = 1;

% Plot the frequency response of the chorus filter
freqz(b, a);

% Apply the chorus filter to the input signal.
finalSound = filter(b, a, inputSignal);

% Let's hear it!
sound(finalSound, fs);

end
