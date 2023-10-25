%% Script 4a for Dynamic GVS +Tilt
% this script calculates and applies a L/R bias adjustment to the data
% based on the average reported values for the sham trials compared to the
% average acutal motion values for those same sham trials. A single 
% bias value is calulated and applied for each subject.
% it can read in data from script 2 or the other 4 scripts and can be used
% in the 3, 4, and 5 scripts. 
close all; 
clear; 
clc; 

%% set up
subnum = 1011:1022;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = ''; %can change this to specify which data you want to use for the checkng
% '' = regular , 'Time' = time adjusted, 'Adj' = Bias adjusted (can stack
% multiple)

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots']; % specify where plots are saved
elseif ispc
    plots_path = [file_path '\Plots']; % specify where plots are saved
end

if ismac || isunix
    gvs_path = [file_path '/GVSProfiles'];
elseif ispc
    gvs_path = [file_path '\GVSProfiles'];
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

%% calculate and apply bias adjustment
%for each subject
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
    %load in un-adjusted subject data
    cd(subject_path);
    if ismac || isunix
        load(['S', subject_str, 'Group' datatype '.mat']);
    elseif ispc
        load(['S', subject_str, 'Group' datatype '.mat ']);
    end
        
    %calculate bias for all trials
    bias_4A=calc_bias(tilt_4A, shot_4A);
    bias_4B=calc_bias(tilt_4B, shot_4B);
    bias_5A=calc_bias(tilt_5A, shot_5A);
    bias_5B=calc_bias(tilt_5B, shot_5B);
    bias_6A=calc_bias(tilt_6A, shot_6A);
    bias_6B=calc_bias(tilt_6B, shot_6B);
         
        %find the indexes for the sham trials and then use the indices to
        %to add together all of the biases across all sham trials,
        %calculate the number of sham trials and divide the sum by the
        %number of trials to get an average bias value. 
        bias_correction = 0;
        sham_indices_4A = find(contains(Label.shot_4A, '0_00mA'));
        for j = 1:length(sham_indices_4A)
            bias_correction = bias_correction + bias_4A(sham_indices_4A(j));
        end
        sham_indices_4B = find(contains(Label.shot_4B, '0_00mA'));
        for j = 1:length(sham_indices_4B)
            bias_correction = bias_correction + bias_4B(sham_indices_4B(j));
        end
        sham_indices_5A = find(contains(Label.shot_5A, '0_00mA'));
        for j = 1:length(sham_indices_5A)
            bias_correction = bias_correction + bias_5A(sham_indices_5A(j));
        end
        sham_indices_5B = find(contains(Label.shot_5B, '0_00mA'));
        for j = 1:length(sham_indices_5B)
            bias_correction = bias_correction + bias_5B(sham_indices_5B(j));
        end
        sham_indices_6A = find(contains(Label.shot_6A, '0_00mA'));
        for j = 1:length(sham_indices_6A)
            bias_correction = bias_correction + bias_6A(sham_indices_6A(j));
        end
        sham_indices_6B = find(contains(Label.shot_6B, '0_00mA'));
        for j = 1:length(sham_indices_6B)
            bias_correction = bias_correction + bias_6B(sham_indices_6B(j));
        end
        num_sham_trials = length(sham_indices_4A) + length(sham_indices_4B)+ ...
            length(sham_indices_5A)+length(sham_indices_5B) + ... 
            length(sham_indices_6A)+length(sham_indices_6B);

        bias_correction = bias_correction/ num_sham_trials;

        %apply the bias correction to all trials
        shot_4A = shot_4A + bias_correction;
        shot_4B = shot_4B + bias_correction;
        shot_5A = shot_5A + bias_correction;
        shot_5B = shot_5B + bias_correction;
        shot_6A = shot_6A + bias_correction;
        shot_6B = shot_6B + bias_correction;


%% save files
   cd(subject_path);
   vars_2_save = ['Label Trial_Info time trial_end shot_4A tilt_4A GVS_4A  ' ...
       ' shot_5A tilt_5A GVS_5A shot_6A tilt_6A GVS_6A shot_4B tilt_4B GVS_4B  ' ...
       'shot_5B tilt_5B GVS_5B shot_6B tilt_6B GVS_6B' ' bias_correction'];
   eval(['  save ' ['S', subject_str, 'Group' datatype 'Bias.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;


end

function bias=calc_bias(motion, report)
        %find average for each signal
        motion_avg = mean(motion,"omitnan"); 
        report_avg = mean(report, "omitnan"); 
        index = 1;
        %only need the average of the TTS actual 
        for i = 1:length(motion_avg)
            if ~ rem(i+2,3)
            actual_avg(:,index) = motion_avg(:,i);
            index = index+1;
            end
        end
        % calculate the difference between averages to generate bias
        bias = actual_avg-report_avg;
end