function [Sinusoidal]=Sinusoidal(t,fs,PmA,Polarity_Type,Sin_freq)

%% Additional inputs:
Sin_freq=input('7) Note: sinusoidal signal frequency should be 1/10 of the sampling frequency or less. Enter sinusoidal signal frequency (Hz): ');


%% Generate Sinusoidal Signal.
if Polarity_Type==1
    Sinusoidal=abs(((cos(2*pi*Sin_freq*t)+1)/2)-1)*PmA;
elseif Polarity_Type==2
    Sinusoidal=sin(2*pi*Sin_freq*t)*PmA;
else
    error('Error: Polarity type must be 1 (unipolar) or 2 (bipolar).');
end

end