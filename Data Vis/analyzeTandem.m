function [data_compiled] = analyzeTandem(fileName,plotB)
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
data = tandem_EXCEL_all(:,:);
testTime = zeros(11*12,1);
headTilt = zeros(11*12,1);
eyesOpen = zeros(11*12,1);
goodSteps = zeros(11*12,1);
GVS_admin = zeros(11*12,1);
trial_order = zeros(11*12,1);
zoneFinish = zeros(11*12,1);
for ii = 1:12
    for iii = 1:11
        data_t = data{iii,ii};
        testTime(12*iii + ii - 12,1) = data_t{1,19};
        if data_t{1,7} == "yes"
            headTilt(12*iii + ii - 12,1) = 1;
        elseif data_t{1,7} == "no"||data_t{1,7} == "No"
            headTilt(12*iii + ii - 12,1) = 0;
        else
            disp('Error');
        end

        if data_t{1,8} == "Open"
            eyesOpen(12*iii + ii - 12,1) = 1;
        elseif data_t{1,8} == "Closed"
            eyesOpen(12*iii + ii - 12,1) = 0;
        else
            disp('Error');
        end
        goodSteps(12*iii + ii - 12,1) = data_t{1,20};
        GVS_admin(12*iii + ii - 12,1) = data_t{1,5};
        trial_order(12*iii + ii - 12,1) = data_t{1,2};
        
        %%%Finished zone
        if data_t{1,22} == "zone 0" || data_t{1,23} == "zone 0"||data_t{1,22} == "0" || data_t{1,23} == "0"
            zoneFinish(12*iii + ii - 12,1) = 0;
        elseif data_t{1,22} == "right 1" || data_t{1,23} == "right 1" || data_t{1,22} == "right1" || data_t{1,23} == "right1"
            zoneFinish(12*iii + ii - 12,1) = 1;
        elseif data_t{1,22} == "right 2" || data_t{1,23} == "right 2"
            zoneFinish(12*iii + ii - 12,1) = 2;
        elseif data_t{1,22} == "right 3" || data_t{1,23} == "right 3"
            zoneFinish(12*iii + ii - 12,1) = 3;
        elseif data_t{1,22} == "right 4" || data_t{1,23} == "right 4"
            zoneFinish(12*iii + ii - 12,1) = 4;
        elseif data_t{1,22} == "left 1" || data_t{1,23} == "left 1"
            zoneFinish(12*iii + ii - 12,1) = -1;
        elseif data_t{1,22} == "left 2" || data_t{1,23} == "left 2"
            zoneFinish(12*iii + ii - 12,1) = -2;
        elseif data_t{1,22} == "left 3" || data_t{1,23} == "left 3"
            zoneFinish(12*iii + ii - 12,1) = -3;
        elseif data_t{1,22} == "left 4" || data_t{1,23} == "left 4"
            zoneFinish(12*iii + ii - 12,1) = -4;
        elseif data_t{1,22} == "zone 1" || data_t{1,23} == "zone 1" || data_t{1,22} == "1" || data_t{1,23} == "1"...
                || data_t{1,22} == "zone 2" || data_t{1,23} == "zone 2" || data_t{1,22} == "zone 3" || data_t{1,23} == "zone 3" ...
                || data_t{1,22} == "zone 4" || data_t{1,23} == "zone 4" || data_t{1,22} == "2" || data_t{1,23} == "2" || data_t{1,22} == "3" || data_t{1,23} == "3"...
                || data_t{1,22} == "4" || data_t{1,23} == "4"
            zoneFinish(12*iii + ii - 12,1) = NaN;
        else
            print("error")
        end

    end
end
    
data_compiled = [testTime goodSteps eyesOpen headTilt GVS_admin trial_order zoneFinish];

