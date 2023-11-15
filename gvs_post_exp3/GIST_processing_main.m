%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        % This script takes inputs of the spreadsheet and GIST raw files for data
        % plotting.
        %
        % NOTE: This script is setup for the spreadsheet to be located one folder
        % above the working directory. This script should be placed in a folder
        % with the folders for each participant. Only the participant folders
        % should be located at this file path. The participant data should be
        % parsed into 3 folders "Tandem", "Romberg" or "FMT" depending on which
        % data each GIST file corresponds to (based on time in spreadsheet). The
        % data plots will be saved to a 'plots' folder located at the same level as
        % the spreadsheet.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

%% set up
subnum = [3023:3024];  % Subject List 3001, 
numsub = length(subnum);
subskip = [3002,0];  %DNF'd subjects or subjects that didn't complete this part

%% Data Import setup

% set up pathing
code_path = strrep(pwd,'\','/'); %save code directory
% Set High Level Folder 
file_path =  strrep(uigetdir,'\','/'); %user selects file directory

% Master Spreadsheet File Location
filename = [ file_path '/FunctionalMobilityTesting.xlsx'];
sheets = sheetnames(filename);

% GIST File Locations
% Get List of Files & Folders in Directory
files = dir(file_path);

% Get a Logical Vector that Tells which is a Directory
dir_flags = [files.isdir];

% Extract Only Those that are Directories
sub_folders = files(dir_flags);

% Get Only the Folder Names into a Cell Array
sub_folder_names = {sub_folders(3:end).name};

% Remove 'plots' Folder
plot_folder_flag = strcmp(sub_folder_names, 'plots');
sub_folder_names = sub_folder_names(~plot_folder_flag);

%% Set Plot Locations

plot_path = [file_path '/plots/'];

%% Reference Spreadsheet Vals

% fmt_var_range = "A2:I2";
% fmt_training_data_range = "A3:I5";
% fmt_data_range = "A6:I11";

%for subject 3023, needed additional training
% fmt_var_range_1 = fmt_var_range;
% fmt_training_data_range_1 = "A3:I6";
% fmt_data_range_1 = "A7:I12";

% tandem_var_range = "A15:W15";
% tandem_training_data_range = "A16:W19";
% tandem_data_range = "A20:W31";

% rom_var_range = "A35:M35";
% rom_training_data_range = "A36:M41";
% rom_data_range = "A42:M53";

%% Specify Spreadsheet Import Parameters

% Functional Mobility Test
opts_fmt = spreadsheetImportOptions("NumVariables", 9);
opts_fmt.VariableNames = ["trialNumber", "trialOrder", "MaxGVS", "CouplingParameter", "KValue", "Threshold", "Raw Time", "Errors", "Corrected Time"];
opts_fmt.VariableTypes = ["double", "double", "categorical", "categorical", "double", "double", "double", "double", "double"];
fmt_dataLines = [3, 11];
opts_fmt.DataRange = fmt_dataLines(1, :);

% Extra FMT (participant S3023)
opts_fmt_mod = spreadsheetImportOptions("NumVariables", 9);
opts_fmt_mod.VariableNames = ["trialNumber", "trialOrder", "MaxGVS", "CouplingParameter", "KValue", "Threshold", "Raw Time", "Errors", "Corrected Time"];
opts_fmt_mod.VariableTypes = ["double", "double", "categorical", "categorical", "double", "double", "double", "double", "double"];
fmt_dataLines_mod = [3, 12];
opts_fmt_mod.DataRange = fmt_dataLines_mod(1, :);

% Tandem Walk Test
opts_tandem = spreadsheetImportOptions("NumVariables", 23);
opts_tandem.VariableNames = ["trialNumber", "trialOrder", "MaxGVS", "CouplingParameter", "KValue", "Threshold", "Headtilts", "Eyes", "Step1", "Step2", "Step3", "Step4", "Step5", "Step6", "Step7", "Step8", "Step9", "Step10", "CompletionTime", "TotalGoodSteps", "firstStep", "Right", "Left"];
opts_tandem.VariableTypes = ["double", "double", "categorical", "categorical", "double", "double", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "double", "double", "char", "categorical", "categorical"];
tandem_dataLines = [16, 31];
opts_tandem.DataRange = tandem_dataLines(1, :);

% Romberg Balance Test
opts_romberg = spreadsheetImportOptions("NumVariables", 13);
opts_romberg.VariableNames = ["trialNumber", "trialOrder", "MaxGVS", "CouplingParameter", "KValue", "Threshold", "Headtilts", "Surface", "Eyes", "TimeOfFailure1", "TimeOfFailure2", "TimeOfFailure3", "TimeOfFailure4"];
opts_romberg.VariableTypes = ["double", "double", "categorical", "categorical", "double", "double", "categorical", "categorical", "categorical", "double", "double", "double", "double"];
romberg_dataLines = [36, 53];
opts_romberg.DataRange = romberg_dataLines(1, :);

%% Import Spreadsheet Data

% Pre-Allocate Size of Each Cell Array
% sp_fmt_data{}
% sp_tandem_data{}
% sp_romberg_data{}

% sp_fmt_training_data{}
% sp_tandem_training_data{}
% sp_romberg_training_data{}


% Enter Loop for Each Participant
participant_num = 0;
for sub = 1:numsub 
    subject = subnum(sub);
    subject_str = num2str(subject);

    if subject < 3023 
        sheet = string(['P' subject_str]);
    else
        sheet = string(['S' subject_str]);
    end

    if ismember(subject,subskip) == 1
       continue
    end

            % Increment Participant
            participant_num = participant_num + 1;
            sp_participant_list(participant_num) = sheet;
            
            % Functional Mobility Test
            % Adjust for additional training trial for subject S3023
            if strcmp(sheet, 'S3023')
                opts_fmt_mod.Sheet = sheet;
                sp_fmt_data_all = readtable(filename, opts_fmt_mod, "UseExcel", false);

                % Set range for training data
                fmt_training_range = 4;

                % Set Training and Trial Data Arrays for Plotting
                sp_fmt_data_training{participant_num} = sp_fmt_data_all(1:fmt_training_range,:);
                sp_fmt_data{participant_num} = sp_fmt_data_all((fmt_training_range + 1):height(sp_fmt_data_all), :);
            else
                opts_fmt.Sheet = sheet;
                sp_fmt_data_all = readtable(filename, opts_fmt, "UseExcel", false);

                % Set range for training data
                fmt_training_range = 3;

                % Set Training and Trial Data Arrays for Plotting
                sp_fmt_data_training{participant_num} = sp_fmt_data_all(1:fmt_training_range,:);
                sp_fmt_data{participant_num} = sp_fmt_data_all((fmt_training_range + 1):height(sp_fmt_data_all), :);
            end
          

            % Tandem Walk Test
            opts_tandem.Sheet = sheet;
            sp_tandem_data_all = readtable(filename,opts_tandem, "UseExcel", false);

            % Set range for training data
            tandem_training_range = 4;

            % Set Training and Trial Data Arrays for Plotting
            sp_tandem_data_training{participant_num} = sp_tandem_data_all(1:tandem_training_range,:);
            sp_tandem_data{participant_num} = sp_tandem_data_all((tandem_training_range + 1):height(sp_tandem_data_all), :);
            

            % Romberg Balance Test
            opts_romberg.Sheet = sheet;
            sp_romberg_data_all = readtable(filename,opts_romberg, "UseExcel", false);

            % Set range for training data
            romberg_training_range = 6;

            % Set Training and Trial Data Arrays for Plotting
            sp_romberg_data_training{participant_num} = sp_romberg_data_all(1:romberg_training_range,:);
            sp_romberg_data{participant_num} = sp_romberg_data_all((romberg_training_range + 1):height(sp_romberg_data_all), :);
        %end
    %end
end

%% GIST IMU Data Processing

% Define Each Folder Structure
fmt_folder = 'FMT\';
tandem_folder = 'Tandem\';
romberg_folder = 'Romberg\';

% Find Total Number of Data Folders in High Level Directory
% GIST_participants = length(sub_folder_names);

% Iterate through all CSV Files in Folder
num_GIST_participants = 0;
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);

     % Current GIST Participant
    if subject < 3023 
        current_GIST_participant = string(['P' subject_str]);
    else
        current_GIST_participant = string(['S' subject_str]);
    end

    if ismember(subject,subskip) == 1
       continue
    end
    sub_path = strjoin([file_path, '/' , current_GIST_participant], '');

        % Generate GIST participant list
        num_GIST_participants = num_GIST_participants + 1;
        GIST_participant_list(num_GIST_participants) = string(current_GIST_participant);

        % Length of FMT GIST Files for Current Participant
        GIST_file_location_FMT = (strjoin([sub_path, '/', fmt_folder], ''));
        GIST_files_FMT{sub} = dir(fullfile(string(GIST_file_location_FMT), '*.csv')); %could use the get_filetype.m function
    
        % Length of Tandem Walk GIST Files for Current Participant
        GIST_file_location_tandem = (strjoin([sub_path, '/', tandem_folder], ''));
        GIST_files_tandem{sub} = dir(fullfile(string(GIST_file_location_tandem), '*.csv'));
    
        % Length of Romberg Balance GIST Files for Current Participant
        GIST_file_location_romberg = (strjoin([sub_path, '/', romberg_folder], ''));
        GIST_files_romberg{sub} = dir(fullfile(string(GIST_file_location_romberg), '*.csv'));
        
        % Loop through FMT GIST files
        for k = 1:length(GIST_files_FMT{sub})
            current_datafile = GIST_files_FMT{sub}(k,1); 
            current_filename = current_datafile.name;
            
            % Read in GIST file
            GIST_data = GISTfile_reader(strcat(GIST_file_location_FMT, current_filename));
            
            % Set Time, Roll, Pitch, and Yaw data
            time_data = GIST_data.Time;
            channel_1_current = GIST_data.Ch1CurrentuA;
            channel_1_impedance = GIST_data.Ch1Impedance;
            channel_1_voltage = GIST_data.Ch1VoltageV;
            channel_2_current = GIST_data.Ch2CurrentuA;
            channel_2_impedance = GIST_data.Ch2Impedance;
            channel_2_voltage = GIST_data.Ch2VoltageV;            
            roll_data = GIST_data.Roll;
            pitch_data = GIST_data.Pitch;
            yaw_data = GIST_data.Yaw;
    
            % Add to Cell Array for Plotting
            FMT_data{num_GIST_participants}{k, 1} = [time_data, channel_1_current, channel_1_impedance, channel_1_voltage, channel_2_current, channel_2_impedance, channel_2_voltage, roll_data, pitch_data, yaw_data];
        end
    
        % Loop through Tandem Walk GIST files
        for k = 1:length(GIST_files_tandem{sub})
            current_datafile = GIST_files_tandem{sub}(k,1); 
            current_filename = current_datafile.name;
    
            % Read in GIST file
            GIST_data = GISTfile_reader(strcat(GIST_file_location_tandem, current_filename));
    
            % Set Time, Roll, Pitch, and Yaw data
            time_data = GIST_data.Time;
            channel_1_current = GIST_data.Ch1CurrentuA;
            channel_1_impedance = GIST_data.Ch1Impedance;
            channel_1_voltage = GIST_data.Ch1VoltageV;
            channel_2_current = GIST_data.Ch2CurrentuA;
            channel_2_impedance = GIST_data.Ch2Impedance;
            channel_2_voltage = GIST_data.Ch2VoltageV;            
            roll_data = GIST_data.Roll;
            pitch_data = GIST_data.Pitch;
            yaw_data = GIST_data.Yaw;
    
            % Add to Cell Array for Plotting
            tandem_data{num_GIST_participants}{k, 1} = [time_data, channel_1_current, channel_1_impedance, channel_1_voltage, channel_2_current, channel_2_impedance, channel_2_voltage, roll_data, pitch_data, yaw_data];
        end
    
        % Loop through Romberg Balance GIST files
        for k = 1:length(GIST_files_romberg{sub})
            current_datafile = GIST_files_romberg{sub}(k,1); 
            current_filename = current_datafile.name;
    
            % Read in GIST file
            GIST_data = GISTfile_reader(strcat(GIST_file_location_romberg, current_filename));
    
            % Set Time, Roll, Pitch, and Yaw data
            time_data = GIST_data.Time;
            channel_1_current = GIST_data.Ch1CurrentuA;
            channel_1_impedance = GIST_data.Ch1Impedance;
            channel_1_voltage = GIST_data.Ch1VoltageV;
            channel_2_current = GIST_data.Ch2CurrentuA;
            channel_2_impedance = GIST_data.Ch2Impedance;
            channel_2_voltage = GIST_data.Ch2VoltageV;            
            roll_data = GIST_data.Roll;
            pitch_data = GIST_data.Pitch;
            yaw_data = GIST_data.Yaw;
    
            % Add to Cell Array for Plotting
            romberg_data{num_GIST_participants}{k, 1} = [time_data, channel_1_current, channel_1_impedance, channel_1_voltage, channel_2_current, channel_2_impedance, channel_2_voltage, roll_data, pitch_data, yaw_data];
        end
%     end
end
%% Xsens IMU data processing 
% Define Each Folder Structure
fmt_folder = 'FMT\';
tandem_folder = 'Tandem\';
romberg_folder = 'Romberg\';

% Iterate through all subjects 
num_XSENS_participants = 0;
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);

     % Current XSENS Participant
    if subject < 3023 
        current_XSENS_participant = string(['P' subject_str]);
    else
        current_XSENS_participant = string(['S' subject_str]);
    end

    if ismember(subject,subskip) == 1
       continue
    end
    sub_path = strjoin([file_path, '/' , current_XSENS_participant, '/XSENS'], '');

        % Generate XSENS participant list
        num_XSENS_participants = num_XSENS_participants + 1;
        XSENS_participant_list(num_XSENS_participants) = string(current_XSENS_participant);
        
        if subject > 3024
            % Length of FMT XSENS Files for Current Participant
            XSENS_file_location_FMT = (strjoin([sub_path, '/', fmt_folder], ''));
            XSENS_files_FMT{sub} = dir(fullfile(string(XSENS_file_location_FMT), '*.csv')); %could use the get_filetype.m function

            % Length of Tandem Walk XSENS Files for Current Participant
            XSENS_file_location_tandem = (strjoin([sub_path, '/', tandem_folder], ''));
            XSENS_files_tandem{sub} = dir(fullfile(string(XSENS_file_location_tandem), '*.csv'));

            % Loop through FMT XSENS files
        for k = 1:length(XSENS_files_FMT{sub})
            current_datafile = XSENS_files_FMT{sub}(k,1); 
            current_filename = current_datafile.name;
            
            % Read in XSENS file
            XSENS_data = XSENSfile_reader(strcat(XSENS_file_location_FMT, current_filename));
            
            % Set Time, Roll, Pitch, and Yaw data
            time_data = XSENS_data.Time;
            euler_x = XSENS_data.EulerX;
            euler_y = XSENS_data.EulerY;
            euler_z = XSENS_data.EulerZ;
            acc_x = XSENS_data.AccX;
            acc_y = XSENS_data.AccY;
            acc_z = XSENS_data.AccZ;            
            gyro_x = XSENS_data.GyroX;
            gyro_y = XSENS_data.GyroY;
            gyro_z = XSENS_data.GyroZ;
    
            % Add to Cell Array for Plotting
            FMT_dataX{num_XSENS_participants}{k, 1} = [time_data, euler_x, euler_y, euler_z, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
        end

         % Loop through Tandem Walk XSENS files
        for k = 1:length(XSENS_files_tandem{sub})
            current_datafile = XSENS_files_tandem{sub}(k,1); 
            current_filename = current_datafile.name;
    
            % Read in XSENS file
            XSENS_data = XSENSfile_reader(strcat(XSENS_file_location_tandem, current_filename));
    
           % Set Time, Roll, Pitch, and Yaw data
            time_data = XSENS_data.Time;
            euler_x = XSENS_data.EulerX;
            euler_y = XSENS_data.EulerY;
            euler_z = XSENS_data.EulerZ;
            acc_x = XSENS_data.AccX;
            acc_y = XSENS_data.AccY;
            acc_z = XSENS_data.AccZ;            
            gyro_x = XSENS_data.GyroX;
            gyro_y = XSENS_data.GyroY;
            gyro_z = XSENS_data.GyroZ;
    
            % Add to Cell Array for Plotting
            tandem_dataX{num_XSENS_participants}{k, 1} = [time_data, euler_x, euler_y, euler_z, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
        end

        end
    
        % Length of Romberg Balance XSENS Files for Current Participant
        XSENS_file_location_romberg = (strjoin([sub_path, '/', romberg_folder], ''));
        XSENS_files_romberg{sub} = dir(fullfile(string(XSENS_file_location_romberg), '*.csv'));

                % Loop through Romberg Balance GIST files
        for k = 1:length(XSENS_files_romberg{sub})
            current_datafile = XSENS_files_romberg{sub}(k,1); 
            current_filename = current_datafile.name;
    
            % Read in XSENS file
            XSENS_data = XSENSfile_reader(strcat(XSENS_file_location_romberg, current_filename),30);
    
            % Set Time, Roll, Pitch, and Yaw data
            time_data = XSENS_data.Time;
            euler_x = XSENS_data.EulerX;
            euler_y = XSENS_data.EulerY;
            euler_z = XSENS_data.EulerZ;
            acc_x = XSENS_data.AccX;
            acc_y = XSENS_data.AccY;
            acc_z = XSENS_data.AccZ;            
            gyro_x = XSENS_data.GyroX;
            gyro_y = XSENS_data.GyroY;
            gyro_z = XSENS_data.GyroZ;
    
            % Add to Cell Array for Plotting
            romberg_dataX{num_XSENS_participants}{k, 1} = [time_data, euler_x, euler_y, euler_z, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
        end
end
%% Cut IMU data to right length (manual)

%% Save Files

%% Spreadsheet Plotting
% I would like to put the plotting code in a new script where we load in
% the files we've saved so we don't have to deal with the cutting /loading
% naming code everytime we want to generate plots or do other things with
% the data

% Plot FMT Raw Completion time vs K
figure_save = figure(); 
plot_title = 'FMT_completion_time';
for p = 1:length(sp_fmt_data)
    scatter(sp_fmt_data{p}.KValue, sp_fmt_data{p}.RawTime, 60, 'filled', 'MarkerEdgeColor','k');
    hold on
    scatter(sp_fmt_data{p}.KValue + 10, sp_fmt_data{p}.CorrectedTime, 60, 'filled', 'MarkerEdgeColor','k');
    hold on
end
xlabel('GVS Gain K');
ylabel('Completion Time [s]');
axis([0,1100, 0, 40]);
legend(["Participant 1 Raw Time", "Participant 1 Corrected Time", "Participant 2 Raw Time", "Participant 2 Corrected Time"]);
title('Functional Mobility Test Completion Time vs. K');
saveas(figure_save, [plot_path plot_title '.fig']);

% Plot FMT Erros vs K
figure_save = figure(); 
plot_title = 'FMT_errors';
for p = 1:length(sp_fmt_data)
    scatter(sp_fmt_data{p}.KValue + 5*p, sp_fmt_data{p}.Errors, 60, 'filled', 'MarkerEdgeColor','k');
    hold on
end
xlabel('GVS Gain K');
ylabel('Errors');
axis([0,1100, 0, 5]);
legend(["Participant 1 Errors", "Participant 2 Errors"]);
title('Functional Mobility Test Errors vs. K');
saveas(figure_save, [plot_path plot_title '.fig']);

%% IMU Plotting

% Raw Data Plots for FMT
% roll
figure_save = figure(); 
plot_title = 'FMTRoll';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,8))
        hold on
    end
end
xlabel('Time [s]');
ylabel('Roll');
axis([0,60, -100, 100]);
legend%(["Participant 1 Errors", "Participant 2 Errors"]);
title('Functional Mobility Test IMU Roll Data vs. Time');
saveas(figure_save, [plot_path plot_title '.fig']);

% roll
figure_save = figure(); 
plot_title = 'FMTRoll_K';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        plot(FMT_data{1,p}{f,1}(:,2)/1000,FMT_data{1,p}{f,1}(:,8))
        hold on
    end
end
xlabel('Current [m amps]');
ylabel('Roll');
axis([0,10, -40, 40]);
legend%(["Participant 1 Errors", "Participant 2 Errors"]);
title('Functional Mobility Test IMU Roll Data vs. Current Level');
saveas(figure_save, [plot_path plot_title '.fig']);

% pitch
figure_save = figure();
plot_title = 'FMTPitch';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,9))
        hold on
    end
