% 9/14/2025
% Bootstrap KGVS estimates (fast version)

clc;clear;close all;
addpath('../Observer/')
addpath('../PerceptionData/CarolineData/')

name = "Bootstrap_Results.mat";

% Initialize
MS_Params = [6.7175   11.7004  561.9546...
    91.2858    0.0001    0.3226  483.2565   73.7873];

GVS_range = -0.15:0.0005:0.1;
Ratio_range = 0;
B = 10000;  % bootstrap replicates 

loadprior = 1;
if loadprior == 1
    Prior = load("ModelResultsWide.mat");
    Results = Prior.Results;
    GVS_range = Prior.GVS_range;
end

motions    = ["4","5","6"];
dirs       = ["A","B"];
conditions = [1 2 4 5];

lm = length(motions);
ld = length(dirs);
lc = length(conditions);

g = length(GVS_range);
r = length(Ratio_range);

N = lm*ld*lc;  % total number of trials

%% Precompute trial data (so bootstrap only resamples)
TrialData = cell(N,1);

for idx = 1:N
    mr = rem(idx-1,ld*lc)+1;
    m = (idx-mr)/(ld*lc)+1;
    c = rem(idx-1,lc)+1;
    qd = (idx-c)/(lc)+1;
    d = rem(qd-1,ld)+1;

    motion    = motions(m);
    dir       = dirs(d);
    condition = conditions(c);

    [model_time, motiondata, perceptions, current] = ...
        PullDataAngleAndOpt(motion,dir,condition);

    model_motion = [0 0 0 0 0 0].*zeros(length(model_time),1);
    model_motion(:,5) = motiondata(:,3);
    Glevel = [0 0 -1].*ones(length(model_time),1);

    TrialData{idx}.time        = model_time;
    TrialData{idx}.perceptions = perceptions;
    TrialData{idx}.current     = current;
    TrialData{idx}.motion      = model_motion;
    TrialData{idx}.Glevel      = Glevel;
end

%% Bootstrap resample routine
% Progress monitor
dq = parallel.pool.DataQueue;
afterEach(dq,@(x) fprintf('Bootstrap replicate %d / %d complete\n',x,B));

boot_est = zeros(B,1);

parfor b = 1:B
    J_dyn = zeros(g,1);

    % resample indices
    sample_idx = randsample(N,N,true);

    for j = 1:g
        GVS_Params = [GVS_range(j) Ratio_range];
        J_tmp = 0;

        for k = 1:N
            idx = sample_idx(k);
            td  = TrialData{idx};

            if loadprior == 1
                ts       = Results{j,idx}(:,1);
                tilt_est = Results{j,idx}(:,2);
            else
                [ts, ~,~,~,g_est,~,~,~,~,~] = Observer_Analysis(...
                    td.time, td.motion, MS_Params, td.Glevel,...
                    0,2,td.current,GVS_Params);

                tilt_est = atan2d(g_est(:,1), ...
                    sqrt(g_est(:,2).^2 + g_est(:,3).^2));
                ts = ts-0.22;
                tilt_est = tilt_est(ts>=0);
                ts = ts(ts>=0);
            end

            % cutoff first and last second
            costtime = td.time(td.time>=1);
            costtime = costtime(costtime<=(costtime(end)-1));

            dynmodel = interp1(ts,tilt_est,costtime);
            p = interp1(td.time,td.perceptions,costtime);

            J_tmp = J_tmp + sum((p-dynmodel).^2)/length(dynmodel);
        end

        J_dyn(j) = J_tmp / N;  % average over bootstrap sample
    end

    [~,min_idx] = min(J_dyn);
    boot_est(b) = GVS_range(min_idx);

    send(dq,b);   % notify progress
end

save(name,"boot_est")

%% Analyze bootstrap distribution
boot_mean = mean(boot_est);
boot_std  = std(boot_est);
ci95 = prctile(boot_est,[2.5 97.5]);

save(name,"boot_est","boot_mean","boot_std","ci95")

%% smooth violin plot with legend and t-tests
colors; % your colormap definitions
figure; hold on;

% 1. Kernel density estimate (smoothed)
[f, xi] = ksdensity(boot_est, 'Bandwidth', 0.01);  % smoother violin