%% Data Visualization
 %%%Plotting
 %shapes = ["o", "+", "*", ".", "x", "square", "diamond", "^", "v", ">", "<", "pentagram", "hexagram"];

 gvs_0 = 0;
 gvs_500 = 0;
 gvs_999 = 0;

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
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15;-0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

 for i = 1:length(GVS_admin)
     if GVS_admin(i) == 0
         gvs_0 = gvs_0 + 1;
         violin_plot_input_time(gvs_0,1) = testTime(i);
         violin_plot_input_goodsteps(gvs_0,1) = goodSteps(i);
         violin_plot_input_zone(gvs_0,1) = zoneFinish(i);
     elseif GVS_admin(i) == 500
         gvs_500 = gvs_500 + 1;
         violin_plot_input_time(gvs_500,2) = testTime(i);
         violin_plot_input_goodsteps(gvs_500,2) = goodSteps(i);
         violin_plot_input_zone(gvs_500,2) = zoneFinish(i);
     elseif GVS_admin(i) == 999
         gvs_999 = gvs_999 + 1;
         violin_plot_input_time(gvs_999,3) = testTime(i);
         violin_plot_input_goodsteps(gvs_999,3) = goodSteps(i);
         violin_plot_input_zone(gvs_999,3) = zoneFinish(i);
     end
 end

 nHTeO = 0;
 nHTeC = 0;
 HTeO = 0;
 HTeC = 0;

gvs_0_nHTeO = 0;
gvs_500_nHTeO = 0;
gvs_999_nHTeO = 0;

gvs_0_nHTeC = 0;
gvs_500_nHTeC = 0;
gvs_999_nHTeC = 0;

gvs_0_HTeO = 0;
gvs_500_HTeO = 0;
gvs_999_HTeO = 0;

gvs_0_HTeC = 0;
gvs_500_HTeC = 0; 
gvs_999_HTeC = 0;


