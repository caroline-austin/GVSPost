close all;
clear;
clc;

code_path = pwd; 
file_path = uigetdir; 
file_list = dir(file_path);

%% Individual comparisons 

GIST_name = file_list(5).name;
TTS_name = file_list(22).name;

GIST_file = readmatrix(GIST_name);
TTS_file = readmatrix(TTS_name);

%% User Decay Comparisons 

GIST_name1 = string(file_list(5).name); 
GIST_name2 = string(file_list(6).name);
GIST_name3 = string(file_list(7).name);

TTS_name1 = string(file_list(22).name); 
TTS_name2 = string(file_list(27).name); 
TTS_name3 = string(file_list(28).name); 

GIST_file_list = [GIST_name1 GIST_name2 GIST_name3];
TTS_file_list = [TTS_name1 TTS_name2 TTS_name3];

for i = 1:length(GIST_file_list)
    loaded_GIST.(['GIST_file' num2str(i)]) = readmatrix(GIST_file_list(i));
    loaded_TTS.(['TTS_file' num2str(i)]) = readmatrix(TTS_file_list(i));
end

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

%% User Decay Scaling

for j = 1:length(GIST_file_list)
    GIST_loaded_file = loaded_GIST.(['GIST_file' num2str(j)]);
    TTS_loaded_file = loaded_TTS.(['TTS_file' num2str(j)]);

    loaded_TTS.(['scaled_time' num2str(j)]) = (TTS_loaded_file(1:end-2,1)-TTS_loaded_file(1,1))./1000;

    voltage = GIST_loaded_file(:,2);
    start_voltage_row = find(voltage>0,1,"first");
    loaded_GIST.(['start_voltage_time' num2str(j)]) = GIST_loaded_file(start_voltage_row,1)/2;

    roll = GIST_loaded_file(:,11);
    start_roll_row = find(roll>0,1,"first");
    loaded_GIST.(['start_roll_time' num2str(j)]) = GIST_loaded_file(start_roll_row,1)/2;

end

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
plot(scaled_time, TTS_CH1/500)
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

figure(6)
plot(loaded_GIST.GIST_file1(:,1)-loaded_GIST.start_roll_time1+0.6, loaded_GIST.GIST_file1(:,5))
hold on
plot(loaded_GIST.GIST_file2(:,1)-loaded_GIST.start_roll_time2+0.6, loaded_GIST.GIST_file2(:,5))
plot(loaded_GIST.GIST_file3(:,1)-loaded_GIST.start_roll_time3+0.6, loaded_GIST.GIST_file3(:,5))
title("User Decay Comparison GIST Record (Roll Coupled)")
legend("1 Second", "10 Seconds", "65 Seconds")
xlabel("time (sec)")
ylabel("current")

figure(7)
plot(loaded_TTS.scaled_time1, loaded_TTS.TTS_file1(1:end-2,11)./2000)
hold on
plot(loaded_TTS.scaled_time2, loaded_TTS.TTS_file2(1:end-2,11)./2000)
plot(loaded_TTS.scaled_time3, loaded_TTS.TTS_file3(1:end-2,11)./2000)
title("User Decay Comparison TTS Record (Roll Coupled)")
legend("1 Second", "10 Seconds", "65 Seconds")
xlabel("time (sec)")
ylabel("voltage")