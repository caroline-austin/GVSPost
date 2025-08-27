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

subnum = [2044:2048, 2050,2052, 2063:2065];  % Subject List 
numsub = length(subnum);
subskip = [2049 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

sub_symbols = ["kpentagram-";"k<-";"khexagram-";"k>-"; "kdiamond-";"kv-";"ko-";"k+-"; "k*-"; "kx-"; "ksquare-"; "k^-";];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15; -0.15; -0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

%%
total_motion_combo = [0,0,0; 0, 0,0; 0,0,0; 0,0,0];
total_tingle_combo = [0,0,0; 0, 0,0; 0,0,0; 0,0,0];
total_vis_combo = [0,0,0; 0, 0,0; 0,0,0; 0,0,0];
total_metal_combo = [0,0,0; 0, 0,0; 0,0,0; 0,0,0];
total_motion_wins = [0,0,0,0,0 ; 0,0,0,0,0];
total_tingle_wins = [0,0,0,0,0 ; 0,0,0,0,0];
total_vis_wins = [0,0,0,0,0 ; 0,0,0,0,0];
total_metal_wins = [0,0,0,0,0 ; 0,0,0,0,0];

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
    cd(code_path)

    main_results = cell2mat(main_results(:,[1,3]));
    % main_match_ups = cell2mat(main_match_ups);

    %% calculate relative wins 
    motion_wins = [0,0,0,0,0 ; 0,0,0,0,0];
    tingle_wins = [0,0,0,0,0 ; 0,0,0,0,0];
    vis_wins = [0,0,0,0,0 ; 0,0,0,0,0];
    metal_wins = [0,0,0,0,0 ; 0,0,0,0,0];
    motion_combo = [0,0,0; 0, 0,0; 0,0,0; 0,0,0];
    tingle_combo = [0,0,0; 0, 0,0; 0,0,0; 0,0,0];
    vis_combo = [0,0,0; 0, 0,0; 0,0,0; 0,0,0];
    metal_combo = [0,0,0; 0, 0,0; 0,0,0; 0,0,0];
    Label.combos = ["Four 1mA Three 2mA","Four 1mA Three 3mA","Four 1mA Three 4mA"; ...
        "Four 2mA Three 2mA","Four 2mA Three 3mA","Four 2mA Three 4mA"; ...
        "Four 3mA Three 2mA","Four 3mA Three 3mA","Four 3mA Three 4mA"; ...
        "Four 4mA Three 2mA","Four 4mA Three 3mA","Four 4mA Three 4mA"];
    Label.wins = ["Three 0.1mA", "Three 1mA", "Three 2mA", "Three 3mA", "Three 4mA"; "Four 0.1mA", "Four 1mA", "Four 2mA", "Four 3mA", "Four 4mA"];
    
    for match_up = 1:height(main_match_ups)
        match_up_info = strrep([main_match_ups{match_up,2}, '_', num2str(main_match_ups{match_up,3}), '_mA', main_match_ups{match_up,4}, '_', num2str(main_match_ups{match_up,5}) '_mA',], ' ', '_');
        match(1) = convertCharsToStrings(strrep([main_match_ups{match_up,2}, '_', num2str(main_match_ups{match_up,3}), '_mA'], ' ', '_'));
        match(2) = convertCharsToStrings(strrep([main_match_ups{match_up,4}, '_', num2str(main_match_ups{match_up,5}), '_mA'], ' ', '_'));
        
        % pull winner data into an increment 
        if main_match_ups{match_up,9} ==1
            win_incr(1,1) = 1;
            win_incr(2,1) = 0;
        else
            win_incr(2,1) = 1;
            win_incr(1,1) = 0;
        end
        if main_match_ups{match_up,10} ==1
            win_incr(1,2) = 1;
            win_incr(2,2) = 0;
        else
            win_incr(2,2) = 1;
            win_incr(1,2) = 0;
        end
        if main_match_ups{match_up,11} ==1
            win_incr(1,3) = 1;
            win_incr(2,3) = 0;
        else
            win_incr(2,3) = 1;
            win_incr(1,3) = 0;
        end
        if main_match_ups{match_up,12} ==1
            win_incr(1,4) = 1;
            win_incr(2,4) = 0;
        else
            win_incr(2,4) = 1;
            win_incr(1,4) = 0;
        end

        if contains(match_up_info, '4_electrode_0.1_mA')
            combo_row = 0;
            if match(1) == '4_electrode_0.1_mA'
                row_1 = 2; col_1 = 1;
                row_2 = 2; col_2 = 5;

            else 
                row_1 = 2; col_1 = 5;
                row_2 = 2; col_2 = 1;
            end
                        
        elseif contains(match_up_info, '4_electrode_1_mA')
            combo_row = 1;
            if match(1) == '4_electrode_1_mA'
              row_1 = 2; col_1 = 2;
              row_2 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_2 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_2 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_2 = 5;
                combo_col = 3;

                end
            else
              row_2 = 2; col_2 = 2;
              row_1 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_1 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_1 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_1 = 5;
                combo_col = 3;

                end
            end

        elseif contains(match_up_info, '4_electrode_2_mA')
            combo_row = 2;
            if match(1) == "4_electrode_2_mA"
              row_1 = 2; col_1 = 3;
              row_2 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_2 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_2 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_2 = 5;
                combo_col = 3;

                end
            else
              row_2 = 2; col_2 = 3;
              row_1 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_1 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_1 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_1 = 5;
                combo_col = 3;

                end
            end


        elseif contains(match_up_info, '4_electrode_3_mA')
            combo_row = 3;
            if match(1) == '4_electrode_3_mA'
              row_1 = 2; col_1 = 4;
              row_2 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_2 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_2 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_2 = 5;
                combo_col = 3;

                end
            else
              row_2 = 2; col_2 = 4;
              row_1 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_1 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_1 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_1 = 5;
                combo_col = 3;

                end
            end

        elseif contains(match_up_info, '4_electrode_4_mA')
            combo_row = 4;
            if match(1) == '4_electrode_4_mA'
              row_1 = 2; col_1 = 5;
              row_2 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_2 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_2 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_2 = 5;
                combo_col = 3;

                end
            else
              row_2 = 2; col_2 = 5;
              row_1 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_1 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_1 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_1 = 5;
                combo_col = 3;

                end
            end
        elseif contains(match_up_info, '3_electrode_0.1_mA')
            combo_row = 0;
            if match(1) == '3_electrode_0.1_mA'
              row_1 = 1; col_1 = 1;
              row_2 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_2 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_2 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_2 = 5;
                combo_col = 3;

                end
            else
              row_2 = 1; col_2 = 1;
              row_1 = 1;

                if contains(match_up_info, '3_electrode_2_mA')
                col_1 = 3;
                combo_col = 1;
                elseif contains(match_up_info, '3_electrode_3_mA')
                col_1 = 4;
                combo_col = 2;    
                elseif contains(match_up_info, '3_electrode_4_mA')
                col_1 = 5;
                combo_col = 3;

                end
            end
                   
        end

        %tabulate!
        motion_wins(row_1,col_1) = motion_wins(row_1,col_1)+win_incr(1,1);
        motion_wins(row_2,col_2) = motion_wins(row_2,col_2)+win_incr(2,1);
        tingle_wins (row_1,col_1) = tingle_wins(row_1,col_1)+win_incr(1,2);
        tingle_wins (row_2,col_2) = tingle_wins(row_2,col_2)+win_incr(2,2);
        vis_wins(row_1,col_1) = vis_wins(row_1,col_1)+win_incr(1,3);
        vis_wins(row_2,col_2) = vis_wins(row_2,col_2)+win_incr(2,3);
        metal_wins (row_1,col_1) = metal_wins(row_1,col_1)+win_incr(1,4);
        metal_wins (row_2,col_2) = metal_wins(row_2,col_2)+win_incr(2,4);
    if combo_row>0
            if win_incr(1,1) == row_1 % if row 1 =1 and the (1,1) index of win_incr = 1 that means 3 electrode won
                motion_combo_win=-1;
            elseif win_incr(2,1) == row_2 % if row 2 = 1 and the (2,1) index of win_incr = 1 that means 3 electrode won
                motion_combo_win=-1;
            else 
                motion_combo_win=1;
            end

            if win_incr(1,2) == row_1 % if row 1 =1 and the (1,2) index of win_incr = 1 that means 3 electrode won
                tingle_combo_win=-1;
            elseif win_incr(2,2) == row_2 % if row 2 = 1 and the (2,2) index of win_incr = 1 that means 3 electrode won
                tingle_combo_win=-1;
            else 
                tingle_combo_win=1;
            end

            if win_incr(1,3) == row_1 % if row 1 =1 and the (1,1) index of win_incr = 1 that means 3 electrode won
                vis_combo_win=-1;
            elseif win_incr(2,3) == row_2 % if row 2 = 1 and the (2,1) index of win_incr = 1 that means 3 electrode won
                vis_combo_win=-1;
            else 
                vis_combo_win=1;
            end

            if win_incr(1,4) == row_1 % if row 1 =1 and the (1,2) index of win_incr = 1 that means 3 electrode won
                metal_combo_win=-1;
            elseif win_incr(2,4) == row_2 % if row 2 = 1 and the (2,2) index of win_incr = 1 that means 3 electrode won
                metal_combo_win=-1;
            else 
                metal_combo_win=1;
            end
            
            motion_combo(combo_row,combo_col) = motion_combo(combo_row,combo_col)+ motion_combo_win;
            tingle_combo(combo_row,combo_col) = tingle_combo(combo_row,combo_col)+ tingle_combo_win;
            vis_combo(combo_row,combo_col) = vis_combo(combo_row,combo_col)+ vis_combo_win;
            metal_combo(combo_row,combo_col) = metal_combo(combo_row,combo_col)+ metal_combo_win;

    end 
       
             
    end

    
    
    %% can add any indv. subject plots here
    % figure;
    % sgtitle(['S' subject_str ' Total Wins'])
    % subplot(2,1,1)
    % bar(main_results(:,1));
    % title ("Most Motion Sensation");
    % xticklabels([])
    % 
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

    % % aggregating results
    total_motion_combo = total_motion_combo +motion_combo;
    total_tingle_combo = total_tingle_combo +tingle_combo;
    total_vis_combo = total_vis_combo +vis_combo;
    total_metal_combo = total_metal_combo +metal_combo;
    total_motion_wins = total_motion_wins+motion_wins;
    total_tingle_wins = total_tingle_wins+tingle_wins;
    total_vis_wins = total_vis_wins+vis_wins;
    total_metal_wins = total_metal_wins+metal_wins;
    sub_motion_combo(:,:,sub) = motion_combo;
    sub_tingle_combo(:,:,sub) = tingle_combo;
    sub_motion_wins(:,:,sub)= motion_wins;
    sub_tingle_wins(:,:,sub)= tingle_wins;
    sub_vis_wins(:,:,sub)= vis_wins;
    sub_metal_wins(:,:,sub)= metal_wins;
    sub_total_motion_wins_montage(sub,1)= cell2mat(total_motion_wins_3);
    sub_total_motion_wins_montage(sub,2)= cell2mat(total_motion_wins_4);
    sub_total_tingle_wins_montage(sub,1)= cell2mat(total_tingle_wins_3);
    sub_total_tingle_wins_montage(sub,2)= cell2mat(total_tingle_wins_4);

    sub_total_motion_wins(sub,:)= ([motion_wins(1,:) motion_wins(2,:)]);
    sub_total_tingle_wins(sub,:)= ([tingle_wins(1,:) tingle_wins(2,:)]);
    sub_total_vis_wins(sub,:)= ([vis_wins(1,:) vis_wins(2,:)]);
    sub_total_metal_wins(sub,:)= ([metal_wins(1,:) metal_wins(2,:)]);
    
    
end
Label.combos_stats_org_row = reshape(Label.combos, 12, 1);
Label.combos_stats_org_col = ["Four electrode Wins", "Three electrode Wins", "Net Wins"] ;
total_motion_combo_stats_org= reshape(total_motion_combo, 12, 1);
total_motion_combo_stats_org(:,2) = (20+ total_motion_combo_stats_org(:,1))/2;
total_motion_combo_stats_org(:,3) = 20- total_motion_combo_stats_org(:,2);
total_motion_combo_stats_org = [total_motion_combo_stats_org(:,2) total_motion_combo_stats_org(:,3) total_motion_combo_stats_org(:,1) ];

total_tingle_combo_stats_org= reshape(total_tingle_combo, 12, 1);
total_tingle_combo_stats_org(:,2) = (20+ total_tingle_combo_stats_org(:,1))/2;
total_tingle_combo_stats_org(:,3) = 20- total_tingle_combo_stats_org(:,2);
total_tingle_combo_stats_org = [total_tingle_combo_stats_org(:,2) total_tingle_combo_stats_org(:,3) total_tingle_combo_stats_org(:,1) ];

total_vis_combo_stats_org= reshape(total_vis_combo, 12, 1);
total_vis_combo_stats_org(:,2) = (20+ total_vis_combo_stats_org(:,1))/2;
total_vis_combo_stats_org(:,3) = 20- total_vis_combo_stats_org(:,2);
total_vis_combo_stats_org = [total_vis_combo_stats_org(:,2) total_vis_combo_stats_org(:,3) total_vis_combo_stats_org(:,1) ];

total_metal_combo_stats_org= reshape(total_metal_combo, 12, 1);
total_metal_combo_stats_org(:,2) = (20+ total_metal_combo_stats_org(:,1))/2;
total_metal_combo_stats_org(:,3) = 20- total_metal_combo_stats_org(:,2);
total_metal_combo_stats_org = [total_metal_combo_stats_org(:,2) total_metal_combo_stats_org(:,3) total_metal_combo_stats_org(:,1) ];

%% save data
    cd([file_path]); %move to directory where file will be saved
    %add all variables that we want to save to a list must include space
    %between variable names 
    vars_2_save =  ['Label total_motion_combo total_tingle_combo ' ...
        ' total_vis_combo total_metal_combo ' ...
        'total_motion_wins total_tingle_wins total_vis_wins total_metal_wins ' ...
        ' sub_motion_combo sub_tingle_combo sub_motion_wins sub_tingle_wins ' ...
        'sub_metal_wins sub_vis_wins sub_total_motion_wins  ' ...
        ' sub_total_tingle_wins total_motion_combo_stats_org total_tingle_combo_stats_org ' ...
        ' total_vis_combo_stats_org total_metal_combo_stats_org'];% ...
        % ' EndImpedance StartImpedance MaxCurrent MinCurrent all_pos all_vel']; 
    eval(['  save ' ['AllVerbal.mat '] vars_2_save ' vars_2_save']); %save file     
    cd(code_path) %return to code directory

