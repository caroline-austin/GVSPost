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
subnum = [3023:3023];  % Subject List 3001, 
numsub = length(subnum);
subskip = [3002,0];  %DNF'd subjects or subjects that didn't complete this part
% full subject data sets should have:
% FMT: 6 GIST files, (9+ excel rows, 6 XSENS files(?)
% tandem: 12 GIST files, 16(?) excel rows, 12 XSENS files (?)
% Romberg: 30 GIST files (6 training, 24 trials), 18 excel rows (6
% training, 12 trials), 30 XSENS files (6 training, 24 trials)
datatype = ''; % this tells the code which version of the data file to grab (ie. if other data processing has been done)
newdatatype = 'Cut_All'; % this adds the CUT suffix plus the file types that have been cut (GFMT, GTDM, GROM, XFMT, XTDM, XROM or ALL)

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

% cd(file_path);
% load('All.mat');
% cd(code_path);


%% Enter Loop for Each Participant
participant_num = 0;
for sub = 1:(numsub) 
    % get subject number info set up
    subject = subnum(sub);
    subject_str = num2str(subject);

    if subject < 3023 
        current_participant = string(['P' subject_str]);
    else
        current_participant = string(['S' subject_str]);
    end
    % skip participants intended to be skipped    
    if ismember(subject,subskip) == 1
       continue
    end
        % set up pathing and load data
        sub_path = strjoin([file_path, '/' , current_participant], '');
        cd(sub_path);
        load(strjoin([current_participant '.mat'],''));
        cd(code_path);

            % Increment Participant
            participant_num = participant_num + 1;
            sp_participant_list(participant_num) = current_participant;
   %% Cut GIST FMT
            for trial = 1:width(fmt_EXCEL_sort)
                %pull trial info and data 
                trial_info = fmt_EXCEL_sort{trial};
                raw_time = trial_info.RawTime;
                trial_length_X = round(raw_time*30);
                trial_length_G = round(raw_time*3.3);
                XSENS_data = fmt_XSENS_sort{trial};
                GIST_data = fmt_GIST_sort{trial};
                XSENS_length = height(XSENS_data); 
                GIST_length = height(GIST_data); 
                
                % initialize the trial variable (in case it does not get
                % cut that way there aren't errors with saving)
                fmt_start_X{trial} = 0;
                fmt_end_X{trial} =0;
                fmt_start_G{trial} = 0;
                fmt_end_G{trial} =0;
    
                if XSENS_length >1 % && we want to cut the XSENS data
                     clc; close all;

                    % plot data for visualization
                    fig = figure();
                    for i = 2: width(XSENS_data)
                        subplot(3,3,i-1)
                        plot(XSENS_data(:,i),'r'); 
                        title(Label.XSENS(i));
                                    
                    end
                    sgtitle(strjoin(["Uncut XSENS FMT Data; Expected Trial Length: " newline num2str(trial_length_X) " of " num2str(XSENS_length) " samples = "  num2str(trial_length_X/30) " s"])) ;
                  
                    % Enable data cursor mode
                    datacursormode on
                    dcm_obj = datacursormode(fig);
                    % Set update function
                    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    
                    % user selects start and end points of the trial
                    % if your estimate is more than two seconds off the expected value it will flag it
                    iter = 0;
                while fmt_end_X{trial} == 0 || abs(trial_length_X - abs(fmt_start_X{trial}-fmt_end_X{trial})) > 60 
                    if iter >=1
                        disp("Your start and end values do not match the expected trial length");
                    end
                    % Wait while the user to click
                    disp('Click Initial Value, then press "Return"')
                    pause
            
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
    
                    % Set initial data point/index and save into an array
                    fmt_start_X{trial} = info_struct.DataIndex;
    
                    % Wait while the user to click
                    disp(['Click Final Value, then press "Return" (estimated x: ' num2str(fmt_start_X{trial} + trial_length_X) ', select a number less than ' num2str(fmt_start_X{trial}) ' to reselect the start value): '])
                    pause
             
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
                     % Set final data point/index and save into an array
                    fmt_end_X{trial} = info_struct.DataIndex;

                    iter= iter+1;
                end

                    % close figure and cut the data
                    close(fig)
                    Xsens_data_cut = XSENS_data(fmt_start_X{trial}:fmt_end_X{trial},:);

                    % plot cut data and verify that it looks good
                    figure; 
                    for i = 2: width(Xsens_data_cut)
                        subplot(3,3,i-1)
                        plot(Xsens_data_cut(:,i),'r'); 
                        title(Label.XSENS(i));
                        
                    end
                    sgtitle(strjoin(["Cut XSENS FMT Data; Selected Trial Length: " newline num2str(fmt_end_X{trial}-fmt_start_X{trial}) " samples = " num2str((fmt_end_X{trial}-fmt_start_X{trial})/30) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    %over write original data with cut data
                    fmt_XSENS_sort{trial}= Xsens_data_cut;
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if 1==1 % this is a placeholder for checking whether or not we want to cut the GIST data
                    clc; close all;

                    % plot data for visualization
                    fig = figure();
                    for i = 2: width(GIST_data)
                        subplot(3,3,i-1)
                        plot(GIST_data(:,i),'r'); 
                        title(Label.GIST(i));
                                    
                    end
                    sgtitle(strjoin(["Uncut GIST FMT Data; Expected Trial Length: " newline num2str(trial_length_G) " of " num2str(GIST_length) "samples = " num2str(trial_length_G/3.3) " s"])) ;
                  
                    % Enable data cursor mode
                    datacursormode on
                    dcm_obj = datacursormode(fig);
                    % Set update function
                    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    
                    % user selects start and end points of the trial
                    % if your estimate is more than ~3 seconds off the expected value it will flag it
                    iter = 0;
                while fmt_end_G{trial} == 0 || abs(trial_length_G - abs(fmt_start_G{trial}-fmt_end_G{trial})) > 10 
                    if iter >=1
                        disp("Your start and end values do not match the expected trial length");
                    end
                    % Wait while the user to click
                    disp(['Click Initial Value, then press "Return" estimated location: ' num2str(fmt_start_X{trial}/30*3.3) ])
                    pause
            
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
    
                    % Set initial data point/index and save into an array
                    fmt_start_G{trial} = info_struct.DataIndex;
    
                    % Wait while the user to click
                    disp(['Click Final Value, then press "Return" (estimated x: ' num2str(fmt_start_G{trial} + trial_length_G) ', select a number less than ' num2str(fmt_start_G{trial}) ' to reselect the start value): '])
                    pause
             
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
                     % Set final data point/index and save into an array
                    fmt_end_G{trial} = info_struct.DataIndex;

                    iter= iter+1;
                end
                     % close figure and cut the data
                    close(fig)
                    GIST_data_cut = GIST_data(fmt_start_G{trial}:fmt_end_G{trial},:);

                    % plot cut data and verify that it looks good
                    figure; 
                    for i = 2: width(GIST_data_cut)
                        subplot(3,3,i-1)
                        plot(GIST_data_cut(:,i),'r'); 
                        title(Label.GIST(i));
                        
                    end
                    sgtitle(strjoin(["Cut GIST FMT Data; Selected Trial Length: " newline num2str(fmt_end_G{trial}-fmt_start_G{trial}) " samples = " num2str((fmt_end_G{trial}-fmt_start_G{trial})/3.3) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    %over write original data with cut data
                    fmt_GIST_sort{trial}= GIST_data_cut;
                end

            end

%% Cut Tandem

            for trial = 1:width(tandem_EXCEL_sort)
                %pull trial info and data 
                trial_info = tandem_EXCEL_sort{trial};
                raw_time = trial_info.CompletionTime;
                trial_length_X = round(raw_time*30);
                trial_length_G = round(raw_time*3.3);
                XSENS_data = tandem_XSENS_sort{trial};
                GIST_data = tandem_GIST_sort{trial};
                XSENS_length = height(XSENS_data); 
                GIST_length = height(GIST_data);
                
                % initialize the trial variable (in case it does not get
                % cut that way there aren't errors with saving)
                tandem_start_X{trial} = 0;
                tandem_end_X{trial} =0;
                tandem_start_G{trial} = 0;
                tandem_end_G{trial} =0;
    
                if XSENS_length >1 % && we want to cut the XSENS data
                     clc; close all;

                    % plot data for visualization
                    fig = figure();
                    for i = 2: width(XSENS_data)
                                    subplot(3,3,i-1)
                                    plot(XSENS_data(:,i),'r'); 
                                    title(Label.XSENS(i));
                                    
                    end
                    sgtitle(strjoin(["Uncut XSENS Tandem Data; Expected Trial Length: " newline num2str(trial_length_X) " of " num2str(XSENS_length) " samples = " num2str(trial_length_X/30) " s"])) ;
                  
                    % Enable data cursor mode
                    datacursormode on
                    dcm_obj = datacursormode(fig);
                    % Set update function
                    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    
                    % user selects start and end points of the trial
                    % if your estimate is more than two seconds off the expected value it will flag it
                    iter = 0;
                while tandem_end_X{trial} == 0 || abs(trial_length_X - abs(tandem_start_X{trial}-tandem_end_X{trial})) > 60 
                    if iter >=1
                        disp("Your start and end values do not match the expected trial length");
                    end
                    % Wait while the user to click
                    disp('Click Initial Value, then press "Return"')
                    pause
            
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
    
                    % Set initial data point/index and save into an array
                    tandem_start_X{trial} = info_struct.DataIndex;
    
                    % Wait while the user to click
                    disp(['Click Final Value, then press "Return" (estimated x: ' num2str(tandem_start_X{trial} + trial_length_X) ', select a number less than ' num2str(tandem_start_X{trial}) ' to reselect the start value): '])
                    pause
             
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
                     % Set final data point/index and save into an array
                    tandem_end_X{trial} = info_struct.DataIndex;

                    iter= iter+1;
                end

                    % close figure and cut the data
                    close(fig)
                    Xsens_data_cut = XSENS_data(tandem_start_X{trial}:tandem_end_X{trial},:);

                    % plot cut data and verify that it looks good
                    figure; 
                    for i = 2: width(Xsens_data_cut)
                        subplot(3,3,i-1)
                        plot(Xsens_data_cut(:,i),'r'); 
                        title(Label.XSENS(i));
                        
                    end
                    sgtitle(strjoin(["Cut XSENS Tandem Data; Selected Trial Length: " newline num2str(tandem_end_X{trial}-tandem_start_X{trial}) " samples = " num2str((tandem_end_X{trial}-tandem_start_X{trial})/30) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    %over write original data with cut data
                    tandem_XSENS_sort{trial}= Xsens_data_cut;
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if 1==1 % this is a placeholder for checking whether or not we want to cut the GIST data
                    clc; close all;

                    % plot data for visualization
                    fig = figure();
                    for i = 2: width(GIST_data)
                        subplot(3,3,i-1)
                        plot(GIST_data(:,i),'r'); 
                        title(Label.GIST(i));
                                    
                    end
                    sgtitle(strjoin(["Uncut GIST Tandem Data; Expected Trial Length: " newline num2str(trial_length_G) " of " num2str(GIST_length) " samples = " num2str(trial_length_G/3.3) " s"])) ;
                  
                    % Enable data cursor mode
                    datacursormode on
                    dcm_obj = datacursormode(fig);
                    % Set update function
                    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    
                    % user selects start and end points of the trial
                    % if your estimate is more than ~3 seconds off the expected value it will flag it
                    iter = 0;
                while tandem_end_G{trial} == 0 || abs(trial_length_G - abs(tandem_start_G{trial}-tandem_end_G{trial})) > 10 
                    if iter >=1
                        disp("Your start and end values do not match the expected trial length");
                    end
                    % Wait while the user to click
                    disp(['Click Initial Value, then press "Return" estimated location: ' num2str(tandem_start_X{trial}/30*3.3) ])
                    pause
            
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
    
                    % Set initial data point/index and save into an array
                    tandem_start_G{trial} = info_struct.DataIndex;
    
                    % Wait while the user to click
                    disp(['Click Final Value, then press "Return" (estimated x: ' num2str(tandem_start_G{trial} + trial_length_G) ', select a number less than ' num2str(tandem_start_G{trial}) ' to reselect the start value): '])
                    pause
             
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
                     % Set final data point/index and save into an array
                    tandem_end_G{trial} = info_struct.DataIndex;

                    iter= iter+1;
                end
                     % close figure and cut the data
                    close(fig)
                    GIST_data_cut = GIST_data(tandem_start_G{trial}:tandem_end_G{trial},:);

                    % plot cut data and verify that it looks good
                    figure; 
                    for i = 2: width(GIST_data_cut)
                        subplot(3,3,i-1)
                        plot(GIST_data_cut(:,i),'r'); 
                        title(Label.GIST(i));
                        
                    end
                    sgtitle(strjoin(["Cut GIST Tandem Data; Selected Trial Length: " newline num2str(tandem_end_G{trial}-tandem_start_G{trial}) " samples = " num2str((tandem_end_G{trial}-tandem_start_G{trial})/3.3) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    %over write original data with cut data
                    tandem_GIST_sort{trial}= GIST_data_cut;
                end

            end

%% Cut GIST Romberg

            for trial = 1:width(romberg_EXCEL_sort)
                %pull trial info and data 
                trial_info = romberg_EXCEL_sort{trial};
                if rem(trial,2) ==0
                    raw_time = trial_info.TimeOfFailure2;
                else
                    raw_time = trial_info.TimeOfFailure1;
                end
                trial_length_X = round(raw_time*30);
                trial_length_G = round(raw_time*3.3);
                XSENS_data = romberg_XSENS_sort{trial};
                GIST_data = romberg_GIST_sort{trial};
                XSENS_length = height(XSENS_data); 
                GIST_length = height(GIST_data);

                % initialize the trial variable (in case it does not get
                % cut that way there aren't errors with saving)
                romberg_start_X{trial} = 0;
                romberg_end_X{trial} =0;
                romberg_start_G{trial} = 0;
                romberg_end_G{trial} =0;
    
                if XSENS_length >1 % && we want to cut the XSENS data
                     clc; close all;

                    % plot data for visualization
                    fig = figure();
                    for i = 2: width(XSENS_data)
                                    subplot(3,3,i-1)
                                    plot(XSENS_data(:,i),'r'); 
                                    title(Label.XSENS(i));
                                    
                    end
                    sgtitle(strjoin(["Uncut XSENS Romberg Data; Expected Trial Length: " newline num2str(trial_length_X) " of " num2str(XSENS_length) " samples = " num2str(trial_length_X/30) " s"])) ;
                  
                    % Enable data cursor mode
                    datacursormode on
                    dcm_obj = datacursormode(fig);
                    % Set update function
                    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    
                    % user selects start and end points of the trial
                    % if your estimate is more than two seconds off the expected value it will flag it
                    iter = 0;
                while romberg_end_X{trial} == 0 || abs(trial_length_X - abs(romberg_start_X{trial}-romberg_end_X{trial})) > 60 
                    if iter >=1
                        disp("Your start and end values do not match the expected trial length");
                    end
    
                    % Wait while the user to click
                    disp(['Click Final Value, then press "Return" '])
                    pause
             
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
                     % Set final data point/index and save into an array
                    romberg_end_X{trial} = info_struct.DataIndex;

                    % Wait while the user to click
                    disp(['Click Initial Value, then press "Return" (estimated x: ' num2str(romberg_end_X{trial} - trial_length_X) ', select a number greater than ' num2str(romberg_end_X{trial}) ' to reselect the start value): '])
                    pause
            
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
    
                    % Set initial data point/index and save into an array
                    romberg_start_X{trial} = info_struct.DataIndex;

                    iter= iter+1;
                end

                    % close figure and cut the data
                    close(fig)
                    Xsens_data_cut = XSENS_data(romberg_start_X{trial}:romberg_end_X{trial},:);

                    % plot cut data and verify that it looks good
                    figure; 
                    for i = 2: width(Xsens_data_cut)
                        subplot(3,3,i-1)
                        plot(Xsens_data_cut(:,i),'r'); 
                        title(Label.XSENS(i));
                        
                    end
                    sgtitle(strjoin(["Cut XSENS Romberg Data; Selected Trial Length: " newline num2str(romberg_end_X{trial}-romberg_start_X{trial}) " samples = " num2str((romberg_end_X{trial}-romberg_start_X{trial})/30) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    %over write original data with cut data
                    romberg_XSENS_sort{trial}= Xsens_data_cut;
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if 1==1 % this is a placeholder for checking whether or not we want to cut the GIST data
                    clc; close all;

                    % plot data for visualization
                    fig = figure();
                    for i = 2: width(GIST_data)
                        subplot(3,3,i-1)
                        plot(GIST_data(:,i),'r'); 
                        title(Label.GIST(i));
                                    
                    end
                    sgtitle(strjoin(["Uncut GIST Romberg Data; Expected Trial Length: " newline num2str(trial_length_G) " of " num2str(GIST_length) " samples = " num2str(trial_length_G/3.3) " s"])) ;
                  
                    % Enable data cursor mode
                    datacursormode on
                    dcm_obj = datacursormode(fig);
                    % Set update function
                    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    
                    % user selects start and end points of the trial
                    % if your estimate is more than ~3 seconds off the expected value it will flag it
                    iter = 0;
                while romberg_end_G{trial} == 0 || abs(trial_length_G - abs(romberg_start_G{trial}-romberg_end_G{trial})) > 10 
                    if iter >=1
                        disp("Your start and end values do not match the expected trial length");
                    end
    
                    % Wait while the user to click
                    disp(['Click Final Value, then press "Return" estimated location: ' num2str(romberg_end_X{trial}/30*3.3) ])
                    pause
             
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
                     % Set final data point/index and save into an array
                    romberg_end_G{trial} = info_struct.DataIndex;

                                        % Wait while the user to click
                    disp(['Click Initial Value, then press "Return" (estimated x: ' num2str(romberg_end_G{trial} - trial_length_G) ', select a number greater than ' num2str(romberg_end_G{trial}) ' to reselect the start value): '])
                    pause
            
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    if isfield(info_struct, 'Position')
                      disp('Clicked positioin is')
                      disp(info_struct.Position)
                    end
    
                    % Set initial data point/index and save into an array
                    romberg_start_G{trial} = info_struct.DataIndex;

                    iter= iter+1;
                end
                     % close figure and cut the data
                    close(fig)
                    GIST_data_cut = GIST_data(romberg_start_G{trial}:romberg_end_G{trial},:);

                    % plot cut data and verify that it looks good
                    figure; 
                    for i = 2: width(GIST_data_cut)
                        subplot(3,3,i-1)
                        plot(GIST_data_cut(:,i),'r'); 
                        title(Label.GIST(i));
                        
                    end
                    sgtitle(strjoin(["Cut GIST Romberg Data; Selected Trial Length: " newline num2str(romberg_end_G{trial}-romberg_start_G{trial}) " samples = " num2str((romberg_end_G{trial}-romberg_start_G{trial})/3.3) " s" ])) ;
                     disp("\n Please verify plot and then press any key to continue");
                    pause; % ideally would put this in a while loop where here the user can check again whether they are satisfied 

                    %over write original data with cut data
                    romberg_GIST_sort{trial}= GIST_data_cut;
                end

            end


    %% save data
    % save all of the trials for all subjects
    cd(sub_path);
    vars_2_save = [' fmt_GIST_sort ' 'fmt_XSENS_sort ' 'fmt_EXCEL_sort ' ...
        'tandem_GIST_sort ' 'tandem_XSENS_sort ' 'tandem_EXCEL_sort ' ... 
        'romberg_GIST_sort ' 'romberg_XSENS_sort ' 'romberg_EXCEL_sort '... 
        'romberg_GIST_train_sort ' 'romberg_XSENS_train_sort ' 'romberg_EXCEL_train_sort ' ...
        'fmt_start_G ' 'fmt_end_G ' 'fmt_start_X ' 'fmt_end_X ' ...
        'tandem_start_G ' 'tandem_end_G ' 'tandem_start_X ' 'tandem_end_X ' ...
        'romberg_start_G ' 'romberg_end_G ' 'romberg_start_X ' 'romberg_end_X ' ];
        eval( strjoin(['  save ' strjoin([current_participant '_' datatype newdatatype '.mat '],'') vars_2_save  ' Label vars_2_save' ]));     
    cd(code_path);
    close all;
end

%%
    function output_txt = myupdatefcn(~,event_obj)

  % ~            Currently not used (empty)

  % event_obj    Object containing event data structure

  % output_txt   Data cursor text

  pos = get(event_obj, 'Position');

  output_txt = {['x: ' num2str(pos(1))], ['y: ' num2str(pos(2))]};

end