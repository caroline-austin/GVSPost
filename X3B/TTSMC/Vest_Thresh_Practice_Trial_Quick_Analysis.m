% clear all; close all; clc; 
format compact;
format long;

%% USER INPUT
multi_select = 0;  % 0 for one file and 1 for multiple files.
seperate_sessions = 0; % 0 for one session per file and 1 for two sessions per file
pool = 0; % 0 for don't pool all data together & 1 for pool all data together 

file_format = 'txt'; % options: 'xlsx', 'xls','csv', or 'txt'
 
data_origin = 'TTS'; % options: 'MEEI' or 'TTS'

% [file, path] = uigetfile({'*.csv'; '*.xls'; '*.xlsx'; '*.txt'},'Select all file(s) to be analyzed.','MultiSelect','on');
[file, path] = uigetfile({'*.txt'},'Select all file(s) to be analyzed.','MultiSelect','on');
    [rows,columns] = size(file);
    filename = fullfile(path, file);

tic

%% INITILIZATION 

f_p = []; n_p = []; thresh_p = []; cfthresh_p = []; SEMthresh_p = []; SEMcfthresh_p = []; SEMK_p = [];
f_r = []; n_r = []; thresh_r = []; cfthresh_r = []; SEMthresh_r = []; SEMcfthresh_r = []; SEMK_r = [];
output = [];

%% EXTRACTING DATA FROM FILES

if multi_select == 1
	counter_temp = columns;
	file = file';
else
    counter_temp = rows;
end    

for i = 1:counter_temp    
        
    filepath = strcat(path,file(i,:));
    filepath = char(filepath);
    
if strcmp(file_format, 'xls') ||  strcmp(file_format, 'xlsx')
	
    rawdata = xlsread(filepath); 

elseif strcmp(file_format, 'csv')
	
    rawdata = load(filepath); 
    
elseif strcmp(file_format, 'txt')
    
    fileID = fopen(filepath);
%     fileID = fopen(filepath(i,:));
    formatSpec = '%f %f %f %f';
    rawdata = textscan(fileID,formatSpec);
    fclose(fileID);
end

[r, c] = size(rawdata);
        

          

          
          if strcmp(data_origin, 'TTS') && strcmp(file_format, 'txt')
              % THIS IS WHAT WE ARE USING
              rawdata = cell2mat(rawdata);
              [r, c] = size(rawdata);
              
              data(i).ID = char(file(i,:));
              data(i).ID =  data(i).ID(1:end-4);
              data(i).N = r;  % extract trial numbers
              data(i).trials = rawdata(1:data(i).N,1); % extract trials 
              data(i).mag = abs(rawdata(1:data(i).N,2)); % stimulus magnitude, meters
              
              % Torin Fall 2020, added negative to account for left positive for translations!
              data(i).dir = -(rawdata(1:data(i).N,2))./(data(i).mag); % direction of stimulus, 
              data(i).conf = rawdata(1:data(i).N,4);  % percent confidence, 50 or 100% 
              data(i).Y = rawdata(1:data(i).N,3); % subject's perceived direction 1 if postiive, 0 if neg
              data(i).Yposneg = 2*data(i).Y-1; % subject's perceived direction: 1 if pos, -1 if negative
              data(i).X =  -rawdata(1:data(i).N,2)';  % stimulus level, meters
%               data(i).X =  (data(i).mag .* data(i).dir)';  % stimulus level, meters
              data(i).Ybi = [abs(data(i).Y - 1)'; data(i).Y'];          
                for j = 1:data(i).N
                  if data(i).dir(j) ==  data(i).Yposneg(j) 
                      data(i).corr(j,1) = 1; %correct
                  else
                      data(i).corr(j,1) = 0; %incorrect
                  end
              end
          end
end           

%% MANIPULATING DATA FORMAT AS PER USER INPUT

