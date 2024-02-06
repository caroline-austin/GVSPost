% Created by: Caroline Austin 2/6/24
% Script 1 of X2B data processing 
% This script reads in the files for each subject in experiment 2B 

close all; 
clear all; 
clc; 


%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory % select data folder
plots_path = [file_path '/Plots']; % specify where plots are saved
cd(code_path); cd .. ;
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 2034:2035;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

%%
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    
    
    % pull info from the Excel Sheet  
    cd(file_path);
    Label.TrialInfo = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','A1:N1');
    main_match_ups = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','A3:N14');
    Label.MainResultsCol = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','B22:C22');
    Label.MainResultsRow = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','A23:A25');
    main_results = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','B23:C25');
    Label.Impedance = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','P5:P14');
    start_impedance = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','Q5:Q14');
    end_impedance = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','R5:R14');

    if subject_str == "2034"
        % issues with Sparky meant we had to flip the order of the final
        % match ups for S2034 (because we re-ran first set again)
        final_match_ups = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','A34:N35'); 
        best_motion =  readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','035:035');        
    else
        final_match_ups = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','A33:N34');
        best_motion =  readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','033:033');
    end
    best_tingling = readcell('NewPitchMontage3Electrodes.xlsx','Sheet',['S' subject_str],'Range','P34:P34');
    
    
    % find IMU data
    cd(code_path); cd ..;
    [IMU_files]=file_path_info2(code_path, [file_path, '/' , subject_str, '/IMU']); % get foldernames from file folder

    %save individual .mat IMU files
    trial = 0;
    for file = 1:length(IMU_files)
        %index through the csv files
        if ~contains(IMU_files(file), '.csv')
            continue
        end
            % create appropriate indexing variables
            trial = trial+ 1; % only keep track of trials
            trial_row = ceil(trial/2); % the row increments every other because two trials per row
            trial_col = 2+rem(trial,2); % the column changes based on the first v. second trial in the set
            %
            cd([file_path, '/' , subject_str, '/IMU']);
            IMU_data = readtable(IMU_files{file});

    % assemble save file name - use Label.TrialInfo to map what the columns
    % are
        if trial <25
            imu_filename = strrep(strrep(['S' subject_str '_' main_match_ups{trial_row,trial_col} '_' num2str(main_match_ups{trial_row,4}) main_match_ups{trial_row,5} '_' main_match_ups{trial_row,6} num2str(main_match_ups{trial_row,7}) 'Hz_' num2str(trial)], '.', '_'), ' ', '_');
        else
            imu_filename = strrep(strrep(['S' subject_str '_' final_match_ups{trial_row-12,trial_col} '_' num2str(final_match_ups{trial_row-12,4}) final_match_ups{trial_row-12,5} '_' final_match_ups{trial_row-12,6} num2str(final_match_ups{trial_row-12,7}) 'Hz_' num2str(trial)], '.', '_'), ' ', '_');
        end
        % save file

        cd([file_path, '/' , subject_str, '/IMU']);
        vars_2_save = ['IMU_data '];
        eval(strjoin(['  save ' strjoin([imu_filename ".mat "],'') vars_2_save  '  vars_2_save']));     
        cd(code_path);
        
    end

    cd([file_path, '/' , subject_str]);
    vars_2_save = ['Label main_match_ups main_results final_match_ups best_tingling best_motion start_impedance end_impedance'];
    eval(strjoin(['  save ' strjoin([subject_str ".mat "],'') vars_2_save  '  vars_2_save']));     
    cd(code_path);

end