function PlotIndPerceptions(Var,subnum)
% Plots of Dynamic Data
% 7/28/23
% Made by Aaron

% User Definied
%Type = 'Angle' (7.0), 'Velocity' (8.0), or 'Semi' (7.5)
LW = 2;
LS = {"-","-","-"};
colors;
LC = [226 107 109;128 128 128;90 160 163]/255;

shift = 2;

%% Make Figure

conditions = [1 2 4];
motions = ["4","5","6"];

f=figure;
tiledlayout(3,2,'TileSpacing','tight');
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
    
            T = length(tiltang)*0.02;
            dt = 0.02;
            time = (0:dt:T-dt)';
            
            shot_name = "shot_save_"+motion+dir;
            shot_data = Var.(shot_name);
            perceptions = reshape(shot_data(:,:,condition),size(Var.shot_save_4A,1:2));
    
            % PostProcess
            timeplot = 0:dt*2:T;
            angplot = interp1(time,tiltang(:,1),timeplot);
            percplot = interp1(time,perceptions,timeplot);
            indvdata = percplot(:,subnum);

            if shift == 1
            elseif shift == 2
                indvdata = indvdata - (indvdata(1)+indvdata(end))/2;
                indvdata = indvdata - indvdata(1);
            end

            plot(timeplot,indvdata,'-','LineWidth',LW,'LineStyle',LS(i),'Color',LC(i,:))
            plot(timeplot,angplot,'LineWidth',LW*2,'color',[0 0 0]);
            
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
f.Position = [100 100 1000 500];
end