if pool == 0 
    counter = counter_temp;    
    if seperate_sessions == 1    
        j = 1;
        index_ns = [];
        for i = 1 : counter_temp * 2 
                if rem(i, 2) == 0

                    session = 'Session2';
                    index = index_ns(2) : 1 : data(j).N;

                elseif rem(i, 2) == 1

                    for k = 1:data(j).N
                        if data(j).trials(k) == 1
                            index_ns = [index_ns, k];
                        end                
                    end

                    session = 'Session1';
                    index = index_ns(1) : 1 : index_ns(2) - 1; 

                end
                    DATA(i).ID = [data(j).ID session];
                    DATA(i).trials = data(j).trials(index); % extract trial numbers
                    DATA(i).N = length(DATA(i).trials); % extract number of trials
                    DATA(i).mag = data(j).mag(index); % stimulus magnitude, degrees/sec
                    DATA(i).dir = data(j).dir(index); % direction of stimulus
                    DATA(i).Yposneg = data(j).Yposneg(index); % subject's perceived direction, 1 if positive, -1 if neg
                    DATA(i).corr = data(j).corr(index); % whether or not the subjects response was correct (1) or incorrect (0)
                    DATA(i).conf = data(j).conf(index);  % percet confidence, 50 or 100%
                    DATA(i).X  = data(j).X(index);  % stimulus level, degrees/sec
                    DATA(i).Y = data(j).Y(index); % subject's perceived direction 1 if postiive, 0 if neg
                    DATA(i).Ybi = data(j).Ybi(index);   

                if rem(i, 2) == 0
                    j = j + 1;
                    index_ns = [];
                end   
        end
            counter = counter_temp * 2;
        else
            DATA = data;  
    end    
elseif pool == 1   
    DATA.ID = []; DATA.trials = []; DATA.N = 0; DATA.mag = [];
    DATA.dir = []; DATA.Yposneg = []; DATA.corr = []; DATA.conf = [];
    DATA.X = []; DATA.Y = []; DATA.Ybi = [];
    
    for i = 1:counter_temp
        DATA.ID = [DATA.ID, data(i).ID];
        DATA.trials = [DATA.trials; data(i).trials]; % extract trial numbers
        DATA.N = DATA.N + data(i).N; % extract number of trials
        DATA.mag = [DATA.mag; data(i).mag]; % stimulus magnitude, degrees/sec
        DATA.dir = [DATA.dir; data(i).dir]; % direction of stimulus
        DATA.Yposneg = [DATA.Yposneg; data(i).Yposneg]; % subject's perceived direction, 1 if positive, -1 if neg
        DATA.corr = [DATA.corr; data(i).corr]; % whether or not the subjects response was correct (1) or incorrect (0)
        DATA.conf = [DATA.conf; data(i).conf];  % percet confidence, 50 or 100%
        DATA.X = [DATA.X, data(i).X];  % stimulus level, degrees/sec
        DATA.Y = [DATA.Y; data(i).Y]; % subject's perceived direction 1 if postiive, 0 if neg
        DATA.Ybi = [DATA.Ybi, data(i).Ybi];    
    end   
    counter = 1;   
end   
    
%% ANALYZING DATA FOR THRESHOLDS

for i = 1:counter

identity = DATA(i).ID; 
    
     subjectnumber = str2num(identity(1,1:2));
        if identity(1,4) == 'P'
            direction = 1; %pitch
        else
            direction = 0; %roll
        end
     stimulus = str2num(identity(1,5:end - 8));
     
     if seperate_sessions == 1   
        session = str2num(identity(1, end));
     else
        session = 1;
     end

n = DATA(i).N;
trials = 1:1:n;
tstim = DATA(i).mag; %magnitude
tstim_run = DATA(i).X; %magnitude and direction
tstim_dir = DATA(i).dir; %L or R motion
lor = DATA(i).Y; %subject response
cor = DATA(i).corr;  %whether response was correct or not
conf = DATA(i).conf;

%% SET-UP FOR FITTING THE DATA

plot_on = 1;    % do you want to plot at the end, 1=yes, 0=no
fit_on = 1;     % do you want to calculate the threshold at the end, 1=yes, 0=no
jackknife_on = 0;   % do you want to estimate the standard errors of the threshold using jackknife, 1=yes, 0=no
fit_meth = 'brglmfit'; 
% se_est_meth = 'jackknife'; %'jackknife' or 'none' or 'bootstrap'...
se_est_meth = 'none';
Wichmann_on = 0; % or activate with '1'
lapse_detect_on = 0;
    tol = 0.01; % the minimum acceptable probability of this trial occuring
    remove = 'justone'; % or 'many'
    bonferroni = 1;
    iterative = 10000; 

confidence_on = 1;
    conf_res = 0.01; % 1% resolution used with the tablet
    conf = round(conf); % round the raw confidence values to the nearest whole number
%     conf_res = 0.05;        % 5% resolution in the confidence reports     used with verbal reports
    conf_meth = '3param'; %'2param' or 'both'
%     conf_trials = [20]; % fit confidence threshold after each of these sets of trials

onebyone_on = 0; 
    onebyone_jk = 0; 
    tBt_bi_mean = 0;
    tBt_csd_mean = 0;
    tBt_bi_se = 0;
    tBt_csd_se = 0;

