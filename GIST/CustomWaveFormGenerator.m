% need to save as a csv 
% no more that 20k lines
% either 1000 or 10000 samples per second 
% integer values in micro amps

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide some time with zero motion at the beginnign and end, if desired
sr=100;          	            % sample rate 1000 Hz
zpad=0;                         % sec at beginning runs padded with zeros
zpad_after = 0;                 % sec at the end of runs padded with zeros
cycles = 19;                     % number of cycles for the sine to run
freq = [0.16 0.33 0.43 0.61 ];       % Hz 1:*[0.07,0.18, 0.31], *[0.07,0.25, 0.33 ], [0.07,0.17, 0.27, .47 ],[0.07,0.19, 0.26, .48 ], *[0.07,0.19, 0.36  ];
ampl = [0.7 1 0.48 0.18 ];                % +/- deg 
amp_scale = 1500;
phase_shift = [ 0, 0, 0, 0];

s1 = 'MacDougall_1_5mA_max4mA_100HzSample.csv'; %s2 = num2str(freq(f)); s3= '_a'; s4 = num2str(ampl(a));
%s5 = '_vtilt_ttilt_on.txt';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = strcat(s1); %,s2,s3,s4,s5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%select where to save the GVS profile
[fname,fpath]=uiputfile(filename,'Select directory to save profiles to:');
cd(fpath)

%% TTS Tilt Profile
tramp = 1/freq(4)/2; % ensures its goes to full sine at a peak, so its smooth
tend = 2*tramp + cycles / freq(1);     % time required to do ramp up, # cycles, ramp down

% Sum of Sines
sinusoid = ampl' .* sin([1/sr:1/sr:tend].*freq'.*2*pi+phase_shift');
sinusoid = sinusoid';
L = length(sinusoid);


ramp_sine = zeros(L,length(ampl));
ramp = zeros(L,1);
for i = 1:L
    if i <= tramp*sr
        % ramp(i) = 1/tramp * (i/sr - tramp/(2*pi) * sin(2*pi*i/sr/tramp)); % This is sigmoidal ramp, which is better since it avoids jumps
        % ramp_sine(i,:) = ramp(i) * sinusoid(i,:);  % scale the profile by the ramp up
        ramp_sine(i,:) = sinusoid(i,:); % in the middle, do no scaling of the profile
        ramp(i) = 1;
    elseif i > L - tramp*sr
        irampdown = (i-(L-tramp*sr));
        ramp(i) = 1 - 1/tramp * (irampdown/sr - tramp/(2*pi) * sin(2*pi*irampdown/sr/tramp)); % sigmoidal ramp down
        ramp_sine(i,:) = ramp(i) * sinusoid(i,:); % scale the profile by the ramp down
    else
        ramp_sine(i,:) = sinusoid(i,:); % in the middle, do no scaling of the profile
        ramp(i) = 1;
    end
end

ttsSin = sum(ramp_sine,2);
% ttsSin = sum(sinusoid,2);

% add in the zero padding at the beginning and end of the profile
Rcom = [zeros(zpad*sr,1); ttsSin; zeros(zpad_after*sr,1)];
max_amp = max(abs(Rcom));
Rcom = Rcom*amp_scale/max_amp;
% Rcom = floor([0 Rcom' 0 4000 0 -4000 0])'; %
Rcom = floor([0 Rcom(1:10000)' 0 4000 0 -4000 0])'; %
% Rcom = floor([0 Rcom(1:18368 )' 0 5000 0 -5000 0])'; %

plot([Rcom' Rcom']);

writematrix(Rcom,filename)