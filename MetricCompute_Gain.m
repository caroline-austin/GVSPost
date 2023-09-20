function MetricCompute_Gain(Type)

% Compute Gain Metric and Save to CSV for R analysis
% Two Types:
%"CurrentGain" Proposed by Aaron: Y = Angle + (1/-1)Current*K
%"AnlgeGain"   Proposed by Caroline: Y = Angle*K

Var = load("DynamicData.mat");
%% Make Figure

motions = ["4","5","6"];

[l,m,n]=size(Var.shot_save_4A);

GainSave = zeros(m,n,3,2);
TableData = [];

ss = 1;
for k = 1:2
    for j = 1:3
        for i = 1:7
            if i == 4
                continue
            end

            if k == 1
                dir = "A";
            else
                dir = "B";
            end
    
            motion = motions(j);
    
            tiltname = "tilt_"+motion+dir;
            tiltang = Var.(tiltname);
            tilt = tiltang(:,1);

             switch i
                case 1
                    coup = tiltang(:,3);
                    GVS = 1*coup/max(coup)*4;
                case 2 
                    coup = (tiltang(:,1)*0.5+tiltang(:,3)*0.5);
                    GVS = 1*coup/max(coup)*4;
                case 3
                    coup = tiltang(:,1);
                    GVS = 1*coup/max(coup)*4;
                case 4
                    coup = tiltang(:,1)*0;
                    GVS = coup;
                case 5
                    coup = tiltang(:,3);
                    GVS = 1*coup/max(coup)*4;
                case 6
                    coup = (tiltang(:,1)*0.5+tiltang(:,3)*0.5);
                    GVS = 1*coup/max(coup)*4;
                case 7
                    coup = tiltang(:,1);
                    GVS = 1*coup/max(coup)*4;
             end
             
    
            T = length(tiltang)*0.02;
            dt = 0.02;
            time = (0:dt:T-dt)';
            
            shot_name = "shot_save_"+motion+dir;
            shot_data = Var.(shot_name);
    
            for sub = 1:m
                G = -4:0.01:4;
                Cost = zeros(length(G),1);
                for g = 1:length(G)
                    if strcmp(Type,'AngleGain')
                        pred = tilt*G(g);
                    elseif strcmp(Type,'CurrentGain')
                        pred = tilt+GVS*G(g);
                    end
                    se = (shot_data(:,sub,i)-pred)'*(shot_data(:,sub,i)-pred);
                    Cost(g) = 1/l*(se);
                end
                [~,ind] = min(Cost);
                GainSave(sub,i,j,k) = G(ind);

                if i<4
                    t = 0;
                else
                    t = 1;
                end
                info = [sub j k i t (G(ind))];
                if i ~= 4
                    TableData = [TableData;info];
                end

            end
        end
    end
end

T = array2table(TableData);
T.Properties.VariableNames(1:6) = {'Subject','Motion','Direction','Coupling','Type','Gain'};
writetable(T,Type+"_Data.csv")

end