%% FIT THE DATA

if fit_on == 1    
    fit_info = Threshold_Analyzer_CSD(tstim_run', lor, conf, 0, ...
        fit_meth, se_est_meth, Wichmann_on, lapse_detect_on, tol, ...
        remove, iterative, bonferroni, confidence_on, conf_meth, ...
        conf_res, onebyone_on, onebyone_jk, tBt_bi_mean, tBt_csd_mean,...
        tBt_bi_se, tBt_csd_se);
    % turned off plot in this function with the "0" input because desired
    % plots are below 
end

if fit_on == 1
    if confidence_on == 1
        if exist('conf_trials')
            if ~isempty(conf_trials)
                display('fitting confidence thresholds with reduced trials')
                sigma_conf_trials = zeros(length(conf_trials),1);
                for c = 1:length(conf_trials)
                    fit_info_conf = Threshold_Analyzer_CSD(tstim_run(1:conf_trials(c))', lor(1:conf_trials(c)), conf(1:conf_trials(c)), 1, ...
                        fit_meth, se_est_meth, Wichmann_on, lapse_detect_on, tol, ...
                        remove, iterative, bonferroni, confidence_on, conf_meth, ...
                        conf_res, onebyone_on, onebyone_jk, tBt_bi_mean, tBt_csd_mean,...
                        tBt_bi_se, tBt_csd_se);
                    sigma_conf_trials(c) = fit_info_conf.sigma_hat_csd3;
                end
%                 figure; plot(conf_trials, sigma_conf_trials, 'o-')
%                 xlabel('number of trials'); ylabel('confidence threshold (meters)')
            end
        end
    end
end


%% ASSIGNING VARIABLES TO OUPUT 

mu_hat = fit_info.mu_hat;
sigma_hat = fit_info.sigma_hat;

% if strcmp(fit_meth, 'both')
%     fit_info.mu_hat_br = mu_hat_br;
%     fit_info.sigma_hat_br = sigma_hat_br;
% end

if Wichmann_on == 0 
    lambda_hat_Wich = fit_info.lambda_hat_Wich;
    mu_hat_Wich = fit_info.mu_hat_Wich;
    sigma_hat_Wich = fit_info.sigma_hat_Wich;
    lambda_se_Wich = fit_info.lambda_se_Wich;
    mu_se_Wich = fit_info.mu_se_Wich;
    sigma_se_Wich = fit_info.sigma_se_Wich;
else
    fprintf('Wrong combination -- Wichmann off.\n')
end 

% fit_info.mu_hat_csd2 = 0; fit_info.sigma_hat_csd2 = 0;
% fit_info.mu_hat_csd3 = 0; fit_info.sigma_hat_csd3 = 0; fit_info.sigma_hat_conf_csd3 = 0; fit_info.confscale_csd3 = 0;
if confidence_on == 1 
    respC = fit_info.respC;
    if  strcmp(conf_meth, '3param')
        mu_hat_csd3 = fit_info.mu_hat_csd3;
        sigma_hat_csd3 = fit_info.sigma_hat_csd3;
        sigma_hat_conf_csd3 = fit_info.sigma_hat_conf_csd3;
        confscale_csd3 = fit_info.confscale_csd3
        if confscale_csd3 > 1.1
            display(['so you are underconfident (on trials where you are saying 75% confident, you are actually getting about ', num2str(round(100*cdf('norm',icdf('norm',0.75,0,confscale_csd3),0,1))), '% correct)']);
        elseif confscale_csd3 < 0.9
            display(['so you are overconfident (on trials where you are saying 75% confident, you are actually about ', num2str(round(100*cdf('norm',icdf('norm',0.75,0,confscale_csd3),0,1))), '% correct)']);
        else
            display('so your confidence is pretty well calibrated') 
        end
    else
        fprintf('Wrong combination -- confidence method.\n')
    end 
else
    fprintf('Wrong combination -- confidence.\n')
end 

if strcmp(se_est_meth, 'jackknife')
    mu_se = fit_info.mu_se;
    sigma_se = fit_info.sigma_se;
    
%     if strcmp(fit_meth, 'both')
%         mu_se_br = fit_info.mu_se_br;
%         sigma_se_br = fit_info.sigma_se_br;
%     end
    
