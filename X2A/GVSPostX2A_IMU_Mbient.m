%% Mbientlab IMU Balance Analysis
% Created by: Aaron Allred
% Modified by: Caroline Austin
% Date: 10/11/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMU data in the form of 'SubjectNumber-Condition-datatype.csv'
% Time stamps in the form of 'SubjectNumber-Romberg-TimeStamps.xlsx'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;
restoredefaultpath;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from
conditions = {'A'}; % right now ideally just one condition, might have an exp. A and B
datatype = {'Accelerometer','Gyroscope'};

numtrials = 30; % this number will vary, should not exceed 60
subnum = [2006];  % Subject List 2001:2010 2001:2010
groups = [1]; % ex: 1:Control 2:VisualCM % but I don't have groups yet so here all are the same
subskip = [2001 2008 2010];  %DNF'd subjects

%there is an issue with how subject 2004's data is being processed and
%saved for sorting that I need to look into 

% additional start buffer for IMU data (sec.) row = cond.; col = subject
% this accounts for the time difference btween starting the imu and
% starting the stop watch 
buffer = [21 9.5 8.5 8.5 9 21 6 0 10 0;%...
          132 0 0 132 0 0 0 0 0 0;]; %...
          % 8.5 9 0 0 0 0 0 0 0 0]; 

% seconds to truncate off each trial [start, end]
trunc = [0.3 -0.3]; %seconds 

% Used to find buffer time for timed trial arrays- this plot is not super
% helpful for finding the buffers with the GVSPost data
findbuffers = 1; % 1 is on other num is off
% Used to view sensor orientation over time
sensorpositionplot =0; % 1 is on other num is off

%% Initialize Storage Variables
numsub = length(subnum);
% Initialize variables for sway data
accel(numsub,numtrials,length(conditions)).x = 0;
accel(numsub,numtrials,length(conditions)).y = 0;
accel(numsub,numtrials,length(conditions)).z = 0;
vel(numsub,numtrials,length(conditions)).x = 0;
vel(numsub,numtrials,length(conditions)).y = 0;
vel(numsub,numtrials,length(conditions)).z = 0;
pos(numsub,numtrials,length(conditions)).x = 0;
pos(numsub,numtrials,length(conditions)).y = 0;
pos(numsub,numtrials,length(conditions)).z = 0;

% Initialize variables for balance metrics
rmsXYa = NaN(numsub,numtrials,length(conditions));
rmsXa = rmsXYa; rmsYa = rmsXYa;
p2pXa = rmsXYa; p2pYa = p2pXa;

