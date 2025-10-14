%% GVSPost X2A Script 5b/c? : Create plots for supplementary material from the aggregated data
% Caroline Austin 
% Created 2/12/25
% this script handles the verbal reports data from X2A - this includes 
% verbal rating of none slight/noticeable moderate severe for motion
% sensations and side effects as well as qualitative descriptions of
% motion. This script plots the data that has been combined across subjects
% for visualization and use in the pitch paper. 

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
orange = [0.9020, 0.6235, 0.0000];  % golden orange
skyblue = [0.3373, 0.7059, 0.9137]; % sky blue
pink = [0.8353, 0.3686, 0.0000];    % strong warm pink
teal = [0.2667, 0.4471, 0.3843];    % muted teal
% yellow = [0.9451, 0.8941, 0.2588];  % soft yellow
brown = [0.7059, 0.3961, 0.1137];   % medium brown
yellow = [255 190 50]/255;
black = [0 0 0];
Color_list = [blue; green; yellow; red; black; navy; purple];
% type_color = [Color_list(1,:);Color_list(2,:); Color_list(3,:);];
% dir_simp_color = [Color_list(1,:);Color_list(2,:); Color_list(3,:); Color_list(7,:);];
% time_color = [Color_list(1,:);Color_list(2,:); Color_list(3,:);];
dir_simp_color = [green; skyblue; orange; pink] ;
type_color = [teal; purple; brown];
time_color = [ blue; yellow; red];
dir_color = [Color_list(1,:);Color_list(1,:); Color_list(2,:); Color_list(2,:); Color_list(3,:); Color_list(3,:); Color_list(4,:); Color_list(1,:); Color_list(2,:); Color_list(7,:);];


%naming variables 
Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
num_profiles = length(Profiles);
num_config = 3;
config_names = ["Binaural"; "Forehead"; "Temples"];
% sub_symbols = ["-ow";"-+w"; "-*w"; "-xw"; "-squarew"; "-^w"; "->w"; "-vw";"-<w"; "-pentagramw"];
sub_symbols = ["ow";"+w"; "*w"; "xw"; "squarew"; "^w"; ">w"; "vw";"<w"; "pentagramw"];

yoffset = [0.25;0.25;0.25;0.25;0.25;-0.25;-0.25;-0.25;-0.25;-0.25]; 
xoffset = [-0.1;-0.05;0;0.05;0.1;-0.1;-0.05;0;0.05;0.1]; 
%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
cd ..
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder
cd(code_path)

subnum = 2001:2010;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

used_sub = 0;
All_vars2save = [''];
cd(file_path);
load(['All_X2A.mat']); 
cd(code_path);


num_sub = length(subject_label); 

%% Plot the Max/minCurrents
%plots the maximum tolerable current amplitudes in different electrode configurations
%responses vs current amplitude (mA), plots for 2/3/4 electrodes
%plots as 3 histogram

    figure; 
    t_dir = tiledlayout(3,2, "TileSpacing","tight", 'Padding','tight');
    for config = 1:num_config
        config_order= [1,2,3];
        tile_order = [1,3,5];
        use_config = config_order(config);
        tile_index = tile_order(config);
        nexttile(tile_index)
        h1 = histogram(All_MaxCurrent(use_config,:),(Label.CurrentAmp+.01));
        h1.FaceColor = Color_list(4,:); %red
        ax = gca;
        ax.FontSize = 20;
        hold on; 
%         h2 = histogram(All_MinCurrent(config,:),(Label.CurrentAmp+.01));
%         h2.FaceColor = Color_list(3,:); %red
%         ax = gca;
%         ax.FontSize = 27;
        for sub_index = 1:length(All_MaxCurrent(use_config,:))
            plot(All_MaxCurrent(use_config,sub_index)-0.25+xoffset(sub_index),0.5+yoffset(sub_index),sub_symbols(sub_index))

        end
        Title = config_names(config);
        title(Title, "FontSize", 20)
        ylim([0 num_sub])
        if config == 1
            xticklabels([])
        elseif config ==2
            xticklabels([])
            ylabel(" Number of Participants", "FontSize", 20)
        end

    end

    xlabel("Current mA", "FontSize", 20)
    xticks([-0.25 0.25 0.75 1.25 1.75 2.25 2.75 3.25 3.75])
    xticklabels([0 0.5 1 1.5 2 2.5 3 3.5 4])

    for config = 1:num_config
        config_order= [1,2,3];
        tile_order = [2,4,6];
        use_config = config_order(config);
        tile_index = tile_order(config);
        nexttile(tile_index)

        h1 = histogram(All_MinCurrent(use_config,:),(Label.CurrentAmp+.01));
        h1.FaceColor = Color_list(4,:); %red
        ax = gca;
        ax.FontSize = 20;
        hold on; 
