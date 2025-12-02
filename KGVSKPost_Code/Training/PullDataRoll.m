function [model_time, motiondata, perceptions, current] = PullDataRoll(motion,dir,condition)

    Var = load('DynamicDataGainRollFinal.mat');
    
    tiltname = "tilt_"+motion+dir;
    motiondata = Var.(tiltname);
    tiltang = motiondata(:,1);
    
    % perceptions
    shot_name = "All_shot_"+motion+dir;
    shot_data = Var.(shot_name);
    perceptions = shot_data(:,condition);
    
    % GVS Current
    if condition == 3
        current = motiondata(:,1);
    elseif condition == 7
        current = -1*motiondata(:,1);
    elseif condition == 1
        current = motiondata(:,3);
    elseif condition == 5
         current = -1*motiondata(:,3);
    elseif condition == 2
        current = motiondata(:,3)/2+motiondata(:,1)/2;
    elseif condition == 6
         current = -1*(motiondata(:,3)/2+motiondata(:,1)/2);
    elseif condition == 4
        current = 0*motiondata(:,1);
    end
    current = current/max(abs(current))*4;
    
    % reconstruct time
    T = length(tiltang)*0.02;
    dt = 0.02;
    model_time = (0:dt:T-dt)';

end