end
xlabel('Time [s]');
ylabel('Pitch');
axis([0,60, -100, 100]);
legend
title('Functional Mobility Test IMU Pitch Data vs. Time');
saveas(figure_save, [plot_path plot_title '.fig']);

% yaw
figure_save = figure();
plot_title = 'FMTYaw';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,10))
        hold on
    end
end
xlabel('Time [s]');
ylabel('Yaw');
axis([0,60, -200, 200]);
legend
title('Functional Mobility Test IMU Yaw Data vs. Time');
saveas(figure_save, [plot_path plot_title '.fig']);

% Raw Data Plots for Tandem Walk
% roll
figure_save = figure(); 
plot_title = 'TandemRoll';
for p = 1:length(tandem_data)
    for t = 1:length(tandem_data{1,p})
        plot(tandem_data{1,p}{t,1}(:,1)/1000,tandem_data{1,p}{t,1}(:,8))
        hold on
    end
end
xlabel('Time [s]');
ylabel('Roll');
axis([0,60, -100, 100]);
legend
title('Tandem Walk Test IMU Roll Data vs. Time');
saveas(figure_save, [plot_path plot_title '.fig']);

% pitch
figure_save = figure();
plot_title = 'TandemPitch';
for p = 1:length(tandem_data)
    for t = 1:length(tandem_data{1,p})
        plot(tandem_data{1,p}{t,1}(:,1)/1000,tandem_data{1,p}{t,1}(:,9))
        hold on
    end
