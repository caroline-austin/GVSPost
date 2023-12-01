function [Noise]=Noise(fs,T,PmA,Polarity_Type)
%% Additional inputs:

Noise_Type=input('7) Enter bipolar noise type (1 = white or 2 = pink): ');
Filter_Type=input('8) Enter filter type (0 = none, 1 = low-pass, 2 = high-pass, 3 = band-pass): ');
if Filter_Type==0
    FilterCut=NaN;
elseif Filter_Type<3 && Filter_Type>0
    FilterCut=input('9) Enter filter cutoff frequency (in Hz): ');
elseif Filter_Type==3
    FilterCut1=input('9) Enter lower bound filter cutoff frequency (in Hz): ');
    FilterCut2=input('10) Enter upper bound filter cutoff frequency (in Hz): ');
elseif Filter_Type<0 && Filter_Type>3
    error('Error: Filter type must be 0 (none), 1 (low-pass), 2 (high-pass), or 3 (band-pass).');
elseif Polarity_Type==1
    error('Error: Polarity type must be 2 (bipolar) for generating noise files.') %% For now, polarity type must be bipolar for noise.
end

%% Create noise signal:
if Noise_Type==1
    N=wgn(T,1,0)';
elseif Noise_Type==2
    N=pinknoise(T)';
end

%% Define noise signal (either unipolar or bipolar).
if Polarity_Type==1
    FullPNoise=abs(N);
elseif Polarity_Type==2
    FullPNoise=N;
end

%% Filter noise:
if Filter_Type==0
    FiltNoise=FullPNoise;
elseif Filter_Type==1
    [B,A]=butter(2,2*FilterCut/fs,'low');
    FiltNoise=filtfilt(B,A,FullPNoise);
elseif Filter_Type==2
    [B,A]=butter(2,2*FilterCut/fs,'high');
    FiltNoise=filtfilt(B,A,FullPNoise);
elseif Filter_Type==3
    [B,A]=butter(2,2*[FilterCut1 FilterCut2]/fs,'bandpass');
    FiltNoise=filtfilt(B,A,FullPNoise);
end

%% Reduce noise to the peak mA desired.
MaxN=max(FiltNoise);
MinN=min(FiltNoise);
if Polarity_Type==1
    Noise=(FiltNoise/MaxN)*PmA;
elseif Polarity_Type==2
    if MaxN>abs(MinN)
        Noise=(FiltNoise/MaxN)*PmA;
    elseif abs(MinN)>MaxN
        Noise=(FiltNoise/abs(MinN))*PmA;
    end
end