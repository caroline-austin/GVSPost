% Fit KGVS to individual participants using Pitch Data
% refactor: cache interpolants to avoid rebuilding inside hot loop
clc; clear; close all;

addpath('../PerceptionData/CarolineData/')
addpath('../Training/')
% typically in ../Training/
load("ModelResultsTest.mat","Results","GVS_range"); 

% Evaluate and Save parameters
name = 'SubjectFits.mat';
subjects = 1:22;          % s

% Define study elements
motions = ["4","5","6"];
dirs = ["A","B"];
conditions = [2 6];    % as in your pasted version

lm = length(motions);
ld = length(dirs);
lc = length(conditions);

g = length(GVS_range);
N = lm*ld*lc;              % total trials

% Precompute mapping idx -> labels (numeric indices + labels)
idx_vec = (1:N)';
m_idx = floor((idx_vec-1)/(ld*lc)) + 1;   % motion index
c_idx = rem(idx_vec-1, lc) + 1;          % condition index
qd   = floor((idx_vec - c_idx) / lc) + 1;
d_idx = rem(qd-1, 2) + 1;

motions_idx = motions(m_idx);
dirs_idx    = dirs(d_idx);
conds_idx   = conditions(c_idx);

%% Precompute observer interpolants F_dyn (depends only on Results)
% F_dyn is a g-by-N cell of griddedInterpolant or empty if bad

F_dyn = cell(g, N);
for j = 1:g
    for idx = 1:N
        R = Results{j, idx};
        
        % shift to align model with perceptions
        ts = R(:,1) - 0.22;                  
        keep = ts >= 0;
        ts = ts(keep);
        tilt_est = R(keep,2);

        % create interpolant once for each KGVS grid point x Trial
        F_dyn{j,idx} = griddedInterpolant(ts, tilt_est, ...
            'linear', 'nearest');
    end
end

%% Loop Through Subjects
Gain_sub = NaN(length(subjects),1);

for subIdx = 1:length(subjects)
    i = subjects(subIdx);

    % Per-subject: pull all trials once, build F_p and costtime
    F_p = cell(1,N);
    costtime_cell = cell(1,N);
    validTrial = false(1,N);

    for tidx = 1:N
        motion = motions_idx(tidx);
        dir = dirs_idx(tidx);
        condition = conds_idx(tidx);

        % Pull subject Perceptions for this GVS trial
        [study_time, motiondata, perceptions, current] = ...
        PullSubject(motion,dir,condition,i);

        % If study trial is empty (or data is all nan), skip invalid trial
        if isempty(study_time) || sum(perceptions,'omitmissing')==0
            F_p{tidx} = [];
            costtime_cell{tidx} = [];
            continue
        end

        % Create a cost time (only evals cost on GVS 'on' portion of trial)
        costtime = study_time(study_time>=1 ...
            & study_time <= (study_time(end)-1));

        % build griddedInterpolant for subject perceptions (once)
        F_p{tidx} = griddedInterpolant(study_time, perceptions, ...
            'linear', 'nearest');
        costtime_cell{tidx} = costtime;
        validTrial(tidx) = true;
    end

    % Evaluate per KGVS grid point using cached interpolants
    J_sub = zeros(g,1);
    for j = 1:g
        for tidx = 1:N
            if ~validTrial(tidx)
                continue
            end

            % evaluate (fast)
            costtime = costtime_cell{tidx};
            dynmodel = F_dyn{j,tidx}(costtime);
            p = F_p{tidx}(costtime);

            % compute cost (mean squared error); robust to NaNs
            cost = mean((p - dynmodel).^2,'omitnan');

            J_sub(j) = J_sub(j) + cost;
           
        end

        % progress print for long runs
        if mod(j,10)==0 || j==g
            fprintf('Subject %d: finished GVS %d of %d\n', i, j, g);
        end
    end

    % Smooth out cost function (somewhat noisy)
    J_sub_smooth = movmean(J_sub, 50);  % 5-point moving average

    % Plot the OG and smooth curves
    figure; hold on;
    plot(GVS_range,J_sub);plot(GVS_range,J_sub_smooth);hold off;
    title(sprintf('Subject %d: J\_sub', i)); drawnow;
    J_sub = J_sub_smooth; % overwrite

    % If no data (all zeros or non-finite), set NaN; otherwise pick min
    if all(J_sub == 0) || ~any(isfinite(J_sub))
        Gain_sub(subIdx) = NaN;
    else
        % choose last occurrence of minimum (matches prior behavior)
        mn = min(J_sub(isfinite(J_sub)));
        oo = find(J_sub == mn);
        Gain_sub(subIdx) = GVS_range(oo(end));
    end

    fprintf('Completed subject %d\n', i);
end

save(name, 'Gain_sub');

%% Pretty histogram with overlays
distribution = Gain_sub;
rollVal = 0.0245;
colors;

figure; hold on;

% Analyze distribution
dist_mean = mean(distribution,'omitmissing');
dist_std  = std(distribution);
ci95 = prctile(distribution,[2.5 97.5]); % 95% CI

% 1. Histogram (normalized to probability density)
h = histogram(distribution, 5, 'Normalization','pdf', ...
    'FaceColor', blueseq(30,:), 'FaceAlpha', 0.4, ...
    'EdgeColor','none', 'DisplayName','Bootstrap Distribution');

% 2. Kernel density line (for smoothness, optional)
[f, xi] = ksdensity(distribution, 'Bandwidth', 0.05);
plot(xi, f, 'Color', blueseq(60,:), 'LineWidth', 2, ...
    'DisplayName','KDE Smooth');

% 3. Overlay mean
yl = ylim;
meanLine = plot([dist_mean dist_mean], yl, 'Color', blueseq(30,:), ...
    'LineWidth', 2.5, 'DisplayName','Mean');

% 4. Overlay roll line (red)
rollLine = plot([rollVal rollVal], yl, 'Color', redseq(30,:), ...
    'LineWidth', 2.5, 'DisplayName','Roll Value');

% 5. Overlay 95% CI (black dashed)
ciLine1 = plot([ci95(1) ci95(1)], yl, 'k--', 'LineWidth', 2,...
    'DisplayName','95% CI');
ciLine2 = plot([ci95(2) ci95(2)], yl, 'k--', 'LineWidth', 2);

% 6. Highlight mean with a circle
scatter(dist_mean, 0, 80, blueseq(60,:), 'filled', 'MarkerEdgeColor','k');

% 7. Styling
xlabel('Estimated KGVS in Pitch', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Density', 'FontSize', 14, 'FontWeight', 'bold');
grid on; box on;
set(gca,'FontSize',13,'LineWidth',1.2,'TickDir','out', ...
    'XColor',[0.2 0.2 0.2],'YColor',[0.2 0.2 0.2]);

% 8. Legend
legend([h, meanLine, rollLine, ciLine1], 'Location','best');