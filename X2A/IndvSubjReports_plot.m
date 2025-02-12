% this script creates sand plots for the 0.5Hz waveform across all mA 
% amplitudes with icons for individual subjects and also accounts for
% "no report" trials 

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

prof = 4; 
%% plotting code for Motion Rating
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
        
figure; %figure for Motion Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = config_names(config);
    MapAreaPlot(Sin05Hz_MotionRating_map(2:end,:,config),Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
    set(gca, 'color', [0 0 0]);
    xlim([0.35 4.15]);
    

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
%         d3 = 1;
%         d4 = 4;
%         d3max = 3;
%         d4max = 5;
           
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
        plot(Label.CurrentAmp+xoffset(sub), y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Motion Sensation" Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["MotionRatings" Profiles_safe(prof) "AllCurrentAreaPlotSymbols"]));
        
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);

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
        
figure; %figure for Motion Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = config_names(config);
    MapAreaPlot(Sin05Hz_Tingle_map(2:end,:,config),Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
    set(gca, 'color', [0 0 0]);
    xlim([0.35 4.15]);
    

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
%         d3 = 1;
%         d4 = 4;
%         d3max = 3;
%         d4max = 5;
           
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
        plot(Label.CurrentAmp+xoffset(sub), y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Tingling Sensation" Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["Tingling" Profiles_safe(prof) "AllCurrentAreaPlotSymbols"]));
        
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);


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
        
figure; %figure for Motion Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = config_names(config);
    MapAreaPlot(Sin05Hz_Metallic_map(2:end,:,config),Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
    set(gca, 'color', [0 0 0]);
    xlim([0.35 4.15]);
    

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
%         d3 = 1;
%         d4 = 4;
%         d3max = 3;
%         d4max = 5;
           
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
        plot(Label.CurrentAmp+xoffset(sub), y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Metallic Taste" Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["Metallic" Profiles_safe(prof) "AllCurrentAreaPlotSymbols"]));
        
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);

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
        
figure; %figure for Motion Rating
t1 = tiledlayout(2,2);
for config = 1:num_config %generate electrode subplots
    nexttile; 
    Title = config_names(config);
    MapAreaPlot(Sin05Hz_VisFlash_map(2:end,:,config),Title,100, ["none", "noticeable", "moderate", "severe", "no report"],Color_list)
    hold on; 
    set(gca, 'color', [0 0 0]);
    xlim([0.35 4.15]);
    

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
%         d3 = 1;
%         d4 = 4;
%         d3max = 3;
%         d4max = 5;
           
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
        plot(Label.CurrentAmp+xoffset(sub), y_val(:,config), sub_symbols(sub))
    
    end
end
        %add labels and info to the plot
        ylabel("                        Number of Responses", "FontSize", 35)
        xlabel("Current mA", "FontSize", 37)
        
        lgd = legend('none','noticeable', 'moderate', 'severe', 'no report', 'FontSize', 38 );
        lgd.Layout.Tile = 4;
        lgd.Color =  [1 1 1];
        
        TotalTitle = char(strjoin(["Reported Visual Flashes" Profiles(prof)]));
        sgtitle( TotalTitle, "FontSize", 50);
        Filename = char(strjoin(["VisFlash" Profiles_safe(prof) "AllCurrentAreaPlotSymbols"]));
        
        %save plot
        cd(plots_path);
        saveas(gcf, [char(Filename) '.fig']);
        cd(code_path);