%% GVSPost X2A Script 4 : Create plots from the aggregated data
% Caroline Austin 
% Created ?/?/2023? Last Modified:10/9/24
% this script handles the verbal reports data from X2A - this includes 
% verbal rating of none slight/noticeable moderate severe for motion
% sensations and side effects as well as qualitative descriptions of
% motion. This script plots the data that has been combined across subjects
% for visualization

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
cd ..
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder
cd(code_path)

subnum = 2001:2010;  % Subject List 

subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

%plot legend
% 1: Sand plots across all 9 current amplitudes, separate files for each 
% side effect and subplots for each electrode configuration, generates
% plots for 4 sides effects and 5 profiles (plot 10 is better)

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

% 7: plots the maximum tolerable current amplitudes in different electrode configurations
%responses vs current amplitude (mA), plots for 2/3/4 electrodes
%plots as 3 histograms

% 8: Plots the starting/ending impedances(kOhm) for 10 different impedance configurations, 
%plots as 1 figure with 10 subplot histograms

% 9: Plots reported sensations (tingling/flashes/taste/motion) at different
%currents for all electrode configurations (2/3/4) using each waveforms
%plots as 20 figures, each with 3 sand plots.
%Plots contain all 3 electrodes for a single property at a time


% 10: Plots as overlayed sand plots that seem to be identical to plots 9, with
%the slight difference that it shows the difference between cases with noe
%reported responses and cases where the response was no discomfort

% 11: This section plots motion timing, axis, and type, for several frequencies
%and electron configurations
%plots as 3 separate histograms

% 12: This section plots the observed motion direction for several frequencies
%and electron configurations
%plots as 2 separate histograms

% 13:

Include_plots = [ ' '];

% should probably insert a for loop that checks to make sure this file exists first
cd([file_path]);
load(['All_X2A.mat']); 
cd(code_path);

% [row, col, depth] = size(All_Tingle_map1);
% All_map = zeros(row, col);

% MapAreaPlot(All_Tingle_map1(:,:,1),Title,numsub)
num_sub = length(subject_label); 
numsub = 100;

if contains(Include_plots,'1 ')
%% Area Plots organized by side effects
%Plots contain all 3 electrodes for a single property at a time
% loops through for all 5 profiles

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
        
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        % 
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
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        
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
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        
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
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        disp("press any key to continue"); pause; 
        close all
    end

end
if contains(Include_plots,'2')
%% Reducece Area Plots organized by side effects
%Plots contain all 3 electrodes for a single property at a time
% area plot only for part 1 of the experiment 

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
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        
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
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        
        
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
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        
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
       % %save plot
       %  cd(plots_path);
       %  saveas(gcf, [char(Filename) '.fig']);
       %  cd(code_path);
        disp("press any key to continue"); pause; 
        close all
    end

end
if contains(Include_plots, ' 3')
%% Area Plots for Side Effects organized by the number of electrodes 
%this has not been updated for the 4D rating arrays
% % these plots have all of the side effects on the same plot and then makes 
% different plots for each electrode configuration for part 1 of the
% experiment 

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
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    end
end 
% 
% 
if contains(Include_plots, '4')
%% Plots contain all 3 electrodes for a single property at a time
 % bar plot only for part 1 of the experiment 
 %

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
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    
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
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    
    
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
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    
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
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
end
%}

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
%         ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Roll','Pitch', 'Yaw', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Direction",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionDirection" Profiles_safe(prof) "AllCurrentGroupedBar"]));
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    end
    %}

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
%         ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Rhythmic','Continuous', 'Intermittent', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Timing",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionTiming" Profiles_safe(prof) "AllCurrentGroupedBar"]));
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
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
%         ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Tilt','Translation', 'General Instability', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Type",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionType" Profiles_safe(prof) "AllCurrentGroupedBar"]));
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    disp("press any key to continue"); pause; 
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
%         ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Roll','Pitch', 'Yaw', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Direction",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionDirection" Profiles_safe(prof) "ReducedAllCurrentGroupedBar"]));
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
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
%         ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Rhythmic','Continuous', 'Intermittent', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Timing",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionTiming" Profiles_safe(prof) "ReducedAllCurrentGroupedBar"]));
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
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
%         ylim([0 6])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
    lgd = legend('Tilt','Translation', 'General Instability', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Type",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionType" Profiles_safe(prof) "ReducedAllCurrentGroupedBar"]));
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    disp("press any key to continue"); pause; 
    close all
    end
