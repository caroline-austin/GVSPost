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
if plotB == 1

    %%% Pure Dasa Visualization
    figure(); hold on;
    sgtitle('Tandem Perfomance Data')
    subplot(2,1,1)
    scatter(GVS_admin, testTime);
    xlabel('GVS Gain Value');
    ylabel('Time to Completion (s)')
    subplot(2,1,2)
    scatter(GVS_admin, goodSteps);
    xlabel('GVS Gain Value');
    ylabel('Number of Good Steps')
    
    %%% Learning Effect over time
    figure(); hold on;
    sgtitle('Tandem Perfomance Data over Time')
    subplot(2,1,1)
    scatter(trial_order, testTime);
    xlabel('Trial Sequence');
    ylabel('Time to Completion (s)')
    subplot(2,1,2)
    scatter(trial_order, goodSteps);
    xlabel('Trial Sequence');
    ylabel('Number of Good Steps')

    %%% Zone finish
    


end



end