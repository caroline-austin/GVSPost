%% script 4 of IMU data analysis
% Created by: Caroline Austin
% Modified by: Caroline Austin
% Date: 11/20/2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMU data in the form of 'Allimu.mat'
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all;
restoredefaultpath;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from
%%
subnum = [2049, 2051,2053:2057, 2061:2062, 2078:2090];  % Subject List 2049, 2051,2053:2062
numsub = length(subnum);
subskip = [2058 2059 2060 2069:2077 2083 2085 2086 2070 2072 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

sub_symbols = ["kpentagram";"k<";"khexagram";"k>"; "kdiamond";"kv";"ko";"k+"; "k*"; "bpentagram";"b<";"bhexagram";"b>"; "bdiamond";"bv";"bo";"b+"; "b*"; "bx"; "bsquare"; "b^"; "kx"; "ksquare"; "k^"];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15; -0.15; -0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25; -0.25;-0.2;-0.15; -0.15; -0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

plots = [" "];

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
orange = [0.9020, 0.6235, 0.0000];  % golden orange
skyblue = [0.3373, 0.7059, 0.9137]; % sky blue
pink = [0.8353, 0.3686, 0.0000];    % strong warm pink
teal = [0.2667, 0.4471, 0.3843];    % muted teal
% yellow = [0.9451, 0.8941, 0.2588];  % soft yellow
brown = [0.7059, 0.3961, 0.1137];   % medium brown
yellow = [255 190 50]/255;
black = [0 0 0];

%%

cd([file_path]);
load(['Allimu.mat'])
cd(code_path);
imu_dir = Label.imu_angles;
%%
% plot the sway angle over time - separate plot for each subject and sway
% direction
if contains(plots, "1 ")
%%

    for sub = 1:1%numsub
        subject = subnum(sub);
        subject_str = num2str(subject);
        for dir = 2%1:2
        figure;
        for trial = 1:5
            plot(squeeze(all_trials_sort(trial, sub,dir,:))');
            hold on;
            xlim([0 240])
            ylabel("Shoulder (deg)")
            ylim([-4 4])
            
        end
        sgtitle([subject_str imu_dir(dir)])
        % legend(Label.all_trials_sort{sub,:})
        end
        
    end
end

if contains(plots, " 2 ")
    %% mag interest
    for dir = 2%1:2
        data_plot = mag_interest_sort(:,:,dir)';
        figure;
        colors = [green/2; green; green; green/2; green; green];
        hold on; 
        for i = 1:width(data_plot)
            boxchart((ones(numsub,1) * i), data_plot(:,i), 'BoxFaceColor', colors(i,:));

            for sub = 1:numsub % num of sub
                plot(i+xoffset2(sub), data_plot(sub,i), sub_symbols(sub))
            end
        end
        yscale("log")
        ylim([0.005 5])
        yticks([0.005 0.05 0.5 5])
        xticklabels([ "", "0.1mA 1Hz", "2mA 1Hz", "4mA 1Hz","0.1mA 0.5Hz", "2mA 0.5Hz", "4mA 0.5Hz"])
        title("Sway Magnitude")
        grid on
        set(gcf, 'Position', [100, 100, 900, 500]);

    end

end

if contains(plots, " 3 ")
    %% psd interest
    for dir = 2%1:2
        data_plot = psd_interest_sort(:,:,dir)';
        figure;
        colors = [green/2; green; green; green/2; green; green];
        hold on; 
        for i = 1:width(data_plot)
            boxchart((ones(numsub,1) * i), data_plot(:,i), 'BoxFaceColor', colors(i,:));

            for sub = 1:numsub % num of sub
                plot(i+xoffset2(sub), data_plot(sub,i), sub_symbols(sub))
            end
        end
        yscale("log")
        ylim([5*10^-6 .5])
        yticks([5*10^-6 5*10^-5 0.0005 0.005 0.05 0.5])
        xticklabels([ "", "0.1mA 1Hz", "2mA 1Hz", "4mA 1Hz","0.1mA 0.5Hz", "2mA 0.5Hz", "4mA 0.5Hz"])
        title("Sway PSD")
        grid on
    end

end


