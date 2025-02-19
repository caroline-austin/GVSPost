%% Script 4b for Dynamic GVS +Tilt
% this script removes the first and last 1s of data from both shot and TTS
% motion data series. It also finds the time adjustment of the shot data
% (shifted forward) where the rms is minimized - this is calculated and
% then averaged across all trials (not just sham) then all trials have
% their shot data shifted forward by this amount

clc; clear; close all;

%% set up
subnum = [2078];  % Subject List 2049, 2051,2053:2049, 2051,2053:2059, 2060:2062, 2069:2074
numsub = length(subnum);
subskip = [2058 2069:2077 2070 2072 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
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

cd(code_path);
cd ..
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
        load(['S', subject_str, 'Extract' datatype '.mat']);
    elseif ispc
        load(['S', subject_str, 'Extract' datatype '.mat ']);
    end
    
    cd(code_path);

 % isolating the sham, non-GVS, trials:

    sham_shot_4A = startsWith(Label.shot_4A,'P_0');
    sham_tilt_4A = startsWith(Label.tilt_4A,'P_0');

    sham_shot_4B = startsWith(Label.shot_4B,'P_0');
    sham_tilt_4B = startsWith(Label.tilt_4B,'P_0');

    sham_shot_5A = startsWith(Label.shot_5A,'P_0');
    sham_tilt_5A = startsWith(Label.tilt_5A,'P_0');

    sham_shot_5B = startsWith(Label.shot_5B,'P_0');
    sham_tilt_5B = startsWith(Label.tilt_5B,'P_0');

    sham_shot_6A = startsWith(Label.shot_6A,'P_0');
    sham_tilt_6A = startsWith(Label.tilt_6A,'P_0');

    sham_shot_6B = startsWith(Label.shot_6B,'P_0');
    sham_tilt_6B = startsWith(Label.tilt_6B,'P_0');

    % calculate the avg. min time shift for each physical motion profile
    % this is not a computationally efficient way to do this, 
    % but it still runs pretty fast  
    if any(sham_shot_4A) == 1
        [avg_loc_rms_min_4A, avg_time_rms_min_4A] = find_time_shift(shot_4A(:,sham_shot_4A),tilt_4A(:,sham_tilt_4A));
    elseif any(sham_shot_4A) == 0
        avg_loc_rms_min_4A = NaN;
        avg_time_rms_min_4A = NaN;
    end

    if any(sham_shot_4B) == 1
        [avg_loc_rms_min_4B, avg_time_rms_min_4B] = find_time_shift(shot_4B(:,sham_shot_4B),tilt_4B(:,sham_tilt_4B));
    elseif any(sham_shot_4B) == 0
        avg_loc_rms_min_4B = NaN;
        avg_time_rms_min_4B = NaN;
    end

    if any(sham_shot_5A) == 1
        [avg_loc_rms_min_5A, avg_time_rms_min_5A] = find_time_shift(shot_5A(:,sham_shot_5A),tilt_5A(:,sham_tilt_5A));
    elseif any(sham_shot_5A) == 0
        avg_loc_rms_min_5A = NaN;
        avg_time_rms_min_5A = NaN;
    end

    if any(sham_shot_5B) == 1
        [avg_loc_rms_min_5B, avg_time_rms_min_5B] = find_time_shift(shot_5B(:,sham_shot_5B),tilt_5B(:,sham_tilt_5B));
    elseif any(sham_shot_5B) == 0
        avg_loc_rms_min_5B = NaN;
        avg_time_rms_min_5B = NaN;
    end

    if any(sham_shot_6A) == 1
        [avg_loc_rms_min_6A, avg_time_rms_min_6A] = find_time_shift(shot_6A(:,sham_shot_6A),tilt_6A(:,sham_tilt_6A));
    elseif any(sham_shot_6A) == 0
        avg_loc_rms_min_6A = NaN;
        avg_time_rms_min_6A = NaN;
    end

    if any(sham_shot_6B) == 1
        [avg_loc_rms_min_6B, avg_time_rms_min_6B] = find_time_shift(shot_6B(:,sham_shot_6B),tilt_6B(:,sham_tilt_6B));
    elseif any(sham_shot_6B) == 0
        avg_loc_rms_min_6B = NaN;
        avg_time_rms_min_6B = NaN;
    end

    %average the offsets from all trials
    avg_loc_rms_min_all = [avg_loc_rms_min_4A ,avg_loc_rms_min_4B, avg_loc_rms_min_5A ,avg_loc_rms_min_5B,avg_loc_rms_min_6A ,avg_loc_rms_min_6B];
    avg_loc_rms_min = round(mean(avg_loc_rms_min_all, 'omitnan'));
    avg_time_rms_min = mean([avg_time_rms_min_4A avg_time_rms_min_4B avg_time_rms_min_5A avg_time_rms_min_5B avg_time_rms_min_6A avg_time_rms_min_6B], 'omitnan');
    shot_start_avg = 51+avg_loc_rms_min;
    shot_end_avg = length(shot_4A)-50+avg_loc_rms_min;

    %cut off beginning and end 1s of trials and shift the shot response
    %data
    [shot_4A,tilt_4A,GVS_4A, predict_4A] = shift_file(shot_4A,tilt_4A,GVS_4A,predict_4A,shot_start_avg, shot_end_avg);
    [shot_4B,tilt_4B,GVS_4B, predict_4B] = shift_file(shot_4B,tilt_4B,GVS_4B,predict_4B,shot_start_avg, shot_end_avg);
    [shot_5A,tilt_5A,GVS_5A, predict_5A] = shift_file(shot_5A,tilt_5A,GVS_5A,predict_5A,shot_start_avg, shot_end_avg);
    [shot_5B,tilt_5B,GVS_5B, predict_5B] = shift_file(shot_5B,tilt_5B,GVS_5B,predict_5B,shot_start_avg, shot_end_avg);
    [shot_6A,tilt_6A,GVS_6A, predict_6A] = shift_file(shot_6A,tilt_6A,GVS_6A,predict_6A,shot_start_avg, shot_end_avg);
    [shot_6B,tilt_6B,GVS_6B, predict_6B] = shift_file(shot_6B,tilt_6B,GVS_6B,predict_6B,shot_start_avg, shot_end_avg);

    %redefine the end of the trial so that it can be properly used in other
    %scripts
    trial_end = length(shot_4A);
    time = time(1:trial_end);

    Time_shift_sub{sub}= avg_loc_rms_min_all;

%% save files
   cd(subject_path);
   vars_2_save = ['Label Trial_Info time trial_end shot_4A tilt_4A GVS_4A  ' ...
       ' shot_5A tilt_5A GVS_5A shot_6A tilt_6A GVS_6A shot_4B tilt_4B GVS_4B  ' ...
       'shot_5B tilt_5B GVS_5B shot_6B tilt_6B GVS_6B' ' avg_time_rms_min' ' avg_loc_rms_min' ...
       ' predict_4A predict_4B predict_5A predict_5B predict_6A predict_6B'];
   eval(['  save ' ['S', subject_str, 'Extract' datatype 'Time.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;


end
 mean_time_shift = mean(cell2mat(Time_shift_sub), 'omitnan');
 std_time_shift = std(cell2mat(Time_shift_sub), 'omitnan');
plotadj=1;
if plotadj == 1
    figure;
    hold on
    for i = 1:numsub
        subdata = Time_shift_sub{i}/50 -0.2; 
        boxplot(subdata, i, 'Positions',i)       
        scatter(i*ones(length(subdata),1),subdata)
    end
    hold off
    xlabel('Subject')
    ylabel('Trial Time Shifts')
    set(gca,'FontSize',12)
end

function [avg_loc_rms_min,avg_time_rms_min] = find_time_shift(shot,tilt)
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
    avg_time_rms_min = mean(min_rms);
end

function [shot,tilt, GVS,predict] = shift_file(shot,tilt,GVS,predict, start_index, end_index)
    tilt  = tilt(51:end-50, :);
    shot  = shot(start_index:end_index, :);
    GVS  = GVS(51:end-50, :);
    predict = predict(start_index:end_index, :);
end

