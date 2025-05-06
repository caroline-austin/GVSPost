function fit_info = Threshold_Analyzer_CSD(X, Y, conf, plot_on, fit_meth, se_est_meth, Wichmann_on, lapse_detect_on, tol, remove, iterative, bonferroni, confidence_on, conf_meth, conf_res, onebyone_on, onebyone_jk, tBt_bi_mean, tBt_csd_mean, tBt_bi_se, tBt_csd_se)
% Required subfunctions
% brglmfit.m 
% lapseratefun1.m
% csdfit.m
% lapseratefun1.m


% Analyzes binary threshold data (X = stimulus in deg/s, left = negative,
% Y = 0 (left) or 1 (right)).  

% Plots outputs if plot_on = 1, otherwise does not plot anything

% Fits either using traditional glmfit or brglmfit (for adaptive data)
% fit_meth = 'glmfit', or 'brglmfit', or 'both'

% Calculates the standard error using the method specified:
% se_est_meth = 'none', don't calcualte the standard error of the estimates
% se_est_meth = 'jackknife', use jackknife method to estimate the standard errors
% se_est_meth = 'bootstrap'....

% Fits using Wichmann and Hill's (2001) lapse rate parameter if activated
% (Wichmann_on = 1) or not if not activated (Wichmann_on = 0)

% Uses lapse detection techniques if activated (lapse_detect_on = 1) with
% the following specifications:

% specified tolerance (tol, default is 0.01)
% removing all trials that reach the tolerance (remove = 'many') or just one (remove = 'justone')
% with J number of interations (iterative, set to length(X) to do unlimited iterations)
% with (bonferroni = 1) or with (bonferroni=0) doing a bonferroni correction on each iteration

% So an example function call to fit and plot everything, using the 
% bias-reduced glmfit, estimating the standard error using jackknife, then
% fit using Wichmann's lapse rate, then do lapse detection, using a tolerance of 0.01 that removes only
% up to 1 trial per iteration, but does unlimited iterations with a
% Bonferroni each time would be:
% Threshold_Analyzer(X, Y, 1, 'brglmfit', 'jackknife', 1, 1, 0.01, 'justone', length(X), 1)


N = length(X);

%% Fit the Data
if strcmp(fit_meth, 'brglmfit')
    [b, dev, stats] = brglmfit(X, Y, 'binomial', 'link', 'probit');
    mu_hat = -b(1)/b(2);
    sigma_hat = 1/b(2);
    deviance = dev;
elseif strcmp(fit_meth, 'glmfit')
    [b, dev, stats] = glmfit(X, Y, 'binomial', 'link', 'probit');
    mu_hat = -b(1)/b(2);
    sigma_hat = 1/b(2);
    deviance = dev;
elseif strcmp(fit_meth, 'both')
    [b, dev, stats] = glmfit(X, Y, 'binomial', 'link', 'probit');
    mu_hat = -b(1)/b(2);
    sigma_hat = 1/b(2);
    deviance = dev;
    
    [b, dev, stats] = brglmfit(X, Y, 'binomial', 'link', 'probit');
    mu_hat_br = -b(1)/b(2);
    sigma_hat_br = 1/b(2);
    deviance_br = dev;
    b_br_overall = b;
end

%% Fit Wichmann's model
if Wichmann_on
    lambda_max = 0.06;
    x = fminsearch(@(x)lapseratefun1(x, X, Y, lambda_max), [0 0 1]);
    lambda_hat_Wich = x(1);
    mu_hat_Wich = x(2);
    sigma_hat_Wich = x(3);
end

%% Fit confidence model
if confidence_on
    if conf == 0
        display('Warning: there is not appropriate confidence data');
    else
        respC = (1-conf/100) + Y.*(conf/50-1);
        fit_info.respC = respC;
        %     conf_res = 0.01;
        if strcmp(conf_meth, '2param')
            [x, nll] = csdfit(X, respC, [b(1) b(2)], conf_res);
            mu_hat_csd2 = x(1);
            sigma_hat_csd2 = x(2);
        elseif strcmp(conf_meth, '3param')
            [x, nll] = csdfit(X, respC, [b(1) b(2) b(2)], conf_res);
            mu_hat_csd3 = x(1);
            sigma_hat_csd3 = x(2);
            sigma_hat_conf_csd3 = x(3); 
            confscale_csd3 = sigma_hat_conf_csd3 / sigma_hat_csd3;
            % < 1 corresponds to over confident (sigma of psychometric conf
            % scale is too small (narrow), report high confidence when not getting
            % that many corrrect).
            % > 1 corresponds to under confident (sigma of psychometric
            % conf scale is too large (wide)). 
        elseif strcmp(conf_meth, 'both')
            [x2, nll] = csdfit(X, respC, [b(1) b(2)], conf_res);
            mu_hat_csd2 = x2(1);
            sigma_hat_csd2 = x2(2);
            
            [x3, nll] = csdfit(X, respC, [b(1) b(2) b(2)], conf_res);
            mu_hat_csd3 = x3(1);
            sigma_hat_csd3 = x3(2);
            sigma_hat_conf_csd3 = x3(3);
            confscale_csd3 = sigma_hat_conf_csd3 / sigma_hat_csd3;
        end
    end    
end
    
