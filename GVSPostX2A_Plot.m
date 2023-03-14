close all; 
clear all; 
clc; 

%%
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];

%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '/Plots']; % specify where plots are saved
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 2001:2006;  % Subject List 
numsub = length(subnum); % need to calculate this differntly
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

Include_plots = ['1 2 5 6'];

% should probably insert a for loop that checks to make sure this file exists first
cd([file_path]);
load(['All_X2A.mat']); 
cd(code_path);

% [row, col, depth] = size(All_Tingle_map1);
% All_map = zeros(row, col);

% MapAreaPlot(All_Tingle_map1(:,:,1),Title,numsub)
numsub = 100;

%% Area Plots organized by side effects
%Plots contain all 3 electrodes for a single property at a time
% area plot only for part 1 of the experiment 
if contains(Include_plots,'1')
    for j = 1:5
        figure;
        t1 = tiledlayout(2,2);
        for i = 1:3
            nexttile
            Title = strjoin([num2str(i+1) " Electrodes"]);
            MapAreaPlot(All_Tingle_map(:,:,i,j),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Tingling Sensation Profile " num2str(j)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["Profile" num2str(j) "ElectrodeTingleRatingsSin0_5HzAllCurrentAreaPlot"]));
        
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        figure;
        t2 = tiledlayout(2,2);
        for i = 1:3
            nexttile
            Title = strjoin([num2str(i+1) " Electrodes"]);
            MapAreaPlot(All_Metallic_map(:,:,i,j),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Metallic Taste Profile " num2str(j)]));
        sgtitle(TotalTitle, "FontSize", 50)
        Filename = char(strjoin(["Profile" num2str(j) "ElectrodeMetallicRatingsSin0_5HzAllCurrentAreaPlot"]));
        
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        
        figure;
        t3 = tiledlayout(2,2);
        for i = 1:3
            nexttile
            Title = strjoin([num2str(i+1) " Electrodes"]);
            MapAreaPlot(All_VisFlash_map(:,:,i,j),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Visual Flashes Profile " num2str(j)]));
        sgtitle(TotalTitle, "FontSize", 50)
        Filename = char(strjoin(["Profile" num2str(j) "ElectrodeVisualFlashRatingsSin0_5HzAllCurrentAreaPlot"]));
        
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        figure;
        t4 = tiledlayout(2,2);
        for i = 1:3
            nexttile
            Title = strjoin([num2str(i+1) " Electrodes"]);
            MapAreaPlot(All_MotionRating_map(:,:,i,j),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Motion Sensation Profile " num2str(j)]));
        sgtitle(TotalTitle, "FontSize", 50)
        
        Filename = char(strjoin(["Profile" num2str(j) "ElectrodeMotionRatingsSin0_5HzAllCurrentAreaPlot"] ));
        
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);

        close all
    end

end

%% Area Plots organized by side effects Reduced 
%Plots contain all 3 electrodes for a single property at a time
% area plot only for part 1 of the experiment 
if contains(Include_plots,'2')
    for j = 1:5
        figure;
        t1 = tiledlayout(2,2);
        for i = 1:3
            nexttile
            Title = strjoin([num2str(i+1) " Electrodes"]);
            MapAreaPlot(All_Tingle_mapReduced(:,:,i,j),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Tingling Sensation Profile " num2str(j)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["Profile" num2str(j) "ReducedElectrodeTingleRatingsSin0_5HzAllCurrentAreaPlot"]));
        
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        figure;
        t2 = tiledlayout(2,2);
        for i = 1:3
            nexttile
            Title = strjoin([num2str(i+1) " Electrodes"]);
            MapAreaPlot(All_Metallic_mapReduced(:,:,i,j),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Metallic Taste Profile " num2str(j)]));
        sgtitle(TotalTitle, "FontSize", 50)
        Filename = char(strjoin(["Profile" num2str(j) "ReducedElectrodeMetallicRatingsSin0_5HzAllCurrentAreaPlot"]));
        
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        
        figure;
        t3 = tiledlayout(2,2);
        for i = 1:3
            nexttile
            Title = strjoin([num2str(i+1) " Electrodes"]);
            MapAreaPlot(All_VisFlash_mapReduced(:,:,i,j),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Visual Flashes Profile " num2str(j)]));
        sgtitle(TotalTitle, "FontSize", 50)
        Filename = char(strjoin(["Profile" num2str(j) "ReducedElectrodeVisualFlashRatingsSin0_5HzAllCurrentAreaPlot"]));
        
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        figure;
        t4 = tiledlayout(2,2);
        for i = 1:3
            nexttile
            Title = strjoin([num2str(i+1) " Electrodes"]);
            MapAreaPlot(All_MotionRating_mapReduced(:,:,i,j),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Motion Sensation Profile " num2str(j)]));
        sgtitle(TotalTitle, "FontSize", 50)
        
        Filename = char(strjoin(["Profile" num2str(j) "ReducedElectrodeMotionRatingsSin0_5HzAllCurrentAreaPlot"] ));
        
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);

        close all
    end

end

%% Area Plots for Side Effects organized by the number of electrodes 
%this has not been updated for the 4D rating arrays
% % these plots have all of the side effects on the same plot and then makes 
% different plots for each electrode configuration for part 1 of the
% experiment 
if contains(Include_plots, '3')
    for i = 1:3
    figure;
    subplot(2,3,1)
    MapAreaPlot(All_Tingle_map1(:,:,i),"Tingle Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    subplot(2,3,2)
    MapAreaPlot(All_Metallic_map1(:,:,i),"Metallic Taste Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    subplot(2,3,3)
    MapAreaPlot(All_VisFlash_map1(:,:,i),"Visual Flashes Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    subplot(2,3,4)
    MapAreaPlot(All_MotionRating_map1(:,:,i),"Motion Sensations Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    subplot(2,3,5)
    MapAreaPlot(All_ObservedRating_map1(:,:,i),"Observed Motion Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    
    subplot(2,3,6,"visible", "off")
    % lgd = legend(["none", "noticeable", "moderate", "severe"]);
    
    Total_title = strjoin([num2str(i+1) " Electrode Effects Ratings Sin 0.5Hz all Current"]);
    sgtitle(Total_title)
    
    Filename = strrep(strjoin([num2str(i+1) "ElectrodeEffectsRatingsSin0_5HzAllCurrent"]), ' ', '');
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
end 
% 
% 

% %% Plots contain all 3 electrodes for a single property at a time
% % bar plot only for part 1 of the experiment 
if contains(Include_plots, '4')
    figure;
    t1 = tiledlayout(2,2);
    for i = 1:3
    nexttile
    Title = strjoin([num2str(i+1) " Electrodes"]);
    MapStackedBarPlot(All_Tingle_map1(:,:,i),Title,numsub, ["none", "noticeable", "moderate", "severe"], Color_list)
    xlim([1.1 9.9]);
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    sgtitle("Reported Tingling Sensation", "FontSize", 50);
    Filename =  "ElectrodeTingleRatingsSin0_5HzAllCurrentStackedBar";
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    
    figure;
    t2 = tiledlayout(2,2);
    for i = 1:3
    nexttile
    Title = strjoin([num2str(i+1) " Electrodes"]);
    MapStackedBarPlot(All_Metallic_map1(:,:,i),Title,numsub, ["none", "noticeable", "moderate", "severe"], Color_list)
    xlim([1.1 9.9]);
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    sgtitle("Reported Metallic Taste", "FontSize", 50)
    Filename = "ElectrodeMetallicRatingsSin0_5HzAllCurrentStackedBar";
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    
    
    figure;
    t3 = tiledlayout(2,2);
    for i = 1:3
    nexttile
    Title = strjoin([num2str(i+1) " Electrodes"]);
    MapStackedBarPlot(All_VisFlash_map1(:,:,i),Title,numsub, ["none", "noticeable", "moderate", "severe"], Color_list)
    xlim([1.1 9.9]);
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    sgtitle("Reported Visual Flashes", "FontSize", 50)
    Filename = "ElectrodeVisualFlashRatingsSin0_5HzAllCurrentStackedBar";
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    
    figure;
    t4 = tiledlayout(2,2);
    for i = 1:3
    nexttile
    Title = strjoin([num2str(i+1) " Electrodes"]);
    MapStackedBarPlot(All_MotionRating_map1(:,:,i),Title,numsub, ["none", "noticeable", "moderate", "severe"], Color_list)
    xlim([1.1 9.9]);
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    sgtitle("Reported Motion Sensation", "FontSize", 50)
    
    Filename = "ElectrodeMotionRatingsSin0_5HzAllCurrentStackedBar";
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
end

if contains(Include_plots,'5')
    %% Plot Motion Direction (roll, pitch, yaw data)
    Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
    Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
    for j = 1:5
    figure;
    t_dir = tiledlayout(2,2);
    for i = 1:3
        nexttile
        b = bar(All_Motion_map (:,:,i,j));
        ax = gca;
        ax.FontSize = 27;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(i+1) " Electrodes"]);
        title(Title, "FontSize", 45)
    
    
        Current_levels_str = ["0.1" ".5" "1" "1.5" "2" "2.5" "3" "3.5" "4"];
        xticks([1 2 3 4 5 6 7 8 9]);
        xticklabels(Current_levels_str);
        ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Roll','Pitch', 'Yaw', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Direction",   Profiles(j)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionDirection" Profiles_safe(j) "AllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
    %% Plot Motion Timing (rhythmic, continuous, intermittent)
    Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
    Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
    for j = 1:5
    figure;
    t_dir = tiledlayout(2,2);
    for i = 1:3
        nexttile
        b = bar(All_Timing_map (:,:,i,j));
        ax = gca;
        ax.FontSize = 27;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(i+1) " Electrodes"]);
        title(Title, "FontSize", 45)
        
    
        Current_levels_str = ["0.1" ".5" "1" "1.5" "2" "2.5" "3" "3.5" "4"];
        xticks([1 2 3 4 5 6 7 8 9]);
        xticklabels(Current_levels_str);
        ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Rhythmic','Continuous', 'Intermittent', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Timing",   Profiles(j)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionTiming" Profiles_safe(j) "AllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
    
    
    %% Plot Motion Type (rhythmic, continuous, intermittent)
    Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
    Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
    for j = 1:5
    figure;
    t_dir = tiledlayout(2,2);
    for i = 1:3
        nexttile
        b = bar(All_Type_map (:,:,i,j));
        ax = gca;
        ax.FontSize = 27;
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(i+1) " Electrodes"]);
        title(Title, "FontSize", 45)
        
    
        Current_levels_str = ["0.1" ".5" "1" "1.5" "2" "2.5" "3" "3.5" "4"];
        xticks([1 2 3 4 5 6 7 8 9]);
        xticklabels(Current_levels_str);
        ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Tilt','Translation', 'General Instability', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Type",   Profiles(j)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionType" Profiles_safe(j) "AllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    close all
    end
end


if contains(Include_plots, '6')
%% Plot Motion Direction (roll, pitch, yaw data)
    Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
    Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
    for j = 1:5
    figure;
    t_dir = tiledlayout(2,2);
    for i = 1:3
        nexttile
        b = bar(All_Motion_mapReduced (:,:,i,j));
        ax = gca;
        ax.FontSize = 27;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(i+1) " Electrodes"]);
        title(Title, "FontSize", 45)
    
    
        Current_levels_str = ["0.1" "low" "high"];
        xticks([1 2 3]);
        xticklabels(Current_levels_str);
        ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Roll','Pitch', 'Yaw', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Direction",   Profiles(j)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionDirection" Profiles_safe(j) "ReducedAllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
    %% Plot Motion Timing (rhythmic, continuous, intermittent)
    Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
    Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
    for j = 1:5
    figure;
    t_dir = tiledlayout(2,2);
    for i = 1:3
        nexttile
        b = bar(All_Timing_mapReduced (:,:,i,j));
        ax = gca;
        ax.FontSize = 27;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(i+1) " Electrodes"]);
        title(Title, "FontSize", 45)
        
    
        Current_levels_str = ["0.1" "low" "high"];
        xticks([1 2 3]);
        xticklabels(Current_levels_str);
        ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Rhythmic','Continuous', 'Intermittent', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Timing",   Profiles(j)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionTiming" Profiles_safe(j) "ReducedAllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
    
    
    %% Plot Motion Type (rhythmic, continuous, intermittent)
    Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
    Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
    for j = 1:5
    figure;
    t_dir = tiledlayout(2,2);
    for i = 1:3
        nexttile
        b = bar(All_Type_mapReduced (:,:,i,j));
        ax = gca;
        ax.FontSize = 27;
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(i+1) " Electrodes"]);
        title(Title, "FontSize", 45)
        
    
        Current_levels_str = ["0.1" "low" "high"];
        xticks([1 2 3]);
        xticklabels(Current_levels_str);
        ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Tilt','Translation', 'General Instability', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Type",   Profiles(j)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionType" Profiles_safe(j) "ReducedAllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    close all
    end
