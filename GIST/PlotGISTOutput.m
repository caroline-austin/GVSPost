% select a GIST file to open and plot the data streams

clear all
% close all
%%
code_path = pwd; 

[file_name, file_path] = uigetfile('*.csv');

cd(file_path)
data = readtable(file_name);
cd(code_path);
%%
figure;
plot(data.CH1Current);
hold on;
plot(data.CH2Current);
hold on;
plot(data.CH3Current);
legend(["Ch1", "Ch2", "Ch3"])
title(file_name);

figure;
plot(data.Roll);
hold on;
plot(data.Pitch);
hold on;
plot(data.Yaw);
legend(["Roll", "Pitch", "Yaw"])
title(file_name);


figure;
plot(data.XVelocity);
hold on;
plot(data.YVelocity);
hold on;
plot(data.ZVelocity);
legend(["Pitch Vel", "Yaw Vel", "Roll Vel"])
title(file_name);