end
xlabel('Time [s]');
ylabel('Pitch');
axis([0,60, -100, 100]);
legend
title('Tandem Walk Test IMU Pitch Data vs. Time');
saveas(figure_save, [plot_path plot_title '.fig']);

% yaw
figure_save = figure();
plot_title = 'TandemYaw';
for p = 1:length(tandem_data)
    for t = 1:length(tandem_data{1,p})
        plot(tandem_data{1,p}{t,1}(:,1)/1000,tandem_data{1,p}{t,1}(:,10))
        hold on
    end
end
xlabel('Time [s]');
ylabel('Yaw');
axis([0,60, -200, 200]);
legend
title('Tandem Walk Test IMU Yaw Data vs. Time');
saveas(figure_save, [plot_path plot_title '.fig']);

% Raw Data Plots for Romberg
% roll
figure_save = figure(); 
plot_title = 'RombergRoll';
for p = 1:length(romberg_data)
    for r = 1:length(romberg_data{1,p})
        plot(romberg_data{1,p}{r,1}(:,1)/1000,romberg_data{1,p}{r,1}(:,8));
        hold on
    end
end
xlabel('Time [s]');
ylabel('Roll');
axis([0,60, -100, 100]);
legend
title('Romberg Balance Test IMU Roll Data vs. Time');
saveas(figure_save, [plot_path plot_title '.fig']);

