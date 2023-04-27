function  PlotGVSTTSPerceptionSHOTonly(Shot_Label,GVS_Label, tilt,shot,GVS, time,colors,prof2plot,match_list)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    figure; 
%     subplot(3,1,1)
    plot(time,tilt(:,3), 'k');
    pos_legend(1) = "TTS Commanded Tilt";
    hold on;
    pos_length = length(prof2plot);
    for i = 1:pos_length
        color_index = 1;
        for j = 1:length(match_list)
            if contains(Shot_Label(prof2plot(i)), match_list(j))
                color_index = j+1;
                continue;
            end
        end
        plot(time,shot(:,prof2plot(i)), colors(color_index))
       
        line_label = char(Shot_Label(prof2plot(i)));
        pos_legend(i+1) =(strrep(line_label(1:13), '_', '.'));
    end
    legend(pos_legend)
    xlabel('Time (s)');
    ylabel('Tilt (degrees)')
    
    ylim([-15 15]);
    xlim([0 35]);
    
%     subplot(3,1,2)
%     plot(time, tilt(:,2))
%     xlabel('Time (s)');
%     ylabel('Angular Velocity (degrees/s)')
%      xlim([0 35]);
% 
%     [gvs_prof] = find(contains(GVS_Label, 'command')); %'command'
% %     gvs_colors=['g'; 'g';'c'; 'c';'b';'b' ; colors];% PS1002
%     gvs_colors=['g'; 'c'; 'b' ; colors];% PS1003 and 4
% 
%     subplot(3,1,3)
%     gvs_legend(1) = "test";
%     for i = 1:length(gvs_prof)
%         if find(prof2plot == (gvs_prof(i)-2*(i-1)))
%             plot(time,GVS(:,gvs_prof(i)), gvs_colors(i))
%             hold on;
%             line_label = char(GVS_Label(gvs_prof(i)));
% %             gvs_legend(i) =(strrep(line_label(1:13), '_', '.'));
%         end
%     end
% %     legend(gvs_legend)
%     xlabel('Time (s)');
%     ylabel('Current (mA)')
%     xlim([0 35]);

    hold off;


end