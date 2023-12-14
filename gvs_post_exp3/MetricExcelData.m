% script 3b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        % This script takes the organized subject/trial data assumes that
        % it has been cut and then calculates the excel data metrics
        
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

%% set up
subnum = [3023:3033];  % Subject List 3001, 
numsub = length(subnum);
subskip = [3002,0];  %DNF'd subjects or subjects that didn't complete this part
% full subject data sets should have:
% FMT: 6 GIST files, (9+ excel rows, 6 XSENS files(?)
% tandem: 12 GIST files, 16(?) excel rows, 12 XSENS files (?)
% Romberg: 30 GIST files (6 training, 24 trials), 18 excel rows (6
% training, 12 trials), 30 XSENS files (6 training, 24 trials)
datatype = 'Cut_All'; % this tells the code which version of the data file to grab (ie. if other data processing has been done)
newdatatype = ''; % this adds the CUT suffix plus the file types that have been cut (GFMT, GTDM, GROM, XFMT, XTDM, XROM or ALL)

fsX = 30; %Hz = sampling freq of the XSENS IMU
fsG = 3.3; % Hz = approximate sampling frequency of the GIST
numtrials = 24;

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];
% sub_symbols = [">-k"; "v-k";"o-k";"+-k"; "*-k"; "x-k"; "square-k"; "^-k"; "<-k"; "pentagram-k"; "diamond-k"];
sub_symbols = [">k"; "vk";"ok";"+k"; "*k"; "xk"; "squarek"; "^k"; "<k"; "pentagramk"; "diamondk"];
sub_symbols_2 = [">m"; "vm";"om";"+m"; "*m"; "xm"; "squarem"; "^m"; "<m"; "pentagramm"; "diamondm"];
sub_symbols_3 = [">r"; "vr";"or";"+r"; "*r"; "xr"; "squarer"; "^r"; "<r"; "pentagramr"; "diamondr"];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
xoffset = [-0.02;-0.01;0;0.01;0.02;-0.02;-0.01;0;0.01;0.02;0]; 

%% Data Import setup

