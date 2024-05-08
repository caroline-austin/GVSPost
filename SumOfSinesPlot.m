%color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];


%%%%%%%%%%%%%%
% default scale factors
Ssf = 5080/.0254;   % DAC counts/m, based upon there being 5080 counts per inch, and converting to meters. S is for Sled translation
Rsf = 200;       	% DAC counts/deg, based upon tehre being 200 counts per deg of tilt. R is for Rotation of tilt
sr=50;          	% sample rate 50 Hz

% maximum parameters:
% Provide some time with zero motion at the beginnign and end, if desired
zpad=1;                         % sec at beginning runs padded with zeros
zpad_after = 1;                 % sec at the end of runs padded with zeros
cycles = 1;                     % number of cycles for the sine to run
freq = [0.07,0.18, 0.31  ];       % Hz 1:*[0.07,0.18, 0.31], *[0.07,0.25, 0.33 ], [0.07,0.17, 0.27, .47 ],[0.07,0.19, 0.26, .48 ], *[0.07,0.19, 0.36  ];
ampl = [1 1 1 ];                % +/- deg 
amp_scale = 8;
phase_shift = [ 0, 0, 0];

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
test_sin = Rcom;

%% TTS Tilt Profile
tramp = 1/freq(1)/2; % ensures its goes to full sine at a peak, so its smooth
tend = 2*tramp + cycles / freq(1);     % time required to do ramp up, # cycles, ramp down

% Sum of Sines
sinusoid = ampl' .* cos([1/sr:1/sr:tend].*freq'.*2*pi+phase_shift');
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
test_cos = Rcom;

%%%%%%%%%%%%%%
% fs = 50;
% dt = 1/fs;
duration = 30.5;
% t = [0:dt:duration];
t = [1:length(Rcom)]/sr;
% num_waves = 4;
% %           0.5 Hz     0.33 Hz     0.15Hz        0.4545Hz
% test_sin = (sin(t*pi)+sin(t*2/3*pi)+sin(t*2*pi/(6+2/3))+ sin(t*2*pi/(2.2)))/num_waves;
% % plot(t, test_sin);
% test_cos = (cos(t*pi)+cos(t*2/3*pi)+cos(t*2*pi/(6+2/3))+ cos(t*2*pi/(2.2)))/num_waves;
% 
% %0.07,0.18, 0.31
% freq = [0.07,0.18, 0.31];
% phase_shift = [ 0, 0, 0];
% sinusoid = sin([0:1/fs:duration].*freq'.*2*pi+phase_shift');
% test_sin = sum(sinusoid);
% test_cos = sum(cos([0:1/fs:duration].*freq'.*2*pi+phase_shift'));

figure;
subplot(4,1,1, 'FontSize', 15);
title('TTS Tilt Profile', 'FontSize', 36); hold on;
plot( t,-8*test_sin/max(abs(test_sin)), 'color', 'k', 'LineWidth',5);
% xlabel('Time (seconds)', 'FontSize',30);
ylabel('Tilt (deg)', 'FontSize',30);
ylim( [-8 8]);
yticks([-8 0 8])
xlim( [0 30]);

subplot(4,1,2, 'FontSize', 15);
title('Angle Coupled Current', 'FontSize', 36); hold on;
plot( t, 4*test_sin/max(abs(test_sin)), 'color', blue, 'LineWidth',5);
% xlabel('Time (seconds)', 'FontSize',30);
% ylabel('Current (mA)', 'FontSize',30);
ylim( [-4 4]);
yticks([-4 0 4])
xlim( [0 30]);

subplot(4,1,3, 'FontSize', 15);
title('Velocity Coupled Current', 'FontSize', 36); hold on;
plot( t, 4*test_cos/max(abs(test_cos)), 'color', red, 'LineWidth',5);
% xlabel('Time (seconds)', 'FontSize',30);
ylabel('Current (mA)', 'FontSize',30);
ylim( [-4 4]);
yticks([-4 0 4])
xlim( [0 30]);

subplot(4,1,4, 'FontSize', 15);
title('Joint Coupled Current', 'FontSize', 36); hold on; 
plot( t, 4*(test_sin+test_cos)/max(abs(test_sin+test_cos)), 'color', purple, 'LineWidth',5);
xlabel('Time (seconds)', 'FontSize',30);
% ylabel('Current (mA)', 'FontSize',30);
ylim( [-4 4]);
yticks([-4 0 4])
xlim( [0 30]);

hold off;
