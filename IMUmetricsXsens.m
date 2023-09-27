close all;clear;clc;
%% set up
subnum = 1017:1021;  % Subject List 
numsub = length(subnum);
subskip = [0,0];  %DNF'd subjects or subjects that didn't complete this part
file_count = 0;

% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots/Measures/MeanRemovedRMS']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
    tts_path = [file_path '/TTSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots\Measures\MeanRemovedRMS']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
    tts_path = [file_path '\TTSProfiles'];
end
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

for sub = 1:numsub % first for loop that iterates through subject files
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    % subject_path = [file_path, '\PS' , subject_str];
    if ismac || isunix
        subject_path = [file_path, '/' , subject_str, '/IMU_data'];

    elseif ispc
        subject_path = [file_path, '\' , subject_str , '\IMU_data'];
               
    end
    cd(subject_path);
% change directories
    cd(file_path);
    Label.TrialInfo = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P1:T1');
    TrialInfo = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P2:T13');
    TrialInfo(cellfun(@(x) any(ismissing(x)), TrialInfo)) = {''};
    cd(code_path);

    imu_list = file_path_info2(code_path, subject_path); % get files from file folder
    cd(subject_path);

    for i=1:length(imu_list) % nested for loop that iterates through IMU files in the subject folder

        if (endsWith(imu_list(i),'.csv') == false) % <change this to check if file type is not excel
            continue
        end
       
        file_count = file_count+1; % keeps track of the number of readable files currently read in the cycle
        original_filename = imu_list(i);
        imu_table = readtable(string(imu_list(i)));

        %pull label info from table and save into Label structure 

        imu_data = table2array(imu_table(:,3:11));
        time = 0:0.05:((height(imu_data)/20)-0.05);

        trial_name = cell2mat(strcat(TrialInfo(file_count,2), '_', string(TrialInfo(file_count,3)), 'mA_', TrialInfo(file_count,4), '_', string(TrialInfo(file_count,5)), 'Hz'));

        for j=1:width(imu_data) % nested for loop that plots each column inside of an IMU file 

            figure;
            plot(time, imu_data(:,j));
            title(trial_name);
            % forbidden save function. It creates funky files.
            % eval(['  save ' ['S' subject_str 'IMU' trial_name '.fig ']]);  
        end
        
%% save files
        cd(subject_path);
        vars_2_save = ['Label ' 'original_filename ' 'imu_data ' 'time'];
        eval(['  save ' ['S' subject_str 'IMU' trial_name '.mat '] vars_2_save ' vars_2_save']);      
        %close all;
        
    end
    eval (['clear ' vars_2_save])
    file_count = 0;
end    
    cd(code_path);

% all of the code you want to run 

