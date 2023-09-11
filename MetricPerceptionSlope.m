%% Script 5x for Dynamic GVS +Tilt Slope metrics
% this script calculates the slope of the perception curve and then
% plots it against the angular velocity to help better visualize
% the data it takes its input from scripts 2 and 4 
close all; 
clear; 
clc; 
%% set up
subnum = 1011:1022;  % Subject List 
numsub = length(subnum);
subskip = [1013 1015];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'BiasTimeGain';

Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];

% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    subject_plot_path = [file_path '/Plots/Measures/Slope']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
    tts_path = [file_path '/TTSProfiles'];
elseif ispc
    subject_plot_path = [file_path '\Plots\Measures\Slope']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
    tts_path = [file_path '\TTSProfiles'];
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

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
   

%% slope calculation 
    delta_t = 1/50; %the TTS samples at 50Hz
    slope4A = lowpass(((shot_4A(1:end-1,:) - shot_4A(2:end,:))/delta_t), 2 , 1/delta_t);
    slope4B = lowpass(((shot_4B(1:end-1,:) - shot_4B(2:end,:))/delta_t), 2 , 1/delta_t);
    slope5A = lowpass(((shot_5A(1:end-1,:) - shot_5A(2:end,:))/delta_t), 2 , 1/delta_t);
    slope5B = lowpass(((shot_5B(1:end-1,:) - shot_5B(2:end,:))/delta_t), 2 , 1/delta_t);
    slope6A = lowpass(((shot_6A(1:end-1,:) - shot_6A(2:end,:))/delta_t), 2 , 1/delta_t);
    slope6B = lowpass(((shot_6B(1:end-1,:) - shot_6B(2:end,:))/delta_t), 2 , 1/delta_t);

    tilt_slope4A = ((tilt_4A(1:end-1,:) - tilt_4A(2:end,:))/delta_t);
    tilt_slope4B = ((tilt_4B(1:end-1,:) - tilt_4B(2:end,:))/delta_t);
    tilt_slope5A = ((tilt_5A(1:end-1,:) - tilt_5A(2:end,:))/delta_t);
    tilt_slope5B = ((tilt_5B(1:end-1,:) - tilt_5B(2:end,:))/delta_t);
    tilt_slope6A = ((tilt_6A(1:end-1,:) - tilt_6A(2:end,:))/delta_t);
    tilt_slope6B = ((tilt_6B(1:end-1,:) - tilt_6B(2:end,:))/delta_t);

    %% plot
