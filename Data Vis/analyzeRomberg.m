function [data_compiled] = analyzeRomberg(fileName,plotB)
%%%%%%%%%%%
%%%% Inputs
%   fileName - "String" Name of FMT data file
%   plot - "bool" for plotting or not
%%%% Outputs
%   
%   
%   
%%%%%%%%%%%%
%% Read File Generation
load(fileName);
%% Begin all data analysis
data = romberg_EXCEL_all(:,:);
failTime = zeros(11*24,1);
headTilt = zeros(11*24,1);
GVS_admin = zeros(11*24,1);
trial_order = zeros(11*24,1);
for ii = 1:12
    for iii = 1:11
        data_t = data{iii,ii*2-1};
        failTime(24*iii + 2*ii-1 - 24,1) = data_t{1,10};
        failTime(24*iii + 2*ii - 24,1) = data_t{1,11};
        if data_t{1,7} == "yes"
            headTilt(24*iii + 2*ii - 1 - 24,1) = 1;
            headTilt(24*iii + 2*ii - 24,1) = 1;
        elseif data_t{1,7} == "No"
            headTilt(24*iii + 2*ii - 1 - 24,1) = 0;
            headTilt(24*iii + 2*ii - 24,1) = 0;
        else
            disp('Error');
        end
        GVS_admin(24*iii + 2*ii-1 - 24,1) = data_t{1,5};
        GVS_admin(24*iii + 2*ii - 24,1) = data_t{1,5};
        trial_order(24*iii + 2*ii-1 - 24,1) = data_t{1,2}*2-1;
        trial_order(24*iii + 2*ii - 24,1) = data_t{1,2}*2;
    end
end
    
data_compiled = [failTime headTilt GVS_admin trial_order];

gvs_0 = 0;
gvs_500 = 0;
gvs_999 = 0;

for i = 1:length(GVS_admin)
     if GVS_admin(i) == 0
         gvs_0 = gvs_0 + 1;
         violin_plot_input_time(gvs_0,1) = failTime(i);
     elseif GVS_admin(i) == 500
         gvs_500 = gvs_500 + 1;
         violin_plot_input_time(gvs_500,2) = failTime(i);
     elseif GVS_admin(i) == 999
         gvs_999 = gvs_999 + 1;
         violin_plot_input_time(gvs_999,3) = failTime(i);
     end
end

nHT = 0;
HT = 0;

gvs_0_nHT = 0;
gvs_500_nHT = 0;
gvs_999_nHT = 0;

gvs_0_HT = 0;
gvs_500_HT = 0;
gvs_999_HT = 0;

for i = 1:length(GVS_admin)
    % No Head Tilt
    if headTilt(i) == 0
        nHT = nHT + 1;
         if GVS_admin(i) == 0
             gvs_0_nHT = gvs_0_nHT + 1;
             GVS_matrix_nHT(gvs_0_nHT, 1) = GVS_admin(i);
             nHT_data_time_to_failure(gvs_0_nHT, 1) = failTime(i);
         elseif GVS_admin(i) == 500
             gvs_500_nHT = gvs_500_nHT + 1;
             GVS_matrix_nHT(gvs_500_nHT, 2) = GVS_admin(i);
             nHT_data_time_to_failure(gvs_500_nHT, 2) = failTime(i);
         elseif GVS_admin(i) == 999
             gvs_999_nHT = gvs_999_nHT + 1;
             GVS_matrix_nHT(gvs_999_nHT, 3) = GVS_admin(i);
             nHT_data_time_to_failure(gvs_999_nHT, 3) = failTime(i);
         end
    % Head Tilt
    elseif headTilt(i) == 1
        HT = HT + 1;
         if GVS_admin(i) == 0
             gvs_0_HT = gvs_0_HT + 1;
             GVS_matrix_HT(gvs_0_HT, 1) = GVS_admin(i);
             HT_data_time_to_failure(gvs_0_HT, 1) = failTime(i);
         elseif GVS_admin(i) == 500
             gvs_500_HT = gvs_500_HT + 1;
             GVS_matrix_HT(gvs_500_HT, 2) = GVS_admin(i);
             HT_data_time_to_failure(gvs_500_HT, 2) = failTime(i);
         elseif GVS_admin(i) == 999
             gvs_999_HT = gvs_999_HT + 1;
             GVS_matrix_HT(gvs_999_HT, 3) = GVS_admin(i);
             HT_data_time_to_failure(gvs_999_HT, 3) = failTime(i);
         end
    end
end 

