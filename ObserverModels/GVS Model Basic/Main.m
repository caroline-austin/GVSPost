% Example Run
clc;clear;
addpath("./Observer/");
addpath("./assets/")
%

GVS_Params = [0.0245, 0];

% if the TTS is in pitch config set to 1 else = 0; for GIST with roll and
% pitch use 2
TTS_pitch = 2;

code_path = pwd;
% [input_filearg,input_path] = uigetfile('*.txt');
[input_filearg,input_path] = uigetfile('*.csv');
fprintf([input_filearg '\n']);

cd(input_path) %make sure the profile you want to run is in this folder


if contains(input_filearg, 'csv') %% TTS or GIST output file as input
    if contains(input_filearg, 'GIST_') % GIST file
        fs = 50; %375Hz ~sampling freq of GIST 2v9, but resampling down to 50 Hz for consistency
        GIST_file = readtable(input_filearg); 
        tilt_vel_deg  = resample(GIST_file.ZVelocity,50,375);
        tilt_vel_degp = resample(GIST_file.XVelocity,50,375);
        tilt_vel_degy = resample(GIST_file.YVelocity,50,375);
    else % TTS file
        fs = 50; % Hz
        TTS_file = readtable(input_filearg); 
        Var_names = TTS_file.Properties.VariableNames;
        if Var_names{1} == "Var1" % out put from manual control vi
            tilt_angle_deg = TTS_file.(Var_names{5})/200; % store tilt feedback (actual tilt)
        else 
            tilt_angle_deg = TTS_file.TiltFeedback/200;
            
        end
        tilt_vel_deg  = [0; smoothdata((diff(tilt_angle_deg)./(diff(TTS_file.(Var_names{1}))/1000)),  "movmean",10 )]; % store tilt velocity
    end
else %TTS input file as input
    fs = 50; %Hz
    TTS_file = load(input_filearg);  
    tilt_angle_deg = TTS_file(:,8);
    tilt_vel_deg = TTS_file(:,7)/200;
end
cd(code_path);

% tilt_angle_deg = TTS_file(:,8);
% tilt_vel_deg = TTS_file(:,7)/200;

dt = 1/fs;
T = length(tilt_vel_deg)/fs; % 1/50 is the tts sampling time
model_time = (0:dt:T)';
time = model_time(1):30:model_time(end); % For plotting 

% Initialize
model_motion = [0 0 0 0 0 0].*zeros(length(model_time),1);

if contains(input_filearg, 'GIST_') % GIST file
    model_motion(2:end,5)= tilt_vel_degp;
    model_motion(2:end,6)= tilt_vel_degy;
    model_motion(2:end,4)= tilt_vel_deg;
elseif TTS_pitch == 1
    model_motion(2:end,5)= tilt_vel_deg;
else
    model_motion(2:end,4)= tilt_vel_deg;
end

loc =find(isnan(model_motion));
model_motion(loc) = 0;

%% Run observer simulations of -1 mA peak
% select GVS profile

Results = cell(1,1);

% Peak = -1;
% 
% current = ones(length(model_time),1)*Peak;
% spot = 11/dt;
% start = 10;
% current(1:start/dt) = linspace(0,0,start/dt);
% current(start/dt+1:spot) = linspace(0,Peak,spot-start/dt);
% endt = 26;
% current(endt/dt+1:end) = linspace(0,0,length(current)-endt/dt);
% current(endt/dt+1:(endt+1)/dt) = linspace(Peak,0,(endt+1)/dt-endt/dt);

% load sparky current profile
[input_filearg,input_path] = uigetfile('*.mat');
fprintf([input_filearg '\n']);

cd(input_path) %make sure the profile you want to run is in this folder
load(input_filearg);  
cd(code_path);

Profile = strrep(Profile, '+', '');
[row, col] = size(Profile);
for i = 1:col+1
    if i<=col
        current_R(i,1) = str2num(Profile{2,i});
    else
        current_R(i,1) = 0;
    end
end

for i = 1:col+1
    if i ==1 
        current_L(i,1) = 0;
    elseif i<=col
        current_L(i,1) = str2num(Profile{1,i});
    else
        current_L(i,1) = 0;
    end
end

current_R = [current_R/100];
current_L = [current_L/100];

current = [current_R current_L];

Glevel = [0 0 -1].*ones(length(model_time),1); % -1g for all time 

[ts, conf,percepts,other]= ...
    Observer_Analysis(model_time,model_motion,Glevel,current,GVS_Params);

g_est = percepts{1};
g_head = percepts{2};

omega_est = percepts{3};
omega_head = percepts{4};