% pitch
figure_save = figure();
plot_title = 'RombergPitch';
for p = 1:length(romberg_data)
    for r = 1:length(romberg_data{1,p})
        plot(romberg_data{1,p}{r,1}(:,1)/1000,romberg_data{1,p}{r,1}(:,9))
        hold on
    end
end
xlabel('Time [s]');
ylabel('Pitch');
axis([0,60, -100, 100]);
legend
title('Romberg Balance Test IMU Pitch Data vs. Time');
saveas(figure_save, [plot_path plot_title '.fig']);

% yaw
figure_save = figure(); 
plot_title = 'RombergYaw';
for p = 1:length(romberg_data)
    for r = 1:length(romberg_data{1,p})
        plot(romberg_data{1,p}{r,1}(:,1)/1000,romberg_data{1,p}{r,1}(:,10))
        hold on
    end
end
xlabel('Time [s]');
ylabel('Yaw');
axis([0,60, -100, 100]);
legend
title('Romberg Balance Test IMU Yaw Data vs. Time');
saveas(figure_save, [plot_path plot_title '.fig']);

%% Correlate Spreadsheet and GIST data files

% Iterate through gist participants and correlate gist data to trial in
% spreadsheet
for gist_index = 1:length(GIST_participant_list)
    current_GIST_participant_compare = GIST_participant_list(gist_index);
    spreadsheet_index = find(strcmp(sp_participant_list, current_GIST_participant_compare));
    

    % Functional Mobility Test
    % Initialize String
    string_k_fmt = strings(size(1:length (sp_fmt_data{spreadsheet_index}.KValue)));

    for fmt_index = 1:length (sp_fmt_data{spreadsheet_index}.KValue)
        
        string_k_fmt(fmt_index) = string(sp_fmt_data{spreadsheet_index}.KValue(fmt_index));

        % If first k value 
        repeat = find(strcmp(string_k_fmt, string_k_fmt(fmt_index)));
        if length(repeat) ==  1
            k_repeat = '_1';
        else
            k_repeat = '_2';
        end

        trial_fmt{gist_index, fmt_index} = k_repeat;
        k_vals_all_fmt{gist_index, fmt_index} = string_k_fmt(fmt_index);
        gist_file_name_fmt(fmt_index,gist_index) = strcat(current_GIST_participant_compare, '_functional_mobility_k_', string_k_fmt(fmt_index), k_repeat);
        
        % Output .mat files      
    end

    % Get k value array
    k_999_gist_files_fmt{gist_index} = contains(gist_file_name_fmt(:,gist_index), 'k_999');
    k_500_gist_files_fmt{gist_index} = contains(gist_file_name_fmt(:,gist_index), 'k_500');
    k_0_gist_files_fmt{gist_index} = contains(gist_file_name_fmt(:,gist_index), 'k_0');
    
    
    % THIS IS A WORK IN PROGRESS!!!  NEED TO INCORPORATE EYES, HEAD
    % SWITCHES, # CORRECT STEPS, EACH INDIVIDUAL STEP, ETC....
    % Tandem Walk Test
    % Initialize String
    string_k_tandem = strings(size(1:length (sp_tandem_data{spreadsheet_index}.KValue)));
    string_headtilts_tandem = strings(size(1:length (sp_tandem_data{spreadsheet_index}.Headtilts)));
    string_eyes_tandem = strings(size(1:length (sp_tandem_data{spreadsheet_index}.Eyes)));
    for tandem_index = 1:length (sp_tandem_data{spreadsheet_index}.KValue)
        
        string_k_tandem(tandem_index) = string(sp_tandem_data{spreadsheet_index}.KValue(tandem_index));
        string_headtilts_tandem(tandem_index) = string(sp_tandem_data{spreadsheet_index}.Headtilts(tandem_index));
        string_eyes_tandem(tandem_index) = string(sp_tandem_data{spreadsheet_index}.Eyes(tandem_index));
        % % If first k value 
        % repeat = find(strcmp(string_k_fmt, string_k_fmt(fmt_index)));
        % if length(repeat) ==  1
        %     k_repeat = '_1';
        % else
        %     k_repeat = '_2';
        % end

        %trial_tandem{gist_index, tandem_index} = k_repeat;
        k_vals_all_tandem{gist_index, tandem_index} = string_k_tandem(tandem_index);
        gist_file_name_tandem(tandem_index,gist_index) = strcat(current_GIST_participant_compare, '_tandem_walk_k_', string_k_tandem(tandem_index),'_', string_headtilts_tandem(tandem_index),'_headtilts', '_eyes_',string_eyes_tandem(tandem_index));
        
        % Output .mat files      
    end

    % Get k value array
    k_999_gist_files_tandem{gist_index} = contains(gist_file_name_tandem(:,gist_index), 'k_999');
    k_500_gist_files_tandem{gist_index} = contains(gist_file_name_tandem(:,gist_index), 'k_500');
    k_0_gist_files_tandem{gist_index} = contains(gist_file_name_tandem(:,gist_index), 'k_0');

    % Romberg Balance Test
    % THIS IS A WORK IN PROGRESS!!!  NEED TO INCORPORATE EYES, HEAD
    % SWITCHES, TIME OF FAILURE 
