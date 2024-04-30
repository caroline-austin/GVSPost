%% Script 5x for Dynamic GVS +Tilt
% this script calculates outcome measures (mae, ...) and
% then plots these outcomes for all trial types to help better visualize
% the data it takes its input from scripts 2 and 4 and should include
close all; 
clear; 
clc; 
%% set up
subnum = [1011:1022, 1066:1067];  % Subject List 
numsub = length(subnum);
subskip = [1013 1015 1019 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'BiasTimeGain';

Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
plot_list = ["N Vel"; "N Ang&Vel"; "N Ang"; "None";"P Vel"; "P Ang&Vel"; "P Ang"];
prof = ["4A"; "5A"; "6A"; "4B";"5B"; "6B"; ];

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];

sub_symbols = ["kpentagram";"k<";"khexagram";"k>"; "kdiamond";"kv";"ko";"k+"; "k*"; "kx"; "ksquare"; "k^";];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15; -0.15; -0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 


% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots/Measures/MeanAbsError']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
    tts_path = [file_path '/TTSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots\Measures\MeanAbsError']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
    tts_path = [file_path '\TTSProfiles'];
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

for p = 1: length(prof)
    eval(["All_avg_mae_" + prof(p) + "= zeros(1,length(match_list));"]);
    eval(["num_trials_" + prof(p) + "= zeros(1, length(match_list));"]);
    eval(["num_sub_trials_" + prof(p) + "= zeros(numsub, length(match_list));"]);
    eval(["mae_save_" + prof(p) + "= zeros(numsub, length(match_list));"]);

    All_avg_mae_all= zeros(1,length(match_list));
    All_avg_mae_all_norm= zeros(1,length(match_list));
    num_trials_all= zeros(1, length(match_list));
    num_sub_trials_all= zeros(numsub, length(match_list));
    mae_save_all= zeros(numsub, length(match_list));
    mae_save_all_norm= zeros(numsub, length(match_list));
end 

for j = 1:length(match_list)
    eval(["shot_" + match_list(j) + " =[];"]);
    eval(["tilt_" + match_list(j) + " =[];"]);
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
% aggregate based on coupling scheme
for p = 1: length(prof)
    eval(["[row,col] = size(shot_" + prof(p) + ");"])
    for i = 1:col
        tilt_index = i*3-2;
        for j = 1:length(match_list)
            if eval(["contains(Label.shot_" + prof(p) + "(i), match_list(j))"])
                eval(["shot_" + match_list(j) + " = [shot_" + match_list(j) + " shot_" + prof(p) + "(:,i)'];"]);
                eval(["tilt_" + match_list(j) + " = [tilt_" + match_list(j) + " tilt_" + prof(p) + "(:,tilt_index)'];"]);
            end
        end
    end
end

% mae calculation for data aggregated by coupling scheme
for j = 1:length(match_list)
     eval(["mae_" + match_list(j) + "= sum(abs(shot_" + match_list(j) ...
        + "(51:end-50)))/(length(shot_" + match_list(j) + "));"]); %MAE from zero 
     eval(["mae_all(j)= mae_" + match_list(j) + ";"]);
end
mae_all_norm = mae_all-mae_all(4);
% MAE calculation for trials grouped by motion profile
for p = 1: length(prof)
%     eval(["mae_" + prof(p) + "= sum(abs(shot_" + prof(p) ...
%         + "(51:end-50,:)-(tilt_" + prof(p) + "(51:end-50,1:3:end))))/(length(time)-100);"]); %MAE from actual tilt
    eval(["mae_" + prof(p) + "= sum(abs(shot_" + prof(p) ...
        + "(51:end-50,:)))/(length(time)-100);"]); %MAE from zero
end
    
%indv mae plot
figure;
for p = 1: length(prof)
    subplot(2,3,p)
    eval(["plot_single_outcomes(mae_" + prof(p) + ",Label.shot_" + prof(p) + ", Color_List,match_list);"]);
    title (["Profile " + prof(p)]);
