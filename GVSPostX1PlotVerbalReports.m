close all; 
clear all; 
clc; 

%% initialize  

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];

% %naming variables 
% % Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
% % Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
% num_profiles = length(Profiles);
% num_config = 3;


%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '/Plots/VerbalReports']; % specify where plots are saved
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 1017:1022;  % Subject List 

subskip = [1013 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

% should probably insert a for loop that checks to make sure this file exists first
cd([file_path]);
load(['All_X2A.mat']); 
cd(code_path);

% [row, col, depth] = size(All_Tingle_map1);
% All_map = zeros(row, col);

% MapAreaPlot(All_Tingle_map1(:,:,1),Title,numsub)
num_sub = length(subject_label); 
numsub = 100;

%% Tingling 
figure;
Title = "Reported Tingling Sensation";
MapAreaPlot(All_Tingle_map([1,3:8],:),Title,numsub, ["none", "slight", "moderate", "severe"],Color_list)
Current_levels_str = ["0" "0.25" ".5"  "0.75" "1" "1.25" "1.5"];
xticks([1 2 3 4 5 6 7]);
xticklabels(Current_levels_str);
xlim ([1 7])
ylim ([0 num_sub])
%add labels and info to the plot
ylabel("Number of Responses", "FontSize", 35)
xlabel("Current mA", "FontSize", 37)
lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38, 'Location', 'southwest' );

Filename = char(strjoin(["TingleRatingsSin1HzAllCurrentAreaPlot"]));
        
%save plot
cd(plots_path);
saveas(gcf, [char(Filename) '.fig']);
cd(code_path);

%% Metallic Taste
figure;
Title = "Reported Metallic Taste";
MapAreaPlot(All_Metallic_map([1,3:8],:),Title,numsub, ["none", "slight", "moderate", "severe"],Color_list)
Current_levels_str = ["0" "0.25" ".5"  "0.75" "1" "1.25" "1.5"];
xticks([1 2 3 4 5 6 7]);
xticklabels(Current_levels_str);
xlim ([1 7])
ylim ([0 num_sub])
%add labels and info to the plot
ylabel("Number of Responses", "FontSize", 35)
xlabel("Current mA", "FontSize", 37)
lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38, 'Location', 'southwest' );

Filename = char(strjoin(["MetallicRatingsSin1HzAllCurrentAreaPlot"]));
        
%save plot
cd(plots_path);
saveas(gcf, [char(Filename) '.fig']);
cd(code_path);

%% Visual Flashes
figure;
Title = "Reported Visual Flashes";
MapAreaPlot(All_VisFlash_map([1,3:8],:),Title,numsub, ["none", "slight", "moderate", "severe"],Color_list)
Current_levels_str = ["0" "0.25" ".5"  "0.75" "1" "1.25" "1.5"];
xticks([1 2 3 4 5 6 7]);
xticklabels(Current_levels_str);
xlim ([1 7])
ylim ([0 num_sub])
%add labels and info to the plot
ylabel("Number of Responses", "FontSize", 35)
xlabel("Current mA", "FontSize", 37)
lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38, 'Location', 'southwest' );

Filename = char(strjoin(["VisFlashRatingsSin1HzAllCurrentAreaPlot"]));
        
%save plot
cd(plots_path);
saveas(gcf, [char(Filename) '.fig']);
cd(code_path);
%% Motion Sensation
figure;
Title = "Reported Motion Sensation";
MapAreaPlot(All_MotionRating_map([1,3:8],:),Title,numsub, ["none", "slight", "moderate", "severe"],Color_list)
Current_levels_str = ["0" "0.25" ".5"  "0.75" "1" "1.25" "1.5"];
xticks([1 2 3 4 5 6 7]);
xticklabels(Current_levels_str);
xlim ([1 7])
ylim ([0 num_sub])
%add labels and info to the plot
ylabel("Number of Responses", "FontSize", 35)
xlabel("Current mA", "FontSize", 37)
lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38, 'Location', 'southwest' );

Filename = char(strjoin(["MotionRatingsSin1HzAllCurrentAreaPlot"]));
        
%save plot
cd(plots_path);
saveas(gcf, [char(Filename) '.fig']);
cd(code_path);