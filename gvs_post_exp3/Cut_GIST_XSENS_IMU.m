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
subnum = [3023:3027];  % Subject List 3001, 
numsub = length(subnum);
subskip = [3002,0];  %DNF'd subjects or subjects that didn't complete this part
% full subject data sets should have:
% FMT: 6 GIST files, (9+ excel rows, 6 XSENS files(?)
% tandem: 12 GIST files, 16(?) excel rows, 12 XSENS files (?)
% Romberg: 30 GIST files (6 training, 24 trials), 18 excel rows (6
% training, 12 trials), 30 XSENS files (6 training, 24 trials)
datatype = ''; % this adds the CUT suffix plus the file types that have been cut (GFMT, GTDM, GROM, XFMT, XTDM, XROM or ALL)

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


%% Cut GIST FMT

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
                trial_info = fmt_EXCEL_all{sub,trial};
                raw_time = trial_info.RawTime;
                trial_length = round(raw_time*30);
                Xsens_data = fmt_XSENS_all{sub,trial};
                GIST_data = fmt_GIST_all{sub,trial};
                Xsens_length = height(Xsens_data); 
                
                fmt_start{sub,trial} = 0;
                fmt_end{sub,trial} =0;
    
                if Xsens_length >1
                    clc; close all;
                figure; 
                    for i = 2: width(Xsens_data)
                        subplot(3,3,i-1)
                        plot(Xsens_data(:,i),'r'); 
                        title(Label.XSENS(i));
                        
                    end
                    sgtitle(strjoin(["Uncut FMT Data; Expected Trial Length: " num2str(trial_length) " samples = " num2str(trial_length/30) " s"])) ;

                    % if your estimate is more than two seconds off the expected value it will flag it
                    iter = 0;
                    while fmt_end{sub,trial} == 0 || abs(trial_length - abs(fmt_start{sub,trial}-fmt_end{sub,trial})) > 60 
                        if iter >=1
                            disp("Your start and end values do not match the expected trial length");
                        end
                        fmt_start{sub,trial} = input("Enter the time (x-value integer) for the start of the trial: ");
                        fmt_end{sub,trial} = input(strjoin(["Enter the time (x-value integer) for the end of the trial (estimated" num2str(fmt_start{sub,trial} + trial_length) ", enter 0 to reselect the start value): "]));
                        iter= iter+1;
                    end
                    Xsens_data_cut = Xsens_data(fmt_start{sub,trial}:fmt_end{sub,trial},:);

                    figure; 
                    for i = 2: width(Xsens_data_cut)
                        subplot(3,3,i-1)
                        plot(Xsens_data_cut(:,i),'r'); 
                        title(Label.XSENS(i));
                        
                    end
                    sgtitle(strjoin(["Cut FMT Data; Selected Trial Length: " num2str(fmt_end{sub,trial}-fmt_start{sub,trial}) " samples = " num2str((fmt_end{sub,trial}-fmt_start{sub,trial})/30) " s" ])) ;
    
                end
            end



end

% loop through each subject
% loop through each trial
% get trial length
% plot data
% ask user for start time and/or end time 
% cut to the trial length based on the start/end time the user specified
% and the known length of the trial

% overwrite the variable storing the uncut data 

%% Cut GIST Tandem

% loop through each subject
% loop through each trial
% get trial length
% plot data
% ask user for start time and/or end time 
% cut to the trial length based on the start/end time the user specified
% and the known length of the trial


%% Cut GIST Romberg

% loop through each subject
% loop through each trial
% get trial length
% plot data
% ask user for start time and/or end time 
% cut to the trial length based on the start/end time the user specified
% and the known length of the trial

%% Cut XSENS FMT

%% Cut XSENS Tandem

%% Cut XSENS Romberg 

