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

%naming variables 
Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
num_profiles = length(Profiles);
num_config = 3;

%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '/Plots']; % specify where plots are saved
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 2001:2010;  % Subject List 
numsub = length(subnum); % need to calculate this differntly
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

%plot legend
% 1: Sand plots across all 9 current amplitudes, separate files for each 
% side effect and subplots for each electrode configuration, generates
% plots for 4 sides effects and 5 profiles

% 2: Sand plots for only sham, low, high current amplitudes, separate files 
% for each side effect and subplots for each electrode configuration, generates
% plots for 4 sides effects and 5 profiles

% 3: obselete

% 4: Bar plots across all 9 current amplitudes, separate files for each
% side effect and subplots for each electrode configureation - generates
% plots for 4 side effects and only the 0.5 Hz profile

% 5: Bar plots for all 9 current amplitudes, separate files 
% for Type, Direction, Timing and subplots for each electrode configuration, generates
% plots for 3 effects and 5 profiles

% 6: Bar plots for only sham, low, high current amplitudes, separate files 
% for Type, Direction, Timing and subplots for each electrode configuration, generates
% plots for 3 effects and 5 profiles

Include_plots = [' 2  6'];

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
% loops through for all 5 profiles
if contains(Include_plots,'1')
    for prof = 1:num_profiles
        figure; %figure for Tingling
        t1 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(All_Tingle_map(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Tingling Sensation " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["TingleRatings" Profiles_safe(prof) "AllCurrentAreaPlot"]));
        
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        figure;%figure for Metallic Taste
        t2 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(All_Metallic_map(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Metallic Taste " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MetallicRatings" Profiles_safe(prof) "AllCurrentAreaPlot"]));
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        figure;%figure for Visual Flashes
        t3 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(All_VisFlash_map(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Visual Flashes " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["VisualFlashRatings" Profiles_safe(prof) "AllCurrentAreaPlot"]));
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        figure; %figure for Motion Sensation/intensity 
        t4 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(All_MotionRating_map(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;

        TotalTitle = char(strjoin(["Reported Motion Sensation " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MotionRatings" Profiles_safe(prof) "AllCurrentAreaPlot"]));
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);

        close all
    end

end

%% Reducece Area Plots organized by side effects
%Plots contain all 3 electrodes for a single property at a time
% area plot only for part 1 of the experiment 
if contains(Include_plots,'2')
    for prof = 1:num_profiles
        figure; %Tingling
        t1 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(All_Tingle_mapReduced(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Tingling Sensation " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["TingleRatings" Profiles_safe(prof) "ReducedCurrentAreaPlot"]));
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        figure; %Metallic Taste
        t2 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(All_Metallic_mapReduced(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Metallic Taste " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MetallicRatings" Profiles_safe(prof) "ReducedCurrentAreaPlot"]));
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        
        figure;%Visual Flashes
        t3 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(All_VisFlash_mapReduced(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Visual Flashes " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["VisualFlashRatings" Profiles_safe(prof) "ReducedCurrentAreaPlot"]));
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);
        
        figure;
        t4 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(All_MotionRating_mapReduced(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.1 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Motion Sensation " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MotionRatings" Profiles_safe(prof) "ReducedCurrentAreaPlot"]));
       %save plot
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
    for config = 1:num_config
    figure;
    subplot(2,3,1)
    MapAreaPlot(All_Tingle_map1(:,:,config),"Tingle Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    subplot(2,3,2)
    MapAreaPlot(All_Metallic_map1(:,:,config),"Metallic Taste Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    subplot(2,3,3)
    MapAreaPlot(All_VisFlash_map1(:,:,config),"Visual Flashes Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    subplot(2,3,4)
    MapAreaPlot(All_MotionRating_map1(:,:,config),"Motion Sensations Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    subplot(2,3,5)
    MapAreaPlot(All_ObservedRating_map1(:,:,config),"Observed Motion Reporting",numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
    xlim([0.5 4]);
    
    
    subplot(2,3,6,"visible", "off")
    % lgd = legend(["none", "noticeable", "moderate", "severe"]);
    
    Total_title = strjoin([num2str(config+1) " Electrode Effects Ratings Sin 0.5Hz all Current"]);
    sgtitle(Total_title)
    
    Filename = strrep(strjoin([num2str(config+1) "ElectrodeEffectsRatingsSin0_5HzAllCurrent"]), ' ', '');
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
end 
% 
% 

%% Plots contain all 3 electrodes for a single property at a time
 % bar plot only for part 1 of the experiment 
if contains(Include_plots, '4')
    figure;
    t1 = tiledlayout(2,2);
    for config = 1:num_config
    nexttile
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(All_Tingle_map1(:,:,config),Title,numsub, ["none", "noticeable", "moderate", "severe"], Color_list)
    xlim([1.1 9.9]);
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    sgtitle("Reported Tingling Sensation", "FontSize", 50);
    Filename =  "TingleRatingsSin0_5HzAllCurrentStackedBar";
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    
    figure;
    t2 = tiledlayout(2,2);
    for config = 1:num_config
    nexttile
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(All_Metallic_map1(:,:,config),Title,numsub, ["none", "noticeable", "moderate", "severe"], Color_list)
    xlim([1.1 9.9]);
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    sgtitle("Reported Metallic Taste", "FontSize", 50)
    Filename = "MetallicRatingsSin0_5HzAllCurrentStackedBar";
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    
    
    figure;
    t3 = tiledlayout(2,2);
    for config = 1:num_config
    nexttile
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(All_VisFlash_map1(:,:,config),Title,numsub, ["none", "noticeable", "moderate", "severe"], Color_list)
    xlim([1.1 9.9]);
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    sgtitle("Reported Visual Flashes", "FontSize", 50)
    Filename = "VisualFlashRatingsSin0_5HzAllCurrentStackedBar";
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    
    figure;
    t4 = tiledlayout(2,2);
    for config = 1:num_config
    nexttile
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(All_MotionRating_map1(:,:,config),Title,numsub, ["none", "noticeable", "moderate", "severe"], Color_list)
    xlim([1.1 9.9]);
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    sgtitle("Reported Motion Sensation", "FontSize", 50)
    
    Filename = "MotionRatingsSin0_5HzAllCurrentStackedBar";
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
end

%plots for Direction, Type, and Timing all current amplitudes and all waveforms
if contains(Include_plots,'5')
    %% Plot Motion Direction (roll, pitch, yaw data)
    for prof = 1:num_profiles
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        b = bar(All_Motion_map (:,:,config,prof));
        ax = gca;
        ax.FontSize = 27;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
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
    overall_title = strjoin(["Reported Motion Direction",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionDirection" Profiles_safe(prof) "AllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
    %% Plot Motion Timing (rhythmic, continuous, intermittent)
    for prof= 1:num_profiles
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        b = bar(All_Timing_map (:,:,config,prof));
        ax = gca;
        ax.FontSize = 27;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
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
    overall_title = strjoin(["Reported Motion Timing",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionTiming" Profiles_safe(prof) "AllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
    
    
    %% Plot Motion Type (rhythmic, continuous, intermittent)
    for prof = 1:num_profiles
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        b = bar(All_Type_map (:,:,config,prof));
        ax = gca;
        ax.FontSize = 27;
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
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
    overall_title = strjoin(["Reported Motion Type",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionType" Profiles_safe(prof) "AllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    close all
    end
end

%plots for Direction, Type, and Timing for sham, low, high current amplitudes and all waveforms
if contains(Include_plots, '6')
%% Reduced Plot Motion Direction (roll, pitch, yaw data)
    for prof = 1:num_profiles
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        b = bar(All_Motion_mapReduced (:,:,config,prof));
        ax = gca;
        ax.FontSize = 27;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
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
    overall_title = strjoin(["Reported Motion Direction",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionDirection" Profiles_safe(prof) "ReducedAllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
    %% Plot Motion Timing (rhythmic, continuous, intermittent)
    for prof = 1:num_profiles
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        b = bar(All_Timing_mapReduced (:,:,config,prof));
        ax = gca;
        ax.FontSize = 27;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
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
    overall_title = strjoin(["Reported Motion Timing",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionTiming" Profiles_safe(prof) "ReducedAllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    end
    
    
    %% Plot Motion Type (rhythmic, continuous, intermittent)
    for prof = 1:num_profiles
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        b = bar(All_Type_mapReduced (:,:,config,prof));
        ax = gca;
        ax.FontSize = 27;
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
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
    overall_title = strjoin(["Reported Motion Type",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionType" Profiles_safe(prof) "ReducedAllCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    close all
    end
end

