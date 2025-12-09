% Fit KGVS to individual participants using Pitch Data
% 9/17/2025
clc;clear;close all;
% addpath('../Observer/') % Observer solutions are pre-computed 
addpath('../PerceptionData/CarolineData/')
addpath('../Training/')

load("ModelResults.mat","Results","GVS_range"); % Typically in ../Training/

% name run
name = 'SubjectFits.mat';
s = 1:22;


% Initialize
MS_Params = [6.7175   11.7004  561.9546...
    91.2858    0.0001    0.3226  483.2565   73.7873];

motions = ["4","5","6"];
dirs =["A","B"];
conditions = [1 2 5 6];

lm = length(motions);
ld = length(dirs);
lc = length(conditions);

g = length(GVS_range);

N = lm*ld*lc;              % total trials

%% Main Loop over Subjects
% parpool(6)
Gain_sub = NaN(length(s),1);
for sub = 1:length(s)
    i = s(sub);
    J_sub = zeros(g,1);

    for j = 1:g
        GVS_Params = [GVS_range(j) 0];

        for idx = 1:N

            % Pull motion, direction, and condition
            mr = rem(idx-1,ld*lc)+1;
            m = (idx-mr)/(ld*lc)+1;
            c = rem(idx-1,lc)+1;
            qd = (idx-c)/(lc)+1;
            d = rem(qd-1,2)+1;

            motion = motions(m);
            dir = dirs(d);
            condition = conditions(c);

    
            % Pull Data
            [model_time, motiondata, perceptions, current] = ...
               PullSubject(motion,dir,condition,i);

            % Skip if trial has no data (0 or NaN)
            if sum(perceptions,'omitmissing')==0 
                continue
            end

            % PULL OBSERVER SIMULATIONS
            ts = Results{j,idx}(:,1);
            tilt_est = Results{j,idx}(:,2);

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

            % Correction code (not used)
            % p = p-p(1);
            % p = p-(p(1)+p(end))/2;
            % cost = 1/length(p)*sum((p-dynmodel).^2);
            
            % band = 2;
            % AT = interp1(model_time,motiondata(:,1),costtime); % should be motiondata(:,1)
            % p = p(abs(AT)>band);
            % dynmodel = dynmodel(abs(AT)>band);
            cost = 1/length(p)*sum((abs(p)-abs(dynmodel)).^2);
            % cost = abs(1/length(p)*sum((abs(p)-abs(dynmodel))));

            if isnan(cost)
                continue
            end
            
            J_sub(j) = cost+J_sub(j);
        end
        disp("K GVS:"+num2str(GVS_range(j)))
    end

    oo= find(J_sub==min(J_sub));
    Gain_sub(sub) = GVS_range(oo(end));

    figure;plot(J_sub)

    disp(num2str(sub)+"Completed")
end

save(name)