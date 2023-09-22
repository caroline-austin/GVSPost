function [All_avg,num_trials_avg,all_save,num_trials_save] = AggregateSingleMetric(metric, Label, sub, All_avg,num_trials_avg,all_save,num_trials_save, match_list)
%Aggregate Single Metric
%   This function is used to take a single valued (scalar) outcome metric where there
%   is one value for each trial the subject completes and averages the
%   metrics together for all subjects. The function does the combining of
%   the data, but code is needed outside the function to fully aggregate it
%   across all subjects. 
% All_avg is the average of all subjects data
% all_save keeps the subject's data separate and can later be passed into
% the box plot function

% %preallocate space (should be done outside the function)
% All_avg = zeros(1,length(match_list));
% num_trials = zeros(1, length(match_list));
% num_trials_save = zeros(numsub, length(match_list));
% all_save = zeros(numsub, length(match_list));


    for i = 1:length(Label)
        for j = 1:length(match_list)
            if contains(Label(i), match_list(j))
                All_avg(j) = All_avg(j)+metric(i);
                num_trials_avg(j) = num_trials_avg(j)+1;
                all_save(sub,j) = all_save(sub,j) + metric(i);
                num_trials_save(sub,j) = num_trials_save(sub,j)+1;
            end
        end
    end

% Label_metric= match_list;

%divide the aggregate report by the number of trials added into it to get
%the average report across subjects  (this should be done outside the function)

% All_avg = All_avg./num_trials_avg;
% all_save=all_save./num_trials_save;

end