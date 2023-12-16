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
end
    
end