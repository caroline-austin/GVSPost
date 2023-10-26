## add libraries needed
library(tidyverse)
library(ggpubr)
library(rstatix)

#navigate to the directory
setwd("C:/Users/caroa/OneDrive/Documents")
mae_bias_time<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/MeanAbsError/SAllMeanAbsErrorShortBiasTime.csv")
perception_tilt_bias_time<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/Perception-tilt-Slope/SAllPerception-tilt-SlopeBiasTime.csv")
mae_bias_time_gain<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/MeanAbsError/SAllMeanAbsErrorShortBiasTimeGain.csv")
perception_tilt_bias_time_gain<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/Perception-tilt-Slope/SAllPerception-tilt-SlopeBiasTimeGain.csv")


# summary statistics
mae_bias_time %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(mae_bias_time, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
mae_bias_time %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
mae_bias_time %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(mae_bias_time, "Var", facet.by = "CouplingScheme")

#compute one-way repeated measures anova
res_mae.aov <- anova_test(data = mae_bias_time, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_mae.aov)

#MAE with gain
#compute one-way repeated measures anova
res_mae_gain.aov <- anova_test(data = mae_bias_time_gain, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_mae_gain.aov)

#actual-perception tilt perception slope
#compute one-way repeated measures anova
res_perception_tilt.aov <- anova_test(data = perception_tilt_bias_time, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_perception_tilt.aov)

#actual-perception tilt perception perception_tilt with gain
#compute one-way repeated measures anova
res_perception_tilt_gain.aov <- anova_test(data = perception_tilt_bias_time_gain, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_perception_tilt_gain.aov)

