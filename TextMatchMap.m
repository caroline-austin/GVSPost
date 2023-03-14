function [Output_map] = TextMatchMap(Input,TrialInfo,Text2Chk,Column)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Text = ["roll"; "pitch" ; "yaw"];
response_types = length(Text2Chk);
% Column = 3;

current_col = 5;
current_index = 0;
config_col = 4; 
config_index = 0;
profile_col = 7;
profile_index = 0;
match = 0;
check = 1;
Output_map = zeros(9,3,response_types,5);

for j= 1:response_types
    match_loc = find(contains(Input(:,Column), Text2Chk(j)));
    for i =1: length(Input(:,Column))
        match = ~ isempty(find(match_loc == i,1)); 
        if match
            check = check +1;
            Current = TrialInfo(i, current_col);
            Config = TrialInfo(i, config_col);
            Profile = TrialInfo(i, profile_col);

            switch string(Config)
                case 'Binaural'
                    config_index = 1;
                case 'Cevette'
                    config_index = 2;
                case 'Aoyama'
                    config_index = 3;
                otherwise
                    config_index = 0; 
            end
            
            switch string(Current)
                case '0.1'
                    current_index = 1;
                case '0.5'
                    current_index = 2;
                case '1'
                    current_index = 3;
                case '1.5'
                    current_index = 4;
                case '2'
                    current_index = 5;
                case '2.5'
                    current_index = 6;
                case '3'
                    current_index = 7;
                case '3.5'
                    current_index = 8;
                case '4'
                    current_index = 9;
                otherwise
                    current_index = 0;
            end
    
           switch string(Profile)
               case 'front'
                    profile_index = 1;
                case 'right'
                    profile_index = 1;
               case 'back'
                    profile_index = 2;
               case 'left'
                    profile_index = 2;
                case '0.25'
                    profile_index = 3;
                case '0.5'
                    profile_index = 4;
                case '1'
                    profile_index = 5;
                otherwise
                    profile_index = 0;
            end
        end

        if current_index == 0 || profile_index == 0 || config_index == 0
            continue
        end
    
        if match % the way this is currently coded doesn't account for reducing multiple reports to a single report 
            Output_map(current_index, j,config_index,profile_index) = ... 
                Output_map(current_index,j, config_index,profile_index) +1;
        end
        match = 0;

    end

end

end 