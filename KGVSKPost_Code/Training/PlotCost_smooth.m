clc;clear;
colors;

% name run
name = 'Pitch10.mat';
load(name)


plotSmooth = 0; % smoothed or raw grid data
Normalize = 0; % Normalize cost functions
conts = "dyncont"; % 'statcont' or 'dyncont' for contour data

%% Normalization
if Normalize == 1
    maxDyn = max(max(J_dyn));
    minDyn = min(min(J_dyn));
    J_dyn = (J_dyn-minDyn)/(maxDyn-minDyn);
end

%% Overlay

f=figure('Renderer', 'painters', 'Position', [10 10 1100 600]);
% figure;
tiledlayout(1,length(conts),'TileSpacing','tight')

for t= 1:length(conts)
    nt = nexttile;
    cont = conts(t);
    
    hold on 
    [X,Y] = meshgrid(Ratio_range,GVS_range);
    [p2,p1] = find(J_dyn == min(min(J_dyn)));
    [p4,p3] = find(J_dyn == (min(J_dyn)));
    
    p = polyfit(Ratio_range(p3),GVS_range(p4), 5);
    v = polyval(p, Ratio_range);
    
    switch cont 
        case 'dyncont'
            % contourf(X,Y,J_dyn,'EdgeColor','none'); 
            contourf(X,Y,J_dyn,5); 
            contname = 'Dynamic Cost J_{MMSE}';
        case 'statcont'
            contourf(X,Y,J_static,0:0.01:2.2,'EdgeColor','none'); 
            contname = 'Static Cost J_{MMSE}';
    end

    if Normalize == 1 && t==1
        %no colors
    else
        colorbar;
    end
    colormap(diverg3) 

    if Normalize == 1
        clim(nt,[0, 0.2])
    else
        % no linking
    end
    
    if plotSmooth == 1
        plot(Ratio_range,v,'color',[0.5 0.5 0.5]*2,'LineWidth',2)
    else
        plot(Ratio_range(p3),GVS_range(p4),'color',[0.5 0.5 0.5]*2,'LineWidth',2)
    end
    
    
    
    hold off
    xlabel('K_{Reg}')
    if t == 1
        ylabel('K_{GVS}')
    else
        yticks([])
    end
    
    set(gca,'FontSize',30)
    legend(contname,'Dynamic Best Front','Static Best Front')
end