% %% can add any aggregate subj plots here
% figure;
% sgtitle(['SAll Total Wins'])
% subplot(2,1,1)
% bar(total_results(:,1));
% title ("Most Motion Sensation");
% xticklabels([])
% subplot(2,1,2)
% bar(total_results(:,2));
% xticklabels([Label.MainResultsRow])
% title ("Most Tingling");
% 

%%
figure;
sgtitle('Total Ratings of Higher Sensation Intensity','FontSize', 20)
% subplot(2,1,1)
tiledlayout(2,1, "TileSpacing","compact")
nexttile
b=boxplot(sub_total_motion_wins_montage);
hold on;
for j = 1:numsub
    for i = 1:width(sub_total_motion_wins_montage)

        plot(i+xoffset2(j), sub_total_motion_wins_montage(j, i),sub_symbols(j),'MarkerSize',10,"LineWidth", 1.5);
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
ylim([0 25])

% subplot(2,1,2)
nexttile
h = boxplot(sub_total_tingle_wins_montage);
hold on;
for j = 1:numsub
    for i = 1:width(sub_total_tingle_wins_montage)

        plot(i+xoffset2(j), sub_total_tingle_wins_montage(j, i),sub_symbols(j),'MarkerSize',10,"LineWidth", 1.5);
        hold on;
    end
