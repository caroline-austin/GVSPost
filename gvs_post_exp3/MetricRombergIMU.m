% script 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        % This script takes the organized subject/trial data assumes that
        % it has been cut and then calculates the corresponding metrics
        % from the Romberg data
        
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

%% set up
subnum = [3023:3033];  % Subject List 3001, 
numsub = length(subnum);
subskip = [3002,0];  %DNF'd subjects or subjects that didn't complete this part
% full subject data sets should have:
% FMT: 6 GIST files, (9+ excel rows, 6 XSENS files(?)
% tandem: 12 GIST files, 16(?) excel rows, 12 XSENS files (?)
% Romberg: 30 GIST files (6 training, 24 trials), 18 excel rows (6
% training, 12 trials), 30 XSENS files (6 training, 24 trials)
datatype = 'Cut_All'; % this tells the code which version of the data file to grab (ie. if other data processing has been done)
newdatatype = ''; % this adds the CUT suffix plus the file types that have been cut (GFMT, GTDM, GROM, XFMT, XTDM, XROM or ALL)

fsX = 30; %Hz = sampling freq of the XSENS IMU
fsG = 3.3; % Hz = approximate sampling frequency of the GIST
numtrials = 24;

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];
% sub_symbols = [">-k"; "v-k";"o-k";"+-k"; "*-k"; "x-k"; "square-k"; "^-k"; "<-k"; "pentagram-k"; "diamond-k"];
sub_symbols = [">k"; "vk";"ok";"+k"; "*k"; "xk"; "squarek"; "^k"; "<k"; "pentagramk"; "diamondk"];
sub_symbols_2 = [">m"; "vm";"om";"+m"; "*m"; "xm"; "squarem"; "^m"; "<m"; "pentagramm"; "diamondm"];
sub_symbols_3 = [">r"; "vr";"or";"+r"; "*r"; "xr"; "squarer"; "^r"; "<r"; "pentagramr"; "diamondr"];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
xoffset = [-0.02;-0.01;0;0.01;0.02;-0.02;-0.01;0;0.01;0.02;0]; 

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
metric_path = [file_path '/Metrics/'];  

%% Initialize Storage Variables
numsub = length(subnum);
% Initialize variables for sway data
accel(numsub,numtrials).x = 0;
accel(numsub,numtrials).y = 0;
accel(numsub,numtrials).z = 0;
vel(numsub,numtrials).x = 0;
vel(numsub,numtrials).y = 0;
vel(numsub,numtrials).z = 0;
pos(numsub,numtrials).x = 0;
pos(numsub,numtrials).y = 0;
pos(numsub,numtrials).z = 0;

% Initialize variables for balance metrics
rmsXYa = NaN(numsub,numtrials);
rmsXa = rmsXYa; rmsYa = rmsXYa;
p2pXa = rmsXYa; p2pYa = p2pXa;
rmsXa_fail = rmsXYa; rmsYa_fail = rmsXYa;
p2pXa_fail = rmsXYa; p2pYa_fail = p2pXa;
rmsXa_fail_2 = rmsXYa; rmsYa_fail_2 = rmsXYa;
p2pXa_fail_2 = rmsXYa; p2pYa_fail_2 = p2pXa;

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
        load(strjoin([current_participant '_' datatype '.mat'],''));
        cd(code_path);

        % Increment Participant
        participant_num = participant_num + 1;
        sp_participant_list(participant_num) = current_participant;

               %% romberg IMU data
        for trial = 1:width(romberg_EXCEL_sort)
            % get/setup trial information    
            trial_info = romberg_EXCEL_sort{trial};
            if rem(trial,2) ==0
                raw_time = trial_info.TimeOfFailure2;
            else
                raw_time = trial_info.TimeOfFailure1;
            end
            trial_length_X = round(raw_time*30);
            trial_length_G = round(raw_time*3.3);
            XSENS_data = romberg_XSENS_sort{trial};
            XSENS_acc = XSENS_data(:,5:7);
            XSENS_time = XSENS_data(:,1);
            GIST_data = romberg_GIST_sort{trial};
            XSENS_length = height(XSENS_acc); 
            GIST_length = height(GIST_data);

            % Store state information
            accel(sub,trial).x = XSENS_acc(:,1);
            accel(sub,trial).y = XSENS_acc(:,2);
            accel(sub,trial).z = XSENS_acc(:,3);
            vel(sub,trial).x = ...
                cumtrapz(XSENS_time,XSENS_acc(:,1));
            vel(sub,trial).y = ...
                cumtrapz(XSENS_time,XSENS_acc(:,2));
            vel(sub,trial).z = ...
                cumtrapz(XSENS_time,XSENS_acc(:,3));
            pos(sub,trial).x = ...
                cumtrapz(XSENS_time,cumtrapz(XSENS_time,XSENS_acc(:,1)));
            pos(sub,trial).y = ...
                cumtrapz(XSENS_time,cumtrapz(XSENS_time,XSENS_acc(:,2)));
            pos(sub,trial).z = ...
                cumtrapz(XSENS_time,cumtrapz(XSENS_time,XSENS_acc(:,3)));

            % METRICS
            if XSENS_length > 14.5*fsX && raw_time == 15
                rmsxy = rms([XSENS_acc(fsX:14*fsX,1), XSENS_acc(fsX:14*fsX,2)]); % cut one second off the start and end of the trial
                p2pa = peak2peak(XSENS_acc(fsX:14*fsX,:));
            %%% Acceleration metrics
            % rms metrics
