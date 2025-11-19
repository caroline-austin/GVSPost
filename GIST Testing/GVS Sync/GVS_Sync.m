
close all;
clear;
clc;

code_path = pwd; 
file_path = uigetdir; 
file_list = dir(file_path);

GIST_name = file_list(3).name;
TTS_name = file_list(19).name;

GIST_file = readmatrix(GIST_name);
TTS_file = readmatrix(TTS_name);

%% Scaling

% TTS scale

cut_time = TTS_file(1:end-2,1)-TTS_file(1,1);
scaled_time = cut_time./1000;
TTS_motion = TTS_file(1:end-2,4)/200;
TTS_CH1 = TTS_file(1:end-2,11);
TTS_CH2 = TTS_file(1:end-2,12);
TTS_CH3 = TTS_file(1:end-2,13);

% GIST time scale

voltage = GIST_file(:,2);
start_voltage_row = find(voltage>0,1,"first");
start_voltage_time = GIST_file(start_voltage_row,1)/2;

roll = GIST_file(:,11);
start_roll_row = find(roll>0,1,"first");
start_roll_time = GIST_file(start_roll_row,1)/2;

%% plotting

figure(1) % TTS motion and GIST voltage
plot(GIST_file(:,1)-start_voltage_time+0.6, GIST_file(:,2).*2);
hold on
plot(scaled_time, TTS_motion);
legend("GIST Voltage", "TTS Motion");
xlabel("time (sec)");
title("GIST Voltage vs TTS Motion")

figure(2) % GIST IMU vs GIST voltage 
plot(GIST_file(:,1), GIST_file(:,2));
hold on
plot(GIST_file(:,1), GIST_file(:,11));
legend("GIST Voltage", "GIST IMU");
title("GIST IMU vs GIST Voltage")
xlabel("time (sec)")

figure(3) % GIST IMU vs TTS motion
plot(GIST_file(:,1)-start_roll_time+0.6, GIST_file(:,11));
hold on
plot(scaled_time, TTS_motion);
legend("GIST IMU", "TTS Motion")
title("GIST IMU vs TTS Motion")
xlabel("time (sec)")
ylabel("degrees")

figure(4) % TTS Motion vs TTS GVS
plot(scaled_time, TTS_motion)
hold on
plot(scaled_time, TTS_CH1/700)
title("Recorded TTS Motion vs TTS GVS Readings")
legend("TTS Motion (column 4)", "TTS GVS (column 11)")
xlabel("time (sec)")

figure(5) % TTS GVS channels
plot(scaled_time, TTS_CH1/1000)
hold on
plot(scaled_time, TTS_CH2/1000)
plot(scaled_time, TTS_CH3/1000)
title("GVS Channels and Current Leak")
legend("Channel 1", "Channel 2", "Channel 3")
xlabel("time (sec)")
ylabel("voltage")
