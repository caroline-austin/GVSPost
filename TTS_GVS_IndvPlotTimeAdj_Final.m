%% Script 4b for Dynamic GVS +Tilt
% this script removes the first and last 1s of data from both shot and TTS
% motion data series. It also finds the time adjustment of the shot data
% (shifted forward) where the rms is minimized - this is calculated and
% then averaged across all trials (not just sham) then all trials have
% their shot data shifted forward by this amount
close all; 
clear; 
clc; 
%% set up
subnum = 1018:1021;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'Bias';

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

%% time adjust for each subject
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    if ismac || isunix
        subject_path = [file_path, '/' , subject_str];
    elseif ispc
        subject_path = [file_path, '\' , subject_str];
    end

%     subject_path = [file_path, '\PS' , subject_str];

    %load the subjects file that is grouped by profile and possibly
    %adjusted 
    cd(subject_path);
    if ismac || isunix
        load(['S', subject_str, 'Group' datatype '.mat']);
    elseif ispc
        load(['S', subject_str, 'Group' datatype '.mat ']);
    end
    
    cd(code_path);
    % calculate the avg. min time shift for each physical motion profile
    % this is not a computationally efficient way to do this, 
    % but it still runs pretty fast 
    avg_loc_rms_min_4A = find_time_shift(shot_4A,tilt_4A);
    avg_loc_rms_min_4B = find_time_shift(shot_4B,tilt_4B);
    avg_loc_rms_min_5A = find_time_shift(shot_5A,tilt_5A);
    avg_loc_rms_min_5B = find_time_shift(shot_5B,tilt_5B);
    avg_loc_rms_min_6A = find_time_shift(shot_6A,tilt_6A);
    avg_loc_rms_min_6B = find_time_shift(shot_6B,tilt_6B);

    %average the offsets from all trials 
    avg_loc_rms_min = round((avg_loc_rms_min_4A +avg_loc_rms_min_4B+ avg_loc_rms_min_5A +avg_loc_rms_min_5B+avg_loc_rms_min_6A +avg_loc_rms_min_6B)/6);
    shot_start_avg = 51+avg_loc_rms_min;
    shot_end_avg = length(shot_4A)-50+avg_loc_rms_min;

    %cut off beginning and end 1s of trials and shift the shot response
    %data
    [shot_4A,tilt_4A] = shift_file(shot_4A,tilt_4A,shot_start_avg, shot_end_avg);
    [shot_4B,tilt_4B] = shift_file(shot_4B,tilt_4B,shot_start_avg, shot_end_avg);
    [shot_5A,tilt_5A] = shift_file(shot_5A,tilt_5A,shot_start_avg, shot_end_avg);
    [shot_5B,tilt_5B] = shift_file(shot_5B,tilt_5B,shot_start_avg, shot_end_avg);
    [shot_6A,tilt_6A] = shift_file(shot_6A,tilt_6A,shot_start_avg, shot_end_avg);
    [shot_6B,tilt_6B] = shift_file(shot_6B,tilt_6B,shot_start_avg, shot_end_avg);

    %redefine the end of the trial so that it can be properly used in other
    %scripts
    trial_end = length(shot_4A);

%% save files
   cd(subject_path);
   vars_2_save = ['Label Trial_Info time trial_end shot_4A tilt_4A GVS_4A  ' ...
       ' shot_5A tilt_5A GVS_5A shot_6A tilt_6A GVS_6A shot_4B tilt_4B GVS_4B  ' ...
       'shot_5B tilt_5B GVS_5B shot_6B tilt_6B GVS_6B'];
   eval(['  save ' ['S', subject_str, 'Group' datatype 'Time.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;


end

function avg_loc_rms_min = find_time_shift(shot,tilt)
    [num_timesteps,num_trials] = size(shot);
    % 
    for trial = 1:num_trials
        %adjust tilt index becaue each trial has 3 columns of data
        tilt_index = (trial-1)*3+1;
        for time_shift = 0:50
            % setup the shifting indices
            shot_start = 51+time_shift;
            shot_end = num_timesteps-50+time_shift;
            tilt_end = num_timesteps -50;
            %calculate and save the error between the actual motion profile and the
            %shot response 
            signal_diff = tilt(51:tilt_end,tilt_index)- shot(shot_start:shot_end,trial);
            time_rms(time_shift+1,trial) = rms(signal_diff);
        end
    end 
    %find the location where error is least for each trial and then average
    %the location for all the trials in the current profile set (currently
    %taking the median not the mean to help account for potential outliers)
    [min_rms,loc_min_rms]=min(time_rms);
    avg_loc_rms_min = median(loc_min_rms); % could use the mean instead 
end

function [shot,tilt] = shift_file(shot,tilt,start_index, end_index)
    tilt  = tilt(51:end-50, :);
    shot  = shot(start_index:end_index, :);
end
