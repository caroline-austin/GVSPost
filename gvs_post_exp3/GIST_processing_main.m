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
subnum = [3023:3032];  % Subject List 3001, 
numsub = length(subnum);
subskip = [3002,0];  %DNF'd subjects or subjects that didn't complete this part

% Include plots?
plot_GIST_raw = 0;
plot_XSENS_raw = 0;
plot_fmt_data = 0;
plot_tandem_data = 0;
plot_romberg_data = 0;

% Save plots?
save_GIST_plots = 0;
save_XSENS_plots= 0;
save_fmt_plots = 0;
save_tandem_plots = 0;
save_romberg_plots = 0;

% full subject data sets should have:
% FMT: 6 GIST files, (9+ excel rows, 6 XSENS files(?)
% tandem: 12 GIST files, 16(?) excel rows, 12 XSENS files (?)
% Romberg: 30 GIST files (6 training, 24 trials), 18 excel rows (6
% training, 12 trials), 30 XSENS files (6 training, 24 trials)


%% Data Import setup

% set up pathing
code_path = strrep(pwd,'\','/'); %save code directory
% Set High Level Folder 
file_path =  strrep(uigetdir,'\','/'); %user selects file directory

% Master Spreadsheet File Location
filename = fullfile(file_path, 'FunctionalMobilityTesting.xlsx');
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
plot_path = fullfile(file_path, 'plots');

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

% Pre-Allocate Size of Each Variable
sp_fmt_data = cell(1,numsub);
sp_tandem_data = cell(1,numsub);
sp_romberg_data = cell(1,numsub);

sp_fmt_data_training = cell(1,numsub);
sp_tandem_data_training = cell(1,numsub);
sp_romberg_data_training = cell(1,numsub);

sp_participant_list = strings(numsub);

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
    if strcmp(sheet, 'S3023') || strcmp(sheet, 'S3025') || strcmp(sheet, 'S3027') || strcmp(sheet, 'S3028') || strcmp(sheet, 'S3030')|| strcmp(sheet, 'S3031')
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
end

%% GIST IMU Data Processing

% Define Each Folder Structure
fmt_folder = 'FMT';
tandem_folder = 'Tandem';
romberg_folder = 'Romberg';

% Find Total Number of Data Folders in High Level Directory
% GIST_participants = length(sub_folder_names);

% Pre-Allocate Size of Each Variable
GIST_participant_list = strings(numsub);

GIST_files_FMT = cell(1,numsub);
GIST_files_tandem = cell(1,numsub);
GIST_files_romberg = cell(1,numsub);

FMT_data = cell(1,numsub);
tandem_data = cell(1,numsub);
romberg_data = cell(1,numsub);

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
    sub_path = fullfile(file_path, current_GIST_participant);

    % Generate GIST participant list
    num_GIST_participants = num_GIST_participants + 1;
    GIST_participant_list(num_GIST_participants) = string(current_GIST_participant);

    % Length of FMT GIST Files for Current Participant
    GIST_file_location_FMT = fullfile(sub_path, fmt_folder);
    GIST_files_FMT{sub} = dir(fullfile(string(GIST_file_location_FMT), '*.csv')); %could use the get_filetype.m function

    % Length of Tandem Walk GIST Files for Current Participant
    GIST_file_location_tandem = fullfile(sub_path, tandem_folder);
    GIST_files_tandem{sub} = dir(fullfile(string(GIST_file_location_tandem), '*.csv'));

    % Length of Romberg Balance GIST Files for Current Participant
    GIST_file_location_romberg = fullfile(sub_path, romberg_folder);
    GIST_files_romberg{sub} = dir(fullfile(string(GIST_file_location_romberg), '*.csv'));
    
    % Loop through FMT GIST files
    for k = 1:length(GIST_files_FMT{sub})
        current_datafile = GIST_files_FMT{sub}(k,1); 
        current_filename = current_datafile.name;
        
        % Read in GIST file
        GIST_data = GISTfile_reader(fullfile(GIST_file_location_FMT, current_filename));
        
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
        GIST_data = GISTfile_reader(fullfile(GIST_file_location_tandem, current_filename));

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
        GIST_data = GISTfile_reader(fullfile(GIST_file_location_romberg, current_filename));

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
end

%% Xsens IMU data processing 

% Pre-Allocate Size of Each Variable
XSENS_participant_list = strings(numsub);

XSENS_files_FMT = cell(1,numsub);
XSENS_files_tandem = cell(1,numsub);
XSENS_files_romberg = cell(1,numsub);

FMT_dataX = cell(1,numsub);
tandem_dataX = cell(1,numsub);
romberg_dataX = cell(1,numsub);

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
    sub_path = fullfile(file_path, current_XSENS_participant, 'XSENS');

        % Generate XSENS participant list
        num_XSENS_participants = num_XSENS_participants + 1;
        XSENS_participant_list(num_XSENS_participants) = string(current_XSENS_participant);

        % Length of FMT XSENS Files for Current Participant
        XSENS_file_location_FMT = fullfile(sub_path, fmt_folder);
        XSENS_files_FMT{sub} = dir(fullfile(string(XSENS_file_location_FMT), '*.csv')); %could use the get_filetype.m function

        % Length of Tandem Walk XSENS Files for Current Participant
        XSENS_file_location_tandem = fullfile(sub_path, tandem_folder);
        XSENS_files_tandem{sub} = dir(fullfile(string(XSENS_file_location_tandem), '*.csv'));

        % Length of Romberg Balance XSENS Files for Current Participant
        XSENS_file_location_romberg = fullfile(sub_path, romberg_folder);
        XSENS_files_romberg{sub} = dir(fullfile(string(XSENS_file_location_romberg), '*.csv'));


        if subject > 3024
            % Loop through FMT XSENS files
            for k = 1:length(XSENS_files_FMT{sub})
                current_datafile = XSENS_files_FMT{sub}(k,1); 
                current_filename = current_datafile.name;
                
                % Read in XSENS file
                XSENS_data = XSENSfile_reader(fullfile(XSENS_file_location_FMT, current_filename));
                
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

            %         figure; 
            % subplot(3,3,1)
            % plot(euler_x,'r'); title("Euler X");
            % subplot(3,3,2)
            % plot(euler_y,'b'); title("Euler y");
            % subplot(3,3,3)
            % plot(euler_z,'g'); title("Euler Z");
            % 
            % subplot(3,3,4)
            % plot(acc_x,'r');  title("Acc X");
            % subplot(3,3,5)
            % plot(acc_y,'b'); title("Acc Y");
            % subplot(3,3,6)
            % plot(acc_z,'g'); title("Acc Z");
            % 
            % subplot(3,3,7)
            % plot(gyro_x,'r'); title("Gyro X");
            % subplot(3,3,8)
            % plot(gyro_y,'b'); title("Gyro Y");
            % subplot(3,3,9)
            % plot(gyro_z,'g'); title("Gyro Z");
            % sgtitle("Not Gravity Aligned") 

                 acc_raw = [acc_x(2:end), acc_y(2:end), acc_z(2:end)]; % Must be m/s2
                gyro_raw = pi/180*[gyro_x(2:end), gyro_y(2:end), gyro_z(2:end)]; % must be rad/s
    
                cd ..
                [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc_raw, gyro_raw,0,30);
                cd(code_path);
    
                time_data = time_data(2:end);
                euler_x = roll;
                euler_y = pitch;
                euler_z = yaw;
                acc_x = acc_aligned(:,1);
                acc_y = acc_aligned(:,2);
                acc_z = acc_aligned(:,3);          
                gyro_x = gyro_aligned(:,1);
                gyro_y = gyro_aligned(:,2);
                gyro_z = gyro_aligned(:,3);

            %     figure; 
            % subplot(3,3,1)
            % plot(roll, 'r'); title("Roll");
            % subplot(3,3,2)
            % plot(pitch, 'b'); title("Pitch");
            % subplot(3,3,3)
            % plot(yaw,'g'); title("Yaw");
            % 
            % subplot(3,3,4)
            % plot(acc_aligned(:,1),'r');  title("Acc X");
            % subplot(3,3,5)
            % plot(acc_aligned(:,2),'b'); title("Acc Y");
            % subplot(3,3,6)
            % plot(acc_aligned(:,3),'g'); title("Acc Z");
            % 
            % subplot(3,3,7)
            % plot(gyro_aligned(:,1),'r'); title("Gyro X");
            % subplot(3,3,8)
            % plot(gyro_aligned(:,2),'b'); title("Gyro Y");
            % subplot(3,3,9)
            % plot(gyro_aligned(:,3),'g'); title("Gyro Z");
            % sgtitle("Gravity Aligned") 
                        
                % Add to Cell Array for Plotting
                FMT_dataX{num_XSENS_participants}{k, 1} = [time_data, euler_x, euler_y, euler_z, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
            end
    
             % Loop through Tandem Walk XSENS files
            for k = 1:length(XSENS_files_tandem{sub})
                current_datafile = XSENS_files_tandem{sub}(k,1); 
                current_filename = current_datafile.name;
        
                % Read in XSENS file
                XSENS_data = XSENSfile_reader(fullfile(XSENS_file_location_tandem, current_filename));
        
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

            %     figure; 
            % subplot(3,3,1)
            % plot(euler_x,'r'); title("Euler X");
            % subplot(3,3,2)
            % plot(euler_y,'b'); title("Euler y");
            % subplot(3,3,3)
            % plot(euler_z,'g'); title("Euler Z");
            % 
            % subplot(3,3,4)
            % plot(acc_x,'r');  title("Acc X");
            % subplot(3,3,5)
            % plot(acc_y,'b'); title("Acc Y");
            % subplot(3,3,6)
            % plot(acc_z,'g'); title("Acc Z");
            % 
            % subplot(3,3,7)
            % plot(gyro_x,'r'); title("Gyro X");
            % subplot(3,3,8)
            % plot(gyro_y,'b'); title("Gyro Y");
            % subplot(3,3,9)
            % plot(gyro_z,'g'); title("Gyro Z");
            % sgtitle("Not Gravity Aligned") 

                acc_raw = [acc_x(2:end), acc_y(2:end), acc_z(2:end)]; % Must be m/s2
                gyro_raw = pi/180*[gyro_x(2:end), gyro_y(2:end), gyro_z(2:end)]; % must be rad/s

                cd ..
                [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc_raw, gyro_raw,0,30);
                cd(code_path);
    
                time_data = time_data(2:end);
                euler_x = roll;
                euler_y = pitch;
                euler_z = yaw;
                acc_x = acc_aligned(:,1);
                acc_y = acc_aligned(:,2);
                acc_z = acc_aligned(:,3);          
                gyro_x = gyro_aligned(:,1);
                gyro_y = gyro_aligned(:,2);
                gyro_z = gyro_aligned(:,3);

                

            % figure; 
            % subplot(3,3,1)
            % plot(roll, 'r'); title("Roll");
            % subplot(3,3,2)
            % plot(pitch, 'b'); title("Pitch");
            % subplot(3,3,3)
            % plot(yaw,'g'); title("Yaw");
            % 
            % subplot(3,3,4)
            % plot(acc_aligned(:,1),'r');  title("Acc X");
            % subplot(3,3,5)
            % plot(acc_aligned(:,2),'b'); title("Acc Y");
            % subplot(3,3,6)
            % plot(acc_aligned(:,3),'g'); title("Acc Z");
            % 
            % subplot(3,3,7)
            % plot(gyro_aligned(:,1),'r'); title("Gyro X");
            % subplot(3,3,8)
            % plot(gyro_aligned(:,2),'b'); title("Gyro Y");
            % subplot(3,3,9)
            % plot(gyro_aligned(:,3),'g'); title("Gyro Z");
            % sgtitle("Gravity Aligned") 
        
                % Add to Cell Array for Plotting
                tandem_dataX{num_XSENS_participants}{k, 1} = [time_data, euler_x, euler_y, euler_z, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
            end
        else % for subjects without XSENS tandem walk and functional mobility data set as zeros
            time_data = NaN;
            euler_x = NaN;
            euler_y = NaN;
            euler_z = NaN;
            acc_x = NaN;
            acc_y = NaN;
            acc_z = NaN;           
            gyro_x = NaN;
            gyro_y = NaN;
            gyro_z = NaN;
               for k = 1:length(GIST_files_FMT{sub}) % number of GIST and anticipated XSENS files should match (ie. same number of trials)
                FMT_dataX{num_XSENS_participants}{k, 1} = [time_data, euler_x, euler_y, euler_z, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
               end
               for k = 1:length(GIST_files_tandem{sub}) % number of GIST and anticipated XSENS files should match (ie. same number of trials)
                tandem_dataX{num_XSENS_participants}{k, 1} = [time_data, euler_x, euler_y, euler_z, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
               end
        end

        % Loop through Romberg Balance XSENS files
        for k = 1:length(XSENS_files_romberg{sub})
            current_datafile = XSENS_files_romberg{sub}(k,1); 
            current_filename = current_datafile.name;
    
            % Read in XSENS file
            XSENS_data = XSENSfile_reader(fullfile(XSENS_file_location_romberg, current_filename),30);
    
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

            acc_raw = [acc_x(2:end), acc_y(2:end), acc_z(2:end)]; % Must be m/s2
            gyro_raw = pi/180*[gyro_x(2:end), gyro_y(2:end), gyro_z(2:end)]; % must be rad/s

            cd ..
            [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc_raw, gyro_raw,0,30);
            cd(code_path);

            time_data = time_data(2:end);
            euler_x = roll;
            euler_y = pitch;
            euler_z = yaw;
            acc_x = acc_aligned(:,1);
            acc_y = acc_aligned(:,2);
            acc_z = acc_aligned(:,3);          
            gyro_x = gyro_aligned(:,1);
            gyro_y = gyro_aligned(:,2);
            gyro_z = gyro_aligned(:,3);

            % figure; 
            % subplot(3,3,1)
            % plot(euler_x,'r'); title("Euler X");
            % subplot(3,3,2)
            % plot(euler_y,'b'); title("Euler y");
            % subplot(3,3,3)
            % plot(euler_z,'g'); title("Euler Z");
            % 
            % subplot(3,3,4)
            % plot(acc_x,'r');  title("Acc X");
            % subplot(3,3,5)
            % plot(acc_y,'b'); title("Acc Y");
            % subplot(3,3,6)
            % plot(acc_z,'g'); title("Acc Z");
            % 
            % subplot(3,3,7)
            % plot(gyro_x,'r'); title("Gyro X");
            % subplot(3,3,8)
            % plot(gyro_y,'b'); title("Gyro Y");
            % subplot(3,3,9)
            % plot(gyro_z,'g'); title("Gyro Z");
            % sgtitle("Not Gravity Aligned") 
            % 
            % 
            % figure; 
            % subplot(3,3,1)
            % plot(roll, 'r'); title("Roll");
            % subplot(3,3,2)
            % plot(pitch, 'b'); title("Pitch");
            % subplot(3,3,3)
            % plot(yaw,'g'); title("Yaw");
            % 
            % subplot(3,3,4)
            % plot(acc_aligned(:,1),'r');  title("Acc X");
            % subplot(3,3,5)
            % plot(acc_aligned(:,2),'b'); title("Acc Y");
            % subplot(3,3,6)
            % plot(acc_aligned(:,3),'g'); title("Acc Z");
            % 
            % subplot(3,3,7)
            % plot(gyro_aligned(:,1),'r'); title("Gyro X");
            % subplot(3,3,8)
            % plot(gyro_aligned(:,2),'b'); title("Gyro Y");
            % subplot(3,3,9)
            % plot(gyro_aligned(:,3),'g'); title("Gyro Z");
            % sgtitle("Gravity Aligned") 
    
            % Add to Cell Array for Plotting
            romberg_dataX{num_XSENS_participants}{k, 1} = [time_data, euler_x, euler_y, euler_z, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
        end
end
%% Cut IMU data to right length (manual)

%% Sort variables and save Files
Label.GIST = ["Time", "Ch1CurrentuA", "Ch1Impedance", "Ch1VoltageV", "Ch2CurrentuA", "Ch2Impedance", "Ch2VoltageV", "Roll", "Pitch", "Yaw"];
Label.XSENS = ["Time", "EulerX", "EulerY", "EulerZ", "AccX", "AccY", "AccZ", "GyroX", "GyroY", "GyroZ"];

%define order for aggregated data
FMT_Label = ["K000", "K000", "K500", "K500", "K999", "K999"];
tandem_Label = ["K000_NHeadTilt_EO",  "K500_NHeadTilt_EO",  "K999_NHeadTilt_EO", ... 
    "K000_YHeadTilt_EO",  "K500_YHeadTilt_EO",  "K999_YHeadTilt_EO", ... 
    "K000_NHeadTilt_EC",  "K500_NHeadTilt_EC",  "K999_NHeadTilt_EC", ... 
    "K000_YHeadTilt_EC",  "K500_YHeadTilt_EC",  "K999_YHeadTilt_EC"];
romberg_Label = ["K000_NHeadTilt", "K000_NHeadTilt", "K000_NHeadTilt", ...
        "K000_NHeadTilt",  "K500_NHeadTilt","K500_NHeadTilt","K500_NHeadTilt", ...
        "K500_NHeadTilt",  "K999_NHeadTilt","K999_NHeadTilt","K999_NHeadTilt",... 
        "K999_NHeadTilt", "K000_YHeadTilt", "K000_YHeadTilt","K000_YHeadTilt", ...
        "K000_YHeadTilt", "K500_YHeadTilt", "K500_YHeadTilt","K500_YHeadTilt", ...
        "K500_YHeadTilt", "K999_YHeadTilt", "K999_YHeadTilt", "K999_YHeadTilt", "K999_YHeadTilt"]; 
romberg_training_Label = [ "K000_NHeadTilt_EO_HS", "K000_NHeadTilt_EC_HS", "K000_NHeadTilt_EO_FS", ... 
        "K000_NHeadTilt_EC_FS", "K000_YHeadTilt_EO_FS", "K000_YHeadTilt_EC_FS"]; 

% Pre-Allocate Size of Each Variable
fmt_GIST_sort = cell(1, length(FMT_Label));
fmt_XSENS_sort = cell(1, length(FMT_Label));
fmt_EXCEL_sort = cell(1, length(FMT_Label));
fmt_GIST_all = cell(numsub, length(FMT_Label));
fmt_XSENS_all = cell(numsub, length(FMT_Label));
fmt_EXCEL_all = cell(numsub, length(FMT_Label));

tandem_GIST_sort = cell(1, length(tandem_Label));
tandem_XSENS_sort = cell(1, length(tandem_Label));
tandem_EXCEL_sort = cell(1, length(tandem_Label));
tandem_GIST_all = cell(numsub, length(tandem_Label));
tandem_XSENS_all = cell(numsub, length(tandem_Label));
tandem_EXCEL_all = cell(numsub, length(tandem_Label));

romberg_GIST_sort = cell(1, length(romberg_Label));
romberg_XSENS_sort = cell(1, length(romberg_Label));
romberg_EXCEL_sort = cell(1, length(romberg_Label));
romberg_GIST_all = cell(numsub, length(romberg_Label));
romberg_XSENS_all = cell(numsub, length(romberg_Label));
romberg_EXCEL_all = cell(numsub, length(romberg_Label));

romberg_GIST_train_sort = cell(1, length(romberg_Label));
romberg_XSENS_train_sort = cell(1, length(romberg_Label));
romberg_EXCEL_train_sort = cell(1, length(romberg_Label));
romberg_GIST_train_all = cell(numsub, length(romberg_Label));
romberg_XSENS_train_all = cell(numsub, length(romberg_Label));
romberg_EXCEL_train_all = cell(numsub, length(romberg_Label));

%process data one participant at a time
for sub= 1:numsub
    %set up subject info and pathing
    subject = subnum(sub);
    subject_str = num2str(subject);

     % Current save Participant
    if subject < 3023 
        current_save_participant = string(['P' subject_str]);
    else
        current_save_participant = string(['S' subject_str]);
    end

    if ismember(subject,subskip) == 1
       continue
    end
    sub_path = fullfile(file_path, current_save_participant);
    
    %FMT
    check = zeros(1,height(sp_fmt_data{1,sub})); % one zero for each of the anticipated trials
    % it would be good to pre allocate the sort and all variables

    %process data one trial at a time
    for trial = 1:height(sp_fmt_data{1,sub})
        %create trial name
        fmt_trial_name = strrep(strjoin(['FMT_K' string(sp_fmt_data{1,sub}{trial,5}) '_' string(sp_fmt_data{1,sub}{trial,2})], ''), 'K0', 'K000');
        %pull data for given trial
        fmt_GIST = FMT_data{1,sub}{trial,1};
        fmt_XSENS = FMT_dataX{1,sub}{trial,1};
        fmt_EXCEL = sp_fmt_data{1,sub}(trial,:);
        %save individual trial data into a its own file
        cd(fullfile(sub_path, fmt_folder));
        vars_2_save = ['fmt_GIST ' 'fmt_XSENS ' 'fmt_EXCEL '];
        eval(strjoin(['  save ' strjoin([current_save_participant '_' fmt_trial_name '.mat '],'') vars_2_save  ' Label vars_2_save']));     
        cd(code_path);
        close all;
        % aggregate the data from all of the trials into a single organized
        % variable - trial organization is determined by the label defined
        % at the beginning of the section
        for match = 1:length(FMT_Label)
            if contains(fmt_trial_name, FMT_Label(match)) && check(match) ==0
                check(match) = 1; % additional condition because each treatment is repeated
                %single subject organization of trials
                fmt_GIST_sort{match} = FMT_data{1,sub}{trial,1};
                fmt_XSENS_sort{match} = FMT_dataX{1,sub}{trial,1};
                fmt_EXCEL_sort{match}= sp_fmt_data{1,sub}(trial,:);
                % store all trials from all subjects 
                fmt_GIST_all{sub,match} = FMT_data{1,sub}{trial,1};
                fmt_XSENS_all{sub,match} = FMT_dataX{1,sub}{trial,1};
                fmt_EXCEL_all{sub,match}= sp_fmt_data{1,sub}(trial,:);
                break;
            end
        end
        eval (['clear ' vars_2_save])
    end
    
    %Tandem Walk
        % it would be good to pre allocate the sort and all variables

         %process data one trial at a time
    for trial = 1:height(sp_tandem_data{1,sub})
        %create trial name (pulling some of the sub components beforehand 
        % so that captialization and name length can be consistent)
        headtilts = char(sp_tandem_data{1,sub}{trial,7});
        headtilts = upper(headtilts(1));
        eyes = char(sp_tandem_data{1,sub}{trial,8});
        eyes = upper(eyes(1));
        tandem_trial_name = strrep(strjoin(['TDM_K' string(sp_tandem_data{1,sub}{trial,5}) '_' headtilts 'HeadTilt_E' eyes  '_' string(sp_tandem_data{1,sub}{trial,2})], ''), 'K0', 'K000');
        %pull data for given trial
        tandem_GIST = tandem_data{1,sub}{trial,1};
        tandem_XSENS = tandem_dataX{1,sub}{trial,1};
        tandem_EXCEL = sp_tandem_data{1,sub}(trial,:);
        %save individual trial data into a its own file
        cd(fullfile(sub_path, tandem_folder));
        vars_2_save = ['tandem_GIST ' 'tandem_XSENS ' 'tandem_EXCEL '];
        eval(strjoin(['  save ' strjoin([current_save_participant '_' tandem_trial_name '.mat '],'') vars_2_save  ' Label vars_2_save']));     
        cd(code_path);
        close all;
        % aggregate the data from all of the trials into a single organized
        % variable - trial organization is determined by the label defined
        % at the beginning of the section
        for match = 1:length(tandem_Label)
            if contains(tandem_trial_name, tandem_Label(match)) 
                %single subject organization of trials
                tandem_GIST_sort{match} = tandem_data{1,sub}{trial,1};
                tandem_XSENS_sort{match} = tandem_dataX{1,sub}{trial,1};
                tandem_EXCEL_sort{match}= sp_tandem_data{1,sub}(trial,:);
                % store all trials from all subjects 
                tandem_GIST_all{sub,match} = tandem_data{1,sub}{trial,1};
                tandem_XSENS_all{sub,match} = tandem_dataX{1,sub}{trial,1};
                tandem_EXCEL_all{sub,match}= sp_tandem_data{1,sub}(trial,:);
                break;
            end
        end
        eval (['clear ' vars_2_save])
    end
    %Romberg
        check_rom = zeros(1,height(sp_romberg_data{1,sub})*2); % one zero for each of the anticipated trials
    % it would be good to pre allocate the sort and all variables
    training = height(sp_romberg_data_training{1,sub});
    %process data one trial at a time (shifting to account for training trials in the data matrix )
    for trial = (training+1):(length(romberg_data{1,sub}))
        % set up index to account for 2 trials in each row of the sp_
        % variable from the excel sheet
        index = ceil((trial-training)/2);
        %create trial name (pulling some of the sub components beforehand 
        % so that captialization and name length can be consistent)
        if rem(trial,2) ==0
            order = "B";
        else 
            order = "A";
        end
        headtilts = char(sp_romberg_data{1,sub}{index,7});
        headtilts = upper(headtilts(1));
        romberg_trial_name = strrep(strjoin(['ROM_K' string(sp_romberg_data{1,sub}{index,5}) '_' headtilts 'HeadTilt_' string(sp_romberg_data{1,sub}{index,2}) order], ''), 'K0', 'K000');
        %pull data for given trial
        romberg_GIST = romberg_data{1,sub}{trial,1}; 
        romberg_XSENS = romberg_dataX{1,sub}{trial,1};
        romberg_EXCEL = sp_romberg_data{1,sub}(index,:);
        %save individual trial data into a its own file
        cd(fullfile(sub_path, romberg_folder));
        vars_2_save = ['romberg_GIST ' 'romberg_XSENS ' 'romberg_EXCEL '];
        eval(strjoin(['  save ' strjoin([current_save_participant '_' romberg_trial_name '.mat '],'') vars_2_save  ' Label vars_2_save']));     
        cd(code_path);
        close all;
        % aggregate the data from all of the trials into a single organized
        % variable - trial organization is determined by the label defined
        % at the beginning of the section
        for match = 1:length(romberg_Label)
            if contains(romberg_trial_name, romberg_Label(match)) && check_rom(match) ==0
                check_rom(match) =1;
                %single subject organization of trials
                romberg_GIST_sort{match} = romberg_data{1,sub}{trial,1};
                romberg_XSENS_sort{match} = romberg_dataX{1,sub}{trial,1};
                romberg_EXCEL_sort{match}= sp_romberg_data{1,sub}(index,:);
                % store all trials from all subjects 
                romberg_GIST_all{sub,match} = romberg_data{1,sub}{trial,1};
                romberg_XSENS_all{sub,match} = romberg_dataX{1,sub}{trial,1};
                romberg_EXCEL_all{sub,match}= sp_romberg_data{1,sub}(index,:);
                break;
            end
        end
        eval (['clear ' vars_2_save])
    end

   %Romberg training trials
    check = zeros(1,height(sp_romberg_data_training{1,sub})); % one zero for each of the anticipated trials
    % it would be good to pre allocate the sort and all variables

    %process data one trial at a time
    for trial = 1:height(sp_romberg_data_training{1,sub})

        headtilts = char(sp_romberg_data_training{1,sub}{trial,7});
        headtilts = upper(headtilts(1));
        eyes = char(sp_romberg_data_training{1,sub}{trial,9});
        eyes = upper(eyes(1));
        surface = char(sp_romberg_data_training{1,sub}{trial,8});
        surface = upper(surface(1));
        
        romberg_trial_name = strrep(strjoin(['ROM_K' string(sp_romberg_data_training{1,sub}{trial,5}) '_' headtilts 'HeadTilt_E' eyes '_' surface 'S_' string(sp_romberg_data_training{1,sub}{trial,1})], ''), 'K0', 'K000');
        %pull data for given trial
        romberg_GIST_train = romberg_data{1,sub}{trial,1}; % missing file for S3023
        romberg_XSENS_train = romberg_dataX{1,sub}{trial,1};
        romberg_EXCEL_train = sp_romberg_data_training{1,sub}(trial,:);
        %save individual trial data into a its own file
        cd(fullfile(sub_path, romberg_folder));
        vars_2_save = ['romberg_GIST_train ' 'romberg_XSENS_train ' 'romberg_EXCEL_train '];
        eval(strjoin(['  save ' strjoin([current_save_participant '_' romberg_trial_name '.mat '],'') vars_2_save  ' Label vars_2_save']));     
        cd(code_path);
        close all;
        % aggregate the data from all of the trials into a single organized
        % variable - trial organization is determined by the label defined
        % at the beginning of the section
        for match = 1:length(romberg_training_Label)
            if contains(romberg_trial_name, romberg_training_Label(match)) && check(match) ==0
                %single subject organization of trials
                romberg_GIST_train_sort{match} = romberg_data{1,sub}{trial,1};
                romberg_XSENS_train_sort{match} = romberg_dataX{1,sub}{trial,1};
                romberg_EXCEL_train_sort{match}= sp_romberg_data_training{1,sub}(trial,:);
                % store all trials from all subjects 
                romberg_GIST_train_all{sub,match} = romberg_data{1,sub}{trial,1};
                romberg_XSENS_train_all{sub,match} = romberg_dataX{1,sub}{trial,1};
                romberg_EXCEL_train_all{sub,match}= sp_romberg_data_training{1,sub}(trial,:);
                break;
            end
        end

        eval (['clear ' vars_2_save])
    end
    
    % put all Labels into the label variable (these were not needed for the individual trial files)
    Label.romberg = romberg_Label;
    Label.romberg_training = romberg_training_Label;
    Label.tandem = tandem_Label;
    Label.FMT = FMT_Label;

    % save all of the trials for a given subject
        cd(sub_path);
        vars_2_save = ['fmt_GIST_sort ' 'fmt_XSENS_sort ' 'fmt_EXCEL_sort ' ... 
            'tandem_GIST_sort ' 'tandem_XSENS_sort ' 'tandem_EXCEL_sort ' ... 
            'romberg_GIST_sort ' 'romberg_XSENS_sort ' 'romberg_EXCEL_sort ' ...
            'romberg_GIST_train_sort ' 'romberg_XSENS_train_sort ' 'romberg_EXCEL_train_sort '];
        eval(strjoin(['  save ' strjoin([current_save_participant '.mat '],'') vars_2_save  ' Label vars_2_save']));     
        cd(code_path);
        close all;
        eval (['clear ' vars_2_save])
end
    % save all of the trials for all subjects
    % need to add subject number label
    cd(file_path);
    vars_2_save = ['fmt_GIST_all ' 'fmt_XSENS_all ' 'fmt_EXCEL_all ' ...
        'tandem_GIST_all ' 'tandem_XSENS_all ' 'tandem_EXCEL_all ' ... 
        'romberg_GIST_all ' 'romberg_XSENS_all ' 'romberg_EXCEL_all '... 
        'romberg_GIST_train_all ' 'romberg_XSENS_train_all ' 'romberg_EXCEL_train_all '];
    eval(['  save All.mat ' vars_2_save  ' Label vars_2_save']);     
    cd(code_path);
    close all;


%% Spreadsheet Plotting
% I would like to put the plotting code in a new script where we load in
% the files we've saved so we don't have to deal with the cutting /loading
% naming code everytime we want to generate plots or do other things with
% the data

% if plot_fmt_data == 1
% go to plotting function... feed in save_fmt_plots into function

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

% if plot_GIST_raw == 1
% go to plotting function... feed in save_GIST_plots into function

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

% Pre-Allocate Size of Each Variable
trial_fmt = cell(numsub, length(FMT_Label));
k_vals_all_fmt = cell(numsub, length(FMT_Label));
gist_file_name_fmt = strings(length(FMT_Label), numsub);

k_999_gist_files_fmt = cell(1, numsub);
k_500_gist_files_fmt = cell(1, numsub);
k_0_gist_files_fmt = cell(1, numsub);

k_vals_all_tandem = cell(numsub, length(tandem_Label));
gist_file_name_tandem = strings(length(tandem_Label), numsub);

k_999_gist_files_tandem = cell(1, numsub);
k_500_gist_files_tandem = cell(1, numsub);
k_0_gist_files_tandem = cell(1, numsub);

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

% if plot_fmt_data == 1
% go to plotting function... feed in save_fmt_plots into function

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

% Pre-Allocate Size of Each Variable
legend_names = strings(length(FMT_Label));

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

