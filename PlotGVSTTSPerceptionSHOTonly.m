function  PlotGVSTTSPerceptionSHOTonly(Shot_Label,GVS_Label, tilt,shot,plot_mult, time,colors,prof2plot,match_list)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if plot_mult
    hold on;
else
    figure; 
end
%     subplot(3,1,1)
    plot(time,tilt(:,3), 'k');
    pos_legend(1) = "TTS Commanded Tilt";
    hold on;
    pos_length = length(prof2plot);
    %plot each of the shot reports one at a time
    for i = 1:pos_length 
        %first figure out what the color will be
        color_index = 1;
        for j = 1:length(match_list)
            %get the index (j) where the shot label matches one of the
            %predefined current/prop combinations listed in match_list
            if contains(Shot_Label(prof2plot(i)), match_list(j))
                % offset by one from the matching index because the 
                % color list should include a default color as the first
                % index
                color_index = j+1; 
                continue;
            end
        end
        
        plot(time,shot(:,prof2plot(i)), colors(color_index))
       %save the label as part of the legend
        line_label = char(Shot_Label(prof2plot(i)));
        pos_legend(i+1) =(strrep(match_list(color_index-1), '_', '.'));
    end
    pos_legend = strrep(pos_legend, '7.00', 'Velocity');
    pos_legend = strrep(pos_legend, '7.50', 'Angle&Velocity');
    pos_legend = strrep(pos_legend, '8.00', 'Angle');
    pos_legend = strrep(pos_legend, '8.00', '');
    legend(pos_legend)
    xlabel('Time (s)');
    ylabel('Tilt (degrees)')
    
    ylim([-15 15]);
    xlim([0 35]);
    

    hold off;


end