end
%%
% % area plot figures for part 2 of the experiment
% for i = 1:3
% figure;
% subplot(2,3,1)
% MapAreaPlot(All_Tingle_map2(:,:,i),"Tingle Reporting",numsub, ["none", "noticeable", "moderate", "severe"])
% xlim([0.5 4]);
% 
% subplot(2,3,2)
% MapAreaPlot(All_Metallic_map2(:,:,i),"Metallic Taste Reporting",numsub, ["none", "noticeable", "moderate", "severe"])
% xlim([0.5 4]);
% 
% subplot(2,3,3)
% MapAreaPlot(All_VisFlash_map2(:,:,i),"Visual Flashes Reporting",numsub, ["none", "noticeable", "moderate", "severe"])
% xlim([0.5 4]);
% 
% subplot(2,3,4)
% MapAreaPlot(All_MotionRating_map2(:,:,i),"Motion Sensations Reporting",numsub, ["none", "noticeable", "moderate", "severe"])
% xlim([0.5 4]);
% 
% subplot(2,3,5)
% MapAreaPlot(All_ObservedRating_map2(:,:,i),"Observed Motion Reporting",numsub, ["none", "noticeable", "moderate", "severe"])
% xlim([0.5 4]);
% 
% subplot(2,3,6,"visible", "off")
% Total_title = horzcat([num2str(i+1) " Electrode Effects Ratings Multi Profile"]);
% sgtitle(Total_title)
% 
% end



