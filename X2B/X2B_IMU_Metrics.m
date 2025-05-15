%% script 3 of IMU data analysis
% Created by: Caroline Austin
% Modified by: Caroline Austin
% Date: 3/27/2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMU data in the form of 'ASubjectNumberimu.mat'
% imu_angle has the sorted data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all;
restoredefaultpath;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

subnum = [2034:2043];  % Subject List 2001:2010 2001:2010
numsub = length(subnum);
subskip = [2001 2004 2008 2010];  %DNF'd subjects
fs =30; % sampling freq of 30Hz
dt = 1/fs;
profile_freq = [ 0.5 ];
freq_interest = [ 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.5 0.6 0.75 0.8 0.9 1 1.1 1.2 1.25];
num_freq = length(freq_interest);

all_trials_sort = NaN(30,numsub, 3,fs*12+2);
power_interest_sort = NaN(30, numsub,3,num_freq);
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
        for trial = 1:w   % calculate all metrics and aggregate the data            
                
                    if isempty(all_imu_angles.(['A', subject_str]){trial})
                        mean_freq(current, profile, config,sub,:) = NaN();
                        med_freq(current, profile, config,sub,:) = NaN();
                        power_interest(trial, sub,1,1:num_freq) = NaN(1:num_freq)
   
                    end
                    trial_angles = all_imu_angles.(['A', subject_str]){trial}(:,1:3)*180/pi();
                    trial_time = (0:dt:length(trial_angles))';
                    % all_time.(['A', subject_str]){current,profile,config}(:,1) = all_imu_data.(['A', subject_str]){current,profile,config}(:,10);
                   
                    
                    [len, wid] = size(trial_angles);
                    

                    % make all trials only 12s
                    if len > 12*fs 
                        buffer = floor((len - 12*fs)/2);
                        trial_angles = trial_angles(buffer:len - buffer,:); % take middle 10s of long trials
                        trial_time_a = trial_time(buffer:len - buffer);
                        
                    % elseif len <12*fs
                    %      buffer = floor(abs((len - 12*fs)/2));
                    %      trial_angles = [trial_angles; NaN(2*buffer,wid)]; % buffer the end of short trials with NaN's
                    %      trial_time_a = [trial_time; NaN(2*buffer,1)];
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

                    [power_interest(trial, sub,1,1:num_freq),~] = periodogram(roll_ang,[],freq_interest,fs);
                    [power_interest(trial, sub,2,1:num_freq),~] = periodogram(pitch_ang,[],freq_interest,fs);
                    [power_interest(trial,  sub,3,1:num_freq),~] = periodogram(yaw_ang,[],freq_interest,fs);
                    [med_freq(trial, sub,:), med_power(trial, sub,:)]=medfreq(roll_ang,fs);
                    [mean_freq(trial,sub,:), mean_power(trial, sub,:)]=meanfreq(roll_ang,fs);

                    power_interest(trial, sub,:,1:num_freq) = log10(power_interest(trial, sub,:,1:num_freq))*10;

                    [len, wid] = size(trial_angles);
                    if len <12*fs+2
                         buffer = floor(abs((len - (12*fs+2))));
                         trial_angles = [trial_angles; NaN(buffer,wid)]; % buffer the end of short trials with NaN's
                         trial_time_a = [trial_time; NaN(buffer,1)];
                    end
                   
                    
                    if contains(Label.trial(trial),"Forhead")
                        All_Label.config(sub,trial) = 1;
                        all_trials_sort(index1, sub,:,:) = trial_angles';
                        power_interest_sort(index1, sub,:,:) = power_interest(trial, sub,:,1:num_freq);
                        All_Label.config_sort(sub,index1) = 1;
                        All_Label.trial_sort{sub,index1} = Label.trial(trial);
                        index1= index1+1;
                    elseif contains(Label.trial(trial),"Shoulder")
                        All_Label.config(sub,trial) = 2;
                        all_trials_sort(index2+10, sub,:,:) = trial_angles';
                        power_interest_sort(index2+10, sub,:,:) = power_interest(trial, sub,:,1:num_freq);
                        All_Label.config_sort(sub,10+index2) = 2;
                        All_Label.trial_sort{sub,index2+10} = Label.trial(trial);
                        index2= index2+1;
                    elseif contains(Label.trial(trial),"Neck")
                        All_Label.config(sub,trial) = 3;
                        all_trials_sort(index3+20, sub,:,:) = trial_angles';
                        power_interest_sort(index3+20, sub,:,:) = power_interest(trial, sub,:,1:num_freq);
                        All_Label.config_sort(sub,20+index3) = 3;
                        All_Label.trial_sort{sub,index3+20} = Label.trial(trial);
                        index3= index3+1;
                    end

        end
        All_Label.all_trials{sub,:}= Label.trial;

        for trial =1:2:w % compare imu metrics to verbal reporting metrics
            match_up = ceil(trial/2);
            % grab sway power for each trial in the match up
            power_1 = power_interest(trial, sub,2,10); % 2 is the pitch dir, 10 is the 0.5Hz freq
            power_2 = power_interest(trial+1, sub,2,10);

            sway_diff(match_up,sub) = (power_1 - power_2);

            if power_1 > power_2
                sway_win_index = 2;
            elseif power_2 >power_1
                sway_win_index = 3;
            end

            % determine whether trial 1 or 2 in the match up won the verbal
            % report for sway intensisty 
            
            verbal_win_index = all_match_ups{match_up,8}+1;
            
            if verbal_win_index ==2
                power_verbal_win(match_up, sub) = power_1;
                power_verbal_loss(match_up, sub) = power_2;

            elseif verbal_win_index ==3 
                power_verbal_win(match_up, sub) = power_2;
                power_verbal_loss(match_up, sub) = power_1;
            end
            

            if sway_win_index == verbal_win_index
                sway_verbal_congruent(match_up, sub) = 1;
                
            else
                sway_verbal_congruent(match_up, sub) = 0;
            end

        end
        
