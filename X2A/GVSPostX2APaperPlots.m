%% GVSPost X2A Script 5 : Create plots for paper from the aggregated data
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
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];
type_color = [Color_list(1,:);Color_list(2,:); Color_list(3,:);];
dir_simp_color = [Color_list(1,:);Color_list(2,:); Color_list(3,:); Color_list(6,:);];
time_color = [Color_list(1,:);Color_list(2,:); Color_list(3,:);];
dir_color = [Color_list(1,:);Color_list(1,:); Color_list(2,:); Color_list(2,:); Color_list(3,:); Color_list(3,:); Color_list(4,:); Color_list(1,:); Color_list(2,:); Color_list(6,:);];


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

%% First Plot (Paper Experiment 1A Sand plot of side effect intensity reports)
for prof = 4; % the sin 0.5Hz wave form only

    figure; %figure for all side effects (4 side effects/rows - 3 columns)
    t1 = tiledlayout(4,3, 'Padding','tight','TileSpacing', 'none' );

%  Motion Rating
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_MotionRating_map);
% reduce 4D var into 3D var -> dims = current, response, config and add
% extra colummn for the "no report" responses
Sin05Hz_MotionRating_map = [All_MotionRating_map(:,:,:,4) zeros(dim1,1,dim3)];
for i = 1:dim3
    for j = 1:dim1
        %check/calculate the number of recorded responses
        check = sum(Sin05Hz_MotionRating_map(j,:,i));
        %make sure all double reports were removed
        if check > numsub % may need to change back to num_sub
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Sin05Hz_MotionRating_map(j,end,i)=numsub-check;% may need to change back to num_sub

    end
end


for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = config_names(config);
    MapAreaPlot(Sin05Hz_MotionRating_map(2:end,:,config),Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
    set(gca, 'color', [0 0 0]);
    xlim([0.35 4.15]);
    ax = gca;
    ax.FontSize = 20;

    title(Title, "FontSize", 20)
    xticklabels([]);
    if config ~= 1
        yticklabels([]);
    else
        ylabel("Motion Sensation") 
    end


    for sub = 1:numsub
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
        load(['A' subject_str 'Extract.mat'])
        cd(code_path); 

        y_val = zeros(9,num_config, num_profiles);
        for row  = 1:9 %there are 9 current levels
            col = find(MotionRating_map(row,:,config,prof));

            if isempty(col) && row >1
               y_val(row,config) = numsub -0.5;
            elseif isempty(col)
                continue
            else
               num_same_responses = Sin05Hz_MotionRating_map(row, col, config);
               num_less_eq_responses = sum(Sin05Hz_MotionRating_map(row, 1:col, config));
               y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);

            end

        end
        plot(Label.CurrentAmp+xoffset(sub), y_val(:,config), sub_symbols(sub),LineWidth=1.5)

    end
end

%% plotting code for Tingling
[dim1, dim2, dim3, dim4] = size(All_Tingle_map);
Sin05Hz_Tingle_map = [All_Tingle_map(:,:,:,4) zeros(dim1,1,dim3)];
for i = 1:dim3
    for j = 1:dim1
        check = sum(Sin05Hz_Tingle_map(j,:,i));
        if check > numsub % may need to change back to num_sub
            disp("error too many reports ")
        end
        Sin05Hz_Tingle_map(j,end,i)=numsub-check;% may need to change back to num_sub

    end
end

for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = config_names(config);
    MapAreaPlot(Sin05Hz_Tingle_map(2:end,:,config),Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
    set(gca, 'color', [0 0 0]);
    xlim([0.35 4.15]);
    ax = gca;
    ax.FontSize = 20;
    title("", "FontSize", 1)
    xticklabels([]);
    if config ~= 1
        yticklabels([]);
    else
        ylabel("Skin Tingling") 
    end


    for sub = 1:numsub
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
        load(['A' subject_str 'Extract.mat'])
        cd(code_path); 

        y_val = zeros(9,num_config, num_profiles);
        for row  = 1:9 %there are 9 current levels
            col = find(Tingle_map(row,:,config,prof));

            if isempty(col) && row >1
               y_val(row,config) = numsub -0.5;
            elseif isempty(col)
                continue
            else
               num_same_responses = Sin05Hz_Tingle_map(row, col, config);
               num_less_eq_responses = sum(Sin05Hz_Tingle_map(row, 1:col, config));
               y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);

            end

        end
        plot(Label.CurrentAmp+xoffset(sub), y_val(:,config), sub_symbols(sub),LineWidth=1.5)

    end
