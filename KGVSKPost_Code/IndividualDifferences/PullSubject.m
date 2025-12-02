function [model_time, motiondata, perceptions, current] = PullSubject(motion,dir,condition,sub)

    Var = load('DynamicDataGainPitchFinal.mat');
    
    tiltname = "tilt_"+motion+dir;
    motiondata = Var.(tiltname);
    tiltang = motiondata(:,1);
    
    % perceptions
    shot_name = "shot_save_"+motion+dir;
    shot_data = Var.(shot_name);
    perceptions = reshape(shot_data(:,:,condition),size(shot_data,1:2));
    perceptions = perceptions(:,sub);
    
    % GVS Current
    % First are Angle coupling conditions
    if condition == 1 % negative means attenuating according to F&D04 (not negative couple)
        current = motiondata(:,1);
        current = current/max(abs(current))*4;
    elseif condition == 5 % postive means amplifying according to F&D04 (not positive couple)
        current = -1*motiondata(:,1);
        current = current/max(abs(current))*4;

    % Next and Optimal Conditions
    elseif condition == 2 % This one is optimal attenuating according to modified roll model
        current = 3.71*motiondata(:,1)+0.28*motiondata(:,3);
        current(current<-5) = -5;
        current(current>5) = 5;
    elseif condition == 6 % This one is optimal amplifying according to modified roll model
        current = -1.55*motiondata(:,1)-2.62*motiondata(:,3);
        current(current<-5) = -5;
        current(current>5) = 5;

    % Zero current conditions
    elseif condition == 3 || condtion == 4
        current = 0*motiondata(:,1);
    end
    
    % reconstruct time
    T = length(tiltang)*0.02;
    dt = 0.02;
    model_time = (0:dt:T-dt)';

end