%% Determine standard errors 
if strcmp(se_est_meth, 'jackknife') || lapse_detect_on
    mu_hatcurr = zeros(N,1); sigma_hatcurr = zeros(N,1); deviance_curr = zeros(N,1);
    if strcmp(fit_meth, 'both')
        mu_hatcurr_br = zeros(N,1); sigma_hatcurr_br = zeros(N,1); deviance_curr_br = zeros(N,1);
    end
    
    if Wichmann_on
        lambda_hat_Wich_curr = zeros(N,1); mu_hat_Wich_curr = zeros(N,1); sigma_hat_Wich_curr = zeros(N,1);
    end
    
    if confidence_on
        if strcmp(conf_meth, '2param')
            mu_hat_csd2_curr = zeros(N,1); sigma_hat_csd2_curr = zeros(N,1);
        elseif strcmp(conf_meth, '3param')
            mu_hat_csd3_curr = zeros(N,1); sigma_hat_csd3_curr = zeros(N,1); sigma_hat_conf_csd3_curr = zeros(N,1);
        elseif strcmp(conf_meth, 'both')
            mu_hat_csd2_curr = zeros(N,1); sigma_hat_csd2_curr = zeros(N,1);
            mu_hat_csd3_curr = zeros(N,1); sigma_hat_csd3_curr = zeros(N,1); sigma_hat_conf_csd3_curr = zeros(N,1);
        end
    end
    
    for i = 1:N
        if mod(i, 10) == 0
            %display(['Jackknife fit #', num2str(i), ' of ', num2str(N)])
        end

        if i == 1
            indices = 2:N;
        elseif i == N
            indices = 1:N-1;
        else
            indices = [1:i-1,i+1:N];
        end
        
        if strcmp(fit_meth, 'brglmfit')
            [b, dev, stats] = brglmfit(X(indices), Y(indices), 'binomial', 'link', 'probit');
        elseif strcmp(fit_meth, 'glmfit')
            [b, dev, stats] = glmfit(X(indices), Y(indices), 'binomial', 'link', 'probit');
        elseif strcmp(fit_meth, 'both')
            [b, dev, stats] = glmfit(X(indices), Y(indices), 'binomial', 'link', 'probit');
            [b_br, dev_br, stats] = brglmfit(X(indices), Y(indices), 'binomial', 'link', 'probit');
            sigma_hatcurr_br(i) = 1/b_br(2);
            mu_hatcurr_br(i) = -b_br(1)/b_br(2);
            deviance_curr_br(i) = dev_br;
        end
        sigma_hatcurr(i) = 1/b(2);
        mu_hatcurr(i) = -b(1)/b(2);
        deviance_curr(i) = dev;
        
        if Wichmann_on
            x = fminsearch(@(x)lapseratefun1(x, X(indices), Y(indices), lambda_max), [0 0 1]);
            lambda_hat_Wich_curr(i) = x(1);
            mu_hat_Wich_curr(i) = x(2);
            sigma_hat_Wich_curr(i) = x(3);
        end
        
        if confidence_on
            if strcmp(conf_meth, '2param')
                [x, nll] = csdfit(X(indices), respC(indices), [b(1) b(2)], conf_res);
                mu_hat_csd2_curr(i) = x(1);
                sigma_hat_csd2_curr(i) = x(2);
            elseif strcmp(conf_meth, '3param')
                % use the current jackknife fit, whether its glm or brglmfit -- causes problems
                [x, nll] = csdfit(X(indices), respC(indices), [b(1) b(2) b(2)], conf_res);

                % use the current jackknife brglmfit -- causes problems
%                 [x, nll] = csdfit(X(indices), respC(indices), [b_br(1) b_br(2) b_br(2)], conf_res);

                % use the overall brglmfit -- causes problems
%                 [x, nll] = csdfit(X(indices), respC(indices), [b_br_overall(1) b_br_overall(2) b_br_overall(2)], conf_res);
                
                % use the overall csd3 fit, except mu -- does not cause problems
%                 [x, nll] = csdfit(X(indices), respC(indices), [b(1) 1/sigma_hat_csd3 1/sigma_hat_conf_csd3], conf_res);

                mu_hat_csd3_curr(i) = x(1);
                sigma_hat_csd3_curr(i) = x(2);
                sigma_hat_conf_csd3_curr(i) = x(3);
                if sigma_hat_conf_csd3_curr(i) > 100 || sigma_hat_csd3_curr(i) > 100 || abs(mu_hat_csd3_curr(i)) > 10
                    display('WARNING: THERE MAY BE A PROBLEM WITH THE SE OF THIS FIT!!!')
                    display(['Removing trial # ', num2str(i)]);
                    display(['Mu hat CSD3 = ', num2str(mu_hat_csd3_curr(i))])
                    display(['Sigma hat CSD3 = ', num2str(sigma_hat_csd3_curr(i))])
                    display(['Sigma conf hat CSD3 = ', num2str(sigma_hat_conf_csd3_curr(i))])
                end
            elseif strcmp(conf_meth, 'both')
                [x2, nll] = csdfit(X(indices), respC(indices), [b(1) b(2)], conf_res);
                mu_hat_csd2_curr(i) = x2(1);
                sigma_hat_csd2_curr(i) = x2(2);
                
