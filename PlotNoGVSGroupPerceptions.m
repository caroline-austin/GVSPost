function PlotNoGVSGroupPerceptions()
% Plots of Dynamic Data
% 7/28/23
% Made by Aaron

% User Definied
%Type = 'Angle' (7.0), 'Velocity' (8.0), or 'Semi' (7.5)
LW = 2;
LS = {"-","-","-"};
colors;
LC = [226 107 109;128 128 128;90 160 163]/255;


%% Make Figure
NetMSE =0;
NetAvgSEM = 0;

conditions = [4 4 4];
motions = ["4","5","6"];

f=figure;
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
        for i = 2
            condition = conditions(i);
            motion = motions(j);
    
            tiltname = "tilt_"+motion+dir;
            tiltang = Var.(tiltname);
    
            T = length(tiltang)*0.02;
            dt = 0.02;
            time = (0:dt:T-dt)';
            
            shot_name = "All_shot_"+motion+dir;
            shot_data = Var.(shot_name);
            perceptions = shot_data(:,condition);
            sem_name = "SEM_shot_save_"+motion+dir;
            SEM = Var.(sem_name);
            percSEM = SEM(:,condition);
    
            % PostProcess
            timeplot = 0:dt*2:T;
            angplot = interp1(time,tiltang(:,1),timeplot);
            percplot = interp1(time,perceptions,timeplot);
            semplot = interp1(time,percSEM,timeplot);

            MSE = 1/size(percplot,2)*(percplot-angplot)*(percplot-angplot)';
            avgSEM = 1/size(semplot,2)*sum(semplot);
    
            plot(timeplot,angplot,'LineWidth',LW,'color',[0 0 0]);
            plot(timeplot,percplot,'-','LineWidth',LW,'color',...
                LC(i,:),'LineStyle',LS(i))
            
            % Plot SEM
            plot(timeplot, percplot-semplot, 'color',LC(i,:), 'LineWidth', 1);
            plot(timeplot, percplot+semplot, 'color',LC(i,:), 'LineWidth',1);
            x2 = [timeplot, fliplr(timeplot)];
            inBetween = [percplot-semplot, fliplr(percplot+semplot)];
            fill(x2, inBetween,LC(i,:),'FaceAlpha',0.3);
            
            text(timeplot(end)/4,12,"MSE = "+num2str(MSE))
            text(timeplot(end)*3/4,12,"avgSEM = "+num2str(avgSEM))

            NetMSE = NetMSE + MSE;
            NetAvgSEM = NetAvgSEM + avgSEM;
        end
        hold off
        ylim([-20 20])
        set(gca,'FontSize',16)
        if k ~= 1
            yticks([])
        else
            ylabel('Tilt (deg)')
            yticks([-10 0 10])
        end
        if j ~= 3
            xticks([])
        else
            xlabel('Time(s)')
            xticks(0:5:25)
        end
        if k == 2 && j ==2
            ylabel('Mirrored Motions')
        end
    end
end
Title = "Net MSE = "+num2str(NetMSE)+" | "+"Net avgSME = "+num2str(NetAvgSEM);
title(t,Title,'Fontsize',16)
f.Position = [100 100 1000 500];
end