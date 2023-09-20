%% Script 5x for Dynamic GVS +Tilt
% this script calculates outcome measures (rms, total deflection ...) and
% then plots these outcomes for all trial types to help better visualize
% the data it takes its input from scripts 2 and 4 and should include
close all; 
clear; 
clc; 
%% set up
subnum = 1011:1022;  % Subject List 
numsub = length(subnum);
subskip = [1013 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'BiasTimeGain';

Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];

% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots/Measures/MeanRemovedRMS']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
    tts_path = [file_path '/TTSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots\Measures\MeanRemovedRMS']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
    tts_path = [file_path '\TTSProfiles'];
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

All_rms_4A = zeros(1,length(match_list));

All_rms_4B = All_rms_4A;
All_rms_5A = All_rms_4A;
All_rms_5B = All_rms_4A;
All_rms_6A = All_rms_4A;
All_rms_6B = All_rms_4A;
num_trials_4A = zeros(1, length(match_list));
num_trials_4B = num_trials_4A;
num_trials_5A = num_trials_4A;
num_trials_5B = num_trials_4A;
num_trials_6A = num_trials_4A;
num_trials_6B = num_trials_4A;


%% calculate and plot the different measures for each subject
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
   
%     subject_path = [file_path, '\PS' , subject_str];
    if ismac || isunix
        subject_path = [file_path, '/' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Group', datatype '.mat']);
    elseif ispc
        subject_path = [file_path, '\' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Group', datatype '.mat ']);
    end
    

    cd(code_path);
   

% RMS calculation and plots   
    rms_4A = rms(shot_4A-mean(shot_4A));
    rms_4B = rms(shot_4B-mean(shot_4B));
    rms_5A = rms(shot_5A-mean(shot_5A));
    rms_5B = rms(shot_5B-mean(shot_5B));
    rms_6A = rms(shot_6A-mean(shot_6A));
    rms_6B = rms(shot_6B-mean(shot_6B));
    
