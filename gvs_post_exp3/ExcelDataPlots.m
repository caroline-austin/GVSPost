% script 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        % This script takes the organized subject/trial data (All.mat) and
        % allows the user to manually cut the IMU data files 
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
subnum = [3023:3030];  % Subject List 3001, 
numsub = length(subnum);
subskip = [3002,0];  %DNF'd subjects or subjects that didn't complete this part
% full subject data sets should have:
% FMT: 6 GIST files, (9+ excel rows, 6 XSENS files(?)
% tandem: 12 GIST files, 16(?) excel rows, 12 XSENS files (?)
% Romberg: 30 GIST files (6 training, 24 trials), 18 excel rows (6
% training, 12 trials), 30 XSENS files (6 training, 24 trials)
datatype = ''; % this adds the CUT suffix plus the file types that have been cut (GFMT, GTDM, GROM, XFMT, XTDM, XROM or ALL)

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];
sub_symbols = [">k"; "vk";"ok";"+k"; "*k"; "xk"; "squarek"; "^k"; "<k"; "pentagramk"];

yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1]; 
xoffset = [-0.2;-0.1;0;0.1;0.2;-0.2;-0.1;0;0.1;0.2]; 

%% Data Import setup

% set up pathing
code_path = strrep(pwd,'\','/'); %save code directory
% Set High Level Folder 
file_path =  strrep(uigetdir,'\','/'); %user selects file directory

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

%% Specify files to cut
%% load file 

% add some logic to see if the data has already been cut/ to specify what
% you want to cut rather than making the user recut all of the data every
% time

cd(file_path);
load('All.mat');
cd(code_path);


%% plot excel data

% Enter Loop for Each Participant
participant_num = 0;
for sub = 1:numsub 
    subject = subnum(sub);
    subject_str = num2str(subject);

    if subject < 3023 
        current_participant = string(['P' subject_str]);
    else
        current_participant = string(['S' subject_str]);
    end

    if ismember(subject,subskip) == 1
       continue
    end

            % Increment Participant
            participant_num = participant_num + 1;
            sp_participant_list(participant_num) = current_participant;
           
            for trial = 1:width(fmt_EXCEL_all)
                trial_info_fmt = fmt_EXCEL_all{sub,trial};
                raw_time(sub,trial) = trial_info_fmt.RawTime;
                corrected_time(sub,trial) = trial_info_fmt.CorrectedTime;
                k_val_fmt(sub,trial) = trial_info_fmt.KValue;
            end
            for trial = 1:width(tandem_EXCEL_all)
                trial_info_tdm = tandem_EXCEL_all{sub,trial};
                completion_time(sub,trial) = trial_info_tdm.CompletionTime;
                correct_steps(sub,trial) = trial_info_tdm.TotalGoodSteps;
                k_val_tdm(sub,trial) = trial_info_tdm.KValue;
                condition_tdm(sub,trial) = Label.tandem(trial);
            end
            for trial = 1:width(romberg_EXCEL_all)
                trial_info_rom = romberg_EXCEL_all{sub,trial};
                if rem(trial,2) ==0
                    failtime(sub,trial) = trial_info_rom.TimeOfFailure2;
                else
                    failtime(sub,trial) = trial_info_rom.TimeOfFailure1;
                end
                head_tilts(sub,trial) = trial_info_rom.Headtilts;
                % eyes(sub,trial) = trial_info_rom.Eyes;
                k_val_rom(sub,trial) = trial_info_rom.KValue;
                condition_rom(sub,trial) = Label.romberg(trial);
            end



end
%%
figure;
for i = 1:height(raw_time)
    plot(k_val_fmt(i,:)/1000,raw_time(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
title("FMT Raw Completion Time Performance")
ylabel("Time (s)")
xlabel("GVS scaling factor")

figure;
for i = 1:height(corrected_time)
    plot(k_val_fmt(i,:)/1000,corrected_time(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
title("FMT Corrected Completion Time Performance")
ylabel("time(s)")
xlabel("GVS scaling factor")

%%
figure;
for i = 1:height(completion_time)
    plot(completion_time(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
xticks([1 2 3 4 5 6 7 8 9 10 11 12]);
xticklabels( Label.tandem);
title("Tandem Walk Completion Time Performance")
ylabel("Time (s)")
xlabel("Condition")

figure;
for i = 1:height(completion_time)
    plot(correct_steps(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
xticks([1 2 3 4 5 6 7 8 9 10 11 12]);
xticklabels( strrep(Label.tandem, '_', ''));
title("Tandem Walk Correct Steps")
ylabel("Number of Correct Steps")
xlabel("Condition")

%%
figure;
for i = 1:height(failtime)
    plot(failtime(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24]);
xticklabels( strrep(Label.romberg, '_',''));
title("Romberg Fail Time")
ylabel("Time (s)")
xlabel("Condition")