% set up pathing
code_path = strrep(pwd,'\','/'); %save code directory
% Set High Level Folder 
file_path =  strrep(uigetdir,'\','/'); %user selects file directory

% GIST File Locations
% Get List of Files & Folders in Directory
files = dir(file_path);

% Get a Logical Vector that Tells which is a Directory
dir_flags = [files.isdir];

% Extract Only Those that are Directories
sub_folders = files(dir_flags);

% Get Only the Folder Names into a Cell Array
sub_folder_names = {sub_folders(3:end).name};

% Remove 'plots' Folder
plot_folder_flag = strcmp(sub_folder_names, 'plots');
sub_folder_names = sub_folder_names(~plot_folder_flag);

%% Set Plot Locations

plot_path = [file_path '/plots/'];        
metric_path = [file_path '/Metrics/'];  

%% Initialize Storage Variables

% Initialize variables for balance metrics
% fmt_EXCEL_all = NaN(numsub,numtrials);
raw_time = NaN(numsub,6); corrected_time= raw_time;
k_val_fmt = raw_time; fmt_order = raw_time; errors = raw_time;
% tandem_EXCEL_all = fmt_EXCEL_all;
completion_time = NaN(numsub,12); correct_steps = completion_time;
k_val_tdm = completion_time; 
% condition_tdm = completion_time;
tdm_order = completion_time;
% romberg_EXCEL_all = fmt_EXCEL_all; 
failtime = NaN(numsub,24);
head_tilts_rom = failtime; k_val_rom = failtime;
% condition_rom = failtime; 
rom_order = failtime;


%% Enter Loop for Each Participant
participant_num = 0;
for sub = 1:(numsub) 
    % get subject number info set up
    subject = subnum(sub);
    subject_str = num2str(subject);

    if subject < 3023 
        current_participant = string(['P' subject_str]);
    else
        current_participant = string(['S' subject_str]);
    end
    % skip participants intended to be skipped    
    if ismember(subject,subskip) == 1
       continue
    end
    Label.subject = current_participant;
        % set up pathing and load data
        sub_path = strjoin([file_path, '/' , current_participant], '');
        cd(sub_path);
        load(strjoin([current_participant '_' datatype '.mat'],''));
        cd(code_path);

        % Increment Participant
        participant_num = participant_num + 1;
        sp_participant_list(participant_num) = current_participant;

            for trial = 1:width(fmt_EXCEL_sort)
                trial_info_fmt = fmt_EXCEL_sort{trial};
                fmt_EXCEL_all{sub,trial}=fmt_EXCEL_sort{trial};
                raw_time(sub,trial) = trial_info_fmt.RawTime;
                corrected_time(sub,trial) = trial_info_fmt.CorrectedTime;
                errors(sub,trial) = trial_info_fmt.Errors;
                k_val_fmt(sub,trial) = trial_info_fmt.KValue;
                fmt_order(sub,trial) = trial_info_fmt.trialOrder;
            end
            for trial = 1:width(tandem_EXCEL_sort)
                trial_info_tdm = tandem_EXCEL_sort{trial};
                tandem_EXCEL_all{sub,trial}=tandem_EXCEL_sort{trial};
                completion_time(sub,trial) = trial_info_tdm.CompletionTime;
                correct_steps(sub,trial) = trial_info_tdm.TotalGoodSteps;
                tandem_steps(sub,trial,:) = trial_info_tdm{1,9:18}; 
                k_val_tdm(sub,trial) = trial_info_tdm.KValue;
                condition_tdm(sub,trial) = Label.tandem(trial);
                eyes_tdm(sub,trial) = trial_info_tdm.Eyes;
                head_tilts_tdm(sub,trial) = trial_info_tdm.Headtilts;
                tdm_order(sub,trial) = trial_info_tdm.trialOrder;

            end
            for trial = 1:width(romberg_EXCEL_sort)
                trial_info_rom = romberg_EXCEL_sort{trial};
                romberg_EXCEL_all{sub,trial}=romberg_EXCEL_sort{trial};
                if rem(trial,2) ==0
                    failtime(sub,trial) = trial_info_rom.TimeOfFailure2;
                    rom_order(sub,trial) = trial_info_rom.trialOrder*2;
                else
                    failtime(sub,trial) = trial_info_rom.TimeOfFailure1;
                    rom_order(sub,trial) = trial_info_rom.trialOrder*2-1;
                end
                head_tilts_rom(sub,trial) = trial_info_rom.Headtilts;
                % eyes(sub,trial) = trial_info_rom.Eyes;
                k_val_rom(sub,trial) = trial_info_rom.KValue;
                condition_rom(sub,trial) = Label.romberg(trial);
            end

end

%%
figure;
for i = 1:height(raw_time)
    plot(k_val_fmt(i,:)/1000+xoffset(i),raw_time(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
title("FMT Raw Completion Time Performance",'FontSize', 20)
ylabel("Time (s)",'FontSize', 20)
xlabel("GVS scaling factor",'FontSize', 20)

figure;
for i = 1:height(corrected_time)
    plot(k_val_fmt(i,:)/1000+xoffset(i),corrected_time(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
title("FMT Corrected Completion Time Performance",'FontSize', 20)
ylabel("time(s)",'FontSize', 20)
xlabel("GVS scaling factor",'FontSize', 20)

%%
figure;
for i = 1:height(completion_time)
    plot(completion_time(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
xticks([1 2 3 4 5 6 7 8 9 10 11 12]);
xticklabels( Label.tandem);
title("Tandem Walk Completion Time Performance",'FontSize', 20)
ylabel("Time (s)",'FontSize', 20)
xlabel("Condition",'FontSize', 20)
%%
figure;
for i = 1:height(completion_time)
    plot(correct_steps(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
xticks([1 2 3 4 5 6 7 8 9 10 11 12]);
xticklabels( strrep(Label.tandem, '_', ''));
title("Tandem Walk Correct Steps")
ylabel("Number of Correct Steps", 'FontSize', 20)
xlabel("Condition", 'FontSize', 20)

% xlim ([9.5 12.5]);
% xticklabels( ["" "" "" "" "" "" "" "" ""  "No GVS"  "1mA @45 deg"  "2mA @45 deg" ]);
% ylim([0 10])
% title("Tandem Walk Correct Steps: Eyes Closed With ~30 deg Head Tilts", 'FontSize', 25)

%%
figure;
for i = 1:height(failtime)
    plot(failtime(i,:), sub_symbols(i),'MarkerSize',15);
    hold on;
end
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24]);
xticklabels( strrep(Label.romberg, '_',''));
title("Romberg Fail Time")
ylabel("Time (s)", 'FontSize', 20)
xlabel("Condition", 'FontSize', 20)

% xlim ([13 24]);
% xticklabels( ["" "" "" "" "" "" "" "" "" "" "" "" "No GVS" "No GVS" "No GVS" "No GVS" "1mA @45 deg" "1mA @45 deg" "1mA @45 deg" "1mA @45 deg" "2mA @45 deg" "2mA @45 deg" "2mA @45 deg" "2mA @45 deg"]);
% ylim([0 15.25])
% % title("Romberg Fail Time Eyes Closed With ~30 deg Head Tilts")
% title("Romberg Fail Time: Eyes Closed With ~30 deg Head Tilts", 'FontSize', 25)


%% save
    cd(metric_path);
    vars_2_save = ['tandem_EXCEL_all ' 'romberg_EXCEL_all ' 'fmt_EXCEL_all ' ...
        ' raw_time ' 'corrected_time ' 'errors ' ' k_val_fmt ' ' completion_time '  ' correct_steps ' 'tandem_steps ' '  k_val_tdm '...
        ' condition_tdm ' 'eyes_tdm ' 'head_tilts_tdm ' ' failtime ' ' head_tilts_rom '  ' condition_rom ' ...
        'fmt_order ' 'tdm_order ' 'rom_order '];
        % 'tandem_GIST_sort ' 'tandem_XSENS_sort ' 'tandem_EXCEL_sort ' ... 
        % 'romberg_GIST_sort ' 'romberg_XSENS_sort ' 'romberg_EXCEL_sort '... 
        % 'romberg_GIST_train_sort ' 'romberg_XSENS_train_sort ' 'romberg_EXCEL_train_sort ' ...
        % 'fmt_start_G ' 'fmt_end_G ' 'fmt_start_X ' 'fmt_end_X ' ...
        % 'tandem_start_G ' 'tandem_end_G ' 'tandem_start_X ' 'tandem_end_X ' ...
        % 'romberg_start_G ' 'romberg_end_G ' 'romberg_start_X ' 'romberg_end_X ' ];
        %can add other data aggregation saving later
        eval( strjoin(['  save ' strjoin([ "ExcelData_" datatype newdatatype '.mat '],'') vars_2_save  ' Label vars_2_save' ]));    
        % eval(['clear ' vars_2_save])
    cd(code_path);
    % close all;