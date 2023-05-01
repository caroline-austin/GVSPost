close all; 
clear all; 
clc; 
% code section 2 (run this 2nd - soon to be 3rd)
Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
datatype = '';
%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

subnum = 1011:1011;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
%     subject_path = [file_path, '\PS' , subject_str];
    subject_path = [file_path, '\' , subject_str];
    subject_plot_path = [plots_path '\' subject_str];
    mkdir(subject_plot_path);

    cd(subject_path);
    load(['PS', subject_str, 'Group', datatype, '.mat ']);
%     load(['PS', subject_str, '.mat ']);
    cd(code_path);
    [subject_filenames]=file_path_info2(code_path,subject_path ); % get files from file folder
    num_files = length(subject_filenames);
    mat_filenames = get_filetype(subject_filenames, 'mat');
    num_mat_files = length(mat_filenames);

%% Plot 4A with function
    [pos_prof] = find(contains(Label.shot_4A, 'P'));
    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, ...
        tilt_4A(1:trial_end,:),shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['4A Positive GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_4A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_4A, 'N'));
    [zero_prof] = find(contains(Label.shot_4A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, ...
        tilt_4A(1:trial_end,:),shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['4A Negative GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_4A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;


%% Plot 4B with function
    [pos_prof] = find(contains(Label.shot_4B, 'P'));
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, ...
        tilt_4B(1:trial_end,:),shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof, match_list);
    subplot(3,1,1)
    title(['4B Positive GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_4B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_4B, 'N'));
    [zero_prof] = find(contains(Label.shot_4B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, ...
        tilt_4B(1:trial_end,:),shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['4B Negative GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_4B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

% Plot 5A with function
    [pos_prof] = find(contains(Label.shot_5A, 'P'));
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, ...
        tilt_5A(1:trial_end,:),shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['5A Positive GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_5A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;
    [neg_prof] = find(contains(Label.shot_5A, 'N'));
    [zero_prof] = find(contains(Label.shot_5A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, ...
        tilt_5A(1:trial_end,:),shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['5A Negative GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_5A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;


%% Plot 5B with function
    [pos_prof] = find(contains(Label.shot_5B, 'P'));
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, ...
        tilt_5B(1:trial_end,:),shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof, match_list);
    subplot(3,1,1)
    title(['5B Positive GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_5B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_5B, 'N'));
    [zero_prof] = find(contains(Label.shot_5B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, ...
        tilt_5B(1:trial_end,:),shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['5B Negative GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_5B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;    

%% Plot 6A with function
    [pos_prof] = find(contains(Label.shot_6A, 'P'));
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, ...
        tilt_6A(1:trial_end,:),shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['6A Positive GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_6A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_6A, 'N'));
    [zero_prof] = find(contains(Label.shot_6A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, ...
        tilt_6A(1:trial_end,:),shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['6A Negative GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_6A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;


%% Plot 6B with function
    [pos_prof] = find(contains(Label.shot_6B, 'P'));
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, ...
        tilt_6B(1:trial_end,:),shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    subplot(3,1,1)
    title(['6B Positive GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_6B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_6B, 'N'));
    [zero_prof] = find(contains(Label.shot_6B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, ...
        tilt_6B(1:trial_end,:),shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    subplot(3,1,1)
    title(['6B Negative GVS Affects on Tilt Perception' datatype])

    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_6B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;    



%% save files
   cd(subject_path);
   vars_2_save = ['Label Trial_Info time trial_end shot_4A tilt_4A GVS_4A  shot_5A tilt_5A GVS_5A shot_6A tilt_6A GVS_6A shot_4B tilt_4B GVS_4B  shot_5B tilt_5B GVS_5B shot_6B tilt_6B GVS_6B'];
%    eval(['  save ' ['PS', subject_str, 'Group.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;

end

% %% debugging
% for i = 1:16
% %     if i == 17
% %         plot(time, tilt_4A(:,i)); legend();
% %     end
% plot(time, tilt_4A(:,i)); legend();
% hold on;
% end