% Example Run
clc;clear;
addpath("./Observer/");
addpath("./assets/")

GVS_Params = [0.0245, 0];
dt = 1/50;

code_path = pwd;
[input_filearg,input_path] = uigetfile('*.txt');
fprintf([input_filearg '\n']);

cd(input_path) %make sure the profile you want to run is in this folder
TTS_file = load(input_filearg);  
cd(code_path);

tilt_angle_deg = TTS_file(:,8);
tilt_vel_deg = TTS_file(:,7)/200;


T = length(tilt_vel_deg)/50;
model_time = (0:dt:T)';
time = model_time(1):30:model_time(end); % For plotting 

% Initialize
model_motion = [0 0 0 0 0 0].*zeros(length(model_time),1);
model_motion(2:end,4)= tilt_vel_deg;


%% Run observer simulations of -1 mA peak

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
        current(i,1) = str2num(Profile{2,i});
    else
        current(i,1) = 0;
    end
end

current = [current/100];

Glevel = [0 0 -1].*ones(length(model_time),1); % -1g for all time 

[ts, conf,percepts,other]= ...
    Observer_Analysis(model_time,model_motion,Glevel,current,GVS_Params);

g_est = percepts{1};
g_head = percepts{2};

omega_est = percepts{3};
omega_head = percepts{4};

tilt = atand(g_head(:,2)./g_head(:,3));
tilt_est = atand(g_est(:,2)./g_est(:,3));
Results{1} = [ts tilt_est];

figure;
subplot(3,1,1)
plot(ts,tilt); hold on;
plot(ts,tilt_est); hold on;
legend("tilt", "perception")
ylabel("deg")

subplot(3,1,2)
plot(ts,omega_head(:,1)*180/pi()); hold on;
plot(ts,omega_est(:,1)); hold on;
legend("angular velocity","perception")
ylabel("deg/s")

subplot(3,1,3)
plot(model_time,current)
ylabel("mA")
xlabel("time")