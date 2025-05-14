% script 7
code_path = pwd; 

% note that I think the negative angle coupling is actually the amplifying
% and the positive angle coupling is actually the attenuating
%%
% Plots of Dynamic Data
% 7/28/23
% Made by Aaron
% modified by Caroline 1/5/24
% modified by Caroline 2/7/25
% DataName = "DynamicDataGain.mat";

%% Load
[filename, file_path] = uigetfile; % grab the SAllBiasTimeGain.mat file from the Data folder for this project
Var = load([file_path '/' filename]);

%%
% User Definied
%Type = 'Angle' (7.0), 'Velocity' (8.0), or 'Semi' (7.5)
LW = 2;
LS = {"-","-","-", "-"};
cd('..')
colors;
cd(code_path);
LC = [redseq(80,:);redseq(50,:);redseq(20,:)];
LC = [red;blue;green];
LC = [226 107 109;128 128 128;90 160 163]/255;


%% Make Figures - separate A and B profiles

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

prof = ["4A"; "4B"; "5A"; "5B"; "6A"; "6B"];
for m = 1:6 
    Type = prof(m);
    Title = Type;
    conditions = [4 3 1; 5 3 2];
    motions = ["4"];
    
    [row, col]=size(conditions);
    
    f=figure;
    t=tiledlayout(row,2,'TileSpacing','tight');
    for j = 1:row % number of GVS coupling schemes
         for k = 1:2 % 1 = GVS plot 2 = perception plot
            nexttile
            hold on
            
            for i = 1:col % postive/negative/sham
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
                    % yyaxis right
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
                    if condition < 3
                        stimulations = GVS_data(:,condition);
                    else % there are 6 GVS dimensions instead of 5 so need to add one 
                        stimulations = GVS_data(:,condition+1);
                    end
    
    
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
            ylim([-12 12])
            xlim([0 27])
            set(gca,'FontSize',16)
            if k == 2
                % yyaxis right
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
                title('Perceptions', FontSize= 30)
            end
            if k == 1 && j ==1
                title('Coupled GVS Waveforms', FontSize= 30)
                ylabel(' Angle (mA)')
            elseif k == 1 && j ==2
                ylabel('Optimized (mA)  ')
            end
            ax = gca;
            ax.XAxis.FontSize = 20;
            ax.YAxis.FontSize = 20;
         end
    end
    sgtitle(t,Title,'Fontsize',16)
    legend({'Physical Tilt','Amplifying','','','','','No GVS','','','','','Attenuating'},'Position',[0.8 0.325 0.15 0.15])
    f.Position = [100 100 1500 620];
    % ax = gca;
    % ax.XAxis.FontSize = 32;
    % ax.YAxis.FontSize = 32;
end

%% Make figures - combined A and B data

prof = ["4"; "5"; "6"];
for m = 1:3
    Type = prof(m);
    Title = Type;
    conditions = [4 3 1; 5 3 2];
    motions = ["4"];
    
    [row, col]=size(conditions);
    
    f=figure;
    t=tiledlayout(row,2,'TileSpacing','tight');
    for j = 1:row % number of GVS coupling schemes
         for k = 1:2 % 1 = GVS plot 2 = perception plot
            nexttile
            hold on
            
            for i = 1:3 % postive/negative/sham
                condition = conditions(j,i);
    %             motion = motions(j);
        
                tiltname = "tilt_"+Type+"A";
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
                    % yyaxis right
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
                    GVS_name = "All_GVS_"+Type+"A";
                    GVS_data = Var.(GVS_name);
                    if condition < 3
                        stimulations = GVS_data(:,condition);
                    else % there are 6 GVS dimensions instead of 5 so need to add one 
                        stimulations = GVS_data(:,condition+1);
                    end
    
    
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
            ylim([-12 12])
            xlim([0 27])
            set(gca,'FontSize',16)
            if k == 2
                % yyaxis right
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
                title('Perceptions', FontSize= 30)
            end
            if k == 1 && j ==1
                title('Coupled GVS Waveforms', FontSize= 30)
                ylabel(' Angle (mA)')
            elseif k == 1 && j ==2
                ylabel('Optimized (mA)  ')

            end
            ax = gca;
            ax.XAxis.FontSize = 20;
            ax.YAxis.FontSize = 20;
         end
    end
    sgtitle(t,Title,'Fontsize',16)
    legend({'Physical Tilt','Amplifying','','','','','No GVS','','','','','Attenuating'},'Position',[0.8 0.325 0.15 0.15])
    f.Position = [100 100 1500 620];
    % ax = gca;
    % ax.XAxis.FontSize = 32;
    % ax.YAxis.FontSize = 32;
