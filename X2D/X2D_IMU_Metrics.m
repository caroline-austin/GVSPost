%% script 3 of IMU data analysis
% Created by: Caroline Austin
% Modified by: Caroline Austin
% Date: 11/20/2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMU data in the form of 'ASubjectNumberimu.mat'
% imu_angle has the sorted data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all;
restoredefaultpath;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

subnum = [2049, 2051,2053:2057, 2061:2062, 2078:2090];  % Subject List 2049, 2051,2053:2062
numsub = length(subnum);
subskip = [2058 2059 2060 2069:2077 2083 2085 2086 2070 2072 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

fs =30; % sampling freq of 30Hz
dt = 1/fs;
profile_freq = [ 0.5 ]; % default freq
all_trials_sort = NaN(5,numsub, 3,fs*12+2);
mag_interest_sort= NaN(6, numsub,3);
psd_interest_sort= NaN(6, numsub,3);
mag_interest= NaN(5, numsub,3);
psd_interest= NaN(5, numsub,3);

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
    [l, w , h] = size(imu_angles);

     all_imu_angles.(['A', subject_str])= imu_angles;

     % Store state information
        index1 = 1;
        index2 = 1;
        index3 = 1;
        index4 = 1;
        index5 = 1;
        index6 = 1;
        index7 = 1;
        index8 = 1;
        index9 = 1;
        for trial = 1:w   % calculate all metrics and aggregate the data            
                
                    if isempty(all_imu_angles.(['A', subject_str]){trial})
                        
                        continue
                     end
                    trial_angles = all_imu_angles.(['A', subject_str]){trial}(:,1:3)*180/pi();
                    trial_time = (0:dt:length(trial_angles))';
                    % all_time.(['A', subject_str]){current,profile,config}(:,1) = all_imu_data.(['A', subject_str]){current,profile,config}(:,10);
                   
                    
                    [len, wid] = size(trial_angles);
                    profile_freq = IMUTrialInfo{trial,5};

                    % make all trials only 12s
                    % if len > 12*fs 
                    %     buffer = floor((len - 12*fs)/2);
                    %     trial_angles = trial_angles(buffer:len - buffer,:); 
                    %     trial_time_a = trial_time(buffer:len - buffer);
                        
                    if len > 10*fs 
                        % start_buffer = floor((len - 12*fs)/2);
                        start_buffer = fs+1;
                        end_buffer = (len - 8*fs) - start_buffer+1;
                        trial_angles = trial_angles(start_buffer:len - end_buffer,:); % take middle 10s of long trials
                        trial_time_a = trial_time(start_buffer:len - end_buffer);

                    elseif len >4*fs
                        start_buffer = fs+1;
                        end_buffer = (len - 4*fs) - start_buffer+1;
                        trial_angles = trial_angles(start_buffer:len - end_buffer,:); % take middle 10s of long trials
                        trial_time_a = trial_time(start_buffer:len - end_buffer);

                    else 
                         trial_time_a = trial_time;
                    end
                    all_time.(['A', subject_str]){trial}(:,1) = trial_time_a;

                    trial_angles = trial_angles- mean(trial_angles, 'omitnan');

                    roll_ang = trial_angles(:,1);
                    pitch_ang = trial_angles(:,2);
                    yaw_ang = trial_angles(:,3);

                    % figure;
                    % plot(trial_angles2)
                    % hold on;
                    % plot(trial_angles)
                    % legend(["roll2" "pitch2" "yaw2" "roll" "pitch" "yaw"])

                    all_ang.(['A', subject_str]){trial} =  trial_angles;

                    if length(roll_ang) >= 4*fs

                        [pxx_roll,f_roll] = periodogram(roll_ang,hamming(length(roll_ang)),length(roll_ang),fs,'power');
                        ind_f = find(ismember(f_roll,profile_freq)); % find the index that matches the profile freq
                        % ind_f = [ind_f-1 ind_f ind_f+1];
                        pwr_f = f_roll(ind_f);
                        % pwr_f = interp1(f_roll, pxx_roll, profile_freq); % the interp function should return the correct value still
                        mag_interest(trial, sub,1,:) = sqrt(pwr_f *2);
                        psd_interest(trial, sub,1,:) = pwr_f ;
    
                        [pxx_pitch,f_pitch] = periodogram(pitch_ang,hamming(length(pitch_ang)),length(pitch_ang),fs,'power');
                        ind_f = find(ismember(f_pitch,profile_freq)); % find the index that matches the profile freq
                        % ind_f = [ind_f-1 ind_f ind_f+1];
                        pwr_f = pxx_pitch(ind_f);
                        % pwr_f = interp1(f_pitch, pxx_pitch, profile_freq);
                        mag_interest(trial, sub,2,:) = sqrt(pwr_f *2);
                        psd_interest(trial, sub,2,:) = pwr_f ;
    
                        [pxx_yaw,f_yaw] = periodogram(yaw_ang,hamming(length(yaw_ang)),length(yaw_ang),fs,'power');
                        ind_f = find(ismember(f_yaw,profile_freq)); % find the index that matches the profile freq
                        % ind_f = [ind_f-1 ind_f ind_f+1];
                        pwr_f = pxx_yaw(ind_f);
                        % pwr_f = interp1(f_yaw, pxx_yaw, profile_freq); 
                        mag_interest(trial, sub,3,:) = sqrt(pwr_f *2);
                        psd_interest(trial, sub,3,:) = pwr_f ;

                        % create control measurement for 0.5Hz
                        if (contains(Label.trial(trial),"_0_1mA") || contains(Label.trial(trial),"_0mA"))
                            ind_f = find(ismember(f_roll,0.5)); % find the index that matches 0.5 Hz for control
                            % ind_f = [ind_f-1 ind_f ind_f+1];
                            pwr_f = f_roll(ind_f);
                            % pwr_f = interp1(f_roll, pxx_roll, profile_freq); % the interp function should return the correct value still
                            mag_interest_05(trial, sub,1,:) = sqrt(pwr_f *2);
                            psd_interest_05(trial, sub,1,:) = pwr_f ;

                            ind_f = find(ismember(f_pitch,0.5)); % find the index that matches 0.5 Hz for control
                            % ind_f = [ind_f-1 ind_f ind_f+1];
                            pwr_f = pxx_pitch(ind_f);
                            % pwr_f = interp1(f_pitch, pxx_pitch, profile_freq);
                            mag_interest_05(trial, sub,2,:) = sqrt(pwr_f *2);
                            psd_interest_05(trial, sub,2,:) = pwr_f ;

                            ind_f = find(ismember(f_yaw,0.5)); % find the index that matches the 0.5 Hz for control
                            % ind_f = [ind_f-1 ind_f ind_f+1];
                            pwr_f = pxx_yaw(ind_f);
                            % pwr_f = interp1(f_yaw, pxx_yaw, profile_freq); 
                            mag_interest_05(trial, sub,3,:) = sqrt(pwr_f *2);
                            psd_interest_05(trial, sub,3,:) = pwr_f ;
                        end
                    else
                        mag_interest(trial, sub,:,:) = NaN;
                        psd_interest(trial, sub,:,:) = NaN;
                    end


                    [len, wid] = size(trial_angles);
                    if len <12*fs+2
                         buffer = floor(abs((len - (12*fs+2))));
                         trial_angles = [trial_angles; NaN(buffer,wid)]; % buffer the end of short trials with NaN's
                         trial_time_a = [trial_time; NaN(buffer,1)];
                    end
                   
                    % sort trials 
                    if contains(Label.trial(trial),"_0_1mA") || contains(Label.trial(trial),"_0mA") % should be 1
                        pad = 1;
                        All_Label.config(sub,trial) = 1;
                        all_trials_sort(pad, sub,:,:) = trial_angles';
                        mag_interest_sort(pad, sub,:,:) = mag_interest(trial, sub,:,:);
                        psd_interest_sort(pad, sub,:,:) = psd_interest(trial, sub,:,:);
                        All_Label.config_sort(sub,pad) = 1;
                        All_Label.trial_sort{sub,pad} = Label.trial(trial);

                        if subject >= 2078
                            pad = 4; % save control condition for 0.5 Hz as well
                            All_Label.config(sub,trial) = 1;
                            all_trials_sort(pad, sub,:,:) = trial_angles';
                            mag_interest_sort(pad, sub,:,:) = mag_interest_05(trial, sub,:,:);
                            psd_interest_sort(pad, sub,:,:) = psd_interest_05(trial, sub,:,:);
                            All_Label.config_sort(sub,pad) = 1;
                            All_Label.trial_sort{sub,pad} = Label.trial(trial);
                        end

                    elseif contains(Label.trial(trial),"2mA_sin_1Hz") % should be 1 trials
                        pad = 2;
                        All_Label.config(sub,trial) = 1;
                        all_trials_sort(pad, sub,:,:) = trial_angles';
                        mag_interest_sort(pad, sub,:,:) = mag_interest(trial, sub,:,:);
                        psd_interest_sort(pad, sub,:,:) = psd_interest(trial, sub,:,:);
                        All_Label.config_sort(sub,pad) = 1;
                        All_Label.trial_sort{sub,pad} = Label.trial(trial);
                    elseif contains(Label.trial(trial),"4mA_sin_1Hz") % should be 1 trials
                        pad = 3;
                        All_Label.config(sub,trial) = 1;
                        all_trials_sort(pad, sub,:,:) = trial_angles';
                        mag_interest_sort(pad, sub,:,:) = mag_interest(trial, sub,:,:);
                        psd_interest_sort(pad, sub,:,:) = psd_interest(trial, sub,:,:);
                        All_Label.config_sort(sub,pad) = 1;
                        All_Label.trial_sort{sub,pad} = Label.trial(trial);
                    elseif contains(Label.trial(trial),"2mA_sin_0_5Hz") % should be 1 or 0 trials
                        pad = 5;
                        All_Label.config(sub,trial) = 1;
                        all_trials_sort(pad, sub,:,:) = trial_angles';
                        mag_interest_sort(pad, sub,:,:) = mag_interest(trial, sub,:,:);
                        psd_interest_sort(pad, sub,:,:) = psd_interest(trial, sub,:,:);
                        All_Label.config_sort(sub,pad) = 1;
                        All_Label.trial_sort{sub,pad} = Label.trial(trial);
                    elseif contains(Label.trial(trial),"4mA_sin_0_5Hz") % should be 1 or 0 trials
                        pad = 6;
                        All_Label.config(sub,trial) = 1;
                        all_trials_sort(pad, sub,:,:) = trial_angles';
                        mag_interest_sort(pad, sub,:,:) = mag_interest(trial, sub,:,:);
                        psd_interest_sort(pad, sub,:,:) = psd_interest(trial, sub,:,:);
                        All_Label.config_sort(sub,pad) = 1;
                        All_Label.trial_sort{sub,pad} = Label.trial(trial);
                    else 
                        All_Label.config(sub,trial) = NaN;
                        All_Label.config_sort(sub,pad) = NaN;
                    end

        end
        All_Label.all_trials{sub,:}= Label.trial;
        
end

%%
Label.IMUmetrics = ["trial" "Subject" "Direction" "VarIndex"];
Label.all_trials = All_Label.all_trials;
Label.all_config = All_Label.config;
Label.all_trials_sort = All_Label.trial_sort;
Label.all_config_sort = All_Label.config_sort;
Label.sort = ["trial order", "Subject",  "direction", "time or freq", ];


%% save data
cd([file_path]); %move to directory where file will be saved
%add all variables that we want to save to a list must include space
%between variable names 
vars_2_save =  ['Label all_imu_angles all_ang all_time ' ...
    ' all_trials_sort mag_interest mag_interest_sort psd_interest psd_interest_sort '];% ...
    % ' EndImpedance StartImpedance MaxCurrent MinCurrent all_pos all_vel']; 
eval(['  save ' ['Allimu.mat '] vars_2_save ' vars_2_save']); %save file     
cd(code_path) %return to code directory
%clear saved variables to prevent them from affecting next subjects' data
% eval (['clear ' vars_2_save]) 

