close all;clear;clc;
%% set up
subnum = 1017:1021;  % Subject List 
numsub = length(subnum);
subskip = [0,0];  %DNF'd subjects or subjects that didn't complete this part
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
% change directories
    cd(file_path);
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

        Eulers = imu_data(:,1:3);
        acc = 
        gyro = 
        

        Label.imu = imu_table.Properties.VariableNames(3:11);
        time = 0:1/30:((height(imu_data)/30)-1/30);

        [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc, gyro,sensorpositionplot);

        trial_name = strrep(cell2mat(strcat(TrialInfo(file_count,2), '_', ...
            string(TrialInfo(file_count,3)), 'mA_', TrialInfo(file_count,4), '_', ...
            string(TrialInfo(file_count,5)), 'Hz', string(TrialInfo(file_count,1)))),'.','_');

        figure();
        for j=1:width(imu_data) % nested for loop that plots each column inside of an IMU file 
            subplot(3,3,j);
            plot(time, imu_data(:,j));
            title(trial_name);
        end
        
        Filename=(['S' subject_str 'IMU' trial_name]);
        cd(plots_path)
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path)

% save files

        cd(subject_path);
        vars_2_save = ['Label ' 'original_filename ' 'imu_data ' 'time'];
        eval(['  save ' ['S' subject_str 'IMU' trial_name '.mat '] vars_2_save ' vars_2_save']);     
        cd(code_path);
        close all;
        
    end
    eval (['clear ' vars_2_save])
    file_count = 0;
end    

function  [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc, gyro,sensorpositionplot)
    FUSE = imufilter('SampleRate',25);
    q = FUSE(acc,gyro); % goes from Inertial to Sensor
    Eulers = eulerd(q, 'ZYX', 'frame'); % sensor = Rx'*Ry'*Rz'*global
    [yaw, pitch, roll] = quat2angle(q);

    acc_aligned = zeros(length(acc),3);
    for i = 1:length(acc)
        theta = Eulers(i,3);
        phi = Eulers(i,2);
        Rx = [1 0 0;0 cosd(theta) -sind(theta);...
              0 sind(theta) cosd(theta)];
        Ry = [cosd(phi) 0 sind(phi); 0 1 0;...
             -sind(phi) 0 cosd(phi)];

        % Excludes Rz to keep ML and AP aligned with x and y in the subject 
        % coordinated system vs. some fixed yaw inertial reference frame
        % yaw = -Eulers(i,1);
        % Rz = [cosd(yaw) -sind(phi) 0; 
        %       sind(yaw) cosd(yaw) 0; 0 0 1];
        acc_aligned(i,:) = (Ry*Rx*acc(i,:)')'; % Rz*Ry*Rx*sensor to go back
        gyro_aligned(i,:) = (Ry*Rx*gyro(i,:)')'; % Rz*Ry*Rx*sensor to go back
    end

    if sensorpositionplot == 1
        pp=poseplot;
        for ii=1:size(acc,1)
            qimu = FUSE(acc(ii,:), gyro(ii,:));
            set(pp, "Orientation", qimu)
            drawnow limitrate
            pause(0.05)
        end
    end
end
% all of the code you want to run 

