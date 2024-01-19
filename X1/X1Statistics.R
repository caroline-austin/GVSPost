#1# add libraries needed
library(tidyverse)
library(ggpubr)
library(rstatix)

#navigate to the directory
setwd("C:/Users/caroa/OneDrive/Documents")
#load all data organized by coupling scheme
#C:/Users/Caroline Austin/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS
mae_bias_time<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/MeanAbsError/SAllMeanAbsErrorShortBiasTime.csv")
perception_tilt_bias_time<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/Perception-tilt-Slope/SAllPerception-tilt-SlopeBiasTime.csv")
over_bias_time<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/OverUnder/SAllOverPercBiasTime.csv")
peak_bias_time<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/SAllPeaksValleysBiasTime.csv")

mae_bias_time_gain<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/MeanAbsError/SAllMeanAbsErrorShortBiasTimeGain.csv")
perception_tilt_bias_time_gain<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/Perception-tilt-Slope/SAllPerception-tilt-SlopeBiasTimeGain.csv")
over_bias_time_gain<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/OverUnder/SAllOverPercBiasTimeGain.csv")
peak_bias_time_gain<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/SAllPeaksValleysBiasTimeGain.csv")

#load data organized by motion profile
mae_bias_time_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/MeanAbsError/SAllMeanAbsErrorShortBiasTimeFull.csv")
perception_tilt_bias_time_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/Perception-tilt-Slope/SAllPerception-tilt-SlopeBiasTimeFull.csv")
over_bias_time_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/OverUnder/SAllOverPercBiasTimeFull.csv")
peak_bias_time_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/SAllPeaksValleysBiasTimeFull.csv")

mae_bias_time_gain_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/MeanAbsError/SAllMeanAbsErrorShortBiasTimeGainFull.csv")
perception_tilt_bias_time_gain_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/Perception-tilt-Slope/SAllPerception-tilt-SlopeBiasTimeGainFull.csv")
over_bias_time_gain_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/Plots/Measures/OverUnder/SAllOverPercBiasTimeGainFull.csv")
peak_bias_time_gain_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/DynamicGVSPlusTiltTesting/Data/SAllPeaksValleysBiasTimeGainFull.csv")

###############################################################

#2# look at MAE without gain 
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

# mae_bias_time[,2] <-as.character(mae_bias_time[,2])
#compute one-way repeated measures anova
res_mae.aov <- anova_test(data = mae_bias_time, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_mae.aov)

pairwise.t.test(mae_bias_time[,3],mae_bias_time[,2],p.adj = "bonf")

