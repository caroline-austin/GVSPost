%run aggregate first
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
sub_symbols = [">k"; "vk";"ok";"+k"; "*k"; "xk"; "squarek"; "^k"; "<k"; "pentagramk"];

yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1]; 
xoffset = [-0.2;-0.1;0;0.1;0.2;-0.2;-0.1;0;0.1;0.2]; 

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

subnum = 1014:1022;  % Subject List 

subskip = [1011 1012 1013 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

% should probably insert a for loop that checks to make sure this file exists first
cd([file_path]);
load(['All_X2A.mat']); 
cd(code_path);

% [row, col, depth] = size(All_Tingle_map1);
% All_map = zeros(row, col);

% MapAreaPlot(All_Tingle_map1(:,:,1),Title,numsub)
num_sub = abs(subject_label(1)- subject_label(end))+1; 
numsub = 100;
used_sub = 0;

%% Tingling 
figure;
% subplot(2,2,2)
Title = "Reported Tingling Sensation";
MapAreaPlot(All_Tingle_map([1,3:8],:),Title,numsub, ["none", "slight", "moderate", ""],Color_list)
Current_levels_str = ["0" "0.25" ".5"  "0.75" "1" "1.25" "1.5"];
xticks([1 2 3 4 5 6 7]);
xticklabels(Current_levels_str);
xlim ([.75 7.25])

%add labels and info to the plot
ylabel("Number of Responses", "FontSize", 35)
xlabel("Current mA", "FontSize", 37)

hold on; 
%     set(gca, 'color', [0 0 0]);

hold on;

[y_val,used_sub] = GetSubjectSymbolLocation(num_sub,subnum,subskip, file_path,'text', 'Tingle_map([1 3:8],:)', All_Tingle_map([1 3:8],:), yoffset);
ylim ([0 used_sub])
    for sub = 1:used_sub
        plot([1 2 3 4 5 6 7]+xoffset(sub), y_val(1:7,sub), sub_symbols(sub), 'MarkerSize',15); %Label.CurrentAmp([1 3:8])
    end

lgd = legend('none','slight', 'moderate', '', 'FontSize', 35, 'Location', 'southwest' );
lgd.Color =  [1 1 1];
Filename = char(strjoin(["TingleRatingsSin1HzAllCurrentAreaPlot"]));

%save plot
cd(plots_path);
saveas(gcf, [char(Filename) '.fig']);
cd(code_path);

%% Metallic Taste
figure;
% subplot(2,2,3);
Title = "Reported Metallic Taste";
MapAreaPlot(All_Metallic_map([1,3:8],:),Title,numsub, ["none", "slight", "moderate", ""],Color_list)
Current_levels_str = ["0" "0.25" ".5"  "0.75" "1" "1.25" "1.5"];
xticks([1 2 3 4 5 6 7]);
xticklabels(Current_levels_str);
xlim ([.75 7.25])

%add labels and info to the plot
ylabel("Number of Responses", "FontSize", 35)
xlabel("Current mA", "FontSize", 37)
hold on; 
%     set(gca, 'color', [0 0 0]);

hold on;

[y_val,used_sub] = GetSubjectSymbolLocation(num_sub,subnum,subskip, file_path,'text', 'Metallic_map([1 3:8],:)', All_Metallic_map([1 3:8],:), yoffset);
ylim ([0 used_sub])
    for sub = 1:used_sub
        plot([1 2 3 4 5 6 7]+xoffset(sub), y_val(:,sub), sub_symbols(sub), 'MarkerSize',15); %Label.CurrentAmp([1 3:8])
    end

lgd = legend('none','slight', 'moderate', '', 'FontSize', 35, 'Location', 'southwest' );
lgd.Color =  [1 1 1];

Filename = char(strjoin(["MetallicRatingsSin1HzAllCurrentAreaPlot"]));

%save plot
cd(plots_path);
saveas(gcf, [char(Filename) '.fig']);
cd(code_path);

%% Visual Flashes
figure;
% subplot(2,2,4)
Title = "Reported Visual Flashes";
MapAreaPlot(All_VisFlash_map([1,3:8],:),Title,numsub, ["none", "slight", "moderate", ""],Color_list)
Current_levels_str = ["0" "0.25" ".5"  "0.75" "1" "1.25" "1.5"];
xticks([1 2 3 4 5 6 7]);
xticklabels(Current_levels_str);
xlim ([.75 7.25])

%add labels and info to the plot
ylabel("Number of Responses", "FontSize", 35)
xlabel("Current mA", "FontSize", 37)
hold on; 
%     set(gca, 'color', [0 0 0]);

hold on;

[y_val, used_sub] = GetSubjectSymbolLocation(num_sub,subnum,subskip, file_path,'text', 'VisFlash_map([1 3:8],:)', All_VisFlash_map([1 3:8],:), yoffset);
ylim ([0 used_sub])
    for sub = 1:used_sub
        plot([1 2 3 4 5 6 7]+xoffset(sub), y_val(:,sub), sub_symbols(sub), 'MarkerSize',15); %Label.CurrentAmp([1 3:8])
    end

lgd = legend('none','slight', 'moderate', '', 'FontSize', 35, 'Location', 'southwest' );
lgd.Color =  [1 1 1];

Filename = char(strjoin(["VisFlashRatingsSin1HzAllCurrentAreaPlot"]));

%save plot
cd(plots_path);
saveas(gcf, [char(Filename) '.fig']);
cd(code_path);
%% Motion Sensation
f=figure;
% subplot(2,2,1)
Title = "Reported Motion Sensation";
MapAreaPlot(All_MotionRating_map([1,3:8],:),Title,numsub, ["none", "slight", "moderate", ""],Color_list)
Current_levels_str = ["0" "0.25" ".5"  "0.75" "1" "1.25" "1.5"];
xticks([1 2 3 4 5 6 7]);
xticklabels(Current_levels_str);
xlim ([.75 7.25])

%add labels and info to the plot
ylabel("Number of Responses", "FontSize", 35)
xlabel("Current mA", "FontSize", 37)

hold on; 
%     set(gca, 'color', [0 0 0]);

hold on;

[y_val,used_sub] = GetSubjectSymbolLocation(num_sub,subnum,subskip, file_path,'text', 'MotionRating_map([1 3:8],:)', All_MotionRating_map([1 3:8],:), yoffset);
ylim ([0 used_sub])
    for sub = 1:used_sub
        plot([1 2 3 4 5 6 7]+xoffset(sub), y_val(:,sub), sub_symbols(sub), 'MarkerSize',15,"LineWidth", 1.5); %Label.CurrentAmp([1 3:8])
    end

lgd = legend('none','slight', 'moderate', '', 'FontSize', 35, 'Location', 'southwest' );
lgd.Color =  [1 1 1];
f.Position= [100 100 1200 600]

Filename = char(strjoin(["MotionRatingsSin1HzAllCurrentAreaPlot"]));
%   Filename = char(strjoin(["AllRatingsSin1HzAllCurrentAreaPlot"]));      
%save plot
cd(plots_path);
saveas(gcf, [char(Filename) '.fig']);
cd(code_path);

function [y_val,used_sub] = GetSubjectSymbolLocation(num_sub,subnum,subskip, file_path, filename, var_name, All_var, yoffset)
%     y_val = zeros(num_sub,length(All_var)); % using num_sub here might cause issues later 
    used_sub = 0;
    code_path = pwd;
    for sub = 1:num_sub
        subject = subnum(sub);
        subject_str = num2str(subject);
        % skip subjects that DNF'd or there is no data for
        if ismember(subject,subskip) == 1
           continue
        end
        used_sub = used_sub +1;
        subject_label(used_sub)= subject;
        Label.Subject(used_sub)= subject;
        cd([file_path, '/' , subject_str]);
        load(['A' subject_str 'Extract.mat']) % figure out how to incorporate filename later so that this function can be reused
        cd(code_path);
        var=zeros(size(All_var));
        eval(['var = ' var_name ';'] );

                
                
        for row  = 1:length(var)
            col = find(var(row,:));
           
            if isempty(col) && row >1
               y_val(row,used_sub) = num_sub -0.5;% I'm confused by this line of code
            elseif isempty(col)
                continue
            else
               num_same_responses = All_var(row, col);
               num_less_eq_responses = sum(All_var(row, 1:col));
               if row == 1 %this will need to be removed for generalization
                y_val(row,used_sub) = (num_less_eq_responses/2 - num_same_responses/4)+yoffset(used_sub);
               else
                y_val(row,used_sub) = (num_less_eq_responses - num_same_responses/2)+yoffset(used_sub);
               end
    
            end
            
        end
%         plot([1 2 3 4 5 6 7]+xoffset(sub), y_val(:,sub), sub_symbols(sub)); %Label.CurrentAmp([1 3:8])

    end
end