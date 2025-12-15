%% script 1 of VR data analysis
% Created by: Caroline Austin
% Modified by: Caroline Austin
% Date: 12/8/2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all;
restoredefaultpath;
code_path = pwd;
%% get file 
[file_name, file_path] = uigetfile; %user selects file (testing data is in research/testing/VRTesting)

cd(file_path);
load(file_name)
cd(code_path);

input_val = NaN(length(save_input),9);
%%
for i = 1:length(save_input)
    input_val(i,:) = (sscanf(save_input(i), 'Roll: %f, Pitch: %f, Yaw: %f, Rolldot: %f, Pitchdot: %f, Yawdot: %f, Xposition: %f, Yposition: %f, Zposition: %f')); % copy this line from sparky

end

% this is an approximation until I get a real time vector
% fs = 50;
% T = length(input_val)/fs; % 1/50 is the tts sampling time
model_time = save_time(2:end-1);
dt = [ diff(model_time) 0.02];

input_val(:,1:3) = wrapTo180(input_val(:,1:3));
% input_val(:,4:6) = (input_val(:,4:6))*180/pi();
% 1,2,3 are position x,y,z ?, 4,5,6 are roll_dot pitch_dot yaw_dot, Aaron's code will
% do the necessary differentiation for position to acc.
model_motion = [0 0 0 0 0 0].*zeros(length(model_time),1); 

%%
% check to make sure the angular velocities make sense
roll_vel = diff(input_val(2:end,1))./dt';
pitch_vel = diff(input_val(2:end,2))./dt';
yaw_vel = diff(input_val(2:end,3))./dt';
% roll_pos = diff(input_val(:,4)).*dt';
% plot(model_time,input_val(1:end-1,4) );
% hold on;
% plot(model_time, roll_vel);
% hold on;
% plot(model_time,input_val(1:end-1,1) );
% plot(model_time, roll_pos);

%%
model_motion(:, 1:3) = input_val(2:end-1,7:9);
model_motion(:, 4:6) = [roll_vel -pitch_vel yaw_vel];

loc =find(isnan(model_motion));
model_motion(loc) = 0;


% specify GVS information

GVS_Params = [0.0245, 0];

% [input_filearg,input_path] = uigetfile('*.mat');
% fprintf([input_filearg '\n']);
% 
% cd(input_path) %make sure the profile you want to run is in this folder
% load(input_filearg);  
% cd(code_path);
% 
% Profile = strrep(Profile, '+', '');
% [row, col] = size(Profile);
% for i = 1:col+1
%     if i<=col
%         current_R(i,1) = str2num(Profile{2,i});
%     else
%         current_R(i,1) = 0;
%     end
% end
% 
% for i = 1:col+1
%     if i ==1 
%         current_L(i,1) = 0;
%     elseif i<=col
%         current_L(i,1) = str2num(Profile{1,i});
%     else
%         current_L(i,1) = 0;
%     end
% end
% 
% current_R = [current_R/100];
% current_L = [current_L/100];
% 
% current = [current_R current_L];
current = [0, 0] .*zeros(length(model_time),1);

% specify gravity information
% Glevel = [0 0 -0.38].*ones(length(model_time),1); % -0.38g (mars)for all time 
Glevel = [0 0 -1].*ones(length(model_time),1); % -1g for all time 

% run observer
cd ..
% cd('ObserverModels\GVS Model Basic\Observer')
cd('ObserverModels\GVS and Vision Model\Observer')
[ts, conf,percepts,other]= ...
    Observer_Analysis_GVS_Vision(model_time',model_motion,Glevel,current,GVS_Params);
cd(code_path)

g_est = percepts{1};
g_head = percepts{2};

omega_est = percepts{3};
omega_head = percepts{4};


tilt = atand(g_head(:,2)./g_head(:,3));
tilt_est = atand(g_est(:,2)./g_est(:,3));
tilt_p = atand(g_head(:,1)./g_head(:,3));
tilt_est_p = atand(g_est(:,1)./g_est(:,3));
Results{1} = [ts tilt_est];

%% plot results
% roll
figure;
plot(ts,tilt);
hold on;
plot(model_time,input_val(2:end-1,1));
plot(ts,tilt_est)
legend(["model roll tilt" "measured roll tilt" "percieved roll tilt"])
title("Roll Tilt perception")
xlim([0 model_time(end)])
%%
% roll velocity 
figure;
plot(ts,omega_head(:,1));
hold on;
plot(model_time,model_motion(:,4));
plot(ts,omega_est(:,1))
legend(["model roll velocity" "measured roll velocity" "percieved roll tilt"])
title("Roll Tilt perception")
xlim([0 model_time(end)])
%% plot results
% pitch
figure;
plot(ts,tilt_p);
hold on;
plot(model_time,input_val(2:end-1,2));
plot(ts,tilt_est_p)
legend(["model pitch tilt" "measured pitch tilt" "percieved pitch tilt"])
title("Pitch Tilt perception")
xlim([0 model_time(end)])
%%
figure;
plot(roll_vel)
hold on
plot(pitch_vel );
plot(yaw_vel);