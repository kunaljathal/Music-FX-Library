

function deEsser(inputSignal, threshold, slope, gainMatching, lowerFreqLimit, upperFreqLimit)

% define Bark band edges and center frequencies
barkEdges = [0 100 200 300 400 510 630 770 920 1080 1270 ...
1480 1720 2000 2320 2700 3150 3700 4400 5300 6400 7700 9500 12000 15500];

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

% Next, we need to basically compute the lower and upper frequency bounds.
% We need to match these to the closest Bark frequency bounds.

minimumDistance = 1000000;
minimumIndex = -1;

%Loop through every input point and compute the distance between the input
%point and the quantizer step.
for i = 1:length(barkEdges)
    currentDistance = abs(lowerFreqLimit - barkEdges(i));
    if currentDistance < minimumDistance
        minimumDistance = currentDistance;
        minimumIndex = i;
    end
end

lowerBound = barkEdges(minimumIndex)

% Reset variables and recalculate for the upper bound.
% I know I could use nested for loops, but....

minimumDistance = 1000000;
minimumIndex = -1;

for j = 1:length(barkEdges)
    currentDistance = abs(upperFreqLimit - barkEdges(j));
    if currentDistance < minimumDistance
        minimumDistance = currentDistance;
        minimumIndex = j;
    end
end

upperBound = barkEdges(minimumIndex)

% We now have the upper and lower BARK frequency bounds. All we need to do
% is bandpass that part of the original signal, compress it, and then
% reconstruct the original signal using that compressed portion. To do
% this, we split the original signal into 3 parts - the compressed portion,
% and everything below and above it. We then reconstruct the signal by
% adding these 3 parts together.

% When designing filters, the lower bound cannot be 0 Hz, so we hard-code
% a tiny value to work around this 
if (lowerBound == 0)
    lowerBound = 0.01;

order = 3;
    
% Construct simple lowpass filter with lower limit as cutoff
[lowB, lowA] = butter(order, lowerBound/(fs/2), 'low');

% Construct simple highpass filter with upper limit as cutoff
[highB, highA] = butter(order, upperBound/(fs/2), 'high');

% Construct a bandpass filter with the lower and upper limits as cutoffs
Wn = [lowerBound/(fs/2), upperBound/(fs/2)];
[bandB, bandA] = butter(order, Wn);

% Let's filter the original signal now
lowPassSection = filter(lowB, lowA, originalSignal);
bandPassSection = filter(bandB, bandA, originalSignal);
highPassSection = filter(highB, highA, originalSignal);

% We need to only compress the bandpass section now, as it contains the
% range of frequencies the user wanted to compress. Let's compress!

% Construct the final bandpass compressed signal
finalBandPassCompressedSection = zeros(length(originalSignal), 1);

% Store the original polarity; use absolute values for processing. Also
% store the original signal for plotting later.
savedOriginalSignal = bandPassSection;
originalSign = sign(bandPassSection);
bandPassSection = abs(bandPassSection);

% Get the DC offset (Y intercept) that needs to be factored in during
% compression
intercept = threshold - (slope * threshold);

% Compression
for i = 1:length(bandPassSection)
    if bandPassSection(i) > threshold
        % Compress
        finalBandPassCompressedSection(i) = ((slope * bandPassSection(i)) + intercept) * originalSign(i);
    else
        % No need to compress
        finalBandPassCompressedSection(i) = bandPassSection(i) * originalSign(i);
    end
end

% Optional Gain Matching
if (gainMatching)
    ratio = max(bandPassSection)/max(finalBandPassCompressedSection);
    finalBandPassCompressedSection = ratio * finalBandPassCompressedSection;
end

% Now, we want to reconstruct the original signal by adding all the pieces
% together

finalSignal = lowPassSection + finalBandPassCompressedSection + highPassSection;

% Listen to the final signal!
sound(finalSignal, fs);

end