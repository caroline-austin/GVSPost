function [outputArg1,outputArg2] = PlotMap(All_var_map,Label)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[row, col, ] = size(All_var_map);
All_map = zeros(row, col);
Current_levels = ["0.1" "0.5" "1" "1.5" "2" "2.5" "3" "3.5" "4"]; % need to save this variable earlier on
figure;
subplot(2,2,1)
bar(All_var_map(:,:,1));
hold on;
ylabel('Number of Responses')
xlabel('Current Level (mA)')
xticks([1 2 3 4 5 6 7 8 9]);
xticklabels(Current_levels);
title('2 Electrode');
% legend('none','noticeable', 'moderate', 'severe')
subplot(2,2,2)
bar(All_var_map(:,:,2));
hold on;
ylabel('Number of Responses')
xlabel('Current Level (mA)')
xticks([1 2 3 4 5 6 7 8 9]);
xticklabels(Current_levels);
title('3 Electrode');
subplot(2,2,3)
bar(All_var_map(:,:,3));
hold on;
ylabel('Number of Responses')
xlabel('Current Level (mA)')
xticks([1 2 3 4 5 6 7 8 9]);
xticklabels(Current_levels);
title('4 Electrode');
subplot(2,2,4)
bar(All_map);
lgd = legend('none','noticeable', 'moderate', 'severe');
sgtitle('Tingling Reports')
end