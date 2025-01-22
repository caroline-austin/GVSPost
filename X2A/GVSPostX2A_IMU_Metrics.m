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
subskip = [2001 2004 2008 2010];  %DNF'd subjects
fs =100; % sampling freq of 100Hz
profile_freq = [ 0 0 0.25 0.5 1];
freq_interest = [ 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.5 0.6 0.75 0.8 0.9 1 1.1 1.2 1.25];
num_freq = length(freq_interest);
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
                        mean_freq(current, profile, config,sub,:) = NaN();
                        mean_power(current, profile, config,sub,:) = NaN();
                        med_freq(current, profile, config,sub,:) = NaN();
                        med_power(current, profile, config,sub,:) = NaN();
                        power_interest(current, profile, config,sub,1:2,1:num_freq) = NaN(1, 2,num_freq);
                        % power_interest_pitch{current, profile, config}(sub,:) = NaN(1, 18);
                        mean_amp(current, profile, config,sub,:) =  NaN();
                        med_amp(current, profile, config,sub,:) =  NaN();
                        phase_shift(current, profile, config,sub,:) = NaN();
                        fit_freq(current, profile, config,sub,:) = NaN();
                        fit_amp(current, profile, config,sub,:) = NaN();
                        continue
                    end
                    trial_time = all_imu_data.(['A', subject_str]){current,profile,config}(:,10);
                    all_time.(['A', subject_str]){current,profile,config}(:,1) = all_imu_data.(['A', subject_str]){current,profile,config}(:,10);
                    trial_accel = all_imu_data.(['A', subject_str]){current,profile,config}(:,1:3);
                    trial_gyro = all_imu_data.(['A', subject_str]){current,profile,config}(:,4:6);
                    trial_eulers = all_imu_data.(['A', subject_str]){current,profile,config}(:,7:9);
                    [len, wid] = size(trial_eulers);

                    % make all trials only 10s
                    if len > 12*fs && (profile == 4 || profile == 3 || profile == 5 )
                        buffer = floor((len - 12*fs)/2);
                        trial_eulers = trial_eulers(buffer:len - buffer,:); % take middle 10s of long trials
                        trial_time_e = trial_time(buffer:len - buffer,:);

                    elseif len <12*fs
                         buffer = floor(abs((len - 12*fs)/2));
                         trial_eulers = [trial_eulers; NaN(2*buffer,wid)]; % buffer the end of short trials with NaN's
                         trial_time_e = [trial_time; NaN(2*buffer,wid)];
                    else 
                         trial_time_e = trial_time;
                    end
                       trial_eulers = unwrap(trial_eulers);
                    % if subject == 2004
                    %     neg_loc=find(trial_eulers < -70); % needs to be -70 for 2004 but -100 for every other sub to make roll and pitch look good
                    % trial_eulers(neg_loc) = trial_eulers(neg_loc)+360;
                    % else
                    %     neg_loc=find(trial_eulers < -100); % needs to be -70 for 2004 but -100 for every other sub to make roll and pitch look good
                    %     trial_eulers(neg_loc) = trial_eulers(neg_loc)+360;
                    % end
                    % 
                    bias = mean(trial_eulers);
                    trial_eulers = trial_eulers - bias; 
                    all_ang.(['A', subject_str]){current,profile,config} =  trial_eulers;

                    roll_ang = trial_eulers(:,3);
                    pitch_ang = trial_eulers(:,2);
                    yaw_ang = trial_eulers(:,1);

                    [power_interest(current, profile, config, sub,1,1:num_freq),~] = periodogram(roll_ang,[],freq_interest,fs);
                    [power_interest(current, profile, config, sub,2,1:num_freq),~] = periodogram(pitch_ang,[],freq_interest,fs);
                    [power_interest(current, profile, config, sub,3,1:num_freq),~] = periodogram(yaw_ang,[],freq_interest,fs);
                    [med_freq(current, profile, config,sub,:), med_power(current, profile, config, sub,:)]=medfreq(roll_ang,fs);
                    [mean_freq(current, profile, config,sub,:), mean_power(current, profile, config, sub,:)]=meanfreq(roll_ang,fs);

                    power_interest(current, profile, config, sub,:,1:num_freq) = log10(power_interest(current, profile, config, sub,:,1:num_freq))*10;
                    
                    mdl = fittype('a*sin(b*x+c)','indep','x');
                    fittedmdl1 = fit(trial_time_e,roll_ang,mdl,'start',[rand(),profile_freq(profile)*pi(),rand()]);
                    y_model = fittedmdl1(trial_time_e);
                  
                    phase_shift(current, profile, config,sub,:) = fittedmdl1.c;
                    fit_freq(current, profile, config, sub,:) = fittedmdl1.b;
                    fit_amp(current, profile, config, sub,:) = fittedmdl1.a;
                    
                    [val, loc]=findpeaks(abs(y_model));
                    amps = abs(diff(roll_ang (loc)))/2;
                    mean_amp(current, profile, config, sub,:) = mean(amps);
                    med_amp(current, profile, config, sub,:) = median(amps);

                    % %for visual checking
                    % subplot(3,1,config)
                    % plot(trial_time_e,roll_ang);
                    % hold on; plot(fittedmdl1);
                    % hold on;plot(trial_time_e(loc),roll_ang(loc))
                    % title(strjoin([subject_str "Profile:" Label.Config(config) Label.Profile(profile)  Label.CurrentAmp(current) " mA"]));
                                
                   angle_drift(current, profile, config, sub,1,:) = mean(roll_ang(fs*10:fs*10+10),'omitnan') - mean(roll_ang(1:10),'omitnan') ;
                   angle_drift(current, profile, config, sub,2,:) = mean(pitch_ang(fs*10:fs*10+10), 'omitnan') - mean(pitch_ang(1:10), 'omitnan') ;
                    if profile == 2 && config ==2 && subject == 2005 && current == 8
                        angle_drift(9, profile, config, sub,1,:) = mean(roll_ang(fs*10:fs*10+10),'omitnan') - mean(roll_ang(1:10),'omitnan') ;
                        angle_drift(9, profile, config, sub,2,:) = mean(pitch_ang(fs*10:fs*10+10), 'omitnan') - mean(pitch_ang(1:10), 'omitnan') ;

                    end

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

            rms_save(current, profile, config, sub,:) = rms_out;
            end
        end
    end

    [rms_save_reduced(:,:,:,sub,:)] = ReduceVarMultiple(rms_save,MinCurrent,MaxCurrent,Label,sub);
    [mean_power_reduced(:,:,:,sub,:)] = ReduceVarMultiple(mean_power,MinCurrent,MaxCurrent,Label,sub);
    [mean_freq_reduced(:,:,:,sub,:)] = ReduceVarMultiple(mean_freq,MinCurrent,MaxCurrent,Label,sub);
    [med_power_reduced(:,:,:,sub,:)] = ReduceVarMultiple(med_power,MinCurrent,MaxCurrent,Label,sub);
    [med_freq_reduced(:,:,:,sub,:)] = ReduceVarMultiple(med_freq,MinCurrent,MaxCurrent,Label,sub);
    [med_amp_reduced(:,:,:,sub,:)] = ReduceVarMultiple(med_amp,MinCurrent,MaxCurrent,Label,sub);
    [mean_amp_reduced(:,:,:,sub,:)] = ReduceVarMultiple(mean_amp,MinCurrent,MaxCurrent,Label,sub);
    [phase_shift_reduced(:,:,:,sub,:)] = ReduceVarMultiple(phase_shift,MinCurrent,MaxCurrent,Label,sub);
    [fit_freq_reduced(:,:,:,sub,:)] = ReduceVarMultiple(fit_freq,MinCurrent,MaxCurrent,Label,sub);
    [fit_amp_reduced(:,:,:,sub,:)] = ReduceVarMultiple(fit_amp,MinCurrent,MaxCurrent,Label,sub);
    [angle_drift_reduced(:,:,:,sub,:)] = ReduceVarMultiple(angle_drift,MinCurrent,MaxCurrent,Label,sub);

    [power_interest_reduced(:,:,:,sub,:,:)] = ReduceVarMultiple(power_interest,MinCurrent,MaxCurrent,Label,sub);