%                 [x3, nll] = csdfit(X(indices), respC(indices), [b(1) b(2) b(2)], conf_res);
%                 [x, nll] = csdfit(X(indices), respC(indices), [b(1) 1/sigma_hat_csd3 1/sigma_hat_conf_csd3], conf_res);
                [x, nll] = csdfit(X(indices), respC(indices), [b_br(1) b_br(2) b_br(2)], conf_res);
                mu_hat_csd3_curr(i) = x3(1);
                sigma_hat_csd3_curr(i) = x3(2);
                sigma_hat_conf_csd3_curr(i) = x3(3);
            end
        end
        
    end
    mu_se = sqrt( (N-1)/N*sum( (mu_hat - mu_hatcurr).^2) );
    sigma_se = sqrt( (N-1)/N*sum( (sigma_hat - sigma_hatcurr).^2 ) );
    
    if strcmp(fit_meth, 'both')
        mu_se_br = sqrt( (N-1)/N*sum( (mu_hat_br - mu_hatcurr_br).^2) );
        sigma_se_br = sqrt( (N-1)/N*sum( (sigma_hat_br - sigma_hatcurr_br).^2 ) );
    end
    
    if Wichmann_on
        lambda_se_Wich = sqrt( (N-1)/N*sum( (lambda_hat_Wich - lambda_hat_Wich_curr).^2) );
        mu_se_Wich = sqrt( (N-1)/N*sum( (mu_hat_Wich - mu_hat_Wich_curr).^2) );
        sigma_se_Wich = sqrt( (N-1)/N*sum( (sigma_hat_Wich - sigma_hat_Wich_curr).^2) );
    end 
    
    if confidence_on
        if strcmp(conf_meth, '2param')
            mu_se_csd2 = sqrt( (N-1)/N*sum( (mu_hat_csd2 - mu_hat_csd2_curr).^2) );
            sigma_se_csd2 = sqrt( (N-1)/N*sum( (sigma_hat_csd2 - sigma_hat_csd2_curr).^2) );
        elseif strcmp(conf_meth, '3param')
            mu_se_csd3 = sqrt( (N-1)/N*sum( (mu_hat_csd3 - mu_hat_csd3_curr).^2) );
            sigma_se_csd3 = sqrt( (N-1)/N*sum( (sigma_hat_csd3 - sigma_hat_csd3_curr).^2) );
            sigma_se_conf_csd3 = sqrt( (N-1)/N*sum( (sigma_hat_conf_csd3 - sigma_hat_conf_csd3_curr).^2) );
            confscale_csd3_curr = sigma_hat_conf_csd3_curr ./ sigma_hat_csd3_curr;
            confscale_se_csd3 = sqrt( (N-1)/N*sum( (confscale_csd3 - confscale_csd3_curr).^2) );
            
%             figure;
%             subplot(4,1,1); plot(mu_hat_csd3_curr, 'o');
%             ylabel('mu_hat_csd3');
%             subplot(4,1,2); plot(sigma_hat_csd3_curr, 'o');
%             subplot(4,1,3); plot(sigma_hat_conf_csd3_curr, 'o');
%             subplot(4,1,4); plot(confscale_csd3_curr, 'o');
            
        elseif strcmp(conf_meth, 'both')
            mu_se_csd2 = sqrt( (N-1)/N*sum( (mu_hat_csd2 - mu_hat_csd2_curr).^2) );
            sigma_se_csd2 = sqrt( (N-1)/N*sum( (sigma_hat_csd2 - sigma_hat_csd2_curr).^2) );
            mu_se_csd3 = sqrt( (N-1)/N*sum( (mu_hat_csd3 - mu_hat_csd3_curr).^2) );
            sigma_se_csd3 = sqrt( (N-1)/N*sum( (sigma_hat_csd3 - sigma_hat_csd3_curr).^2) );
            sigma_se_conf_csd3 = sqrt( (N-1)/N*sum( (sigma_hat_conf_csd3 - sigma_hat_conf_csd3_curr).^2) );
            confscale_csd3_curr = sigma_hat_conf_csd3_curr ./ sigma_hat_csd3_curr;
            confscale_se_csd3 = sqrt( (N-1)/N*sum( (confscale_csd3 - confscale_csd3_curr).^2) );
        end
    end
end


