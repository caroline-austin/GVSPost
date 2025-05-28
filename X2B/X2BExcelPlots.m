% Created by: Caroline Austin 2/6/24
% Script 2a of X2B data processing 
% This script reads in the output of script 1 (X2BGet files) and uses the
% data from the excel sheet to make plots summarizing the results of the
% experiment 

close all; 
clear all; 
clc; 


%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory % select data folder
plots_path = [file_path '/Plots']; % specify where plots are saved
cd(code_path); cd .. ;
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 2034:2043;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

sub_symbols = ["kpentagram-";"k<-";"khexagram-";"k>-"; "kdiamond-";"kv-";"ko-";"k+-"; "k*-"; "kx-"; "ksquare-"; "k^-";];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15; -0.15; -0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

%%
total_results = zeros(3,4);
total_bonus_results = zeros(3,2);
total_forhead_shoulder = [0,0; 0,0 ;0,0; 0,0];
total_shoulder_neck = [0,0; 0,0 ;0,0; 0,0];
total_neck_forhead = [0,0; 0,0 ;0,0; 0,0];
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path '/' subject_str];
    
    % load subject data 
    cd(subject_path);
    load(['S' subject_str '.mat']);

    main_results = cell2mat(main_results);
    bonus_results = cell2mat(bonus_results(:,1:2));
    % main_match_ups = cell2mat(main_match_ups);

    %% calculate relative wins 
    
    for side_effect = 8:11
        forhead_shoulder = [0,0];
        shoulder_neck = [0,0];
        neck_forhead = [0,0];
    for match_up = 1:height(main_match_ups)
        
        if contains(main_match_ups{match_up,2}, 'Three Forhead')
            if contains(main_match_ups{match_up,3}, 'Three Shoulder')
                if main_match_ups{match_up,side_effect} == 1
                    forhead_shoulder(1) = forhead_shoulder(1)+1;
                elseif main_match_ups{match_up,side_effect} == 2
                    forhead_shoulder(2) = forhead_shoulder(2)+1;
                end

            elseif contains(main_match_ups{match_up,3},'Three Neck')
                if main_match_ups{match_up,side_effect} == 1
                    neck_forhead(2) = neck_forhead(2)+1;
                elseif main_match_ups{match_up,side_effect} == 2
                    neck_forhead(1) = neck_forhead(1)+1;
                end

            end

        elseif contains(main_match_ups{match_up,2}, 'Three Shoulder')
            if contains(main_match_ups{match_up,3}, 'Three Neck')
                if main_match_ups{match_up,side_effect} == 1
                    shoulder_neck(1) = shoulder_neck(1)+1;
                elseif main_match_ups{match_up,side_effect} == 2
                    shoulder_neck(2) = shoulder_neck(2)+1;
                end

            elseif contains(main_match_ups{match_up,3} , 'Three Forhead')
                if main_match_ups{match_up,side_effect} == 1
                    forhead_shoulder(2) = forhead_shoulder(2)+1;
                elseif main_match_ups{match_up,side_effect} == 2
                    forhead_shoulder(1) = forhead_shoulder(1)+1;
                end

            end
        elseif contains(main_match_ups{match_up,2} ,'Three Neck')
            if contains(main_match_ups{match_up,3} , 'Three Forhead')
                if main_match_ups{match_up,side_effect} == 1
                    neck_forhead(1) = neck_forhead(1)+1;
                elseif main_match_ups{match_up,side_effect} == 2
                    neck_forhead(2) = neck_forhead(2)+1;
                end

            elseif contains(main_match_ups{match_up,3} , 'Three Shoulder')
                if main_match_ups{match_up,side_effect} == 1
                    shoulder_neck(2) = shoulder_neck(2)+1;
                elseif main_match_ups{match_up,side_effect} == 2
                    shoulder_neck(1) = shoulder_neck(1)+1;
                end

            end

        end
             
    end

    
    
    %% can add any indv. subject plots here
    % figure;
    % sgtitle(['S' subject_str ' Total Wins'])
    % subplot(2,1,1)
    % bar(main_results(:,1));
    % title ("Most Motion Sensation");
    % xticklabels([])
    % subplot(2,1,2)
    % bar(main_results(:,2));
    % xticklabels([Label.MainResultsRow])
    % title ("Most Tingling");

    % figure;
    % sgtitle(['S' subject_str 'Paired Wins'])
    % % subplot(2,1,1)
    % bar([forhead_shoulder, shoulder_neck, neck_forhead]);
    % title ("Most Motion Sensation");
    % xticklabels(["forehead" "shoulder" "shoulder" "neck" "neck" "forehead"])

    % aggregating results
    total_results = total_results +main_results;
    total_bonus_results = total_bonus_results +bonus_results;
    total_neck_forhead(side_effect-7,:) = total_neck_forhead(side_effect-7,:) + neck_forhead;
    total_shoulder_neck(side_effect-7,:) = total_shoulder_neck(side_effect-7,:) + shoulder_neck;
    total_forhead_shoulder(side_effect-7,:) = total_forhead_shoulder(side_effect-7,:) + forhead_shoulder;

    end 

    sub_motion(:,sub) = main_results(:,1); 
    sub_tingle(:,sub) = main_results(:,2); 
    sub_metal(:,sub) = main_results(:,3); 
    sub_vis(:,sub) = main_results(:,4); 
    sub_neck_forhead (sub,:)= neck_forhead;
    sub_shoulder_neck (sub,:)= shoulder_neck;
    sub_forhead_shoulder (sub,:)= forhead_shoulder;
