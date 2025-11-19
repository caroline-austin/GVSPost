% TTSprofiles.m 
% Build general profiles for Tilt Translation Sled tilt 

% Sled translation (S) = 5080 DAcounts/inch, + = forward, rightward (opposite door)
% Tilt rotation (R) = 200 DAcounts/deg, + = forward, rightward (opposite door) <- CONFIRM?
% dio1 = eye calibration LEDs and timer, 32 bit unsigned integer (binary coded decimal)
%        bits 0 = start/stop of profiles that is recorded on video inserter
%        bit 5 (32) = restart timer
% dio2 = onboard/monitor lighting, 1=on,0=off 
%-----------------------------------------------------------------------------------------
clc; clear all; close all; 


[fname,fpath]=uiputfile('Esther_MC_Distmax8deg.txt','Select directory to save profiles to:');
cd(fpath)


% default scale factors 
Ssf = 5080/.0254;   % DAC counts/m
Rsf = 200;       	% DAC counts/deg
sr=50;          	% sample rate 50 Hz

zpad_end = 10;      % seconds of no motion at the end of the disturbance
zpad_ramp = 1;      % seconds ramping up to the offest
offset = 0.3;       % the offset angle so we can Soft Stop

% maximum parameters: 
% tilt = +/-20 degrees (could maybe squeeze out 21 without changing where the stops are)
% translation = +/- 10 ft 9 inches, or only +/-7ft 6 inches if avoiding the
% splice (for a little margin, will use +/- 7ft 3 inches
tilt_max = 20;    % deg
trans_max = (7*12 + 3) * 0.0254;    % meters


%% Create Tilt Rotation Profile
%Insert Amplitudes 
%Amplitude were adjusted to produce motions under 8 degrees
a = [1.2475     %1
    1.2475      %2
    1.2475      %3
    1.2475      %4
    1.2475      %5
    1.2475      %6
    1.2475      %7  
    1.2475      %8  
    0.1247      %9
    0.1247      %10
    0.1247      %11 
    0.1247];    %12
% a = a*1.5;   % for safety testing or for 12 deg
% a = a*1.875;   % for 15 deg - also use for training profiles (~+/-6 deg)
% a = a*2.5;   % for 20 deg

%Insert Frequencies
f = [0.014      %1
    0.024       %2
    0.053       %3
    0.083       %4
    0.112       %5
    0.151       %6
    0.200       %7
    0.258       %8      
    0.346       %9
    0.434       %10
    0.532       %11 
    0.668];     %12

% Insert Phases (deg)
% p = [0;0;0;0;0;0;0;0;0;0;0;0]; % for training profiles
p = [31+90          %1
    42+90          %2
    74+90          %3
    98+90          %4
    120+90         %5
    235+90         %6
    294+90         %7
    99+90          %8, tweak this from 259 to get it to be symmetric and zero-mean
    331+90         %9
    352+90         %10
    11+90          %11
    61+90];        %12

dt = 1/sr;
StopTime = 120;              % Total Duration of Trial - 120 for full trials - 30 for training trials
% StopTime = 120 *1.2;            % for safety testing
t = (0:dt:StopTime-dt)';     % seconds

% Sum of Sines
y = zeros(length(t),1);
for j = 1:length(p)
    y = y + sin(2*pi*f(j)*t + p(j)*pi/180)*a(j);
end

% y= y- mean(y); %use when making training trials to ensure a zero mean 

%Ramp up/down
ramp = 5;           % 5 seconds to ramp up and down
scale = ones(length(y),1);
for i = 1:length(y)
    if t(i) <=ramp
        scale(i) = t(i)/ramp;
    elseif t(end)-t(i) <=ramp
        scale(i) = (t(end)-t(i))/ramp;
    end
end

%Check for zero-mean over the central portion (beteween ramp up and down)
m = mean(y(sr*ramp:end-sr*ramp));

min(y(sr*ramp:end-sr*ramp))
max(y(sr*ramp:end-sr*ramp))

Rcom_nozeros = y.*scale;

zpad_end = 10;      % seconds of no motion at the end of the disturbance
zpad_ramp = 1;      % seconds ramping up to the offest
offset = 0.3;       % the offset angle so we can Soft Stop

ramp_offset = [0:offset/zpad_ramp/sr:offset/zpad_ramp, offset*ones(1,(zpad_end-zpad_ramp)*sr)]'; 
Rcom = [y.*scale; ramp_offset];
% offset*ones(zpad_end*sr,1)

% Create a Translation Profile
Scom = zeros(length(Rcom), 1);




figure;
time = [0:length(Rcom)-1]' / sr;
subplot(2,1,1); plot(time, Rcom, [0, max(time)], tilt_max*[1 1], [0, max(time)], -tilt_max*[1 1]); ylabel('tilt (deg)')
subplot(2,1,2); plot(time, Scom, [0, max(time)], trans_max*[1 1], [0, max(time)], -trans_max*[1 1]); xlabel('time (sec)'); ylabel('translation (m)');

figure;
plot(time, Rcom, [0 120], [0 0], 'k', 'LineWidth', 2); ylabel('Disturbance Tilt (deg)')
xlim([0 120]); ylim([-10 10]);
xlabel('Time (sec)');

DO=zeros(length(Rcom),2);
% Torin: I am not sure we are using this digital output, so I am leaving it
% as all zeros. However, we may need the first 25 time steps to be 32's
% DO(1:25,1)=32*ones(25,1); % start timer

pause
if max(abs(Rcom)) > tilt_max
    error('Tilt profile exceeds the device limits');
end
if max(abs(Scom)) > trans_max
    error('Translation profile exceeds the device limits');
end

% save binary output files
% 1: Digital output #1, all zeros, I don't think we use
% 2: Digital output #2, all zeros, turns lights on and off (?), 0s turns off
% 3: Tilt angle in counts where 200 counts = 1 deg
% 4: Translation position in counts where 5080 counts = 1 inch
% Have to round to the nearest integer of counts
Profile=round([DO(:,1), DO(:,2), Rcom*Rsf, Scom*Ssf]);
tilt_counts_nozeros = Rcom_nozeros*Rsf;
tilt_counts = round([tilt_counts_nozeros; ramp_offset*Rsf]); 

figure;  
subplot(3,1,1); plot(time, Profile(:,1), time, Profile(:,2), '--'); ylim([-5 35]); ylabel('digitial outputs'); legend('DO1', 'DO2')
subplot(3,1,2); plot(time, Profile(:,3)); ylabel('tilt (counts)');
subplot(3,1,3); plot(time, Profile(:,4)); ylabel('translation (counts'); xlabel('time (sec)')

% Write the profile going forward
fid=fopen([fname(1:end-4),'1.txt'],'wt');
for j=1:length(Profile)
    fprintf(fid,'%i\t %i\t %i\t %i\n',Profile(j,1),Profile(j,2),Profile(j,3),Profile(j,4));
end
fclose(fid);

% Write the profile going foward with sign flipped
tilt_counts_flipped = round([flipud(tilt_counts_nozeros); ramp_offset*Rsf]);

figure; 
subplot(4,1,1); plot(time, tilt_counts);  title('Profile 1')
subplot(4,1,2); plot(time, -tilt_counts); ylabel('tilt (counts)'); title('Profile 2');
subplot(4,1,3); plot(time, tilt_counts_flipped); title('Profile 3');
subplot(4,1,4); plot(time, -tilt_counts_flipped); title('Profile 4'); xlabel('time (sec)');

fid=fopen([fname(1:end-4),'2.txt'],'wt');
for j=1:length(Profile)
    fprintf(fid,'%i\t %i\t %i\t %i\n',Profile(j,1),Profile(j,2),-tilt_counts(j),Profile(j,4));
end
fclose(fid);

% Write the profile going in reverse 
fid=fopen([fname(1:end-4),'3.txt'],'wt');
for j=1:length(Profile)
    fprintf(fid,'%i\t %i\t %i\t %i\n',Profile(j,1),Profile(j,2),tilt_counts_flipped(j),Profile(j,4));
end
fclose(fid); 

% Write the profile going in reverse with sign flipped
fid=fopen([fname(1:end-4),'4.txt'],'wt');
for j=1:length(Profile)
    fprintf(fid,'%i\t %i\t %i\t %i\n',Profile(j,1),Profile(j,2),-tilt_counts_flipped(j),Profile(j,4));
end
fclose(fid); 

%%
% Write a profile with no disturbance for just manual control inputs
fid=fopen([fname(1:end-4),'nodisturbance.txt'],'wt');
for j=1:length(Profile)
    fprintf(fid,'%i\t %i\t %i\t %i\n',Profile(j,1),Profile(j,2),0,Profile(j,4));
end
fclose(fid); 


