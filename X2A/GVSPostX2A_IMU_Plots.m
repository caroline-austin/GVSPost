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
 plots = ['  '];

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
Profiles_safe = ["DCRight_Front"; "DCLeft_Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
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
%% plot 1 - rms of anglular position in a box plot across current amps for the 0.5 Hz profile
for prof = 1:num_profiles
    rms_plot.(Profiles_safe(prof)) = single_metric_plot(subnum,subskip,imu_dir(4:6), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof], 1, rms_save, "Current Amplitude (mA)", "RMS (deg)", sub_symbols, xoffset2);
end
disp("press any key to continue")
pause 
close all;
end

if contains(plots,'2 ')
%% plot 2 
%  mean (dominant) freq in angular position data in a box plot across 
% current amps for the 0.5 Hz profile (first set of plots)
% and the power at that mean freq. (2nd set of plots)
for prof = 4%1:num_profiles
    mean_freq_plot.(Profiles_safe(prof)) = single_metric_plot(subnum,subskip,imu_dir(4), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof],1, mean_freq, "Current Amplitude (mA)", "Mean Freq (Hz)", sub_symbols, xoffset2);
    mean_power_plot.(Profiles_safe(prof)) = single_metric_plot(subnum,subskip,imu_dir(4), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof],1, mean_power, "Current Amplitude (mA)", "Mean Amp (deg)", sub_symbols, xoffset2);
end
disp("press any key to continue")
pause 
close all;
end

if contains(plots,'3 ')
%% plot 3 - 
%  median (dominant) freq in angular position data in a box plot across 
% current amps for the 0.5 Hz profile (first set of plots)
% and the power at that median freq. (2nd set of plots)
for prof = 1:num_profiles
    med_freq_plot.(Profiles_safe(prof))  = single_metric_plot(subnum,subskip,imu_dir(4), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof], 1, med_freq, "Current Amplitude (mA)", "Mean Freq (Hz)", sub_symbols, xoffset2);
    med_power_plot.(Profiles_safe(prof))  = single_metric_plot(subnum,subskip,imu_dir(4), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof], 1,med_power, "Current Amplitude (mA)", "Mean Power (deg?)", sub_symbols, xoffset2);
end
disp("press any key to continue")
pause 
close all;
end

if contains(plots,' 4 ')
%% plot 4
% phase shift, amplitude, and freq. fitted by the sinusodial fit model box
% plot across current amps for the 0.5 Hz profile
for prof = 4%1:num_profiles
    fit_phase_shift_plot.(Profiles_safe(prof))  = single_metric_plot(subnum,subskip,imu_dir(4), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof], 1, phase_shift, "Current Amplitude (mA)", "Phase shift (deg)", sub_symbols, xoffset2);
    fit_amp_plot.(Profiles_safe(prof))  = single_metric_plot(subnum,subskip,imu_dir(4), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof], 1, fit_amp, "Current Amplitude (mA)", "Amplitude (deg)", sub_symbols, xoffset2);
    fit_freq_plot.(Profiles_safe(prof))  = single_metric_plot(subnum,subskip,imu_dir(4), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof], 1, fit_freq, "Current Amplitude (mA)", "Freq (Hz)", sub_symbols, xoffset2);
end
disp("press any key to continue")
pause 
close all;
end

if contains(plots,' 5 ')
%% plot 5
% mean or median estimated sway amplitude (1/2* difference in peak to peak sway) 
% (pulled for all peak time points in a trial, based on frequency fit by 
% the sinusoidal fit model). box plot across current amps for the 0.5Hz
% profile
for prof = 1:num_profiles
    mean_amp_plot.(Profiles_safe(prof))  = single_metric_plot(subnum,subskip,imu_dir(4:6), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof],1, mean_amp, "Current Amplitude (mA)", "Amplitude (deg)", sub_symbols, xoffset2);
    med_amp_plot.(Profiles_safe(prof))  = single_metric_plot(subnum,subskip,imu_dir(4:6), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof],1, med_amp, "Current Amplitude (mA)", "Amplitude (deg)", sub_symbols, xoffset2);
