figure;
tiledlayout(2,3)


colors;
cols = [blueseq(100,:);blue;[0.5 0.5 0.5];redseq(100,:);red];
motions = ["4","5","6"];
dirs =["A","B"];
conditions = [1 2 3 4 5]; % Attenuating and then Amplifying
for m = 1:3
    motion = motions(m);
    for d = 1:2
        dir = dirs(d);
        nexttile
        hold on
        for c = 1:length(conditions)
            condition = conditions(c);

            % Pull Data
            [model_time, motiondata, perceptions, current] = ...
               PullDataAngleAndOpt(motion,dir,condition);
            
           plot(perceptions-perceptions(1),'color',cols(c,:))
        end
        hold off
    end
end