end
% xticklabels([Label.MainResultsRow])
xticklabels(["Shoulder" "Temples"])
set(h, 'LineWidth', 2);
set(h, 'Color', 'k');
ax = gca;
set(ax, 'FontSize', 18); 
title ("Tingling",'FontSize', 18);
ylabel("Number of Reports")
ylim([0 25])
set(gcf,'position',[100,100,700,800])  
%%
figure;
% subplot(2,1,1)
tiledlayout(2,2, "TileSpacing","compact")
nexttile
motion_plot = [sub_total_motion_wins(:,3:4) sub_total_motion_wins(:,5)-2 sub_total_motion_wins(:,7:9) sub_total_motion_wins(:,10)-2];
b=boxplot(motion_plot);
hold on;
for j = 1:numsub
    for i = 1:width(motion_plot)
        for k = 1:height(motion_plot)

            plot(i+xoffset2(j), motion_plot(j, i),sub_symbols(j),'MarkerSize',10,"LineWidth", 1.5);
            hold on;
        end
    end
end
title ("Motion Sensation",'FontSize', 18);
set(b, 'LineWidth', 2);
set(b, 'Color', 'k');
ax = gca; 
set(ax, 'FontSize', 18);
xticklabels([])
ylabel("Number of Reports")
ylim([0 8])

