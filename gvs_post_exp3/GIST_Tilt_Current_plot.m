% load data (I've been running this after running MetricRombergIMU so that
% the final subject's data is still loaded
        % sub_path = strjoin([file_path, '/' , current_participant], '');
        % cd(sub_path);
        % load(strjoin([current_participant '_' datatype '.mat'],''));
        % cd(code_path);

blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [red; blue; green; yellow;  navy; purple];

trial = 23;
channel = 2; % 2 or 5;

max_tilt = max(abs(romberg_GIST_sort{1,trial}(:,8)));

time = [1:length(romberg_GIST_sort{1,trial}(:,channel))]/3.3;

fig=figure; 
plot(time, romberg_GIST_sort{1,trial}(:,channel)/1000*45/max_tilt,  'LineWidth', 5);
title("Roll-Tilt Coupled GVS Current")
ax = gca; 
ax.ColorOrder = Color_list;
hold on;
ylabel(["Current (mA)" ], 'FontSize', 25)
xlabel("Time (s)", 'FontSize', 25)
fontsize(fig, 75, "points")

%%

fig=figure; 
plot(time, romberg_GIST_sort{1,trial}(:,[8 9 10])*45/max_tilt,  'LineWidth', 5);
title("IMU Recorded Head Tilt")
ax = gca; 
ax.ColorOrder = Color_list;
hold on;
ylabel(["Angle (deg)" ], 'FontSize', 25)
xlabel("Time (s)", 'FontSize', 25)
legend (["Roll", "Pitch", "Yaw"]);
fontsize(fig, 75, "points")

