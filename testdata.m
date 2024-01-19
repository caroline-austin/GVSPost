close all;clear;clc; warning off;

%% set up
subnum = 1021;  % Subject List 
numsub = length(subnum);
subskip = [0,1031];  %DNF'd subjects or subjects that didn't complete this part
file_count = 0;
sensorpositionplot = 0;

% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots/Measures/IMU']; % specify where plots are saved
elseif ispc
    plots_path = [file_path '\Plots\Measures\IMU']; % specify where plots are saved
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

    cd(file_path); % change directories
    Label.TrialInfo = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P1:T1');
    TrialInfo = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P2:T13');
    TrialInfo(cellfun(@(x) any(ismissing(x)), TrialInfo)) = {''};
    cd(code_path);

    imu_list = file_path_info2(code_path, subject_path); % get files from file folder

    for i=1:length(imu_list) % nested for loop that iterates through IMU files in the subject folder

        if (endsWith(imu_list(i),'.csv') == false) % <change this to check if file type is not excel
            continue
        end
       
        file_count = file_count+1; % keeps track of the number of readable files currently read in the cycle
        original_filename = imu_list(i);
        cd(subject_path);
        imu_table = readtable(string(imu_list(i)));
        cd(code_path);

        %pull label info from table and save into Label structure 

        imu_data = table2array(imu_table(:,3:11));

        Euler = imu_data(2:end,1:3); % exclude first line of 0's
        % not sure why, but order needs to be rotated like this- maybe so that the
        % axis that is most aligned with what we want to be z is the third?
        acc = imu_data(2:end,[6,5,4]); 
        gyro = pi/180*imu_data(2:end,7:9); % convert to rad/s

        %% loc of 11.5 sec is 346!!!


        Label.imu = imu_table.Properties.VariableNames(3:11);
        time{i} = 0:1/30:((height(acc)/30)-1/30);
        timeimu = 0:1/30:((height(imu_data)/30)-1/30);


        [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc, gyro,sensorpositionplot);
  


        while strlength(string(TrialInfo(file_count,3))) ~= 5  % makes all trial names the same number of chars
            if strlength(string(TrialInfo(file_count,3))) == 1
                TrialInfo(file_count,3) = mat2cell(string(TrialInfo(file_count,3)) + ".000",1);
            else
                TrialInfo(file_count,3) = mat2cell(string(TrialInfo(file_count,3)) + "0",1);
            end
        end

        trial_name = strrep(cell2mat(strcat(TrialInfo(file_count,2), '_', ...
            string(TrialInfo(file_count,3)), 'mA_', TrialInfo(file_count,4), '_', ...
            string(TrialInfo(file_count,5)), 'Hz', string(TrialInfo(file_count,1)))),'.','_');

        data_type = ["EulerX","EulerY","EulerZ","accX","accY","accZ","gyroX","gyroY","gyroZ"];
        direction = ["Z", "Y", "X"];




    end

end   