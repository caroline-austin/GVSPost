%% KGVS Fit with Jackknife, Smoothed J_sub, Safe Condition Skipping
% 9/19/2025 - ARA
clc; clear;
colors;

addpath('../PerceptionData/CarolineData/')
addpath('../Training/')
% this is where the pre-run data is saved on Caroline's computer 
addpath('C:\Users\caroa\OneDrive - UCB-O365\Research\Testing\X2D_Data') 

% Load precomputed observer results
load("ModelResultsFine.mat","Results","GVS_range","Post_range"); 
G = length(GVS_range);
P = length(Post_range);

% Run parameters
name = 'SubjectFits_JackknifeFine.mat';
subjects = 1:22;
conditions_use = [1 2 5 6];  % subset of conditions to evaluate

% Trial elements in the study
motions = ["4","5","6"];
dirs = ["A","B"];
conditions_all = [1 2 5 6];  % original order of Results

lm = length(motions);
ld = length(dirs);
lc_all = length(conditions_all);

g = length(GVS_range);
N = lm*ld*lc_all;  % total trials in Results

%% Precompute trial mapping based on full Results
idx_vec = (1:N)';
m_idx = floor((idx_vec-1)/(ld*lc_all)) + 1;   
c_idx = rem(idx_vec-1, lc_all) + 1;          
qd   = floor((idx_vec - c_idx) / lc_all) + 1;
d_idx = rem(qd-1, 2) + 1;

motions_idx = motions(m_idx);
dirs_idx    = dirs(d_idx);
conds_idx_all = conditions_all(c_idx);  % full mapping

% Determine which trial indices to use based on subset
useTrial = ismember(conds_idx_all, conditions_use);
trialIdxs_use = find(useTrial);

%% Precompute observer interpolants F_dyn
target_Post = 1.37;   % example
[~, p_idx] = min(abs(Post_range - target_Post)); % find nearest index

F_dyn = cell(g, N);
for g = 1:G
    for idx = 1:N
        R = Results{(p_idx-1)*G + g, idx};
        ts = R(:,1) - 0.22;                  
        keep = ts >= 0;
        ts = ts(keep);
        tilt_est = R(keep,2);
        F_dyn{g,idx} = griddedInterpolant(ts, tilt_est, 'linear', 'nearest');
    end
end

%% Loop through subjects: fit gain, jackknife, variance
Gain_sub = NaN(length(subjects),1);
SE_sub   = NaN(length(subjects),1);
Gain_jack = NaN(length(subjects), length(trialIdxs_use));

for subIdx = 1:length(subjects)
    i = subjects(subIdx);
    

    %%% Cache subject interpolants
    F_p = cell(1,N);
    costtime_cell = cell(1,N);
    validTrial = false(1,N);

    for tidx = trialIdxs_use  % only evaluate desired conditions
        motion = motions_idx(tidx);
        dir = dirs_idx(tidx);
        condition = conds_idx_all(tidx);

        [study_time, ~, perceptions, ~] = PullSubject(motion, dir, condition, i);

        if isempty(study_time) || sum(perceptions,'omitnan')==0
            F_p{tidx} = [];
            costtime_cell{tidx} = [];
            continue
        end

        ct = study_time(study_time>=1 & study_time <= (study_time(end)-1));

        % Save interpolants and pulled values
        F_p{tidx} = griddedInterpolant(study_time, perceptions, 'linear', 'nearest');
        costtime_cell{tidx} = ct;
        validTrial(tidx) = true;
    end

    trialIdxs = trialIdxs_use(validTrial(trialIdxs_use));
    if isempty(trialIdxs)
        fprintf('Subject %d: no valid trials, skipping\n', i);
        Gain_sub(subIdx) = NaN;
        SE_sub(subIdx) = NaN;
        continue
    else
        fprintf('Subject %d: %d valid trials\n', i, numel(trialIdxs));
    end

    %%% Full-subject gain
    J_sub = zeros(g,1);
    for j = 1:g
        for tidx = trialIdxs
            dynmodel = F_dyn{j,tidx}(costtime_cell{tidx});
            p = F_p{tidx}(costtime_cell{tidx});
            J_sub(j) = J_sub(j) + mean((p - dynmodel).^2,'omitnan');
        end
    end

    % Smooth the cost curve
    J_sub_smooth = smooth(GVS_range,J_sub, 0.5, 'loess');

    % Plot smoothed J_sub
    figure; hold on;
    plot(GVS_range, J_sub, 'Color',[0.7 0.7 0.7],'LineWidth',2);
    plot(GVS_range, J_sub_smooth, 'Color', purple,'LineWidth',2);
    title(sprintf('Subject %d: Cost Function J_{sub}', i));
    xlabel('GVS'); ylabel('Cost'); grid on; drawnow;

    % Select minimum
    if all(J_sub_smooth==0) || ~any(isfinite(J_sub_smooth))
        Gain_sub(subIdx) = NaN;
    else
        mn = min(J_sub_smooth(isfinite(J_sub_smooth)));
        oo = find(J_sub_smooth == mn);
        Gain_sub(subIdx) = mean(GVS_range(oo));
    end

    %%% Jackknife leave-one-out per trial
    for t = 1:length(trialIdxs)
        sampleIdx = trialIdxs;
        sampleIdx(t) = [];
        J_jack = zeros(g,1);
        for j = 1:g
            for tidx = sampleIdx
                dynmodel = F_dyn{j,tidx}(costtime_cell{tidx});
                p = F_p{tidx}(costtime_cell{tidx});
                J_jack(j) = J_jack(j) + mean((p - dynmodel).^2,'omitnan');
            end
        end
        J_jack_smooth = movmean(J_jack,1);
        [~, oo] = min(J_jack_smooth);
        Gain_jack(subIdx, t) = GVS_range(oo(end));
    end

    % Compute jackknife SE
    theta_jack = Gain_jack(subIdx,1:length(trialIdxs));
    valid = isfinite(theta_jack);
    theta_bar = mean(theta_jack(valid),'omitnan');
    SE_sub(subIdx) = sqrt((sum(valid)-1)/sum(valid) * sum((theta_jack(valid) - theta_bar).^2));

    fprintf('Completed subject %d\n', i);