end


%% plotting code for Metallic Taste
[dim1, dim2, dim3, dim4] = size(All_Metallic_map);
Sin05Hz_Metallic_map = [All_Metallic_map(:,:,:,4) zeros(dim1,1,dim3)];
for i = 1:dim3
    for j = 1:dim1
        check = sum(Sin05Hz_Metallic_map(j,:,i));
        if check > numsub % may need to change back to num_sub
            disp("error too many reports ")
        end
        Sin05Hz_Metallic_map(j,end,i)=numsub-check;% may need to change back to num_sub

    end
end

for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = config_names(config);
    MapAreaPlot(Sin05Hz_Metallic_map(2:end,:,config),Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
    set(gca, 'color', [0 0 0]);
    xlim([0.35 4.15]);
    ax = gca;
    ax.FontSize = 20;
    title("", "FontSize", 1)
    xticklabels([]);
    if config ~= 1
        yticklabels([]);
    else
        ylabel("Metallic Taste") 
    end


    for sub = 1:numsub
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
        load(['A' subject_str 'Extract.mat'])
        cd(code_path); 

        y_val = zeros(9,num_config, num_profiles);
        for row  = 1:9 %there are 9 current levels
            col = find(Metallic_map(row,:,config,prof));

            if isempty(col) && row >1
               y_val(row,config) = numsub -0.5;
            elseif isempty(col)
                continue
            else
               num_same_responses = Sin05Hz_Metallic_map(row, col, config);
               num_less_eq_responses = sum(Sin05Hz_Metallic_map(row, 1:col, config));
               y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);

            end

        end
        plot(Label.CurrentAmp+xoffset(sub), y_val(:,config), sub_symbols(sub),LineWidth=1.5)

    end
end

%% plotting code for Visual Flashes
[dim1, dim2, dim3, dim4] = size(All_VisFlash_map);
Sin05Hz_VisFlash_map = [All_VisFlash_map(:,:,:,4) zeros(dim1,1,dim3)];
for i = 1:dim3
    for j = 1:dim1
        check = sum(Sin05Hz_VisFlash_map(j,:,i));
        if check > numsub % may need to change back to num_sub
            disp("error too many reports ")
        end
        Sin05Hz_VisFlash_map(j,end,i)=numsub-check;% may need to change back to num_sub

    end
end

for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = config_names(config);
    MapAreaPlot(Sin05Hz_VisFlash_map(2:end,:,config),Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
    set(gca, 'color', [0 0 0]);
    xlim([0.35 4.15]);
    ax = gca;
    ax.FontSize = 20;
    title("", "FontSize", 1)

    if config ~= 1
        yticklabels([]);
        if config == 2
            xlabel("Current mA", "FontSize", 25)
        end
    else
        ylabel("Visual Flashes") 
    end

    for sub = 1:numsub
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
        load(['A' subject_str 'Extract.mat'])
        cd(code_path); 

        y_val = zeros(9,num_config, num_profiles);
        for row  = 1:9 %there are 9 current levels
            col = find(VisFlash_map(row,:,config,prof));

            if isempty(col) && row >1
               y_val(row,config) = numsub -0.5;
            elseif isempty(col)
                continue
            else
               num_same_responses = Sin05Hz_VisFlash_map(row, col, config);
               num_less_eq_responses = sum(Sin05Hz_VisFlash_map(row, 1:col, config));
               y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);

            end

        end
        plot(Label.CurrentAmp+xoffset(sub), y_val(:,config), sub_symbols(sub),LineWidth=1.5)

    end
