%% script 2 of IMU data analysis
% Created by: Caroline Austin
% Modified by: Caroline Austin
% Date: 10/11/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMU data in the form of 'ASubjectNumberimu.mat'
% imu_data has the sorted data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all;
restoredefaultpath;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

subnum = [2001:2010];  % Subject List 2001:2010 2001:2010
numsub = length(subnum);
subskip = [2001 2008 2010];  %DNF'd subjects

%% load data 
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    

     if ismember(subject,subskip) == 1
       continue
     end

    cd([file_path, '/' , subject_str]);
    load(['A' subject_str 'imu.mat'])
    cd(code_path);

%% calc metrics 
    [l, w , h] = size(imu_data);

% rms, others
    for current = 1:l
        for profile =1:w
            for config = 1:h
                rms_out = rms(imu_data{current,profile,config});
                if isnan(rms_out)
                    rms_out = [NaN NaN NaN NaN NaN NaN];
                end

                rms_save{current, profile, config}(sub,:) = rms_out;
            end
        end
    end

     all_imu_data.(['A', subject_str])= imu_data;

     % get position data
     % Store state information
    % vel(sub,trial,cond).x = ...
    %     cumtrapz(trial_time,trial_accel(:,1));
    % vel(sub,trial,cond).y = ...
    %     cumtrapz(trial_time,trial_accel(:,2));
    % vel(sub,trial,cond).z = ...
    %     cumtrapz(trial_time,trial_accel(:,3));
        for current = 1:l
            for profile =1:w
                for config = 1:h
                    all_pos.(['A', subject_str]){current,profile,config}(:,1) = ...
                        cumtrapz(trial_time,cumtrapz(trial_time,trial_accel(:,1)));
                    all_pos.(['A', subject_str]){current,profile,config}(:,2) = ...
                        cumtrapz(trial_time,cumtrapz(trial_time,trial_accel(:,2)));
                    all_pos.(['A', subject_str]){current,profile,config}(:,3) = ...
                        cumtrapz(trial_time,cumtrapz(trial_time,trial_accel(:,3)));
                end
            end
        end

end

%% save data
    cd([file_path]); %move to directory where file will be saved
    %add all variables that we want to save to a list must include space
    %between variable names 
    vars_2_save =  ['Label all_imu_data rms_save' ];% ...
        % ' EndImpedance StartImpedance MaxCurrent MinCurrent ']; 
    eval(['  save ' ['Allimu.mat '] vars_2_save ' vars_2_save']); %save file     
    cd(code_path) %return to code directory
    %clear saved variables to prevent them from affecting next subjects' data
    eval (['clear ' vars_2_save]) 
