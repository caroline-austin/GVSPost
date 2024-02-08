%% Dynamic GVS X1A - Script 8a
% Locates the peaks and valleys of the GVS Current for each individual's
% trial, and saves the SHOT Perception at that point
%
% Edit the subject range and dataType for what is needed, then hit run and
% navigate to your Data folder that has been synced with the repository.
%
% Initial Code by Lanna K, oct 2023


%% Housekeeping
clear; close all; clc;

%%%%% Edit Here: %%%%%%%%%%%%%%%%%%
% Which Subjects and files to find?
subnum = 1011:1022;  % Subject List 
subskip = [1006 1007 1008 1009 1010 1013 1015 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'BiasTimeGain';      % options are '', 'Bias', 'BiasTime', 'BiasTimeGain'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ttsProfileNums = ["_4A" "_4B" "_5A" "_5B" "_6A" "_6B"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
gvsProfiles = ["N700"; "N750"; "N800"; "N000";"P700"; "P750"; "P800"];
shotStr = "shot";
gvsStr = "GVS";
tiltStr = "tilt";
numsub = length(subnum);
count = 0;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instantiate the arrays for saving Data
for i = 1:numel(ttsProfileNums)

        gvsTrial = strcat(gvsStr,ttsProfileNums(i));
        shotTrial = strcat(shotStr,ttsProfileNums(i));
        tiltTrial = strcat(tiltStr,ttsProfileNums(i));

    for j = 1:numel(gvsProfiles)
        % GVS Arrays
        AllChangePercep.(gvsTrial).(gvsProfiles(j)) = [];
        AllChangeGvs.(gvsTrial).(gvsProfiles(j)) = [];
        % Tilt Arrays
        AllChangePercep.(tiltTrial).(gvsProfiles(j)) = [];
        AllChangeTilt.(tiltTrial).(gvsProfiles(j)) = [];

    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Locate Saved Data
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
[filenames]=file_path_info2(code_path, file_path); % get files from file folder


% Loop through the subjects
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);

    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end   

    %load subject files
    if ismac || isunix
        subject_path = [file_path, '/' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Group' datatype '.mat']);
        cd(code_path);
    elseif ispc
        subject_path = [file_path, '\' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Group' datatype '.mat ']);
        cd(code_path);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Instantiate the Subject-Specific arrays for saving Data
    for i = 1:numel(ttsProfileNums)

        gvsTrial = strcat(gvsStr,ttsProfileNums(i));
        shotTrial = strcat(shotStr,ttsProfileNums(i));
        tiltTrial = strcat(tiltStr,ttsProfileNums(i));

        for j = 1:numel(gvsProfiles)
            % GVS Arrays
            Subject(sub).AllChangePercep.(gvsTrial).(gvsProfiles(j)) = [];
            Subject(sub).AllChangeGvs.(gvsTrial).(gvsProfiles(j)) = [];
            % Tilt Arrays
            Subject(sub).AllChangePercep.(tiltTrial).(gvsProfiles(j)) = [];
            Subject(sub).AllChangeTilt.(tiltTrial).(gvsProfiles(j)) = [];

        end
    end

    for i = 1:numel(ttsProfileNums)
        % Which Profile are we looking at?
        gvsTrial = strcat(gvsStr,ttsProfileNums(i));
        shotTrial = strcat(shotStr,ttsProfileNums(i));
        tiltTrial = strcat(tiltStr,ttsProfileNums(i));
        % Which Columns contain command data?
        gvsList = contains(Label.(gvsTrial),"command");
        tiltList = contains(Label.(tiltTrial),"command");

        % Loop through each of the recorded GVS trials for that motion profile
        for j = 1:length(Label.(gvsTrial))

            % Skip the non-command columns
            if gvsList(j) == 0 || tiltList(j) == 0
                continue
            end
            count = count + 1;

            % Pull the GVS and Tilt files
            gvsFile = eval(gvsTrial);
            tiltFile = eval(tiltTrial);

            %% Tilt Calculations
            % Find the local min and max indices
            tiltMax = islocalmax(tiltFile(:,j),'MinProminence',0.1,'MinSeparation',100);
            tiltMaxIndices = find(tiltMax);
            tiltMin = islocalmin(tiltFile(:,j),'MinProminence',0.1,'MinSeparation',100);
            tiltMinIndices = find(tiltMin);
            tiltAllIndices = union(tiltMinIndices,tiltMaxIndices);% Combine the two arrays

            % Save the Shot values at those points
            shotData = eval(shotTrial);                                     % The entire file of shot responses for that profile
            perceptionPoints = shotData(tiltAllIndices,count);              % The shot perception at the mins and maxs
            tiltPoints = tiltFile(tiltAllIndices,j);                        % The tilt angle at the mins and maxs
            shotAtTiltPeaks(sub).(shotTrial).(Label.(shotTrial)(count)) = tiltPoints;


            % Clear Out Last Subject's Variables
                shotAtTiltPeaks(sub).(shotTrial).changeInPerception = [];
                shotAtTiltPeaks(sub).(shotTrial).AbsChangeInPerception = [];
                shotAtTiltPeaks(sub).(shotTrial).changeInTilt = [];
                shotAtTiltPeaks(sub).(shotTrial).AbsChangeInTilt = [];

            % Form an array of the change in perception between peaks
            for k = 1:length(perceptionPoints)-1
                tiltDiff = tiltPoints(k+1)-tiltPoints(k);
                percepDiff = perceptionPoints(k+1)-perceptionPoints(k);
%                 if tiltDiff < 0     % Change in tilt is negative
%                     percepDiff = (perceptionPoints(k+1)-perceptionPoints(k))*-1;
%                 else                % Change in tilt is positive
%                     percepDiff = perceptionPoints(k+1)-perceptionPoints(k);
%                 end

                shotAtTiltPeaks(sub).(shotTrial).changeInPerception(k,count) = percepDiff;
                shotAtTiltPeaks(sub).(shotTrial).AbsChangeInPerception(k,count) = abs(percepDiff);
                shotAtTiltPeaks(sub).(shotTrial).changeInTilt(k,count) = tiltDiff;
                shotAtTiltPeaks(sub).(shotTrial).AbsChangeInTilt(k,count) = abs(tiltDiff);
            end

            TiltAbsChangePercep = shotAtTiltPeaks(sub).(shotTrial).AbsChangeInPerception(:,count);
            TiltChangePercep = shotAtTiltPeaks(sub).(shotTrial).changeInPerception(:,count);
            TiltAbsChangeTilt = shotAtTiltPeaks(sub).(shotTrial).AbsChangeInTilt(:,count);
            TiltChangeTilt = shotAtTiltPeaks(sub).(shotTrial).changeInTilt(:,count);

            for m = 1:length(match_list)
                % Match the velocity, tilt or combined data
                if contains(Label.(shotTrial)(count), match_list(m))
                    % Add in the Tilt Data
                    AllChangePercep.(tiltTrial).(gvsProfiles(m)) = cat(2,AllChangePercep.(tiltTrial).(gvsProfiles(m)),TiltChangePercep);
                    AllChangeTilt.(tiltTrial).(gvsProfiles(m)) = cat(2,AllChangeTilt.(tiltTrial).(gvsProfiles(m)),TiltChangeTilt);
                    % Add in the Subject-Specific Tilt Data
                    Subject(sub).AllChangePercep.(tiltTrial).(gvsProfiles(m)) = cat(2,Subject(sub).AllChangePercep.(tiltTrial).(gvsProfiles(m)),TiltChangePercep);
                    Subject(sub).AllChangeTilt.(tiltTrial).(gvsProfiles(m)) = cat(2,Subject(sub).AllChangeTilt.(tiltTrial).(gvsProfiles(m)),TiltChangeTilt);
                end
            end

            %% GVS Calculations

            if contains(Label.(gvsTrial)(j),"P_0_00")
                % Skip trials that do not have GVS applied. The GVS profile is flat, 
                % so there are no peaks to the profile
                continue
            end

            % Find the local min and max indices
            gvsMax = islocalmax(gvsFile(:,j),'MinProminence',0.1,'MinSeparation',100);
            gvsMaxIndices = find(gvsMax);
            gvsMin = islocalmin(gvsFile(:,j),'MinProminence',0.1,'MinSeparation',100);
            gvsMinIndices = find(gvsMin);
            gvsAllIndices = union(gvsMinIndices,gvsMaxIndices); % Combine the two arrays

            % Save the Shot values at those points
            shotData = eval(shotTrial);
            perceptionPoints = shotData(gvsAllIndices,count);
            gvsPoints = gvsFile(gvsAllIndices,j);
            shotAtGVSPeaks(sub).(shotTrial).(Label.(shotTrial)(count)) = gvsPoints;

            % Clear Variables
            shotAtGVSPeaks(sub).(shotTrial).changeInPerception = [];
            shotAtGVSPeaks(sub).(shotTrial).AbsChangeInPerception = [];
            shotAtGVSPeaks(sub).(shotTrial).changeInGVS = [];
            shotAtGVSPeaks(sub).(shotTrial).AbsChangeInGVS = [];

            for k = 1:length(perceptionPoints)-1
                gvsDiff = gvsPoints(k+1)-gvsPoints(k);
                percepDiff = perceptionPoints(k+1)-perceptionPoints(k);
%                 if gvsDiff < 0     % Change in gvs is negative
%                     percepDiff = (perceptionPoints(k+1)-perceptionPoints(k))*-1;
%                 else                % Change in gvs is positive
%                     percepDiff = perceptionPoints(k+1)-perceptionPoints(k);
%                 end

                shotAtGVSPeaks(sub).(shotTrial).changeInPerception(k,count) = percepDiff;
                shotAtGVSPeaks(sub).(shotTrial).AbsChangeInPerception(k,count) = abs(percepDiff);
                shotAtGVSPeaks(sub).(shotTrial).changeInGVS(k,count) = gvsDiff;
                shotAtGVSPeaks(sub).(shotTrial).AbsChangeInGVS(k,count) = abs(gvsDiff);
            end

            GvsAbsChangePercep = shotAtGVSPeaks(sub).(shotTrial).AbsChangeInPerception(:,count);
            GvsChangePercep = shotAtGVSPeaks(sub).(shotTrial).changeInPerception(:,count);
            GvsAbsChangeGvs = shotAtGVSPeaks(sub).(shotTrial).AbsChangeInGVS(:,count);
            GvsChangeGvs = shotAtGVSPeaks(sub).(shotTrial).changeInGVS(:,count);


            for m = 1:length(match_list)
                % Match the velocity, tilt or combined data
                if contains(Label.(shotTrial)(count), match_list(m))
                    % Add in the GVS Data
                    AllChangePercep.(gvsTrial).(gvsProfiles(m)) = cat(2,AllChangePercep.(gvsTrial).(gvsProfiles(m)),GvsChangePercep);
                    AllChangeGvs.(gvsTrial).(gvsProfiles(m)) = cat(2,AllChangeGvs.(gvsTrial).(gvsProfiles(m)),GvsChangeGvs);
                    % Add in the Subject-Specific GVS Data
                    Subject(sub).AllChangePercep.(gvsTrial).(gvsProfiles(m)) = cat(2,Subject(sub).AllChangePercep.(gvsTrial).(gvsProfiles(m)),GvsChangePercep);
                    Subject(sub).AllChangeGvs.(gvsTrial).(gvsProfiles(m)) = cat(2,Subject(sub).AllChangeGvs.(gvsTrial).(gvsProfiles(m)),GvsChangeGvs);
                end
            end

        end
        count = 0;
    end

    %% Plot the individual subject data
    % Group Data by GVS Coupling Type
    figure();
    plotTitle = strcat("Subject ",subject_str,"Change in Perception vs Change in Tilt"); 
    xData = Subject(sub).AllChangeTilt;
    yData = Subject(sub).AllChangePercep;
    Subject(sub).LinearRegression = plottingFx(gvsProfiles,ttsProfileNums,xData,yData,plotTitle,true);

    % Group Data by TTS Motion Profile
    for i = 1:length(ttsProfileNums)
        figure();   % One figure per tts motion profile
        Subject(sub).LinearRegressionByMotion.(strcat('motion',ttsProfileNums(i))) = plottingFx(gvsProfiles,ttsProfileNums(i),xData,yData,plotTitle,false);
    end

end

%% Plot the Aggregate Subject Perceptions
% Change in Tilt vs Change in Perception 
figure();
plotTitle = "Aggregate Subject Data"; 
xData = AllChangeTilt;
yData = AllChangePercep;
LinearRegression = plottingFx(gvsProfiles,ttsProfileNums,xData,yData,plotTitle,false);


%% save data arrays to files
%group data into array
peak_save_all = NaN(length(subnum),length(gvsProfiles));
peak_save_4A = peak_save_all; peak_save_4B = peak_save_all;
peak_save_5A = peak_save_all; peak_save_5B = peak_save_all;
peak_save_6A = peak_save_all; peak_save_6B = peak_save_all;

for i = 1:length(subnum)
    subject = subnum(i);

    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1; continue; end

    peak_save_all(i,:) = Subject(i).LinearRegression;

    peak_save_4A(i,:) = Subject(i).LinearRegressionByMotion.(strcat('motion',ttsProfileNums(1)));
    peak_save_4B(i,:) = Subject(i).LinearRegressionByMotion.(strcat('motion',ttsProfileNums(2)));
    peak_save_5A(i,:) = Subject(i).LinearRegressionByMotion.(strcat('motion',ttsProfileNums(3)));
    peak_save_5B(i,:) = Subject(i).LinearRegressionByMotion.(strcat('motion',ttsProfileNums(4)));
    peak_save_6A(i,:) = Subject(i).LinearRegressionByMotion.(strcat('motion',ttsProfileNums(5)));
    peak_save_6B(i,:) = Subject(i).LinearRegressionByMotion.(strcat('motion',ttsProfileNums(6)));

end

%Sham Removed
peak_save_all_shamRemoved = NaN(length(subnum),length(gvsProfiles)-1);
for i = 1:length(subnum)
    for j = 1:length(gvsProfiles)
        subject = subnum(i);
        gvsCoupling = gvsProfiles(j);

        % skip subjects that DNF'd or there is no data for
        if ismember(subject,subskip) == 1; continue; end
        if matches(gvsCoupling,"N000") == 1; continue; end

        peak_save_all_shamRemoved(i,j) = Subject(i).LinearRegression(j) - Subject(i).LinearRegression(4);
    end
end

cd(file_path);
vars_2_save = ['subnum peak_save_all peak_save_all_shamRemoved gvsProfiles peak_save_4A peak_save_4B peak_save_5A peak_save_5B peak_save_6A peak_save_6B ttsProfileNums'];
eval(['  save ' ['S' 'AllPeaksValleys' datatype '.mat '] vars_2_save ' vars_2_save']);
cd(code_path)

%% Box and Whisker Graphs
figure;
boxplot(peak_save_all_shamRemoved);
xticklabels(gvsProfiles')
xlabel("GVS Coupling Condition")
ylabel("Slope of Linear Regression Line")
title("Change in Perception Vs Change in Tilt","Peaks Valleys Metric");

%%%%%
 figure;
b = boxplot(peak_save_all);
% b.BoxFaceColor = blue;
plot_label = ["- Velocity";"- Semi";"- Angle"; "No GVS"; "+ Velocity"; "+ Semi";"+ Angle" ];
% xticks([1 2 3 4 5 6 ]);
xticklabels(plot_label);
hold on;

for j = 1:numsub
    for i = 1:width(peak_save_all)
        
        plot(i+xoffset2(j), peak_save_all(j, i),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
        hold on;
    end
end

xlabel("GVS Coupling Scheme")
ylabel("Perception/Actual (deg/deg)")
ax = gca;
ax.XAxis.FontSize = 32;
ax.YAxis.FontSize = 32;
hold on; 
sgtitle(['Perception/Actual Change Slope' ],fontsize = 36); % for nice pretty plots
% sgtitle(['Perception-tilt-Slope-All-Profiles: AllSubjectsBoxPlot' datatype ]); %for within the group plots

 cd(plots_path);
    saveas(gcf, [ 'Perception-change-Slope-All-ProfilesAllSubjectsBoxPlot' datatype  ]); 
    cd(code_path);
    hold off;   
    %%%%%%

    %%
    peak_means = mean(peak_save_all, 'omitnan');
    peak_std = std(peak_save_all, 'omitnan');

%% Plotting Function (grouped by GVS Coupling)
function [b] = plottingFx(outerLoop,innerLoop,xInput,yInput,sgTitleString,plotOrNot)

tiltStr = "tilt";
b = NaN(1,numel(outerLoop));

for i = 1:numel(outerLoop)    % Loop through the 7 coupling types

    %Instantiate empty arrays for compiling data
    x = [];
    y = [];

    for j = 1:numel(innerLoop)    % Loop through the 6 Motion Profiles
        gvsCoupling = convertStringsToChars(outerLoop(i));
        tiltTrial = strcat(tiltStr,innerLoop(j));

        tiltData = reshape(xInput.(tiltTrial).(outerLoop(i)), [],1);
        perceptionData = reshape(yInput.(tiltTrial).(outerLoop(i)), [],1);

        % Cat the data into an outer-loop specific array
        x = cat(1,x,tiltData);
        y = cat(1,y,perceptionData);

        % Determine the color of the dots
        switch gvsCoupling(2:4)
            case '000'
                color = [0.8500 0.3250 0.0980]; %red
            case '700'
                color = [0 0.4470 0.7410]; %blue
            case '750'
                color = [0.4660 0.6740 0.1880]; %green
            case '800'
                color = [0.4940 0.1840 0.5560]; %purple
        end

        switch gvsCoupling
            case 'N700'
                subplot(2,4,1)
            case 'N750'
                subplot(2,4,2)
            case 'N800'
                subplot(2,4,3)
            case 'N000'
                subplot(2,4,4)
            case 'P700'
                subplot(2,4,5)
            case 'P750'
                subplot(2,4,6)
            case 'P800'
                subplot(2,4,7)
        end

        if plotOrNot == false; continue; end
        title(gvsCoupling)
        scatter(tiltData,perceptionData,[],color,'filled');
        hold on;
        sgtitle(sgTitleString)
        ylim([-40 40]); xlim([-15 15]);
        xlabel("Change in Tilt (deg)"); ylabel("Change in Perception (deg)");
    
    end
    % Calculate and plot linear regression line
    b(i) = x\y;   % Slope of the line
    if b(i) == 0; b(i) = NaN; end
    yCalc = b(i)*x;
    if plotOrNot == false; continue; end
    lrLine = plot(x,yCalc);
    lrLine.Color = 'k';
    lrLine.LineWidth = 2;
    txt = strcat('LR Line with slope of',num2str(b(i)));
    text(-14,-30,txt)
    title(gvsCoupling)

end

if plotOrNot == false; close; end   %close the unused plot
% End of plotting function
end