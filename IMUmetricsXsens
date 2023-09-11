clc;clear;close all;

sub_dir = uigetdir;
[~,name] = fileparts(sub_dir); % Determine the name of the folder

IMU_FileName = uigetfile; % Determine the name of the file

IMU_File = [sub_dir,'\',IMU_FileName]; % Create a location for readtable

IMU_data = readtable(IMU_File);

% Initialize structure variables
euler(height(IMU_data)).x = 0;
euler(height(IMU_data)).y = 0;
euler(height(IMU_data)).z = 0;
accel(height(IMU_data)).x = 0;
accel(height(IMU_data)).y = 0;
accel(height(IMU_data)).z = 0;
gyr(height(IMU_data)).x = 0;
gyr(height(IMU_data)).y = 0;
gyr(height(IMU_data)).z = 0;

% Read data into the structure
for i=1:height(IMU_data)
    euler(i).x = table2array(IMU_data(i,3));
    euler(i).y = table2array(IMU_data(i,4));
    euler(i).z = table2array(IMU_data(i,5));
    accel(i).x = table2array(IMU_data(i,6));
    accel(i).y = table2array(IMU_data(i,7));
    accel(i).z = table2array(IMU_data(i,8));
    gyr(i).x = table2array(IMU_data(i,9));
    gyr(i).y = table2array(IMU_data(i,10));
    gyr(i).z = table2array(IMU_data(i,11));
end

time = 0:0.05:((height(IMU_data)/20)-0.05); % Create time steps

var_input = input('input data type to plot (EX: euler.x) ','s'); % Select a data type for the plot

var_cat = eval(strcat('[', var_input ,']')); % Create a variable name in brackets for the plot 


plot(time,var_cat);
title(var_input);
xlabel('time');
