%% Script 4c for Dynamic GVS + Tilt
% Code to adjust individual gain. More description to come!

clc; clear; close all; %warning off;

%% set up
subnum = 1011:1022;  % Subject List 
numsub = length(subnum);
subskip = [1013 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'BiasTime';

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

    %load the subjects file that is grouped by profile and possibly
    %adjusted 
    cd(subject_path);
    if ismac || isunix
        load(['S', subject_str, 'Group' datatype '.mat']);
    elseif ispc
        load(['S', subject_str, 'Group' datatype '.mat ']);
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

    % calculate the avg. min gain shift for each physical motion profile
    % this is not a computationally efficient way to do this, 
    % but it still runs pretty fast 
    if any(sham_shot_4A) == 1
        avg_gain_4A = find_gain(shot_4A(:,sham_shot_4A),tilt_4A(:,sham_tilt_4A));
    elseif any(sham_shot_4A) == 0
        avg_gain_4A = NaN;
    end

    if any(sham_shot_4B) == 1
        avg_gain_4B = find_gain(shot_4B(:,sham_shot_4B),tilt_4B(:,sham_tilt_4B));
    elseif any(sham_shot_4B) == 0
        avg_gain_4B = NaN;
    end

    if any(sham_shot_5A) == 1
        avg_gain_5A = find_gain(shot_5A(:,sham_shot_5A),tilt_5A(:,sham_tilt_5A));
    elseif any(sham_shot_5A) == 0
        avg_gain_5A = NaN;
    end

    if any(sham_shot_5B) == 1
        avg_gain_5B = find_gain(shot_5B(:,sham_shot_5B),tilt_5B(:,sham_tilt_5B));
    elseif any(sham_shot_5B) == 0
        avg_gain_5B = NaN;
    end

    if any(sham_shot_6A) == 1
        avg_gain_6A = find_gain(shot_6A(:,sham_shot_6A),tilt_6A(:,sham_tilt_6A));
    elseif any(sham_shot_6A) == 0
        avg_gain_6A = NaN;
    end

    if any(sham_shot_6B) == 1
        avg_gain_6B = find_gain(shot_6B(:,sham_shot_6B),tilt_6B(:,sham_tilt_6B));
    elseif any(sham_shot_6B) == 0
        avg_gain_6B = NaN;
    end

    %average the offsets from all trials 
    %avg_gain_rms_min = round((avg_gain_rms_min_4A + avg_gain_rms_min_4B + avg_gain_rms_min_5A + avg_gain_rms_min_5B + avg_gain_rms_min_6A + avg_gain_rms_min_6B)/6);
    avg_gain = mean([avg_gain_4A  avg_gain_4B  avg_gain_5A  avg_gain_5B  avg_gain_6A  avg_gain_6B], "omitnan");
%     shot_start_avg = 51 + avg_gain_rms_min;
%     shot_end_avg = length(shot_4A)-50+avg_gain_rms_min;

    % Multiply each trial by the avgerage gain value:

    [shot_4A] = mult_gain(shot_4A,avg_gain);
    [shot_4B] = mult_gain(shot_4B,avg_gain);

    [shot_5A] = mult_gain(shot_5A,avg_gain);
    [shot_5B] = mult_gain(shot_5B,avg_gain);

    [shot_6A] = mult_gain(shot_6A,avg_gain);
    [shot_6B] = mult_gain(shot_6B,avg_gain);

    %redefine the end of the trial so that it can be properly used in other
    %scripts
%     trial_end = length(shot_4A);

%% save files
   cd(subject_path);
   vars_2_save = ['Label Trial_Info time trial_end shot_4A tilt_4A GVS_4A  ' ...
       ' shot_5A tilt_5A GVS_5A shot_6A tilt_6A GVS_6A shot_4B tilt_4B GVS_4B  ' ...
       'shot_5B tilt_5B GVS_5B shot_6B tilt_6B GVS_6B' ...
       ' avg_gain'];
   eval(['  save ' ['S', subject_str, 'Group' datatype 'Gain.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
%    eval (['clear ' vars_2_save])
   close all;

end

function avg_gain = find_gain(shot,tilt)
<<<<<<<< Updated upstream:TTS_GVS_GainAdjust_Aaron.m
    
    [l,trials] = size(shot);

    gain_select = zeros(trials,1);
    for k = 1:trials
        G = 0.01:0.01:4; % Gains for search
        Cost = zeros(length(G),1);

        for g = 1:length(G)
            tti = (k-1)*3+1; % tilt trial index 
            pred = tilt(:,tti)/G(g);
            
            se = (shot(:,k)-pred)'*(shot(:,k)-pred);
            Cost(g) = 1/l*(se);
        end

        [~,ind] = min(Cost);
        gain_select(k) = G(ind);
    end
    avg_gain = mean(gain_select);
========

    [num_timesteps,num_trials] = size(shot);
    for trial = 1:num_trials
        %adjust tilt index becaue each trial has 3 columns of data
        tilt_index = (trial-1)*3+1;
        gvec = 0:0.01:2;
        for gain_shift = 1:length(gvec)
            %calculate and save the error between the actual motion profile and the
            %shot response 
            signal_diff =  tilt(:,tilt_index) - shot(:,trial)*(gvec(gain_shift));
            gain_rms(gain_shift,trial) = rms(signal_diff,'omitnan'); 
        end
    end 
    %find the location where error is least for each trial and then average
    %the location for all the trials in the current profile set (currently
    %taking the median not the mean to help account for potential outliers)
    [min_rms,~]=min(gain_rms);
    [min_rms_loc, ~] = find(gain_rms == min_rms);
    gain_select = gvec(min_rms_loc);
    avg_gain = mean(gain_select); % could use the mean instead 

>>>>>>>> Stashed changes:archived/TTS_GVS_GainAdjust_Final.m
end

function [shot] = mult_gain(shot,avg_gain)
    shot = shot*avg_gain;
end