for i = 1:length(GVS_admin)
    
    % No Head Tilt, Eyes Open
    if headTilt(i) == 0 && eyesOpen(i) == 1
        nHTeO = nHTeO + 1;
        %nHTeO_data_completion_time(nHTeO) = testTime(i);
         if GVS_admin(i) == 0
             gvs_0_nHTeO = gvs_0_nHTeO + 1;
             GVS_matrix_nHTeO(gvs_0_nHTeO, 1) = GVS_admin(i);
             nHTeO_data_completion_time(gvs_0_nHTeO, 1) = testTime(i);
             nHTeO_data_completion_goodsteps(gvs_0_nHTeO,1) = goodSteps(i);
             nHTeO_data_completion_zone(gvs_0_nHTeO,1) = zoneFinish(i);
         elseif GVS_admin(i) == 500
             gvs_500_nHTeO = gvs_500_nHTeO + 1;
             GVS_matrix_nHTeO(gvs_500_nHTeO, 2) = GVS_admin(i);
             nHTeO_data_completion_time(gvs_500_nHTeO, 2) = testTime(i);
             nHTeO_data_completion_goodsteps(gvs_0_nHTeO,2) = goodSteps(i);
             nHTeO_data_completion_zone(gvs_0_nHTeO,2) = zoneFinish(i);
         elseif GVS_admin(i) == 999
             gvs_999_nHTeO = gvs_999_nHTeO + 1;
             GVS_matrix_nHTeO(gvs_999_nHTeO, 3) = GVS_admin(i);
             nHTeO_data_completion_time(gvs_999_nHTeO, 3) = testTime(i);
             nHTeO_data_completion_goodsteps(gvs_0_nHTeO,3) = goodSteps(i);
             nHTeO_data_completion_zone(gvs_0_nHTeO,3) = zoneFinish(i);
         end
    % No Head Tilt, Eyes Closed
    elseif headTilt(i) == 0 && eyesOpen(i) == 0
        nHTeC = nHTeC + 1;
        %nHTeC_data_completion_time(nHTeC) = testTime(i);
         if GVS_admin(i) == 0
             gvs_0_nHTeC = gvs_0_nHTeC + 1;
             GVS_matrix_nHTeC(gvs_0_nHTeC, 1) = GVS_admin(i);
             nHTeC_data_completion_time(gvs_0_nHTeC, 1) = testTime(i);
             nHTeC_data_completion_goodsteps(gvs_0_nHTeC,1) = goodSteps(i);
             nHTeC_data_completion_zone(gvs_0_nHTeC,1) = zoneFinish(i);
         elseif GVS_admin(i) == 500
             gvs_500_nHTeC = gvs_500_nHTeC + 1;
             GVS_matrix_nHTeC(gvs_500_nHTeC, 2) = GVS_admin(i);
             nHTeC_data_completion_time(gvs_500_nHTeC, 2) = testTime(i);
             nHTeC_data_completion_goodsteps(gvs_500_nHTeC,2) = goodSteps(i);
             nHTeC_data_completion_zone(gvs_500_nHTeC,2) = zoneFinish(i);
         elseif GVS_admin(i) == 999
             gvs_999_nHTeC = gvs_999_nHTeC + 1;
             GVS_matrix_nHTeC(gvs_999_nHTeC, 3) = GVS_admin(i);
             nHTeC_data_completion_time(gvs_999_nHTeC, 3) = testTime(i);
             nHTeC_data_completion_goodsteps(gvs_999_nHTeC,3) = goodSteps(i);
             nHTeC_data_completion_zone(gvs_999_nHTeC,3) = zoneFinish(i);
             
         end

    % Head Tilt, Eyes Open
    elseif headTilt(i) == 1 && eyesOpen(i) == 1
        HTeO = HTeO + 1;
        %HTeO_data_completion_time(HTeO) = testTime(i);

        if GVS_admin(i) == 0
             gvs_0_HTeO = gvs_0_HTeO + 1;
             GVS_matrix_HTeO(gvs_0_HTeO, 1) = GVS_admin(i);
             HTeO_data_completion_time(gvs_0_HTeO, 1) = testTime(i);
             HTeO_data_completion_goodsteps(gvs_0_HTeO,1) = goodSteps(i);
             HTeO_data_completion_zone(gvs_0_HTeO,1) = zoneFinish(i);
         elseif GVS_admin(i) == 500
             gvs_500_HTeO = gvs_500_HTeO + 1;
             GVS_matrix_HTeO(gvs_500_HTeO, 2) = GVS_admin(i);
             HTeO_data_completion_time(gvs_500_HTeO, 2) = testTime(i);
             HTeO_data_completion_goodsteps(gvs_500_HTeO,2) = goodSteps(i);
             HTeO_data_completion_zone(gvs_500_HTeO,2) = zoneFinish(i);
         elseif GVS_admin(i) == 999
             gvs_999_HTeO = gvs_999_HTeO + 1;
             GVS_matrix_HTeO(gvs_999_HTeO, 3) = GVS_admin(i);
             HTeO_data_completion_time(gvs_999_HTeO, 3) = testTime(i);
             HTeO_data_completion_goodsteps(gvs_999_HTeO,3) = goodSteps(i);
             HTeO_data_completion_zone(gvs_999_HTeO,3) = zoneFinish(i);            
         end

    % Head Tilt, Eyes Closed
    elseif headTilt(i) == 1 && eyesOpen(i) == 0
        HTeC = HTeC+ 1;
        %HTeC_data_completion_time(HTeC) = testTime(i);
         if GVS_admin(i) == 0
             gvs_0_HTeC = gvs_0_HTeC + 1;
             GVS_matrix_HTeC(gvs_0_HTeC, 1) = GVS_admin(i);
             HTeC_data_completion_time(gvs_0_HTeC, 1) = testTime(i);
             HTeC_data_completion_goodsteps(gvs_0_HTeC,1) = goodSteps(i);
             HTeC_data_completion_zone(gvs_0_HTeC,1) = zoneFinish(i);
         elseif GVS_admin(i) == 500
             gvs_500_HTeC = gvs_500_HTeC + 1;
             GVS_matrix_HTeC(gvs_500_HTeC, 2) = GVS_admin(i);
             HTeC_data_completion_time(gvs_500_HTeC, 2) = testTime(i);
             HTeC_data_completion_goodsteps(gvs_500_HTeC,2) = goodSteps(i);
             HTeC_data_completion_zone(gvs_500_HTeC,2) = zoneFinish(i);
         elseif GVS_admin(i) == 999
             gvs_999_HTeC = gvs_999_HTeC + 1;
             GVS_matrix_HTeC(gvs_999_HTeC, 3) = GVS_admin(i);
             HTeC_data_completion_time(gvs_999_HTeC, 3) = testTime(i);
             HTeC_data_completion_goodsteps(gvs_999_HTeC,3) = goodSteps(i);
             HTeC_data_completion_zone(gvs_999_HTeC,3) = zoneFinish(i);
         end
    end
