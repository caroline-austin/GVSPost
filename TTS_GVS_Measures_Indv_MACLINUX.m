%% Script 5b for Dynamic GVS +Tilt
% this script calculates outcome measures (rms, total deflection ...) and
% then plots these outcomes for all trial types to help better visualize
% the data it takes its input from scripts 2 and 4 and should include
close all; 
clear; 
clc; 
%% set up
subnum = 1015:1015;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'BiasTime';

Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];

% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '/Plots/Measures']; % specify where plots are saved
gvs_path = [file_path '/GVSProfiles'];
tts_path = [file_path '/TTSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

%% calculate and plot the different measures for each subject
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
   
%     subject_path = [file_path, '/PS' , subject_str];
    subject_path = [file_path, '/' , subject_str];

    cd(subject_path);
    load(['S', subject_str, 'Group', datatype '.mat']);
    cd(code_path);
   

% RMS calculation and plots   
    rms4A = rms(shot_4A);
    rms4B = rms(shot_4B);
    rms5A = rms(shot_5A);
    rms5B = rms(shot_5B);
    rms6A = rms(shot_6A);
    rms6B = rms(shot_6B);
    
%     rmsA = [ rms4A; rms5A; rms6A ];
%     rmsB = [ rms4B; rms5B; rms6B ];
    
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
    sgtitle(['RMS: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'RMS' datatype subject_str  ]); 
    cd(code_path);
    hold off;  
    
    %% variance calculations and plots  
    var4A = var(shot_4A);
    var4B = var(shot_4B);
    var5A = var(shot_5A);
    var5B = var(shot_5B);
    var6A = var(shot_6A);
    var6B = var(shot_6B);
    
%     varA = [ var4A; var5A; var6A ];
%     varB = [ var4B; var5B; var6B ];
    
    %%
    figure;
    subplot(2,3,1)
    plot_single_outcomes( var4A,Label.shot_4A, Color_List,match_list);
    title ("Profile 4A");
    subplot(2,3,2)
    plot_single_outcomes( var5A,Label.shot_5A, Color_List,match_list);
    title ("Profile 5A");
    subplot(2,3,3)
    plot_single_outcomes( var6A,Label.shot_6A, Color_List,match_list);
    title ("Profile 6A");
    subplot(2,3,4)
    plot_single_outcomes( var4B,Label.shot_4B, Color_List,match_list);
    title ("Profile 4B");
    subplot(2,3,5)
    plot_single_outcomes( var5B,Label.shot_5B, Color_List,match_list);
    title ("Profile 5B");
    subplot(2,3,6)
    plot_single_outcomes( var6B,Label.shot_6B, Color_List,match_list);
    title ("Profile 6B");
    hold on; 
    sgtitle(['Variance: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'Variance' datatype subject_str  ]); 
    cd(code_path);
    hold off;  
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