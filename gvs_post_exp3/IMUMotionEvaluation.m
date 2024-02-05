% Created by : Caroline Austin 1/25/24
% This script is reading the IMU data from the GIST to determine the
% maximum angle/ other motion parameters experienced by participants during
% each trial in all 3 functional mobility tests (obstacle course, tandem
% walk, and romberg). It then plots this information. This code was
% developed to help make a decision about future GVS coupling scaling
% parameters. It assumes that the processing scripts and cutting
% scripts have been run.

clc; clear; close all;

%% set up
subnum = [3023:3033];  % Subject List 3023:3033 
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
        load(strjoin([current_participant '_' datatype '.mat'],''));
        cd(code_path);

        % Increment Participant
        participant_num = participant_num + 1;
        sp_participant_list(participant_num) = current_participant;

        for i = 1:24
            max_roll_rom(sub,i) = max(abs(romberg_GIST_sort{1,i}(:,8)));
            mean_roll_rom(sub,i) = mean(abs(romberg_GIST_sort{1,i}(:,8)));
            max_pitch_rom(sub,i) = max(abs(romberg_GIST_sort{1,i}(:,9)));
            mean_pitch_rom(sub,i) = mean(abs(romberg_GIST_sort{1,i}(:,9)));
            max_yaw_rom(sub,i) = max(abs(romberg_GIST_sort{1,i}(:,10)));
            mean_yaw_rom(sub,i) = mean(abs(romberg_GIST_sort{1,i}(:,10)));
        end

        for i = 1:12
            max_roll_tdm(sub,i) = max(abs(tandem_GIST_sort{1,i}(:,8)));
            mean_roll_tdm(sub,i) = mean(abs(tandem_GIST_sort{1,i}(:,8)));
            max_pitch_tdm(sub,i) = max(abs(tandem_GIST_sort{1,i}(:,9)));
            mean_pitch_tdm(sub,i) = mean(abs(tandem_GIST_sort{1,i}(:,9)));
            max_yaw_tdm(sub,i) = max(abs(tandem_GIST_sort{1,i}(:,10)));
            mean_yaw_tdm(sub,i) = mean(abs(tandem_GIST_sort{1,i}(:,10)));
        end

        for i = 1:6
            max_roll_fmt(sub,i) = max(abs(fmt_GIST_sort{1,i}(:,8)));
            mean_roll_fmt(sub,i) = mean(abs(fmt_GIST_sort{1,i}(:,8)));
            max_pitch_fmt(sub,i) = max(abs(fmt_GIST_sort{1,i}(:,9)));
            mean_pitch_fmt(sub,i) = mean(abs(fmt_GIST_sort{1,i}(:,9)));
            max_yaw_fmt(sub,i) = max(abs(fmt_GIST_sort{1,i}(:,10)));
            mean_yaw_fmt(sub,i) = mean(abs(fmt_GIST_sort{1,i}(:,10)));
        end
end

%% plot results

%% FMT Roll 
fig=figure; 
tiledlayout(2,1,'TileSpacing','tight')
nexttile
boxchart(max_roll_fmt)
title('Max Roll FMT');
hold on;
grid on;
grid minor;

