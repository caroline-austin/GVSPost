Type = '4A';
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

% switch Type
%     case 'Velocity'
%         conditions = [5 4 1];
%         Title = 'Velocity Coupled GVS';
%     case 'Angle'
%         conditions = [7 4 3];
%         Title = 'Angle Coupled GVS';
%     case 'Semi'
%         conditions = [6 4 2];
%         Title = 'Semi Coupled GVS';
% end
Title = Type;
conditions = [5 4 1; 6 4 2; 7 4 3 ];
motions = ["4"];

f=figure;
t=tiledlayout(3,2,'TileSpacing','tight');
for j = 1:3
     for k = 1:2
        nexttile
        hold on
        
        for i = 1:3
            condition = conditions(j,i);
%             motion = motions(j);
    
            tiltname = "tilt_"+Type;
            tiltang = Var.(tiltname);
    
            T = length(tiltang)*0.02;
            dt = 0.02;
            time = (0:dt:T-dt)';
            
            if k == 2 % plot the shot report
                shot_name = "All_shot_"+Type;
                shot_data = Var.(shot_name);
                perceptions = shot_data(:,condition);
                sem_name = "SEM_shot_save_"+Type;
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

            else
                % plot GVS stuff
                GVS_name = "All_GVS_"+Type;
                GVS_data = Var.(GVS_name);
                stimulations = GVS_data(:,condition);

                timeplot = 0:dt*2:T;
                angplot = interp1(time,tiltang(:,1),timeplot);
                stimplot = interp1(time,stimulations,timeplot);
                plot(timeplot,angplot,'LineWidth',LW,'color',[0 0 0]);
                plot(timeplot(1:end-5),stimplot(6:end),'-','LineWidth',LW,'color',...
                    LC(i,:),'LineStyle',LS(i))
            end
            
            % if strcmp(Type,'Velocity')==1 && i == 3
            %     plot(time,tiltang(:,3),'LineWidth',LW,'Color',[0.5 0.5 0.5 0.5],'LineStyle','--')
            % elseif strcmp(Type,'Semi')==1 && i == 3
            %     plot(time,0.5*tiltang(:,3)+0.5*tiltang(:,1),'LineWidth',LW,'Color',[0.5 0.5 0.5 0.5],'LineStyle','--')
            % end
        end
        hold off
        ylim([-20 20])
        set(gca,'FontSize',16)
        if k == 2
            ylabel('Tilt (deg)')
            yticks([-10 0 10])
        elseif k == 1
        
%             ylabel('Tilt (deg)')
            yticks([-10 0 10])
        end
            
        if j ~= 3
            xticks([])
        else
            xlabel('Time(s)')
            xticks(0:5:25)
        end
        if k ==2 && j==1
            title('Perceptions')
        end
        if k == 1 && j ==1
            title('Coupled GVS Profiles')
            ylabel('Velocity (mA)')
        elseif k == 1 && j ==2
            ylabel('Semi (mA)')
        elseif k == 1 && j ==3
            ylabel('Angle (mA)')
        end
     end
end
% title(t,Title,'Fontsize',16)
legend({'Physical Tilt','Amplifying','','','','','No GVS','','','','','Attenuating'},'Position',[0.8 0.325 0.15 0.15])
f.Position = [100 100 1000 500];