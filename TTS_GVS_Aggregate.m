%% Script 6 for Dynamic GVS +Tilt
% this script averages together the data from all specified subjects, if a
% trial does not exist for a subject it is not averaged in. 
% the script can take input from scripts 2 and 4 and output should be used
% for scripts 7 

close all; 
clear all; 
clc; 
%% set up
subnum = 1015:1015;  % Subject List 
numsub = length(subnum);
subskip = [1006 1007 1008 1009 1010 1013 40006];  %DNF'd subjects or subjects that didn't complete this part
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
datatype = 'BiasTime';

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

%initalize all shot variables 
% tot_num = 0;
All_shot_4A = zeros(1527,length(match_list)); %1527 is the length of the non-adjusted time series 
if contains(datatype, 'Time')
    All_shot_4A = zeros(1427,length(match_list)); %1427 is the length of the time-adjusted time series
end
All_shot_4B = All_shot_4A;
All_shot_5A = All_shot_4A;
All_shot_5B = All_shot_4A;
All_shot_6A = All_shot_4A;
All_shot_6B = All_shot_4A;
num_trials_4A = zeros(1, length(match_list));
num_trials_4B = num_trials_4A;
num_trials_5A = num_trials_4A;
num_trials_5B = num_trials_4A;
num_trials_6A = num_trials_4A;
num_trials_6B = num_trials_4A;

%add in the data for each subject while keeping track of how many trials
%are averaged in
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    %keep track of the number of subjects that get used 
%     tot_num = tot_num+1;   

    %load subject file
    subject_path = [file_path, '\' , subject_str];
%     subject_path = [file_path, '\PS' , subject_str];
    cd(subject_path);
    load(['S', subject_str, 'Group' datatype '.mat ']);
    cd(code_path);

    % add the current subject's data into the aggregate variable
    %and increment the number of trials averaged into each trial type based on
    %the trial data available for the current subject
    for i = 1:length(Label.shot_4A)
        for j = 1:length(match_list)
            if contains(Label.shot_4A(i), match_list(j))
                All_shot_4A(:,j) = All_shot_4A(:,j)+shot_4A(:,i);
                num_trials_4A(j) = num_trials_4A(j)+1;
            end
        end
    end
    for i = 1:length(Label.shot_4B)
        for j = 1:length(match_list)
            if contains(Label.shot_4B(i), match_list(j))
                All_shot_4B(:,j) = All_shot_4B(:,j)+shot_4B(:,i);
                num_trials_4B(j) = num_trials_4B(j)+1;
            end
        end
    end
    for i = 1:length(Label.shot_5A)
        for j = 1:length(match_list)
            if contains(Label.shot_5A(i), match_list(j))
                All_shot_5A(:,j) = All_shot_5A(:,j)+shot_5A(:,i);
                num_trials_5A(j) = num_trials_5A(j)+1;
            end
        end
    end
    for i = 1:length(Label.shot_5B)
        for j = 1:length(match_list)
            if contains(Label.shot_5B(i), match_list(j))
                All_shot_5B(:,j) = All_shot_5B(:,j)+shot_5B(:,i);
                num_trials_5B(j) = num_trials_5B(j)+1;
            end
        end
    end
    for i = 1:length(Label.shot_6A)
        for j = 1:length(match_list)
            if contains(Label.shot_6A(i), match_list(j))
                All_shot_6A(:,j) = All_shot_6A(:,j)+shot_6A(:,i);
                num_trials_6A(j) = num_trials_6A(j)+1;
            end
        end
    end
    for i = 1:length(Label.shot_6B)
        for j = 1:length(match_list)
            if contains(Label.shot_6B(i), match_list(j))
                All_shot_6B(:,j) = All_shot_6B(:,j)+shot_6B(:,i);
                num_trials_6B(j) = num_trials_6B(j)+1;
            end
        end
    end

end
%divide the aggregate report by the number of trials added into it to get
%the average report across subjects (need to add a calculation of error)
All_shot_4A = All_shot_4A./num_trials_4A;
All_shot_4B = All_shot_4B./num_trials_4B;
All_shot_5A = All_shot_5A./num_trials_5A;
All_shot_5B = All_shot_5B./num_trials_5B;
All_shot_6A = All_shot_6A./num_trials_6A;
All_shot_6B = All_shot_6B./num_trials_6B;

%update the label
Label.shot_4A = match_list;
Label.shot_4B = match_list;
Label.shot_5A = match_list;
Label.shot_5B = match_list;
Label.shot_6A = match_list;
Label.shot_6B = match_list;

%% save files
   cd(file_path);
   vars_2_save = ['Label Trial_Info trial_end time All_shot_4A tilt_4A GVS_4A ' ... 
       'All_shot_5A tilt_5A GVS_5A All_shot_6A tilt_6A GVS_6A ' ...
       'All_shot_4B tilt_4B GVS_4B  All_shot_5B tilt_5B GVS_5B All_shot_6B tilt_6B GVS_6B'];
   eval(['  save ' ['PS' 'All' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])