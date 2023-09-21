close all;clear;clc;
%% set up
subnum = 1017:1021;  % Subject List 
numsub = length(subnum);
subskip = [1013 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

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

for sub = 1:numsub
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
%     cd(subject_path);
% change directories
    cd(file_path);
    Label.TrialInfo = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P1:T1');
    TrialInfo = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P2:T13');
    TrialInfo(cellfun(@(x) any(ismissing(x)), TrialInfo)) = {''};
    cd(code_path);

    imu_list = file_path_info2(code_path, subject_path); % get files from file folder
    cd(subject_path);
    for i=length(imu_list)
        if true % <change this to check if file type is not excel
            continue
        end
        original_filename =imu_list(i);
        imu_table = readtable(string(imu_list(i)));
        %pull label info from table and save into Label structure 
        imu_data = table2array(imu_table(:,3:11));
        time = 0:0.05:((height(imu_data)/20)-0.05);
        figure;
        plot(time, imu_data)


        trial_name = horzcat([TrialInfo(i,2) '_' string(TrialInfo(i,3)) 'mA_' TrialInfo(i,4) '_' string(TrialInfo(i,4)) 'Hz']);

            %% save files
       cd(subject_path);
       vars_2_save = ['Label original_filename imu_data time' ];
       eval(['  save ' ['S' subject_str 'IMU' trial_name '.mat '] vars_2_save ' vars_2_save']);      
       cd(code_path)
       eval (['clear ' vars_2_save])
       close all;
    end
            %saveas(gcf,'output','fig');
    cd(code_path);

% all of the code you want to run 


end 
