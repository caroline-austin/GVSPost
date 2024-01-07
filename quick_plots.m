plot(All_avg_net_over_4A);
hold on; plot(All_avg_net_over_5A);
hold on; plot(All_avg_net_over_6A);
hold on; plot(All_avg_net_over_4B);
hold on; plot(All_avg_net_over_5B);
hold on; plot(All_avg_net_over_6B);
title("Sum of All Overestimation Averaged Across Subjects ")
xlabel("GVS Coupling")
ylabel("Total Tilt Over Estimation")
legend(["4A"; "5A"; "6A"; "4B";"5B"; "6B" ]);
xticks([1 2 3 4 5 6 7]);
    xticklabels(plot_list);


    plot(GVS_4A(:,1),shot_4A(:,1), 'o');
hold on; plot(GVS_4A(:,4),shot_4A(:,2), 'o');
hold on; plot(GVS_4A(:,7),shot_4A(:,3), 'o');
title("Tilt Perception V. GVS applied Attenuating")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
legend(Label.shot_4A(1:3))

 
 plot(GVS_4A(:,16),shot_4A(:,6), 'o');
hold on; plot(GVS_4A(:,19),shot_4A(:,7), 'o');
hold on; plot(GVS_4A(:,22),shot_4A(:,8), 'o');
title("Tilt Perception V. GVS applied Amplifying")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
legend(Label.shot_4A(6:end))

%%
    plot(tilt_4A(:,1),shot_4A(:,1), 'o');
hold on; plot(tilt_4A(:,4),shot_4A(:,2), 'o');
hold on; plot(tilt_4A(:,7),shot_4A(:,3), 'o');
hold on; plot(tilt_4A(:,10),shot_4A(:,4), 'o');
hold on; plot(tilt_4A(:,13),shot_4A(:,5), 'o');
title("Tilt Perception V. Actual Tilt Attenuating")
xlabel("Actual Tilt Angle")
ylabel ("Percieved Tilt Angle")
legend(Label.shot_4A(1:5))
hold off;
 figure;
 plot(tilt_4A(:,16),shot_4A(:,6), 'o');
 hold on; plot(tilt_4A(:,10),shot_4A(:,4), 'o');
hold on; plot(tilt_4A(:,13),shot_4A(:,5), 'o');
hold on; plot(tilt_4A(:,19),shot_4A(:,7), 'o');
hold on; plot(tilt_4A(:,22),shot_4A(:,8), 'o');
title("Tilt Perception V. Actual Tilt  Amplifying")
xlabel("Actual Tilt Angle")
ylabel ("Percieved Tilt Angle")
legend(Label.shot_4A(4:end))

%% tilt angle 4A
close all;
    plot(tilt_4A(:,10),All_shot_4A(:,4), 'o');
