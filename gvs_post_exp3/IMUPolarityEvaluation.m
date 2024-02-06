% Created by : Caroline Austin 2/5/24
% This script is reading the IMU data from the GIST and using the first
% step information from the tandem walk test to determine the coupling
% polarity of the GIST for a given participant. (we belive the IMU was
% mounted upside down for some of the participants and since the head tilts
% (and head tilt direction) during the tandem walk was coupled to the steps
% it should allow us to determine whether the coupling polarity was
% reversed or not. The script assumes that the processing scripts and
% cutting scripts have been run. Pull Data from:
% C:\Users\caroa\UCB-O365\Bioastronautics File Repository - File Repository\Torin Group Items\Projects\Motion Coupled GVS\FunctionalMobilityTesting\Data

clc; clear; close all;

% manually pulled from the excel spreadsheet -1 = left foot first, 1 = right
% foot first- the index 1-10 indicates the participant order
first_step = [-1; -1; -1; 1;1;1;1;1;1;-1;1];

%% set up
subnum = [3023:3033];  % Subject List 3023:3033 
numsub = length(subnum);
subskip = [3002,0];  %DNF'd subjects or subjects that didn't complete this part
% full subject data sets should have:
% FMT: 6 GIST files, (9+ excel rows, 6 XSENS files(?)
% tandem: 12 GIST files, 16(?) excel rows, 12 XSENS files (?)
% Romberg: 30 GIST files (6 training, 24 trials), 18 excel rows (6
% training, 12 trials), 30 XSENS files (6 training, 24 trials)

datatype = ''; %'Cut_All'; % this tells the code which version of the data file to grab (ie. if other data processing has been done)
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
xoffset2 = [-0.25;-0.2;-0.15;-0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

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

% Set Plot Locations
plot_path = [file_path '/plots/'];        
metric_path = [file_path '/Metrics/'];  

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
        % load(strjoin([current_participant '_' datatype '.mat'],''));
        load(strjoin([current_participant datatype '.mat'],''));
        cd(code_path);

        % Increment Participant
        participant_num = participant_num + 1;
        sp_participant_list(participant_num) = current_participant;

        figure;
        plot(tandem_GIST_sort{1,4}(:,8)*first_step(sub))
        hold on;
        plot(tandem_GIST_sort{1,5}(:,8)*first_step(sub))
        hold on;
        plot(tandem_GIST_sort{1,6}(:,8)*first_step(sub))
        hold on;

        plot(tandem_GIST_sort{1,10}(:,8)*first_step(sub))
        hold on;
        plot(tandem_GIST_sort{1,11}(:,8)*first_step(sub))
        hold on;
        plot(tandem_GIST_sort{1,12}(:,8)*first_step(sub))
        hold on;
       
        
end