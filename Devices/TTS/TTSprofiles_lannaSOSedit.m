% TTSprofiles_lannaloop.m
% Build profiles for SOE1B Tilt Translation Sled
% Simple sin wave tilt

% UPDATED on 9/30/2022

% Sled translation (S) = 5080 DAcounts/inch, + = forward, rightward (opposite door)
% Tilt rotation (R) = 200 DAcounts/deg, + = forward, rightward (opposite door) <- CONFIRM?
% dio1 = eye calibration LEDs and timer, 32 bit unsigned integer (binary coded decimal)
%        bits 0 = start/stop of profiles that is recorded on video inserter
%        bit 5 (32) = restart timer
% dio2 = onboard/monitor lighting, 1=on,0=off
%-----------------------------------------------------------------------------------------
clc; clear all; close all;
code_path= pwd;

% default scale factors
Ssf = 5080/.0254;   % DAC counts/m, based upon there being 5080 counts per inch, and converting to meters. S is for Sled translation
Rsf = 200;       	% DAC counts/deg, based upon tehre being 200 counts per deg of tilt. R is for Rotation of tilt
sr=50;          	% sample rate 50 Hz

% maximum parameters:
% tilt = +/-20 degrees (could maybe squeeze out 21 without changing where the stops are)
% translation = +/- 10 ft 9 inches, or only +/-7ft 6 inches if avoiding the splice
% (for a little margin, will use +/- 7ft 3 inches)
tilt_max = 20;                      % deg
% trans_max = (7*12 + 3) * 0.0254;  % meters, avoiding splice
trans_max = (10*12 + 9) * 0.0254;   % meters, crossing splice
g = 9.81;                           % m/s^2
gain = -0.3; k = (gain/9.81)*(180/pi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide some time with zero motion at the beginnign and end, if desired
zpad=1;                         % sec at beginning runs padded with zeros
zpad_after = 1;                 % sec at the end of runs padded with zeros
cycles = 1;                     % number of cycles for the sine to run
freq = [0.07,0.18, 0.31  ];       % Hz 1:*[0.07,0.18, 0.31], *[0.07,0.25, 0.33 ], [0.07,0.17, 0.27, .47 ],[0.07,0.19, 0.26, .48 ], *[0.07,0.19, 0.36  ];
ampl = [1 1 1 ];                % +/- deg 
amp_scale = 8;
phase_shift = [ 0, 0, 0];

s1 = 'Test.txt'; %s2 = num2str(freq(f)); s3= '_a'; s4 = num2str(ampl(a));
%s5 = '_vtilt_ttilt_on.txt';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = strcat(s1); %,s2,s3,s4,s5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%select where to save the TTS profile
[fname,fpath]=uiputfile(filename,'Select directory to save profiles to:');
cd(fpath)

%% TTS Tilt Profile
tramp = 1/freq(1)/2; % ensures its goes to full sine at a peak, so its smooth
tend = 2*tramp + cycles / freq(1);     % time required to do ramp up, # cycles, ramp down

% Sum of Sines
sinusoid = ampl' .* sin([1/sr:1/sr:tend].*freq'.*2*pi+phase_shift');
sinusoid = sinusoid';
L = length(sinusoid);

ramp_sine = zeros(L,length(ampl));
ramp = zeros(L,1);
for i = 1:L
    if i <= tramp*sr
        ramp(i) = 1/tramp * (i/sr - tramp/(2*pi) * sin(2*pi*i/sr/tramp)); % This is sigmoidal ramp, which is better since it avoids jumps
        ramp_sine(i,:) = ramp(i) * sinusoid(i,:);  % scale the profile by the ramp up
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

% add in the zero padding at the beginning and end of the profile
Rcom = [zeros(zpad*sr,1); ttsSin; zeros(zpad_after*sr,1)];
max_amp = max(abs(Rcom));
Rcom = Rcom*amp_scale/max_amp;

%% TTS Translation
Scom = zeros(length(Rcom), 1); %%No translation in these, edit to include translation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time = [0:length(Rcom)-1]' / sr;


%% Create linear acceleration, linear velocity, and angular velocity info
linvel = [0; diff(Scom)*sr];  % m/s, linear velocity through numerical differentiation
linaccel = [0; diff(linvel)*sr]; % m/s^2 linear acceleration through numerical differentiation

angvel = [0; diff(Rcom)*sr];   % deg/s, angular velocity through numerical differentiation

%% Digital Outputs (DOs) - can control lights, etc. depending upon the VI.
DO=zeros(length(Scom),2);
DO(1,1) = 2; DO(2,1) = 2; DO(3,1) = 2; DO(4,1) = 2; %make the first few rows of column 1 turn off lights for VR


%% Plot profile
figure;
subplot(3,1,1); plot(time, DO(:,1), time, DO(:,2), '--'); ylabel('digitals'); legend('DOI 1', 'DOI 2')
subplot(3,1,2); plot(time, Rcom, [0, max(time)], tilt_max*[1 1], [0, max(time)], -tilt_max*[1 1]); ylabel('tilt (deg)')
subplot(3,1,3); plot(time, Scom, [0, max(time)], trans_max*[1 1], [0, max(time)], -trans_max*[1 1]); xlabel('time (sec)'); ylabel('translation (m)');


if max(abs(Rcom)) > tilt_max
    error('Tilt profile exceeds the device limits');
end
if max(abs(Scom)) > trans_max
    error('Translation profile exceeds the device limits');
end

disp('Verify commanded motions are correct in plot. Press any key to proceed.')
pause;

figure;
angvel_max = 55;   % deg/s -- this is somethwat arbitrary, should put more thought into it! But Jordan did this in his Exp 1 SD profiles
subplot(2,1,1); plot(time, Rcom, [0, max(time)], tilt_max*[1 1], [0, max(time)], -tilt_max*[1 1]); ylabel('tilt (deg)')
subplot(2,1,2); plot(time, angvel, [0, max(time)], angvel_max*[1 1], [0, max(time)], -angvel_max*[1 1]); ylabel('tilt velocity (deg/sec)');
disp('Verify angular velocity inputs are correct in plot. Press any key to proceed.')
pause;
% cd(fpath)
% saveas(gcf, [ s1]); 
% cd(code_path)

figure;
linvel_max = 1;  % m/s -- this is somethwat arbitrary, should put more thought into it! But we do seem to get "shuddering" over 1 m/s
linaccel_max = 0.25*9.81; % m/s^2, corresponds to 0.25 g's
subplot(3,1,1); plot(time, Scom, [0, max(time)], trans_max*[1 1], [0, max(time)], -trans_max*[1 1]); xlabel('time (sec)'); ylabel('translation (m)');
subplot(3,1,2); plot(time, linvel, [0, max(time)], linvel_max*[1 1], [0, max(time)], -linvel_max*[1 1]); ylabel('trans velocity (m/s)');
subplot(3,1,3); plot(time, linaccel, [0, max(time)], linaccel_max*[1 1], [0, max(time)], -linaccel_max*[1 1]); ylabel('trans acceleration (m/s^2)');

disp('Verify linear velocity and acceleration inputs are correct in plot. Press any key to proceed. WILL SAVE FILE!')
pause;

% save binary output files
% 1: Digital output #1, used to turn VR or tablet on/off
% 2: Digital output #2, all zeros, turns physical lights on and off, 0s turns off
% 3: Tilt angle in counts where 200 counts = 1 deg
% 4: Translation position in counts where 5080 counts = 1 inch
% Have to round to the nearest integer of counts
Profile=round([DO(:,1), DO(:,2), Rcom*Rsf, Scom*Ssf]);

%% If you are making a profile with 8 columns, like for controlling the VR translation directly
Profile567 = [Profile, linaccel*Ssf, linvel*Ssf, angvel*Rsf]; % trans_counts/s^2, trans_counts/s, tilt_counts/s
Profile8 = Rcom; % translation position in meters to drive the VR scene
fid=fopen([fname],'wt');
for j=1:length(Profile)
    fprintf(fid,'%i\t %i\t %i\t %i\t %.8f\t %.8f\t %.8f\t %.8f\n',Profile567(j,1),Profile567(j,2),Profile567(j,3),Profile567(j,4),Profile567(j,5),Profile567(j,6),Profile567(j,7), Profile8(j,1));
end
fclose(fid);
cd(code_path);
