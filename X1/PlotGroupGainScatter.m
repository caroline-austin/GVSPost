function PlotGroupGainScatter(Type)
% Plots of Dynamic Data
% 7/28/23
% Made by Aaron
Var = load("DynamicData.mat");

% User Definied
%Type = 'Angle' (7.0), 'Velocity' (8.0), or 'Semi' (7.5)
LW = 2;
LS = {"-","-","-"};
colors;
LC = [redseq(80,:);redseq(50,:);redseq(20,:)];
LC = [red;blue;green];
LC = [226 107 109;128 128 128;90 160 163]/255;


%% Make Figure

switch Type
    case 'Angle'
        conditions = [5 4 1];
        Title = 'Angle Coupled GVS';
    case 'Velocity'
        conditions = [7 4 3];
        Title = 'Velocity Coupled GVS';
    case 'Semi'
        conditions = [6 4 2];
        Title = 'Semi Coupled GVS';
end
motions = ["4","5","6"];

figure;
t=tiledlayout(3,2,'TileSpacing','tight');
for j = 1:3
    for k = 1:2
        nexttile
        hold on
        if k == 1
            dir = "A";
        else
            dir = "B";
        end
        for i = 1:3
            condition = conditions(i);
            motion = motions(j);
    
            tiltname = "tilt_"+motion+dir;
            tiltang = Var.(tiltname);
            
            shot_name = "All_shot_"+motion+dir;
            shot_data = Var.(shot_name);
            perceptions = shot_data(:,condition);
    

            delta = perceptions - tiltang(:,1);

            if strcmp(Type,'Angle') == 1
                current = tiltang(:,1);
                sc = red;
            elseif strcmp(Type,'Velocity')==1 
                current = tiltang(:,3);
                sc = blue;
            elseif strcmp(Type,'Semi')==1
                current = 0.5*tiltang(:,3)+0.5*tiltang(:,1);
                sc = green;
            end
            current = current*4/max(current);

            scatter(current,delta,50,'filled','color',LC(i,:),...
                'markeredgecolor','k','MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5)

        end
        hold off
        ylim([-15 15])
        set(gca,'FontSize',16)
        if k ~= 1
            yticks([])
        else
            ylabel('\Delta Tilt (deg)')
            yticks(-10:5:10)
        end
        if j ~= 3
            xticks([])
        else
            xlabel('Current (mA)')
            xticks([-4 0 4])
        end
        if k == 2 && j ==2
            ylabel('Mirrored Motions')
        end
    end
end
title(t,Title,'Fontsize',16)

end