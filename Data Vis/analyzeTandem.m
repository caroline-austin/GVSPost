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
    end
end
    
data_compiled = [testTime goodSteps eyesOpen headTilt GVS_admin trial_order];




end