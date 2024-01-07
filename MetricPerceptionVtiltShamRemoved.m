%% Script 5x for Dynamic GVS +Tilt
% this script calculates outcome measures (slope, total deflection ...) and
% then plots these outcomes for all trial types to help better visualize
% the data it takes its input from scripts 2 and 4 and should include
close all; 
clear; 
clc; 
%% set up
subnum = 1011:1022;  % Subject List 
numsub = length(subnum);
subskip = [1013 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'BiasTime';

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];

Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
plot_list = ["N Vel"; "N Ang&Vel"; "N Ang"; "None";"P Vel"; "P Ang&Vel"; "P Ang"];
prof = ["4A"; "5A"; "6A"; "4B";"5B"; "6B"; ];
sub_symbols = ["kpentagram";"k<";"khexagram";"k>"; "kdiamond";"kv";"ko";"k+"; "k*"; "kx"; "ksquare"; "k^";];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15; -0.15; -0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots/Measures/Perception-tilt-ShamRemoved-Slope']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
    tts_path = [file_path '/TTSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots\Measures\Perception-tilt-ShamRemoved-Slope']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
    tts_path = [file_path '\TTSProfiles'];
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

for p = 1: length(prof)
    eval(["All_avg_slope_" + prof(p) + "= zeros(1,length(match_list));"]);
    eval(["num_trials_" + prof(p) + "= zeros(1, length(match_list));"]);
    eval(["num_sub_trials_" + prof(p) + "= zeros(numsub, length(match_list));"]);
    eval(["slope_save_" + prof(p) + "= zeros(numsub, length(match_list));"]);

    All_avg_slope_all= zeros(1,length(match_list));
    num_trials_all= zeros(1, length(match_list));
    num_sub_trials_all= zeros(numsub, length(match_list));
    slope_save_all= zeros(numsub, length(match_list));
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

% slope calculation 
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

for j = 1:length(match_list)
    eval(["LM.X" + match_list(j) + " = fitlm(tilt_" + match_list(j) + ", shot_" + match_list(j) + ", 'Intercept', false);"]);
    eval(["slope_all(j)= LM.X" + match_list(j) + ".Coefficients.Estimate;"]);
end
slope_all = slope_all - slope_all(4);

% %% curve fitting plots
x_current = linspace(-8,8);
for j = 1:length(slope_all)
    y_slope(:,j) = x_current.*slope_all(j);
end

figure;
plot(tilt_N_4_00mA_7_00,shot_N_4_00mA_7_00, '^','MarkerEdgeColor', blue);
hold on; plot(tilt_N_4_00mA_7_50,shot_N_4_00mA_7_50, 'diamond','MarkerEdgeColor', purple);
hold on; plot(tilt_N_4_00mA_8_00,shot_N_4_00mA_8_00, 'v','MarkerEdgeColor', red);
hold on; plot(tilt_0_00mA,shot_0_00mA, 'square','MarkerEdgeColor', green);
hold on; plot(x_current,y_slope(:,1),"Color", "#0072BD", "LineWidth", 3);
hold on; plot(x_current,y_slope(:,2),"Color", "#7E2F8E", "LineWidth", 3);
hold on; plot(x_current,y_slope(:,3),"Color", 	"red", "LineWidth", 3);
title(["Tilt Perception V. tilt Attenuating" subject_str])
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend([match_list(4) match_list(1:3)'])
hold off;
cd(plots_path);
    saveas(gcf, [ 'Perception-tilt-Slope-Fit-Negative' datatype subject_str ]); 
    cd(code_path);
    hold off; 
figure;
plot(tilt_P_4_00mA_7_00,shot_P_4_00mA_7_00, '^','MarkerEdgeColor', blue);
hold on; plot(tilt_P_4_00mA_7_50,shot_P_4_00mA_7_50, 'diamond','MarkerEdgeColor', purple);
hold on; plot(tilt_P_4_00mA_8_00,shot_P_4_00mA_8_00, 'v','MarkerEdgeColor', red);
hold on; plot(tilt_0_00mA,shot_0_00mA, 'square','MarkerEdgeColor', green);
hold on; plot(x_current,y_slope(:,5),"Color", "#0072BD", "LineWidth", 3);
hold on; plot(x_current,y_slope(:,6),"Color", "#7E2F8E", "LineWidth", 3);
hold on; plot(x_current,y_slope(:,7),"Color", "red", "LineWidth", 3);
%plot slopes
title(["Tilt Perception V. tilt  Amplifying" subject_str])
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20]);
legend(match_list(4:end));

