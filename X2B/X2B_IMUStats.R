#1# add libraries needed
library(tidyverse)
library(ggpubr)
library(rstatix)
library(dplyr)
library('ARTool')
library(lmtest)

#navigate to the directory
setwd("C:/Users/caroa/OneDrive/Documents")
#load all data organized by coupling scheme
#C:/Users/Caroline Austin/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS
freq_power<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/Data/freq_power_anova.csv")

freq_power$type <- factor(freq_power$type)
freq_power$freq_interest <- factor(freq_power$freq_interest)
freq_power$config <- factor(freq_power$config)
freq_power$dir <- factor(freq_power$dir)
freq_power$sub <- factor(freq_power$sub)

pitch_power<-subset(freq_power, dir == "pitch")
roll_power<-subset(freq_power, dir == "roll")

neck_power <- subset(freq_power, config == "Neck")
shoulder_power <- subset(freq_power, config == "Shoulder")
forehead_power <- subset(freq_power, config == "Forehead")



#################################
# run pitch only anova
# pooling the pitch data there is no difference between the montages
pitch_power.aov <- anova_test(data = pitch_power[,1:7], dv = Var, wid = sub, within = c(  "config", "order" ))
get_anova_table(pitch_power.aov)

anova_result_pitch <- aov(Var ~  config + order  + Error(sub/(config*order)), data = pitch_power[,1:7])
shapiro_test((anova_result_pitch$`sub:config`$residuals))

# run roll only anova
roll_power.aov <- anova_test(data = roll_power[,1:7], dv = Var, wid = sub, within = c(  "config", "order" ))
get_anova_table(roll_power.aov)

anova_result_roll <- aov(Var ~  config + order  + Error(sub/(config*order)), data = roll_power[,1:7])
shapiro_test((anova_result_roll$`sub:config`$residuals))

# run pitch v. roll anova
freq_power_dir.aov <- anova_test(data = freq_power[,1:7], dv = Var, wid = sub, within = c(  "config", "order", "dir" ))
get_anova_table(freq_power_dir.aov)

anova_result_all <- aov(Var ~  config + order +dir  + Error(sub/(config*order*dir)), data = freq_power[,1:7])
shapiro_test((anova_result_all$`sub:config`$residuals))

# post hoc tests
pairwise.t.test(freq_power[,1],freq_power[,4],p.adj = "bonf") # montage
pairwise.t.test(freq_power[,1],freq_power[,5],p.adj = "bonf") # direction
pairwise.t.test(freq_power[,1],freq_power[,3],p.adj = "bonf") # order

pairwise.t.test(roll_power[,1],roll_power[,4],p.adj = "bonf") # roll only montage

######################### pitch
#check data normality and homoscedacity 
pitch_power %>% 
  group_by(config) %>% 
  get_summary_stats(Var, type = "mean_sd")

#outliers
pitch_power %>%
  group_by(config) %>%
  identify_outliers(Var)

# normaility assumption
pitch_power %>%
  group_by(config) %>%
  shapiro_test(Var)
ggqqplot(pitch_power, "Var", facet.by = "config")

# homoscedascity assumption
pitch_power_model <- lm(Var ~ config, data = pitch_power)
plot(pitch_power_model$fitted.values, resid(pitch_power_model),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "Residuals vs Fitted")
abline(h = 0, col = "red")

bptest(pitch_power_model)

######################### roll
#check data normality and homoscedacity 
roll_power %>% 
  group_by(config) %>% 
  get_summary_stats(Var, type = "mean_sd")

#outliers
roll_power %>%
  group_by(config) %>%
  identify_outliers(Var)

# normaility assumption
roll_power %>%
  group_by(config) %>%
  shapiro_test(Var)
ggqqplot(roll_power, "Var", facet.by = "config")

# homoscedascity assumption
roll_power_model <- lm(Var ~ config, data = roll_power)
plot(roll_power_model$fitted.values, resid(roll_power_model),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "Residuals vs Fitted")
abline(h = 0, col = "red")

bptest(roll_power_model)

######################### all
#check data normality and homoscedacity 
freq_power %>% 
  group_by(dir) %>% 
  get_summary_stats(Var, type = "mean_sd")

#outliers
freq_power %>%
  group_by(dir) %>%
  identify_outliers(Var)

# normaility assumption
freq_power %>%
  group_by(config) %>%
  shapiro_test(dir)
ggqqplot(freq_power, "Var", facet.by = "config")

# homoscedascity assumption
freq_power_model <- lm(Var ~ dir, data = freq_power)
plot(freq_power_model$fitted.values, resid(freq_power_model),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "Residuals vs Fitted")
abline(h = 0, col = "red")

bptest(freq_power_model)