% Current_levels_str = ["0.1" "0.5" "1" "1.5" "2" "2.5" "3" "3.5" "4"]; % need to save this variable earlier on
% figure;
% subplot(2,2,1)
% bar(All_Tingle_map1(:,:,1));
% hold on;
% ylabel('Number of Responses')
% xlabel('Current Level (mA)')
% xticks([1 2 3 4 5 6 7 8 9]);
% xticklabels(Current_levels_str);
% title('2 Electrode');
% % legend('none','noticeable', 'moderate', 'severe')
% subplot(2,2,2)
% bar(All_Tingle_map1(:,:,2));
% hold on;
% ylabel('Number of Responses')
% xlabel('Current Level (mA)')
% xticks([1 2 3 4 5 6 7 8 9]);
% xticklabels(Current_levels_str);
% title('3 Electrode');
% subplot(2,2,3)
% bar(All_Tingle_map1(:,:,3));
% hold on;
% ylabel('Number of Responses')
% xlabel('Current Level (mA)')
% xticks([1 2 3 4 5 6 7 8 9]);
% xticklabels(Current_levels_str);
% title('4 Electrode');
% subplot(2,2,4)
% bar(All_map);
% lgd = legend('none','noticeable', 'moderate', 'severe');
% sgtitle('Tingling Reports')
% % lgd.Layout.Tile = 4;
% 
% % Code that generates the plots based on the responses