for i = 1:height(max_roll_fmt)

        plot([1,2,3,4,5,6]+xoffset2(i),max_roll_fmt(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end
set(gca,'Xticklabel',[])
ylabel([ "Roll Tilt (deg)" ], 'FontSize', 20)

nexttile
boxchart(mean_roll_fmt)
title('Mean Roll FMT');
hold on;
grid on;
grid minor;

for i = 1:height(max_roll_fmt)

        plot([1,2,3,4,5,6]+xoffset2(i),mean_roll_fmt(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end

xticklabels(["0" "0" "1mA" "1mA" "2mA" "2mA"]);
xlabel("GVS Current at 45 deg");
ylabel([ "Roll Tilt (deg)" ], 'FontSize', 20)
fontsize(fig, 30, "points")

%% FMT Pitch 
fig=figure; 
tiledlayout(2,1,'TileSpacing','tight')
nexttile
boxchart(max_pitch_fmt)
title('Max Pitch FMT');
hold on;
grid on;
grid minor;

for i = 1:height(max_pitch_fmt)

        plot([1,2,3,4,5,6]+xoffset2(i),max_pitch_fmt(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end
set(gca,'Xticklabel',[])
ylabel([ "Pitch Tilt (deg)" ], 'FontSize', 20)

nexttile
boxchart(mean_pitch_fmt)
title('Mean Pitch FMT');
hold on;
grid on;
grid minor;

for i = 1:height(max_pitch_fmt)

        plot([1,2,3,4,5,6]+xoffset2(i),mean_pitch_fmt(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end

xticklabels(["0" "0" "1mA" "1mA" "2mA" "2mA"]);
xlabel("GVS Current at 45 deg");
ylabel([ "Pitch Tilt (deg)" ], 'FontSize', 20)
fontsize(fig, 30, "points")

%% Romberg Roll 
fig=figure; 
tiledlayout(2,1,'TileSpacing','tight')
nexttile
boxchart(max_roll_rom)
title('Max Roll Romberg');
hold on;
grid on;
grid minor;

for i = 1:height(max_roll_rom)

        plot([1:24]+xoffset2(i),max_roll_rom(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end
set(gca,'Xticklabel',[])
ylabel([ "Roll Tilt (deg)" ], 'FontSize', 20)

nexttile
boxchart(mean_roll_rom)
title('Mean Roll Romberg');
hold on;
grid on;
grid minor;

for i = 1:height(max_roll_rom)

        plot([1:24]+xoffset2(i),mean_roll_rom(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end

xticklabels(["" "0mA No Head Tilts" "" "" "" "1mA No Head Tilts" "" "" "" "2mA No Head Tilts" "" "" "" "0mA Head Tilts" "" "" "" "1mA Head Tilts" "" "" "" "2mA Head Tilts" "" ""]);
xlabel("GVS Current at 45 deg");
ylabel([ "Roll Tilt (deg)" ], 'FontSize', 20)
fontsize(fig, 15, "points")

%% Romberg Pitch 
fig=figure; 
tiledlayout(2,1,'TileSpacing','tight')
nexttile
boxchart(max_pitch_rom)
title('Max Pitch Romberg');
hold on;
grid on;
grid minor;

for i = 1:height(max_pitch_rom)

        plot([1:24]+xoffset2(i),max_pitch_rom(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end
set(gca,'Xticklabel',[])
ylabel([ "Pitch Tilt (deg)" ], 'FontSize', 20)

nexttile
boxchart(mean_pitch_rom)
title('Mean Pitch Romberg');
hold on;
grid on;
grid minor;

for i = 1:height(max_pitch_rom)

        plot([1:24]+xoffset2(i),mean_pitch_rom(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end

xticklabels(["" "0mA No Head Tilts" "" "" "" "1mA No Head Tilts" "" "" "" "2mA No Head Tilts" "" "" "" "0mA Head Tilts" "" "" "" "1mA Head Tilts" "" "" "" "2mA Head Tilts" "" ""]);
xlabel("GVS Current at 45 deg");
ylabel([ "Pitch Tilt (deg)" ], 'FontSize', 20)
fontsize(fig, 15, "points")

%% Tandem Roll 
fig=figure; 
tiledlayout(2,1,'TileSpacing','tight')
nexttile
boxchart(max_roll_tdm)
title('Max Roll Tandem');
hold on;
grid on;
grid minor;

for i = 1:height(max_roll_tdm)

        plot([1:12]+xoffset2(i),max_roll_tdm(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end
set(gca,'Xticklabel',[])
ylabel([ "Roll Tilt (deg)" ], 'FontSize', 20)

nexttile
boxchart(mean_roll_tdm)
title('Mean Roll Tandem');
hold on;
grid on;
grid minor;

for i = 1:height(max_roll_tdm)

        plot([1:12]+xoffset2(i),mean_roll_tdm(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end

xticklabels(["0" "No Head Tilts EO" "2" "0" "Head Tilts EO" "2" "0" "No Head Tilts EC" "2" "0" "Head Tilts EC" "2"]);
xlabel("GVS Current at 45 deg");
ylabel([ "Roll Tilt (deg)" ], 'FontSize', 20)
fontsize(fig, 30, "points")

%% Tandem Pitch 
fig=figure; 
tiledlayout(2,1,'TileSpacing','tight')
nexttile
boxchart(max_pitch_tdm)
title('Max Pitch Tandem');
hold on;
grid on;
grid minor;

for i = 1:height(max_pitch_tdm)

        plot([1:12]+xoffset2(i),max_pitch_tdm(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end
set(gca,'Xticklabel',[])
ylabel([ "Pitch Tilt (deg)" ], 'FontSize', 20)

nexttile
boxchart(mean_pitch_tdm)
title('Mean Pitch Tandem');
hold on;
grid on;
grid minor;

for i = 1:height(max_pitch_tdm)

        plot([1:12]+xoffset2(i),mean_pitch_tdm(i,:), sub_symbols(i),'MarkerSize',15, 'MarkerEdgeColor', 'k');
        hold on;
end

xticklabels(["0" "No Head Tilts EO" "2" "0" "Head Tilts EO" "2" "0" "No Head Tilts EC" "2" "0" "Head Tilts EC" "2"]);
xlabel("GVS Current at 45 deg");
ylabel([ "Pitch Tilt (deg)" ], 'FontSize', 20)
fontsize(fig, 30, "points")