%             rmsXYa(sub,trial) = sqrt(1/2*(rmsxy(1)^2+rmsxy(2)^2));
            rmsXYa(sub,trial) = sqrt((rmsxy(1)^2+rmsxy(2)^2));
            rmsXa(sub,trial) = rmsxy(1);
            rmsYa(sub,trial) = rmsxy(2);
            % peak-to-peak metrics
            p2pXa(sub,trial) = p2pa(1); 
            p2pYa(sub,trial) = p2pa(2); 

            % fftX(sub,trial,:) = fft(XSENS_acc(fsX:14*fsX,1));
            % fftY(sub,trial,:) = fft(XSENS_acc(fsX:14*fsX,2));
            
            elseif XSENS_length > 2*fsX
                rmsxy = rms([XSENS_acc(end-1.5*fsX:end-0.5*fsX,1), XSENS_acc(end-1.5*fsX: end-0.5*fsX,2)]); % cut one second off the start and end of the trial
                p2pa = peak2peak(XSENS_acc(end-1.5*fsX:end-.5*fsX,:));
                %%% Acceleration metrics
                % rms metrics
    %             rmsXYa(sub,trial) = sqrt(1/2*(rmsxy(1)^2+rmsxy(2)^2));
                rmsXYa_fail(sub,trial) = sqrt((rmsxy(1)^2+rmsxy(2)^2));
                rmsXa_fail(sub,trial) = rmsxy(1);
                rmsYa_fail(sub,trial) = rmsxy(2);
                % peak-to-peak metrics
                p2pXa_fail(sub,trial) = p2pa(1); 
                p2pYa_fail(sub,trial) = p2pa(2); 
            else
               rmsxy = rms([XSENS_acc(:,1), XSENS_acc(:,2)]); % cut one second off the start and end of the trial
                p2pa = peak2peak(XSENS_acc);
                %%% Acceleration metrics
                % rms metrics
    %             rmsXYa(sub,trial) = sqrt(1/2*(rmsxy(1)^2+rmsxy(2)^2));
                rmsXYa_fail_2(sub,trial) = sqrt((rmsxy(1)^2+rmsxy(2)^2));
                rmsXa_fail_2(sub,trial) = rmsxy(1);
                rmsYa_fail_2(sub,trial) = rmsxy(2);
                % peak-to-peak metrics
                p2pXa_fail_2(sub,trial) = p2pa(1); 
                p2pYa_fail_2(sub,trial) = p2pa(2);  
            end

        end

end
%% plot results
figure;
for i = 1:height(p2pXa)
    plot(p2pXa(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
    plot(p2pXa_fail(i,:), sub_symbols_2(i),'MarkerSize',15);
    hold on;
    plot(p2pXa_fail_2(i,:), sub_symbols_3(i),'MarkerSize',15);
    hold on;
end
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24]);
xticklabels( strrep(Label.romberg, '_',''));
title("Romberg Peak 2 Peak X")
ylabel("distance ", 'FontSize', 20)
xlabel("Condition", 'FontSize', 20)

figure;
for i = 1:height(rmsXa)
    plot(rmsXa(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
    plot(rmsXa_fail(i,:), sub_symbols_2(i),'MarkerSize',15);
    hold on;
    plot(rmsXa_fail_2(i,:), sub_symbols_3(i),'MarkerSize',15);
    hold on;
end
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24]);
xticklabels( strrep(Label.romberg, '_',''));
title("Romberg RMS X")
ylabel("distance ", 'FontSize', 20)
xlabel("Condition", 'FontSize', 20)

%% save

    cd(metric_path);
    vars_2_save = [' rmsXYa ' ' rmsXa ' ' rmsYa ' ' p2pXa ' ' p2pYa '...
        ' rmsXYa_fail ' ' rmsXa_fail ' ' rmsYa_fail '  ' p2pXa_fail ' ' p2pYa_fail '...
        ' rmsXYa_fail_2 ' ' rmsXa_fail_2 ' ' rmsYa_fail_2 '  ' p2pXa_fail_2 ' ' p2pYa_fail_2 ' ];
        % 'tandem_GIST_sort ' 'tandem_XSENS_sort ' 'tandem_EXCEL_sort ' ... 
        % 'romberg_GIST_sort ' 'romberg_XSENS_sort ' 'romberg_EXCEL_sort '... 
        % 'romberg_GIST_train_sort ' 'romberg_XSENS_train_sort ' 'romberg_EXCEL_train_sort ' ...
        % 'fmt_start_G ' 'fmt_end_G ' 'fmt_start_X ' 'fmt_end_X ' ...
        % 'tandem_start_G ' 'tandem_end_G ' 'tandem_start_X ' 'tandem_end_X ' ...
        % 'romberg_start_G ' 'romberg_end_G ' 'romberg_start_X ' 'romberg_end_X ' ];
        %can add data aggregation saving later
        eval( strjoin(['  save ' strjoin([ "RombergIMU_" datatype newdatatype '.mat '],'') vars_2_save  ' Label vars_2_save' ]));     
    cd(code_path);

    % close all;

    %%
