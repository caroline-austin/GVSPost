#1# add libraries needed
library(tidyverse)
library(ggpubr)
library(rstatix)
library(lmtest)

#navigate to the directory
setwd("C:/Users/caroa/OneDrive/Documents")
#load all data organized by coupling scheme
#C:/Users/Caroline Austin/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS
mae<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/PitchDynamicGVSPlusTiltTesting/Data/Plots/Measures/MeanAbsError/SAllMeanAbsErrorShortBiasTimeGain.csv")
perception_tilt<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/PitchDynamicGVSPlusTiltTesting/Data/Plots/Measures/Perception-tilt-Slope/SAllPerception-tilt-SlopeBiasTimeGain.csv")


mae_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/PitchDynamicGVSPlusTiltTesting/Data/Plots/Measures/MeanAbsError/SAllMeanAbsErrorShortBiasTimeGainFull.csv")
perception_tilt_full<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/PitchDynamicGVSPlusTiltTesting/Data/Plots/Measures/Perception-tilt-Slope/SAllPerception-tilt-SlopeBiasTimeGainFull.csv")


#1# look at MAE 
#make data factor
mae$SID <- factor(mae$SID)
mae$CouplingScheme <- factor(mae$CouplingScheme)
mae$CouplingDirection <- factor(mae$CouplingDirection)

mae_full$SID <- factor(mae_full$SID)
mae_full$CouplingScheme <- factor(mae_full$CouplingScheme)
mae_full$CouplingDirection <- factor(mae_full$CouplingDirection)
mae_full$MotionProfile <- factor(mae_full$MotionProfile)
mae_full$MotionDirection <- factor(mae_full$MotionDirection)

# transform for normality
#mae$Var <- log(mae$Var)

mae %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(mae, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
mae %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
mae %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(mae, "Var", facet.by = "CouplingScheme")

# homoscedascity assumption
mae_model <- lm(Var ~ CouplingScheme, data = mae)
plot(mae_model$fitted.values, resid(model),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "Residuals vs Fitted")
abline(h = 0, col = "red")

bptest(mae_model)

#compute one-way repeated measures anova
res_mae.aov <- anova_test(data = mae, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_mae.aov)

pairwise.t.test(mae[,3],mae[,2],p.adj = "bonf")

#res_mae_neg.aov <- anova_test(data = mae[1:44,], dv = Var, wid = SID, within = CouplingScheme)
#get_anova_table(res_mae_neg.aov)
#res_mae_pos.aov <- anova_test(data = mae[67:110,], dv = Var, wid = SID, within = CouplingScheme)
#get_anova_table(res_mae_pos.aov)

################
#1b# consider motion profile
res_mae_full.aov <- anova_test(data = mae_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_mae_full.aov)

###########################################################
#2# look at tilt perception slope
#make data factor
perception_tilt$SID <- factor(perception_tilt$SID)
perception_tilt$CouplingScheme <- factor(perception_tilt$CouplingScheme)
perception_tilt$CouplingDirection <- factor(perception_tilt$CouplingDirection)

perception_tilt_full$SID <- factor(perception_tilt_full$SID)
perception_tilt_full$CouplingScheme <- factor(perception_tilt_full$CouplingScheme)
perception_tilt_full$CouplingDirection <- factor(perception_tilt_full$CouplingDirection)
perception_tilt_full$MotionProfile <- factor(perception_tilt_full$MotionProfile)
perception_tilt_full$MotionDirection <- factor(perception_tilt_full$MotionDirection)

# transform for normality
#perception_tilt$Var <- log(perception_tilt$Var)^(2)
# summary statistics
perception_tilt %>% 
  group_by(CouplingScheme) %>% 
  get_summary_stats(Var, type = "mean_sd")

# visualization
bxp <- ggboxplot(perception_tilt, x = "CouplingScheme", y = "Var", add = "point")
bxp

#outliers
perception_tilt %>%
  group_by(CouplingScheme) %>%
  identify_outliers(Var)

# normaility assumption
perception_tilt %>%
  group_by(CouplingScheme) %>%
  shapiro_test(Var)
ggqqplot(perception_tilt, "Var", facet.by = "CouplingScheme")

# overall the data is normal, but the inndividual groups are not
shapiro_test(perception_tilt$Var)

# homoscedascity assumption
perception_tilt_model <- lm(Var ~ CouplingScheme, data = perception_tilt)
plot(perception_tilt_model$fitted.values, resid(model),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "Residuals vs Fitted")
abline(h = 0, col = "red")

bptest(perception_tilt_model)

# fails normality test, barely passes homoscedacity test

#compute one-way repeated measures anova
res_perception_tilt.aov <- anova_test(data = perception_tilt, dv = Var, wid = SID, within = CouplingScheme)
get_anova_table(res_perception_tilt.aov)

pairwise.t.test(perception_tilt[,3],perception_tilt[,2],p.adj = "bonf")

#res_perception_tilt_neg.aov <- anova_test(data = perception_tilt[1:44,], dv = Var, wid = SID, within = CouplingScheme)
#get_anova_table(res_perception_tilt_neg.aov)
#res_perception_tilt_pos.aov <- anova_test(data = perception_tilt[67:110,], dv = Var, wid = SID, within = CouplingScheme)
#get_anova_table(res_perception_tilt_pos.aov)

#################################
#2b# consider motion profile
res_perception_tilt_full.aov <- anova_test(data = perception_tilt_full[,1:6], dv = Var, wid = SID, within = c("CouplingScheme" , "MotionProfile" , "MotionDirection" ))
get_anova_table(res_perception_tilt_full.aov)
