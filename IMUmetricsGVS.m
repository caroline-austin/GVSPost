%% Mbientlab IMU Balance Analysis
% Created by: Aaron Allred
% Modified by: Caroline Austin
% Date: 10/8/2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMU data in the form of 'SubjectNumber-Condition-datatype.csv'
% Time stamps in the form of 'SubjectNumber-Romberg-TimeStamps.xlsx'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;
restoredefaultpath;

%% Experimental Methods Specifications
sub_dir = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from
code_path = pwd;
conditions = {'A'}; % right now ideally just one condition, might have an exp. A and B
datatype = {'Accelerometer','Gyroscope'};

numtrials = 60; % this number will vary, should not exceed 60
subnum = 2001:2002;  % Subject List 
groups = [1]; % 1:Control 2:VisualCM % I don't have groups yet so I'll just set them all as the same for now
subskip = [2001 2004 2006 2008 2010];  %DNF'd subjects

% additional start buffer for IMU data (sec.) row = cond.; col = subject
buffer = [0 10 18.24 0 14.08 0 10.08 0 35.04 0;...
          0 0 0 0 0 0 0 0 0 0;...
          0 0 0 0 0 0 0 0 0 0]; %(19.72-5.38)

% seconds to truncate off each trial [start, end] 
trunc = [0.1 -0.1]; %seconds 

% Used to find buffer time for timed trial arrays
findbuffers = 0; % 1 is on other num is off
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
angle(numsub,numtrials,length(conditions)).x = 0;
angle(numsub,numtrials,length(conditions)).y = 0;
angle(numsub,numtrials,length(conditions)).z = 0;

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
    end
    for cond = 1:length(conditions)

        % Get File names
        accelfile = [sub_dir,'/',num2str(subject),'/',...
            num2str(subject),'-',conditions{cond},'-',...
            datatype{1},'.csv'];

        gyrofile = [sub_dir,'/',num2str(subject),'/',...
            num2str(subject),'-',conditions{cond},'-',...
            datatype{2},'.csv'];

        timestampfile = [sub_dir,'/',num2str(subject),'/',...
            num2str(subject),'-All-TimeStamps.xlsx'];
        
        if isfile(accelfile)==0
            continue
        end

        % Read in raw data
        acceldata = readtable(accelfile,'ReadVariableNames',false);
        gyrodata = readtable(gyrofile,'ReadVariableNames',false);
        timestamps = readtable(timestampfile,'ReadVariableNames',false);%,'Sheet','Sheet2');
  
        % Ensure data aligns across measurement types
        time = 1/25:1/25:max(acceldata.Var3); % create aligned time vec %adjust for sampling freq