cd(plots_path);
    saveas(gcf, [ 'Perception-tilt-Slope-Fit-Positive' datatype subject_str ]); 
    cd(code_path);
    hold off; 

%%
for p = 1: length(prof)
    eval(["[row,col] = size(shot_" + prof(p) + ");"])
    for trial = 1:col
        tilt_index = trial*3-2;
        eval(["[LM_" + prof(p) + "." + eval(["Label.shot_" + prof(p) ...
            + "(trial)"]) + "] = fitlm(tilt_" + prof(p) + ...
            "(:,tilt_index), shot_" + prof(p) + "(:,trial), 'Intercept', false);"]); 
        eval(["slope_" + prof(p) + "(trial) = LM_" + prof(p) + "." ...
            + eval(["Label.shot_" + prof(p) + "(trial)"]) + ".Coefficients.Estimate;"]);
        
        % plot individual trial raw data and corresponding slope in the
        % same color
        % store/create legend
           
    end

    
    % add overall title/legend/labels/other plot formatting
    % save the plot (1 per motion profile)
    % or just the labeling for a subplot

end

for p = 1: length(prof)
    check = 0;
    for i = 1:eval(["length(Label.shot_" + prof(p) + ")"])
            if eval(["contains(Label.shot_" + prof(p) + "(i), match_list(4))"])
                if check ==1
                    continue
                end
                eval(["slope_" + prof(p) + " =  slope_" + prof(p) + "- slope_" + prof(p) +  "(i);"]);
                check = 1;
                continue

            end
    end 
    if check == 0
        eval(["slope_" + prof(p) + "(:) =  NaN;"])
    end