%% Analyze on a trial by trial basis
if onebyone_on
%     if tBt_bi_mean(end) ~= N
%         tBt_bi_mean = [tBt_bi_mean N];
%     end
%     if tBt_csd_mean(end) ~= N
%         tBt_csd_mean = [tBt_csd_mean N];
%     end
%     if tBt_bi_se(end) ~= N
%         tBt_bi_se = [tBt_bi_se N];
%     end
%     if tBt_csd_se(end) ~= N
%         tBt_csd_se = [tBt_csd_se N];
%     end
    LtBt_bi_mean = length(tBt_bi_mean);          % the length of the 1 by 1 analysis trial vector
    LtBt_csd_mean = length(tBt_csd_mean); 
    LtBt_bi_se = length(tBt_bi_se); 
    LtBt_csd_se = length(tBt_csd_se); 
    
    if strcmp(fit_meth, 'brglmfit') || strcmp(fit_meth, 'both')
        sigma_hat_br_vect = zeros(1,LtBt_bi_mean);
        for i = 1:LtBt_bi_mean
            [b_br_i, dev_br, stats] = brglmfit(X(1:tBt_bi_mean(i)), Y(1:tBt_bi_mean(i)), 'binomial', 'link', 'probit');
            sigma_hat_br_vect(i) = 1/b_br_i(2);
        end
        if onebyone_jk
            sigma_hat_br_vect_se = zeros(1,LtBt_bi_se);
            sigma_hat_br_vect_se_mean = zeros(1,LtBt_bi_se);
            for i = 1:LtBt_bi_se
                [b_br_i, dev_br, stats] = brglmfit(X(1:tBt_bi_se(i)), Y(1:tBt_bi_se(i)), 'binomial', 'link', 'probit');
                sigma_hat_br_vect_se_mean(i) = 1/b_br_i(2);
                sigma_hat_br_vect_se(i) = jk_thresh(X(1:tBt_bi_se(i)), Y(1:tBt_bi_se(i)), 0, sigma_hat_br_vect_se_mean(i), 'brglmfit');
            end
        end 
    end
    
    if strcmp(fit_meth, 'glmfit') || strcmp(fit_meth, 'both')
        sigma_hat_vect = zeros(1,LtBt_bi_mean);
        for i = 1:LtBt_bi_mean
            [b_i, dev, stats] = glmfit(X(1:tBt_bi_mean(i)), Y(1:tBt_bi_mean(i)), 'binomial', 'link', 'probit');
            sigma_hat_vect(i) = 1/b_i(2);
        end
        if onebyone_jk
            sigma_hat_vect_se = zeros(1,LtBt_bi_se);
            sigma_hat_vect_se_mean = zeros(1,LtBt_bi_se);
            for i = 1:LtBt_bi_se
                [b_i, dev, stats] = glmfit(X(1:tBt_bi_se(i)), Y(1:tBt_bi_se(i)), 'binomial', 'link', 'probit');
                sigma_hat_vect_se_mean(i) = 1/b_i(2);
                sigma_hat_vect_se(i) = jk_thresh(X(1:tBt_bi_se(i)), Y(1:tBt_bi_se(i)), 0, sigma_hat_vect_se_mean(i), 'glmfit');
            end
        end  
    end
    
    if confidence_on  && strcmp(conf_meth, '3param')
        sigma_hat_csd3_vect = zeros(1,LtBt_csd_mean);
        for i = 1:LtBt_csd_mean
            if mod(i, 1) == 0
                display(['Confidence fit with subset of trials #', num2str(i), ' of ', num2str(LtBt_csd_mean)])
            end
            % note the initial values are the b(1) and b(2) of the overall
            % fit not of the current fit for trials 1:LtBt_bi_mean(i), may need to
            % fix this
            [x, nll] = csdfit(X(1:tBt_csd_mean(i)), respC(1:tBt_csd_mean(i)), [b(1) b(2) b(2)], conf_res);
            sigma_hat_csd3_vect(i) = x(2);
            
        end
        if onebyone_jk
            sigma_hat_csd3_vect_se = zeros(1,LtBt_csd_se);
            sigma_hat_csd3_vect_se_mean = zeros(1,LtBt_csd_se);
            for i = 1:LtBt_csd_se
                if mod(i, 1) == 0
                    display(['Jackknife: Confidence fit with subset of trials #', num2str(i), ' of ', num2str(LtBt_csd_se)])
                end
                [x, nll] = csdfit(X(1:tBt_csd_se(i)), respC(1:tBt_csd_se(i)), [b(1) b(2) b(2)], conf_res);
                sigma_hat_csd3_vect_se_mean(i) = x(2);
                sigma_hat_csd3_vect_se(i) = jk_thresh(X(1:tBt_csd_se(i)), Y(1:tBt_csd_se(i)), respC(1:tBt_csd_se(i)), sigma_hat_csd3_vect_se_mean(i), 'confidence');
            end
        end
    end
end




%% Lapse detection
if lapse_detect_on

atleast1bilapse = 0;

delta_deviance = abs(deviance_curr - deviance);
%         figure; hist(delta_deviance)
p_dev = 1 - chi2cdf(delta_deviance, 1);
%         figure; hist(p_dev)
%         figure; hold on; plot(p_dev, 'o'); plot([0 N], tol*[1 1], 'k'); ylim([0 1])

if strcmp(remove, 'many')
ident_lapses = (p_dev < tol);
elseif strcmp(remove, 'justone')
    [min_p_dev, index_lapse] = min(p_dev);
    ident_lapses = zeros(length(p_dev), 1);
    ident_lapses = logical(ident_lapses);
    if p_dev(index_lapse) < tol
        ident_lapses(index_lapse) = 1;
    end
end

included_trials = find(ident_lapses == 0);
excluded_trials = find(ident_lapses);

if plot_on
    figure;
    subplot(3,1,1); plot(sigma_hatcurr, 'ko'); hold on; plot([0 N], sigma_hat*[1 1], 'k--', 'LineWidth', 2); 
    text(50, min(sigma_hatcurr), ['\sigma_{hat} = ', num2str(sigma_hat)]);
    ylabel('Sigma hat curr'); title('Interation 1')
    subplot(3,1,2); plot(delta_deviance, 'ko'); ylabel('Delta Dev');
    subplot(3,1,3); plot(p_dev, 'ko'); hold on; plot([0 N], tol*[1 1], 'k');
    text(1, tol+0.1, ['tol = ', num2str(tol)])
    plot(excluded_trials, p_dev(excluded_trials), 'ko', 'MarkerFaceColor', 'k')
    ylabel('Prob of Delta Dev')
end


if ~isempty(excluded_trials)
    atleast1bilapse = 1;
else
    % There no lapses so just use the normal ones
    mu_hat_LD = mu_hat;
    sigma_hat_LD = sigma_hat;
    mu_se_LD = mu_se;
    sigma_se_LD = sigma_se;
end
% for i = 1:length(excluded_trials)
%     display(['   Search 1: Trial ', num2str(excluded_trials(i)), ' had a delta-deviance with only a ', num2str(p_dev(excluded_trials(i))*100), '% chance of happening and a tolerance of ', num2str(tol*100), '%'])
% end