%         h2 = histogram(All_MinCurrent(config,:),(Label.CurrentAmp+.01));
%         h2.FaceColor = Color_list(3,:); %red
%         ax = gca;
%         ax.FontSize = 27;
        for sub_index = 1:length(All_MinCurrent(use_config,:))
            plot(All_MinCurrent(use_config,sub_index)-0.25+xoffset(sub_index),0.5+yoffset(sub_index),sub_symbols(sub_index))

        end
        Title = config_names(config);
        title(Title, "FontSize", 20)
        ylim([0 num_sub])
        if config == 1
            xticklabels([])
        elseif config ==2
            xticklabels([])
            % ylabel(" Number of Participants", "FontSize", 20)
        end

    end

    xlabel("Current mA", "FontSize", 20)
    xticks([-0.25 0.25 0.75 1.25 1.75 2.25 2.75 3.25 3.75])
    xticklabels([0 0.5 1 1.5 2 2.5 3 3.5 4])
    set(gcf,'position',[100,100,1000,900])  
%     lgd = legend('Maximum Tolerable Current','Low Current', 'FontSize', 38 );
%     lgd.Layout.Tile = 4;
    % overall_title = strjoin(["Maximum Tolerable Current Amplitudes"]);
    % sgtitle(overall_title, "FontSize", 50)

    Filename = strtrim(strjoin(["Current_Hist"]));

    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    % disp("press any key to continue"); pause; 
    % close all

%% Third Plot ()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plotting code for Motion Rating at max current
figure; %figure for Motion Rating
t1 = tiledlayout(4,3, "TileSpacing","tight", "Padding","tight");