end

if contains(Include_plots, '7')
%% Plot the Max/minCurrents
%plots the maximum tolerable current amplitudes in different electrode configurations
%responses vs current amplitude (mA), plots for 2/3/4 electrodes
%plots as 3 histograms

    figure; 
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        config_order= [1,3,2];
        use_config = config_order(config);
        nexttile
        h1 = histogram(All_MaxCurrent(use_config,:),(Label.CurrentAmp+.01));
        h1.FaceColor = Color_list(4,:); %red
        ax = gca;
        ax.FontSize = 27;
        hold on; 
%         h2 = histogram(All_MinCurrent(config,:),(Label.CurrentAmp+.01));
%         h2.FaceColor = Color_list(3,:); %red
%         ax = gca;
%         ax.FontSize = 27;
        Title = strjoin([num2str(config+1) " Electrodes"]);
        title(Title, "FontSize", 45)
        ylim([0 num_sub])
    
    end
    ylabel("                        Number of Responses", "FontSize", 35)
    xlabel("Current mA", "FontSize", 37)
%     lgd = legend('Maximum Tolerable Current','Low Current', 'FontSize', 38 );
%     lgd.Layout.Tile = 4;
    overall_title = strjoin(["Maximum Tolerable Current Amplitudes"]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["Current_Hist"]));
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    disp("press any key to continue"); pause; 
    close all

end
if contains(Include_plots, '8')
%% Plot the Start/End Impedances
%plots the starting/ending impedances(kOhm) for 10 different impedance configurations, 
%plots as 10 histograms

    fig = figure; 
    t_dir = tiledlayout(3,4);
    Impedance_label = ["1-2"; "1-3"; "1-4"; "1-5"; "2-3"; ...
        "2-4"; "2-5"; "3-4"; "3-5"; "4-5"];
    
    Imp = [0:1:12];
    for config = 1:10 %10 impedance configurations
        nexttile
        h1 = histogram(All_StartImpedance(config,:),(Imp));
        h1.FaceColor = Color_list(2,:); %green
        ax = gca;
        ax.FontSize = 27;
        hold on; 
        h2 = histogram(All_EndImpedance(config,:),(Imp));
        h2.FaceColor = Color_list(6,:); %purple
        ax = gca;
        ax.FontSize = 27;
        Title = strjoin([ Impedance_label(config) ]);
        title(Title, "FontSize", 40)
        ylim([0 5])
        yticks([0 5]);
%         yticklabels(Current_levels_str);
        if config == 5
            ylabel("    Number of Measurements", "FontSize", 35)
        end
    
    end
%     sgylabel("Number of Measurements", "FontSize", 35)
%     sgxlabel("Impedance kOhms", "FontSize", 37)
    lgd = legend('Start','End', 'FontSize', 38 );
    lgd.Layout.Tile = 12;
    overall_title = strjoin(["Impedances Values"]);
    sgtitle(overall_title, "FontSize", 50)

    h3=axes(fig,'visible','off'); 
%     h3.Title.Visible='on';
    h3.XLabel.Visible='on';
%     h3.YLabel.Visible='on';
%     ylabel(h3,"Number of Measurements", "FontSize", 35);
    xlabel(h3,"Impedance kOhms", "FontSize", 30);
%     title(h3,'yourTitle');

    
    Filename = strtrim(strjoin(["Impedance_Hist"]));
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    disp("press any key to continue"); pause; 
    close all

end
if contains(Include_plots,'9')