%% Loop Through and get Metrics defining Sway
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd
    if ismember(subject,subskip) == 1
       continue
    elseif subject == 2004
         num_imu_files = 2;
    
    else
        num_imu_files = length(conditions);
    end
    
    for cond = 1:num_imu_files

        if num_imu_files > 1
        accelfile = [file_path,'/',num2str(subject),'/',...
            num2str(subject),'-A','-',...
            datatype{1},'-',  num2str(cond) ,'.csv'];

        gyrofile = [file_path,'/',num2str(subject),'/',...
            num2str(subject),'-A','-',...
            datatype{2}, '-' ,num2str(cond), '.csv'];

        timestampfile = [file_path,'/',num2str(subject),'/',...
            num2str(subject),'-All-TimeStamps-', num2str(cond) ,'.xlsx'];
        else
        % Get File names
        accelfile = [file_path,'/',num2str(subject),'/',...
            num2str(subject),'-',conditions{cond},'-',...
            datatype{1},'.csv'];

        gyrofile = [file_path,'/',num2str(subject),'/',...
            num2str(subject),'-',conditions{cond},'-',...
            datatype{2},'.csv'];

        timestampfile = [file_path,'/',num2str(subject),'/',...
            num2str(subject),'-All-TimeStamps.xlsx'];
        end
        
        if isfile(accelfile)==0
            continue
        end

        if subject == 2004 && cond ==1
        continue
        end

        % Read in raw data
        acceldata = readtable(accelfile,'ReadVariableNames',false);
        gyrodata = readtable(gyrofile,'ReadVariableNames',false);
        timestamps = readtable(timestampfile,'ReadVariableNames',false);

        if subject == 2004 && cond ==1
            acceldata.Var6 = acceldata.Var4;
            acceldata.Var5 = acceldata.Var3;
            acceldata.Var4 = acceldata.Var2;
            acceldata.Var3 = acceldata.Var1;
            acceldata.Var2 = acceldata.Var1;

            gyrodata.Var6 = gyrodata.Var4;
            gyrodata.Var5 = gyrodata.Var3;
            gyrodata.Var4 = gyrodata.Var2;
            gyrodata.Var3 = gyrodata.Var1;
            gyrodata.Var2 = gyrodata.Var1;
            
            timestamps.Var5 =timestamps.Var3;
        elseif subject == 2004
            timestamps.Var5 =timestamps.Var3;
        end

        numtrials = ceil(height(timestamps)/2); 
  
        % Ensure data aligns across measurement types
        time = 1/100:1/100:max(acceldata.Var3); % create aligned time vec %adjust for sampling freq
        [acc, gyro] = TimeAlign(time,acceldata,gyrodata);

        % Convert units from g --> m/s2 and deg/s --> rad/s
        acc = 9.8*acc;
        gyro = pi/180*gyro;

        % Rotate accelerometer Data (x-ML y-AP z-EarthVertical)
        [acc_aligned, gyro_aligned] = GravityAligned(acc, gyro,sensorpositionplot);
        %%

        % Get Trial Times
        Times = GetTrialTimes(timestamps,buffer(cond,sub),cond);


        % Make plot to find buffer
        if findbuffers == 1
            figure();
            clf(1);
            hold on
            plot(time,gyro_aligned(:,1)); %acc_aligned(:,3)
            scatter(Times+repmat(trunc',numtrials,1),mean(gyro(:,1),'omitnan')*...
                ones(length(Times),1)); % acc_aligned(:,3)
            title(subject_str)
            hold off
            % pause;
        end


%% sort trials to save 
    

trial_key = [file_path,'/',num2str(subject), '/A' , num2str(subject), '.mat'];
load(trial_key);

for trial =1:numtrials
    if trial<31
        Config =TrialInfo1(trial,4);
        Current =TrialInfo1(trial,5);
        Profile = strjoin(string(TrialInfo1(trial,7)));
    else
        Config= TrialInfo2(trial-30,4);
        Current =TrialInfo2(trial-30,5);
        Profile = strjoin(string(TrialInfo2(trial-30,7)));
    end


     %assign storage index value for each of our variables of
            %interest that we want to index by
            switch string(Config)
                case 'Binaural'
                    config_index = 1;
                case 'Cevette'
                    config_index = 2;
                case 'Aoyama'
                    config_index = 3;
                otherwise
                    config_index = 0; 
            end
            
            switch string(Current)
                case '0.1'
                    current_index = 1;
                case '0.5'
                    current_index = 2;
                case '1'
                    current_index = 3;
                case '1.5'
                    current_index = 4;
                case '2'
                    current_index = 5;
                case '2.5'
                    current_index = 6;
                case '3'
                    current_index = 7;
                case '3.5'
                    current_index = 8;
                case '4'
                    current_index = 9;
                otherwise
                    current_index = 0;
            end
    
           switch string(Profile)
               case 'front'
                    profile_index = 1;
                case 'right'
                    profile_index = 1;
               case 'back'
                    profile_index = 2;
               case 'left'
                    profile_index = 2;
                case '0.25'
                    profile_index = 3;
                case '0.5'
                    profile_index = 4;
                case '1'
                    profile_index = 5;
                otherwise
                    profile_index = 0;
            end
        %error checking
        if current_index == 0 || profile_index == 0 || config_index == 0
            continue
        end
    imu_data{current_index,profile_index,config_index} = ...
    [acc_aligned(floor(Times(trial*2-1)*100):ceil(Times(trial*2)*100),1:3) ...
    gyro_aligned(floor(Times(trial*2-1)*100):ceil(Times(trial*2)*100),1:3) ...
    time(floor(Times(trial*2-1)*100):ceil(Times(trial*2)*100))'];
    % imu_data{current_index,profile_index,config_index,:,4:6} = gyro(Times(trial*2-1):Times(trial*2),1:3);





end
    Label.IMUcell = ["AccX" "AccY" "AccZ" "Roll" "Pitch" "Yaw"];
    Label.IMU = ["Current"; "Config";"Profile"];
    Label.CurrentAmp = [0.1 , 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0];
    Label.Profile = ["front/right" "back/left" "sin 0.25Hz" "sin 0.5Hz" "sin 1Hz"];
    Label.Config = ["Binaural" "Cevete" "Aoyama"];


    %% Save file
    cd([file_path, '/' , subject_str]); %move to directory where file will be saved
    %add all variables that we want to save to a list must include space
    %between variable names 
    vars_2_save =  ['Label TrialInfo1 TrialInfo2 imu_data acc_aligned gyro_aligned' ...
        ' EndImpedance StartImpedance MaxCurrent MinCurrent Times']; 
    eval(['  save ' ['A', subject_str,'imu.mat '] vars_2_save ' vars_2_save']); %save file     
    cd(code_path) %return to code directory
    %clear saved variables to prevent them from affecting next subjects' data
    eval (['clear ' vars_2_save]) 

%%
% %%
%         % Get Modified Romberg Balance data from IMU for each trial
%         start_time = buffer(cond,sub); 
%         for trial = 1:numtrials
% 
%             s = Times(trial*2-1)+trunc(1); % trial start time
%             e = Times(trial*2)  +trunc(2); % trial end time
% 
%             % Get trial data
%             i1 = time>=s; i2 = time<=e;
%             trial_ind = i1.*i2;
%             trial_accel = acc_aligned(trial_ind==1,:);
%             trial_time = time(trial_ind==1);
% 
%             % Store state information
%             accel(sub,trial,cond).x = trial_accel(:,1);
%             accel(sub,trial,cond).y = trial_accel(:,2);
%             accel(sub,trial,cond).z = trial_accel(:,3);
%             vel(sub,trial,cond).x = ...
%                 cumtrapz(trial_time,trial_accel(:,1));
%             vel(sub,trial,cond).y = ...
%                 cumtrapz(trial_time,trial_accel(:,2));
%             vel(sub,trial,cond).z = ...
%                 cumtrapz(trial_time,trial_accel(:,3));
%             pos(sub,trial,cond).x = ...
%                 cumtrapz(trial_time,cumtrapz(trial_time,trial_accel(:,1)));
%             pos(sub,trial,cond).y = ...
%                 cumtrapz(trial_time,cumtrapz(trial_time,trial_accel(:,2)));
%             pos(sub,trial,cond).z = ...
%                 cumtrapz(trial_time,cumtrapz(trial_time,trial_accel(:,3)));
% 
%             % METRICS
%             rmsxy = rms([trial_accel(:,1), trial_accel(:,2)]);
%             p2pa = peak2peak(trial_accel);
%             %%% Acceleration metrics
%             % rms metrics
% %             rmsXYa(sub,trial,cond) = sqrt(1/2*(rmsxy(1)^2+rmsxy(2)^2));
%             rmsXYa(sub,trial,cond) = sqrt((rmsxy(1)^2+rmsxy(2)^2));
%             rmsXa(sub,trial,cond) = rmsxy(1);
%             rmsYa(sub,trial,cond) = rmsxy(2);
%             % peak-to-peak metrics
%             p2pXa(sub,trial,cond) = p2pa(1); 
%             p2pYa(sub,trial,cond) = p2pa(2); 
        % 
        % end
    end
end

% %% Choose Metric
% metrictype = 'rmsXYa';
% metricpick = 'median';
% 
% switch metrictype
%     case 'rmsXYa'
%         ax = [];
%         ax1 = [];
%         metric = rmsXYa;
%         ylab = 'XY-plane rms of acceleration';
%     case 'p2pXa'
%         ax = [];
%         ax1 = [];
%         metric = p2pXa;
%         ylab = 'X-p2p acceleration';
%     case 'p2pYa'
%         ax = [];
%         ax1 = [];
%         metric = p2pYa;
%         ylab = 'Y-p2p acceleration';
% end
% 
% switch metricpick
%     case 'median'
%         metric = median(metric(:,1:numtrials,:),2);
%         trial = 1;
%     case 'mean'
%         metric = mean(metric(:,1:numtrials,:),2);
%         trial = 1;
%     case 'min'
%         trial = 1;
%         for i = 1:numsub
%             for j = 1:length(conditions)
%                 metric(i,trial,j) = min(metric(i,1:numtrials,j));
%             end
%         end
%     case 'trial'
%         trial = 2; %specify trial of interest
% end

%% Do some stats
% Thinking ANOVA (3 levels to our categorical IV / have to pick our DV)
% With follow-up 2-tailed paired t-tests between levels
% AND effect size of each


% %% Comparison Plot
% bias = 0.1;
% color = turbo(numsub); 
% shapes = ["o";"p";"h";">";"<";"s";"d";"^";"v"];
% names = conditions;
% 
% % metric = metric - metric(:,:,1);
% 
% % Confidence Data 
% SEM = zeros(1,length(conditions),2);
% CI = zeros(length(conditions),2,2);
% for g = 1:2
%     subs = find(groups == g);
%     for c = 1:length(conditions)
%         ts = tinv([0.025  0.975],numsub-1);
%         SEM(c,g) = std(metric(subs,trial,c),'omitnan')/sqrt(length(subs)); 
%         CI(c,:,g) = mean(metric(subs,trial,c),'omitnan') + ts*SEM(c,g); 
%     end
% end
% colorbar = [0 0 1 0.6];
% colorbar_g = [0 0 1 0.6;1 0 0 0.6];
% color_g = colorbar_g(:,1:3);
% leg = {};
% count1 = 0; count2=count1;
% 
% % Plot
% figure;
% hold on
% % Data Points
% for sub = 1:numsub
% %     c = color(sub,:);
%     c = color_g(groups(sub),:);
%     if groups(sub) == 1
%         count1 = count1+1;
%         count = count1;
%     elseif groups(sub) == 2
%         count2 = count2+1;
%         count = count2;
%     end
%     alpha = 0.7;
%     ol = 'k';
%     scatter(1:length(conditions),reshape(metric(sub,trial,:),...
%         [1,length(conditions)]),100,c,...
%         'filled',shapes(count),'MarkerEdgeColor',ol,'MarkerFaceAlpha',alpha)
% end
% 
% for sub = 1:numsub
%      lc = [0.2 0.2 0.2,0.7];
%      plot(1:length(conditions),reshape(metric(sub,trial,:),...
%         [1,length(conditions)]),'linewidth',2,'color',lc);
% end
% 
% % Confidence Interval portion
% for g = 1:2
%     subs = find(groups == g);
%     for c = 1:length(conditions)
%         plot([c+bias,c+bias],CI(c,:,g),'Color',colorbar_g(g,:),...
%             'linewidth',5)
%         if c < length(conditions)
%             plot([c+bias,c+1+bias],[mean(metric(subs,trial,c),'omitnan'),...
%                 mean(metric(subs,trial,c+1),'omitnan')],...
%                 'Color',colorbar_g(g,:),'linewidth',2)
%         end
%     end
% end
% 
% legend(string(subnum))
% hold off
% set(gca,'XTick',1:length(conditions),'xticklabel',names);
% set(gca,'FontSize',10)
% 
% % Makes figures nice for papers on Aaron's laptop
% x0=10; y0=10; width = 450/2; height=600/2;
% set(gcf,'position',[x0,y0,width,height])
% set(gca,'FontSize',10)
% ylabel(ylab)
% 
% 
% %% Plot XY acceleration / velocity / position tracking
% % Note: until the acceleration is filtered of noise, position will have
% % error quadratic to noise and make little sense
% sub = 9; %specify subject
% swaytype = accel; % accel | vel | pos
% 
% figure;
% hold on
% SwayColors =[[0.1 0.1 0.1 1];[1 0 0 0.4];[0 0 1 0.4]];
% for c = 1:length(conditions)
%     plot(swaytype(sub,trial,c).x,swaytype(sub,trial,c).y,...
%         'Color',SwayColors(c,:),'LineWidth',2)
% end
% xlabel('Acceleration in ML Direction (m/s^2)')
% ylabel('Acceleration in AP Direction (m/s^2)')
% legend(names)
% hold off



%% Functions
function [acc, gyro] = TimeAlign(time,acceldata,gyrodata)
    acc = interp1(acceldata.Var3,[acceldata.Var4, acceldata.Var5, ...
            acceldata.Var6],time);
    gyro = interp1(gyrodata.Var3,[gyrodata.Var4, gyrodata.Var5, ...
            gyrodata.Var6],time);
end


function Times = GetTrialTimes(timestamps,buffer,cond)
    
    if cond == 1
        TimeStamps = timestamps.Var3;
    elseif cond == 2
        TimeStamps = timestamps.Var5;
    elseif cond == 3
        TimeStamps = timestamps.Var8;
    else
        disp('Not programmed for 4 or more conditions!')
    end

    if isnan(TimeStamps(1))
            ts = 2; spot = 1;
    else
            ts = 1; spot = 0;
    end
    timeold = buffer;
    Times = zeros(length(TimeStamps)-1,1);
    for t = ts:length(TimeStamps)
        time = TimeStamps(t);
        Times(t-spot) = time+timeold;
        timeold = Times(t-spot);
    end
end

function  [acc_aligned,gyro_aligned] = GravityAligned(acc, gyro,sensorpositionplot)
    FUSE = imufilter('SampleRate',25);
    q = FUSE(acc,gyro); % goes from Inertial to Sensor
    Eulers = eulerd(q, 'ZYX', 'frame'); % sensor = Rx'*Ry'*Rz'*global

    acc_aligned = zeros(length(acc),3);
    for i = 1:length(acc)
        theta = Eulers(i,3);
        phi = Eulers(i,2);
        Rx = [1 0 0;0 cosd(theta) -sind(theta);...
              0 sind(theta) cosd(theta)];
        Ry = [cosd(phi) 0 sind(phi); 0 1 0;...
             -sind(phi) 0 cosd(phi)];

        % Excludes Rz to keep ML and AP aligned with x and y in the subject 
        % coordinated system vs. some fixed yaw inertial reference frame
        % yaw = -Eulers(i,1);
        % Rz = [cosd(yaw) -sind(phi) 0; 
        %       sind(yaw) cosd(yaw) 0; 0 0 1];
        acc_aligned(i,:) = (Ry*Rx*acc(i,:)')'; % Rz*Ry*Rx*sensor to go back
        gyro_aligned(i,:) = (Ry*Rx*gyro(i,:)')'; 
    end

    if sensorpositionplot == 1
        pp=poseplot;
        for ii=1:size(acc,1)
            qimu = FUSE(acc(ii,:), gyro(ii,:));
            set(pp, "Orientation", qimu)
            drawnow limitrate
            pause(0.05)
        end
    end
end