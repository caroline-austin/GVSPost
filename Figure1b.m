function Figure1b(Var)
% Plots of Dynamic Data
% 7/28/23
% Made by Aaron

% User Definied
%Type = 'Angle' (7.0), 'Velocity' (8.0), or 'Semi' (7.5)
LW = 2;
LS = {"-","-","-"};
colors;
% LC = [redseq(80,:);redseq(50,:);redseq(20,:)];
% LC = [red;blue;green];
LC = [226 107 109;128 128 128;90 160 163]/255;
LC(1,:) = red;
LC(3,:) = blue;


%% Make Figure
dir = "B";
nummot = 1; %number of motions to plot
motions = ["4";"5";"6"];

f=figure('Renderer', 'painters');
tiledlayout(4*nummot,3,'TileSpacing','none');
for d = 1:nummot
    motion = motions(d);
    for j = 1:2
        for k = 1:3
            
            if k == 1
                Type = 'Angle';
            elseif k == 2
                Type = 'Velocity';
            elseif k == 3
                Type = 'Semi';
            end
            
            tiltname = "tilt_"+motion+dir;
            tiltang = Var.(tiltname);
    
            T = length(tiltang)*0.02;
            dt = 0.02;
            time = (0:dt:T-dt)';
            
            shot_name = "All_shot_"+motion+dir;
            shot_data = Var.(shot_name);
    
            switch Type
                case 'Velocity'
                    conditions = [5 4 1];
                    Title = 'Velocity Coupled GVS';
                    current = tiltang(:,3);
                case 'Angle'
                    conditions = [7 4 3];
                    Title = 'Angle Coupled GVS';
                    current = tiltang(:,1);
                case 'Semi'
                    conditions = [6 4 2];
                    Title = 'Joint Coupled GVS';
                    current = tiltang(:,3)/2+tiltang(:,1)/2;
            end
            current = current*4/max(abs(current));
    
            if j == 1
                nexttile
                hold on
                plot(time,-1*current,'LineWidth',LW,'color',LC(1,:));
                plot(time,0*current,'LineWidth',LW,'color',LC(2,:));
                plot(time,current,'LineWidth',LW,'color',LC(3,:));
                ylim([min(tiltang(:,1)) max(tiltang(:,1))])
    
            elseif j == 2
                nexttile([3,1])
                hold on
                for i = 1:3
                    condition = conditions(i);
            
                    perceptions = shot_data(:,condition);
                    sem_name = "SEM_shot_save_"+motion+dir;
                    SEM = Var.(sem_name);
                    percSEM = SEM(:,condition);
            
                    % PostProcess
                    timeplot = 0:dt*2:T;
                    angplot = interp1(time,tiltang(:,1),timeplot);
                    percplot = interp1(time,perceptions,timeplot);
                    semplot = interp1(time,percSEM,timeplot);
            
                    plot(timeplot,angplot,'LineWidth',LW,'color',[0 0 0]);
                    plot(timeplot,percplot,'-','LineWidth',LW,'color',...
                        LC(i,:),'LineStyle',LS(i))
                    
                    % Plot SEM
                    plot(timeplot, percplot-semplot, 'color',LC(i,:), 'LineWidth', 1);
                    plot(timeplot, percplot+semplot, 'color',LC(i,:), 'LineWidth',1);
                    x2 = [timeplot, fliplr(timeplot)];
                    inBetween = [percplot-semplot, fliplr(percplot+semplot)];
                    fill(x2, inBetween,LC(i,:),'FaceAlpha',0.3);
                    
                    % if strcmp(Type,'Velocity')==1 && i == 3
                    %     plot(time,tiltang(:,3),'LineWidth',LW,'Color',[0.5 0.5 0.5 0.5],'LineStyle','--')
                    % elseif strcmp(Type,'Semi')==1 && i == 3
                    %     plot(time,0.5*tiltang(:,3)+0.5*tiltang(:,1),'LineWidth',LW,'Color',[0.5 0.5 0.5 0.5],'LineStyle','--')
                    % end
                end
            end
        

        hold off
        
        
        set(gca,'FontSize',16)

        if j ~= 2 
            xticks([])
            ylim([-4 4])
            yticks([-4 0 4])
        else
            ylim([-12 15])
            yticks([-10 0 10])
        end
        if j == 1 && d ==1
            title(Title,'Fontsize',16,'FontWeight','Normal')
        end

        if k ~= 1 
            yticks([])
        else
            if j == 2
                ylabel('Tilt (deg)')
            else
                ylabel('Current (mA)')
            end
            
        end
        if j==2 && d==nummot
            xlabel('Time(s)')
            xticks([0 15])
        else 
            xticks([])
        end
        end
    end
end
legend({'Physical Tilt','Positive Coupling','','','','','No GVS','','','','','Negative Coupling'},'Position',[0.8 0.325 0.15 0.15])
f.Position = [100 100 1250 300*nummot];
end