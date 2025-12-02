% Created by: Caroline Austin 11/19/25
% Script 1a of X2D+ data processing 
% This script reads in the excel data for each subject in experiment 2B and
% processes all of the IMU data to turn the csv files into nicely labeled
% .mat files

close all; 
clear all; 
clc; 


%% 
subnum = [2049, 2051,2053:2057, 2061:2062, 2078:2090];  % Subject List 2049, 2051,2053:2062
numsub = length(subnum);
subskip = [2058 2059 2060 2069:2077 2083 2085 2086 2070 2072 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory % select data folder
plots_path = [file_path '/Plots']; % specify where plots are saved
cd(code_path); cd .. ;
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

%%
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
        subject_path = [file_path '/' subject_str];
    
    % pull info from the Excel Sheet  
    cd(file_path);
    Label.IMUTrialInfo = readcell('PitchDynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str],'Range','P1:X1'); 
    if subject < 2062
        IMUTrialInfo = readcell('PitchDynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str],'Range','P2:X4');
    elseif subject == 2062
        IMUTrialInfo = readcell('PitchDynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str],'Range','Q2:Y4');
    elseif subject >2062
        IMUTrialInfo = readcell('PitchDynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str],'Range','P2:X6');
    end

    
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
            trial_row = trial; 
            trial_col = 1; 
            montage_col = 2; 
            current_col = 3; 
            freq_col = 5;
            %
            cd([file_path, '/' , subject_str, '/IMU']);
            imu_table = readtable(IMU_files{file});
            imu_data = table2array(imu_table(:,3:11));
            data_info = IMUTrialInfo(trial,:);
            info_label = Label.IMUTrialInfo;
            

    % assemble save file name - use Label.TrialInfo to map what the columns
    % are

        imu_filename = strrep(strrep(['S' subject_str '_Shoulders_' num2str(IMUTrialInfo{trial_row,current_col}) 'mA_sin_'  num2str(IMUTrialInfo{trial_row,freq_col}) 'Hz_0'  num2str(trial)], '.', '_'), ' ', '_');
           

        % save file

        cd([file_path, '/' , subject_str, '/IMU']);
        % writetable(imu_table, strjoin([imu_filename ".csv"],''));
        vars_2_save = ['imu_data imu_table data_info info_label'];
        eval(strjoin(['  save ' strjoin([imu_filename ".mat "],'') vars_2_save  '  vars_2_save']));     
        cd(code_path);
        
    end

    % cd([file_path, '/' , subject_str]);
    % vars_2_save = ['Label main_match_ups main_results start_impedance end_impedance ' ...
    %     'total_motion_wins_3 total_motion_wins_4 total_tingle_wins_3 total_tingle_wins_4'];
    % eval(strjoin(['  save ' strjoin(['S' subject_str ".mat "],'') vars_2_save  '  vars_2_save']));     
    % cd(code_path);

end