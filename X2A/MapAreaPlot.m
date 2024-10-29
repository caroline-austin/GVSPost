function MapAreaPlot(All_map,Title,norm, Legend,Color_list )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[row,col] = size(All_map);
if row ==9
Current_levels = [0.1 .5 1 1.5 2 2.5 3 3.5 4];
elseif row == 8
Current_levels = [0.25 .5 1 1.5 2 2.5 3 3.5 4 4.25];
All_map = [ All_map(1,:); All_map; All_map(end,:)];
elseif row == 3
    Current_levels = [1, 2, 3];
else 
    Current_levels = 1:row;
end
area(Current_levels, All_map/norm*100); % bi %need to calculate numsub differently
colors = [Color_list(1,:); Color_list(2,:); Color_list(3,:); Color_list(4,:)];
if col ==5
    colors = [colors; 0,0,0];
end
colororder(colors);
if row == 3
    Current_levels_str = ["0.1", "Low", "High"];
    xticks([1 2 3]);
    xticklabels(Current_levels_str);
end

% Current_levels_str = ["0.1" ".5" "1" "1.5" "2" "2.5" "3" "3.5" "4"];
% xticks([1 2 3 4 5 6 7 8 9]);
% xticklabels(Current_levels_str);

ax = gca;
ax.FontSize = 27;
title(Title, "FontSize", 45)
% title(Title)
% legend(Legend);
% xlabel("Current mA")
% ylabel("Number of Responses")
end