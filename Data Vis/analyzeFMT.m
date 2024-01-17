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

%% Plotting set up
% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];
% sub_symbols = [">-k"; "v-k";"o-k";"+-k"; "*-k"; "x-k"; "square-k"; "^-k"; "<-k"; "pentagram-k"; "diamond-k"];
sub_symbols = [">k"; "vk";"ok";"+k"; "*k"; "xk"; "squarek"; "^k"; "<k"; "pentagramk"; "diamondk"];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15;-0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

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

              
    %organize data for the trial order box plots
    for subj= 1:11
        for trial = 1:6
            trial_info_fmt = fmt_EXCEL_all{subj, trial};
            order = trial_info_fmt.trialOrder;
            raw_time_order(subj,order) = trial_info_fmt.RawTime;
            errors_order(subj,order) = trial_info_fmt.Errors;
            corrected_time_order(subj,order) = trial_info_fmt.CorrectedTime;
            k_val_fmt_order(subj,order) = trial_info_fmt.KValue;
        end
    end
    
    %% Plotting
    if plotB == 1

        %% GVS Effects on Raw time and Errors
        % define figure
        fig = figure(); hold on;
        % used tiledlayout so that we can adjust the margin setting
        t=tiledlayout(2,1,'TileSpacing','tight');
        sgtitle('FMT Perfomance Data')
        
        %top tile is raw time data
        nexttile
        % string together 1st and 2nd iterations of condition into single
        % column
        raw_time_plot = [raw_time(:, [1 3 5]); raw_time(:, [2 4 6]) ];
        %make box plot
        boxchart(raw_time_plot)
        hold on;
        % plot individual subject data, divide by 500 so that values are 0,
        % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
        % boxplots
        % use x offset to separate subject symbols from each other
        for i = 1:11
            plot(GVS_admin((i*6)-5: (i*6))/500+ 1+ xoffset2(i), raw_time_data((i*6)-5: (i*6)),sub_symbols(i),'MarkerSize',15);
            hold on;
        end
        % no labels for the top plot to save space
        set(gca,'Xticklabel',[])
        % xlabel('GVS Gain');
        % y axis settings
        yticks([5 10 15 20 25])
        ylim([10 28])
        ylabel('Raw Time (s)')
        grid on;
        % lower plot is the errors 
        nexttile
        % string together 1st and 2nd iterations of condition into single
        % column for the box plot
        errors_plot = [errors(:, [1 3 5]); errors(:, [2 4 6]) ];
        boxchart(errors_plot)
        hold on;
        % plot indv subj data using with same xoffset calcs as above and y
        % offset since both values for a subj could be the same 
        for i = 1:11
            plot(GVS_admin((i*6)-5: (i*6))/500 +1+ xoffset2(i), error_data((i*6)-5: (i*6))+yoffset2,sub_symbols(i),'MarkerSize',15);
            hold on;
        end
        % add x and y labels
        xticklabels( ["0"; "500"; "999"]);
        xlabel('GVS Gain');
        ylim([-0.5 5.5])
        ylabel('Errors');
        %set font size for the figure so it's legible
        fontsize(fig, 32, "points")
        
        
        

        %% Learning Effects on Raw time and Errors

        % define figure
        fig = figure(); hold on;
        % used tiledlayout so that we can adjust the margin setting
        t=tiledlayout(2,1,'TileSpacing','tight');
        sgtitle('FMT Perfomance Data Over Time')
        
        %top tile is raw time data
        nexttile
        %use error sorted data for boxplot
        boxchart(raw_time_order)
        hold on;
        % plot individual subject data, divide by 500 so that values are 0,
        % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
        % boxplots
        % use x offset to separate subject symbols from each other
        for i = 1:11
            plot(trial_order((i*6)-5: (i*6))+ xoffset2(i), raw_time_data((i*6)-5: (i*6)),sub_symbols(i),'MarkerSize',15);
            hold on;
        end
        % no labels for the top plot to save space
        set(gca,'Xticklabel',[])
        % xlabel('GVS Gain');
        % y axis settings
        yticks([5 10 15 20 25])
        ylim([10 28])
        ylabel('Raw Time (s)')
        grid on;
        % lower plot is the errors 
        nexttile
        %use the order sorted errors
        boxchart(errors_order)
        hold on;
        % plot indv subj data using with same xoffset calcs as above 
        for i = 1:11
            plot(trial_order((i*6)-5: (i*6))+ xoffset2(i), error_data((i*6)-5: (i*6)),sub_symbols(i),'MarkerSize',15);
            hold on;
        end
        % add x and y labels
        xticklabels( ["1"; "2"; "3"; "4"; "5"; "6"]);
        xlabel('Trial Order');
        ylim([-0.5 5.5])
        ylabel('Errors');
        %set font size for the figure so it's legible
        fontsize(fig, 32, "points")

        % figure(); hold on;
        % sgtitle('FMT Perfomance Data over Time')
        % subplot(2,1,1)
        % scatter(trial_order, raw_time_data);
        % xlabel('Trial Sequence');
        % ylabel('Raw Time of Course Completion (s)')
        % subplot(2,1,2)
        % scatter(trial_order, error_data);
        % xlabel('Trial Sequence');
        % ylabel('Amount of Errors');

        %% Corrected completion time GVS and Learning Effects 
        % define figure
        fig = figure(); hold on;
        % used tiledlayout so that we can adjust the margin setting
        t=tiledlayout(2,1,'TileSpacing','tight');
        sgtitle('FMT Perfomance Data')
        
        %top tile is for GVS effects
        nexttile
        % string together 1st and 2nd iterations of condition into single
        % column
        corrected_time_plot = [corrected_time(:, [1 3 5]); corrected_time(:, [2 4 6]) ];
        %make box plot
        boxchart(corrected_time_plot)
        hold on;
        % plot individual subject data, divide by 500 so that values are 0,
        % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
        % boxplots
        % use x offset to separate subject symbols from each other
        for i = 1:11
            plot(GVS_admin((i*6)-5: (i*6))/500+ 1+ xoffset2(i), net_time_data((i*6)-5: (i*6)),sub_symbols(i),'MarkerSize',15);
            hold on;
        end
        % no labels for the top plot to save space
        % set(gca,'Xticklabel',[])
        xticklabels(["0" "500" "999"])
        xlabel('GVS Gain');
        % y axis settings
        yticks([5 10 15 20 25])
        ylim([10 28])
        ylabel('Net Time (s)')
        grid on;

        % lower plot is for learning effects
        nexttile
        %use the order sorted errors
        boxchart(corrected_time_order)
        hold on;
        % plot indv subj data using with same xoffset calcs as above 
        for i = 1:11
            plot(trial_order((i*6)-5: (i*6))+ xoffset2(i), net_time_data((i*6)-5: (i*6)),sub_symbols(i),'MarkerSize',15);
            hold on;
        end
        % add x and y labels
        xticklabels( ["1"; "2"; "3"; "4"; "5"; "6"]);
        xlabel('Trial Order');
        yticks([5 10 15 20 25])
        ylim([10 28])
        ylabel('Net Time (s)')
        grid on;
        %set font size for the figure so it's legible
        fontsize(fig, 32, "points")


        % %%% Net Time of completion 
        % figure(); hold on;
        % sgtitle('FMT Summed Perfomance Data')
        % subplot(2,1,1)
        % scatter(GVS_admin, net_time_data);
        % xlabel('GVS Gain Value');
        % ylabel('Net Time of Course Completion (s)')
        % subplot(2,1,2)
        % scatter(trial_order, net_time_data);
        % xlabel('Trial Order');
        % ylabel('Net Time of Course Completion (s)');

        %% Corrected completion time GVS
        fig = figure(); hold on;
        % used tiledlayout so that we can adjust the margin setting
        t=tiledlayout(2,1,'TileSpacing','tight');
        
        
        %top tile is for GVS effects
        nexttile
        % string together 1st and 2nd iterations of condition into single
        % column
        corrected_time_plot = [corrected_time(:, [1 3 5]); corrected_time(:, [2 4 6]) ];
        %make box plot
        boxchart(corrected_time_plot)
        title('Functional Mobility Obstacle Course Perfomance')
        hold on;
        % plot individual subject data, divide by 500 so that values are 0,
        % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
        % boxplots
        % use x offset to separate subject symbols from each other
        for i = 1:11
            plot(GVS_admin((i*6)-5: (i*6))/500+ 1+ xoffset2(i), net_time_data((i*6)-5: (i*6)),sub_symbols(i),'MarkerSize',15);
            hold on;
        end
        % no labels for the top plot to save space
        % set(gca,'Xticklabel',[])
        xticklabels(["0" "500" "999"])
        xlabel('GVS Gain');
        % y axis settings
        yticks([5 10 15 20 25])
        ylim([10 28])
        ylabel('Net Time (s)')
        grid on;
        fontsize(fig, 32, "points")
        
        % lower plot is for learning effects
        % fig = figure(); hold on;
        % % used tiledlayout so that we can adjust the margin setting
        % t=tiledlayout(1,1,'TileSpacing','tight');
        % sgtitle('Functional Mobility Obstacle Course Perfomance Data')

        nexttile
        title('Functional Mobility Obstacle Course Perfomance Data')
        %use the order sorted errors
        boxchart(corrected_time_order)
        title('Functional Mobility Obstacle Course Perfomance Data')
        hold on;
        % plot indv subj data using with same xoffset calcs as above 
        for i = 1:11
            plot(trial_order((i*6)-5: (i*6))+ xoffset2(i), net_time_data((i*6)-5: (i*6)),sub_symbols(i),'MarkerSize',15);
            hold on;
        end
        % add x and y labels
        xticklabels( ["1"; "2"; "3"; "4"; "5"; "6"]);
        xlabel('Trial Order');
        yticks([5 10 15 20 25])
        ylim([10 28])
        ylabel('Net Time (s)')
        grid on;
        %set font size for the figure so it's legible
        fontsize(fig, 32, "points")

    end

end