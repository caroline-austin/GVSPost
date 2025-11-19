close all;
clear;
clc;

code_path = pwd; 
file_path = uigetdir; 
file_list = dir(file_path);

GIST_name = file_list(4).name;

GIST_file = readmatrix(GIST_name);

%% Scaling

% GIST time scale

voltage1 = GIST_file(:,2);
voltage2 = GIST_file(:,3);
voltage3 = GIST_file(:,4);

time = GIST_file(:,1);
roll = GIST_file(:,11);
pitch = GIST_file(:,12);
yaw = GIST_file(:,13);

figure(1)
plot(time, roll);
hold on
plot(time, pitch);
plot(time, yaw);
title("GIST IMU Readings")
legend("Roll (degrees)","Pitch (degrees)", "yaw (degrees)")
hold off

figure(2)
plot(time, voltage1)
hold on
plot(time, voltage2)
plot(time, voltage3)
title("GIST Channel Voltages")
legend("CH1","CH2","CH3")
hold off