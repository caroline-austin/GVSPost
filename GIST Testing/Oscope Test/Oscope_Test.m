close all;
clear;
clc;

file_path = uigetdir;
file_list = dir(file_path);

GIST_name = file_list(7).name;
Oscope_name = file_list(10).name;
file_1 = readmatrix(Oscope_name);
file_2 = readmatrix(GIST_name);
Oscope_time = file_1(3:end,1);
GIST_time = file_2(:,1);

% trim data 
GIST_cut = 10; % new starting time for GIST data
Oscope_cut = 15; % new starting time for Oscope data
start_row_GIST = find(file_2(:,1)>GIST_cut,1,"first");
Oscope_shift = Oscope_time + Oscope_time(end);
start_row_Oscope = find(Oscope_shift>Oscope_cut,1,"first");

% Oscope data
Oscope_cut_time = Oscope_shift(start_row_Oscope-2:end,1);
Oscope_channel1 = file_1(start_row_Oscope:end,2);
Oscope_channel2 = file_1(start_row_Oscope:end,3);
Oscope_channel3 = file_1(start_row_Oscope:end,4);

% GIST data
GIST_cut_time = file_2(start_row_GIST:end,1);
GIST_current1 = file_2(start_row_GIST:end,5);
GIST_current2 = file_2(start_row_GIST:end,6);
GIST_current3 = file_2(start_row_GIST:end,7);
GIST_roll = file_2(start_row_GIST:end,13);
GIST_pitch = file_2(start_row_GIST:end,12);
GIST_zvelocity = file_2(start_row_GIST:end,19);

% GIST Oscope Sync
[maxO, Oidx] = max(Oscope_channel3);
[maxG, Gidx] = max(GIST_current2);
sync_time1 = GIST_cut_time(Gidx);
sync_time2 = Oscope_cut_time(Oidx);
sync_diff = sync_time2-sync_time1;
Oscope_cut_time = Oscope_cut_time-sync_diff;

% Plots
figure(1)
plot(Oscope_cut_time,Oscope_channel1);
hold on
plot(Oscope_cut_time,Oscope_channel2);
plot(Oscope_cut_time,Oscope_channel3);
title("New GIST Current Leak 4mA")
xlabel("time (sec)")
ylabel("voltage (mA)")
legend("Channel 1 (Ch1 Red)", "Channel 2 (Ch2 Red)", "Channel 3 (Ref)")
hold off

figure(2)
plot(GIST_cut_time,GIST_zvelocity);
hold on
plot(GIST_cut_time,GIST_roll);
plot(GIST_cut_time,GIST_current1./10);
title("GIST zvelocity coupled (Polarity On)");
xlabel("time (sec)");
legend("zvelocity", "roll","current");
hold off

figure(3)
subplot(3,1,1) % IMU multi-channel Oscope;
plot(GIST_cut_time,GIST_current1);
hold on
xlim([10,45])
plot(Oscope_cut_time,(Oscope_channel2-Oscope_channel1) .* 1000);
title("GIST and Oscope pitch")
hold off

subplot(3,1,2)
plot(GIST_cut_time,GIST_current2);
hold on
xlim([10 45])
plot(Oscope_cut_time,(Oscope_channel3-Oscope_channel1) .* 1000);
title("GIST and Oscope roll")
hold off

subplot(3,1,3)
plot(Oscope_cut_time,Oscope_channel1 .*1000)
hold on
xlim([10 45])
plot(Oscope_cut_time,Oscope_channel2 .*1000)
plot(Oscope_cut_time,Oscope_channel3 .*1000)
title("Oscope Channels")
legend("Channel 1 (ref)", "Channel 2 (red)", "Channel 3 (red)")
hold off



