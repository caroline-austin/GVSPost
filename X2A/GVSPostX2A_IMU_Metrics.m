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
fs =100; % sampling freq of 100Hz
profile_freq = [ 0 0 0.25 0.5 1];
freq_interest = [ 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.5 0.6 0.75 0.8 0.9 1 1.1 1.2 1.25];
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
    % for current = 1:l
    %     for profile =1:w
    %         for config = 1:h
    %             rms_out = rms(imu_data{current,profile,config});
    %             if isnan(rms_out)
    %                 rms_out = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
    %             end
    % 
    %             rms_save{current, profile, config}(sub,:) = rms_out;
    %         end
    %     end
    % end

     all_imu_data.(['A', subject_str])= imu_data;

     % get position data
     % Store state information

        for current = 1:l
            for profile =1:w
                % figure; 
                for config = 1:h
                    if isempty(all_imu_data.(['A', subject_str]){current,profile,config})
                        continue
                    end
                    trial_time = all_imu_data.(['A', subject_str]){current,profile,config}(:,10);
                    all_time.(['A', subject_str]){current,profile,config}(:,1) = all_imu_data.(['A', subject_str]){current,profile,config}(:,10);
                    trial_accel = all_imu_data.(['A', subject_str]){current,profile,config}(:,1:3);
                    trial_gyro = all_imu_data.(['A', subject_str]){current,profile,config}(:,4:6);
                    trial_eulers = all_imu_data.(['A', subject_str]){current,profile,config}(:,7:9);
                    [len, wid] = size(trial_eulers);

                    % make all trials only 10s
                    if len > 12*fs 
                        buffer = floor((len - 12*fs)/2);
                        trial_eulers = trial_eulers(buffer:len - buffer,:); % take middle 10s of long trials
                        trial_time_e = trial_time(buffer:len - buffer,:);

                    else
                         trial_eulers = [trial_eulers; NaN(2*buffer,wid)]; % buffer the end of short trials with NaN's
                         trial_time_e = [trial_time; NaN(2*buffer,wid)];
                    end
                       
                    if subject == 2004
                        neg_loc=find(trial_eulers < -70); % needs to be -70 for 2004 but -100 for every other sub to make roll and pitch look good
                    trial_eulers(neg_loc) = trial_eulers(neg_loc)+360;
                    else
                        neg_loc=find(trial_eulers < -100); % needs to be -70 for 2004 but -100 for every other sub to make roll and pitch look good
                        trial_eulers(neg_loc) = trial_eulers(neg_loc)+360;
                    end
                    
                    bias = mean(trial_eulers);
                    trial_eulers = trial_eulers - bias; 
                    all_ang.(['A', subject_str]){current,profile,config} =  trial_eulers;

                    roll_ang = trial_eulers(:,3);

                    [power_interest{current, profile, config}(sub,:),~] = periodogram(roll_ang,[],freq_interest,fs);
                    [med_freq{current, profile, config}(sub,:), med_power{current, profile, config}(sub,:)]=medfreq(roll_ang,fs);
                    [mean_freq{current, profile, config}(sub,:), mean_power{current, profile, config}(sub,:)]=meanfreq(roll_ang,fs);


                    mdl = fittype('a*sin(b*x+c)','indep','x');
                    fittedmdl1 = fit(trial_time_e,roll_ang,mdl,'start',[rand(),profile_freq(profile)*pi(),rand()]);
                    y_model = fittedmdl1(trial_time_e);
                  
                    phase_shift{current, profile, config}(sub,:) = fittedmdl1.c;
                    fit_freq{current, profile, config}(sub,:) = fittedmdl1.b;
                    fit_amp{current, profile, config}(sub,:) = fittedmdl1.a;
                    
                    [val, loc]=findpeaks(abs(y_model));
                    amps = abs(diff(roll_ang (loc)))/2;
                    mean_amp{current, profile, config}(sub,:) = mean(amps);
                    med_amp{current, profile, config}(sub,:) = median(amps);

                    % %for visual checking
                    % subplot(3,1,config)
                    % plot(trial_time_e,roll_ang);
                    % hold on; plot(fittedmdl1);
                    % hold on;plot(trial_time_e(loc),roll_ang(loc))
                    % title(strjoin([subject_str "Profile:" Label.Config(config) Label.Profile(profile)  Label.CurrentAmp(current) " mA"]));
                                

                end
            end
        end

    for current = 1:l
        for profile =1:w
            for config = 1:h
                rms_out = rms( all_ang.(['A', subject_str]){current,profile,config});
            if isnan(rms_out)
                rms_out = [NaN NaN NaN ];
            end

            rms_save{current, profile, config}(sub,:) = rms_out;
            end
        end
    end


end

%% save data
    cd([file_path]); %move to directory where file will be saved
    %add all variables that we want to save to a list must include space
    %between variable names 
    vars_2_save =  ['Label all_imu_data rms_save all_imu_data  all_ang all_time ' ...
        'freq_interest power_interest med_freq med_power mean_freq mean_power ' ...
        'phase_shift fit_freq fit_amp mean_amp med_amp'];% ...
        % ' EndImpedance StartImpedance MaxCurrent MinCurrent all_pos all_vel']; 
    eval(['  save ' ['Allimu.mat '] vars_2_save ' vars_2_save']); %save file     
    cd(code_path) %return to code directory
    %clear saved variables to prevent them from affecting next subjects' data
    eval (['clear ' vars_2_save]) 