%     rmsA = [ rms4A; rms5A; rms6A ];
%     rmsB = [ rms4B; rms5B; rms6B ];
    
    % plot rms
    figure;
    subplot(2,3,1)
    plot_single_outcomes(rms_4A,Label.shot_4A, Color_List,match_list);
    title ("Profile 4A");
    subplot(2,3,2)
    plot_single_outcomes(rms_5A,Label.shot_5A, Color_List,match_list);
    title ("Profile 5A");
    subplot(2,3,3)
    plot_single_outcomes(rms_6A,Label.shot_6A, Color_List,match_list);
    title ("Profile 6A");
    subplot(2,3,4)
    plot_single_outcomes(rms_4B,Label.shot_4B, Color_List,match_list);
    title ("Profile 4B");
    subplot(2,3,5)
    plot_single_outcomes(rms_5B,Label.shot_5B, Color_List,match_list);
    title ("Profile 5B");
    subplot(2,3,6)
    plot_single_outcomes(rms_6B,Label.shot_6B, Color_List,match_list);
    title ("Profile 6B");
    hold on; 
    sgtitle(['RMS: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'RMS' datatype subject_str  ]); 
    cd(code_path);
    hold off;  


 % add the current subject's data into the aggregate variable
    %and increment the number of trials averaged into each trial type based on
    %the trial data available for the current subject

    for i = 1:length(Label.shot_4A)
        for j = 1:length(match_list)
            if contains(Label.shot_4A(i), match_list(j))
                All_rms_4A(:,j) = All_rms_4A(:,j)+rms_4A(:,i);
                num_trials_4A(j) = num_trials_4A(j)+1;
                rms_save_4A(:,sub,j) = rms_4A(:,i);
            end
        end
    end
    for i = 1:length(Label.shot_4B)
        for j = 1:length(match_list)
            if contains(Label.shot_4B(i), match_list(j))
                All_rms_4B(:,j) = All_rms_4B(:,j)+rms_4B(:,i);
                num_trials_4B(j) = num_trials_4B(j)+1;
                rms_save_4B(:,sub,j) = rms_4B(:,i);
            end
        end
    end
    for i = 1:length(Label.shot_5A)
        for j = 1:length(match_list)
            if contains(Label.shot_5A(i), match_list(j))
                All_rms_5A(:,j) = All_rms_5A(:,j)+rms_5A(:,i);
                num_trials_5A(j) = num_trials_5A(j)+1;
                rms_save_5A(:,sub,j) = rms_5A(:,i);
            end
        end
    end
    for i = 1:length(Label.shot_5B)
        for j = 1:length(match_list)
            if contains(Label.shot_5B(i), match_list(j))
                All_rms_5B(:,j) = All_rms_5B(:,j)+rms_5B(:,i);
                num_trials_5B(j) = num_trials_5B(j)+1;
                rms_save_5B(:,sub,j) = rms_5B(:,i);
            end
        end
    end
    for i = 1:length(Label.shot_6A)
        for j = 1:length(match_list)
            if contains(Label.shot_6A(i), match_list(j))
                All_rms_6A(:,j) = All_rms_6A(:,j)+rms_6A(:,i);
                num_trials_6A(j) = num_trials_6A(j)+1;
                rms_save_6A(:,sub,j) = rms_6A(:,i);
            end
        end
    end
    for i = 1:length(Label.shot_6B)
        for j = 1:length(match_list)
            if contains(Label.shot_6B(i), match_list(j))
                All_rms_6B(:,j) = All_rms_6B(:,j)+rms_6B(:,i);
                num_trials_6B(j) = num_trials_6B(j)+1;
                rms_save_6B(:,sub,j) = rms_6B(:,i);
            end
        end
    end



%divide the aggregate report by the number of trials added into it to get
%the average report across subjects (need to add a calculation of error)
All_rms_4A = All_rms_4A./num_trials_4A;
All_rms_4B = All_rms_4B./num_trials_4B;
All_rms_5A = All_rms_5A./num_trials_5A;
All_rms_5B = All_rms_5B./num_trials_5B;
All_rms_6A = All_rms_6A./num_trials_6A;
All_rms_6B = All_rms_6B./num_trials_6B;

%update the label
Label_rms_4A = match_list;
Label_rms_4B = match_list;
Label_rms_5A = match_list;
Label_rms_5B = match_list;
Label_rms_6A = match_list;
Label_rms_6B = match_list;


    %% save files
   cd(plots_path);
   vars_2_save = ['Label rms_4A rms_4B rms_5A rms_5B rms_6A rms_6B' ];
   eval(['  save ' ['S' subject_str 'MeanRemovedRMS' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;
    
end

% plot rms
    figure;
    subplot(2,3,1)
    plot_single_outcomes(All_rms_4A,Label_rms_4A, Color_List,match_list);
    title ("Profile 4A");
    subplot(2,3,2)
    plot_single_outcomes(All_rms_5A,Label_rms_5A, Color_List,match_list);
    title ("Profile 5A");
    subplot(2,3,3)
    plot_single_outcomes(All_rms_6A,Label_rms_6A, Color_List,match_list);
    title ("Profile 6A");
    subplot(2,3,4)
    plot_single_outcomes(All_rms_4B,Label_rms_4B, Color_List,match_list);
    title ("Profile 4B");
    subplot(2,3,5)
    plot_single_outcomes(All_rms_5B,Label_rms_5B, Color_List,match_list);
    title ("Profile 5B");
    subplot(2,3,6)
    plot_single_outcomes(All_rms_6B,Label_rms_6B, Color_List,match_list);
    title ("Profile 6B");
    hold on; 
    sgtitle(['RMS: AllSubjects' datatype ]);

    cd(plots_path);
    saveas(gcf, [ 'RMSAllSubjects' datatype  ]); 
    cd(code_path);
    hold off;

function plot_single_outcomes(outcome,label, Color_List,match_list)
    %plot data 
    A=bar([1], [outcome]');
    %format data
    xticklabels([""]);
    for j = 1:length(outcome)
        color_index = 1;
        for k = 1:length(match_list)
            %get the index (j) where the shot label matches one of the
            %predefined current/prop combinations listed in match_list
            if contains(label(j), match_list(k))
                % offset by one from the matching index because the 
                % color list should include a default color as the first
                % index
                color_index = k+1;
                outcome_legend(j) = match_list(k);
                break;
            end
        end
        %set to approcpriate color
        A(j).FaceColor = Color_List(color_index,:);
    end
    %modify legend text to help make it more readable/understandable
    outcome_legend = strrep(outcome_legend, '_', '.');
    outcome_legend = strrep(outcome_legend, '.7.00', ' Vel');
    outcome_legend = strrep(outcome_legend, '.7.50', ' Ang&Vel');
    outcome_legend = strrep(outcome_legend, '.8.00', ' Ang');
    outcome_legend = strrep(outcome_legend, '.00', '');
    outcome_legend = strrep(outcome_legend, 'P.', '+');
    outcome_legend = strrep(outcome_legend, 'N.', '-');
    legend(outcome_legend)
    hold on; 
end