tilt = atand(g_head(:,2)./g_head(:,3));
tilt_est = atand(g_est(:,2)./g_est(:,3));
tilt_p = atand(g_head(:,1)./g_head(:,3));
tilt_est_p = atand(g_est(:,1)./g_est(:,3));
Results{1} = [ts tilt_est];
% 
% figure;
% subplot(3,1,1)
% 
% 
% 
% if TTS_pitch ==1 
%     plot(ts,tilt_p); hold on;
%     plot(ts,tilt_est_p); hold on;
%     ylabel("pitch tilt deg")
% else
%     plot(ts,tilt); hold on;
%     plot(ts,tilt_est); hold on;
%     ylabel("roll tilt deg")
% end
% legend("tilt", "perception")
% subplot(3,1,2)
% % plot(ts,omega_head(:,1)); hold on;
% plot(model_time(2:end),tilt_vel_deg); hold on;
% if TTS_pitch ==1 
%     plot(ts,omega_est(:,2)); hold on;
%     ylabel(" pitch velocity deg/s")
% else
%     plot(ts,omega_est(:,1)); hold on;
%     ylabel(" roll velocity deg/s")
% end 
% legend("angular velocity","perception")
% 
% 
% subplot(3,1,3)
% plot(model_time,current_R, 'r') 
% hold on; 
% plot(model_time,current_L, 'b')
% ylabel("mA")
% xlabel("time")
% legend(["right" "left"])
% 
% subplot(3,1,2)
% ylim([-20 20])
% sgtitle(strrep(input_filearg, '_' , ' '));
% % sgtitle("4A 5mAmaxCh10Roll-999ZVelocityMaxAngle5MaxVel6")
% if TTS_pitch ==1
%     cd('C:\Users\caroa\UCB-O365\Bioastronautics File Repository - File Repository\Torin Group Items\Projects\Motion Coupled GVS\PitchDynamicGVSPlusTiltTesting\Data\PerceptionProfiles');
%     save(input_filearg, "tilt_est_p");
%     cd(code_path)
% 
% end
% 
% % pitch plot
% if TTS_pitch ==1 
% else
% figure;
% subplot(3,1,1)
% plot(ts,tilt_p); hold on;
% plot(ts,tilt_est_p); hold on;
% legend("tilt", "perception")
% ylabel("pitch tilt deg")
% 
% subplot(3,1,2)
% % plot(ts,omega_head(:,1)); hold on;
% plot(model_time(2:end),tilt_vel_degp); hold on;
% plot(ts,omega_est(:,2)); hold on;
% legend("angular velocity","perception")
% ylabel(" pitch velocity deg/s")
% 
% subplot(3,1,3)
% plot(model_time,current_R, 'r') 
% hold on; 
% plot(model_time,current_L, 'b')
% ylabel("mA")
% xlabel("time")
% 
% subplot(3,1,2)
% ylim([-20 20])
% sgtitle(strrep(input_filearg, '_' , '-'));
% end
% 
% max(tilt_est)
% max(tilt)
% min(tilt_est)
% min(tilt)
% max(abs(tilt-tilt_est))

%% ASMA figures
% 
% t_sham = ts;
% omega_est_sham = omega_est;
% tilt_est_p_sham = tilt_est_p;
% tilt_est_r_sham = tilt_est;

colorOrder = [188 39 49
              54 134 160 
              129 190 161
              56 54 97
              107 78 113];
co = colorOrder/255;

red = co(1,:);
blue = co(2,:);
green = co(3,:);
navy = co(4,:);
purple = co(5,:);

f = figure; 
f.Position = [0,0, 650, 950];
tiledlayout(3,1,"TileSpacing","tight", "Padding","tight")
nexttile
plot(model_time,current_R, 'Color', red, LineWidth= 3) 
hold on; 
plot(model_time,current_L, 'k', LineWidth=3)
legend(["Right" "Left" ])
ylabel("Current (mA)")
xticks({})
ylim([-5 5])
xlim([0 9])
grid minor;
set(gca, 'FontSize', 24);


nexttile
plot(ts,tilt_p, 'Color', [0.75 0.75 0.75], LineWidth= 4 ); hold on;
% plot(t_sham,tilt_est_p_sham,':', 'Color', purple, 'LineWidth', 2); hold on;
plot(ts,tilt_est_p,  'Color',green , 'LineWidth', 2); hold on;
legend(["Actual"  "GVS Perception"])
ylabel("Pitch Angle (deg)")
xticks({})
ylim([-2.1 2.1])
xlim([0 9])
grid minor;
set(gca, 'FontSize', 24);

nexttile
plot(ts,omega_head(:,2)*180/pi(), 'Color', [0.75 0.75 0.75], LineWidth= 4 ); hold on;
% plot(t_sham,omega_est_sham(:,2),':', 'Color', purple, 'LineWidth',2); hold on;
plot(ts,omega_est(:,2), 'Color',green , 'LineWidth', 2); hold on;
legend(["Actual"  "GVS Percpetion"])
ylabel("Pitch Velocity (deg/s)")
xlabel("Time(s)")
ylim([-20 20])
xlim([0 9])
grid minor;
set(gca, 'FontSize', 24);

%

f = figure; 
f.Position = [0,0, 650, 950];
tiledlayout(3,1,"TileSpacing","tight", "Padding","tight")
nexttile
plot(model_time,current_R, 'Color', red, LineWidth= 3) 
hold on; 
plot(model_time,current_L, 'k', LineWidth=3)
% legend(["Right" "Left" ])
ylabel("Current (mA)")
xticks({})
ylim([-5 5])
xlim([0 9])
grid minor;
set(gca, 'FontSize', 24);


nexttile
plot(ts,tilt, 'Color', [0.75 0.75 0.75], LineWidth= 4 ); hold on;
% plot(t_sham,tilt_est_r_sham,':', 'Color', purple, 'LineWidth', 2); hold on;
plot(ts,tilt_est, 'Color',green , 'LineWidth', 2); hold on;
% legend(["Actual" "Sham Perception" "GVS Perception"])
ylabel("Roll Angle (deg)")
xticks({})
ylim([-2.1 2.1])
xlim([0 9])
grid minor;
set(gca, 'FontSize', 24);

nexttile
plot(t_no_noise,omega_head_no_noise(:,1)*180/pi(), 'Color', [0.75 0.75 0.75], LineWidth= 4 ); hold on;
% plot(t_sham,omega_est_sham(:,1),':', 'Color', purple, 'LineWidth',2); hold on;
plot(ts,omega_est(:,1),'Color',green , 'LineWidth', 2); hold on;
% legend(["Actual" "Sham Perception" "GVS Percpetion"])
ylabel("Roll Velocity (deg/s)")
xlabel("Time(s)")
ylim([-20 20])
xlim([0 9])
grid minor;
set(gca, 'FontSize', 24);