end

        [index_con] = find(sway_verbal_congruent);
        congruent_mean_sway_diff = mean(abs(sway_diff(index_con)),"all");
        congruent_sway_diff = sway_diff(index_con);
        [index_non] = find(sway_verbal_congruent-1);
        non_congruent_mean_sway_diff = mean(abs(sway_diff(index_non)),"all");
        non_congruent_sway_diff = sway_diff(index_non);
        non_congruent_sway_diff = [non_congruent_sway_diff ; NaN(length(congruent_sway_diff)-length(non_congruent_sway_diff),1)];

        % figure; boxplot([abs(congruent_sway_diff) abs(non_congruent_sway_diff)])
        % xticklabels(["Macthed Sway-Verbal (78)" "Conflicting Sway-Verbal (62)"])
        % ylabel("Diff in sway power dB deg^2 /Hz")
        % title("Comparison of Sway Magnitude and Verbal Reports")

        % figure;
        % boxplot([reshape(power_verbal_win,[],1) reshape(power_verbal_loss,[],1)])
        % xticklabels(["Sway for Verbal Wins" "Sway for Verbal Losses"])
        % ylabel("Sway power dB deg^2 /Hz")
        % title("Comparison of Sway Magnitude for Verbal win/loss")

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
        'freq_interest power_interest  med_freq mean_freq ' ...
        ' all_trials_sort power_interest_sort sway_diff sway_verbal_congruent'];% ...
        % ' EndImpedance StartImpedance MaxCurrent MinCurrent all_pos all_vel']; 
    eval(['  save ' ['Allimu.mat '] vars_2_save ' vars_2_save']); %save file     
    cd(code_path) %return to code directory
    %clear saved variables to prevent them from affecting next subjects' data
    eval (['clear ' vars_2_save]) 