end
%%
Label.IMUmetrics = ["Current" "Profile" "Config" "Subject" "Direction" "VarIndex"];
Label.CurrentAmpReduced = ["Low" "Min" "Max"];



%% save data
    cd([file_path]); %move to directory where file will be saved
    %add all variables that we want to save to a list must include space
    %between variable names 
    vars_2_save =  ['Label all_imu_data rms_save all_imu_data  all_ang all_time ' ...
        'freq_interest power_interest  med_freq med_power mean_freq mean_power ' ...
        'phase_shift fit_freq fit_amp mean_amp med_amp rms_save_reduced' ...
        ' power_interest_reduced  med_freq_reduced med_power_reduced mean_freq_reduced mean_power_reduced ' ...
        'phase_shift_reduced fit_freq_reduced fit_amp_reduced mean_amp_reduced med_amp_reduced' ...
        ' angle_drift angle_drift_reduced'];% ...
        % ' EndImpedance StartImpedance MaxCurrent MinCurrent all_pos all_vel']; 
    eval(['  save ' ['Allimu.mat '] vars_2_save ' vars_2_save']); %save file     
    cd(code_path) %return to code directory
    %clear saved variables to prevent them from affecting next subjects' data
    eval (['clear ' vars_2_save]) 


    %%
function [Reduced_var] = ReduceVarMultiple(Var,MinCurrent,MaxCurrent,Label,sub_index)
%this function takes a previously generated map and reduces it so that the
%values recorded are only for the sham(0.1), low (min), and high(max)
%current amplitude conditions. 
% dim1 is current, dim2 is variable of interest,dim 3 electrode configuration,is dim 4 is profile

