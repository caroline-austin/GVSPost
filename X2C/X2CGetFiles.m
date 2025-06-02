% Created by: Caroline Austin 2/6/24
% Script 1 of X2B data processing 
% This script reads in the excel data for each subject in experiment 2B and
% processes all of the IMU data to turn the csv files into nicely labeled
% .mat files

close all; 
clear all; 
clc; 


%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory % select data folder
plots_path = [file_path '/Plots']; % specify where plots are saved
cd(code_path); cd .. ;
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = [2044:2052 2063:2065];  % Subject List 
numsub = length(subnum);
subskip = [2049 2051 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

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
    Label.TrialInfo = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','A1:O1');
    Label.MainResultsCol = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','B33:E33');
    Label.MainResultsRow = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','A34:A35');
    main_results = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','B34:E35');
    Label.Impedance = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','Q5:Q14');
    start_impedance = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','R5:R14');
    end_impedance = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','S5:S14');

    if subject_str == "2044"
        % small mistake in the run order meant we had to redo one of the
        % trials at the end
        main_match_ups = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','A3:O31');    
        main_match_ups = main_match_ups([1:25, 27:29],:);
    else
        main_match_ups = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','A3:O30');
    end

    total_motion_wins_3 = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','B34:B34');
    total_tingle_wins_3 = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','C34:C34');
    total_motion_wins_4 = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','B35:B35');
    total_tingle_wins_4 = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','C35:C35');

    total_mettalic_wins_3 = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','D34:D34');
    total_visual_wins_3 = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','E34:E34');
    total_metallic_wins_4 = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','D35:D35');
    total_visual_wins_4 = readcell('NewPitchMontage.xlsx','Sheet',['S' subject_str],'Range','E35:E35');
    
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
            trial_col = 2+rem(trial+1,2); % the column changes based on the first v. second trial in the set
            montage_col = 2+rem(trial+1,2)*2; % the column changes based on the first v. second trial in the set
            current_col = 3+rem(trial+1,2)*2; % the column changes based on the first v. second trial in the set
            %
            cd([file_path, '/' , subject_str, '/IMU']);
            imu_table = readtable(IMU_files{file});
            imu_data = table2array(imu_table(:,3:11));
            

    % assemble save file name - use Label.TrialInfo to map what the columns
    % are

        % assemble save file name - use Label.TrialInfo to map what the columns
    % are
        if trial <10
            imu_filename = strrep(strrep(['S' subject_str '_' main_match_ups{trial_row,montage_col} '_' num2str(main_match_ups{trial_row,current_col}) main_match_ups{trial_row,6} '_' main_match_ups{trial_row,7} num2str(main_match_ups{trial_row,8}) 'Hz_0'  num2str(trial)], '.', '_'), ' ', '_');
            % imu_filename = strrep(strrep(['S' subject_str '_' main_match_ups{trial_row,trial_col} '_' num2str(main_match_ups{trial_row,4}) main_match_ups{trial_row,5} '_' main_match_ups{trial_row,6} num2str(main_match_ups{trial_row,7}) 'Hz_0' num2str(trial)], '.', '_'), ' ', '_');
        elseif trial<60
            imu_filename = strrep(strrep(['S' subject_str '_' main_match_ups{trial_row,montage_col} '_' num2str(main_match_ups{trial_row,current_col}) main_match_ups{trial_row,6} '_' main_match_ups{trial_row,7} num2str(main_match_ups{trial_row,8}) 'Hz_' num2str(trial)], '.', '_'), ' ', '_');
            % imu_filename = strrep(strrep(['S' subject_str '_' main_match_ups{trial_row,trial_col} '_' num2str(main_match_ups{trial_row,4}) main_match_ups{trial_row,5} '_' main_match_ups{trial_row,6} num2str(main_match_ups{trial_row,7}) 'Hz_' num2str(trial)], '.', '_'), ' ', '_');
        end
        % 
        % if main_match_ups{trial_row,1} > 0.1
        %     imu_filename = strrep(strrep(['S' subject_str '_' main_match_ups{trial_row,montage_col} '_' num2str(main_match_ups{trial_row,current_col}) main_match_ups{trial_row,6} '_' main_match_ups{trial_row,7} num2str(main_match_ups{trial_row,8}) 'Hz_' num2str(main_match_ups{trial_row,1})], '.', '_'), ' ', '_');
        % else
        %     % if the trial number (which is stored in the variable being
        %     % checked is =0 then that means the row should be skipped for
        %     % data analysis so increment beyond it) this code shouldn't be
        %     % needed
        %     trial = trial +1;
        %     trial_row = ceil(trial/2); % the row increments every other because two trials per row
        %     montage_col = 2+rem(trial,2)*2; % the column changes based on the first v. second trial in the set
        %     current_col = 3+rem(trial,2)*2; % the column changes based on the first v. second trial in the set
        %     imu_filename = strrep(strrep(['S' subject_str '_' main_match_ups{trial_row,montage_col} '_' num2str(main_match_ups{trial_row,current_col}) main_match_ups{trial_row,6} '_' main_match_ups{trial_row,7} num2str(main_match_ups{trial_row,8}) 'Hz_' num2str(main_match_ups{trial_row,1})], '.', '_'), ' ', '_');
        % 
        % end

        % save file

        cd([file_path, '/' , subject_str, '/IMU']);
        vars_2_save = ['imu_data imu_table'];
        eval(strjoin(['  save ' strjoin([imu_filename ".mat "],'') vars_2_save  '  vars_2_save']));     
        cd(code_path);
        
    end

    cd([file_path, '/' , subject_str]);
    vars_2_save = ['Label main_match_ups main_results start_impedance end_impedance ' ...
        'total_motion_wins_3 total_motion_wins_4 total_tingle_wins_3 total_tingle_wins_4'];
    eval(strjoin(['  save ' strjoin(['S' subject_str ".mat "],'') vars_2_save  '  vars_2_save']));     
    cd(code_path);

end