%     if Wichmann_on == 0
%         lambda_se_Wich = fit_info.lambda_se_Wich;
%         mu_se_Wich = fit_info.mu_se_Wich;
%         sigma_se_Wich = fit_info.sigma_se_Wich;
%     end
    
    if confidence_on == 1 
        if  strcmp(conf_meth, '3param')
            mu_se_csd3 = fit_info.mu_se_csd3;
            sigma_se_csd3 = fit_info.sigma_se_csd3;
            sigma_se_conf_csd3 = fit_info.sigma_se_conf_csd3;
            confscale_se_csd3 = fit_info.confscale_se_csd3;
        else
            fprintf('Wrong combination -- confidence method.\n')
        end 
    else
        fprintf('Wrong combination -- confidence on.\n')
    end 

else
    fprintf('Wrong combination -- standard error method.\n')
end 


if lapse_detect_on == 1
    mu_hat_LD = fit_info.mu_hat_LD;
    sigma_hat_LD = fit_info.sigma_hat_LD;
    included_trials = fit_info.included_trials;
    excluded_trials = fit_info.excluded_trials;
    if strcmp(se_est_meth, 'jackknife')
        mu_se_LD = fit_info.mu_se_LD;
        sigma_se_LD = fit_info.sigma_se_LD;
    else
        fprintf('Wrong combination -- standard error method.\n')
    end 
else
    fprintf('Wrong combination -- lapse detection.\n')
end 

% if onebyone_on == 1
%     sigma_hat_br_vect = fit_info.sigma_hat_br_vect;
%     sigma_hat_vect = fit_info.sigma_hat_vect;
%     sigma_hat_br_vect_se = fit_info.sigma_hat_br_vect_se;
%     sigma_hat_vect_se = fit_info.sigma_hat_vect_se;
%     sigma_hat_csd3_vect = fit_info.sigma_hat_csd3_vect;
%     sigma_hat_csd3_vect_se = fit_info.sigma_hat_csd3_vect_se;
% end


if confidence_on == 1 
        if strcmp(conf_meth, '3param')
            if ~strcmp(se_est_meth, 'none')
                mu_se_csd3 = fit_info.mu_se_csd3;
                sigma_se_csd3 = fit_info.sigma_se_csd3;
                sigma_se_conf_csd3 = fit_info.sigma_se_conf_csd3;
                confscale_se_csd3 = fit_info.confscale_se_csd3;
            end
        else
            fprintf('Wrong combination -- confidence method.\n')
        end  
end

%% PLOT DATA