%         time = 0.5:0.5:max(acceldata.Var3); % create aligned time vec %adjust for sampling freq
        [acc, gyro] = TimeAlign(time,acceldata,gyrodata);

        % Convert units from g --> m/s2 and deg/s --> rad/s
        acc = 9.8*acc;
        gyro = pi/180*gyro;

        % Rotate accelerometer Data (x-ML y-AP z-EarthVertical)
        tic
        [acc_aligned, gyro_aligned, yaw_aligned, pitch_aligned, roll_aligned] = ... 
            GravityAligned(acc(:,:), gyro(:,:),sensorpositionplot);
        toc


        % Get Trial Times
        Times = GetTrialTimes(timestamps,buffer(cond,sub),cond);

        % Make plot to find buffer
        if findbuffers == 1
            figure(1);
            clf(1);
            hold on
            plot(time,gyro_aligned(:,1));
            plot(time,gyro_aligned(:,2));
            plot(time,gyro_aligned(:,3));
            scatter(Times+repmat(trunc',numtrials,1),mean(gyro_aligned(:,3))*...
                ones(length(Times),1))
            hold off
            disp('press any key to continue')
            pause;
            
        end

        % Get Modified Romberg Balance data from IMU for each trial
        start_time = buffer(cond,sub); 
        for trial = 1:numtrials

            s = Times(trial*2-1)+trunc(1); % trial start time
            e = Times(trial*2)  +trunc(2); % trial end time
            if s > e
                continue
            end
            % Get trial data
            i1 = time>=s; i2 = time<=e;
            trial_ind = i1.*i2;
            trial_accel = acc_aligned(trial_ind==1,:);
            trial_roll = roll_aligned(trial_ind==1);
            trial_pitch = pitch_aligned(trial_ind ==1);
            trial_yaw = yaw_aligned(trial_ind==1);
            trial_time = time(trial_ind==1);
    
            % Store state information
            accel(sub,trial,cond).x = trial_accel(:,1);
            accel(sub,trial,cond).y = trial_accel(:,2);
            accel(sub,trial,cond).z = trial_accel(:,3);
            vel(sub,trial,cond).x = ...
                cumtrapz(trial_time,trial_accel(:,1));
            vel(sub,trial,cond).y = ...
                cumtrapz(trial_time,trial_accel(:,2));
            vel(sub,trial,cond).z = ...
                cumtrapz(trial_time,trial_accel(:,3));
            pos(sub,trial,cond).x = ...
                cumtrapz(trial_time,cumtrapz(trial_time,trial_accel(:,1)));
            pos(sub,trial,cond).y = ...
                cumtrapz(trial_time,cumtrapz(trial_time,trial_accel(:,2)));
            pos(sub,trial,cond).z = ...
                cumtrapz(trial_time,cumtrapz(trial_time,trial_accel(:,3)));
            angle(sub,trial,cond).x = trial_roll;
            angle(sub,trial,cond).y = trial_pitch;
            angle(sub,trial,cond).z = trial_yaw;
            % METRICS
            rmsxy = rms([trial_accel(:,1), trial_accel(:,2)]);
            p2pa = peak2peak(trial_accel);
            %%% Acceleration metrics
            % rms metrics
%             rmsXYa(sub,trial,cond) = sqrt(1/2*(rmsxy(1)^2+rmsxy(2)^2));
            rmsXYa(sub,trial,cond) = sqrt((rmsxy(1)^2+rmsxy(2)^2));
            rmsXa(sub,trial,cond) = rmsxy(1);
            rmsYa(sub,trial,cond) = rmsxy(2);
            % peak-to-peak metrics
            p2pXa(sub,trial,cond) = p2pa(1); 
            p2pYa(sub,trial,cond) = p2pa(2); 

        end
    end

        cd([sub_dir, '/' , subject_str]);
        vars_2_save = ['acc_aligned gyro_aligned Times yaw_aligned pitch_aligned ' ...
            'roll_aligned angle accel vel pos']; %rmsXYa rmsXa rmsYa p2pXa p2pYa buffer'
        eval(['  save ' ['A', subject_str,'_IMU.mat '] vars_2_save ' vars_2_save']);      
        cd(code_path)
        eval (['clear ' vars_2_save])

end
        
%% Choose Metric
metrictype = 'rmsXYa';
metricpick = 'median';

switch metrictype
    case 'rmsXYa'
        ax = [];
        ax1 = [];
        metric = rmsXYa;
        ylab = 'XY-plane rms of acceleration';
    case 'p2pXa'
        ax = [];
        ax1 = [];
        metric = p2pXa;
        ylab = 'X-p2p acceleration';
    case 'p2pYa'
        ax = [];
        ax1 = [];
        metric = p2pYa;
        ylab = 'Y-p2p acceleration';
end

switch metricpick
    case 'median'
        metric = median(metric(:,1:numtrials,:),2);
        trial = 1;
    case 'mean'
        metric = mean(metric(:,1:numtrials,:),2);
        trial = 1;
    case 'min'
        trial = 1;
        for i = 1:numsub
            for j = 1:length(conditions)
                metric(i,trial,j) = min(metric(i,1:numtrials,j));
            end
        end
    case 'trial'
        trial = 2; %specify trial of interest
end
cd([sub_dir]);
vars_2_save = ['acc_aligned gyro_aligned Times yaw_aligned pitch_aligned ' ...
    'roll_aligned angle accel vel pos rmsXYa rmsXa rmsYa p2pXa p2pYa buffer']; %'
eval(['  save ' ['All_IMU.mat '] vars_2_save ' vars_2_save']);      
cd(code_path)
eval (['clear ' vars_2_save])
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
%     elseif cond == 2
%         TimeStamps = timestamps.Var5;
%     elseif cond == 3
%         TimeStamps = timestamps.Var8;
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

function  [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc, gyro,sensorpositionplot)
    FUSE = imufilter('SampleRate',25);
    q = FUSE(acc,gyro); % goes from Inertial to Sensor
    Eulers = eulerd(q, 'ZYX', 'frame'); % sensor = Rx'*Ry'*Rz'*global
    [yaw, pitch, roll] = quat2angle(q);

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
        gyro_aligned(i,:) = (Ry*Rx*gyro(i,:)')'; % Rz*Ry*Rx*sensor to go back
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