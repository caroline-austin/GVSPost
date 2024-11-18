%% script 3
% Created by: Caroline Austin
% Modified by: Caroline Austin
% 10/23/24

clear all; close all; clc;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

subnum = [2001:2010];  % Subject List 2001:2010 2001:2010
numsub = length(subnum);
subskip = [2001 2004 2008 2010];  %DNF'd subjects



%% plot info
 plots = [' 1 '];

 % plot 1 creates box plots for the rms metric - 3 plots (roll pitch and
 % yaw each with subplots for binaural, cevette, and aoyama)
 % plot 2 plots the angular position for the 0.5Hz sinusoidal trials -3
 % plots for each subject roll, pitch, and yaw each with subplots for
 % binaural, cevette, and aoyama and then separate lines for each current
 % amplitude
 %plot 3 plots the  position for the 0.5Hz sinusoidal trials -3
 % plots for each subject x, y, and z each with subplots for
 % binaural, cevette, and aoyama and then separate lines for each current
 % amplitude

 %% initialize  

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];
color_grad = turbo(9);

%naming variables 
Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
num_profiles = length(Profiles);

sub_symbols = ["kpentagram";"k<";"khexagram";"k>"; "kdiamond";"kv";"ko";"k+"; "k*"; "kx"; "ksquare"; "k^";"k*";"khexagram";"kdiamond";];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15; -0.15; -0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25;0.1;-0.1;0.025]; 


%% load data 
cd([file_path]);
load(['Allimu.mat'])
cd(code_path);

Config = Label.Config;
num_config = length(Config);
Current_amp = Label.CurrentAmp ;
num_current = length(Current_amp);
imu_dir = ['x' 'y' 'z' "roll" "pitch" "yaw" "yaw" "pitch" "roll"];