% subplot(2,1,2)
nexttile(3)
tingle_plot = [sub_total_tingle_wins(:,3:4) sub_total_tingle_wins(:,5)-2 sub_total_tingle_wins(:,7:9) sub_total_tingle_wins(:,10)-2];

h = boxplot(tingle_plot);
hold on;
for j = 1:numsub
    for i = 1:width(tingle_plot)

        plot(i+xoffset2(j), tingle_plot(j, i),sub_symbols(j),'MarkerSize',10,"LineWidth", 1.5);
        hold on;
    end
end
% xticklabels([Label.MainResultsRow])
xticklabels(["Shoulder 2mA" "Shoulder 3mA" "Shoulder 4mA" "Temples 1mA" "Temples 2mA" "Temples 3mA" "Temples 4mA"])
set(h, 'LineWidth', 2);
set(h, 'Color', 'k');
ax = gca;
set(ax, 'FontSize', 18); 
title ("Skin Tingling",'FontSize', 18);
ylabel("Number of Reports")
ylim([0 8])
set(gcf,'position',[100,100,700,800])  

nexttile(2)
vis_plot = [sub_total_vis_wins(:,3:4) sub_total_vis_wins(:,5)-2 sub_total_vis_wins(:,7:9) sub_total_vis_wins(:,10)-2];
b=boxplot(vis_plot);
hold on;
for j = 1:numsub
    for i = 1:width(vis_plot)
        for k = 1:height(vis_plot)

            plot(i+xoffset2(j), vis_plot(j, i),sub_symbols(j),'MarkerSize',10,"LineWidth", 1.5);
            hold on;
        end
    end