% If there were any lapses, throw them out, and search for more lapses.
% trials = 1:N;
X_nolapses = X(included_trials); Y_nolapses = Y(included_trials);
search = 2;
tol_curr = tol;
while atleast1bilapse && search < iterative
    if bonferroni
        tol_curr = tol/search;
    end
    %     display(['  Search for lapses iteration #', num2str(search), ', tolerance = ', num2str(tol_curr*100),'%']);

    % see if eliminating the 1st lapse identifies any more lapses
    if strcmp(fit_meth, 'glmfit')
        [b, deviance, stats] = glmfit(X_nolapses, Y_nolapses, 'binomial', 'link', 'probit');
    elseif strcmp(fit_meth, 'brglmfit')
        [b, deviance, stats] = brglmfit(X_nolapses, Y_nolapses, 'binomial', 'link', 'probit');
    end
    mu_hat_LD = -b(1)/b(2);
    sigma_hat_LD = 1/b(2);
    
    N_nolapses = length(X_nolapses);
    deviance_curr = zeros(N_nolapses,1);
    mu_hatcurr = zeros(N_nolapses,1);
    sigma_hatcurr = zeros(N_nolapses,1);
    ident_lapses = [];
    
    % Leave one out and recalculate deviance
    for i = 1:N_nolapses
        if i == 1
            indices = 2:N_nolapses;
        elseif i == N_nolapses
            indices = 1:N_nolapses-1;
        else
            indices = [1:i-1,i+1:N_nolapses];
        end
        if strcmp(fit_meth, 'glmfit')
            [b, dev_curr, stats] = glmfit(X_nolapses(indices), Y_nolapses(indices), 'binomial', 'link', 'probit');
        elseif strcmp(fit_meth, 'brglmfit')
            [b, dev_curr, stats] = brglmfit(X_nolapses(indices), Y_nolapses(indices), 'binomial', 'link', 'probit');
        end
        mu_hatcurr(i) = -b(1)/b(2);
        sigma_hatcurr(i) = 1/b(2);
        deviance_curr(i) = dev_curr;
    end
    
    if strcmp(se_est_meth, 'jackknife')
        mu_se_LD = sqrt( (N_nolapses-1)/N_nolapses*sum( (mu_hat_LD - sigma_hatcurr).^2 ) );
        sigma_se_LD = sqrt( (N_nolapses-1)/N_nolapses*sum( (sigma_hat_LD - sigma_hatcurr).^2 ) ); 
    end
    
    delta_deviance = abs(deviance_curr - deviance);
    %     figure; hist(delta_deviance)
    p_dev = 1 - chi2cdf(delta_deviance, 1);
    %     figure; hist(p_dev)
  
    if strcmp(remove, 'many')
        ident_lapses = (p_dev < tol_curr);
    elseif strcmp(remove, 'justone')
        [min_p_dev, index_lapse] = min(p_dev);
        ident_lapses = zeros(length(p_dev), 1);
        ident_lapses = logical(ident_lapses);
        if p_dev(index_lapse) < tol_curr;
            ident_lapses(index_lapse) = 1;
        end
    end
    
    % Important line to that removes trials properly!!!
    X_nolapses = X_nolapses(~ident_lapses);
    Y_nolapses = Y_nolapses(~ident_lapses);
    
    new_excluded_trials = included_trials(ident_lapses);
    excluded_trials = [excluded_trials; new_excluded_trials];
    
    if plot_on
        figure;
        subplot(3,1,1); plot(included_trials, sigma_hatcurr, 'ko'); hold on; plot([0 N], sigma_hat_LD*[1 1], 'k--', 'LineWidth', 2); 
        text(50, min(sigma_hatcurr), ['\sigma_{hat} = ', num2str(sigma_hat_LD)]);
        ylabel('Sigma hat curr'); title(['Interation ', num2str(search)])
        subplot(3,1,2); plot(included_trials, delta_deviance, 'ko'); ylabel('Delta Dev');
        subplot(3,1,3); plot(included_trials, p_dev, 'ko'); hold on; plot([0 N], tol_curr*[1 1], 'k');
        text(1, tol_curr+0.1, ['tol = ', num2str(tol_curr)])
        plot(new_excluded_trials, p_dev(ident_lapses==1), 'ko', 'MarkerFaceColor', 'k')
%         plot(new_excluded_trials, p_dev(new_excluded_trials), 'gx')
%         plot(new_excluded_trials, p_dev(ident_lapses==1), 'rx')
        ylabel('Prob of Delta Dev')
    end
    
    
    if ~isempty(new_excluded_trials)
        atleast1bilapse = 1;
%         p_dev_ind = find(ident_lapses);
%         for r = 1:length(new_excluded_trials)
%             display(['   Search ', num2str(search),': Trial ', num2str(new_excluded_trials(r)), ' had a delta-deviance with only a ', num2str(p_dev(p_dev_ind(r))*100), '% chance of happening and a tolerance of ', num2str(tol_curr*100), '%'])
%         end
    else
        atleast1bilapse = 0;
    end
    for w = 1:length(excluded_trials)
        if any(excluded_trials(w)==included_trials)
            i_remove = find(excluded_trials(w)==included_trials);
            if i_remove == 1
                included_trials = included_trials(2:end);
            elseif i_remove == length(included_trials);
                included_trials = included_trials(1:end-1);
            else
                included_trials = included_trials([1:i_remove-1, i_remove+1:end]);
            end
        end
    end

    search = search + 1;
end

else
    excluded_trials = [];
end

% [b, dev, stats] = brglmfit(X(included_trials), Y_lapses(included_trials), 'binomial', 'link', 'probit');
% mu_hat = -b(1)/b(2);
% sigma_hat = 1/b(2);



