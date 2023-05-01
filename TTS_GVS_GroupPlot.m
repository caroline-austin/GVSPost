close all; 
clear all; 
clc; 
% code section 7?
Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
datatype = 'Adj';
%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots\Group' datatype]; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

subnum = 1002:1005;  % Subject List 
numsub = length(subnum);
subskip = [100 40006];  %DNF'd subjects or subjects that didn't complete this part

cd(file_path);
load(['PSAll' datatype '.mat ']);
cd(code_path);

%% Plot 4A with function
    [pos_prof] = find(contains(Label.shot_4A, 'P'));
    [zero_prof] = find(contains(Label.shot_4A, '0_00'));
    pos_prof = [zero_prof ; pos_prof];

    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, ...
        tilt_4A(1:trial_end,:),All_shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['4A Positive GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Positive_4A_4_00mA_PerceptionAvg' datatype ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_4A, 'N'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, ...
        tilt_4A(1:trial_end,:),All_shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['4A Negative GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Negative_4A_4_00mA_PerceptionAvg'  datatype]); 
    cd(code_path);
    hold off;


%% Plot 4B with function
    [pos_prof] = find(contains(Label.shot_4B, 'P'));
    [zero_prof] = find(contains(Label.shot_4B, '0_00'));
    pos_prof = [zero_prof ; pos_prof];
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, ...
        tilt_4B(1:trial_end,:),All_shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['4B Positive GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Positive_4B_4_00mA_PerceptionAvg'  datatype]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_4B, 'N'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, ...
        tilt_4B(1:trial_end,:),All_shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['4B Negative GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Negative_4B_4_00mA_PerceptionAvg'  datatype]); 
    cd(code_path);
    hold off;

% Plot 5A with function
    [pos_prof] = find(contains(Label.shot_5A, 'P'));
    [zero_prof] = find(contains(Label.shot_5A, '0_00'));
    pos_prof = [zero_prof ; pos_prof];
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, ...
        tilt_5A(1:trial_end,:),All_shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['5A Positive GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Positive_5A_4_00mA_PerceptionAvg' datatype ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_5A, 'N'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, ...
        tilt_5A(1:trial_end,:),All_shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['5A Negative GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Negative_5A_4_00mA_PerceptionAvg' datatype ]); 
    cd(code_path);
    hold off;


%% Plot 5B with function
    [pos_prof] = find(contains(Label.shot_5B, 'P'));
    [zero_prof] = find(contains(Label.shot_5B, '0_00'));
    pos_prof = [zero_prof ; pos_prof];
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, ...
        tilt_5B(1:trial_end,:),All_shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['5B Positive GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Positive_5B_4_00mA_PerceptionAvg' datatype ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_5B, 'N'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, ...
        tilt_5B(1:trial_end,:),All_shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['5B Negative GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Negative_5B_4_00mA_PerceptionAvg'  datatype]); 
    cd(code_path);
    hold off;    

%% Plot 6A with function
    [pos_prof] = find(contains(Label.shot_6A, 'P'));
    [zero_prof] = find(contains(Label.shot_6A, '0_00'));
    pos_prof = [zero_prof ; pos_prof];
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, ...
        tilt_6A(1:trial_end,:),All_shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['6A Positive GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Positive_6A_4_00mA_PerceptionAvg' datatype ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_6A, 'N'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, ...
        tilt_6A(1:trial_end,:),All_shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['6A Negative GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Negative_6A_4_00mA_PerceptionAvg' datatype ]); 
    cd(code_path);
    hold off;


%% Plot 6B with function
    [pos_prof] = find(contains(Label.shot_6B, 'P'));
    [zero_prof] = find(contains(Label.shot_6B, '0_00'));
    pos_prof = [zero_prof ; pos_prof];
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, ...
        tilt_6B(1:trial_end,:),All_shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['6B Positive GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Positive_6B_4_00mA_PerceptionAvg' datatype ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_6B, 'N'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, ...
        tilt_6B(1:trial_end,:),All_shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['6B Negative GVS Affects on Tilt PerceptionAvg' datatype])

    cd(plots_path);
    saveas(gcf, [ 'Negative_6B_4_00mA_PerceptionAvg' datatype ]); 
    cd(code_path);
    hold off;    