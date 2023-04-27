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
    

    hold off;


end