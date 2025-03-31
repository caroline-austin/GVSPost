%% XSENS IMU Balance Analysis
% script 1 of IMU analysis - manually select file to gravity align
% Created by: Aaron Allred
% Modified by: Caroline Austin
% Date: 3/10/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMU data in the form of 'SubjectNumber-Condition-datatype.csv'
% Time stamps in the form of 'SubjectNumber-Romberg-TimeStamps.xlsx'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;
restoredefaultpath;
code_path = pwd;

%% Experimental Methods Specifications
% file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

numtrials = 1; % this number will vary, should not exceed 60

% Used to find buffer time for timed trial arrays- this plot is not super
% helpful for finding the buffers with the GVSPost data
findbuffers = 0; % 1 is on other num is off
% Used to view sensor orientation over time
sensorpositionplot =0; % 1 is on other num is off

%% Initialize Storage Variables
numsub = 1;

%% get Metrics defining Sway

         [imufile , file_path] = uigetfile('*.csv', 'Select a CSV File');

     
        cd(file_path)
        % Read in raw data
        imu_table = readtable(imufile);
        imu_data = table2array(imu_table(:,3:11));

        acc = imu_data(2:end,4:6); 
        gyro = pi/180*imu_data(2:end,7:9); % convert to rad/s
        time = 0:1/30:((height(acc)/30)-1/30);
        % timestamps = readtable(timestampfile,'ReadVariableNames',false);
        cd(code_path)
        % numtrials = ceil(height(timestamps)/2); 

        fs = input('Enter the sampling frequency in Hz: ');
        dt = 1/fs;
 

        % Rotate accelerometer Data (x-ML y-AP z-EarthVertical)
        cd(code_path); cd .. ;
        [acc_aligned, gyro_aligned, ~,~,~] = GravityAligned(acc(:,[2,3,1]), gyro(:,[2,3,1]),sensorpositionplot,fs);

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
            % % Gyroscope integration to get the angular velocity
            % gyro_angle(:, i) = gyro_angle(:, i-1) + gyro_aligned(i-1,: )' * dt; % Integrate gyro data to get angle
            % 
            % % Accelerometer-based angle estimation (assuming accelerometer gives tilt)
            % acc_angle(1, i) = atan2(acc_aligned(i,2), acc_aligned(i,3)); % Roll from accelerometer
            % acc_angle(2, i) = atan2(-acc_aligned(i,1), sqrt(acc_aligned(i,2)^2 + acc_aligned(i,3)^2)); % Pitch from accelerometer
            % 
            % % Apply complementary filter to combine accelerometer and
            % % gyroscope data- accelerometer data corrects for the gyroscope
            % % drift
            % roll(i) = alpha * (roll(i-1) + gyro_aligned( i-1,1) * dt) + (1 - alpha) * acc_angle(1,i); % Roll estimate
            % pitch(i) = alpha * (pitch(i-1) + gyro_aligned(i-1,2) * dt) + (1 - alpha) * acc_angle(2,i); % Pitch estimate
            % 
            % % If you want to calculate yaw, you would need magnetometer
            % % data or use more advanced sensor fusion to correct for the
            % % drift
            % yaw(i) = yaw(i-1) + gyro_aligned(i-1,3 ) * dt; % Gyroscope yaw estimate (if available)


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


        %% plot roll and pitch angles
        figure; 
        plot(gyro_aligned(:,1)*180/pi())
        hold on
        plot(gyro_aligned(:,2)*180/pi())

        figure; 
        plot(roll*180/pi())
        hold on
        plot(pitch*180/pi())
        % plot(yaw)
% %% plot euler angles
%         figure; 
%         euler_angles= unwrap(euler_angles);
%         euler_angles= euler_angles-mean(euler_angles, 'omitnan');
%         plot(euler_angles)
        %%

        % Get Trial Times
        % Times = GetTrialTimes(timestamps,buffer(cond,sub),cond);


        % % Make plot to find buffer
        % if findbuffers == 1
        %     figure();
        %     clf(1);
        %     hold on
        %     plot(time,gyro_aligned(:,1)); %acc_aligned(:,3)
        %     scatter(Times+repmat(trunc',numtrials,1),mean(gyro(:,1),'omitnan')*...
        %         ones(length(Times),1)); % acc_aligned(:,3)
        %     title(subject_str)
        %     hold off
        %     % pause;
        % end


    Label.IMUcell = ["AccX" "AccY" "AccZ" "Roll" "Pitch" "Yaw"];


    % %% Save file
    % cd([file_path, '/' , subject_str]); %move to directory where file will be saved
    % %add all variables that we want to save to a list must include space
    % %between variable names 
    % vars_2_save =  ['Label TrialInfo1 TrialInfo2 imu_data acc_aligned gyro_aligned euler_angles' ...
    %     ' EndImpedance StartImpedance MaxCurrent MinCurrent Times']; 
    % eval(['  save ' ['A', subject_str,'imu.mat '] vars_2_save ' vars_2_save']); %save file     
    % cd(code_path) %return to code directory
    % %clear saved variables to prevent them from affecting next subjects' data
    % eval (['clear ' vars_2_save]) 