%get size of the original map and pre-allocate the reduced map
[dim1, dim3, dim4,~,~,~] = size(Var);
% Reduced_var = zeros(3,dim3,dim4);
for index_1 = 1:dim1
for outer = 1: dim4  %cycle through the different electrode configurations
    for inner = 1:dim3 %cycle through the different profiles
        %find locations where a response is recorded 
        % test = Var{:,inner,outer}(sub_index,:);
        [row,col] = find(Var(index_1,inner,outer,sub_index,:,:));

        num_trials = length(row); %number of responses
        %initialize checking variables
        check_low = 0;
        check_min = 0;
        check_max = 0;
        for k = 1:num_trials %cycle through all identified responses
            if Label.CurrentAmp(index_1) == 0.1 %for sham condition
                Reduced_var(1, inner, outer,1,:,:) = Var(index_1,inner, outer,sub_index,:,:);
                check_low = 1;
            elseif Label.CurrentAmp(index_1) == MinCurrent{outer} %for low current condition
                Reduced_var(2, inner, outer,1,:,:) = Var(index_1, inner, outer,sub_index,:,:);
                check_min = 1;
            elseif Label.CurrentAmp(index_1) == MaxCurrent{outer} %for high current conditions 
                Reduced_var(3, inner, outer,1,:,:) = Var(index_1, inner, outer,sub_index,:,:);
                check_max = 1;
                %below is meant to handle a couple of trials where the
                %current provided in a part 2 trial was less than the
                %predetermined max while still meant to represent the max
                %report
            elseif Label.CurrentAmp(index_1) <= MaxCurrent{outer} && Label.CurrentAmp(index_1) >= MinCurrent{outer} && inner ~= 4 %not 0.5hz profile
                Reduced_var(3, inner, outer,1,:,:) = Var(index_1, inner, outer,sub_index,:,:);
                check_max = 1;
            end
        end

    end
end
end

end