end
title ("Visual Flashes",'FontSize', 18);
set(b, 'LineWidth', 2);
set(b, 'Color', 'k');
ax = gca; 
set(ax, 'FontSize', 18);
xticklabels([])
% ylabel("Number of Reports")
ylim([0 8])

% subplot(2,1,2)
nexttile(4)
metal_plot = [sub_total_metal_wins(:,3:4) sub_total_metal_wins(:,5)-2 sub_total_metal_wins(:,7:9) sub_total_metal_wins(:,10)-2];

h = boxplot(metal_plot);
hold on;
for j = 1:numsub
    for i = 1:width(metal_plot)

        plot(i+xoffset2(j), metal_plot(j, i),sub_symbols(j),'MarkerSize',10,"LineWidth", 1.5);
        hold on;
    end
end
% xticklabels([Label.MainResultsRow])
xticklabels(["Shoulder 2mA" "Shoulder 3mA" "Shoulder 4mA" "Temples 1mA" "Temples 2mA" "Temples 3mA" "Temples 4mA"])
set(h, 'LineWidth', 2);
set(h, 'Color', 'k');
ax = gca;
set(ax, 'FontSize', 18); 
title ("Metallic Taste",'FontSize', 18);
% ylabel("Number of Reports")
ylim([0 8])
set(gcf,'position',[100,100,1600,800])  


