function [Sinusoidal]=Sinusoidal_Ramp(t,fs,PmA,Polarity_Type,Sin_freq)

%% Additional inputs:
% Sin_freq=input('7) Note: sinusoidal signal frequency should be 1/10 of the sampling frequency or less. Enter sinusoidal signal frequency (Hz): ');

% ramped sinusoid of +/- amplitude deg at some frequency for 5 cycles,
% ramping up and ramping down
% freq = 0.5;     % Hz
% PmA = 5;       % +/- deg
% tramp = 10;     % seconds for the ramp up, and ramp down, if you want to specify this
tramp = 1/Sin_freq/2; % ensures its goes to full sine at a peak, so its smooth
cycles = ceil(max(t)*Sin_freq);    % number of cycles
tend = 2*tramp + cycles / Sin_freq;     % time required to do ramp up, X cylces, ramp down

%% Generate Sinusoidal Signal.
if Polarity_Type==1
    sinusoidal=abs(((cos(2*pi*Sin_freq*[1/fs:1/fs:tend])+1)/2)-1)*PmA;
elseif Polarity_Type==2
    sinusoidal = PmA * sin(2*pi*Sin_freq * [1/fs:1/fs:tend])';
else
    error('Error: Polarity type must be 1 (unipolar) or 2 (bipolar).');
end

L = length(sinusoidal);
ramp_sine = zeros(L,1);
ramp = zeros(L,1);
for i = 1:L
    if i <= tramp*fs
%         ramp(i) = i/(tramp*fs);  % this is simple linear ramp up. This is not ideal because it can still cause jumps at the beginning and end
        ramp(i) = 1/tramp * (i/fs - tramp/(2*pi) * sin(2*pi*i/fs/tramp)); % This is sigmoidal ramp, which is better since it avoids jumps
        ramp_sine(i) = ramp(i) * sinusoidal(i);  % scale the profile by the ramp up
    elseif i > L - tramp*fs
%         ramp(i) = (L - i)/(tramp*fs); % simple linear ramp down
        irampdown = (i-(L-tramp*fs));
        ramp(i) = 1 - 1/tramp * (irampdown/fs - tramp/(2*pi) * sin(2*pi*irampdown/fs/tramp)); % sigmoidal ramp down
        ramp_sine(i) = ramp(i) * sinusoidal(i); % scale the profile by the ramp down
    else 
        ramp_sine(i) = sinusoidal(i); % in the middle, do no scaling of the profile
        ramp(i) = 1;
    end

   
end

Sinusoidal = ramp_sine';

end