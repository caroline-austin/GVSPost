%% Script 3 for Dynamic GVS +Tilt
% this file should be run to double check that the correct unique 
% waveform, proportionality and current pairing was run. It is also used to
% check how well the subject performed the task (do the shot report match
% the physcial motion). None of these plots are saved automatically. If you
% notice a problem in one of the plots, you will have to manually remove it
% from the data set by deleting it's indivual matlab file, setting it's
% trial number in the master excel sheet to 0, and re-running script 2.
% This script can take input from script 2 and 4(s)

close all; 
clear all; 
clc; 

%% set up
subnum = 1015:1015;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'Bias'; %can change this to specify which data you want to use for the checkng
% '' = regular , 'Time' = time adjusted, 'Adj' = Bias adjusted (can stack
% multiple)

%may eventually want to modigy the color list to be more colorblind
%friendly 
Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots\Check']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
tts_path = [file_path '\TTSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

%generate plots to check for each subject 
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path, '\' , subject_str];
%     subject_path = [file_path, '\PS' , subject_str];

    %load the data file with all trial shot reports for the subject
    cd(subject_path);
    load(['S', subject_str, 'Group' datatype '.mat ']);
    cd(code_path);

    % determine the number of trials for each physcial motion profile
    [~,num_4A ]=size(shot_4A);
    [~,num_4B ]=size(shot_4B);
    [~,num_5A ]=size(shot_5A);
    [~,num_5B ]=size(shot_5B);
    [~,num_6A ]=size(shot_6A);
    [~,num_6B ]=size(shot_6B);
    % determine the max number of subplots needed to fit plots from all the
    % trials 
    num_subplots = max([num_4A,num_4B,num_5A,num_5B,num_6A,num_6B]);
    cols = 4;
    rows = ceil(num_subplots/cols);
    
    %plot GVS profiles to check them (want to make sure the commanded
    %signal and the noisy signal recorded by the TTS match up timing wise
    %and genreal shape wise, but the exact magnitudes will not match
    PlotNxM(rows,cols, GVS_4A,Color_List,3,Label.GVS_4A, match_list);
    sgtitle(["GVS 4A" subject_str]);
    PlotNxM(rows,cols, GVS_4B,Color_List,3,Label.GVS_4B,match_list);
    sgtitle(["GVS 4B" subject_str]);
    PlotNxM(rows,cols, GVS_5A,Color_List,3,Label.GVS_5A,match_list);
    sgtitle(["GVS 5A" subject_str]);
    PlotNxM(rows,cols, GVS_5B,Color_List,3,Label.GVS_5B,match_list);
    sgtitle(["GVS 5B" subject_str]);
    PlotNxM(rows,cols, GVS_6A,Color_List,3,Label.GVS_6A,match_list);
    sgtitle(["GVS 6A" subject_str]);
    PlotNxM(rows,cols, GVS_6B,Color_List,3,Label.GVS_6B,match_list);
    sgtitle(["GVS 6B" subject_str]);
    disp("Please Review these 6 plots for correctness and then press any key to continue");
    pause;
    close all

    %plot the tilt profiles to check them, this plot has two lines that
    %should be mostly overlapping (TTS commanded and actual) and then a
    %third line (commanded velocity) for this you want to make sure all of
    %the plots match, if one of the plots does not match this means you
    %the wrong physical motion profile was run (the operator could have
    % selected the wrong one, or it might not have loaded properly)  
    PlotNxM(rows,cols, tilt_4A,Color_List,3,Label.tilt_4A, match_list);
    sgtitle(["tilt 4A" subject_str]);
    PlotNxM(rows,cols, tilt_4B,Color_List,3,Label.tilt_4B,match_list);
    sgtitle(["tilt 4B" subject_str]);
    PlotNxM(rows,cols, tilt_5A,Color_List,3,Label.tilt_5A,match_list);
    sgtitle(["tilt 5A" subject_str]);
    PlotNxM(rows,cols, tilt_5B,Color_List,3,Label.tilt_5B,match_list);
    sgtitle(["tilt 5B" subject_str]);
    PlotNxM(rows,cols, tilt_6A,Color_List,3,Label.tilt_6A,match_list);
    sgtitle(["tilt 6A" subject_str]);
    PlotNxM(rows,cols, tilt_6B,Color_List,3,Label.tilt_6B,match_list);
    sgtitle(["tilt 6B" subject_str]);
    disp("Please Review these 6 plots for correctness and then press any key to continue");
    pause;
    close all

    %plot shot profiles against tilt to check them. For these plots you
    %want to make sure that the shot report is generally in the same
    %direction as the physical motion profile (with maybe a little bit of
    %lag) If the subject is reporting the exact opposite sense of motion
    %for large portions of the trial consider removing the trial
    figure;
    subplot(rows,cols,1)
        for prof2plot = 1:length(Label.shot_4A)
            subplot(rows,cols, prof2plot)
        PlotGVSTTSPerceptionSHOTonly(Label.shot_4A, Label.GVS_4A , tilt_4A, ...
            shot_4A(),1, time,Color_List,prof2plot,match_list)
        trial_name= char(strrep(Label.shot_4A(prof2plot), '_', '.'));
        plot_title =trial_name(1:16);
        title(plot_title);
        end  
    sgtitle(["SHOT 4A" subject_str]);

    figure;
    subplot(rows,cols,1)
        for prof2plot = 1:length(Label.shot_4B)
            subplot(rows,cols, prof2plot)
        PlotGVSTTSPerceptionSHOTonly(Label.shot_4B, Label.GVS_4B , tilt_4B, ...
            shot_4B(),1, time,Color_List,prof2plot,match_list)
        trial_name= char(strrep(Label.shot_4B(prof2plot), '_', '.'));
        plot_title =trial_name(1:16);
        title(plot_title);
        end 
    sgtitle(["SHOT 4B" subject_str]);

    figure;
    subplot(rows,cols,1)
        for prof2plot = 1:length(Label.shot_5A)
            subplot(rows,cols, prof2plot)
        PlotGVSTTSPerceptionSHOTonly(Label.shot_5A, Label.GVS_5A , tilt_5A, ...
            shot_5A(),1, time,Color_List,prof2plot,match_list)
        trial_name= char(strrep(Label.shot_5A(prof2plot), '_', '.'));
        plot_title =trial_name(1:16);
        title(plot_title);
        end  
    sgtitle(["SHOT 5A" subject_str]);

    figure;
    subplot(rows,cols,1)
        for prof2plot = 1:length(Label.shot_5B)
            subplot(rows,cols, prof2plot)
        PlotGVSTTSPerceptionSHOTonly(Label.shot_5B, Label.GVS_5B , tilt_5B, ...
            shot_5B(),1, time,Color_List,prof2plot,match_list)
        trial_name= char(strrep(Label.shot_5B(prof2plot), '_', '.'));
        plot_title =trial_name(1:16);
        title(plot_title);
        end  
    sgtitle(["SHOT 5B" subject_str]);

    figure;
    subplot(rows,cols,1)
        for prof2plot = 1:length(Label.shot_6A)
            subplot(rows,cols, prof2plot)
        PlotGVSTTSPerceptionSHOTonly(Label.shot_6A, Label.GVS_6A , tilt_6A, ...
            shot_6A(),1, time,Color_List,prof2plot,match_list)
        trial_name= char(strrep(Label.shot_6A(prof2plot), '_', '.'));
        plot_title =trial_name(1:16);
        title(plot_title);
        end  
    sgtitle(["SHOT 6A" subject_str]);

    figure;
    subplot(rows,cols,1)
        for prof2plot = 1:length(Label.shot_6B)
            subplot(rows,cols, prof2plot)
        PlotGVSTTSPerceptionSHOTonly(Label.shot_6B, Label.GVS_6B , tilt_6B, ...
            shot_6B(),1, time,Color_List,prof2plot,match_list)
        trial_name= char(strrep(Label.shot_6B(prof2plot), '_', '.'));
        plot_title =trial_name(1:16);
        title(plot_title);
        end    
    sgtitle(["SHOT 6B" subject_str]);

    disp("Please Review these 6 plots for correctness and then press any key to continue");
    pause;
    close all

    %currently users have to manually remove any bad trials by deleting
    %files and/or setting the TTS trial number in the master spread sheet
    %to 0
    %could add to this code to ask user to identify all/any bad trials 
    % and enter their values maybe add if statement where if they type 
    % a key it doesn't update the existing values
end
disp("Script Complete");

function PlotNxM(N,M, data,Color_List,lines_per_plot,label,match_list)
    figure;
    subplot(N,M,1);
    [~,col]=size(data);
    %create a subplot for each trial 
    for i = 1:col
        
        %get correct color for the plot based on the trial name stored in
        %the label
        color_index = 1;
        for j = 1:length(match_list)
            if contains(label(i), match_list(j))
                color_index = j+1;
                continue;
            end
        end
        %plot the current column of data and give the subplot a name
        %reflecting the unique combination of motion and GVS as well as the
        %trial number
        plot(data(:,i), 'color', Color_List(color_index));
        hold on;
        trial_name= char(strrep(label(i), '_', '.'));
        plot_title =trial_name(1:16);
        title(plot_title);

        %either stay at the current subplot or advance to the next subplot
        index = floor((i)/lines_per_plot+1);
        if i < col
        subplot(N,M,index);
        end
        
    end
end