%% Plot stuff if that is your thing
if plot_on
    X_vect = linspace(-max(abs(X)), max(abs(X)));
    prob_hat = cdf('norm', X_vect, mu_hat, sigma_hat);
    
    % Average the Y outcomes at each unique X value
    [Xunique, ix, ixu] = unique(X);
    Punique = zeros(1,length(Xunique));
    Lunique = zeros(1,length(Xunique));
    for i = 1:length(Xunique)
        YatXunique = Y(ixu == i); % find the Y outcomes for the ith unique X value
        Lunique(i) = length(YatXunique);    % find the number of trials for the ith unique X value
        Punique(i) = mean(YatXunique);  % find the probability at the ith unique X value
    end
    
%     figure; 
    figure('Position', [50 50 700 900]);
    subplot(3,1,1); hold on;
    p1 = plot(X_vect, prob_hat, 'k', 'LineWidth', 2);
    if strcmp(fit_meth, 'both')
        prob_hat_br = cdf('norm', X_vect, mu_hat_br, sigma_hat_br);
        p2 = plot(X_vect, prob_hat_br, 'color', 0.5*[1 1 1], 'LineWidth', 2);
    end
    if lapse_detect_on
        prob_hat_LD = cdf('norm', X_vect, mu_hat_LD, sigma_hat_LD);
        p3 = plot(X_vect, prob_hat_LD, 'k--', 'LineWidth', 2);
%         text(min(X_vect)*.9, 0.9, ['\sigma_{hat} = ', num2str(sigma_hat)])
%         text(min(X_vect)*.9, 0.8, ['\sigma_{hat}LD = ', num2str(sigma_hat_LD)])
    end
    if Wichmann_on
        F = cdf('norm', X_vect, mu_hat_Wich, sigma_hat_Wich);
        prob_hat_Wich = lambda_hat_Wich + (1-lambda_hat_Wich-lambda_hat_Wich)*F;
        p4 = plot(X_vect, prob_hat_Wich, 'k-.', 'LineWidth', 2);
    end

    % plot the mean probabilities with the size of the marker representing the number of trials
    for i = 1:length(Xunique)
        % find the marker size with a max of 12 and a min of 4
        if max(Lunique) == min(Lunique)
            msize = 8;
        else
            msize = (12-4)/(max(Lunique)-min(Lunique)) * (Lunique(i)-min(Lunique)) + 4;
        end
        pN = plot(Xunique(i), Punique(i), 'ko', 'MarkerSize', msize);
    end
    
    % add the legend, depending upon what was plotted
    if strcmp(fit_meth, 'brglmfit')
        legend([p1 pN], 'brglmfit', 'responses', 'Location', 'SouthEast');
    elseif strcmp(fit_meth, 'both')
        legend([p1 p2 pN], 'glmfit', 'brglmfit', 'responses', 'Location', 'SouthEast')
    end
    if lapse_detect_on
        pL = plot(X(excluded_trials), Y(excluded_trials), 'rs', 'MarkerSize', 12); % Plot the identified lapse trials
        legend([p1 p3 pN pL], 'normal fit', 'LapseID fit', 'responses', 'lapses', 'Location', 'SouthEast')
    end
    if Wichmann_on
        legend([p1 p4 pN], 'normal fit', 'Wichmann fit', 'responses', 'Location', 'SouthEast')
    end
    if Wichmann_on && lapse_detect_on
        pL = plot(X(excluded_trials), Y(excluded_trials), 'rs', 'MarkerSize', 12); % Plot the identified lapse trials
        legend([p1 p4 p3 pN], 'normal fit', 'Wichmann fit', 'LapseID fit', 'responses', 'lapses', 'Location', 'SouthEast')
    end
        
    xlabel('Stimulus (deg/s)'); ylabel('Likelihood of Rightward Response')
    box on;
    
    trials = 1:N;
    corr = (sign(X)+1)/2 == Y;
    ind_corr_pos = (corr == 1).*(sign(X) == 1);
    ind_corr_neg = (corr == 1).*(sign(X) == -1);
    ind_incorr_pos = (corr ~= 1).*(sign(X) == 1);
    ind_incorr_neg = (corr ~= 1).*(sign(X) == -1);
    
%     figure; 
    subplot(3,1,2); hold on;  
    msize = 4;
