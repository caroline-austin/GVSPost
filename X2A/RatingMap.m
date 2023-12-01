function [Rating_map] = RatingMap(Rating_Var,TrialInfo)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    current_col = 5;
    config_col = 4; 

    Rating_map =  zeros(9,4,3); % make sure this is a 3d array for config

for inner = 1: length(Rating_Var)
    Current = TrialInfo(inner, current_col);
    Config = TrialInfo(inner, config_col);   
    Var = Rating_Var(inner);
        
    switch string(Var)
        case 'none'
            rating_index = 1;
        case 'noticeable'
            rating_index = 2;
        case 'moderate'
            rating_index = 3;
        case 'severe'
            rating_index = 4;
        otherwise
            rating_index = 0;
    end

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

    if current_index == 0 || rating_index == 0 || config_index == 0
        continue
    end
    
    Rating_map(current_index, rating_index,config_index) = Rating_map(current_index, rating_index,config_index) +1;
        
end       
      
end