end

%% Figures for FMT per Gain Value

% 999 value
% roll
figure_save = figure(); 
plot_title = 'FMT_Roll_K999';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        if k_999_gist_files_fmt{p}(f,1)
            plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,8), 'LineWidth',2)
            hold on
        else
            continue
        end
    end
end
xlabel('Time [s]');
ylabel('Roll');
axis([0,40, -100, 100]);
legend(["Participant 1 Trial 1 at K = 999", "Participant 1 Trial 2 at K = 999", "Participant 2 Trial 1 at K = 999", "Participant 2 Trial 2 at K = 999"]);
title('Functional Mobility Test IMU Roll Data vs. Time for K = 999');
saveas(figure_save, [plot_path plot_title '.fig']);


% pitch
figure_save = figure(); 
plot_title = 'FMT_Pitch_K999';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        if k_999_gist_files_fmt{p}(f,1)
            plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,9), 'LineWidth',2)
            hold on
        else
            continue
        end
    end
end
xlabel('Time [s]');
ylabel('Pitch');
axis([0,40, -100, 100]);
legend(["Participant 1 Trial 1 at K = 999", "Participant 1 Trial 2 at K = 999", "Participant 2 Trial 1 at K = 999", "Participant 2 Trial 2 at K = 999"]);
title('Functional Mobility Test IMU Pitch Data vs. Time for K = 999');
saveas(figure_save, [plot_path plot_title '.fig']);