if contains(plots,' 1 ')
%% plot 1
rms_plot = single_metric_plot(subnum,subskip,imu_dir(4:6), Config , [1:3], Current_amp',[1:9], Profiles_safe, [4], rms_save, "Current Amplitude (mA)", "RMS (deg)", sub_symbols, xoffset2);

disp("press any key to continue")
pause 
close all;
end

if contains(plots,'2 ')
%% plot 2
mean_freq_plot = single_metric_plot(subnum,subskip,imu_dir(4), Config , [1:3], Current_amp',[1:9], Profiles_safe, [4], mean_freq, "Current Amplitude (mA)", "Mean Freq (Hz)", sub_symbols, xoffset2);

disp("press any key to continue")
pause 
close all;
end

if contains(plots,'3 ')
%% plot 3
f1 = figure();
tiledlayout(3,1, 'Padding', 'none', 'TileSpacing', 'compact'); 
sgtitle ('Roll direction Freq Power of 0.5Hz Profiles ')
f2 = figure();
tiledlayout(3,1, 'Padding', 'none', 'TileSpacing', 'compact'); 
sgtitle ('Pitch direction Freq Power of 0.5Hz Profiles ')
% f3 = figure();
% tiledlayout(3,1, 'Padding', 'none', 'TileSpacing', 'compact'); 
% sgtitle ('Yaw direction RMS of 0.5Hz Profiles ')
% organize data into plotting variable
    for j = 1:num_config
        for i = 1:num_current
            mean_freq_plot.(Config(j)).(imu_dir(4))(:,i) = power_interest_roll{i,4,j}(:,10);
            mean_freq_plot.(Config(j)).(imu_dir(5))(:,i) = power_interest_pitch{i,4,j}(:,10);
            % mean_freq_plot.(Config(j)).(imu_dir(6))(:,i) = mean_freq{i,4,j}(:,3);

        end
        figure(f1)
        nexttile
        boxplot(mean_freq_plot.(Config(j)).(imu_dir(4)));
        hold on;
        title(Config(j));
        xticks([1,2,3,4,5,6,7,8,9]);
        xticklabels(["0.1" ,"0.5" ,"1" ,"1.5" ,"2", "2.5" ,"3" ,"3.5" ,"4"]);
        if j ==2
            ylabel("Power (?)")
        elseif j == 3
        xlabel("Current Amplitude (mA)")
        end
        ylim([0 45]);
        grid minor
        

        figure(f2)
        nexttile
        boxplot(mean_freq_plot.(Config(j)).(imu_dir(5)));
        hold on;
        title(Config(j));
        xticks([1,2,3,4,5,6,7,8,9]);
        xticklabels(["0.1" ,"0.5" ,"1" ,"1.5" ,"2", "2.5" ,"3" ,"3.5" ,"4"]);
        if j ==2
            ylabel("Power (?)")
        elseif j == 3
        xlabel("Current Amplitude (mA)")
        end
        ylim([0 15]);
        grid minor
        % 
        % figure(f3)
        % nexttile
        % boxplot(mean_freq_plot.(Config(j)).(imu_dir(6)));
        % hold on;
        % title(Config(j));
        % xticks([1,2,3,4,5,6,7,8,9]);
        % xticklabels(["0.1" ,"0.5" ,"1" ,"1.5" ,"2", "2.5" ,"3" ,"3.5" ,"4"]);
        % if j ==2
        %     ylabel("RMS (deg/s)")
        % elseif j == 3
        % xlabel("Current Amplitude (mA)")
        % end
        % % ylim([0 0.25]);
        % grid minor

    end
    disp("press any key to continue")
    pause 
    close all;
end


if contains(plots,'X ')
%% plot X - plots angle over time
data_plot = time_series_plot(subnum,subskip,imu_dir(7:9), Config , [1:3], Current_amp',[2:9], Profiles_safe, [4], all_ang, all_time, "Angle (deg)");
disp(" press any key to close all")
pause;
close all;

end


if contains(plots,'Y ')
    %% plot Y - plots linear acceleration over time
data_plot = time_series_plot(subnum,subskip,imu_dir(1:3), Config , [1:3], Current_amp',[2:9], Profiles_safe, [4], all_imu_data, all_time, "acceleration (m/s)");
disp(" press any key to close all")
pause;
close all;
end


%% functions
%list of subjects, % %list of variables to
%separate the suplots by
function data_plot = time_series_plot(subnum,subskip,figure_var, subplot_var,subplot_indices, trial_var, trial_indices, extra_var, extra_var_indices, data, time, y_label)
numsub = length(subnum);
num_figure_var = length(figure_var);
num_subplot_var = length(subplot_var);
num_trial_var = length(trial_var);
num_extra_var = length(extra_var);
color_grad = turbo(num_trial_var);

for sub = 1:numsub
    
    subject = subnum(sub);
    subject_str = num2str(subject);
     if ismember(subject,subskip) == 1
       continue
     end
    for figure_index =1:num_figure_var
        f(figure_index) = figure();
        tiledlayout(num_subplot_var,1, 'Padding', 'none', 'TileSpacing', 'compact'); 
        sgtitle ([ figure_var(figure_index) ; num2str(extra_var(extra_var_indices)) 'subject: ' subject_str])
    end

 for subplot_index = subplot_indices
         for figure_index =1:num_figure_var
            figure(f(figure_index) );
            nexttile
        end 
        for trial_index = trial_indices
            for extra_index = extra_var_indices %might actually want to move this to be outermost loop?
            if isempty(data.(['A', subject_str]){trial_index,extra_index,subplot_index})
                        continue
            end

            data_plot.(subplot_var(subplot_index)).time{:,trial_index} = time.(['A' subject_str ]){trial_index,extra_index,subplot_index}(:,1);
            
            for figure_index =1:num_figure_var
                data_plot.(subplot_var(subplot_index)).(figure_var(figure_index)){:,trial_index} = data.(['A' subject_str ]){trial_index,extra_index,subplot_index}(:,figure_index);
                
                figure(f(figure_index));
                plot( data_plot.(subplot_var(subplot_index)).(figure_var(figure_index)){:,trial_index}, "Color", color_grad(trial_index,:)); hold on;
                hold on;
                title(subplot_var(subplot_index));

                % should proabably manually build the legend here
               
                if subplot_index ==2
                    ylabel(y_label)
                elseif subplot_index == 3
                xlabel("Time (ms)")
                end
                % ylim([0 0.25]);
            % grid minor

            
            end             
           
            end
        end
        for figure_index =1:num_figure_var
             figure(f(figure_index))
             legend(num2str(trial_var(trial_indices)));
        end

 end
 end

end


function data_plot = single_metric_plot(subnum,subskip,figure_var, subplot_var,subplot_indices, trial_var, trial_indices, extra_var, extra_var_indices, data, x_label, y_label,sub_symbols, xoffset)

numsub = length(subnum);
num_figure_var = length(figure_var);
num_subplot_var = length(subplot_var);
num_trial_var = length(trial_var);
num_extra_var = length(extra_var);
color_grad = turbo(num_trial_var);

    for figure_index =1:num_figure_var
        f(figure_index) = figure();
        tiledlayout(num_subplot_var,1, 'Padding', 'none', 'TileSpacing', 'compact'); 
        sgtitle (strjoin([ figure_var(figure_index) y_label num2str(extra_var(extra_var_indices)) ]))
    end
% organize data into plotting variable
    for subplot = subplot_indices
        for trial = trial_indices
            for figure_index =1:num_figure_var
                for extra_index = extra_var_indices
                    data_plot.(subplot_var(subplot)).(figure_var(figure_index))(:,trial) = data{trial,extra_index,subplot}(:,figure_index);

                end
            end

        end

        for figure_index =1:num_figure_var
            figure(f(figure_index));
            nexttile

            boxplot(data_plot.(subplot_var(subplot)).(figure_var(figure_index)));
            hold on;
            title(subplot_var(subplot));
            xticks(trial_indices);
            xticklabels(trial_var(trial_indices));

            for sub = 1:numsub
                subject = subnum(sub);
                subject_str = num2str(subject);
                 if ismember(subject,subskip) == 1
                   continue
                 end
                for trial = 1:num_trial_var
                    
                    plot(trial+xoffset(sub), data_plot.(subplot_var(subplot)).(figure_var(figure_index))(sub,trial),sub_symbols(sub),'MarkerSize',15,"LineWidth", 1.5);
                    hold on;
                end
            end

            if subplot ==2
                ylabel(y_label)
            elseif subplot == 3
            xlabel(x_label)
            end
            % ylim([0 0.25]);
            grid minor

        end


    end


end