end  
% or do the overall plot labeling /saving out here (1 per subjects)
%indv slope plot
figure;
    plot_single_outcomes(slope_all,match_list, Color_List,match_list);
    hold on; 
    title(['Perception-tilt-Slope-All-Profiles: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'Perception-tilt-Slope-All-Profiles' datatype subject_str ]); 
    cd(code_path);
    hold off; 


figure;
for p = 1: length(prof)
    subplot(2,3,p)
    eval(["plot_single_outcomes(slope_" + prof(p) + ",Label.shot_" + prof(p) + ", Color_List,match_list);"]);
    title (["Profile " + prof(p)]);
end
    hold on; 
    sgtitle(['Perception-tilt-Slope: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'Perception-tilt-Slope' datatype subject_str ]); 
    cd(code_path);
    hold off;  

 % add the current subject's data into the aggregate variable
    %and increment the number of trials averaged into each trial type based on
    %the trial data available for the current subject

for p = 1: length(prof)
    eval(["[All_avg_slope_" + prof(p) + ",num_trials_" + prof(p) + ...
        ",slope_save_" + prof(p) + ",num_sub_trials_" + prof(p) + ...
        "] =  AggregateSingleMetric(slope_" + prof(p) + ", Label.shot_" ...
        + prof(p) + ", sub, All_avg_slope_" + prof(p) + ",num_trials_" ...
        + prof(p) + ",slope_save_" + prof(p) + ",num_sub_trials_" + prof(p) ...
        + ", match_list);"]);
end

[All_avg_slope_all,num_trials_all ,slope_save_all,num_sub_trials_all] =  AggregateSingleMetric( ...
    slope_all, match_list, sub, All_avg_slope_all,num_trials_all ...
        ,slope_save_all,num_sub_trials_all, match_list);

%update the label
Label_slope = match_list;

    %% save files
   cd(plots_path);
   vars_2_save = ['Label slope_4A slope_4B slope_5A slope_5B slope_6A slope_6B LM slope_all' ];
   eval(['  save ' ['S' subject_str 'Perception-tilt-Slope' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;
    
end
%% divide the aggregate report by the number of trials added into it to get
%the average report across subjects and trials (need to add a calculation of error)
All_avg_slope_all= All_avg_slope_all./num_trials_all;
slope_save_all= slope_save_all./num_sub_trials_all;

for p = 1: length(prof)
    eval(["All_avg_slope_" + prof(p) + "= All_avg_slope_" + prof(p) + "./num_trials_" + prof(p) + ";"]);
    eval(["slope_save_" + prof(p) + "= slope_save_" + prof(p) + "./num_sub_trials_" + prof(p) + ";"]);
end 


%% create box plot
figure;
b = boxplot(slope_save_all(:, [1:3,5:7]));
% b.BoxFaceColor = blue;
plot_label = ["- Velocity";"- Semi";"- Angle"; "+ Velocity"; "+ Semi";"+ Angle" ];
% xticks([1 2 3 4 5 6 ]);
xticklabels(plot_label);
hold on;
slope_save_all_plot = slope_save_all(:, [1:3,5:7]);
for j = 1:numsub
    for i = 1:width(slope_save_all_plot)
        
        plot(i+xoffset2(j), slope_save_all_plot(j, i),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
        hold on;
    end
end

xlabel("GVS Coupling Scheme")
ylabel("Normalized Perception/Tilt (Deg/Deg)")
ax = gca;
ax.XAxis.FontSize = 32;
ax.YAxis.FontSize = 32;
hold on; 
sgtitle(['GVS Effect' ],fontsize = 36); % for nice pretty plots
% sgtitle(['Perception-tilt-Slope-All-Profiles: AllSubjectsBoxPlot' datatype ]); %for within the group plots

 cd(plots_path);
    saveas(gcf, [ 'Perception-tilt-Slope-All-ProfilesAllSubjectsBoxPlot' datatype  ]); 
    cd(code_path);
    hold off;
%%
figure;

for p = 1: length(prof)
    subplot(2,3,p)
    eval(["boxplot(slope_save_" + prof(p) + ");"]);
    title (["Profile " + prof(p)]);
    xticks([1 2 3 4 5 6 7]);
    xticklabels(plot_list);
end
hold on; 
sgtitle(['Perception-tilt-Slope: AllSubjectsBoxPlot' datatype ]);

 cd(plots_path);
    saveas(gcf, [ 'Perception-tilt-SlopeAllSubjectsBoxPlot' datatype  ]); 
    cd(code_path);
    hold off;

%all subjects averaged slope plot
figure;

    plot_single_outcomes(All_avg_slope_all,Label_slope, Color_List,match_list);

    hold on; 
    sgtitle(['Perception-tilt-Slope-All-Profiles: AllSubjects' datatype ]);

    cd(plots_path);
    saveas(gcf, [ 'Perception-tilt-Slope-All-ProfilesAllSubjects' datatype  ]); 
    cd(code_path);
    hold off; 

figure;
for p = 1: length(prof)
    subplot(2,3,p)
    eval(["plot_single_outcomes(All_avg_slope_" + prof(p) + ",Label_slope, Color_List,match_list);"]);
    title (["Profile " + prof(p)]);
end
    hold on; 
    sgtitle(['Perception-tilt-Slope: AllSubjects' datatype ]);

    cd(plots_path);
    saveas(gcf, [ 'Perception-tilt-SlopeAllSubjects' datatype  ]); 
    cd(code_path);
    hold off; 

    %% save files
   cd(plots_path);
   vars_2_save = ['Label_slope slope_save_4A slope_save_4B slope_save_5A slope_save_5B slope_save_6A slope_save_6B slope_save_all' ];
   eval(['  save ' ['SAllPerception-tilt-Slope' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
%    close all;

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