% yaw
figure_save = figure(); 
plot_title = 'FMT_Yaw_K999';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        if k_999_gist_files_fmt{p}(f,1)
            plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,10), 'LineWidth',2)
            hold on
        else
            continue
        end
    end
end
xlabel('Time [s]');
ylabel('Yaw');
axis([0,40, -200, 200]);
legend(["Participant 1 Trial 1 at K = 999", "Participant 1 Trial 2 at K = 999", "Participant 2 Trial 1 at K = 999", "Participant 2 Trial 2 at K = 999"]);
title('Functional Mobility Test IMU Yaw Data vs. Time for K = 999');
saveas(figure_save, [plot_path plot_title '.fig']);


% 0 value

% roll
figure_save = figure(); 
plot_title = 'FMT_Roll_K0';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        if k_0_gist_files_fmt{p}(f,1)
            plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,8), 'LineWidth',2)
            hold on
        else
            continue
        end
    end
end
xlabel('Time [s]');
ylabel('Roll');
axis([0,40, -100, 100]);
legend(["Participant 1 Trial 1 at K = 0", "Participant 1 Trial 2 at K = 0", "Participant 2 Trial 1 at K = 0", "Participant 2 Trial 2 at K = 0"]);
title('Functional Mobility Test IMU Roll Data vs. Time for K = 0');
saveas(figure_save, [plot_path plot_title '.fig']);


