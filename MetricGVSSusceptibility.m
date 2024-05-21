%% Script 5x for Dynamic GVS +Tilt
% this script calculates outcome measures (MotionRating, total deflection ...) and
% then plots these outcomes for all trial types to help better visualize
% the data it takes its input from scripts 2 and 4 and should include
close all; 
clear; 
clc; 
%% set up
subnum = [1011:1022, 1066:1068];  % Subject List 
subskip = [1006 1007 1008 1009 1010 1011 1012 1013 1015 1019 1067 40006];  %DNF'd subjects or subjects that didn't complete this part

numsub = length(subnum);
% subskip = [1011 1012 1013 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = ''; % no data type specifiers for verbal reports

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_List = [blue; green; yellow; red; navy; purple];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
plot_list = ["N Vel"; "N Ang&Vel"; "N Ang"; "None";"P Vel"; "P Ang&Vel"; "P Ang"];
prof = ["4A"; "5A"; "6A"; "4B";"5B"; "6B"; ];
rating_scale = ["none"; "slight"; "moderate"; "severe"];

% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots/Measures/GVSSusceptibility']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
    tts_path = [file_path '/TTSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots\Measures\GVSSusceptibility']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
    tts_path = [file_path '\TTSProfiles'];
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

    All_avg_MotionRating_min= zeros(1,length(rating_scale));
    num_trials= zeros(1, length(rating_scale));
    num_trials_save= zeros(numsub, length(rating_scale));
    MotionRating_min_save= zeros(numsub, length(rating_scale));

    All_avg_MotionRating_max= zeros(1,length(rating_scale));
    num_trials_max= zeros(1, length(rating_scale));
    num_trials_save_max= zeros(numsub, length(rating_scale));
    MotionRating_max_save= zeros(numsub, length(rating_scale));


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
        load(['A', subject_str, 'Extract', datatype '.mat']);
    elseif ispc
        subject_path = [file_path, '\' , subject_str];
        cd(subject_path);
        load(['A', subject_str, 'Extract', datatype '.mat']);
    end
    
    cd(code_path);

% MotionRating calculation 
MotionRating_min = NaN(1,length(rating_scale));
for j = 1:length(rating_scale)
    location = find(MotionRating_map(:,j),1);
    if ~isempty(location)
        MotionRating_min(j)=Label.CurrentAmp(location);  
    end
end

MotionRating_max = NaN(1,length(rating_scale));
for j = 1:length(rating_scale)
    location = find(MotionRating_map(:,j),1,"last");
    if ~isempty(location)
        MotionRating_max(j)=Label.CurrentAmp(location);  
    end
end
    
%indv MotionRating plot
figure;
    plot_single_outcomes(MotionRating_min,rating_scale, Color_List,rating_scale);
    hold on; 
    title(['MotionRatingMinimumCurrent: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'MotionRatingMinimumCurrent' datatype subject_str ]); 
    cd(code_path);
    hold off; 

 % add the current subject's data into the aggregate variable
    %and increment the number of trials averaged into each trial type based on
    %the trial data available for the current subject

[All_avg_MotionRating_min,num_trials ,MotionRating_min_save,num_trials_save] =  AggregateSingleMetric( ...
    MotionRating_min, rating_scale, sub, All_avg_MotionRating_min,num_trials ...
        ,MotionRating_min_save,num_trials_save, rating_scale);

[All_avg_MotionRating_max,num_trials_max ,MotionRating_max_save,num_trials_save_max] =  AggregateSingleMetric( ...
    MotionRating_max, rating_scale, sub, All_avg_MotionRating_max,num_trials_max ...
        ,MotionRating_max_save,num_trials_save_max, rating_scale);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%update the label
Label_MotionRating = rating_scale;

    %% save files
   cd(plots_path);
   vars_2_save = ['Label MotionRating_min MotionRating_max' ];
   eval(['  save ' ['S' subject_str 'MotionRatingMinimumCurrent' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;
    
end
%divide the aggregate report by the number of trials added into it to get
%the average report across subjects and trials (need to add a calculation of error)
All_avg_MotionRating_min= All_avg_MotionRating_min./num_trials;
MotionRating_min_save= MotionRating_min_save./num_trials_save;

All_avg_MotionRating_max= All_avg_MotionRating_max./num_trials_max;
MotionRating_max_save= MotionRating_max_save./num_trials_save_max;

%create box plot
figure;
boxplot(MotionRating_min_save);
xticks([1 2 3 4 ]);
xticklabels(rating_scale);
hold on; 
sgtitle(['MotionRatingMinimumCurrent: AllSubjectsBoxPlot' datatype ]);

 cd(plots_path);
    saveas(gcf, [ 'MotionRatingMinimumCurrentAllSubjectsBoxPlot' datatype  ]); 
    cd(code_path);
    hold off;


%all subjects averaged MotionRating plot
figure;

    plot_single_outcomes(All_avg_MotionRating_min,Label_MotionRating, Color_List,rating_scale);

    hold on; 
    sgtitle(['MotionRatingMinimumCurrent: AllSubjects' datatype ]);

    cd(plots_path);
    saveas(gcf, [ 'MotionRatingMinimumCurrentAllSubjects' datatype  ]); 
    cd(code_path);
    hold off; 

    %% save files
   cd(plots_path);
   vars_2_save = ['Label_MotionRating  MotionRating_min_save MotionRating_max_save' ];
   eval(['  save ' ['SAllPerception-tilt-Slope' datatype '.mat '] vars_2_save ' vars_2_save']);      
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