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
profileNums = ["_4A" "_4B" "_5A" "_5B" "_6A" "_6B"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
gvsProfiles = ["N700"; "N750"; "N800"; "N000";"P700"; "P750"; "P800"];
shotStr = "shot";
gvsStr = "GVS";
tiltStr = "tilt";
numsub = length(subnum);
count = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instantiate the arrays for saving Data
for i = 1:numel(profileNums)

        gvsTrial = strcat(gvsStr,profileNums(i));
        shotTrial = strcat(shotStr,profileNums(i));
        tiltTrial = strcat(tiltStr,profileNums(i));

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

    for i = 1:numel(profileNums)
        % Which Profile are we looking at?
        gvsTrial = strcat(gvsStr,profileNums(i));
        shotTrial = strcat(shotStr,profileNums(i));
        tiltTrial = strcat(tiltStr,profileNums(i));
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
                end
            end

        end
        count = 0;
    end

end


%% Plot the Perceptions
% Change in GVS vs Change in Perception 
figure();
for i = 1:numel(profileNums)    % Loop through the 7 coupling types
    gvsTrial = strcat(gvsStr,profileNums(i));

    for j = 1:numel(gvsProfiles)
        gvsCoupling = convertStringsToChars(gvsProfiles(j));

        gvsData = reshape(AllChangeGvs.(gvsTrial).(gvsProfiles(j)), [],1);
        perceptionData = reshape(AllChangePercep.(gvsTrial).(gvsProfiles(j)), [],1);
        
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
            case 'P700'
                subplot(2,3,1)
            case 'P750'
                subplot(2,3,2)
            case 'P800'
                subplot(2,3,3)
            case 'N000'
                %skip
            case 'N700'
                subplot(2,3,4)
            case 'N750'
                subplot(2,3,5)
            case 'N800'
                subplot(2,3,6)
        end
        title(gvsCoupling)

        scatter(gvsData,perceptionData,[],color,'filled');
        hold on;
        sgtitle("Change in Perception vs Change in GVS")
        ylim([-40 40]); xlim([-8 8]);
        xlabel("Change in GVS (mA)"); ylabel("Change in Perception (deg)");
        zeroLine = refline(1,0);
        zeroLine.Color = 'k';
    end
end
 
 
% Change in Tilt vs Change in Perception 
figure();
for i = 1:numel(profileNums)    % Loop through the 7 coupling types
    tiltTrial = strcat(tiltStr,profileNums(i));


    for j = 1:numel(gvsProfiles)
        gvsCoupling = convertStringsToChars(gvsProfiles(j));

        tiltData = reshape(AllChangeTilt.(tiltTrial).(gvsProfiles(j)), [],1);
        perceptionData = reshape(AllChangePercep.(tiltTrial).(gvsProfiles(j)), [],1);
        
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
            case 'P700'
                subplot(2,4,1)
            case 'P750'
                subplot(2,4,2)
            case 'P800'
                subplot(2,4,3)
            case 'N000'
                subplot(2,4,4)
            case 'N700'
                subplot(2,4,5)
            case 'N750'
                subplot(2,4,6)
            case 'N800'
                subplot(2,4,7)
        end
        title(gvsCoupling)

        scatter(tiltData,perceptionData,[],color,'filled');
        hold on;
        sgtitle("Change in Perception vs Change in Tilt")
        ylim([-40 40]); xlim([-15 15]);
        xlabel("Change in Tilt (deg)"); ylabel("Change in Perception (deg)");
        zeroLine = refline(1,0);
        zeroLine.Color = 'k';
    end
end