% pitch
figure_save = figure(); 
plot_title = 'FMT_Pitch_K0';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        if k_0_gist_files_fmt{p}(f,1)
            plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,9), 'LineWidth',2)
            hold on
        else
            continue
        end
    end
end
xlabel('Time [s]');
ylabel('Pitch');
axis([0,40, -100, 100]);
legend(["Participant 1 Trial 1 at K = 0", "Participant 1 Trial 2 at K = 0", "Participant 2 Trial 1 at K = 0", "Participant 2 Trial 2 at K = 0"]);
title('Functional Mobility Test IMU Pitch Data vs. Time for K = 0');
saveas(figure_save, [plot_path plot_title '.fig']);

% yaw
figure_save = figure(); 
plot_title = 'FMT_Yaw_K0';
for p = 1:length(FMT_data)
    for f = 1:length(FMT_data{1,p})
        if k_0_gist_files_fmt{p}(f,1)
            plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,10), 'LineWidth',2)
            hold on
        else
            continue
        end
    end
end
xlabel('Time [s]');
ylabel('Yaw');
axis([0,40, -200, 200]);
legend(["Participant 1 Trial 1 at K = 0", "Participant 1 Trial 2 at K = 0", "Participant 2 Trial 1 at K = 0", "Participant 2 Trial 2 at K = 0"]);
title('Functional Mobility Test IMU Yaw Data vs. Time for K = 0');
saveas(figure_save, [plot_path plot_title '.fig']);

