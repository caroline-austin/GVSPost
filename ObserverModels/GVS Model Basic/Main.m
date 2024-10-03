% Example Run
clc;clear;
addpath("./Observer/");
addpath("./assets/")

GVS_Params = [0.0245, 0];

T = 42;
dt = 0.01;
model_time = (0:dt:T)';
time = model_time(1):30:model_time(end); % For plotting 

% Initialize
model_motion = [0 0 0 0 0 0].*zeros(length(model_time),1);

%% Run observer simulations of -1 mA peak

Results = cell(1,1);

Peak = -1;

current = ones(length(model_time),1)*Peak;
spot = 11/dt;
start = 10;
current(1:start/dt) = linspace(0,0,start/dt);
current(start/dt+1:spot) = linspace(0,Peak,spot-start/dt);
endt = 26;
current(endt/dt+1:end) = linspace(0,0,length(current)-endt/dt);
current(endt/dt+1:(endt+1)/dt) = linspace(Peak,0,(endt+1)/dt-endt/dt);

Glevel = [0 0 -1].*ones(length(model_time),1); % -1g for all time 

[ts, conf,percepts,other]= ...
    Observer_Analysis(model_time,model_motion,Glevel,current,GVS_Params);

g_est = percepts{1};
g_head = percepts{2};

tilt = atand(g_head(:,2)./g_head(:,3));
tilt_est = atand(g_est(:,2)./g_est(:,3));
Results{1} = [ts tilt_est];