hold on; plot(tilt_4A(:,1),All_shot_4A(:,1), 'o');
hold on; plot(tilt_4A(:,4),All_shot_4A(:,2), 'o');
hold on; plot(tilt_4A(:,7),All_shot_4A(:,3), 'o');
lsline
title("Tilt Perception V. Actual Tilt Attenuating 4A")
xlabel("Actual Tilt Angle")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend([Label.shot_4A(4) Label.shot_4A(1:3)'])
hold off;
 figure;
 plot(tilt_4A(:,10),All_shot_4A(:,4), 'o');
 hold on; plot(tilt_4A(:,13),All_shot_4A(:,5), 'o');
 hold on; plot(tilt_4A(:,16),All_shot_4A(:,6), 'o');
 hold on; plot(tilt_4A(:,19),All_shot_4A(:,7), 'o');
 lsline
title("Tilt Perception V. Actual Tilt  Amplifying 4A")
xlabel("Actual Tilt Angle")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend(Label.shot_4A(4:end))

%% tilt angle 5B
close all;
    plot(tilt_5B(:,10),All_shot_5B(:,4), 'o');
hold on; plot(tilt_5B(:,1),All_shot_5B(:,1), 'o');
hold on; plot(tilt_5B(:,4),All_shot_5B(:,2), 'o');
hold on; plot(tilt_5B(:,7),All_shot_5B(:,3), 'o');

title("Tilt Perception V. Actual Tilt Attenuating 5B")
xlabel("Actual Tilt Angle")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend([Label.shot_5B(4) Label.shot_5B(1:3)'])
hold off;
 figure;
 plot(tilt_5B(:,10),All_shot_5B(:,4), 'o');
 hold on; plot(tilt_5B(:,13),All_shot_5B(:,5), 'o');
 hold on; plot(tilt_5B(:,16),All_shot_5B(:,6), 'o');
 hold on; plot(tilt_5B(:,19),All_shot_5B(:,7), 'o');
title("Tilt Perception V. Actual Tilt  Amplifying 5B")
xlabel("Actual Tilt Angle")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend(Label.shot_5B(4:end))

%% tilt angle 6A
close all;
    plot(tilt_6A(:,10),All_shot_6A(:,4), 'o');
hold on; plot(tilt_6A(:,1),All_shot_6A(:,1), 'o');
hold on; plot(tilt_6A(:,4),All_shot_6A(:,2), 'o');
hold on; plot(tilt_6A(:,7),All_shot_6A(:,3), 'o');

title("Tilt Perception V. Actual Tilt Attenuating 6A")
xlabel("Actual Tilt Angle")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend([Label.shot_6A(4) Label.shot_6A(1:3)'])
hold off;
 figure;
 plot(tilt_6A(:,10),All_shot_6A(:,4), 'o');
 hold on; plot(tilt_6A(:,13),All_shot_6A(:,5), 'o');
 hold on; plot(tilt_6A(:,16),All_shot_6A(:,6), 'o');
 hold on; plot(tilt_6A(:,19),All_shot_6A(:,7), 'o');
title("Tilt Perception V. Actual Tilt  Amplifying 6A")
xlabel("Actual Tilt Angle")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend(Label.shot_6A(4:end))

%% GVS 4A
close all;
    plot(GVS_4A(:,10),All_shot_4A(:,4), 'o');
hold on; plot(GVS_4A(:,1),All_shot_4A(:,1), 'o');
hold on; plot(GVS_4A(:,4),All_shot_4A(:,2), 'o');
hold on; plot(GVS_4A(:,7),All_shot_4A(:,3), 'o');
lsline
title("Tilt Perception V. GVS Attenuating 4A")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend([Label.shot_4A(4) Label.shot_4A(1:3)'])
hold off;
 figure;
 plot(GVS_4A(:,10),All_shot_4A(:,4), 'o');
 hold on; plot(GVS_4A(:,16),All_shot_4A(:,5), 'o');
 hold on; plot(GVS_4A(:,19),All_shot_4A(:,6), 'o');
 hold on; plot(GVS_4A(:,22),All_shot_4A(:,7), 'o');
 lsline
title("Tilt Perception V. GVS  Amplifying 4A")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend(Label.shot_4A(4:end))
%% 5B
close all;
    plot(GVS_5B(:,10),All_shot_5B(:,4), 'o');
hold on; plot(GVS_5B(:,1),All_shot_5B(:,1), 'o');
hold on; plot(GVS_5B(:,4),All_shot_5B(:,2), 'o');
hold on; plot(GVS_5B(:,7),All_shot_5B(:,3), 'o');
lsline

title("Tilt Perception V. GVS Attenuating 5B")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend([Label.shot_5B(4) Label.shot_5B(1:3)'])
hold off;
 figure;
 plot(GVS_5B(:,10),All_shot_5B(:,4), 'o');
 hold on; plot(GVS_5B(:,16),All_shot_5B(:,5), 'o');
 hold on; plot(GVS_5B(:,19),All_shot_5B(:,6), 'o');
 hold on; plot(GVS_5B(:,22),All_shot_5B(:,7), 'o');
 lsline
title("Tilt Perception V. GVS  Amplifying 5B")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend(Label.shot_5B(4:end))
%% 6A
close all;
    plot(GVS_6A(:,10),All_shot_6A(:,4), 'o');
hold on; plot(GVS_6A(:,1),All_shot_6A(:,1), 'o');
hold on; plot(GVS_6A(:,4),All_shot_6A(:,2), 'o');
hold on; plot(GVS_6A(:,7),All_shot_6A(:,3), 'o');
lsline

title("Tilt Perception V. GVS Attenuating 6A")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend([Label.shot_6A(4) Label.shot_6A(1:3)'])
hold off;
 figure;
 plot(GVS_6A(:,10),All_shot_6A(:,4), 'o');
 hold on; plot(GVS_6A(:,16),All_shot_6A(:,5), 'o');
 hold on; plot(GVS_6A(:,19),All_shot_6A(:,6), 'o');
 hold on; plot(GVS_6A(:,22),All_shot_6A(:,7), 'o');
 lsline

title("Tilt Perception V. GVS  Amplifying 6A")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend(Label.shot_6A(4:end))

%%
[p(1,:), s(1), mu(:,1)] = polyfit(GVS_4A(:,1), All_shot_4A(:,1),1); %"Intercept", false);
[p(2,:), s(2), mu(:,2)] = polyfit(GVS_4A(:,4), All_shot_4A(:,2),1);
[p(3,:), s(3), mu(:,3)] = polyfit(GVS_4A(:,7), All_shot_4A(:,3),1);
[p(4,:), s(4), mu(:,4)] = polyfit(GVS_4A(:,10), All_shot_4A(:,4),1);

[p(5,:), s(5), mu(:,5)] = polyfit(GVS_4A(:,16), All_shot_4A(:,5),1);
[p(6,:), s(6), mu(:,6)] = polyfit(GVS_4A(:,19), All_shot_4A(:,6),1);
[p(7,:), s(7), mu(:,7)] = polyfit(GVS_4A(:,22), All_shot_4A(:,7),1);

x1 = linspace(-4,4);
y1(1,:) = polyval(p(:,1),x1);
plot(x1,y1);
%%
[LM_4A.N7] = fitlm(GVS_4A(:,1), All_shot_4A(:,1),"Intercept", false);
slope_4A(1) = LM_4A.N7.Coefficients.Estimate;


[LM_N75_4A] = fitlm(GVS_4A(:,4), All_shot_4A(:,2),"Intercept", false);
slope_4A(2) = LM_N75_4A.Coefficients.Estimate;
[LM_N8_4A] = fitlm(GVS_4A(:,7), All_shot_4A(:,3),"Intercept", false);
slope_4A(3) = LM_N8_4A.Coefficients.Estimate;
[LM_00_4A] = fitlm(GVS_4A(:,10), All_shot_4A(:,4),"Intercept", false);
slope_4A(4) = LM_00_4A.Coefficients.Estimate;
[LM_P7_4A] = fitlm(GVS_4A(:,16), All_shot_4A(:,5),"Intercept", false);
slope_4A(5) = LM_P7_4A.Coefficients.Estimate;
[LM_P75_4A] = fitlm(GVS_4A(:,19), All_shot_4A(:,6),"Intercept", false);
slope_4A(6) = LM_P75_4A.Coefficients.Estimate;
[LM_P8_4A] = fitlm(GVS_4A(:,22), All_shot_4A(:,7),"Intercept", false);
slope_4A(7) = LM_P8_4A.Coefficients.Estimate;

y1(1,:)= x1*slope_4A(1);
y1(2,:)= x1*slope_4A(2);
y1(3,:)= x1*slope_4A(3);
y1(4,:)= x1*slope_4A(4);
y1(5,:)= x1*slope_4A(5);
y1(6,:)= x1*slope_4A(6);
y1(7,:)= x1*slope_4A(7);
plot(x1,y1)
legend(Label.shot_4A);

plot(slope_4A);


%% GVS 4A
close all;
    plot(GVS_4A(:,10),All_shot_4A(:,4), 'o');
hold on; plot(GVS_4A(:,1),All_shot_4A(:,1), 'o');
hold on; plot(GVS_4A(:,4),All_shot_4A(:,2), 'o');
hold on; plot(GVS_4A(:,7),All_shot_4A(:,3), 'o');
lsline
title("Tilt Perception V. GVS Attenuating 4A")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend([Label.shot_4A(4) Label.shot_4A(1:3)'])
hold off;
 figure;
 plot(GVS_4A(:,10),All_shot_4A(:,4), 'o');
 hold on; plot(GVS_4A(:,16),All_shot_4A(:,5), 'o');
 hold on; plot(GVS_4A(:,19),All_shot_4A(:,6), 'o');
 hold on; plot(GVS_4A(:,22),All_shot_4A(:,7), 'o');
 lsline
title("Tilt Perception V. GVS  Amplifying 4A")
xlabel("Current mA")
ylabel ("Percieved Tilt Angle")
ylim([-20 20])
legend(Label.shot_4A(4:end))

%% plot tilt slope against rating with subject symbols
% used for IEEE paper
%load  GVS Susceptibility and perception v. GVS and perception v. tilt
%(sham removed)
 tilt_slope = slope_save_all;

sub_symbols = [ "pentagram";"<";"hexagram";">"; "diamond";"v";"o";"+"; "*"; "x"; "square"; "^"; ];
figure;
tiledlayout(2,3,'TileSpacing','tight')
for j = 1:7
    
    if j ~= 4
        nexttile 
    plot(MotionRating_min_save(:,3), tilt_slope(:,j),'.','MarkerSize',0.1); 
    eval(["h" + Label_slope(j) + "=lsline;"])
    eval(["line_y(j,:)=h" + Label_slope(j) + ".YData;"])
    corr_slope(j)=(line_y(j,2)-line_y(j,1))/3;
    hold on;
    for i = 1:length(tilt_slope)
        plot(MotionRating_min_save(i,3), tilt_slope(i,j),sub_symbols(i),'MarkerSize',20, "Color","black", "LineWidth", 2);
        hold on;
    end
    xlim([1,4.1])
    xticks([1,2,3,4])
    if j == 1 
            ylabel({'';'Attenuating'},FontSize=30)
            yticks([-.5 0 ])
    elseif j ==5
            ylabel({'                                  Normalized Perception/Tilt (Deg/Deg)';'Amplifying'},FontSize=30)
            
            yticks([ 0 0.5])
    else
            yticks([])
            
    end

    if j == 1
        ylim([-0.6, 0])
        xticks([])
        ax = gca;
        ax.YAxis.FontSize = 25;
        title("Velocity",FontSize=30)
    elseif  j ==2
        ylim([-0.6, 0])
        xticks([])
        ax = gca;
%         ax.YAxis.FontSize = 25;
        title("Semi",FontSize=30)
    elseif j ==3 
        ylim([-0.6, 0])
        xticks([])
        ax = gca;
%         ax.YAxis.FontSize = 25;
        title("Angle",FontSize=30)
    elseif j ==5
        ylim([0, .6])
        ax = gca;
        ax.XAxis.FontSize = 25;
        
        ax.YAxis.FontSize = 25;
%         ylabel('Amplifying',FontSize=30)
    elseif j == 7
        ylim([0, .6])
        ax = gca;
        ax.XAxis.FontSize = 25;
    elseif j == 6
        ylim([0, .6])
        ax = gca;
        ax.XAxis.FontSize = 25;
        xlabel("Minimum Current (mA) for Moderate Motion Report",FontSize=30);
    end
    else
        
% lsline
% legend([""; ""; ""; ""; ""; ""; ""; "- Velocity"; "- Semi"; "- Angle"; "No GVS";"+ Velocity"; "+ Semi"; "+ Angle"], FontSize=25)


    end
end
sgtitle("GVS Effect vs. GVS Susceptibility", "FontSize", 36)
% lgd = legend('none','noticeable', 'moderate', 'severe', 'FontSize', 38 );
%         lgd.Layout.Tile = 8;
% xlabel("Minimum Current (mA) for Moderate Motion",FontSize=30);
% ylabel("Perception-Actual Tilt Correlation Slope",FontSize=30);
% xlim ([1 4])
%% plot tilt slope against rating
%load  GVS Susceptibility and perception v. GVS and perception v. tilt
sub_symbols = [ "pentagram";"<";"hexagram";">"; "diamond";"v";"o";"+"; "*"; "x"; "square"; "^"; ];
figure;
    plot(MotionRating_min_save(:,3), tilt_slope,'.','MarkerSize',0.1);
    
lsline
legend(["N Vel"; "N Ang&Vel"; "N Ang"; "None";"P Vel"; "P Ang&Vel"; "P Ang"])

xlabel("Minimum Current (mA) for Moderate Motion");
ylabel("Perception-Actual Tilt Correlation Slope");

%% 
%load  GVS Susceptibility and perception v. GVS and perception v. tilt
 tilt_slope = slope_save_all;
 x = linspace(0,4);
for i = 1:length(Label_slope)
    eval(["LM.X" + Label_slope(i) + "= fitlm(MotionRating_max_save(:,3), tilt_slope(:,i));"]);
    eval(["correlation(i)= LM.X" + Label_slope(i) + ".Coefficients.Estimate(2);"]);
    y(i,:) = x*correlation(i);
end
plot(x,y)

