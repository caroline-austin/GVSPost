function MapStackedBarPlot(All_map,Title,norm, legend, Color_list) %~ used to be legend
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[row, col] = size(All_map);
% Current_levels_str = ["0.1" ".5" "1" "1.5" "2" "2.5" "3" "3.5" "4"];
b = bar(All_map/norm*100, "stacked"); % bi %need to calculate numsub differently
for j = 1:col % 4 should acutally be a variable that is part of the size of All_map
    b(j).FaceColor = Color_list(j,:);
end

% % legend(Legend);
% xticks([1 2 3 4 5 6 7 8 9]);
% xticklabels(Current_levels_str);
% % yticks([1 6]); 

ax = gca;
ax.FontSize = 25; %27;
title(Title, "FontSize", 45)
end