end
%% make figure of diff from baseline
prof = ["4A"; "4B"; "5A"; "5B"; "6A"; "6B"];
LC = [226 107 109;128 128 128;128 128 128;90 160 163]/255;
for m = 1:6 
    Type = prof(m);
    Title = Type;
    conditions = [5 3 4 1; 6 3 4 2];
    motions = ["4"];
    
    [row, col]=size(conditions);
    
    f=figure;
    t=tiledlayout(row,2,'TileSpacing','tight');
    for j = 1:row % number of GVS coupling schemes
         for k = 1:2 % 1 = GVS plot 2 = perception plot
            nexttile
            hold on
            
            for i = 1:col % postive/negative/sham
                condition = conditions(j,i);
    %             motion = motions(j);
        
                tiltname = "tilt_"+Type;
                tiltang = Var.(tiltname);
        
                T = length(tiltang)*0.02;
                dt = 0.02;
                time = (0:dt:T-dt)';
                
                if k == 2 % plot the shot report
                    shot_name = "All_shot_diff_"+Type;
                    shot_data = Var.(shot_name);
                    perceptions = shot_data(:,condition);
                    sem_name = "SEM_shot_diff_"+Type;
                    SEM = Var.(sem_name);
                    percSEM = SEM(:,condition);
            
                 
                    % PostProcess
                    timeplot = 0:dt*2:T;
                    angplot = interp1(time,tiltang(:,1),timeplot);
                    percplot = interp1(time,perceptions,timeplot);
                    semplot = interp1(time,percSEM,timeplot);
                    % yyaxis right
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
            ylim([-8 8])
            xlim([0 27])
            set(gca,'FontSize',16)
            if k == 2
                % yyaxis right
                ylabel('Tilt (deg)')
                yticks([-8 0 8])
            elseif k == 1
            
    %             ylabel('Tilt (deg)')
                yticks([-8 0 8])
            end
                
            if j ~= 3
                xticks([])
            else
                xlabel('Time(s)')
                xticks(0:5:25)
            end
            if k ==2 && j==1
                title('Perceptions', FontSize= 30)
            end
            if k == 1 && j ==1
                title('Coupled GVS Waveforms', FontSize= 30)
                ylabel(' Angle (mA)')
            elseif k == 1 && j ==2
                ylabel('Optimized (mA)  ')
            end
            ax = gca;
            ax.XAxis.FontSize = 20;
            ax.YAxis.FontSize = 20;
         end
    end
    sgtitle(t,Title,'Fontsize',16)
    legend({'Physical Tilt','Amplifying','','','','','No GVS','','','','','Attenuating'},'Position',[0.8 0.325 0.15 0.15])
    f.Position = [100 100 1500 620];
    % ax = gca;
    % ax.XAxis.FontSize = 32;
    % ax.YAxis.FontSize = 32;