end

%% save data
    cd([file_path]); %move to directory where file will be saved
    %add all variables that we want to save to a list must include space
    %between variable names 
    vars_2_save =  ['Label total_results total_bonus_results ' ...
        'total_neck_forhead total_shoulder_neck total_forhead_shoulder ' ...
        ' sub_motion sub_tingle sub_metal sub_vis sub_neck_forhead ' ...
        ' sub_shoulder_neck sub_forhead_shoulder'];% ...
        % ' EndImpedance StartImpedance MaxCurrent MinCurrent all_pos all_vel']; 
    eval(['  save ' ['AllVerbal.mat '] vars_2_save ' vars_2_save']); %save file     
    cd(code_path) %return to code directory


%% can add any aggregate subj plots here
figure;
sgtitle('Total Ratings of Higher Sensation Intensity','FontSize', 20)

subplot(2,1,1)
bar(total_results(:,1));
title ("Motion Sensation",'FontSize', 18);
ax = gca; 
set(ax, 'FontSize', 18);
xticklabels([])
ylabel("Number of Reports")
ylim([0 70])
grid minor

subplot(2,1,2)
bar(total_results(:,2));
ax = gca; 
set(ax, 'FontSize', 18);
xticklabels(["Forehead","Shoulder","Neck"])
ylabel("Number of Reports")
title ("Tingling",'FontSize', 18);
ylim([0 70])
grid minor

set(gcf,'position',[100,100,700,800])  

%% box plots for motion and tingling 
figure;
tiledlayout(2,2,"TileSpacing","compact")
sgtitle('Total Ratings of Higher Sensation Intensity','FontSize', 20)
nexttile 
b=boxplot(sub_motion');
hold on;
for j = 1:numsub
    for i = 1:width(sub_motion')
        
        plot(i+xoffset2(j), sub_motion(i, j),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
        hold on;
    end
end
title ("Motion Sensation",'FontSize', 18);
set(b, 'LineWidth', 2);
set(b, 'Color', 'k');
ax = gca; 
set(ax, 'FontSize', 18);
xticklabels([])
ylabel("Number of Reports")
ylim([-0.5 8.5])
grid minor

% nexttile
nexttile(3)
h = boxplot(sub_tingle');
hold on;
for j = 1:numsub
    for i = 1:width(sub_motion')
        
        plot(i+xoffset2(j), sub_tingle(i, j),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
        hold on;
    end
end
xticklabels(["Forehead","Shoulder","Neck"])
set(h, 'LineWidth', 2);
set(h, 'Color', 'k');
ax = gca;
set(ax, 'FontSize', 18); 
title ("Tingling",'FontSize', 18);
ylabel("Number of Reports")
ylim([-0.5 8.5])
grid minor
set(gcf,'position',[100,100,700,800])  

% box plots for metallic taste and visual flashes 
% figure;
% tiledlayout(2,1,"TileSpacing","compact")
% sgtitle('Total Ratings of Higher Sensation Intensity','FontSize', 20)
% nexttile
nexttile(2)
b=boxplot(sub_metal');
hold on;
for j = 1:numsub
    for i = 1:width(sub_metal')
        
        plot(i+xoffset2(j), sub_metal(i, j),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
        hold on;
    end
end
title ("Metallic Taste",'FontSize', 18);
set(b, 'LineWidth', 2);
set(b, 'Color', 'k');
ax = gca; 
set(ax, 'FontSize', 18);
xticklabels([])
% ylabel("Number of Reports")
ylim([-0.5 8.5])
grid minor
% nexttile
nexttile(4)
h = boxplot(sub_vis');
hold on;
for j = 1:numsub
    for i = 1:width(sub_vis')
        
        plot(i+xoffset2(j), sub_vis(i, j),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
        hold on;
    end
end
xticklabels(["Forehead","Shoulder","Neck"])
set(h, 'LineWidth', 2);
set(h, 'Color', 'k');
ax = gca;
set(ax, 'FontSize', 18); 
title ("Visual Flashes",'FontSize', 18);
% ylabel("Number of Reports")
ylim([-0.5 8.5])
grid minor
set(gcf,'position',[100,100,1400,800])  

%% can add any aggregate subj plots here
figure;
sgtitle(['SAll Paired Wins'])
% subplot(2,1,1)
bar([total_forhead_shoulder(1,:), total_shoulder_neck(1,:), total_neck_forhead(1,:)]);
title ("Most Motion Sensation");
xticklabels(["forehead" "shoulder" "shoulder" "neck" "neck" "forehead"])

figure;
sgtitle(['SAll Total Wins'])
% subplot(2,1,1)
b=boxplot([sub_forhead_shoulder sub_shoulder_neck sub_neck_forhead]);
hold on;
% for j = 1:numsub
%     for i = 1:width(sub_motion')
% 
%         plot(i+xoffset2(j), sub_motion(i, j),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
%         hold on;
%     end
% end
title ("Most Motion Sensation");
xticklabels(["forehead" "shoulder" "shoulder" "neck" "neck" "forehead"])


cd(code_path);

%% initial stats
p=friedman(sub_motion');
p=friedman(sub_tingle');
p=friedman(sub_metal');
p=friedman(sub_vis');

p_forehead_shoulder_t = signrank(sub_tingle(1,:),sub_tingle(2,:));
p_forehead_shoulder_m = signrank(sub_motion(1,:),sub_motion(2,:));