end
        % %add labels and info to the plot
        % lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 38 );
        % lgd.Layout.Tile = 4;
        % lgd.Color =  [1 1 1];

        TotalTitle = char(strjoin(["Side Effect Ratings" Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 25);
        % 
        Filename = char(strjoin(["SideEffectRatings" Profiles_safe(prof) "AllCurrentSandPlotWithSubSymbols"]));

        % %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);
end

%% 2nd plot 

 %% Plot Motion Direction (simplified list)
     % color order: blue; green; yellow; red; navy; purple
     figure;
    t_dir = tiledlayout(3,4,"TileSpacing","none","Padding","tight");
for prof = 4
    
    for config = 1:num_config
        nexttile
        b = bar(All_Motion_map_simple (:,:,config,prof));
        
        for j = 1:length(dir_simp_color) 
            b(j).FaceColor = dir_simp_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;

        Title = config_names(config);
        title(Title, "FontSize", 45)
    
        Current_levels_str = ["0.1" ".5" "1" "1.5" "2" "2.5" "3" "3.5" "4"];
        xticks([1 2 3 4 5 6 7 8 9]);
        xticklabels(Current_levels_str);
        ylim([0 10])
        if prof == 4
            xlim([1.5 9.5])
        end
        grid minor;
        if config ~= 1
            yticklabels([]);
        else
            ylabel("Motion Direction") 
        end
    end
    % ylabel("                        Number of Responses", "FontSize", 35)
    % xlabel("Current mA", "FontSize", 37)
    lgd = legend(Label.direction_simple, 'FontSize', 38 );
    lgd.Layout.Tile = 4;

end
    %}

     %% Plot Motion Type (tilt trans)
    for prof = 4
    for config = 1:num_config
        nexttile
        b = bar(All_Type_map (:,:,config,prof));
        
        for j = 1:length(type_color) 
            b(j).FaceColor = type_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;
        title("", "FontSize", 1)
        
    
        Current_levels_str = ["0.1" ".5" "1" "1.5" "2" "2.5" "3" "3.5" "4"];
        xticks([1 2 3 4 5 6 7 8 9]);
        xticklabels(Current_levels_str);
        ylim([0 10])
        grid minor;
        if prof == 4
            xlim([1.5 9.5])
        end
        if config ~= 1
            yticklabels([]);
        else
            ylabel("Motion Type") 
        end
    end
    % ylabel("                        Number of Responses", "FontSize", 35)
    % xlabel("Current mA", "FontSize", 37)
    lgd = legend('Tilt','Translation', sprintf('General \n Instability'), 'FontSize', 38 );
    lgd.Layout.Tile = 8;
    % overall_title = strjoin(["Reported Motion Type",   Profiles(prof)]);
    % sgtitle(overall_title, "FontSize", 50)
    % 
    end

    %% Plot Motion Timing (rhythmic, continuous, intermittent)
    for prof= 4
    for config = 1:num_config
        nexttile
        b = bar(All_Timing_map (:,:,config,prof));
        
        for j = 1:length(time_color) 
            b(j).FaceColor = time_color(j,:);
        end
        ax = gca;
        ax.FontSize = 25;
        title("", "FontSize", 1)

        Current_levels_str = ["0.1" ".5" "1" "1.5" "2" "2.5" "3" "3.5" "4"];
        xticks([1 2 3 4 5 6 7 8 9]);
        xticklabels(Current_levels_str);
        ylim([0 10])
        grid minor;
        if prof == 4
            xlim([1.5 9.5])
        end
        if config ~= 1
            yticklabels([]);
            if config == 2
                xlabel("Current mA", "FontSize", 25)
            end
        else
            ylabel("Motion Timing") 
        end

    end
    % ylabel("                        Number of Responses", "FontSize", 35)
    % xlabel("Current mA", "FontSize", 37)
    lgd = legend('Rhythmic','Continuous', 'Intermittent', 'FontSize', 38 );
    lgd.Layout.Tile = 12;
    overall_title = strjoin(["Reported Motion Characteristics",   Profiles(prof)]);
    sgtitle(overall_title, "FontSize", 50)
    % 
    % Filename = strtrim(strjoin(["ElectrodeMotionTiming" Profiles_safe(prof) "AllCurrentGroupedBar"]));
    
    % cd(plots_path);
    % saveas(gcf, [char(Filename) '.fig']);
    % cd(code_path);
    end
    