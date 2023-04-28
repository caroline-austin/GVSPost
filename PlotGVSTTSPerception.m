function  PlotGVSTTSPerception(Shot_Label,GVS_Label, tilt,shot,GVS, time,colors,prof2plot, match_list)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    figure; 
    %first subplot is the actual tilt and shot reports
    subplot(3,1,1)
    %plot a sample tilt (all tilt should be ~the same)
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
        pos_legend(i+1) =(strrep(match_list(color_index-1), '_', '.')); %line_label(1:13)
    end
    %make the label intuitive to readers
    gvs_match = strrep(pos_legend(2:end), '.', '_');
    pos_legend = strrep(pos_legend, '7.00', 'Velocity');
    pos_legend = strrep(pos_legend, '7.50', 'Angle&Velocity');
    pos_legend = strrep(pos_legend, '8.00', 'Angle');
    pos_legend = strrep(pos_legend, '8.00', '');
    legend(pos_legend)
    legend(pos_legend)
    xlabel('Time (s)');
    ylabel('Tilt (degrees)')
    
    ylim([-15 15]);
    xlim([0 35]);
    
    subplot(3,1,2)
    plot(time, tilt(:,2))
    xlabel('Time (s)');
    ylabel('Angular Velocity (degrees/s)')
     xlim([0 35]);

     %will want/need to change this code to match the other color selection
     %code
    [gvs_prof] = find(contains(GVS_Label, 'command')); %'command'

    subplot(3,1,3)
%     gvs_legend(1) = "test";
    for i = 1:length(gvs_prof)
        for k = 1:length(gvs_match)
            %find where the gvs profile matches the shot report profile
        loc = find(contains(GVS_Label(gvs_prof(i)), gvs_match(k)));
        if loc

            color_index = 1;
            for j = 1:length(match_list)
                if contains(GVS_Label(gvs_prof(i)), match_list(j)) 
                    color_index = j+1;
                    continue;
                end
            end
            plot(time,GVS(:,gvs_prof(i)), colors(color_index))
            hold on;
%             line_label = char(GVS_Label(gvs_prof(i)));
%             gvs_legend(i) =(strrep(match_list(color_index-1), '_', '.'));
        end
        end
    end
%     legend(gvs_legend)
    xlabel('Time (s)');
    ylabel('Current (mA)')
    xlim([0 35]);

    hold off;


end