end 

 if plotB == 1

    % %%% Pure Data Visualization
    % figure(); hold on;
    % sgtitle('Tandem Perfomance Data')
    % subplot(2,1,1)
    % scatter(GVS_admin, testTime);
    % xlabel('GVS Gain Value');
    % ylabel('Time to Completion (s)')
    % subplot(2,1,2)
    % scatter(GVS_admin, goodSteps);
    % xlabel('GVS Gain Value');
    % ylabel('Number of Good Steps')
    % 
    % %%% Learning Effect over time
    % figure(); hold on;
    % sgtitle('Tandem Perfomance Data over Time')
    % subplot(2,1,1)
    % scatter(trial_order, testTime);
    % xlabel('Trial Sequence');
    % ylabel('Time to Completion (s)')
    % subplot(2,1,2)
    % scatter(trial_order, goodSteps);
    % xlabel('Trial Sequence');
    % ylabel('Number of Good Steps')
    % 
    % %%% Zone finish
    % figure(); hold on;
    % sgtitle('Tandem Perfomance Data')
    % scatter(GVS_admin, zoneFinish);
    % xlabel('GVS Gain Value');
    % ylabel('Zone Finish')
    % 
    % fig = figure();
    % violin(violin_plot_input_time, 'xlabel',{'0','500','999'}, 'facecolor',[green_cb;green_cb;green_cb], 'medc', red_cb);
    % ylabel('Time to Completion (s)')
    % xlabel('GVS Gain')
    % boxplot(violin_plot_input_time)
    % xticklabels({'0','500','999'})
    % bx = findobj('Tag','boxplot');
    % set(bx(2).Children,'LineWidth',1, 'Color', blue)
    % lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
    % set(lines, 'Color', red_cb);
    % outliers = findobj(gcf,'tag','Outliers');
    % set(outliers,'MarkerEdgeColor', red_cb);
    % fontsize(fig, 24, "points")
    % title('Tandem Walk Performance- All Treatments');
    % clear bx outliers lines
    % 
    % % fig = figure();
    % % violin(violin_plot_input_goodsteps, 'xlabel',{'0','500','999'}, 'facecolor',[green_cb;green_cb;green_cb], 'medc', red_cb);
    % % ylabel('Good Steps')
    % % xlabel('GVS Gain')
    % % boxplot(violin_plot_input_goodsteps)
    % % xticklabels({'0','500','999'})
    % % bx = findobj('Tag','boxplot');
    % % set(bx(2).Children,'LineWidth',2, 'Color', blue)
    % % lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
    % % set(lines, 'Color', red_cb);
    % % outliers = findobj(gcf,'tag','Outliers');
    % % set(outliers,'MarkerEdgeColor', red_cb);
    % % fontsize(fig, 24, "points")
    % % title('Tandem Walk Performance- All Treatments');
    % % clear bx outliers lines
    % % 
    % % fig = figure();
    % % violin(violin_plot_input_zone, 'xlabel',{'0','500','999'}, 'facecolor',[green_cb;green_cb;green_cb], 'medc', red_cb);
    % % ylabel('Zone')
    % % xlabel('GVS Gain')
    % % boxplot(violin_plot_input_zone)
    % % xticklabels({'0','500','999'})
    % % bx = findobj('Tag','boxplot');
    % % set(bx(3).Children,'LineWidth',2, 'Color', blue)
    % % lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
    % % set(lines, 'Color', red_cb);
    % % outliers = findobj(gcf,'tag','Outliers');
    % % set(outliers,'MarkerEdgeColor', red_cb);
    % % fontsize(fig, 24, "points")
    % % title('Tandem Walk Performance- All Treatments');
    % 
    % if plotB == 1
    %     %% No HT, Eyes Open
    %     % GVS Effects on Completion time and Good Steps
    %     % define figure
    %     fig = figure(); hold on;
    %     % used tiledlayout so that we can adjust the margin setting
    %     t=tiledlayout(2,1,'TileSpacing','tight');
    %     sgtitle('Tandem Walk Perfomance Data (No Head Tilts, Eyes Open)')
    % 
    %     %top tile is raw time data
    %     nexttile
    %     % string together 1st and 2nd iterations of condition into single
    %     % column
    %     completion_time_plot = [nHTeO_data_completion_time];
    %     %make box plot
    %     boxchart(completion_time_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_nHTeO(i,:)/500+ 1+ xoffset2(i), nHTeO_data_completion_time(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([0 5 10 15 20])
    %     ylim([0 20])
    %     ylabel('Completion Time (s)')
    %     grid on;
    %     % lower plot is the errors 
    %     nexttile
    %     % string together 1st and 2nd iterations of condition into single
    %     % column for the box plot
    %     good_steps = [nHTeO_data_completion_goodsteps];
    %     boxchart(good_steps)
    %     hold on;
    %     % plot indv subj data using with same xoffset calcs as above and y
    %     % offset since both values for a subj could be the same 
    %     for i = 1:11
    %         plot(GVS_matrix_nHTeO(i,:)/500 +1+ xoffset2(i), nHTeO_data_completion_goodsteps(i,:),sub_symbols(i),'MarkerSize',15);
    %         hold on;
    %     end
    % 
    %     % add x and y labels
    %     xticklabels( ["0"; "500"; "999"]);
    %     xlabel('GVS Gain');
    %     yticks([0 2 4 6 8 10])
    %     ylim([-1 11])
    %     ylabel('Good Steps');
    %     %set font size for the figure so it's legible
    %     fontsize(fig, 24, "points")
    % 
    %     %% No HT, Eyes Closed
    %     % GVS Effects on Completion time and Good Steps
    %     % define figure
    %     fig = figure(); hold on;
    %     % used tiledlayout so that we can adjust the margin setting
    %     t=tiledlayout(2,1,'TileSpacing','tight');
    %     sgtitle('Tandem Walk Perfomance Data (No Head Tilts, Eyes Closed)')
    % 
    %     %top tile is raw time data
    %     nexttile
    %     % string together 1st and 2nd iterations of condition into single
    %     % column
    %     completion_time_plot = [nHTeC_data_completion_time];
    %     %make box plot
    %     boxchart(completion_time_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_nHTeC(i,:)/500+ 1+ xoffset2(i), nHTeC_data_completion_time(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([0 5 10 15 20 25 30])
    %     ylim([0 30])
    %     ylabel('Completion Time (s)')
    %     grid on;
    %     % lower plot is the errors 
    %     nexttile
    %     % string together 1st and 2nd iterations of condition into single
    %     % column for the box plot
    %     good_steps = [nHTeC_data_completion_goodsteps];
    %     boxchart(good_steps)
    %     hold on;
    %     % plot indv subj data using with same xoffset calcs as above and y
    %     % offset since both values for a subj could be the same 
    %     for i = 1:11
    %         plot(GVS_matrix_nHTeC(i,:)/500 +1+ xoffset2(i), nHTeC_data_completion_goodsteps(i,:),sub_symbols(i),'MarkerSize',15);
    %         hold on;
    %     end
    % 
    %     % add x and y labels
    %     xticklabels( ["0"; "500"; "999"]);
    %     xlabel('GVS Gain');
    %     yticks([0 2 4 6 8 10])
    %     ylim([-1 11])
    %     ylabel('Good Steps');
    %     %set font size for the figure so it's legible
    %     fontsize(fig, 24, "points")
    %     %% HT, Eyes Open
    %     % GVS Effects on Completion time and Good Steps
    %     % define figure
    %     fig = figure(); hold on;
    %     % used tiledlayout so that we can adjust the margin setting
    %     t=tiledlayout(2,1,'TileSpacing','tight');
    %     sgtitle('Tandem Walk Perfomance Data (Head Tilts, Eyes Open)')
    % 
    %     %top tile is raw time data
    %     nexttile
    %     % string together 1st and 2nd iterations of condition into single
    %     % column
    %     completion_time_plot = [HTeO_data_completion_time];
    %     %make box plot
    %     boxchart(completion_time_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_HTeO(i,:)/500+ 1+ xoffset2(i), HTeO_data_completion_time(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([0 5 10 15 20 25 30])
    %     ylim([0 30])
    %     ylabel('Completion Time (s)')
    %     grid on;
    %     % lower plot is the errors 
    %     nexttile
    %     % string together 1st and 2nd iterations of condition into single
    %     % column for the box plot
    %     good_steps = [HTeO_data_completion_goodsteps];
    %     boxchart(good_steps)
    %     hold on;
    %     % plot indv subj data using with same xoffset calcs as above and y
    %     % offset since both values for a subj could be the same 
    %     for i = 1:11
    %         plot(GVS_matrix_HTeO(i,:)/500 +1+ xoffset2(i), HTeO_data_completion_goodsteps(i,:),sub_symbols(i),'MarkerSize',15);
    %         hold on;
    %     end
    % 
    %     % add x and y labels
    %     xticklabels( ["0"; "500"; "999"]);
    %     xlabel('GVS Gain');
    %     yticks([0 2 4 6 8 10])
    %     ylim([-1 11])
    %     ylabel('Good Steps');
    %     %set font size for the figure so it's legible
    %     fontsize(fig, 24, "points")
    % 
    %     %% HT, Eyes Closed
    % 
    %     % GVS Effects on Completion time and Good Steps
    %     % define figure
    %     fig = figure(); hold on;
    %     % used tiledlayout so that we can adjust the margin setting
    %     t=tiledlayout(2,1,'TileSpacing','tight');
    %     sgtitle('Tandem Walk Perfomance Data (Head Tilts, Eyes Closed)')
    % 
    %     %top tile is raw time data
    %     nexttile
    %     % string together 1st and 2nd iterations of condition into single
    %     % column
    %     completion_time_plot = [HTeC_data_completion_time];
    %     %make box plot
    %     boxchart(completion_time_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_HTeC(i,:)/500+ 1+ xoffset2(i), HTeC_data_completion_time(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([0 10 20 30 40 50 60])
    %     ylim([0 60])
    %     ylabel('Completion Time (s)')
    %     grid on;
    %     % lower plot is the errors 
    %     nexttile
    %     % string together 1st and 2nd iterations of condition into single
    %     % column for the box plot
    %     good_steps = [HTeC_data_completion_goodsteps];
    %     boxchart(good_steps)
    %     hold on;
    %     % plot indv subj data using with same xoffset calcs as above and y
    %     % offset since both values for a subj could be the same 
    %     for i = 1:11
    %         plot(GVS_matrix_HTeC(i,:)/500 +1+ xoffset2(i), HTeC_data_completion_goodsteps(i,:),sub_symbols(i),'MarkerSize',15);
    %         hold on;
    %     end
    % 
    %     % add x and y labels
    %     xticklabels( ["0"; "500"; "999"]);
    %     xlabel('GVS Gain');
    %     yticks([0 2 4 6 8 10])
    %     ylim([-1 11])
    %     ylabel('Good Steps');
    %     %set font size for the figure so it's legible
    %     fontsize(fig, 24, "points")
    % 
    %     %% Plot all Zone Data
    %     fig = figure(); hold on;
    %     % used tiledlayout so that we can adjust the margin setting
    %     t=tiledlayout(2,2,'TileSpacing','tight');
    %     sgtitle('Tandem Walk Perfomance Data- Zone')
    %     nexttile
    %     completion_zone_plot = [nHTeO_data_completion_zone];
    %     boxchart(completion_zone_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_nHTeO(i,:)/500+ 1+ xoffset2(i), nHTeO_data_completion_zone(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([-4 -3 -2 -1 0 1 2 3 4])
    %     ylim([-5 5])
    %     ylabel({'No Head Tilts','Zone'})
    %     grid on;
    %     title('Eyes Open')
    %     fontsize(fig, 24, "points")
    % 
    % 
    % 
    %     nexttile
    %     completion_zone_plot = [nHTeC_data_completion_zone];
    %     boxchart(completion_zone_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_nHTeC(i,:)/500+ 1+ xoffset2(i), nHTeC_data_completion_zone(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([-4 -3 -2 -1 0 1 2 3 4])
    %     ylim([-5 5])
    %     grid on;
    %     title('Eyes Closed')        
    %     fontsize(fig, 24, "points")
    %     set(gca,'Yticklabel',[])
    % 
    % 
    %     nexttile
    %     completion_zone_plot = [HTeO_data_completion_zone];
    %     boxchart(completion_zone_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_HTeO(i,:)/500+ 1+ xoffset2(i), HTeO_data_completion_zone(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([-4 -3 -2 -1 0 1 2 3 4])
    %     ylim([-5 5])
    %     ylabel({'Head Tilts','Zone'})
    %     grid on;
    %     xticklabels( ["0"; "500"; "999"]);
    %     xlabel('GVS Gain');
    %     %title('Head Tilts, Eyes Open')
    %     fontsize(fig, 24, "points")
    % 
    % 
    %     nexttile
    %     completion_zone_plot = [HTeC_data_completion_zone];
    %     boxchart(completion_zone_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_HTeC(i,:)/500+ 1+ xoffset2(i), HTeC_data_completion_zone(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([-4 -3 -2 -1 0 1 2 3 4])
    %     ylim([-5 5])
    %     grid on;
    %     fontsize(fig, 24, "points")
    %     xticklabels( ["0"; "500"; "999"]);
    %     xlabel('GVS Gain');
    %     %title('Head Tilts, Eyes Closed')
    %     set(gca,'Yticklabel',[])
    % 
    % 
    % 
    %     %% Plot all Completion Time Data
    %     fig = figure(); hold on;
    %     % used tiledlayout so that we can adjust the margin setting
    %     t=tiledlayout(2,2,'TileSpacing','tight');
    %     sgtitle('Tandem Walk Perfomance Data- Completion Time')
    %     nexttile
    %     completion_time_plot = [nHTeO_data_completion_time];
    %     boxchart(completion_time_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_nHTeO(i,:)/500+ 1+ xoffset2(i), nHTeO_data_completion_time(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([0 10 20 30 40 50 60])
    %     ylim([0 60])
    %     ylabel({'No Head Tilts','Completion Time (s)'})
    %     grid on;
    %     title('Eyes Open')
    %     fontsize(fig, 24, "points")
    % 
    % 
    % 
    %     nexttile
    %     completion_time_plot = [nHTeC_data_completion_time];
    %     boxchart(completion_time_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_nHTeC(i,:)/500+ 1+ xoffset2(i), nHTeC_data_completion_time(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([0 10 20 30 40 50 60])
    %     ylim([0 60])
    %     grid on;
    %     title('Eyes Closed')        
    %     fontsize(fig, 24, "points")
    %     set(gca,'Yticklabel',[])
    % 
    % 
    %     nexttile
    %     completion_time_plot = [HTeO_data_completion_time];
    %     boxchart(completion_time_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_HTeO(i,:)/500+ 1+ xoffset2(i), HTeO_data_completion_time(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([0 10 20 30 40 50 60])
    %     ylim([0 60])
    %     ylabel({'Head Tilts','Completion Time(s)'})
    %     grid on;
    %     xticklabels( ["0"; "500"; "999"]);
    %     xlabel('GVS Gain');
    %     %title('Head Tilts, Eyes Open')
    %     fontsize(fig, 24, "points")
    % 
    % 
    %     nexttile
    %     completion_time_plot = [HTeC_data_completion_time];
    %     boxchart(completion_time_plot)
    %     hold on;
    %     % plot individual subject data, divide by 500 so that values are 0,
    %     % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
    %     % boxplots
    %     % use x offset to separate subject symbols from each other
    %     for i = 1:11
    %         plot(GVS_matrix_HTeC(i,:)/500+ 1+ xoffset2(i), HTeC_data_completion_time(i,:),sub_symbols(i),'MarkerSize',15);            
    %         hold on;
    %     end
    %     % no labels for the top plot to save space
    %     set(gca,'Xticklabel',[])
    %     % xlabel('GVS Gain');
    %     % y axis settings
    %     yticks([0 10 20 30 40 50 60])
    %     ylim([0 60])
    %     grid on;
    %     fontsize(fig, 24, "points")
    %     xticklabels( ["0"; "500"; "999"]);
    %     xlabel('GVS Gain');
    %     %title('Head Tilts, Eyes Closed')
    %     set(gca,'Yticklabel',[])

        %% Plot all Good Steps Data
        fig = figure(); hold on;
        % used tiledlayout so that we can adjust the margin setting
        t=tiledlayout(2,2,'TileSpacing','tight');
        sgtitle('Tandem Walk Perfomance')
        nexttile
        goodsteps_plot = [nHTeO_data_completion_goodsteps];
        boxchart(goodsteps_plot)
        hold on;
        % plot individual subject data, divide by 500 so that values are 0,
        % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
        % boxplots
        % use x offset to separate subject symbols from each other
        for i = 1:11
            plot(GVS_matrix_nHTeO(i,:)/500+ 1+ xoffset2(i), nHTeO_data_completion_goodsteps(i,:),sub_symbols(i),'MarkerSize',15);            
            hold on;
        end
        % no labels for the top plot to save space
        set(gca,'Xticklabel',[])
        % xlabel('GVS Gain');
        % y axis settings
        yticks([0 5 10])
        ylim([-1 11])
        ylabel({'       No Head Tilts',''})
        grid on;
        title('Eyes Open')
        fontsize(fig, 36, "points")
        


        nexttile
        goodsteps_plot = [nHTeC_data_completion_goodsteps];
        boxchart(goodsteps_plot)
        hold on;
        % plot individual subject data, divide by 500 so that values are 0,
        % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
        % boxplots
        % use x offset to separate subject symbols from each other
        for i = 1:11
            plot(GVS_matrix_nHTeC(i,:)/500+ 1+ xoffset2(i), nHTeC_data_completion_goodsteps(i,:),sub_symbols(i),'MarkerSize',15);            
            hold on;
        end
        % no labels for the top plot to save space
        set(gca,'Xticklabel',[])
        % xlabel('GVS Gain');
        % y axis settings
        yticks([0 5 10])
        ylim([-1 11])
        grid on;
        title('Eyes Closed')        
        fontsize(fig, 36, "points")
        set(gca,'Yticklabel',[])


        nexttile
        goodsteps_plot = [HTeO_data_completion_goodsteps];
        boxchart(goodsteps_plot)
        hold on;
        % plot individual subject data, divide by 500 so that values are 0,
        % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
        % boxplots
        % use x offset to separate subject symbols from each other
        for i = 1:11
            plot(GVS_matrix_HTeO(i,:)/500+ 1+ xoffset2(i), HTeO_data_completion_goodsteps(i,:),sub_symbols(i),'MarkerSize',15);            
            hold on;
        end
        % no labels for the top plot to save space
        set(gca,'Xticklabel',[])
        % xlabel('GVS Gain');
        % y axis settings
        yticks([0 5 10])
        ylim([-1 11])
        ylabel({'Head Tilts -    ','                Correct Steps'})
        grid on;
        xticklabels( ["0"; "Low"; "High"]);
        xlabel('GVS Condition');
        %title('Head Tilts, Eyes Open')
        fontsize(fig, 50, "points")


        nexttile
        goodsteps_plot = [HTeC_data_completion_goodsteps];
        boxchart(goodsteps_plot)
        hold on;
        % plot individual subject data, divide by 500 so that values are 0,
        % 1 and 2 then add 1 so that it is 1, 2, 3 and lines up with
        % boxplots
        % use x offset to separate subject symbols from each other
        for i = 1:11
            plot(GVS_matrix_HTeC(i,:)/500+ 1+ xoffset2(i), HTeC_data_completion_goodsteps(i,:),sub_symbols(i),'MarkerSize',15);            
            hold on;
        end
        % no labels for the top plot to save space
        set(gca,'Xticklabel',[])
        % xlabel('GVS Gain');
        % y axis settings
        yticks([0 5 10])
        ylim([-1 11])
        grid on;
        fontsize(fig, 50, "points")
        xticklabels( ["0"; "Low"; "High"]);
        xlabel('GVS Condition');
        %title('Head Tilts, Eyes Closed')
        set(gca,'Yticklabel',[])
    % end
end


end