%     msize = 6;  % make the markers bigger for like 50 trials
% ind_corr_pos
% trials(ind_corr_pos==1)
% abs(X(ind_corr_pos==1))

    plot(trials(ind_corr_pos==1), abs(X(ind_corr_pos==1)), 'ro', 'MarkerSize', msize)
    plot(trials(ind_corr_neg==1), abs(X(ind_corr_neg==1)), 'ko', 'MarkerSize', msize)
    plot(trials(ind_incorr_pos==1), abs(X(ind_incorr_pos==1)), 'rx', 'MarkerSize', msize+2)
    plot(trials(ind_incorr_neg==1), abs(X(ind_incorr_neg==1)), 'kx', 'MarkerSize', msize+2)
    legend('pos motion, correct', 'neg motion, corr', 'pos motion, incorr', 'neg motion, corr')
    if ~isempty(excluded_trials)
        % then a trial has been excluded by some basis, and we can plot it
        plot(trials(excluded_trials), abs(X(excluded_trials)), 'ks', 'MarkerSize', 12)
        legend('pos motion, correct', 'neg motion, corr', 'pos motion, incorr', 'neg motion, corr', 'lapses')
    end
    
    xlabel('Trial Number');
    ylabel('Simulus Magnitude (deg/s)');
    ylim([0 max(abs(X))]);
    box on;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(3,1,3);
    xlim([0 1]); ylim([0 1]); xticks(''); yticks(''); box on; 
    col1 = 0.02; col2 = 0.25; col3 = 0.48;
    row1 = 0.03; row = 0.1;
    text(col1, 1-row1, ['N=', num2str(N)])
    text(col1, 1-row1-row, ['\mu=', num2str(mu_hat)])
    text(col1, 1-row1-2*row, ['\sigma=', num2str(sigma_hat)])
    if strcmp(se_est_meth, 'jackknife')
        text(col1, 1-row1-3*row, ['se(\mu)=', num2str(mu_se)])
        text(col1, 1-row1-4*row, ['se(\sigma)=', num2str(sigma_se)])
    end
    if strcmp(fit_meth, 'both')
        text(col2, 1-row1, 'BiasReduced Fit')
        text(col2, 1-row1-row, ['\mu=', num2str(mu_hat_br)])
        text(col2, 1-row1-2*row, ['\sigma=', num2str(sigma_hat_br)])
        if strcmp(se_est_meth, 'jackknife')
            text(col2, 1-row1-3*row, ['se(\mu)=', num2str(mu_se_br)])
            text(col2, 1-row1-4*row, ['se(\sigma)=', num2str(sigma_se_br)])
        end
    end
    if lapse_detect_on
        text(col3, 1-row1, 'LapseID Fit')
        text(col3, 1-row1-row, ['\mu=', num2str(mu_hat_LD)])
        text(col3, 1-row1-2*row, ['\sigma=', num2str(sigma_hat_LD)])
        if strcmp(se_est_meth, 'jackknife')
            text(col3, 1-row1-3*row, ['se(\mu)=', num2str(mu_se_LD)])
            text(col3, 1-row1-4*row, ['se(\sigma)=', num2str(sigma_se_LD)])
        end
        if ~isempty(excluded_trials)
            text(col3, 1-row1-5*row, ['excluded=', num2str(excluded_trials)])
        else
            text(col3, 1-row1-5*row, 'none excluded')
        end
    end
   
    print('test.pdf', '-dpdf', '-bestfit');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if onebyone_on
        figure; hold on;
        if confidence_on
            if strcmp(fit_meth, 'brglmfit')
                plot(tBt_bi_mean, sigma_hat_br_vect, 'b', 'LineWidth', 3)
                plot(tBt_csd_mean, sigma_hat_csd3_vect, 'g', 'LineWidth', 3)
                legend('brGLMfit', 'CSD3fit')
            elseif strcmp(fit_meth, 'glmfit')
                plot(tBt_bi_mean, sigma_hat_vect, 'r', 'LineWidth', 3)
                plot(tBt_csd_mean, sigma_hat_csd3_vect, 'g', 'LineWidth', 3)
                legend('GLMfit', 'CSD3fit')
            elseif strcmp(fit_meth, 'both')
                plot(tBt_bi_mean, sigma_hat_br_vect, 'b', 'LineWidth', 3)
                plot(tBt_bi_mean, sigma_hat_vect, 'r', 'LineWidth', 3)
                plot(tBt_csd_mean, sigma_hat_csd3_vect, 'g', 'LineWidth', 3)
                legend('brGLMfit', 'GLMfit', 'CSD3fit')
            end
        else
            if strcmp(fit_meth, 'brglmfit')
                plot(tBt_bi_mean, sigma_hat_br_vect, 'b', 'LineWidth', 3)
                legend('brGLMfit')
            elseif strcmp(fit_meth, 'glmfit')
                plot(tBt_bi_mean, sigma_hat_vect, 'r', 'LineWidth', 3)
                legend('GLMfit')
            elseif strcmp(fit_meth, 'both')
                plot(tBt_bi_mean, sigma_hat_br_vect, 'b', 'LineWidth', 3)
                plot(tBt_bi_mean, sigma_hat_vect, 'r', 'LineWidth', 3)
                legend('brGLMfit', 'GLMfit')
            end
        end
        xlabel('Trial Number'); xlim([0 N+1]); ylabel('Threshold Estimate'); box on;
        set(gca, 'XGrid', 'on', 'YGrid', 'off')
        
        if strcmp(se_est_meth, 'jackknife')
            if strcmp(fit_meth, 'brglmfit')
                plot(tBt_bi_se, sigma_hat_br_vect_se_mean+1.96*sigma_hat_br_vect_se, 'b--', 'LineWidth', 2)
                plot(tBt_bi_se, sigma_hat_br_vect_se_mean-1.96*sigma_hat_br_vect_se, 'b--', 'LineWidth', 2)
            elseif strcmp(fit_meth, 'glmfit')
                plot(tBt_bi_se, sigma_hat_vect_se_mean+1.96*sigma_hat_vect_se, 'r--', 'LineWidth', 2)
                plot(tBt_bi_se, sigma_hat_vect_se_mean-1.96*sigma_hat_vect_se, 'r--', 'LineWidth', 2)
            elseif strcmp(fit_meth, 'both')
                plot(tBt_bi_se, sigma_hat_br_vect_se_mean+1.96*sigma_hat_br_vect_se, 'b--', 'LineWidth', 2)
                plot(tBt_bi_se, sigma_hat_br_vect_se_mean-1.96*sigma_hat_br_vect_se, 'b--', 'LineWidth', 2)
                plot(tBt_bi_se, sigma_hat_vect_se_mean+1.96*sigma_hat_vect_se, 'r--', 'LineWidth', 2)
                plot(tBt_bi_se, sigma_hat_vect_se_mean-1.96*sigma_hat_vect_se, 'r--', 'LineWidth', 2)
            end
            if confidence_on
                plot(tBt_csd_se, sigma_hat_csd3_vect_se_mean+1.96*sigma_hat_csd3_vect_se, 'g--', 'LineWidth', 2)
                plot(tBt_csd_se, sigma_hat_csd3_vect_se_mean-1.96*sigma_hat_csd3_vect_se, 'g--', 'LineWidth', 2)
            end
        end
    end
