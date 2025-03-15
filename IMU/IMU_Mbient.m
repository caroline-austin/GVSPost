%% Mbientlab IMU Balance Analysis
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
conditions = {'A'}; % right now ideally just one condition, might have an exp. A and B
datatype = {'Accelerometer','Gyroscope'};

numtrials = 1; % this number will vary, should not exceed 60

% Used to find buffer time for timed trial arrays- this plot is not super
% helpful for finding the buffers with the GVSPost data
findbuffers = 0; % 1 is on other num is off
% Used to view sensor orientation over time
sensorpositionplot =0; % 1 is on other num is off

%% Initialize Storage Variables
numsub = 1;
% Initialize variables for sway data
accel(numsub,numtrials,length(conditions)).x = 0;
accel(numsub,numtrials,length(conditions)).y = 0;
accel(numsub,numtrials,length(conditions)).z = 0;
vel(numsub,numtrials,length(conditions)).x = 0;
vel(numsub,numtrials,length(conditions)).y = 0;
vel(numsub,numtrials,length(conditions)).z = 0;
pos(numsub,numtrials,length(conditions)).x = 0;
pos(numsub,numtrials,length(conditions)).y = 0;
pos(numsub,numtrials,length(conditions)).z = 0;

% Initialize variables for balance metrics
rmsXYa = NaN(numsub,numtrials,length(conditions));
rmsXa = rmsXYa; rmsYa = rmsXYa;
p2pXa = rmsXYa; p2pYa = p2pXa;

%% get Metrics defining Sway

         [accelfile , file_path] = uigetfile('*.csv', 'Select a CSV File');
        % [file_path,'/',num2str(subject),'/',...
        %     num2str(subject),'-A','-',...
        %     datatype{1},'-',  num2str(cond) ,'.csv'];

        [ gyrofile , ~] = uigetfile('*.csv', 'Select a CSV File');
        % [file_path,'/',num2str(subject),'/',...
        %     num2str(subject),'-A','-',...
        %     datatype{2}, '-' ,num2str(cond), '.csv'];

        % timestampfile = [file_path,'/',num2str(subject),'/',...
            % num2str(subject),'-All-TimeStamps-', num2str(cond) ,'.xlsx'];
     
        cd(file_path)
        % Read in raw data
        acceldata = readtable(accelfile,'ReadVariableNames',false);
        gyrodata = readtable(gyrofile,'ReadVariableNames',false);
        % timestamps = readtable(timestampfile,'ReadVariableNames',false);
        cd(code_path)
        % numtrials = ceil(height(timestamps)/2); 

        fs = input('Enter the sampling frequency in Hz: ');
        dt = 1/fs;
  
        % Ensure data aligns across measurement types
        time = 1/fs:1/fs:max(acceldata.Var3); % create aligned time vec %adjust for sampling freq
        [acc, gyro] = TimeAlign(time,acceldata,gyrodata);
%%
        % Convert units from g --> m/s2 and deg/s --> rad/s
        acc = 9.8*acc;
        gyro = pi/180*gyro;

        % Rotate accelerometer Data (x-ML y-AP z-EarthVertical)
        [acc_aligned, gyro_aligned,euler_angles] = GravityAligned(acc, gyro,sensorpositionplot,fs);

%% calculate the roll and pitch angles
        % Initialize variables
        roll = zeros(size(time));    % Roll angle
        pitch = zeros(size(time));   % Pitch angle
        yaw = zeros(size(time));     % Yaw angle (this example doesn't calculate yaw)
        gyro_angle = zeros(3, length(time)); % Gyro angle
        acc_angle = zeros(3, length(time)); % Accelerometer angle
        alpha = .98; % Complementary filter constant (tune this value)

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
            acc_angle(2, i) = atan2(-acc(i,1), sqrt(acc(i,2)^2 + acc(i,1)^2)); % Pitch from accelerometer

            % Apply complementary filter to combine accelerometer and
            % gyroscope data- accelerometer data corrects for the gyroscope
            % drift
            roll(i) = alpha * (roll(i-1) + gyro( i-1,3) * dt) + (1 - alpha) * acc_angle(1,i); % Roll estimate
            pitch(i) = alpha * (pitch(i-1) + gyro(i-1,2) * dt) + (1 - alpha) * acc_angle(2,i); % Pitch estimate

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




%% Functions
function [acc, gyro] = TimeAlign(time,acceldata,gyrodata)
    acc = interp1(acceldata.Var3,[acceldata.Var4, acceldata.Var5, ...
            acceldata.Var6],time);
    gyro = interp1(gyrodata.Var3,[gyrodata.Var4, gyrodata.Var5, ...
            gyrodata.Var6],time);
end


function Times = GetTrialTimes(timestamps,buffer,cond)
    
    if cond == 1
        TimeStamps = timestamps.Var3;
    elseif cond == 2
        TimeStamps = timestamps.Var5;
    elseif cond == 3
        TimeStamps = timestamps.Var8;
    else
        disp('Not programmed for 4 or more conditions!')
    end

    if isnan(TimeStamps(1))
            ts = 2; spot = 1;
    else
            ts = 1; spot = 0;
    end
    timeold = buffer;
    Times = zeros(length(TimeStamps)-1,1);
    for t = ts:length(TimeStamps)
        time = TimeStamps(t);
        Times(t-spot) = time+timeold;
        timeold = Times(t-spot);
    end
end

function  [acc_aligned,gyro_aligned,Eulers] = GravityAligned(acc, gyro,sensorpositionplot,fs)
    FUSE = imufilter('SampleRate',fs);
    q = FUSE(acc,gyro); % goes from Inertial to Sensor
    Eulers = eulerd(q, 'ZYX', 'frame'); % sensor = Rx'*Ry'*Rz'*global

    acc_aligned = zeros(length(acc),3);
    for i = 1:length(acc)
        theta = Eulers(i,3);
        phi = Eulers(i,2);
        Rx = [1 0 0;0 cosd(theta) -sind(theta);...
              0 sind(theta) cosd(theta)];
        Ry = [cosd(phi) 0 sind(phi); 0 1 0;...
             -sind(phi) 0 cosd(phi)];

        % Excludes Rz to keep ML and AP aligned with x and y in the subject 
        % coordinated system vs. some fixed yaw inertial reference frame
        % yaw = -Eulers(i,1);
        % Rz = [cosd(yaw) -sind(phi) 0; 
        %       sind(yaw) cosd(yaw) 0; 0 0 1];
        acc_aligned(i,:) = (Ry*Rx*acc(i,:)')'; % Rz*Ry*Rx*sensor to go back
        gyro_aligned(i,:) = (Ry*Rx*gyro(i,:)')'; 
    end

    if sensorpositionplot == 1
        pp=poseplot;
        for ii=1:size(acc,1)
            qimu = FUSE(acc(ii,:), gyro(ii,:));
            set(pp, "Orientation", qimu)
            drawnow limitrate
            pause(0.05)
        end
    end
end