end
    hold on; 
    sgtitle(['MAE: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'MAEShort' datatype subject_str  ]); 
    cd(code_path);
    hold off;  

 % add the current subject's data into the aggregate variable
    %and increment the number of trials averaged into each trial type based on
    %the trial data available for the current subject

for p = 1: length(prof)
    eval(["[All_avg_mae_" + prof(p) + ",num_trials_" + prof(p) + ...
        ",mae_save_" + prof(p) + ",num_sub_trials_" + prof(p) + ...
        "] =  AggregateSingleMetric(mae_" + prof(p) + ", Label.shot_" ...
        + prof(p) + ", sub, All_avg_mae_" + prof(p) + ",num_trials_" ...
        + prof(p) + ",mae_save_" + prof(p) + ",num_sub_trials_" + prof(p) ...
        + ", match_list);"]);
end

[All_avg_mae_all,num_trials_all ,mae_save_all,num_sub_trials_all] =  AggregateSingleMetric( ...
    mae_all, match_list, sub, All_avg_mae_all,num_trials_all ...
        ,mae_save_all,num_sub_trials_all, match_list);


[All_avg_mae_all_norm,num_trials_all ,mae_save_all_norm,num_sub_trials_all] =  AggregateSingleMetric( ...
    mae_all_norm, match_list, sub, All_avg_mae_all_norm,num_trials_all ...
        ,mae_save_all_norm,num_sub_trials_all, match_list);
%update the label
Label_mae = match_list;

    %% save files
   cd(plots_path);
   vars_2_save = ['Label mae_4A mae_4B mae_5A mae_5B mae_6A mae_6B mae_all mae_all_norm' ];
   eval(['  save ' ['S' subject_str 'MeanAbsErrorShort' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   for j = 1:length(match_list)
    eval(["shot_" + match_list(j) + " =[];"]);
    eval(["tilt_" + match_list(j) + " =[];"]);
   end
   close all;
    
end
%divide the aggregate report by the number of trials added into it to get
%the average report across subjects and trials (need to add a calculation of error)
All_avg_mae_all= All_avg_mae_all./num_trials_all;
mae_save_all= mae_save_all./num_sub_trials_all;

All_avg_mae_all_norm= All_avg_mae_all_norm./num_trials_all;
mae_save_all_norm= mae_save_all_norm./num_sub_trials_all;

for p = 1: length(prof)
    eval(["All_avg_mae_" + prof(p) + "= All_avg_mae_" + prof(p) + "./num_trials_" + prof(p) + ";"]);
    eval(["mae_save_" + prof(p) + "= mae_save_" + prof(p) + "./num_sub_trials_" + prof(p) + ";"]);
end 

%create box plot
figure;
b = boxplot(mae_save_all);
% b.BoxFaceColor = blue;
plot_label = ["- Velocity";"- Semi";"- Angle"; "No GVS";"+ Velocity"; "+ Semi";"+ Angle" ];
% xticks([1 2 3 4 5 6 ]);
xticklabels(plot_label);
hold on;

for j = 1:numsub
    for i = 1:width(mae_save_all)
        
        plot(i+xoffset2(j), mae_save_all(j, i),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
        hold on;
    end
end

xlabel("GVS Coupling Scheme")
ylabel("Mean Absolute Deflection")
ax = gca;
ax.XAxis.FontSize = 32;
ax.YAxis.FontSize = 32;
hold on; 
sgtitle(['Mean Absolute Deflection' ],fontsize = 36); % for nice pretty plots
% sgtitle(['Perception-tilt-Slope-All-Profiles: AllSubjectsBoxPlot' datatype ]); %for within the group plots

 cd(plots_path);
    saveas(gcf, [ 'MAE-All-ProfilesAllSubjectsBoxPlot' datatype  ]); 
    cd(code_path);
    hold off;

% %create box plot
% figure;
% boxplot(mae_save_all);
% xticks([1 2 3 4 5 6 7]);
% xticklabels(plot_list);
% hold on; 
% sgtitle(['MAE-All-Profiles: AllSubjectsBoxPlot' datatype ]);
% 
%  cd(plots_path);
%     saveas(gcf, [ 'MAE-All-ProfilesAllSubjectsBoxPlot' datatype  ]); 
%     cd(code_path);
%     hold off;

    %create box plot
%create box plot
figure;
boxplot(mae_save_all_norm);
xticks([1 2 3 4 5 6 7]);
xticklabels(plot_list);
hold on; 
sgtitle(['MAE-Sham-Removed-All-Profiles: AllSubjectsBoxPlot' datatype ]);

 cd(plots_path);
    saveas(gcf, [ 'MAE-Sham-Removed-All-ProfilesAllSubjectsBoxPlot' datatype  ]); 
    cd(code_path);
    hold off;


figure;

for p = 1: length(prof)
    subplot(2,3,p)
    eval(["boxplot(mae_save_" + prof(p) + ");"]);
    title (["Profile " + prof(p)]);
    xticks([1 2 3 4 5 6 7]);
    xticklabels(plot_list);
end
hold on; 
sgtitle(['MAE: AllSubjectsBoxPlot' datatype ]);

 cd(plots_path);
    saveas(gcf, [ 'MAEShortAllSubjectsBoxPlot' datatype  ]); 
    cd(code_path);
    hold off;


%all subjects averaged mae plot (aggregate by coupling scheme)
figure;

    plot_single_outcomes(All_avg_mae_all,Label_mae, Color_List,match_list);

    hold on; 
    sgtitle(['MAE-All-Profiles: AllSubjects' datatype ]);

    cd(plots_path);
    saveas(gcf, [ 'MAE-All-ProfilesAllSubjects' datatype  ]); 
    cd(code_path);
    hold off; 

    %all subjects averaged mae plot (aggregate by coupling scheme)
figure;

    plot_single_outcomes(All_avg_mae_all_norm,Label_mae, Color_List,match_list);

    hold on; 
    sgtitle(['MAE-Sham-Removed-All-Profiles: AllSubjects' datatype ]);

    cd(plots_path);
    saveas(gcf, [ 'MAE-Sham-Removed-All-ProfilesAllSubjects' datatype  ]); 
    cd(code_path);
    hold off; 

%all subjects averaged mae plot
figure;
for p = 1: length(prof)
    subplot(2,3,p)
    eval(["plot_single_outcomes(All_avg_mae_" + prof(p) + ",Label_mae, Color_List,match_list);"]);
    title (["Profile " + prof(p)]);
end
    hold on; 
    sgtitle(['MAE: AllSubjects' datatype ]);

    cd(plots_path);
    saveas(gcf, [ 'MAEShortAllSubjects' datatype  ]); 
    cd(code_path);
    hold off; 
%%
    mae_means = mean(mae_save_all, 'omitnan');
    mae_std = std(mae_save_all, 'omitnan');


    %% save files
   cd(plots_path);
   vars_2_save = ['Label_mae mae_save_4A mae_save_4B mae_save_5A mae_save_5B mae_save_6A mae_save_6B mae_save_all mae_save_all_norm' ];
   eval(['  save ' ['SAllMeanAbsErrorShort' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   % eval (['clear ' vars_2_save])
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