end


%% Output structure
fit_info.mu_hat = mu_hat;
fit_info.sigma_hat = sigma_hat;

if strcmp(fit_meth, 'both')
    fit_info.mu_hat_br = mu_hat_br;
    fit_info.sigma_hat_br = sigma_hat_br;
end

if Wichmann_on
    fit_info.lambda_hat_Wich = lambda_hat_Wich;
    fit_info.mu_hat_Wich = mu_hat_Wich;
    fit_info.sigma_hat_Wich = sigma_hat_Wich;
else
    fit_info.lambda_hat_Wich = 0;
    fit_info.mu_hat_Wich = 0;
    fit_info.sigma_hat_Wich = 0;
    fit_info.lambda_se_Wich = 0;
    fit_info.mu_se_Wich = 0;
    fit_info.sigma_se_Wich = 0;
end

% fit_info.mu_hat_csd2 = 0; fit_info.sigma_hat_csd2 = 0;
% fit_info.mu_hat_csd3 = 0; fit_info.sigma_hat_csd3 = 0; fit_info.sigma_hat_conf_csd3 = 0; fit_info.confscale_csd3 = 0;
if confidence_on
    if strcmp(conf_meth, '2param')
        fit_info.mu_hat_csd2 = mu_hat_csd2;
        fit_info.sigma_hat_csd2 = sigma_hat_csd2;
    elseif strcmp(conf_meth, '3param')
        fit_info.mu_hat_csd3 = mu_hat_csd3;
        fit_info.sigma_hat_csd3 = sigma_hat_csd3;
        fit_info.sigma_hat_conf_csd3 = sigma_hat_conf_csd3;
        fit_info.confscale_csd3 = confscale_csd3;
    elseif strcmp(conf_meth, 'both')
        fit_info.mu_hat_csd2 = mu_hat_csd2;
        fit_info.sigma_hat_csd2 = sigma_hat_csd2;
        fit_info.mu_hat_csd3 = mu_hat_csd3;
        fit_info.sigma_hat_csd3 = sigma_hat_csd3;
        fit_info.sigma_hat_conf_csd3 = sigma_hat_conf_csd3;
        fit_info.confscale_csd3 = confscale_csd3;
    end
end


if strcmp(se_est_meth, 'none')
    fit_info.mu_se = 0;
    fit_info.sigma_se = 0;
elseif strcmp(se_est_meth, 'jackknife')
    fit_info.mu_se = mu_se;
    fit_info.sigma_se = sigma_se;
    
    if strcmp(fit_meth, 'both')
        fit_info.mu_se_br = mu_se_br;
        fit_info.sigma_se_br = sigma_se_br;
    end
    
    if Wichmann_on
        fit_info.lambda_se_Wich = lambda_se_Wich;
        fit_info.mu_se_Wich = mu_se_Wich;
        fit_info.sigma_se_Wich = sigma_se_Wich;
    else
        fit_info.lambda_se_Wich = 0;
        fit_info.mu_se_Wich = 0;
        fit_info.sigma_se_Wich = 0;
    end
    
    if confidence_on
        if strcmp(conf_meth, '2param')
            fit_info.mu_se_csd2 = mu_se_csd2;
            fit_info.sigma_se_csd2 = sigma_se_csd2;
        elseif strcmp(conf_meth, '3param')
            fit_info.mu_se_csd3 = mu_se_csd3;
            fit_info.sigma_se_csd3 = sigma_se_csd3;
            fit_info.sigma_se_conf_csd3 = sigma_se_conf_csd3;
            fit_info.confscale_se_csd3 = confscale_se_csd3;
        elseif strcmp(conf_meth, 'both')
            fit_info.mu_se_csd2 = mu_se_csd2;
            fit_info.sigma_se_csd2 = sigma_se_csd2;
            fit_info.mu_se_csd3 = mu_se_csd3;
            fit_info.sigma_se_csd3 = sigma_se_csd3;
            fit_info.sigma_se_conf_csd3 = sigma_se_conf_csd3;
            fit_info.confscale_se_csd3 = confscale_se_csd3;
        end
    end
end

if lapse_detect_on
    fit_info.mu_hat_LD = mu_hat_LD;
    fit_info.sigma_hat_LD = sigma_hat_LD;
    fit_info.included_trials = included_trials;
    fit_info.excluded_trials = excluded_trials;
    if strcmp(se_est_meth, 'none')
        fit_info.mu_se_LD = 0;
        fit_info.sigma_se_LD = 0;
    elseif strcmp(se_est_meth, 'jackknife')
        fit_info.mu_se_LD = mu_se_LD;
        fit_info.sigma_se_LD = sigma_se_LD;
    end
else
    fit_info.mu_hat_LD = 0;
    fit_info.sigma_hat_LD = 0;
    fit_info.included_trials = 1:N;
    fit_info.excluded_trials = [];
end

if onebyone_on
    fit_info.sigma_hat_br_vect = sigma_hat_br_vect;
    fit_info.sigma_hat_vect = sigma_hat_vect;
    fit_info.sigma_hat_br_vect_se = sigma_hat_br_vect_se;
    fit_info.sigma_hat_vect_se = sigma_hat_vect_se;
    fit_info.sigma_hat_csd3_vect = sigma_hat_csd3_vect;
    fit_info.sigma_hat_csd3_vect_se = sigma_hat_csd3_vect_se;
end
   
