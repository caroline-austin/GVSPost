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
        cd(subject_path);
        imu_list = dir(subject_path);

        % iterates through trials in the IMU folder. 
        for i= 3:length(imu_list) 
            imu_table = readtable(imu_list(i).name);
            imu_data = table2array(imu_table(:,3:11));
            time = 0:0.05:((height(imu_data)/20)-0.05);

            plot(time, imu_data(:,1));

        end
  
    elseif ispc
        subject_path = [file_path, '\' , subject_str , '\IMU_data'];
        cd(subject_path);
        imu_list = dir(subject_path);

        for i=length(imu_list)
            imu_table = readtable(imu_list(i).name);
            imu_data = table2array(imu_table(:,3:11));
            time = 0:0.05:((height(imu_data)/20)-0.05);

            plot(time, imu_data(:,1))
            %saveas(gcf,'output','fig');
        end
    end
    
    cd(code_path);

% all of the code you want to run 


end 
