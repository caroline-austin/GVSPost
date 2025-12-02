% Plots to Demonstrate Aim 3
% 4/22/23
clc;clear;close all;
addpath('../Observer/')
addpath('../PerceptionData/CarolineData/')

% name run
name = 'KGVS_KPostPosWide.mat';

% Initialize
MS_Params = [6.7175   11.7004  561.9546...
    91.2858    0.0001    0.3226  483.2565   73.7873];

Post_low  = linspace(0.5, 1.25, 6);
Post_mid  = linspace(1.25, 1.45, 21);
Post_high = linspace(1.45, 2.5, 6);
Post_range = unique([Post_low, Post_mid, Post_high]);

GVS_low  = linspace(0, 0.02, 5);
GVS_mid  = linspace(0.02, 0.03, 21);
GVS_high = linspace(0.03, 0.1, 8);
GVS_range = unique([GVS_low, GVS_mid, GVS_high]);

Ratio_range = 0;

motions = ["4","5","6"];
dirs =["A","B"];
%first four are our pitch conditions (1-5 ommitting 3)
%last six are our roll conditions (11-17 ommitting (1)4)
conditions = [2 5,...
              11 12 13 15 16 17];

lm = length(motions);
ld = length(dirs);
lc = length(conditions);

G = length(GVS_range);
P = length(Post_range);

N = lm*ld*lc;              % total trials

%% Loop through
J_dyn = zeros(G*P,1);
Results = cell(G*P,N);

% Flatten (p,j) loops into one combined loop
totalPJ = P*G;

parfor pj = 1:totalPJ
    % Map flat index back to (p,j)
    po = floor((pj-1)/G) + 1;
    j = rem(pj-1, G) + 1;
    
    %             KGVS RegRatio=0 PostGain LeftSideCurrentMultiplier
    GVS_Params = [GVS_range(j) Ratio_range Post_range(po) 1];

    local_J_dyn = 0;
    for idx = 1:N
        mr = rem(idx-1,ld*lc)+1;
        m = (idx-mr)/(ld*lc)+1;
        c = rem(idx-1,lc)+1;
        qd = (idx-c)/(lc)+1;
        d = rem(qd-1,ld)+1;

        motion = motions(m);
        dir = dirs(d);
        condition = conditions(c);

        % Pull Data
        if condition < 10 % pitch pull
            [model_time, motiondata, perceptions, current] = ...
               PullDataPitch(motion,dir,condition);
        elseif condition > 10 % roll pull
            [model_time, motiondata, perceptions, current] = ...
               PullDataRoll(motion,dir,condition-10);
        end
        
        % construct model motion and environment
        model_motion = [0 0 0 0 0 0].*zeros(length(model_time),1);
        if condition < 10
            model_motion(:,5) = motiondata(:,3);
            leftside_mult = 1; %left side current multiplier
        elseif condition > 10
            model_motion(:,4) = motiondata(:,3);
            leftside_mult = -1; %left side current multiplier
        end
        Glevel = [0 0 -1].*ones(length(model_time),1); % -1g for all time
        GVS_Params(4) = leftside_mult;

        % Run observer simulations
        [ts, ~,~,~,g_est,~,~,~,~,~]= Observer_Analysis(...
           model_time,model_motion,MS_Params,Glevel,...
           0,2,current,GVS_Params);

        % compute the model pitch / roll estimate from observer
        if condition < 10
            tilt_est = atan2d(g_est(:,1),...
                sqrt(g_est(:,2).^2 + g_est(:,3).^2)); % projection method
        elseif condition > 10
            tilt_est = atand(g_est(:,2)./g_est(:,3));
        end

        % Shift observer to match up with the reportings
        % (based on no GVS case)
        ts=ts-0.22;
        tilt_est = tilt_est(ts>=0);
        ts = ts(ts>=0);

        % Save Results
        Results{pj,idx} = [ts, tilt_est];

        % Define a cost time that cuts off first and last
        % second
        costtime = model_time(model_time>=1);
        costtime = costtime(costtime<=(costtime(end)-1));

        dynmodel = interp1(ts,tilt_est,costtime);
        p = interp1(model_time,perceptions,costtime);
        % baseline = (p(1)+p(end))/2;
        % p = p-baseline;
       
        if condition < 10
            condition_ratio=sum(conditions>10)/sum(conditions<10);
            local_J_dyn = condition_ratio*sum((p-dynmodel).^2)/length(dynmodel) + local_J_dyn;
        else
            local_J_dyn = sum((p-dynmodel).^2)/length(dynmodel) + local_J_dyn;
        end
            
    end
    Equalizer =lm*ld*2*max(sum(conditions>10),sum(conditions<10));   

    J_dyn(pj) = local_J_dyn/Equalizer;

    % Display progress
    fprintf('Completed %d/%d (Post %d of %d, GVS %d of %d)\n', ...
        pj, totalPJ, po, P, j, G);
end

save(name)
save("ModelResultsWide.mat","Results","GVS_range","Post_range")

%% Plots
colors;

% Reshape J_dyn back into G x P grid
J_dyn_mat = reshape(J_dyn, [G, P]);

% Find the minimum value and its indices
[min_val, linear_idx] = min(J_dyn_mat(:));
[row, col] = ind2sub(size(J_dyn_mat), linear_idx);

% Corresponding GVS and Post values
min_GVS = GVS_range(row);
min_Post = Post_range(col);

% Contour plot
figure;
contourf(GVS_range, Post_range, J_dyn_mat',200); % transpose so Post_range is y-axis
colorbar;
xlabel('GVS range');
ylabel('Post range');
title('Cost Function J_{dyn}');
set(gca,'FontSize',12);

colormap(flip(diverg1))
% caxis([min(J_dyn_mat(:)) min(J_dyn_mat(:))+0.2]);  % [min max] for the color scale

% Mark the minimum point
hold on;
plot(min_GVS, min_Post, 'r*', 'MarkerSize', 12, 'LineWidth', 2);
% text(min_GVS, min_Post, sprintf('  min = %.3f', min_val), 'Color','r','FontSize',12);
% Annotate with value + coordinates
text(min_GVS, min_Post, ...
    sprintf('  min = %.3f \n  at (%.3f, %.2f)', min_val, min_GVS, min_Post), ...
    'Color',[0.7 0.7 0.7],'FontSize',12, 'FontWeight','bold');
%%
% Restrict to GVS_range < 0.05
idx = GVS_range < 0.05;
GVS_sub = GVS_range(idx);
J_dyn_sub = J_dyn_mat(idx, :);   % keep only those rows

% Contour plot
figure;
contourf(GVS_sub, Post_range, J_dyn_sub', 50); % transpose for Post on y-axis
colorbar;
xlabel('GVS range');
ylabel('Post range');
title('Cost Function J_{dyn}');
set(gca,'FontSize',12);

colormap(flip(diverg1))

% Mark the minimum point if it's still in range
if min_GVS < 0.05
    hold on;
    plot(min_GVS, min_Post, 'r*', 'MarkerSize', 12, 'LineWidth', 2);
    text(min_GVS, min_Post, ...
        sprintf('  min = %.3f \n  at (%.3f, %.2f)', min_val, min_GVS, min_Post), ...
        'Color',[0.7 0.7 0.7],'FontSize',12,'FontWeight','bold');
end
%%
figure;
imagesc(GVS_range, Post_range, J_dyn_mat');
axis xy; colorbar;