end
disp("press any key to continue")
pause 
close all;
end


if contains(plots,'6 ')
%% plot  6 
% plots the power of the signal at select frequencies - box plot across
% current amplitudes for each evaluated frequency within the 0.5 Hz profile
for prof = 4%1:num_profiles
for freq = [10 11]%1:length(freq_interest)
    y_label = strjoin (["Power at " num2str(freq_interest(freq)) "Hz 10log10(deg^2 /Hz)"]);
    power_interest_plot.(Profiles_safe(prof)).(strrep(strrep(strjoin(["X" num2str(freq_interest(freq))]),'.', '_'), ' ', ''))  =  ...
        single_metric_plot(subnum,subskip,imu_dir(4:5), Config , [1:3], Current_amp',[1:9], Profiles_safe, [prof],freq, power_interest, "Current Amplitude (mA)", y_label, sub_symbols, xoffset2);
    disp("press any key to continue") 
    pause 
    close all;

end
end

end
if contains(plots,'7 ')
%% plot  7
% plots the power of the signal at select frequencies - box plot across
% low/min/max current amplitudes for each evaluated frequency within  a 
% given profile 
for prof = 4%1:num_profiles
for freq = [10 11]%1:length(freq_interest)
    y_label = strjoin (["Power at " num2str(freq_interest(freq)) "Hz 10log10(deg^2 /Hz)"]);
    power_interest_plot.(Profiles_safe(prof)).(strrep(strrep(strjoin(["X" num2str(freq_interest(freq))]),'.', '_'), ' ', ''))  =  ...
        single_metric_plot(subnum,subskip,imu_dir(4:5), Config , [1:3], Label.CurrentAmpReduced',[1:3], Profiles_safe, [prof],freq, power_interest_reduced, "Current Amplitude (mA)", y_label, sub_symbols, xoffset2);
    disp("press any key to continue") 
    pause 
    close all;

end
end
end
if contains(plots,'8 ')
%% plot 8
% plots the power of the signal across selected frequencies for a selected
% current amplitude and profile compination
for prof = 4%1:num_profiles
for current = [8]%1:length(freq_interest)
    y_label = strjoin (["Power at " num2str(Current_amp(current)) "mA 10log10(deg^2 /Hz)"]);
    data_plot = single_metric_plot2(subnum,subskip,imu_dir(4:5), Config,[1:3], Current_amp', [current], Profiles_safe, [prof], freq_interest, [2:18] ,power_interest, "Frequency (Hz)", y_label,sub_symbols, xoffset2);
    disp("press any key to continue") 
    pause 
    close all;
end
end
end
if contains(plots,'9 ')
%% plot 9
% plots the power of the signal across selected frequencies for a selected
% current amplitude (low min max) and profile compination
for prof = [2]%1:num_profiles
for current = [1]%1:3
    y_label = strjoin (["Power at " num2str(Label.CurrentAmpReduced(current)) "mA 10log10(deg^2 /Hz)"]);
    data_plot = single_metric_plot2(subnum,subskip,imu_dir(4:5), Config,[1:3], Label.CurrentAmpReduced',[current], Profiles_safe, [prof], freq_interest, [2:18] ,power_interest_reduced, "Frequency (Hz)", y_label,sub_symbols, xoffset2);
    disp("press any key to continue") 
    pause 
    close all;
end
end
end




if contains(plots,'X ')
%% plot X - plots angle over time
for prof = [1 2]%1:num_profiles
    ang_plot.(Profiles_safe(prof))  = time_series_plot(subnum,subskip,imu_dir(7:9), Config , [1:3], Current_amp',[2:9], Profiles_safe, [prof], all_ang, all_time, "Angle (deg)");
    disp(" press any key to close all") %subnum
    pause;
    close all;
end


end


if contains(plots,'Y ')
    %% plot Y - plots linear acceleration over time
for prof = 1:num_profiles
    acc_plot.(Profiles_safe(prof))  = time_series_plot(subnum,subskip,imu_dir(1:3), Config , [1:3], Current_amp',[2:9], Profiles_safe, [prof], all_imu_data, all_time, "acceleration (m/s)");
    disp(" press any key to close all")
    pause;
    close all;
end

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


function data_plot = single_metric_plot(subnum,subskip,figure_var, subplot_var,subplot_indices, trial_var, trial_indices, extra_var, extra_var_indices, extra_index2 ,data, x_label, y_label,sub_symbols, xoffset)

numsub = length(subnum);
num_figure_var = length(figure_var);
num_subplot_var = length(subplot_var);
num_trial_var = length(trial_var);
num_extra_var = length(extra_var);
color_grad = turbo(num_trial_var);
sub2use = [2 3 5 6 7 9];

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
                    data_plot.(subplot_var(subplot)).(figure_var(figure_index))(:,trial) = data(trial,extra_index,subplot,sub2use,figure_index,extra_index2);
                    % mean_freq_plot.(Config(j)).(imu_dir(4))(:,i) = power_interest_roll{i,4,j}(:,10);

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
            save_index = 0;
            for sub = 1:numsub
                subject = subnum(sub);
                subject_str = num2str(subject);
                 if ismember(subject,subskip) == 1
                   continue
                 end
                 save_index = save_index+1;
                for trial = 1:num_trial_var
                    
                    plot(trial+xoffset(sub), data_plot.(subplot_var(subplot)).(figure_var(figure_index))(save_index,trial),sub_symbols(sub),'MarkerSize',15,"LineWidth", 1.5);
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


function data_plot = single_metric_plot2(subnum,subskip,motion_dir, Config,config_indices, Current, current_indices, Profiles, profile_indices, freq_interest, freq_indices ,data, x_label, y_label,sub_symbols, xoffset)

numsub = length(subnum);
num_figure_var = length(motion_dir);
num_subplot_var = length(Config);
num_trial_var = length(Current);
num_extra_var = length(Profiles);
color_grad = turbo(num_trial_var);
sub2use = [2 3 5 6 7 9];

    for dir_index =1:num_figure_var
        f(dir_index) = figure();
        tiledlayout(num_subplot_var,1, 'Padding', 'none', 'TileSpacing', 'compact'); 
        sgtitle (strjoin([ motion_dir(dir_index) y_label num2str(Profiles(profile_indices)) ]))
    end
% organize data into plotting variable
    for config = config_indices
        for current = current_indices
            for dir_index =1:num_figure_var
                for profile = profile_indices
                    for freq = freq_indices
                        data_plot.(Config(config)).(motion_dir(dir_index)).(strrep(strrep(strjoin(["X" num2str(Current(current))]),'.', '_'), ' ', ''))(:,freq) = data(current,profile,config,sub2use,dir_index,freq);
                    % mean_freq_plot.(Config(j)).(imu_dir(4))(:,i) = power_interest_roll{i,4,j}(:,10);
                    end
                end
            end

        end

        for dir_index =1:num_figure_var
            figure(f(dir_index));
            nexttile

            boxplot(data_plot.(Config(config)).(motion_dir(dir_index)).(strrep(strrep(strjoin(["X" num2str(Current(current))]),'.', '_'), ' ', '')));
            hold on;
            title(Config(config));
            xticks(freq_indices);
            xticklabels(freq_interest(freq_indices));
            save_index = 0;
            for sub = 1:numsub
                subject = subnum(sub);
                subject_str = num2str(subject);
                 if ismember(subject,subskip) == 1
                   continue
                 end
                 save_index = save_index+1;
                for freq = freq_indices
                    
                    plot(freq+xoffset(sub), data_plot.(Config(config)).(motion_dir(dir_index)).(strrep(strrep(strjoin(["X" num2str(Current(current))]),'.', '_'), ' ', ''))(save_index,freq),sub_symbols(sub),'MarkerSize',15,"LineWidth", 1.5);
                    hold on;
                end
            end

            if config ==2
                ylabel(y_label)
            elseif config == 3
            xlabel(x_label)
            end
            % ylim([0 0.25]);
            grid minor

        end


    end


end