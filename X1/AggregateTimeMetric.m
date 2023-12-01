function [All_avg,num_trials_avg,all_save,num_trials_save] = AggregateTimeMetric(metric, Label, sub, All_avg,num_trials_avg,all_save,num_trials_save, match_list)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% %preallocate space (should be done outside the function)
% All_avg_rms_4A = zeros(1,length(match_list));
% num_trials_4A = zeros(1, length(match_list));
% num_sub_trials_4A = zeros(numsub, length(match_list));
% rms_save_4A = zeros(numsub, length(match_list));
% rms_saveallindv_4A = [];

    for i = 1:length(Label)
        for j = 1:length(match_list)
            if contains(Label(i), match_list(j))
                All_avg(:,j) = All_avg(:,j)+metric(:,i);
                num_trials_avg(j) = num_trials_avg(j)+1;
                all_save(:,sub,j) = all_save(:,sub,j) + metric(:,i);
                num_trials_save(sub,j) = num_trials_save(sub,j)+1;
            end
        end
    end

% Label_rms_4A = match_list;
%divide the aggregate report by the number of trials added into it to get
%the average report across subjects (need to add a calculation of error)
% All_avg = All_avg./num_trials_avg;
% 
% all_save=all_save./num_trials_save;


end