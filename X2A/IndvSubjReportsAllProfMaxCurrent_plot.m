% this script creates stacked bar plots for the all waveforms across only at 
% the maximum current amplitudes with icons for individual subjects 
% and also accounts for "no report" trials 


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
black =  [0 0 0];
Color_list = [blue; green; yellow; red; black; navy; purple; ];

%naming variables 
Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
num_profiles = length(Profiles);
num_config = 3;
% sub_symbols = ["-ow";"-+w"; "-*w"; "-xw"; "-squarew"; "-^w"; "->w"; "-vw";"-<w"; "-pentagramw"];
sub_symbols = ["ow";"+w"; "*w"; "xw"; "squarew"; "^w"; ">w"; "vw";"<w"; "pentagramw"];

yoffset = [0.25;0.25;0.25;0.25;0.25;-0.25;-0.25;-0.25;-0.25;-0.25]; 
xoffset = [-0.2;-0.1;0;0.1;0.2;-0.2;-0.1;0;0.1;0.2]; 
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

%% plotting code for Motion Rating at max current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_MotionRating_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Max_MotionRating_map = zeros(dim2+1,dim3,dim4);
Max_MotionRating_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_MotionRating_mapReduced(end,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Max_MotionRating_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Max_MotionRating_map(end,i,j) = numsub-check;
        
    end
end
        
figure; %figure for Motion Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Max_MotionRating_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
            col = find(MotionRating_mapReduced(end,:,config,row));
    
            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Max_MotionRating_map(col, config, row);
               num_less_eq_responses = sum(Max_MotionRating_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
    
            end
            
        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Motion Intensity at High Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MotionRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);


%% plotting code for Tingling Rating at max current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_Tingle_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Max_Tingle_map = zeros(dim2+1,dim3,dim4);
Max_Tingle_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_Tingle_mapReduced(end,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Max_Tingle_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Max_Tingle_map(end,i,j) = numsub-check;
        
    end
end
        
figure; %figure for Tingle Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Max_Tingle_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
            col = find(Tingle_mapReduced(end,:,config,row));
    
            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Max_Tingle_map(col, config, row);
               num_less_eq_responses = sum(Max_Tingle_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
    
            end
            
        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Tingle Intensity at High Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["TingleRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);

%% plotting code for Visual Flashes Rating at max current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_VisFlash_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Max_VisFlash_map = zeros(dim2+1,dim3,dim4);
Max_VisFlash_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_VisFlash_mapReduced(end,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Max_VisFlash_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Max_VisFlash_map(end,i,j) = numsub-check;
        
    end
end
        
figure; %figure for VisFlash Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Max_VisFlash_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
            col = find(VisFlash_mapReduced(end,:,config,row));
    
            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Max_VisFlash_map(col, config, row);
               num_less_eq_responses = sum(Max_VisFlash_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
    
            end
            
        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Visual Flash Intensity at High Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["VisFlashRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);

%% plotting code for Metallic Taste Rating at max current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_Metallic_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Max_Metallic_map = zeros(dim2+1,dim3,dim4);
Max_Metallic_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_Metallic_mapReduced(end,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Max_Metallic_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Max_Metallic_map(end,i,j) = numsub-check;
        
    end
end
        
figure; %figure for Metallic Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Max_Metallic_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
            col = find(Metallic_mapReduced(end,:,config,row));
    
            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Max_Metallic_map(col, config, row);
               num_less_eq_responses = sum(Max_Metallic_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
    
            end
            
        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Metallic Taste Intensity at High Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MetallicRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);

%% Same plots for min ratings

%% plotting code for Motion Rating at min current
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
        
figure; %figure for Motion Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Min_MotionRating_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Motion Intensity at Low Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MotionRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);


%% plotting code for Tingling Rating at Min current
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
        
figure; %figure for Tingle Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Min_Tingle_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Tingle Intensity at Low Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["TingleRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);

%% plotting code for Visual Flashes Rating at Min current
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
        
figure; %figure for VisFlash Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Min_VisFlash_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Visual Flash Intensity at Low Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["VisFlashRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);

%% plotting code for Metallic Taste Rating at Min current
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
        
figure; %figure for Metallic Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Min_Metallic_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Metallic Taste Intensity at Low Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MetallicRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);


        %% Same plots for sham ratings

%% plotting code for Motion Rating at min current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_MotionRating_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Sham_MotionRating_map = zeros(dim2+1,dim3,dim4);
Sham_MotionRating_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_MotionRating_mapReduced(1,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Sham_MotionRating_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Sham_MotionRating_map(end,i,j) = numsub-check;
        
    end
end
        
figure; %figure for Motion Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Sham_MotionRating_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
            col = find(MotionRating_mapReduced(1,:,config,row));
    
            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Sham_MotionRating_map(col, config, row);
               num_less_eq_responses = sum(Sham_MotionRating_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
    
            end
            
        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Motion Intensity at Low Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MotionRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);


%% plotting code for Tingling Rating at Sham current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_Tingle_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Sham_Tingle_map = zeros(dim2+1,dim3,dim4);
Sham_Tingle_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_Tingle_mapReduced(1,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Sham_Tingle_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Sham_Tingle_map(end,i,j) = numsub-check;
        
    end
end
        
figure; %figure for Tingle Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Sham_Tingle_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
            col = find(Tingle_mapReduced(1,:,config,row));
    
            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Sham_Tingle_map(col, config, row);
               num_less_eq_responses = sum(Sham_Tingle_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
    
            end
            
        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Tingle Intensity at Low Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["TingleRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);

%% plotting code for Visual Flashes Rating at Sham current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_VisFlash_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Sham_VisFlash_map = zeros(dim2+1,dim3,dim4);
Sham_VisFlash_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_VisFlash_mapReduced(1,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Sham_VisFlash_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Sham_VisFlash_map(end,i,j) = numsub-check;
        
    end
end
        
figure; %figure for VisFlash Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Sham_VisFlash_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
            col = find(VisFlash_mapReduced(1,:,config,row));
    
            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Sham_VisFlash_map(col, config, row);
               num_less_eq_responses = sum(Sham_VisFlash_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
    
            end
            
        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Visual Flash Intensity at Low Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["VisFlashRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);

%% plotting code for Metallic Taste Rating at Sham current
% current , response, config, profile
[dim1, dim2, dim3, dim4] = size(All_Metallic_mapReduced);
% reduce 4D var into 3D var -> dims = response, config, profile and add
% extra colummn for the "no report" responses
Sham_Metallic_map = zeros(dim2+1,dim3,dim4);
Sham_Metallic_map(1:dim2,1:dim3,1:dim4) = [squeeze(All_Metallic_mapReduced(1,:,:,:))];% zeros(dim2+1,dim3,dim4)]; 
for i = 1:dim3 % all 3 configurations
    for j = 1:dim4 % all 5 profiles
        %check/calculate the number of recorded responses
        check = sum(Sham_Metallic_map(:,i,j)); 
        %make sure all double reports were removed
        if check > numsub 
            disp("error too many reports ")
        end
        %record/save the number of trials/subjects without reports
        Sham_Metallic_map(end,i,j) = numsub-check;
        
    end
end
        
figure; %figure for Metallic Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = strjoin([num2str(config+1) " Electrodes"]);
    MapStackedBarPlot(squeeze(Sham_Metallic_map(:,config,:))',Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
%     set(gca, 'color', [0 0 0]);
%     xlim([0.35 4.15]);
        profiles_str = ["DC+" "DC-" "0.25Hz" "0.5Hz" "1Hz"];
        xticks([1 2 3 4 5]);
        xticklabels(profiles_str);
        ylim([0 10])
    
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
            col = find(Metallic_mapReduced(1,:,config,row));
    
            %calculate and store proper the location information value for
            %the subject's symbol
            if isempty(col) 
                %no report
               symbol_y_val(row,config) = numsub -0.5;
            elseif length(col) >1
                disp(['There are multiple reports for this value']);  
            else 
                % place the symbol at center of bar 
               num_same_responses = Sham_Metallic_map(col, config, row);
               num_less_eq_responses = sum(Sham_Metallic_map(1:col, config,row));
               symbol_y_val(row,config) = (num_less_eq_responses - num_same_responses/2)+yoffset(sub);
    
            end
            
        end
        %add symbols to plot
        plot([1:num_profiles]+xoffset(sub), symbol_y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
%         xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 34 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Metallic Taste Intensity at Low Current Amplitude"]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MetallicRatingsAllWaveStackedBarPlotSymbols"]));
        
        %save plot
        % cd(plots_path);
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path);