end

save(name,'Gain_sub','Gain_jack','SE_sub');

%% Histogram + KDE of all subjects
distribution = Gain_sub(~isnan(Gain_sub));
rollVal = 0.0245; % optional reference line

figure; hold on;

% Compute stats
dist_mean = mean(distribution,'omitmissing');
ci95 = prctile(distribution,[2.5 97.5]); % 95% CI

% Histogram
h = histogram(distribution, 5, 'Normalization','pdf', ...
    'FaceColor', blueseq(30,:), 'FaceAlpha', 0.4, ...
    'EdgeColor','none', 'DisplayName','Gain Distribution');

% KDE
[f, xi] = ksdensity(distribution, 'Bandwidth', 0.05);
plot(xi, f, 'Color', blueseq(60,:), 'LineWidth', 2, 'DisplayName','KDE Smooth');

% Overlay mean
yl = ylim;
meanLine = plot([dist_mean dist_mean], yl, 'Color', blueseq(30,:), ...
    'LineWidth', 2.5, 'DisplayName','Mean');

% Overlay roll value
rollLine = plot([rollVal rollVal], yl, 'Color', redseq(30,:), ...
    'LineWidth', 2.5, 'DisplayName','Roll Value');

% Overlay 95% CI
ciLine1 = plot([ci95(1) ci95(1)], yl, 'k--', 'LineWidth', 2, 'DisplayName','95% CI');
ciLine2 = plot([ci95(2) ci95(2)], yl, 'k--', 'LineWidth', 2);

% Highlight mean
scatter(dist_mean, 0, 80, blueseq(60,:), 'filled', 'MarkerEdgeColor','k');

xlabel('Estimated KGVS in Pitch', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Density', 'FontSize', 14, 'FontWeight', 'bold');
grid on; box on;
set(gca,'FontSize',13,'LineWidth',1.2,'TickDir','out', ...
    'XColor',[0.2 0.2 0.2],'YColor',[0.2 0.2 0.2]);
legend([h, meanLine, rollLine, ciLine1], 'Location','best');

%% Per-subject ± Jackknife SE
figure; hold on;
for subIdx = 1:length(subjects)
    y = Gain_sub(subIdx);
    se = SE_sub(subIdx);
    if ~isnan(y)
        errorbar(subIdx, y, se, 'o','MarkerFaceColor',[0.2 0.6 0.9], ...
        'MarkerEdgeColor','k','LineWidth',1.5);
    end
end
xlim([0 length(subjects)+1]);
ylim([-0.5 0.5])
xlabel('Subject'); ylabel('Estimated KGVS in Pitch');
title('Per-Subject KGVS ± Jackknife SE');
grid on; box on;
set(gca,'FontSize',13,'LineWidth',1.2,'XTick',1:length(subjects));