% plotting code for Tingling Rating at max current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_Tingle_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Min_Tingle_map = zeros(dim2+1,dim3,dim4);
Min_Tingle_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_Tingle_mapReduced(2,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Min_Tingle_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Min_Tingle_map(end,i,j) = numsub-check;

    end
end

% figure; %figure for Tingle Rating
% t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = config_names(config);
    MapStackedBarPlot(squeeze(Min_Tingle_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        ax = gca;
        ax.FontSize = 20;
        xticks([1 2 3 4 5]);
        xticklabels([]);
        ylim([0 10])
        xlim([.25 5.75])

        if config ==3
            yticklabels([]);
            yyaxis right
            yticklabels([]);
            ylab = ylabel("Skin Tingling", "Color",'k') ;
            set(ylab, 'Rotation', -90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
        elseif config ~= 1
            yticklabels([]);

        end

% add individual subject responses on top
    for sub = 1:numsub
        subject = subnum(sub);
        subject_str = num2str(subject);
        % skip subjects that DNF'd or there is no data for
        if ismember(subject,subskip) == 1
           continue
        end
        %keep track of how many subjects included
        used_sub = used_sub +1;
        %save subject number for use elsewhere
        subject_label(used_sub)= subject;
        Label.Subject(used_sub)= subject;

        %load subject's individaul data 
        cd([file_path, '/' , subject_str]);
        load(['A' subject_str 'Extract.mat'])
        cd(code_path); 

        %initialize the array that will store the location of the
        %subject's symbols for each trial
%                       row         col
        symbol_y_val = zeros(num_profiles,num_config);
        for row  = 1:num_profiles
            %indentify the location of the subject's report
            col = find(Tingle_mapReduced(2,:,config,row));

            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Min_Tingle_map(col, config, row);
               num_less_eq_responses = sum(Min_Tingle_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);

            end

        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub)*2, symbol_y_val(:,config), sub_symbols(sub),LineWidth=1.5)

    end
end



%% plotting code for Metallic Taste Rating at max current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_Metallic_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Min_Metallic_map = zeros(dim2+1,dim3,dim4);
Min_Metallic_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_Metallic_mapReduced(2,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Min_Metallic_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Min_Metallic_map(end,i,j) = numsub-check;

    end
end

% figure; %figure for Metallic Rating
% t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = "";
    MapStackedBarPlot(squeeze(Min_Metallic_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
                xticks([1 2 3 4 5]);
        xticklabels([]);
        ylim([0 10])
        xlim([.25 5.75])
        ax = gca;
        ax.FontSize = 20;

        if config ==3
            yticklabels([]);
            yyaxis right
            yticklabels([]);
            ylab = ylabel("Metallic Taste", "Color",'k') ;
            set(ylab, 'Rotation', -90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');

        elseif config ~= 1
            yticklabels([]);

        end

% add individual subject responses on top
    for sub = 1:numsub
        subject = subnum(sub);
        subject_str = num2str(subject);
        % skip subjects that DNF'd or there is no data for
        if ismember(subject,subskip) == 1
           continue
        end
        %keep track of how many subjects included
        used_sub = used_sub +1;
        %save subject number for use elsewhere
        subject_label(used_sub)= subject;
        Label.Subject(used_sub)= subject;

        %load subject's individaul data 
        cd([file_path, '/' , subject_str]);
        load(['A' subject_str 'Extract.mat'])
        cd(code_path); 

        %initialize the array that will store the location of the
        %subject's symbols for each trial
%                       row         col
        symbol_y_val = zeros(num_profiles,num_config);
        for row  = 1:num_profiles
            %indentify the location of the subject's report
            col = find(Metallic_mapReduced(2,:,config,row));

            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Min_Metallic_map(col, config, row);
               num_less_eq_responses = sum(Min_Metallic_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);

            end

        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub)*2, symbol_y_val(:,config), sub_symbols(sub), LineWidth=1.5)

    end
end


        %% plotting code for Visual Flashes Rating at max current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_VisFlash_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Min_VisFlash_map = zeros(dim2+1,dim3,dim4);
Min_VisFlash_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_VisFlash_mapReduced(2,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Min_VisFlash_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Min_VisFlash_map(end,i,j) = numsub-check;

    end
end

% figure; %figure for VisFlash Rating
% t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = "";
    MapStackedBarPlot(squeeze(Min_VisFlash_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);

        xticks([1 2 3 4 5]);
        xticklabels([]);
        ylim([0 10])
        xlim([.25 5.75])

        if config ==3
            yticklabels([]);
            yyaxis right
            yticklabels([]);
            ylab = ylabel("Visual Flashes", "Color",'k') ;
            set(ylab, 'Rotation', -90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
        elseif config == 1
            ylabel("                  Number of subjects rating (N=10)")
        elseif config ~= 1
            yticklabels([]);
           
            
        end

       

% add individual subject responses on top
    for sub = 1:numsub
        subject = subnum(sub);
        subject_str = num2str(subject);
        % skip subjects that DNF'd or there is no data for
        if ismember(subject,subskip) == 1
           continue
        end
        %keep track of how many subjects included
        used_sub = used_sub +1;
        %save subject number for use elsewhere
        subject_label(used_sub)= subject;
        Label.Subject(used_sub)= subject;

        %load subject's individaul data 
        cd([file_path, '/' , subject_str]);
        load(['A' subject_str 'Extract.mat'])
        cd(code_path); 

        %initialize the array that will store the location of the
        %subject's symbols for each trial
%                       row         col
        symbol_y_val = zeros(num_profiles,num_config);
        for row  = 1:num_profiles
            %indentify the location of the subject's report
            col = find(VisFlash_mapReduced(2,:,config,row));

            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Min_VisFlash_map(col, config, row);
               num_less_eq_responses = sum(Min_VisFlash_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);

            end

        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub)*2, symbol_y_val(:,config), sub_symbols(sub), LineWidth=1.5)

    end
end
%% Motion at max current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_MotionRating_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Min_MotionRating_map = zeros(dim2+1,dim3,dim4);
Min_MotionRating_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_MotionRating_mapReduced(2,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Min_MotionRating_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Min_MotionRating_map(end,i,j) = numsub-check;

    end
end


for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = "";
    MapStackedBarPlot(squeeze(Min_MotionRating_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
    ax = gca;
    % ax.FontSize = 20;

 profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
        xlim([.25 5.75])
        ax = gca;
        ax.FontSize = 20;


        if config ==3
            yticklabels([]);
            yyaxis right
            yticklabels([]);
            ylab = ylabel("Motion Sensations", "Color",'k') ;
            set(ylab, 'Rotation', -90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
        
        elseif config == 2
            yticklabels([]);
                xlabel("Current Waveform", "FontSize", 25)
        elseif config ~= 1
            yticklabels([]);
        end

        
% add individual subject responses on top
    for sub = 1:numsub
        subject = subnum(sub);
        subject_str = num2str(subject);
        % skip subjects that DNF'd or there is no data for
        if ismember(subject,subskip) == 1
           continue
        end
        %keep track of how many subjects included
        used_sub = used_sub +1;
        %save subject number for use elsewhere
        subject_label(used_sub)= subject;
        Label.Subject(used_sub)= subject;

        %load subject's individaul data 
        cd([file_path, '/' , subject_str]);
        load(['A' subject_str 'Extract.mat'])
        cd(code_path); 

        %initialize the array that will store the location of the
        %subject's symbols for each trial
%                       row         col
        symbol_y_val = zeros(num_profiles,num_config);
        for row  = 1:num_profiles
            %indentify the location of the subject's report
            col = find(MotionRating_mapReduced(2,:,config,row));

            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Min_MotionRating_map(col, config, row);
               num_less_eq_responses = sum(Min_MotionRating_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);

            end

        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub)*2, symbol_y_val(:,config), sub_symbols(sub),LineWidth=1.5)

    end
end

        TotalTitle = char(strjoin(["Side Effect Ratings at High Current Amplitude" ]));
        % sgtitle( TotalTitle, "FontSize", 25);
        % 
        Filename = char(strjoin(["Fig3SideEffectRatingsAllProvilesMinCurrentStackeBarPlotWithSubSymbols"]));
% 
%         %save plot
%         % cd(plots_path);
%         % saveas(gcf, [char(Filename) '.fig']);
%         % cd(code_path);

%% Fourth Plot (X2A part 2 motion characteristics)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%  Reduced Plot Reported Motion Direction Simplified (lateral, fore-aft circular,, yaw)
%this section plots the observed motion direction for several frequencies
%and electron configurations
%plots as 2 separate histograms
    figure;
    t_dir = tiledlayout(3,4,"TileSpacing","none", "Padding","tight");
    for config = 1:num_config
        nexttile
        b = bar(squeeze(All_Motion_map_simpleReduced(2,:,config,:))');
        for j = 1:length(dir_simp_color) % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = dir_simp_color(j,:);
        end
        ax = gca;
        ax.FontSize = 22;
        
        Title = config_names(config);
        title(Title, "FontSize", 30)
            
        xticks([1 2 3 4 5]);
        xticklabels([]);
        ylim([0 10])
        grid minor;
        if config ~= 1
            yticklabels([]);
        else
            ylabel("Motion Direction") 
        end
    end
    lgd = legend(Label.direction_simple, 'FontSize', 30 );
    lgd.Layout.Tile = 4;
    
    %% Plot Motion Type (tilt, translation, general instability)
    for prof = 1:num_profiles
        Type_map_Min(:,prof,:) = All_Type_mapReduced (2,:,:,prof);
    end
    % figure;
    % t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        bar_notation = Type_map_Min (:,:,config)';
        b = bar(bar_notation);
        for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = type_color(j,:);
        end
        ax = gca;
        ax.FontSize = 22;

               xticks([1 2 3 4 5]);
        xticklabels([]);
        ylim([0 10])
        grid minor;
        if config ~= 1
            yticklabels([]);
        else
            ylabel("Motion Type") 
        end
    end
    lgd = legend(Label.motion_type, 'FontSize', 30 );
    lgd.Layout.Tile = 8;

        %% Plot Motion Timing (rhythmic, continuous, intermittent)
    for prof = 1:num_profiles
        Timing_map_Min(:,prof,:) = All_Timing_mapReduced (2,:,:,prof);
    end
    % figure;
    % t_dir = tiledlayout(2,2);
    for config = 1:num_config
        nexttile
        bar_notation = Timing_map_Min (:,:,config)';
        b = bar(bar_notation);
        for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
            b(j).FaceColor = time_color(j,:);
        end
        ax = gca;
        ax.FontSize = 22;

        Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(Current_levels_str);
        ylim([0 10])
                grid minor;

        if config ~= 1
            yticklabels([]);
            if config == 2
                xlabel("Current Waveform", "FontSize", 22)
            end
        else
            ylabel("Motion Timing") 
        end

    end
    % ylabel("                        Number of Responses", "FontSize", 35)
    % xlabel("Current mA", "FontSize", 37)
    lgd = legend('Rhythmic','Continuous', 'Intermittent', 'FontSize', 30 );
    lgd.Layout.Tile = 12;
    overall_title = strjoin(["Reported Motion Characteristics at High Current Amplitude"]);
    % sgtitle(overall_title, "FontSize", 40)
    % 
    Filename = strtrim(strjoin(["Fig4MotionCharacterizationReportsAllProfilesMinCurrentGroupedBar"]));

    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);

%    %SHAM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sham
%     %% Rating Plot ()
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% plotting code for Motion Rating at max current
% figure; %figure for Motion Rating
% t1 = tiledlayout(4,3, "TileSpacing","tight", "Padding","tight");
% 
% 
% % plotting code for Tingling Rating at max current
% % current , response, config, profile
% [dim1, dim2, dim3, dim4] = size(All_Tingle_mapReduced);
% % reduce 4D var into 3D var -> dims = response, config, profile and add
% % extra colummn for the "no report" responses
% SHAM_Tingle_map = zeros(dim2+1,dim3,dim4);
% SHAM_Tingle_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_Tingle_mapReduced(1,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
% for i = 1:dim3 % all 3 configurations
%     for j = 1:dim4 % all 5 profiles
%         %check/calculate the number of recorded responses
%         check = sum(SHAM_Tingle_map(:,i,j)); 
%         %make sure all double reports were removed
%         if check > numsub 
%             disp("error too many reports ")
%         end
%         %record/save the number of trials/subjects without reports
%         SHAM_Tingle_map(end,i,j) = numsub-check;
% 
%     end
% end
% 
% % figure; %figure for Tingle Rating
% % t1 = tiledlayout(2,2);
% for config = 1:num_config %generate electrode subplots
%     nexttile; 
%     Title = config_names(config);
%     MapStackedBarPlot(squeeze(SHAM_Tingle_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
%     hold on; 
% %     set(gca, 'color', [0 0 0]);
% %     xlim([0.35 4.15]);
%         ax = gca;
%         ax.FontSize = 20;
%         xticks([1 2 3 4 5]);
%         xticklabels([]);
%         ylim([0 10])
%         xlim([.25 5.75])
% 
%         if config ==3
%             yticklabels([]);
%             yyaxis right
%             yticklabels([]);
%             ylab = ylabel("Skin Tingling", "Color",'k') ;
%             set(ylab, 'Rotation', -90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
%         elseif config ~= 1
%             yticklabels([]);
% 
%         end
% 
% % add individual subject responses on top
%     for sub = 1:numsub
%         subject = subnum(sub);
%         subject_str = num2str(subject);
%         % skip subjects that DNF'd or there is no data for
%         if ismember(subject,subskip) == 1
%            continue
%         end
%         %keep track of how many subjects included
%         used_sub = used_sub +1;
%         %save subject number for use elsewhere
%         subject_label(used_sub)= subject;
%         Label.Subject(used_sub)= subject;
% 
%         %load subject's individaul data 
%         cd([file_path, '/' , subject_str]);
%         load(['A' subject_str 'Extract.mat'])
%         cd(code_path); 
% 
%         %initialize the array that will store the location of the
%         %subject's symbols for each trial
% %                       row         col
%         symbol_y_val = zeros(num_profiles,num_config);
%         for row  = 1:num_profiles
%             %indentify the location of the subject's report
%             col = find(Tingle_mapReduced(1,:,config,row));
% 
%             %calculate and store proper the location information value for
%             %the subject's symbol
%             if isempty(col) 
%                 %no report
%                symbol_y_val(row,config) = numsub -0.5;
%             elseif length(col) >1
%                 disp(['There are multiple reports for this value']);  
%             else 
%                 % place the symbol at center of bar 
%                num_same_responses = SHAM_Tingle_map(col, config, row);
%                num_less_eq_responses = sum(SHAM_Tingle_map(1:col, config,row));
%                symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
% 
%             end
% 
%         end
%         %add symbols to plot
%         plot([1:num_profiles]+xoffset(sub)*2, symbol_y_val(:,config), sub_symbols(sub),LineWidth=1.5)
% 
%     end
% end
% 
% 
% 
% %% plotting code for Metallic Taste Rating at max current
% % current , response, config, profile
% [dim1, dim2, dim3, dim4] = size(All_Metallic_mapReduced);
% % reduce 4D var into 3D var -> dims = response, config, profile and add
% % extra colummn for the "no report" responses
% SHAM_Metallic_map = zeros(dim2+1,dim3,dim4);
% SHAM_Metallic_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_Metallic_mapReduced(1,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
% for i = 1:dim3 % all 3 configurations
%     for j = 1:dim4 % all 5 profiles
%         %check/calculate the number of recorded responses
%         check = sum(SHAM_Metallic_map(:,i,j)); 
%         %make sure all double reports were removed
%         if check > numsub 
%             disp("error too many reports ")
%         end
%         %record/save the number of trials/subjects without reports
%         SHAM_Metallic_map(end,i,j) = numsub-check;
% 
%     end
% end
% 
% % figure; %figure for Metallic Rating
% % t1 = tiledlayout(2,2);
% for config = 1:num_config %generate electrode subplots
%     nexttile; 
%     Title = "";
%     MapStackedBarPlot(squeeze(SHAM_Metallic_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
%     hold on; 
% %     set(gca, 'color', [0 0 0]);
% %     xlim([0.35 4.15]);
%                 xticks([1 2 3 4 5]);
%         xticklabels([]);
%         ylim([0 10])
%         xlim([.25 5.75])
%         ax = gca;
%         ax.FontSize = 20;
% 
%         if config ==3
%             yticklabels([]);
%             yyaxis right
%             yticklabels([]);
%             ylab = ylabel("Metallic Taste", "Color",'k') ;
%             set(ylab, 'Rotation', -90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
% 
%         elseif config ~= 1
%             yticklabels([]);
% 
%         end
% 
% % add individual subject responses on top
%     for sub = 1:numsub
%         subject = subnum(sub);
%         subject_str = num2str(subject);
%         % skip subjects that DNF'd or there is no data for
%         if ismember(subject,subskip) == 1
%            continue
%         end
%         %keep track of how many subjects included
%         used_sub = used_sub +1;
%         %save subject number for use elsewhere
%         subject_label(used_sub)= subject;
%         Label.Subject(used_sub)= subject;
% 
%         %load subject's individaul data 
%         cd([file_path, '/' , subject_str]);
%         load(['A' subject_str 'Extract.mat'])
%         cd(code_path); 
% 
%         %initialize the array that will store the location of the
%         %subject's symbols for each trial
% %                       row         col
%         symbol_y_val = zeros(num_profiles,num_config);
%         for row  = 1:num_profiles
%             %indentify the location of the subject's report
%             col = find(Metallic_mapReduced(1,:,config,row));
% 
%             %calculate and store proper the location information value for
%             %the subject's symbol
%             if isempty(col) 
%                 %no report
%                symbol_y_val(row,config) = numsub -0.5;
%             elseif length(col) >1
%                 disp(['There are multiple reports for this value']);  
%             else 
%                 % place the symbol at center of bar 
%                num_same_responses = SHAM_Metallic_map(col, config, row);
%                num_less_eq_responses = sum(SHAM_Metallic_map(1:col, config,row));
%                symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
% 
%             end
% 
%         end
%         %add symbols to plot
%         plot([1:num_profiles]+xoffset(sub)*2, symbol_y_val(:,config), sub_symbols(sub), LineWidth=1.5)
% 
%     end
% end
% 
% 
%         %% plotting code for Visual Flashes Rating at max current
% % current , response, config, profile
% [dim1, dim2, dim3, dim4] = size(All_VisFlash_mapReduced);
% % reduce 4D var into 3D var -> dims = response, config, profile and add
% % extra colummn for the "no report" responses
% SHAM_VisFlash_map = zeros(dim2+1,dim3,dim4);
% SHAM_VisFlash_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_VisFlash_mapReduced(1,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
% for i = 1:dim3 % all 3 configurations
%     for j = 1:dim4 % all 5 profiles
%         %check/calculate the number of recorded responses
%         check = sum(SHAM_VisFlash_map(:,i,j)); 
%         %make sure all double reports were removed
%         if check > numsub 
%             disp("error too many reports ")
%         end
%         %record/save the number of trials/subjects without reports
%         SHAM_VisFlash_map(end,i,j) = numsub-check;
% 
%     end
% end
% 
% % figure; %figure for VisFlash Rating
% % t1 = tiledlayout(2,2);
% for config = 1:num_config %generate electrode subplots
%     nexttile; 
%     Title = "";
%     MapStackedBarPlot(squeeze(SHAM_VisFlash_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
%     hold on; 
% %     set(gca, 'color', [0 0 0]);
% %     xlim([0.35 4.15]);
% 
%         xticks([1 2 3 4 5]);
%         xticklabels([]);
%         ylim([0 10])
%         xlim([.25 5.75])
% 
%         if config ==3
%             yticklabels([]);
%             yyaxis right
%             yticklabels([]);
%             ylab = ylabel("Visual Flashes", "Color",'k') ;
%             set(ylab, 'Rotation', -90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
%         elseif config == 1
%             ylabel("                  Number of subjects rating (N=10)")
%         elseif config ~= 1
%             yticklabels([]);
% 
% 
%         end
% 
% 
% 
% % add individual subject responses on top
%     for sub = 1:numsub
%         subject = subnum(sub);
%         subject_str = num2str(subject);
%         % skip subjects that DNF'd or there is no data for
%         if ismember(subject,subskip) == 1
%            continue
%         end
%         %keep track of how many subjects included
%         used_sub = used_sub +1;
%         %save subject number for use elsewhere
%         subject_label(used_sub)= subject;
%         Label.Subject(used_sub)= subject;
% 
%         %load subject's individaul data 
%         cd([file_path, '/' , subject_str]);
%         load(['A' subject_str 'Extract.mat'])
%         cd(code_path); 
% 
%         %initialize the array that will store the location of the
%         %subject's symbols for each trial
% %                       row         col
%         symbol_y_val = zeros(num_profiles,num_config);
%         for row  = 1:num_profiles
%             %indentify the location of the subject's report
%             col = find(VisFlash_mapReduced(1,:,config,row));
% 
%             %calculate and store proper the location information value for
%             %the subject's symbol
%             if isempty(col) 
%                 %no report
%                symbol_y_val(row,config) = numsub -0.5;
%             elseif length(col) >1
%                 disp(['There are multiple reports for this value']);  
%             else 
%                 % place the symbol at center of bar 
%                num_same_responses = SHAM_VisFlash_map(col, config, row);
%                num_less_eq_responses = sum(SHAM_VisFlash_map(1:col, config,row));
%                symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
% 
%             end
% 
%         end
%         %add symbols to plot
%         plot([1:num_profiles]+xoffset(sub)*2, symbol_y_val(:,config), sub_symbols(sub), LineWidth=1.5)
% 
%     end
% end
% %% Motion at max current
% % current , response, config, profile
% [dim1, dim2, dim3, dim4] = size(All_MotionRating_mapReduced);
% % reduce 4D var into 3D var -> dims = response, config, profile and add
% % extra colummn for the "no report" responses
% SHAM_MotionRating_map = zeros(dim2+1,dim3,dim4);
% SHAM_MotionRating_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_MotionRating_mapReduced(1,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
% for i = 1:dim3 % all 3 configurations
%     for j = 1:dim4 % all 5 profiles
%         %check/calculate the number of recorded responses
%         check = sum(SHAM_MotionRating_map(:,i,j)); 
%         %make sure all double reports were removed
%         if check > numsub 
%             disp("error too many reports ")
%         end
%         %record/save the number of trials/subjects without reports
%         SHAM_MotionRating_map(end,i,j) = numsub-check;
% 
%     end
% end
% 
% 
% for config = 1:num_config %generate electrode subplots
%     nexttile; 
%     Title = "";
%     MapStackedBarPlot(squeeze(SHAM_MotionRating_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
%     hold on; 
% %     set(gca, 'color', [0 0 0]);
% %     xlim([0.35 4.15]);
%     ax = gca;
%     % ax.FontSize = 20;
% 
%  profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
%         xticks([1 2 3 4 5]);
%         xticklabels(profiles_str);
%         ylim([0 10])
%         xlim([.25 5.75])
%         ax = gca;
%         ax.FontSize = 20;
% 
% 
%         if config ==3
%             yticklabels([]);
%             yyaxis right
%             yticklabels([]);
%             ylab = ylabel("Motion Sensations", "Color",'k') ;
%             set(ylab, 'Rotation', -90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
% 
%         elseif config == 2
%             yticklabels([]);
%                 xlabel("Current Waveform", "FontSize", 25)
%         elseif config ~= 1
%             yticklabels([]);
%         end
% 
% 
% % add individual subject responses on top
%     for sub = 1:numsub
%         subject = subnum(sub);
%         subject_str = num2str(subject);
%         % skip subjects that DNF'd or there is no data for
%         if ismember(subject,subskip) == 1
%            continue
%         end
%         %keep track of how many subjects included
%         used_sub = used_sub +1;
%         %save subject number for use elsewhere
%         subject_label(used_sub)= subject;
%         Label.Subject(used_sub)= subject;
% 
%         %load subject's individaul data 
%         cd([file_path, '/' , subject_str]);
%         load(['A' subject_str 'Extract.mat'])
%         cd(code_path); 
% 
%         %initialize the array that will store the location of the
%         %subject's symbols for each trial
% %                       row         col
%         symbol_y_val = zeros(num_profiles,num_config);
%         for row  = 1:num_profiles
%             %indentify the location of the subject's report
%             col = find(MotionRating_mapReduced(1,:,config,row));
% 
%             %calculate and store proper the location information value for
%             %the subject's symbol
%             if isempty(col) 
%                 %no report
%                symbol_y_val(row,config) = numsub -0.5;
%             elseif length(col) >1
%                 disp(['There are multiple reports for this value']);  
%             else 
%                 % place the symbol at center of bar 
%                num_same_responses = SHAM_MotionRating_map(col, config, row);
%                num_less_eq_responses = sum(SHAM_MotionRating_map(1:col, config,row));
%                symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
% 
%             end
% 
%         end
%         %add symbols to plot
%         plot([1:num_profiles]+xoffset(sub)*2, symbol_y_val(:,config), sub_symbols(sub),LineWidth=1.5)
% 
%     end
% end
% 
%         TotalTitle = char(strjoin(["Side Effect Ratings at High Current Amplitude" ]));
%         % sgtitle( TotalTitle, "FontSize", 25);
%         % 
%         Filename = char(strjoin(["Fig3SideEffectRatingsAllProvilesSHAMCurrentStackeBarPlotWithSubSymbols"]));
% % 
% %         %save plot
% %         % cd(plots_path);
% %         % saveas(gcf, [char(Filename) '.fig']);
% %         % cd(code_path);
% 
% %% Fourth Plot (X2A part 2 motion characteristics)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %%  Reduced Plot Reported Motion Direction Simplified (lateral, fore-aft circular,, yaw)
% %this section plots the observed motion direction for several frequencies
% %and electron configurations
% %plots as 2 separate histograms
%     figure;
%     t_dir = tiledlayout(3,4,"TileSpacing","none", "Padding","tight");
%     for config = 1:num_config
%         nexttile
%         b = bar(squeeze(All_Motion_map_simpleReduced(1,:,config,:))');
%         for j = 1:length(dir_simp_color) % 4 should acutally be a variable that is part of the size of All_map
%             b(j).FaceColor = dir_simp_color(j,:);
%         end
%         ax = gca;
%         ax.FontSize = 22;
% 
%         Title = config_names(config);
%         title(Title, "FontSize", 30)
% 
%         xticks([1 2 3 4 5]);
%         xticklabels([]);
%         ylim([0 10])
%         grid minor;
%         if config ~= 1
%             yticklabels([]);
%         else
%             ylabel("Motion Direction") 
%         end
%     end
%     lgd = legend(Label.direction_simple, 'FontSize', 30 );
%     lgd.Layout.Tile = 4;
% 
%     %% Plot Motion Type (tilt, translation, general instability)
%     for prof = 1:num_profiles
%         Type_map_SHAM(:,prof,:) = All_Type_mapReduced (1,:,:,prof);
%     end
%     % figure;
%     % t_dir = tiledlayout(2,2);
%     for config = 1:num_config
%         nexttile
%         bar_notation = Type_map_SHAM (:,:,config)';
%         b = bar(bar_notation);
%         for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
%             b(j).FaceColor = type_color(j,:);
%         end
%         ax = gca;
%         ax.FontSize = 22;
% 
%                xticks([1 2 3 4 5]);
%         xticklabels([]);
%         ylim([0 10])
%         grid minor;
%         if config ~= 1
%             yticklabels([]);
%         else
%             ylabel("Motion Type") 
%         end
%     end
%     lgd = legend(Label.motion_type, 'FontSize', 30 );
%     lgd.Layout.Tile = 8;
% 
%         %% Plot Motion Timing (rhythmic, continuous, intermittent)
%     for prof = 1:num_profiles
%         Timing_map_SHAM(:,prof,:) = All_Timing_mapReduced (1,:,:,prof);
%     end
%     % figure;
%     % t_dir = tiledlayout(2,2);
%     for config = 1:num_config
%         nexttile
%         bar_notation = Timing_map_SHAM (:,:,config)';
%         b = bar(bar_notation);
%         for j = 1:3 % 4 should acutally be a variable that is part of the size of All_map
%             b(j).FaceColor = time_color(j,:);
%         end
%         ax = gca;
%         ax.FontSize = 22;
% 
%         Current_levels_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
%         xticks([1 2 3 4 5]);
%         xticklabels(Current_levels_str);
%         ylim([0 10])
%                 grid minor;
% 
%         if config ~= 1
%             yticklabels([]);
%             if config == 2
%                 xlabel("Current Waveform", "FontSize", 22)
%             end
%         else
%             ylabel("Motion Timing") 
%         end
% 
%     end
%     % ylabel("                        Number of Responses", "FontSize", 35)
%     % xlabel("Current mA", "FontSize", 37)
%     lgd = legend('Rhythmic','Continuous', 'Intermittent', 'FontSize', 30 );
%     lgd.Layout.Tile = 12;
%     overall_title = strjoin(["Reported Motion Characteristics at High Current Amplitude"]);
%     % sgtitle(overall_title, "FontSize", 40)
%     % 
%     Filename = strtrim(strjoin(["Fig4MotionCharacterizationReportsAllProfilesSHAMCurrentGroupedBar"]));
% 
%     % cd(plots_path);
%     % saveas(gcf, [char(Filename) '.fig']);
%     % cd(code_path);