% Plot the sequence of responses
if plot_on == 1 
    % Plot what was actually run
    ind_corr_pos = (cor == 1).*(sign(tstim_run) == 1)';
    ind_corr_neg = (cor == 1).*(sign(tstim_run) == -1)';
    ind_incorr_pos = (cor ~= 1).*(sign(tstim_run) == 1)';
    ind_incorr_neg = (cor ~= 1).*(sign(tstim_run) == -1)';
    
    ylimit = max([max(abs(tstim_run)) max(abs(tstim))]);
    
    INDEX_ind_corr_pos = find(ind_corr_pos ==1);
    INDEX_ind_corr_neg = find(ind_corr_neg ==1);
    INDEX_ind_incorr_pos = find(ind_incorr_pos ==1);
    INDEX_ind_incorr_neg = find(ind_incorr_neg ==1);
    
    h(1) = figure;
    subplot(2,1,1);
    hold on;
    plot(trials(INDEX_ind_corr_pos), abs(tstim_run(INDEX_ind_corr_pos)), 'ro', 'MarkerSize', 4)
    plot(trials(INDEX_ind_corr_neg), abs(tstim_run(INDEX_ind_corr_neg)), 'ko', 'MarkerSize', 4)
    plot(trials(INDEX_ind_incorr_pos), abs(tstim_run(INDEX_ind_incorr_pos)), 'rx', 'MarkerSize', 6)
    plot(trials(INDEX_ind_incorr_neg), abs(tstim_run(INDEX_ind_incorr_neg)), 'kx', 'MarkerSize', 6)
    xlabel('Trial Number');
    ylabel('Simulus Magnitude (meters)');
    ylim([0 ylimit]);
    title('Stimuli Run')
    box on;
    
    % Plot what we wanted to run
    ind_corr_pos = (cor == 1).*(sign(tstim) == 1)';
    ind_corr_neg = (cor == 1).*(sign(tstim) == -1)';
    ind_incorr_pos = (cor ~= 1).*(sign(tstim) == 1)';
    ind_incorr_neg = (cor ~= 1).*(sign(tstim) == -1)';
    
    % Average the Y outcomes at each unique X value
    [Xunique, ix, ixu] = unique(tstim_run);
    Punique = zeros(1,length(Xunique));
    Lunique = zeros(1,length(Xunique));
    for k = 1:length(Xunique)
        YatXunique = lor(ixu == k); % find the Y outcomes for the jth unique X value
        Lunique(k) = length(YatXunique);    % find the number of trials for the ith unique X value
        Punique(k) = mean(YatXunique);  % find the probability at the ith unique X value
    end
    
    
    subplot(2,1,2);
    hold on;
    X_vect = linspace(-ylimit, ylimit);
    prob_hat = cdf('norm', X_vect, mu_hat, sigma_hat);
    plot(X_vect, prob_hat, 'r', 'LineWidth', 2)
    
    prob_hat_csd3 = cdf('norm', X_vect, mu_hat_csd3, sigma_hat_csd3); % fitted psychometric curve
    plot(X_vect, prob_hat_csd3, 'Color', 0.5*[1 1 1], 'LineWidth', 2)
    
    if confidence_on 
        if conf_meth == '3param'
            prob_hat_conf_csd3 = cdf('norm', X_vect, mu_hat_csd3, sigma_hat_conf_csd3); % fitting confidence curve
            plot(X_vect, prob_hat_conf_csd3, 'k--')   
        else
            disp('Warning: wrong combination\n')
        end
    end
    
    plot(tstim_run, respC, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 1.5)

    if lapse_detect_on
        prob_hat_LD = cdf('norm', X_vect, mu_hat_LD, sigma_hat_LD);
        plot(X_vect, prob_hat_LD, 'k--', 'LineWidth', 2);
    end
    
    % plot the mean probabilities with the size of the marker representing the
    % number of trials
    for k = 1:length(Xunique)
        % find the marker size with a max of 12 and a min of 4
        if max(Lunique) == min(Lunique)
            msize = 8;
            
        else
            msize = (12-4)/(max(Lunique)-min(Lunique)) * (Lunique(k)-min(Lunique)) + 4;
        end
        plot(Xunique(k), Punique(k), 'ko', 'MarkerSize', msize);
    end
    
    legend('binary fit', 'csd fit', 'conf', 'conf responses', 'binary responses', 'ld','Location', 'SouthEast')
    xlabel('Stimulus (meters)'); ylabel('Likelihood of Rightward Response')
    box on;

%% CREATE DATA OUPUT

%saveas(h,fullfile(path, identity),'jpeg')
% close all;
% 
% OUTPUT = [subjectnumber, direction, session, stimulus, n,...
%     mu_hat, sigma_hat, ...
%     mu_se, sigma_se, ...
%     mu_hat_csd3, sigma_hat_csd3, confscale_csd3, ...
%     mu_se_csd3, sigma_se_csd3, confscale_se_csd3, ...  
%     mu_hat_LD, sigma_hat_LD, ...
%     mu_se_LD, sigma_se_LD]; 
% 
% output = [output; OUTPUT];

% fprintf('Completed analysis of Subject %1.0f in %1.0f Tilt at %1.0f Hz (Session %1.0f).\n', subjectnumber, direction, stimulus, session)
     
fprintf('Fitted binary threshold of %1.7f meters\n', sigma_hat)
fprintf('Fitted confidence threshold using all trials of %1.7f meters\n', sigma_hat_csd3)

if exist('conf_trials')
    if ~isempty(conf_trials)
        for c = 1:length(conf_trials)
            fprintf('Fitted confidence threshold using %2.0f trials of %1.7f meters\n', conf_trials(c), sigma_conf_trials(c))
        end
    end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Save Thresholds Data.
Thresholds(i).ID=char(file(i,:));
  Thresholds(i).ID=Thresholds(i).ID(1:end-4);
Thresholds(i).Binary_Threshold=sigma_hat*100; % *100 = threshold value in cm.
Thresholds(i).Confidence_Threshold_All_Trials=sigma_hat_csd3*100; % *100 = threshold value in cm.
% Thresholds(i).Confidence_Threshold_50_Trials=sigma_conf_trials(4)*100; % *100 = threshold value in cm.
% Thresholds(i).Confidence_Threshold_40_Trials=sigma_conf_trials(3)*100; % *100 = threshold value in cm.
% Thresholds(i).Confidence_Threshold_30_Trials=sigma_conf_trials(2)*100; % *100 = threshold value in cm.
% Thresholds(i).Confidence_Threshold_20_Trials=sigma_conf_trials(1)*100; % *100 = threshold value in cm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%xlswrite(fullfile(path, 'Raw Data'),output)

% load gong.mat;
% sound(y)

toc