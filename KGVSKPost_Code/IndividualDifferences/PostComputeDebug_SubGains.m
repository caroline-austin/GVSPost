% Plots to Demonstrate Aim 3
% 4/22/23
clc;clear;close all;
addpath('../Observer/')
addpath('../PerceptionData/CarolineData/')
addpath('../')
load("ModelDataFinal.mat","ModelData","GVS_range");

% name run
name = 'SubjectFitsDebug.mat';

% Initialize
MS_Params = [6.7175   11.7004  561.9546...
    91.2858    0.0001    0.3226  483.2565   73.7873];


g = length(GVS_range);
s = 1:10;

Gain_sub = zeros(10,1);
motions = ["4","5","6"];
dirs =["A","B"];

% parpool(6)
for sub = 1:length(s)
    i = s(sub);
    J_sub = zeros(g,1);

    for j = 1:g

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
                    conditions = [7 3]; conditions = [4 1];
                    Title = 'Angle Coupled GVS';
                case 3 %'Semi'
                    conditions = [6 2];
                    Title = 'Semi Coupled GVS';
            end

            if t==1 || t == 3
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
            

            % PULL OBSERVER SIMULATIONS
            ts = ModelData{spot,j}(:,1);
            tilt_est = ModelData{spot,j}(:,2);

            % Shift observer to match up with the reportings
            % (based on no GVS case)
            ts=ts-0.22;
            tilt_est = tilt_est(ts>=0);
            ts = ts(ts>=0);

            % Define a cost time that cuts off first and last second
            costtime = model_time(model_time>=1);
            costtime = costtime(costtime<=(costtime(end)-1));

            dynmodel = interp1(ts,tilt_est,costtime);
            p = interp1(model_time,perceptions,costtime);
            % p = p-p(1);
            p = p-(p(1)+p(end))/2;
            cost = 1/length(p)*sum((p-dynmodel).^2);
            
            % band = 2;
            % AT = interp1(model_time,motiondata(:,1),costtime); % should be motiondata(:,1)
            % p = p(abs(AT)>band);
            % dynmodel = dynmodel(abs(AT)>band);
            % % cost = 1/length(p)*sum((abs(p)-abs(dynmodel)).^2);
            % cost = abs(1/length(p)*sum((abs(p)-abs(dynmodel))));

            if isnan(cost)
                continue
            end
            J_sub(j) = cost+J_sub(j);
        end
        disp("K GVS multiplier:"+num2str(GVS_range(j)))
    end
    oo= find(J_sub==min(J_sub));
    Gain_sub(sub) = GVS_range(oo(end));
    % figure;plot(J_sub)
    disp(num2str(sub)+"Completed")
end

save(name)