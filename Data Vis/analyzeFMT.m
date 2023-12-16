%% Timothy Behrer
%% 12/15/2023
function [data_compiled] = analyzeFMT(fileName,individual,plotB)
%Take in the desired FMT data and perform a statistical analysis of it
%%%%%%%%%%%
%%%% Inputs
%   fileName - "String" Name of FMT data file
%   individual - "double (1-11)" Indicate row # for individual data set
%   reference
%   plot - "bool" for plotting or not
%%%% Outputs
%   
%   
%   
%%%%%%%%%%%%
%% Individual Participant

%% Read File Generation
load(fileName);
if individual ~= 0
    data = {};
    data = fmt_EXCEL_all(individual,:);
    raw_time_data = zeros(1,6);
    error_data = zeros(1,6);
    GVS_admin = zeros(1,6);
    trial_order = zeros(1,6);
    
    
    for ii = 1:6
        data_t = data{1,ii};
        raw_time_data(ii) = data_t{1,7};
        error_data(ii) = data_t{1,8};
        GVS_admin(ii) = data_t{1,5};
        trial_order(ii) = data_t{1,2};
    end
    data_compiled = [raw_time_data' error_data' GVS_admin'];
    
    if plotB == 1
        %% Data Visualization
    
        %%% Pure Dasa Visualization
        figure(); hold on;
        sgtitle('FMT Perfomance Data')
        subplot(2,1,1)
        scatter(GVS_admin, raw_time_data);
        xlabel('GVS Gain Value');
        ylabel('Time of Course Completion (s)')
        subplot(2,1,2)
        scatter(GVS_admin, error_data);
        xlabel('GVS Gain Value');
        ylabel('Amount of Errors');
        
        %%% Learning Effect over time
        figure(); hold on;
        sgtitle('FMT Perfomance Data over Time')
        subplot(2,1,1)
        scatter(trial_order, raw_time_data);
        xlabel('Trial Sequence');
        ylabel('Time of Course Completion (s)')
        subplot(2,1,2)
        scatter(trial_order, error_data);
        xlabel('Trial Sequence');
        ylabel('Amount of Errors');
    
    
    
    %% Data Analysis
        mean_time = mean(raw_time_data);
        mean_error = mean(error_data);
        sd_time = std(raw_time_data);
        sd_error = std(error_data);
        res_time = raw_time_data - mean_time;
        res_err = error_data - mean_error;
        figure(); hold on;
        sgtitle('Residuals Over Time')
        subplot(2,1,1)
        scatter(trial_order, res_time);
        xlabel('Trial Sequence');
        ylabel('Residual of Course Completion (s)')
        subplot(2,1,2)
        scatter(trial_order, res_err);
        xlabel('Trial Sequence');
        ylabel('Residual for Amount of Errors');
    
    
    end
end
%% Begin all data analysis
if individual == 0
    data = fmt_EXCEL_all(:,:);
    raw_time_data = zeros(11*6,1);
    error_data = zeros(11*6,1);
    GVS_admin = zeros(11*6,1);
    trial_order = zeros(11*6,1);

    for ii = 1:6
        for iii = 1:11
            data_t = data{iii,ii};
            raw_time_data(6*iii + ii - 6,1) = data_t{1,7};
            error_data(6*iii + ii - 6,1) = data_t{1,8};
            GVS_admin(6*iii + ii - 6,1) = data_t{1,5};
            trial_order(6*iii + ii - 6,1) = data_t{1,2};
        end
    end
    
    net_time_data = raw_time_data + 2*error_data;
    data_compiled = [raw_time_data error_data net_time_data GVS_admin trial_order];
    
    %%%Plotting
    if plotB == 1

        %%% Pure Dasa Visualization
        figure(); hold on;
        sgtitle('FMT Perfomance Data')
        subplot(2,1,1)
        scatter(GVS_admin, raw_time_data);
        xlabel('GVS Gain Value');
        ylabel('Raw Time of Course Completion (s)')
        subplot(2,1,2)
        scatter(GVS_admin, error_data);
        xlabel('GVS Gain Value');
        ylabel('Amount of Errors');
        

        %%% Learning Effect over time
        figure(); hold on;
        sgtitle('FMT Perfomance Data over Time')
        subplot(2,1,1)
        scatter(trial_order, raw_time_data);
        xlabel('Trial Sequence');
        ylabel('Raw Time of Course Completion (s)')
        subplot(2,1,2)
        scatter(trial_order, error_data);
        xlabel('Trial Sequence');
        ylabel('Amount of Errors');

        %%% Net Time of completion 
        figure(); hold on;
        sgtitle('FMT Summed Perfomance Data')
        subplot(2,1,1)
        scatter(GVS_admin, net_time_data);
        xlabel('GVS Gain Value');
        ylabel('Net Time of Course Completion (s)')
        subplot(2,1,2)
        scatter(trial_order, net_time_data);
        xlabel('Trial Order');
        ylabel('Net Time of Course Completion (s)');

    end

end