% Scale density for violin width
f = f / max(f) * 0.2;   % adjust width

% 2. Draw a smooth violin with elegant fill
violinFill = fill([xi fliplr(xi)], [f -fliplr(f)], blueseq(30,:), ...
    'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName','Bootstrap Distribution');

% 3. Scatter individual points with subtle jitter
nPoints = length(boot_est);
yScatter = (rand(nPoints,1)-0.5)*0.03;  % jitter
scatter(boot_est, yScatter, 15, [0.1 0.1 0.1], 'filled', ...
    'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.4, 'DisplayName','Samples');

% 4. Overlay mean (thick blue line)
yl = ylim;
meanLine = plot([boot_mean boot_mean], yl, 'Color', blueseq(30,:), ...
    'LineWidth', 2.5, 'DisplayName','Mean');

% 5. Overlay roll line (red)
rollVal = 0.0245;
rollLine = plot([rollVal rollVal], yl, 'Color', redseq(30,:), ...
    'LineWidth', 2.5, 'DisplayName','Roll Value');

% 6. Overlay 95% CI (black dashed)
ciLine1 = plot([ci95(1) ci95(1)], yl, 'k--', 'LineWidth', 2, 'DisplayName','95% CI');
ciLine2 = plot([ci95(2) ci95(2)], yl, 'k--', 'LineWidth', 2);

% 7. Highlight mean with a circle
scatter(boot_mean, 0, 80, blueseq(60,:), 'filled', 'MarkerEdgeColor','k');

% 8. Styling
xlabel('Estimated KGVS in Pitch', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('');
yticks([]);
grid on; box on;
set(gca,'FontSize',13,'LineWidth',1.2,'TickDir','out','XColor',[0.2 0.2 0.2],'YColor',[0.2 0.2 0.2]);

% 9. Add legend
legend([violinFill, meanLine, rollLine, ciLine1], 'Location','best');

% Check significance against zero
if 0 < ci95(1) || 0 > ci95(2)
    sig_zero = true;
else
    sig_zero = false;
end

%% Pretty histogram with overlays
colors; % your colormap definitions
figure; hold on;

% 1. Histogram (normalized to probability density)
h = histogram(boot_est,10, 'Normalization','pdf', ...
    'FaceColor', blueseq(30,:), 'FaceAlpha', 0.4, ...
    'EdgeColor','none', 'DisplayName','Bootstrap Distribution');

% 2. Kernel density line (for smoothness, optional)
[f, xi] = ksdensity(boot_est, 'Bandwidth', 0.05);
plot(xi, f, 'Color', blueseq(60,:), 'LineWidth', 2, ...
    'DisplayName','KDE Smooth');

% 3. Overlay mean
yl = ylim;
meanLine = plot([boot_mean boot_mean], yl, 'Color', blueseq(30,:), ...
    'LineWidth', 2.5, 'DisplayName','Mean');

% 4. Overlay roll line (red)
rollVal = 0.0245;
rollLine = plot([rollVal rollVal], yl, 'Color', redseq(30,:), ...
    'LineWidth', 2.5, 'DisplayName','Roll Value');

% 5. Overlay 95% CI (black dashed)
ciLine1 = plot([ci95(1) ci95(1)], yl, 'k--', 'LineWidth', 2, 'DisplayName','95% CI');
ciLine2 = plot([ci95(2) ci95(2)], yl, 'k--', 'LineWidth', 2);

% 6. Highlight mean with a circle
scatter(boot_mean, 0, 80, blueseq(60,:), 'filled', 'MarkerEdgeColor','k');

% 7. Styling
xlabel('Estimated KGVS in Pitch', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Density', 'FontSize', 14, 'FontWeight', 'bold');
grid on; box on;
set(gca,'FontSize',13,'LineWidth',1.2,'TickDir','out', ...
    'XColor',[0.2 0.2 0.2],'YColor',[0.2 0.2 0.2]);

% 8. Legend
legend([h, meanLine, rollLine, ciLine1], 'Location','best');

% Check significance against zero
sig_zero = 0 < ci95(1) || 0 > ci95(2);