[pos_prof] = find(contains(Label.shot_4A, 'P'));
% PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, -tilt_4A(1:end-1,2:end), slope4A, GVS_4A(1:end-1,:), time(1:end-1),Color_List,pos_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_4A,Label.GVS_4A, -tilt_4A(1:end-1,2:end),slope4A,0, time(1:end-1),Color_List,pos_prof,match_list)    
ylabel("Tilt Velocity (deg/s)") 
%add title to the plot
title(['4A Amplifying GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Positive_4A_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;

[neg_prof] = find(contains(Label.shot_4A, 'N'));
[zero_prof] = find(contains(Label.shot_4A, '_0_'));
neg_prof = [zero_prof ; neg_prof];
% PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, tilt_4A(1:end-1,:), slope4A, GVS_4A(1:end-1,:), time(1:end-1),Color_List,neg_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_4A,Label.GVS_4A, -tilt_4A(1:end-1,2:end),slope4A,0, time(1:end-1),Color_List,neg_prof,match_list)    
ylabel("Change in Tilt (deg/s)") 
%add title to the plot
title(['4A Attenuating GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Negative_4A_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;
%%%%%%%%%%%%%%%%%
[pos_prof] = find(contains(Label.shot_4B, 'P'));
% PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, tilt_4B(1:end-1,:), slope4B, GVS_4B(1:end-1,:), time(1:end-1),Color_List,pos_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_4B,Label.GVS_4B, -tilt_4B(1:end-1,2:end),slope4B,0, time(1:end-1),Color_List,pos_prof,match_list)    
ylabel("Tilt Velocity (deg/s)") 
%add title to the plot
title(['4B Amplifying GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Positive_4B_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;

[neg_prof] = find(contains(Label.shot_4B, 'N'));
[zero_prof] = find(contains(Label.shot_4B, '_0_'));
neg_prof = [zero_prof ; neg_prof];
% PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, tilt_4B(1:end-1,:), slope4B, GVS_4B(1:end-1,:), time(1:end-1),Color_List,neg_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_4B,Label.GVS_4B, -tilt_4B(1:end-1,2:end),slope4B,0, time(1:end-1),Color_List,neg_prof,match_list)    
ylabel("Change in Tilt (deg/s)") 
%add title to the plot
title(['4B Attenuating GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Negative_4B_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%

[pos_prof] = find(contains(Label.shot_5A, 'P'));
% PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, tilt_5A(1:end-1,:), slope5A, GVS_5A(1:end-1,:), time(1:end-1),Color_List,pos_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_5A,Label.GVS_5A, -tilt_5A(1:end-1,2:end),slope5A,0, time(1:end-1),Color_List,pos_prof,match_list)    
ylabel("Tilt Velocity (deg/s)") 
%add title to the plot
title(['5A Amplifying GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Positive_5A_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;

[neg_prof] = find(contains(Label.shot_5A, 'N'));
[zero_prof] = find(contains(Label.shot_5A, '_0_'));
neg_prof = [zero_prof ; neg_prof];
% PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, tilt_5A(1:end-1,:), slope5A, GVS_5A(1:end-1,:), time(1:end-1),Color_List,neg_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_5A,Label.GVS_5A, -tilt_5A(1:end-1,2:end),slope5A,0, time(1:end-1),Color_List,neg_prof,match_list)    
ylabel("Change in Tilt (deg/s)") 
%add title to the plot
title(['5A Attenuating GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Negative_5A_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;
%%%%%%%%%%%%%%%%%
[pos_prof] = find(contains(Label.shot_5B, 'P'));
% PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, tilt_5B(1:end-1,:), slope5B, GVS_5B(1:end-1,:), time(1:end-1),Color_List,pos_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_5B,Label.GVS_5B, -tilt_5B(1:end-1,2:end),slope5B,0, time(1:end-1),Color_List,pos_prof,match_list)    
ylabel("Tilt Velocity (deg/s)") 
%add title to the plot
title(['5B Amplifying GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Positive_5B_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;

[neg_prof] = find(contains(Label.shot_5B, 'N'));
[zero_prof] = find(contains(Label.shot_5B, '_0_'));
neg_prof = [zero_prof ; neg_prof];
% PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, tilt_5B(1:end-1,:), slope5B, GVS_5B(1:end-1,:), time(1:end-1),Color_List,neg_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_5B,Label.GVS_5B, -tilt_5B(1:end-1,2:end),slope5B,0, time(1:end-1),Color_List,neg_prof,match_list)    
ylabel("Change in Tilt (deg/s)") 
%add title to the plot
title(['5B Attenuating GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Negative_5B_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%

[pos_prof] = find(contains(Label.shot_6A, 'P'));
% PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, tilt_6A(1:end-1,:), slope6A, GVS_6A(1:end-1,:), time(1:end-1),Color_List,pos_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_6A,Label.GVS_6A, -tilt_6A(1:end-1,2:end),slope6A,0, time(1:end-1),Color_List,pos_prof,match_list)    
ylabel("Tilt Velocity (deg/s)") 
%add title to the plot
title(['6A Amplifying GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Positive_6A_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;

[neg_prof] = find(contains(Label.shot_6A, 'N'));
[zero_prof] = find(contains(Label.shot_6A, '_0_'));
neg_prof = [zero_prof ; neg_prof];
% PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, tilt_6A(1:end-1,:), slope6A, GVS_6A(1:end-1,:), time(1:end-1),Color_List,neg_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_6A,Label.GVS_6A, -tilt_6A(1:end-1,2:end),slope6A,0, time(1:end-1),Color_List,neg_prof,match_list)    
ylabel("Change in Tilt (deg/s)") 
%add title to the plot
title(['6A Attenuating GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Negative_6A_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;
%%%%%%%%%%%%%%%%%
[pos_prof] = find(contains(Label.shot_6B, 'P'));
% PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, tilt_6B(1:end-1,:), slope6B, GVS_6B(1:end-1,:), time(1:end-1),Color_List,pos_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_6B,Label.GVS_6B, -tilt_6B(1:end-1,2:end),slope6B,0, time(1:end-1),Color_List,pos_prof,match_list)    
ylabel("Tilt Velocity (deg/s)") 
%add title to the plot
title(['6B Amplifying GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Positive_6B_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;

[neg_prof] = find(contains(Label.shot_6B, 'N'));
[zero_prof] = find(contains(Label.shot_6B, '_0_'));
neg_prof = [zero_prof ; neg_prof];
PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, tilt_6B(1:end-1,:), slope6B, GVS_6B(1:end-1,:), time(1:end-1),Color_List,neg_prof, match_list)
PlotGVSTTSPerceptionSHOTonly(Label.shot_6B,Label.GVS_6B, -tilt_6B(1:end-1,2:end),slope6B,0, time(1:end-1),Color_List,neg_prof,match_list)    
ylabel("Change in Tilt (deg/s)") 
%add title to the plot
title(['6B Attenuating GVS Affects on Changing Tilt Perception ' datatype subject_str])
%save plot
cd(subject_plot_path);
saveas(gcf, [ 'Negative_6B_4_00mA_Changing_Perception' datatype subject_str]); 
cd(code_path);
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%

%% RMS
% RMS calculation and plots   
    rms4A = rms(slope4A);
    rms4B = rms(slope4B);
    rms5A = rms(slope5A);
    rms5B = rms(slope5B);
    rms6A = rms(slope6A);
    rms6B = rms(slope6B);

% plot rms
    figure;
    subplot(2,3,1)
    plot_single_outcomes(rms4A,Label.shot_4A, Color_List,match_list);
    title ("Profile 4A");
    subplot(2,3,2)
    plot_single_outcomes(rms5A,Label.shot_5A, Color_List,match_list);
    title ("Profile 5A");
    subplot(2,3,3)
    plot_single_outcomes(rms6A,Label.shot_6A, Color_List,match_list);
    title ("Profile 6A");
    subplot(2,3,4)
    plot_single_outcomes(rms4B,Label.shot_4B, Color_List,match_list);
    title ("Profile 4B");
    subplot(2,3,5)
    plot_single_outcomes(rms5B,Label.shot_5B, Color_List,match_list);
    title ("Profile 5B");
    subplot(2,3,6)
    plot_single_outcomes(rms6B,Label.shot_6B, Color_List,match_list);
    title ("Profile 6B");
    hold on; 
    sgtitle(['Slope: Subject ' datatype subject_str]);

    cd(subject_plot_path);
    saveas(gcf, [ 'SlopeRMS' datatype subject_str  ]); 
    cd(code_path);
    hold off;  
    
    close all
end


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