res_mae_neg.aov <- anova_test(data = mae_bias_time[1:36,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_mae_neg.aov)
res_mae_pos.aov <- anova_test(data = mae_bias_time[49:84,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_mae_pos.aov)

#################################
#2b# consider motion profile
res_mae_full.aov <- anova_test(data = mae_bias_time_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_mae_full.aov)

###############################################################

#3#MAE with gain
# summary statistics
mae_bias_time_gain %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(mae_bias_time_gain, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
mae_bias_time_gain %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
mae_bias_time_gain %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(mae_bias_time_gain, "Var", facet.by = "CouplingScheme")

#compute one-way repeated measures anova
res_mae_gain.aov <- anova_test(data = mae_bias_time_gain, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_mae_gain.aov)

pairwise.t.test(mae_bias_time_gain[,3],mae_bias_time_gain[,2],p.adj = "bonf")

res_mae_gain_neg.aov <- anova_test(data = mae_bias_time_gain[1:36,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_mae_gain_neg.aov)
res_mae_gain_pos.aov <- anova_test(data = mae_bias_time_gain[49:84,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_mae_gain_pos.aov)

#############################
#3b# consider motion profile
res_mae_gain_full.aov <- anova_test(data = mae_bias_time_gain_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_mae_gain_full.aov)

###############################################################

#4# actual-perception tilt perception slope
# summary statistics
perception_tilt_bias_time %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(perception_tilt_bias_time, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
perception_tilt_bias_time %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
perception_tilt_bias_time %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(perception_tilt_bias_time, "Var", facet.by = "CouplingScheme")

#compute one-way repeated measures anova
res_perception_tilt.aov <- anova_test(data = perception_tilt_bias_time, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_perception_tilt.aov)

pairwise.t.test(perception_tilt_bias_time[,3],perception_tilt_bias_time[,2],p.adj = "bonf")

res_perception_tilt_neg.aov <- anova_test(data = perception_tilt_bias_time[1:36,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_perception_tilt_neg.aov)
res_perception_tilt_pos.aov <- anova_test(data = perception_tilt_bias_time[49:84,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_perception_tilt_pos.aov)

#################################
#4b# consider motion profile
res_perception_tilt_full.aov <- anova_test(data = perception_tilt_bias_time_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_perception_tilt_full.aov)
###############################################################

#5# actual-perception tilt perception perception_tilt with gain
# summary statistics
perception_tilt_bias_time_gain %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(perception_tilt_bias_time_gain, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
perception_tilt_bias_time_gain %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
perception_tilt_bias_time_gain %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(perception_tilt_bias_time_gain, "Var", facet.by = "CouplingScheme")

#compute one-way repeated measures anova
res_perception_tilt_gain.aov <- anova_test(data = perception_tilt_bias_time_gain, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_perception_tilt_gain.aov)

pairwise.t.test(perception_tilt_bias_time_gain[,3],perception_tilt_bias_time_gain[,2],p.adj = "bonf")

res_perception_tilt_gain_neg.aov <- anova_test(data = perception_tilt_bias_time_gain[1:36,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_perception_tilt_gain_neg.aov)
res_perception_tilt_gain_pos.aov <- anova_test(data = perception_tilt_bias_time_gain[49:84,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_perception_tilt_gain_pos.aov)

#################################
#5b# consider motion profile
res_perception_tilt_gain_full.aov <- anova_test(data = perception_tilt_bias_time_gain_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_perception_tilt_gain_full.aov)
##################################################################################

#6# Over estimation percentage 
# summary statistics
over_bias_time %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(over_bias_time, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
over_bias_time %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
over_bias_time %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(over_bias_time, "Var", facet.by = "CouplingScheme")

#compute one-way repeated measures anova
res_over.aov <- anova_test(data = over_bias_time, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_over.aov)

pairwise.t.test(over_bias_time[,3],over_bias_time[,2],p.adj = "bonf")

res_over_neg.aov <- anova_test(data = over_bias_time[1:36,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_over_neg.aov)
res_over_pos.aov <- anova_test(data = over_bias_time[49:84,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_over_pos.aov)

#################################
#6b# consider motion profile
res_over_full.aov <- anova_test(data = over_bias_time_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_over_full.aov)
##################################################################################

#7# Over estimation percentage with gain
# summary statistics
over_bias_time_gain %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(over_bias_time_gain, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
over_bias_time_gain %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
over_bias_time_gain %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(over_bias_time_gain, "Var", facet.by = "CouplingScheme")

#compute one-way repeated measures anova
res_over_gain.aov <- anova_test(data = over_bias_time_gain, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_over_gain.aov)

pairwise.t.test(over_bias_time_gain[,3],over_bias_time_gain[,2],p.adj = "bonf")

res_over_gain_neg.aov <- anova_test(data = over_bias_time_gain[1:36,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_over_gain_neg.aov)
res_over_gain_pos.aov <- anova_test(data = over_bias_time_gain[49:84,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_over_gain_pos.aov)

#################################
#7b# consider motion profile
res_over_gain_full.aov <- anova_test(data = over_bias_time_gain_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_over_gain_full.aov)
##################################################################################

#8# Peaks and Valley's metric 
# summary statistics
peak_bias_time %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(peak_bias_time, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
peak_bias_time %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
peak_bias_time %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(peak_bias_time, "Var", facet.by = "CouplingScheme")

#compute one-way repeated measures anova
res_peak.aov <- anova_test(data = peak_bias_time, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_peak.aov)

pairwise.t.test(peak_bias_time[,3],peak_bias_time[,2],p.adj = "bonf")

res_peak_neg.aov <- anova_test(data = peak_bias_time[1:36,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_peak_neg.aov)
res_peak_pos.aov <- anova_test(data = peak_bias_time[49:84,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_peak_pos.aov)

#################################
#8b# consider motion profile
res_peak_full.aov <- anova_test(data = peak_bias_time_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_peak_full.aov)
##################################################################################

#9# Peaks and Valleys with gain
# summary statistics
peak_bias_time_gain %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(peak_bias_time_gain, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
peak_bias_time_gain %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
peak_bias_time_gain %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(peak_bias_time_gain, "Var", facet.by = "CouplingScheme")

#compute one-way repeated measures anova
res_peak_gain.aov <- anova_test(data = peak_bias_time_gain, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_peak_gain.aov)

pairwise.t.test(peak_bias_time_gain[,3],peak_bias_time_gain[,2],p.adj = "bonf")

res_peak_gain_neg.aov <- anova_test(data = peak_bias_time_gain[1:36,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_peak_gain_neg.aov)
res_peak_gain_pos.aov <- anova_test(data = peak_bias_time_gain[49:84,], dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_peak_gain_pos.aov)

#################################
#9b# consider motion profile
res_peak_gain_full.aov <- anova_test(data = peak_bias_time_gain_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_peak_gain_full.aov)