%% Data Visualization
 %%%Plotting
if plotB == 1

    %%% Pure Dasa Visualization
    figure(); hold on;
    title('Romberg Perfomance Data')
    scatter(GVS_admin, failTime);
    xlabel('GVS Gain Value');
    ylabel('Time to Fail (s)')
    
    
    %%% Learning Effect over time
    figure(); hold on;
    title('Romberg Perfomance Data over Time')
    scatter(trial_order, failTime);
    xlabel('Trial Sequence');
    ylabel('Time to Fail (s)')

     %% Plotting set up
    % colors- first 5 are color blind friendly colors
    blue = [ 0.2118    0.5255    0.6275];
    green_cb = [0.5059    0.7451    0.6314];
    navy = [0.2196    0.2118    0.3804];
    purple = [0.4196    0.3059    0.4431];
    red_cb =[0.7373  0.1529    0.1922];
    yellow = [255 190 50]/255;
    % Color_list = [blue; green; yellow; red; navy; purple];
    % sub_symbols = [">-k"; "v-k";"o-k";"+-k"; "*-k"; "x-k"; "square-k"; "^-k"; "<-k"; "pentagram-k"; "diamond-k"];
    sub_symbols = [">k"; "vk";"ok";"+k"; "*k"; "xk"; "squarek"; "^k"; "<k"; "pentagramk"; "diamondk"];
    yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
    yoffset2 = [-0.1; -0.05;0;0.05]; 
    xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
    xoffset2 = [-0.25;-0.2;-0.15;-0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

    fig = figure();
    violin(violin_plot_input_time, 'xlabel',{'0','500','999'}, 'facecolor',[green_cb;green_cb;green_cb], 'medc', red_cb);
    ylabel('Time to Failure (s)')
    xlabel('GVS Gain')
    boxplot(violin_plot_input_time)
    xticklabels({'0','500','999'})
    bx = findobj('Tag','boxplot');
    set(bx.Children,'LineWidth',1, 'Color', blue)
    lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
    set(lines, 'Color', red_cb);
    outliers = findobj(gcf,'tag','Outliers');
    set(outliers,'MarkerEdgeColor', red_cb);
    fontsize(fig, 24, "points")
    title('Romberg Balance Test Performance- All Treatments');
    clear bx outliers lines

    %% Plot all Time to Failure Data
    fig = figure(); hold on;
    % used tiledlayout so that we can adjust the margin setting
    t=tiledlayout(1,2,'TileSpacing','tight');
    sgtitle('Romberg Balance Test Perfomance Data- Time to Failure')
    nexttile
    completion_zone_plot = [nHT_data_time_to_failure];
    boxchart(completion_zone_plot)
    hold on;
    % plot individual subject data, divide by 500 so that values are 0,
    % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    % boxplots
    % use x offset to separate subject symbols from each other
    for i = 1:11
        plot(GVS_matrix_nHT(((i*4-3):i*4), :)/500+ 1+ xoffset2(i), nHT_data_time_to_failure(((i*4-3):i*4),:) + yoffset2,sub_symbols(i),'MarkerSize',15);            
        hold on;
    end
    % no labels for the top plot to save space
    set(gca,'Xticklabel',[])
    % xlabel('GVS Gain');
    % y axis settings
    yticks([0 2.5 5 7.5 10 12.5 15])
    ylim([-1 16])
    ylabel('Time to Failure (s)')
    grid on;
    title('No Head Tilts')
    fontsize(fig, 24, "points")
    xticklabels( ["0"; "500"; "999"]);
    xlabel('GVS Gain');

    nexttile
    completion_zone_plot = [HT_data_time_to_failure];
    boxchart(completion_zone_plot)
    hold on;
    % plot individual subject data, divide by 500 so that values are 0,
    % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    % boxplots
    % use x offset to separate subject symbols from each other
    for i = 1:11
        plot(GVS_matrix_HT(((i*4-3):i*4), :)/500+ 1+ xoffset2(i), HT_data_time_to_failure(((i*4-3):i*4),:) + yoffset2,sub_symbols(i),'MarkerSize',15);            
        hold on;
    end
    % no labels for the top plot to save space
    set(gca,'Xticklabel',[])
    % xlabel('GVS Gain');
    % y axis settings
    yticks([0 2.5 5 7.5 10 12.5 15])
    ylim([-1 16])
    grid on;
    title('Head Tilts')
    fontsize(fig, 24, "points")
    xticklabels( ["0"; "500"; "999"]);
    xlabel('GVS Gain');

end
    
end