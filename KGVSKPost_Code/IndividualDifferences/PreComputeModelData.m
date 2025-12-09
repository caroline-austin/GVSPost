% Precomput model predictions for processing later

clc;clear;close all;
addpath('../Observer/')
addpath('../PerceptionData/CarolineData/')

% Initialize
MS_Params = [6.7175   11.7004  561.9546...
    91.2858    0.0001    0.3226  483.2565   73.7873];

GVS_range = -2:0.05:2;

g = length(GVS_range);
s = [1 2 4 6:14];

Gain_sub = zeros(10,1);
motions = ["4","5","6"];
dirs =["A","B"];

ModelData = cell(36,g);

i=1;

parfor j = 1:g

    GVS_Params = [0.0245*GVS_range(j) 0];
    for spot = 1:36
        if spot < 19
            c = 1;
        else
            c = 2;
        end
        if spot-(c-1)*18 < 7
            t = 1;
        elseif spot-(c-1)*18 < 13 && spot-(c-1)*18 > 6
            t = 2;
        else 
            t = 3;
        end
        if spot-(c-1)*18-(t-1)*6 < 4
            d = 1;
        else 
            d = 2;
        end
        m = spot-(c-1)*18-(t-1)*6-(d-1)*3;
   
        switch t
            case 1 %'Velocity'
                conditions = [5 1];
            case 2 %'Angle'
                conditions = [7 3];  conditions = [4 1];
                Title = 'Angle Coupled GVS';
            case 3 %'Semi'
                conditions = [6 2];
                Title = 'Semi Coupled GVS';
        end

        if t == 1 || t == 3
            continue
        end
            
        motion = motions(m);
        dir = dirs(d);
        condition = conditions(c);
        if condition > 4
            condition = condition+1;
        end

        % Pull Data
        [model_time, motiondata, perceptions, current] = ...
           PullSubject(motion,dir,condition,i);

        if sum(perceptions)==0
            continue
        end
        
        % construct model motion and environment
        model_motion = [0 0 0 0 0 0].*zeros(length(model_time),1);
        model_motion(:,5) = motiondata(:,3);
        Glevel = [0 0 -1].*ones(length(model_time),1); % -1g for all time 

        % Run observer simulations
        [ts, ~,~,~,g_est,~,~,~,~,~]= Observer_Analysis(...
           model_time,model_motion,MS_Params,Glevel,...
           0,2,current,GVS_Params);

        tilt_est = asind(g_est(:,1));

        ModelData{spot,j} = [ts tilt_est];

    end
    disp(j)
end

save("ModelDataFinal.mat")