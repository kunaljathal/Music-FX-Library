% Kunal Jathal

% Simple implementation of the Schroeder Reverb

% Schroeder reverb
% ================

function schroederReverb(input)

% Read in audio file
[inputSignal, fs] = wavread(input);

% Play it
sound(inputSignal, fs);

% Let's first implement the 4 IIR Comb Filters. These are the delays in ms:
delaysMs = [29.7 37.1 41.1 43.7];

% Convert these delays to samples
delaysSamples = round((delaysMs ./ 1000) .* fs);

% Create the intermediateSignal...
finalSignal = zeros(size(inputSignal));

% Because we keep adding the original signal to itself, I scale the reverbs
% uniformly across the filters. I use a random scaling factor each time,
% scaled itself by a fixed constant.

scalingConstant = 0.25;

% Let's build each IIR Comb Filter and pass the original signal through it
for iirCounter=1:4
    % The IIR Comb Filter equation is:
    % y[n] = x[n]+ a1·y[n - L]
    %
    % I'm using random coefficient values for a1, and b is always 1. I
    % negate it due to the convention the filter function uses in MATLAB

    a1 = rand(1) * -1;
    aCoeff = [1 zeros(1, delaysSamples(iirCounter) - 1) a1];

    % Filter the original signal, add it to the final signal
    finalSignal = finalSignal + (rand(1) * scalingConstant * filter(1, aCoeff, inputSignal));
end

% Finally put these through the 2 all pass filters. All pass filters have 
% the following equation:
% y[n] = alpha.x[n] + x[n - N] - a.y[n - N]      
%
% where N = reflection length (filter order)
%
% We have only 2 all pass filters, so a for loop would be overkill :P

% All Pass 1
alpha1 = rand(1);
reflection1 = 5 * fs; % 5 second delay
finalSignal = finalSignal + (rand(1) * scalingConstant * filter([alpha1 zeros(1, reflection1-1) 1],[1 zeros(1, reflection1-1) alpha1], finalSignal));

% All Pass 2
alpha2 = rand(1);
reflection2 = round(1.7 * fs); % 1.7 second delay
finalSignal = finalSignal + (rand(1) * scalingConstant * filter([alpha2 zeros(1, reflection2-1) 1],[1 zeros(1, reflection2-1) alpha2], finalSignal));

% Let's hear the final signal
sound(finalSignal, fs);

end


% This combination works well because the comb filters can handle the short
% duration delays (on the order of ms) while the all pass filters are
% effective at handling the longer duration (5 second etc.) delays,
% particularly since they don't change the magnitude response and so are
% able to avoid the introduction of distortion that other very high order
% filters would inevitably produce.