%% Reducece Area Plots organized by side effects
%Plots contain all 3 electrodes for a single property at a time
% area plot only for part 1 of the experiment 

    for prof = 1:2%:num_profiles
        check = 0;
        [dim1, dim2, dim3, dim4] = size(All_Tingle_mapReduced);
        Prof_Tingle_mapReduced = [All_Tingle_mapReduced(:,:,:,prof) zeros(dim1,1,dim3)];
        for i = 1:dim3
            for j = 1:dim1
                check = sum(Prof_Tingle_mapReduced(j,:,i));
                if check > num_sub
                    disp("error too many reports ")
                end
                Prof_Tingle_mapReduced(j,end,i)=num_sub-check;
                
            end
        end

        if ismember(prof, [1 4 5])
            low_lim = 2;
            high_lim = 3;
        else 
            low_lim = 1;
            high_lim = 3;
        end

        figure; %Tingling
        t1 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            set(gca, 'Color', 'black') 
            hold on;
            MapAreaPlot(All_Tingle_mapReduced(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
            xlim([low_lim high_lim]);
        end
        
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe','FontSize', 38, 'Color', 'w' );    
        lgd.Layout.Tile = 4;


        TotalTitle = char(strjoin(["Reported Tingling Sensation " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["TingleRatings" Profiles_safe(prof) "ReducedCurrentAreaPlot"]));
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
  %%  
        figure; %Metallic Taste
        t2 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            set(gca, 'Color', 'black') 
            hold on;
            MapAreaPlot(All_Metallic_mapReduced(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
            xlim([low_lim high_lim]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 , 'Color', 'w' );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Metallic Taste " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MetallicRatings" Profiles_safe(prof) "ReducedCurrentAreaPlot"]));
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        
        
        figure;%Visual Flashes
        t3 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            set(gca, 'Color', 'black') 
            hold on;
            MapAreaPlot(All_VisFlash_mapReduced(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
            xlim([low_lim high_lim]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 , 'Color', 'w' );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Visual Flashes " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["VisualFlashRatings" Profiles_safe(prof) "ReducedCurrentAreaPlot"]));
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        
        figure;
        t4 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            set(gca, 'Color', 'black') 
            hold on;
            MapAreaPlot(All_MotionRating_mapReduced(:,:,config,prof),Title,numsub, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
            xlim([low_lim high_lim]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 , 'Color', 'w' );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Motion Sensation " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MotionRatings" Profiles_safe(prof) "ReducedCurrentAreaPlot"]));
       % %save plot
       %  cd(plots_path);
       %  saveas(gcf, [char(Filename) '.fig']);
       %  cd(code_path);

        % disp("press any key to continue"); pause; 
        % close all
    end

end


%plots... tbh im a little unsure about the difference between 10 and 9
%plots as overlayed line charts
if contains(Include_plots,'10')
%% Area Plots organized by side effects With Subject Lines Overlayed
    %Sand plots reported sensations (tingling/flashes/taste/motion) at different
%currents for all electrode configurations (2/3/4) using a sin 0.5Hz wave
%plots as 3 overlayed line charts
%Plots contain all 3 electrodes for a single property at a time
% Only Part 1 profile (4)
    prof = 4; 
        [dim1, dim2, dim3, dim4] = size(All_Tingle_map);
        Prof_Tingle_mapReduced = [All_Tingle_map(:,:,:,4) zeros(dim1,1,dim3)];
        for i = 1:dim3
            for j = 1:dim1
                check = sum(Prof_Tingle_mapReduced(j,:,i));
                if check > num_sub
                    disp("error too many reports ")
                end
                Prof_Tingle_mapReduced(j,end,i)=num_sub-check;
                
            end
        end
        
        figure; %figure for Tingling
        t1 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(Prof_Tingle_mapReduced(:,:,config),Title,numsub, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
            xlim([0.5 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Tingling Sensation" Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["TingleRatings" Profiles_safe(prof) "AllCurrentAreaPlot"]));
        
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        % 

       [dim1, dim2, dim3, dim4] = size(All_Metallic_map);
        Sin05Hz_Metallic_map = [All_Metallic_map(:,:,:,4) zeros(dim1,1,dim3)];
        for i = 1:dim3
            for j = 1:dim1
                check = sum(Sin05Hz_Metallic_map(j,:,i));
                if check > num_sub
                    disp("error too many reports ")
                end
                Sin05Hz_Metallic_map(j,end,i)=num_sub-check;
                
            end
        end

        figure;%figure for Metallic Taste
        t2 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(Sin05Hz_Metallic_map(:,:,config),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.5 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe','no report', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Metallic Taste " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MetallicRatings" Profiles_safe(prof) "AllCurrentAreaPlot"]));
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        

        [dim1, dim2, dim3, dim4] = size(All_VisFlash_map);
        Sin05Hz_VisFlash_map = [All_VisFlash_map(:,:,:,4) zeros(dim1,1,dim3)];
        for i = 1:dim3
            for j = 1:dim1
                check = sum(Sin05Hz_VisFlash_map(j,:,i));
                if check > num_sub
                    disp("error too many reports ")
                end
                Sin05Hz_VisFlash_map(j,end,i)=num_sub-check;
                
            end
        end

        figure;%figure for Visual Flashes
        t3 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(Sin05Hz_VisFlash_map(:,:,config),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.5 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe','no report', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        TotalTitle = char(strjoin(["Reported Visual Flashes " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["VisualFlashRatings" Profiles_safe(prof) "AllCurrentAreaPlot"]));
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        

        [dim1, dim2, dim3, dim4] = size(All_MotionRating_map);
        Sin05Hz_MotionRating_map = [All_MotionRating_map(:,:,:,4) zeros(dim1,1,dim3)];
        for i = 1:dim3
            for j = 1:dim1
                check = sum(Sin05Hz_MotionRating_map(j,:,i));
                if check > num_sub
                    disp("error too many reports ")
                end
                Sin05Hz_MotionRating_map(j,end,i)=num_sub-check;
                
            end
        end


        figure; %figure for Motion Sensation/intensity 
        t4 = tiledlayout(2,2);
        for config = 1:num_config %generate electrode subplots
            nexttile
            Title = strjoin([num2str(config+1) " Electrodes"]);
            MapAreaPlot(Sin05Hz_MotionRating_map(:,:,config),Title,numsub, ["none", "noticeable", "moderate", "severe"],Color_list)
            xlim([0.5 4]);
        end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        lgd = legend('none','noticeable', 'moderate', 'severe','no report', 'FontSize', 38 );
        lgd.Layout.Tile = 4;

        TotalTitle = char(strjoin(["Reported Motion Sensation " Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MotionRatings" Profiles_safe(prof) "AllCurrentAreaPlot"]));
        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
        disp("press any key to continue"); pause; 
        close all

end

if contains(Include_plots, '11')
%this section plots motion timing, axis, and type, for several frequencies
%and electron configurations
%plots as 3 separate histograms
%% Reduced Plot Motion Direction (roll, pitch, yaw data)
    for prof = 1:num_profiles
        Motion_map_Max(:,prof,:) = All_Motion_mapReduced (3,:,:,prof);
    end
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        bar_notation = Motion_map_Max (:,:,config)';
        b = bar(bar_notation);
        dir_color = [Color_list(1,:);Color_list(6,:); Color_list(4,:)];
        for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = dir_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
        title(Title, "FontSize", 45)
    
    
        Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(Current_levels_str);
        ylim([0 10])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
%     xlabel("Current mA", "FontSize", 37)
    lgd = legend("right", "left", "up", "down", "forward", "back", "circular", "roll", "pitch", "yaw", 'FontSize', 38, 'NumColumns', 2 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Axis at Max Current Amplitude"]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionDirectionAllProfMaxCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    
    %% Plot Motion Timing (rhythmic, continuous, intermittent)
    for prof = 1:num_profiles
        Timing_map_Max(:,prof,:) = All_Timing_mapReduced (3,:,:,prof);
    end
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        bar_notation = Timing_map_Max (:,:,config)';
        b = bar(bar_notation);
        time_color = [Color_list(2,:);Color_list(1,:); Color_list(3,:)];
        for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = time_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
        title(Title, "FontSize", 45)
        
       
    
        Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(Current_levels_str);
        ylim([0 10])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
%     xlabel("Current mA", "FontSize", 37)
    lgd = legend('Rhythmic','Continuous', 'Intermittent', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Timing at Max Current Amplitude"]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionTimingAllProfMaxCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
 
    
    
    %% Plot Motion Type (tilt, translation, general instability)
    for prof = 1:num_profiles
        Type_map_Max(:,prof,:) = All_Type_mapReduced (3,:,:,prof);
    end
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        bar_notation = Type_map_Max (:,:,config)';
        b = bar(bar_notation);
        type_color = [Color_list(5,:);Color_list(2,:); Color_list(3,:)];
        for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = type_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
        title(Title, "FontSize", 45)
        
    
       Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(Current_levels_str);
        ylim([0 10])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
%     xlabel("Current mA", "FontSize", 37)
    lgd = legend('Tilt','Translation', 'General Instability', 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Type at Max Current Amplitude"]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeMotionTypeAllProfMaxCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);
    disp("press any key to continue"); pause; 
    close all
end

if contains(Include_plots, '12')
%%  Reduced Plot Observed Motion Direction (right, left, up, down, forward, back, circular, roll, pitch, yaw)
%this section plots the observed motion direction for several frequencies
%and electron configurations
%plots as 2 separate histograms
    for prof = 1:num_profiles
        Observed_Motion_map_Max(:,prof,:) = All_Observed_Motion_mapReduced (3,:,:,prof);
    end
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        bar_notation = Observed_Motion_map_Max (:,:,config)';
        b = bar(bar_notation);
        dir_color = [Color_list(1,:);Color_list(6,:); Color_list(4,:)];
        for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = dir_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
        title(Title, "FontSize", 45)
    
    
        Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(Current_levels_str);
        ylim([0 10])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
%     xlabel("Current mA", "FontSize", 37)
    lgd = legend("right", "left", "up", "down", "forward", "back", "circular", "roll", "pitch", "yaw", 'FontSize', 38 ,'NumColumns',2);
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Observed Motion Axis at Max Current Amplitude"]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeObservedMotionDirectionAllProfMaxCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);

%% Reduced Plot Observed Motion Timing (rhythmic, continuous, intermittent)

    for prof = 1:num_profiles
        Observed_Timing_map_Max(:,prof,:) = All_Observed_Timing_mapReduced (3,:,:,prof);
    end
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        bar_notation = Observed_Timing_map_Max (:,:,config)';
        b = bar(bar_notation);
        type_color = [Color_list(5,:);Color_list(2,:); Color_list(3,:)];
        for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = type_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
        title(Title, "FontSize", 45)
        
    
       Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(Current_levels_str);
        ylim([0 10])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
%     xlabel("Current mA", "FontSize", 37)
    lgd = legend("rhythmic", "continuous", "intermittent", 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Observed Motion Timing at Max Current Amplitude"]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeObservedMotionTimingAllProfMaxCurrentGroupedBar"]));

    %% TRYING OUT SPIDER PLOTS
    for prof = 1:num_profiles
        Observed_Timing_map_Max(:,prof,:) = All_Observed_Timing_mapReduced (3,:,:,prof);
    end
    figure;
        t_dir = tiledlayout(2,2,'TileSpacing','none','Padding','tight');
        for config = 1:num_config
            nexttile
            bar_notation = Observed_Timing_map_Max (:,:,config)';
            s = spider_plot(bar_notation,'AxesLabels', {'Rhythmic', 'Continuous', 'Intermittent'},'AxesLimits', [0, 0, 0; 10, 10, 10] ...
                ,'AxesInterval', 5,'AxesDisplay', 'one','AxesPrecision', 0, 'AxesLabelsOffset', 0.2, 'AxesDataOffset', 0.1);
            %s.AxesLimits = [0, 0, 0; 10, 10, 10];
            %s.AxesDisplay = 'data';
            %s.AxesLabelsOffset = 0.2;
            %s.AxesDataOffset = 0.1;
            %type_color = [Color_list(5,:);Color_list(2,:); Color_list(3,:)];
            %{
            for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
                s(j).FaceColor = type_color(j,:);
            end
            %}
            ax = gca;
            ax.FontSize = 25;
        %     legend("roll", "pitch", "yaw")
            Title = strjoin([num2str(config+1) " Electrodes"]);
            title(Title, "FontSize", 45)
            
        
           %Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
            %xticks([1 2 3 4 5]);
            %xticklabels(Current_levels_str);
            %ylim([0 10])
        end
        %ylabel("                        Number of Responses", "FontSize", 35)
    %     xlabel("Current mA", "FontSize", 37)
        lgd = legend("DC+", "DC-", "0.25Hz", "0.5Hz", "1Hz", 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        overall_title = strjoin(["Observed Motion Timing at Max Current Amplitude"]);
        sgtitle(overall_title, "FontSize", 50)

        %% END OF TRYING SPIDER PLOTS
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);

    % close all
end

if contains(Include_plots, '13')
%%  Reduced Plot Reported Motion Direction (right, left, up, down, forward, back, circular, roll, pitch, yaw)
%this section plots the observed motion direction for several frequencies
%and electron configurations
%plots as 2 separate histograms
    for prof = 1:num_profiles
        Motion_map_Max(:,prof,:) = All_Motion_mapReduced (3,:,:,prof);
    end
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        bar_notation = Motion_map_Max (:,:,config)';
        bar_lateral = bar_notation(:,1)+bar_notation(:,2)+bar_notation(:,8);
        bar_fore_aft = bar_notation(:,5)+bar_notation(:,6)+bar_notation(:,9);
        bar_circular = bar_notation(:,7);
        bar_yaw = bar_notation(:,10);
        bar_data = [bar_lateral,bar_fore_aft,bar_circular,bar_yaw];
        b = bar(bar_data);
        dir_color = [Color_list(1,:);Color_list(6,:); Color_list(4,:)];
        for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = dir_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;
        
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
        title(Title, "FontSize", 45)
    
    
        Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(Current_levels_str);
        ylim([0 20])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
%     xlabel("Current mA", "FontSize", 37)
    lgd = legend("lateral","fore/aft","circular","yaw", 'FontSize', 38 ,'NumColumns',2);
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Axis at Max Current Amplitude"]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeReportedObservedMotionDirectionAllProfMaxCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);

%% Reduced Plot Reported Motion Timing (rhythmic, continuous, intermittent)

    for prof = 1:num_profiles
        Timing_map_Max(:,prof,:) = All_Timing_mapReduced (3,:,:,prof);
    end
    figure;
    t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        bar_notation = Timing_map_Max (:,:,config)';
        b = bar(bar_notation);
        type_color = [Color_list(5,:);Color_list(2,:); Color_list(3,:)];
        for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = type_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;
    %     legend("roll", "pitch", "yaw")
        Title = strjoin([num2str(config+1) " Electrodes"]);
        title(Title, "FontSize", 45)
        
    
       Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(Current_levels_str);
        ylim([0 10])
    end
    ylabel("                        Number of Responses", "FontSize", 35)
%     xlabel("Current mA", "FontSize", 37)
    lgd = legend("rhythmic", "continuous", "intermittent", 'FontSize', 38 );
    lgd.Layout.Tile = 4;
    overall_title = strjoin(["Reported Motion Timing at Max Current Amplitude"]);
    sgtitle(overall_title, "FontSize", 50)
    
    Filename = strtrim(strjoin(["ElectrodeReportedMotionTimingAllProfMaxCurrentGroupedBar"]));
    
    cd(plots_path);
    saveas(gcf, [char(Filename) '.fig']);
    cd(code_path);

    close all
end