%%
figure;
sgtitle('Visual Flashes')
bar(total_vis_wins.');
xticklabels([0.1 1 2 3 4].')
xlabel('Current at Distal Electrode (mA)',"FontSize",14)
ylabel('Total Reports',"FontSize",14)
legend("Shoulder", "Temples","Location","northwest")
ylim([0 81])
xlim([1.5 5.5])
hold on

%%
figure;
sgtitle('Metallic Taste')
bar(total_metal_wins.');
xticklabels([0.1 1 2 3 4].')
xlabel('Current (mA)',"FontSize",14)
ylabel('Total Reports',"FontSize",14)
legend("Shoulder", "Temples","Location","northwest")
ylim([0 81])
xlim([1.5 5.5])
hold on
%%
figure;
sgtitle('Motion Sensation')
bar(total_motion_wins.');
xticklabels([0.1 1 2 3 4].')
xlabel('Current (mA)',"FontSize",14)
ylabel('Total Reports',"FontSize",14)
legend("Shoulder", "Temples","Location","northwest")
ylim([0 81])
xlim([1.5 5.5])
grid minor
hold on
%%
figure;
sgtitle('Tingling')
bar(total_tingle_wins.');
xticklabels([0.1 1 2 3 4].')
xlabel('Current (mA)',"FontSize",14)
ylabel('Total Reports',"FontSize",14)
legend("Shoulder", "Temples","Location","northwest")
ylim([0 81])
xlim([1.5 5.5])
grid minor
hold on




% % can add any aggregate subj plots here
% figure;
% sgtitle(['SAll Paired Wins'])
% subplot(2,1,1)
% bar([total_forhead_shoulder, total_shoulder_neck, total_neck_forhead]);
% title ("Most Motion Sensation");
% xticklabels(["forehead" "shoulder" "shoulder" "neck" "neck" "forehead"])
% 
% figure;
% sgtitle(['SAll Total Wins'])
% subplot(2,1,1)
% b=boxplot([sub_forhead_shoulder sub_shoulder_neck sub_neck_forhead]);
% hold on;
% for j = 1:numsub
%     for i = 1:width(sub_motion')
% 
%         plot(i+xoffset2(j), sub_motion(i, j),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
%         hold on;
%     end
% end
% title ("Most Motion Sensation");
% xticklabels(["forehead" "shoulder" "shoulder" "neck" "neck" "forehead"])


% cd(code_path);
% 
% %% initial stats
% p=friedman(sub_motion');
% p=friedman(sub_tingle');
% 
% p_forehead_shoulder_t = signrank(sub_tingle(1,:),sub_tingle(2,:));
% p_forehead_shoulder_m = signrank(sub_motion(1,:),sub_motion(2,:));
