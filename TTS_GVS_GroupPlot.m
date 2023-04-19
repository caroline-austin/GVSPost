close all; 
clear all; 
clc; 
% code section 3
%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

subnum = 1002:1005;  % Subject List 
numsub = length(subnum);
subskip = [1004 40006];  %DNF'd subjects or subjects that didn't complete this part

tot_num = 0;
All_shot_4A = 0;
All_shot_4B = 0;
All_shot_5A = 0;
All_shot_5B = 0;
All_shot_6A = 0;
All_shot_6B = 0;

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    tot_num = tot_num+1;   

    subject_path = [file_path, '\PS' , subject_str];

    cd(subject_path);
    load(['PS', subject_str, 'Group.mat ']);
    
    cd(code_path);
    All_shot_4A = All_shot_4A+shot_4A;
    All_shot_4B = All_shot_4B+shot_4B;
    All_shot_5A = All_shot_5A+shot_5A;
    All_shot_5B = All_shot_5B+shot_5B;
    All_shot_6A = All_shot_6A+shot_6A;
    All_shot_6B = All_shot_6B+shot_6B;


end
All_shot_4A = All_shot_4A/tot_num;
All_shot_4B = All_shot_4B/tot_num;
All_shot_5A = All_shot_5A/tot_num;
All_shot_5B = All_shot_5B/tot_num;
All_shot_6A = All_shot_6A/tot_num;
All_shot_6B = All_shot_6B/tot_num;

%% Plot 4A with function
    [pos_prof] = find(contains(Label.shot_4A, 'P'));
%     pos_colors=['r'; 'r'; 'g'; 'g';'c'; 'c';'b';'b']; % PS1002
    pos_colors=['r'; 'r'; 'g'; 'c';'b']; % PS1003 and 4
    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, tilt_4A(1:trial_end,:),All_shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('4A Positive GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Positive_4A_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_4A, 'N'));
    [zero_prof] = find(contains(Label.shot_4A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, tilt_4A(1:trial_end,:),All_shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('4A Negative GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Negative_4A_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;


%% Plot 4B with function
    [pos_prof] = find(contains(Label.shot_4B, 'P'));
    pos_colors=[ 'r'; 'g'; 'c';'b']; % PS1003 and 4
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, tilt_4B(1:trial_end,:),All_shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('4B Positive GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Positive_4B_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_4B, 'N'));
    [zero_prof] = find(contains(Label.shot_4B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, tilt_4B(1:trial_end,:),All_shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('4B Negative GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Negative_4B_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;

% Plot 5A with function
    [pos_prof] = find(contains(Label.shot_5A, 'P'));
%     pos_colors=['r'; 'r'; 'g'; 'g'; 'g'; 'c'; 'c';'b';'b']; %PS1002
    pos_colors=['r'; 'r'; 'g'; 'c';'b']; % PS1003 and 4
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, tilt_5A(1:trial_end,:),All_shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('5A Positive GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Positive_5A_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;
%     pos_colors=['r'; 'r'; 'g';  'g';'c'; 'c';'b';'b']; % PS1002
    pos_colors=['r'; 'r'; 'g'; 'c';'b']; % PS1003 and 4
    [neg_prof] = find(contains(Label.shot_5A, 'N'));
    [zero_prof] = find(contains(Label.shot_5A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, tilt_5A(1:trial_end,:),All_shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('5A Negative GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Negative_5A_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;


%% Plot 5B with function
    [pos_prof] = find(contains(Label.shot_5B, 'P'));
    pos_colors=[ 'r'; 'g'; 'c';'b']; % PS1003 and 4
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, tilt_5B(1:trial_end,:),All_shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('5B Positive GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Positive_5B_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_5B, 'N'));
    [zero_prof] = find(contains(Label.shot_5B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, tilt_5B(1:trial_end,:),All_shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('5B Negative GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Negative_5B_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;    

%% Plot 6A with function
    [pos_prof] = find(contains(Label.shot_6A, 'P'));
%     pos_colors=['r'; 'r'; 'g'; 'c'; 'b']; %1003?
    pos_colors=['r'; 'r'; 'g'; 'c';'b']; % PS1003 and 4
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, tilt_6A(1:trial_end,:),All_shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('6A Positive GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Positive_6A_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_6A, 'N'));
    [zero_prof] = find(contains(Label.shot_6A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, tilt_6A(1:trial_end,:),All_shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('6A Negative GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Negative_6A_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;


%% Plot 6B with function
    [pos_prof] = find(contains(Label.shot_6B, 'P'));
    pos_colors=['r'; 'g'; 'c';'b']; % PS1003 and 4
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, tilt_6B(1:trial_end,:),All_shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('6B Positive GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Positive_6B_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_6B, 'N'));
    [zero_prof] = find(contains(Label.shot_6B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, tilt_6B(1:trial_end,:),All_shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('6B Negative GVS Affects on Tilt PerceptionAvg')

    cd(plots_path);
    saveas(gcf, [ 'Negative_6B_4_00mA_PerceptionAvg'  ]); 
    cd(code_path);
    hold off;    



%% save files
   cd(file_path);
   vars_2_save = ['Label Trial_Info time All_shot_4A tilt_4A GVS_4A ' ... 
       'All_shot_5A tilt_5A GVS_5A All_shot_6A tilt_6A GVS_6A ' ...
       'All_shot_4B tilt_4B GVS_4B  All_shot_5B tilt_5A GVS_5B All_shot_6B tilt_6B GVS_6B'];
   eval(['  save ' ['PS' 'All.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   

