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
subnum = [3030:3031];  % Subject List 3001, 
numsub = length(subnum);
subskip = [3002,0];  %DNF'd subjects or subjects that didn't complete this part
% full subject data sets should have:
% FMT: 6 GIST files, (9+ excel rows, 6 XSENS files(?)
% tandem: 12 GIST files, 16(?) excel rows, 12 XSENS files (?)
% Romberg: 30 GIST files (6 training, 24 trials), 18 excel rows (6
% training, 12 trials), 30 XSENS files (6 training, 24 trials)
datatype = ''; % this tells the code which version of the data file to grab (ie. if other data processing has been done)
newdatatype = '_Cut_All'; % this adds the CUT suffix plus the file types that have been cut (GFMT, GTDM, GROM, XFMT, XTDM, XROM or ALL)

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

% check the newdatatype variable and code that into which parts of the code to
% run (using an if statement at the beginning of each section to see if the
% section should be run

%check datatype to see if the data has been cut before - if so make sure
%the previous variables are stored (this should be the case if loading the
%data file with that info 

%if the data hasn't been cut yet and not all of the data is going to be cut
%might need to pre-allocate/empty variables for the others

%what about adding participants and keeping the cutting work that has
%already been done for previous participants?

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
        % sub_path = strjoin([file_path, '/' , current_GIST_participant], '');
        % cd(sub_path);
        % load('All.mat');
        % cd(code_path);
            % Increment Participant
            participant_num = participant_num + 1;
            sp_participant_list(participant_num) = current_participant;
            for trial = 1:width(fmt_EXCEL_all)
                trial_info = fmt_EXCEL_all{sub,trial};
                raw_time = trial_info.RawTime;
                trial_length_X = round(raw_time*30);
                trial_length_G = round(raw_time*3.3);
                Xsens_data = fmt_XSENS_all{sub,trial};
                GIST_data = fmt_GIST_all{sub,trial};
                Xsens_length = height(Xsens_data); 
                
                fmt_start_X{sub,trial} = 0;
                fmt_end_X{sub,trial} =0;
                fmt_start_G{sub,trial} = 0;
                fmt_end_G{sub,trial} =0;
    
                if Xsens_length >1 % && we want to cut the XSENS data
                    clc; close all;
                figure; 
                    for i = 2: width(Xsens_data)
                        subplot(3,3,i-1)
                        plot(Xsens_data(:,i),'r'); 
                        title(Label.XSENS(i));
                        
                    end
                    sgtitle(strjoin(["Uncut XSENS FMT Data; Expected Trial Length: " num2str(trial_length_X) " samples = " num2str(trial_length_X/30) " s"])) ;

                    % if your estimate is more than two seconds off the expected value it will flag it
                    iter = 0;
                    while fmt_end_X{sub,trial} == 0 || abs(trial_length_X - abs(fmt_start_X{sub,trial}-fmt_end_X{sub,trial})) > 60 
                        if iter >=1
                            disp("Your start and end values do not match the expected trial length");
                        end
                        fmt_start_X{sub,trial} = input("Enter the time (x-value integer) for the start of the trial: ");
                        fmt_end_X{sub,trial} = input(strjoin(["Enter the time (x-value integer) for the end of the trial (estimated" num2str(fmt_start_X{sub,trial} + trial_length_X) ", enter 0 to reselect the start value): "]));
                        iter= iter+1;
                    end
                    Xsens_data_cut = Xsens_data(fmt_start_X{sub,trial}:fmt_end_X{sub,trial},:);

                    figure; 
                    for i = 2: width(Xsens_data_cut)
                        subplot(3,3,i-1)
                        plot(Xsens_data_cut(:,i),'r'); 
                        title(Label.XSENS(i));
                        
                    end
                    sgtitle(strjoin(["Cut XSENS FMT Data; Selected Trial Length: " num2str(fmt_end_X{sub,trial}-fmt_start_X{sub,trial}) " samples = " num2str((fmt_end_X{sub,trial}-fmt_start_X{sub,trial})/3.3) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    fmt_XSENS_all{sub,trial}= Xsens_data_cut;
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if 1==1 % this is a placeholder for checking whether or not we want to cut the GIST data
                    clc; close all;
                figure; 
                    for i = 2: width(GIST_data)
                        subplot(3,3,i-1)
                        plot(GIST_data(:,i),'r'); 
                        title(Label.GIST(i));
                        
                    end
                    sgtitle(strjoin(["Uncut GIST FMT Data; Expected Trial Length: " num2str(trial_length_G) " samples = " num2str(trial_length_G/3.3) " s"])) ;

                    % if your estimate is more than two seconds off the expected value it will flag it
                    iter = 0;
                    while fmt_end_G{sub,trial} == 0 || abs(trial_length_G - abs(fmt_start_G{sub,trial}-fmt_end_G{sub,trial})) > 60 
                        if iter >=1
                            disp("Your start and end values do not match the expected trial length");
                        end
                        fmt_start_G{sub,trial} = input("Enter the time (x-value integer) for the start of the trial: ");
                        fmt_end_G{sub,trial} = input(strjoin(["Enter the time (x-value integer) for the end of the trial (estimated" num2str(fmt_start_G{sub,trial} + trial_length_G) ", enter 0 to reselect the start value): "]));
                        iter= iter+1;
                    end
                    GIST_data_cut = GIST_data(fmt_start_G{sub,trial}:fmt_end_G{sub,trial},:);

                    figure; 
                    for i = 2: width(GIST_data_cut)
                        subplot(3,3,i-1)
                        plot(GIST_data_cut(:,i),'r'); 
                        title(Label.GIST(i));
                        
                    end
                    sgtitle(strjoin(["Cut GIST FMT Data; Selected Trial Length: " num2str(fmt_end_G{sub,trial}-fmt_start_G{sub,trial}) " samples = " num2str((fmt_end_G{sub,trial}-fmt_start_G{sub,trial})/3.3) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    fmt_GIST_all{sub,trial}= GIST_data_cut;
                end

            end

end

%% Cut Tandem

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
            for trial = 1:width(tandem_EXCEL_all)
                trial_info = tandem_EXCEL_all{sub,trial};
                raw_time = trial_info.CompletionTime;
                trial_length_X = round(raw_time*30);
                trial_length_G = round(raw_time*3.3);
                Xsens_data = tandem_XSENS_all{sub,trial};
                GIST_data = tandem_GIST_all{sub,trial};
                Xsens_length = height(Xsens_data); 
                
                tandem_start_X{sub,trial} = 0;
                tandem_end_X{sub,trial} =0;
                tandem_start_G{sub,trial} = 0;
                tandem_end_G{sub,trial} =0;
    
                if Xsens_length >1 % && we want to cut the XSENS data
                    clc; close all;
                figure; 
                    for i = 2: width(Xsens_data)
                        subplot(3,3,i-1)
                        plot(Xsens_data(:,i),'r'); 
                        title(Label.XSENS(i));
                        
                    end
                    sgtitle(strjoin(["Uncut XSENS Tandem Data; Expected Trial Length: " num2str(trial_length_X) " samples = " num2str(trial_length_X/30) " s"])) ;

                    % if your estimate is more than two seconds off the expected value it will flag it
                    iter = 0;
                    while tandem_end_X{sub,trial} == 0 || abs(trial_length_X - abs(tandem_start_X{sub,trial}-tandem_end_X{sub,trial})) > 60 %note if a time is not recorded this will not work, but doesn't break the code
                        if iter >=1
                            disp("Your start and end values do not match the expected trial length");
                        end
                        tandem_start_X{sub,trial} = input("Enter the time (x-value integer) for the start of the trial: ");
                        tandem_end_X{sub,trial} = input(strjoin(["Enter the time (x-value integer) for the end of the trial (estimated" num2str(tandem_start_X{sub,trial} + trial_length_X) ", enter 0 to reselect the start value): "]));
                        iter= iter+1;
                    end
                    Xsens_data_cut = Xsens_data(tandem_start_X{sub,trial}:tandem_end_X{sub,trial},:);

                    figure; 
                    for i = 2: width(Xsens_data_cut)
                        subplot(3,3,i-1)
                        plot(Xsens_data_cut(:,i),'r'); 
                        title(Label.XSENS(i));
                        
                    end
                    sgtitle(strjoin(["Cut XSENS Tandem Data; Selected Trial Length: " num2str(tandem_end_X{sub,trial}-tandem_start_X{sub,trial}) " samples = " num2str((tandem_end_X{sub,trial}-tandem_start_X{sub,trial})/3.3) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    tandem_XSENS_all{sub,trial}= Xsens_data_cut;
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if 1==1 % this is a placeholder for checking whether or not we want to cut the GIST data
                    clc; close all;
                figure; 
                    for i = 2: width(GIST_data)
                        subplot(3,3,i-1)
                        plot(GIST_data(:,i),'r'); 
                        title(Label.GIST(i));
                        
                    end
                    sgtitle(strjoin(["Uncut GIST Tandem Data; Expected Trial Length: " num2str(trial_length_G) " samples = " num2str(trial_length_G/3.3) " s"])) ;

                    % if your estimate is more than two seconds off the expected value it will flag it
                    iter = 0;
                    while tandem_end_G{sub,trial} == 0 || abs(trial_length_G - abs(tandem_start_G{sub,trial}-tandem_end_G{sub,trial})) > 60 
                        if iter >=1
                            disp("Your start and end values do not match the expected trial length");
                        end
                        tandem_start_G{sub,trial} = input("Enter the time (x-value integer) for the start of the trial: ");
                        tandem_end_G{sub,trial} = input(strjoin(["Enter the time (x-value integer) for the end of the trial (estimated" num2str(tandem_start_G{sub,trial} + trial_length_G) ", enter 0 to reselect the start value): "]));
                        iter= iter+1;
                    end
                    GIST_data_cut = GIST_data(tandem_start_G{sub,trial}:tandem_end_G{sub,trial},:);

                    figure; 
                    for i = 2: width(GIST_data_cut)
                        subplot(3,3,i-1)
                        plot(GIST_data_cut(:,i),'r'); 
                        title(Label.GIST(i));
                        
                    end
                    sgtitle(strjoin(["Cut GIST Tandem Data; Selected Trial Length: " num2str(tandem_end_G{sub,trial}-tandem_start_G{sub,trial}) " samples = " num2str((tandem_end_G{sub,trial}-tandem_start_G{sub,trial})/3.3) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    tandem_GIST_all{sub,trial}= GIST_data_cut;
                end

            end

end


%% Cut GIST Romberg

% loop through each subject
% loop through each trial
% get trial length
% plot data
% ask user for start time and/or end time 
% cut to the trial length based on the start/end time the user specified
% and the known length of the trial


%% save data
    % save all of the trials for all subjects
    cd(file_path);
    vars_2_save = ['fmt_GIST_all ' 'fmt_XSENS_all ' 'fmt_EXCEL_all ' ...
        'tandem_GIST_all ' 'tandem_XSENS_all ' 'tandem_EXCEL_all ' ... 
        'romberg_GIST_all ' 'romberg_XSENS_all ' 'romberg_EXCEL_all '... 
        'romberg_GIST_train_all ' 'romberg_XSENS_train_all ' 'romberg_EXCEL_train_all '];
    eval(['  save All_' datatype newdatatype '.mat ' vars_2_save  ' Label vars_2_save']);     
    cd(code_path);
    close all;
