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
plot_list = ["N Vel"; "N Ang&Vel"; "N Ang"; "None";"P Vel"; "P Ang&Vel"; "P Ang"];
prof = ["4A"; "5A"; "6A"; "4B";"5B"; "6B"; ];
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

%preallocate for aggregating metric across subjects
for p = 1: length(prof)
    eval(["All_avg_rms_" + prof(p) + "= zeros(1,length(match_list));"]);
    eval(["num_trials_" + prof(p) + "= zeros(1, length(match_list));"]);
    eval(["num_sub_trials_" + prof(p) + "= zeros(numsub, length(match_list));"]);
    eval(["rms_save_" + prof(p) + "= zeros(numsub, length(match_list));"]);
end 

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

% RMS calculation 
for p = 1: length(prof)
    eval(["rms_" + prof(p) + "= rms(shot_" + prof(p) ...
        + "(51:end-50,:)-mean(shot_" + prof(p) + "(51:end-50,:)));"]);
end
    
%indv rms plot
figure;
for p = 1: length(prof)
    subplot(2,3,p)
    eval(["plot_single_outcomes(rms_" + prof(p) + ",Label.shot_" + prof(p) + ", Color_List,match_list);"]);
    title (["Profile " + prof(p)]);
end
    hold on; 
    sgtitle(['RMS: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'RMSShort' datatype subject_str  ]); 
    cd(code_path);
    hold off;  

 % add the current subject's data into the aggregate variable
    %and increment the number of trials averaged into each trial type based on
    %the trial data available for the current subject. Use the
    %AggregateSingleMetric function

for p = 1: length(prof)
    eval(["[All_avg_rms_" + prof(p) + ",num_trials_" + prof(p) + ...
        ",rms_save_" + prof(p) + ",num_sub_trials_" + prof(p) + ...
        "] =  AggregateSingleMetric(rms_" + prof(p) + ", Label.shot_" ...
        + prof(p) + ", sub, All_avg_rms_" + prof(p) + ",num_trials_" ...
        + prof(p) + ",rms_save_" + prof(p) + ",num_sub_trials_" + prof(p) ...
        + ", match_list);"]);
end

%update the label
Label_rms = match_list;

    %% save files
   cd(plots_path);
   vars_2_save = ['Label rms_4A rms_4B rms_5A rms_5B rms_6A rms_6B' ];
   eval(['  save ' ['S' subject_str 'MeanRemovedRMSShort' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;
    
end
%divide the aggregate report by the number of trials added into it to get
%the average report across subjects and/or trials 
for p = 1: length(prof)
    eval(["All_avg_rms_" + prof(p) + "= All_avg_rms_" + prof(p) + "./num_trials_" + prof(p) + ";"]);
    eval(["rms_save_" + prof(p) + "= rms_save_" + prof(p) + "./num_sub_trials_" + prof(p) + ";"]);
end 

%create box plot
figure;
for p = 1: length(prof)
    subplot(2,3,p)
    eval(["boxplot(rms_save_" + prof(p) + ");"]);
    title (["Profile " + prof(p)]);
    xticks([1 2 3 4 5 6 7]);
    xticklabels(plot_list);
end
hold on; 
sgtitle(['RMS: AllSubjectsBoxPlot' datatype ]);

 cd(plots_path);
    saveas(gcf, [ 'RMSShortAllSubjectsBoxPlot' datatype  ]); 
    cd(code_path);
    hold off;

%all subjects averaged rms plot
figure;
for p = 1: length(prof)
    subplot(2,3,p)
    eval(["plot_single_outcomes(All_avg_rms_" + prof(p) + ",Label_rms, Color_List,match_list);"]);
    title (["Profile " + prof(p)]);
end
    hold on; 
    sgtitle(['RMS: AllSubjects' datatype ]);

    cd(plots_path);
    saveas(gcf, [ 'RMSShortAllSubjects' datatype  ]); 
    cd(code_path);
    hold off; 

    %% save files
   cd(plots_path);
   vars_2_save = ['Label_rms rms_save_4A rms_save_4B rms_save_5A rms_save_5B rms_save_6A rms_save_6B' ];
   eval(['  save ' ['SAllMeanRemovedRMSShort' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;

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