function [Motion_map] = MotionMap(MotionSense,TrialInfo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[roll_loc] = find(contains(MotionSense(:,3), "roll"));
[pitch_loc] = find(contains(MotionSense(:,3), "pitch"));
[yaw_loc] = find(contains(MotionSense(:,3), "yaw"));

current_col = 5;
config_col = 4; 


check = 1;
roll_match = 0;
pitch_match = 0;
yaw_match = 0;
Motion_map =  zeros(9,3,3);

for i =1: length(MotionSense(:,3))

    roll_match = ~ isempty(find(roll_loc == i,1)); 
    pitch_match = ~ isempty(find(pitch_loc == i,1)); 
    yaw_match = ~ isempty(find(yaw_loc == i,1)); 
    
    if roll_match || pitch_match || yaw_match
        check = check +1;
    Current = TrialInfo(i, current_col);
    Config = TrialInfo(i, config_col);

       switch string(Config)
            case 'Binaural'
                config_index = 1;
            case 'Cevette'
                config_index = 2;
            case 'Aoyama'
                config_index = 3;
            otherwise
        
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
        
        end

    end 

    if roll_match
        Motion_map(current_index, 1,config_index) = ... 
            Motion_map(current_index, config_index,1) +1;
    end

    if pitch_match
        Motion_map(current_index, 2, config_index) = ... 
            Motion_map(current_index, config_index,2) +1;

    end

    if yaw_match
        Motion_map(current_index, 3, config_index) = ... 
            Motion_map(current_index, config_index,3) +1;
    end
roll_match = 0;
pitch_match = 0;
yaw_match = 0;
end