%% Figures per participant for all gain values

% Participant 1
figure_save = figure(); 
plot_title = 'FMT_Yaw_Participant1';
for p = 1:1
    for f = 1:length(FMT_data{1,p})
        plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,10), 'LineWidth',2)
        hold on
        legend_names(f) = strcat('Participant 1 Trial  ', erase(string(trial_fmt{p,f}), '_'), ' at K =  ', k_vals_all_fmt{p,f});
    end
end
xlabel('Time [s]');
ylabel('Yaw');
axis([0,40, -200, 200]);
legend(legend_names);%["Participant 1 Trial 1 at K = 999", "Participant 1 Trial 2 at K = 999", "Participant 2 Trial 1 at K = 999", "Participant 2 Trial 2 at K = 999"]);
title('Functional Mobility Test IMU Yaw Data vs. Time');% for K = 999');
saveas(figure_save, [plot_path plot_title '.fig']);

% Participant 2
figure_save = figure(); 
plot_title = 'FMT_Yaw_Participant2';
for p = 2:2
    for f = 1:length(FMT_data{1,p})
        plot(FMT_data{1,p}{f,1}(:,1)/1000,FMT_data{1,p}{f,1}(:,10), 'LineWidth',2)
        hold on
        legend_names(f) = strcat('Participant 2 Trial  ', erase(string(trial_fmt{p,f}), '_'), ' at K =  ', k_vals_all_fmt{p,f});
    end
end
xlabel('Time [s]');
ylabel('Yaw');
axis([0,40, -200, 200]);
legend(legend_names);%["Participant 1 Trial 1 at K = 999", "Participant 1 Trial 2 at K = 999", "Participant 2 Trial 1 at K = 999", "Participant 2 Trial 2 at K = 999"]);
title('Functional Mobility Test IMU Yaw Data vs. Time');% for K = 999');
saveas(figure_save, [plot_path plot_title '.fig']);