end
%%
%% Make figures - combined A and B  diff from baseline
LC = [226 107 109;128 128 128;128 128 128;90 160 163]/255;
prof = ["4"; "5"; "6"];
for m = 1:3
    Type = prof(m);
    Title = Type;
    conditions = [5 3 4 1; 6 3 4 2];
    motions = ["4"];
    
    [row, col]=size(conditions);
    
    f=figure;
    t=tiledlayout(row,2,'TileSpacing','tight');
    for j = 1:row % number of GVS coupling schemes
         for k = 1:2 % 1 = GVS plot 2 = perception plot
            nexttile
            hold on
            
            for i = 1:col % postive/negative/sham
                condition = conditions(j,i);
    %             motion = motions(j);
        
                tiltname = "tilt_"+Type+"A";
                tiltang = Var.(tiltname);
        
                T = length(tiltang)*0.02;
                dt = 0.02;
                time = (0:dt:T-dt)';
                
                if k == 2 % plot the shot report
                    shot_name = "All_shot_diff_"+Type;
                    shot_data = Var.(shot_name);
                    perceptions = shot_data(:,condition);
                    sem_name = "SEM_shot_diff_"+Type;
                    SEM = Var.(sem_name);
                    percSEM = SEM(:,condition);
            
                 
                    % PostProcess
                    timeplot = 0:dt*2:T;
                    angplot = interp1(time,tiltang(:,1),timeplot);
                    percplot = interp1(time,perceptions,timeplot);
                    semplot = interp1(time,percSEM,timeplot);
                    % yyaxis right
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
                    GVS_name = "All_GVS_"+Type+"A";
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
            ylim([-8 8])
            xlim([0 27])
            set(gca,'FontSize',16)
            if k == 2
                % yyaxis right
                ylabel('Tilt (deg)')
                yticks([-8 0 8])
            elseif k == 1
            
    %             ylabel('Tilt (deg)')
                yticks([-8 0 8])
            end
                
            if j ~= 3
                xticks([])
            else
                xlabel('Time(s)')
                xticks(0:5:25)
            end
            if k ==2 && j==1
                title('Perceptions', FontSize= 30)
            end
            if k == 1 && j ==1
                title('Coupled GVS Waveforms', FontSize= 30)
                ylabel(' Angle (mA)')
            elseif k == 1 && j ==2
                ylabel('Optimized (mA)  ')

            end
            ax = gca;
            ax.XAxis.FontSize = 20;
            ax.YAxis.FontSize = 20;
         end
    end
    sgtitle(t,Title,'Fontsize',16)
    legend({'Physical Tilt','Amplifying','','','','','No GVS','','','','','No GVS', '', '', '', '', 'Attenuating'},'Position',[0.8 0.325 0.15 0.15])
    f.Position = [100 100 1500 620];
    % ax = gca;
    % ax.XAxis.FontSize = 32;
    % ax.YAxis.FontSize = 32;
end

%% make figures - just tilt and GVS

LW = 3;
prof = ["4A"];
for m = 1 % length of prof
    Type = prof(m);
    Title = Type;
    
    [row, col]=size(conditions);
    
    f=figure;
    t=tiledlayout(4,1,'TileSpacing','tight');

    nexttile
    hold on
    
    tiltname = "tilt_"+Type;
    tiltang = Var.(tiltname);


    timeplot = 0:dt*2:T;
    angplot = interp1(time,tiltang(:,1),timeplot);
    plot(timeplot,angplot,'LineWidth',LW,'color',[0 0 0]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    ylabel('Tilt (deg)')
    yticks([-10 0 10])
    title('TTS Tilt Profile', FontSize= 30)
    xticks([])

    
     % plot GVS stuff
    nexttile
    hold on

    GVS_name = "All_GVS_"+Type;
    GVS_data = Var.(GVS_name);
    stimulations = GVS_data(:,5);
    stimplot = interp1(time,stimulations,timeplot);
    plot(timeplot(1:end-5),stimplot(6:end),'-','LineWidth',LW,'color',...
        LC(1,:),'LineStyle',LS(1))
    
    yticks([-5 0 5])
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    title(' Angle Coupled ', FontSize= 30)
    xticks([])

    nexttile
    hold on

    GVS_name = "All_GVS_"+Type;
    GVS_data = Var.(GVS_name);
    stimulations = GVS_data(:,6);
    stimplot = interp1(time,stimulations,timeplot);
    plot(timeplot(1:end-5),stimplot(6:end),'-','LineWidth',LW,'color',...
        LC(1,:),'LineStyle',LS(1))
    yticks([-5 0 5])
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    title('Optimized for Amplification',FontSize= 30)
    ylabel("Current (mA)")
    xticks([])

    nexttile
    hold on

    GVS_name = "All_GVS_"+Type;
    GVS_data = Var.(GVS_name);
    stimulations = GVS_data(:,2);
    stimplot = interp1(time,stimulations,timeplot);
    plot(timeplot(1:end-5),stimplot(6:end),'-','LineWidth',LW,'color',...
        LC(3,:),'LineStyle',LS(3))
    yticks([-5 0 5])
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
        title('Optimized for Attenuation', FontSize= 30)
        xlabel('Time(s)')
                xticks(0:5:25)




        ax = gca;
        ax.XAxis.FontSize = 20;
        ax.YAxis.FontSize = 20;

    % sgtitle(t,Title,'Fontsize',16)
    f.Position = [100 100 1500 620];
    % ax = gca;
    % ax.XAxis.FontSize = 32;
    % ax.YAxis.FontSize = 32;
end