% Created by: Caroline Austin 2/6/24
% Script 2b of X2C data processing 
% This script reads in the output of script 1 (X2CGet files) and processes
% the IMU data files by running them through the gravity align function and
% then extracting sway metrics?

close all; 
clear all; 
clc; 


%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory % select data folder
plots_path = [file_path '/Plots']; % specify where plots are saved
cd(code_path); cd .. ;
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = [2044:2048, 2050,2052, 2063:2065];  % Subject List 2044:2048, 2050,2052, 2063:
numsub = length(subnum);
subskip = [2049 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

sensorpositionplot = 0;
fs = 30;
dt = 1/fs;

%%
total_results = zeros(3,2);

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path '/' subject_str];

    % load excel data for the subj
    cd([subject_path]);
    load(['S' subject_str '.mat']);

    all_match_ups = main_match_ups;

    % find IMU data
    cd(code_path); cd ..;
    [IMU_files]=file_path_info2(code_path, [file_path, '/' , subject_str, '/IMU']); % get filenames from file folder
     

    file_count = 0;
    f_index = 0;
    s_index = 0;
    n_index = 0;
    for file = 1:length(IMU_files)
        
        %index through the csv files
        if ~contains(IMU_files(file), '.mat')
            continue
        elseif contains(IMU_files(file), '2065') && contains(IMU_files(file), '01')
            continue
        end
        file_count = file_count+1;
        %load trial data
        cd([subject_path '/IMU']);
        load(IMU_files{file});
        x_tick_label{file_count,sub} = IMU_files{file}(7:12);

        trial =  str2num(IMU_files{file}(end-5:end-4));

        Euler = imu_data(2:end,1:3); % exclude first line of 0's
        % not sure why, but order needs to be rotated like this- maybe so that the
        % axis that is most aligned with what we want to be z is the third?
        % acc = imu_data(2:end,[6,5,4]); 
        acc = imu_data(2:end,4:6); 
        gyro = pi/180*imu_data(2:end,7:9); % convert to rad/s


        Label.imu = imu_table.Properties.VariableNames(3:11);
        time = 0:1/30:((height(acc)/30)-1/30);
        timeimu = 0:1/30:((height(imu_data)/30)-1/30);
        if length(timeimu) > 285
            time_cut = timeimu > 2 & timeimu < 9.5;
        else
            %continue
        end

        cd(code_path); cd .. ;
        [acc_aligned, gyro_aligned, ~,~,~] = GravityAligned(acc(:,[2,3,1]), gyro(:,[2,3,1]),sensorpositionplot,fs);
        % %[Xlimit,Ylimit] = PlotScale(imu_data,time);
        % cutacc = acc_aligned(time_cut,:);
        % cutgyro = gyro_aligned(time_cut,:);
        % cutyaw = yaw(time_cut);
        % cutroll = roll(time_cut);
        % cutpitch = pitch(time_cut);

                %% calculate the roll and pitch angles
        % Initialize variables
        roll = zeros(size(time));    % Roll angle
        pitch = zeros(size(time));   % Pitch angle
        yaw = zeros(size(time));     % Yaw angle (this example doesn't calculate yaw)
        gyro_angle = zeros(3, length(time)); % Gyro angle
        acc_angle = zeros(3, length(time)); % Accelerometer angle
        alpha = .90; % Complementary filter constant (tune this value)

        % Initial angles from accelerometer (first estimate)
        acc_angle(1, 1) = atan2(acc_aligned(2,1), acc_aligned(3,1)); % Roll
        acc_angle(2, 1) = atan2(-acc_aligned(1,1), sqrt(acc_aligned(2,1)^2 + acc_aligned(3,1)^2)); % Pitch
        
        % Process each time step
        for i = 2:length(time)

             gyro_angle(:, i) = gyro_angle(:, i-1) + gyro(i-1,: )' * dt; % Integrate gyro data to get angle

            % Accelerometer-based angle estimation (assuming accelerometer gives tilt)
            acc_angle(1, i) = atan2(acc(i,2), acc(i,1)); % Roll from accelerometer
            acc_angle(2, i) = atan2(-acc(i,3), sqrt(acc(i,1)^2 + acc(i,3)^2)); % Pitch from accelerometer

            % Apply complementary filter to combine accelerometer and
            % gyroscope data- accelerometer data corrects for the gyroscope
            % drift
            roll(i) = alpha * (roll(i-1) + gyro( i-1,3) * dt) + (1 - alpha) * -acc_angle(1,i); % Roll estimate
            pitch(i) = alpha * (pitch(i-1) + gyro(i-1,2) * dt) + (1 - alpha) * -acc_angle(2,i); % Pitch estimate

            % If you want to calculate yaw, you would need magnetometer
            % data or use more advanced sensor fusion to correct for the
            % drift
            yaw(i) = yaw(i-1) + gyro(i-1,3 ) * dt; % Gyroscope yaw estimate (if available)
        end


        tilt_angles= [roll; pitch; yaw]';
        
        imu_angles{trial} = tilt_angles; 
        Label.imu_angles = ["roll" "pitch" "yaw"];
        Label.trial{trial} = IMU_files{file}(1:end-6);

    end

        %% Save file
    cd([file_path, '/' , subject_str]); %move to directory where file will be saved
    %add all variables that we want to save to a list must include space
    %between variable names 
    vars_2_save =  ['Label  imu_data imu_angles acc_aligned gyro_aligned ' ...
        'all_match_ups']; 
    eval(['  save ' ['A', subject_str,'imu.mat '] vars_2_save ' vars_2_save fs']); %save file     
    cd(code_path) %return to code directory
    %clear saved variables to prevent them from affecting next subjects' data
    eval (['clear ' vars_2_save]) 

end


cd(code_path);



