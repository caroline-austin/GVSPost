#1# add libraries needed
library(tidyverse)
library(ggpubr)
library(rstatix)

#navigate to the directory
setwd("C:/Users/caroa/OneDrive/Documents")
#load all data organized by coupling scheme
#C:/Users/Caroline Austin/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS
freq_power<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/PitchMontageTesting/Data/freq_power_anova.csv")

# sort data into roll and pitch subsets for focused analysis
binaural_power <- subset(freq_power, config == "Binaural")
binaural_roll_power <- subset(binaural_power, dir == "roll")
binaural_yaw_power <- subset(binaural_power, dir == "yaw")

pitch_power <- subset(freq_power, dir == "pitch")
pitch_power <- subset(pitch_power, config != "Binaural")

# run binaural anovas
binaural_roll_power.aov <- anova_test(data = binaural_roll_power[,1:6], dv = data, wid = sub, within = c("type" , "freq_interest" ))
binaural_roll_power.aov <- anova_test(data ~ type + freq_interest +Error(sub/(type*freq_interest)), data = binaural_roll_power[,1:6])
get_anova_table(binaural_roll_power.aov)
get_anova_table(binaural_roll_power.aov)

anova_result <- aov(data ~  type + freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_power[,1:6])
anova_result <- aov(data ~  type * freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_power[,1:6])
summary(anova_result)

binaural_yaw_power.aov <- anova_test(data = binaural_yaw_power[,1:6], dv = data, wid = sub, within = c("type" , "freq_interest" ))
get_anova_table(binaural_yaw_power.aov)

# run pitch anova
pitch_power.aov <- anova_test(data = pitch_power[,1:6], dv = data, wid = sub, within = c("type" , "freq_interest", "config" ))
get_anova_table(pitch_power.aov)


# run full anova
freq_power.aov <- anova_test(data = freq_power[,1:6], dv = data, wid = sub, within = c("type" , "config" , "dir", "freq_interest" ))
get_anova_table(freq_power.aov)

#run follow up t tests 
# binaural roll - t-tests
pairwise.t.test(binaural_roll_power[,1],binaural_roll_power[,2],p.adj = "bonf") # exp/control
pairwise.t.test(binaural_roll_power[,1],binaural_roll_power[,5],p.adj = "bonf") # freq of interest
pairwise.t.test(binaural_roll_power[1:120,1],binaural_roll_power[1:120,2],p.adj = "bonf") # exp/control without 1 Hz

# binaural yaw - t-tests
pairwise.t.test(binaural_yaw_power[,1],binaural_yaw_power[,2],p.adj = "bonf") # exp/control
pairwise.t.test(binaural_yaw_power[,1],binaural_yaw_power[,5],p.adj = "bonf") # freq of interest

# pitch - t-tests
pairwise.t.test(pitch_power[,1],pitch_power[,2],p.adj = "bonf") # exp/control
pairwise.t.test(pitch_power[,1],pitch_power[,5],p.adj = "bonf") # freq of interest
pairwise.t.test(pitch_power[,1],pitch_power[,3],p.adj = "bonf") # montage
pairwise.t.test(pitch_power[49:204,1],pitch_power[49:204,2],p.adj = "bonf") # exp/control


# full data t-test
pairwise.t.test(freq_power[,1],freq_power[,2],p.adj = "bonf") #exp/control
pairwise.t.test(freq_power[,1],freq_power[,5],p.adj = "bonf") #freq of interest
pairwise.t.test(freq_power[,1],freq_power[,3],p.adj = "bonf") #montage
pairwise.t.test(freq_power[,1],freq_power[,4],p.adj = "bonf") # axis of interest


## visualize the data and check anova assumptions
# summary statistics
freq_power %>% 
  group_by(type) %>% 
  get_summary_stats(data, type = "mean_sd")

freq_power %>% 
  group_by(type, config, dir) %>% 
  get_summary_stats(data, type = "mean_sd")

binaural_roll_power %>% 
  group_by(type) %>% 
  get_summary_stats(data, type = "mean_sd") # questionable variance equivalence

binaural_yaw_power %>% 
  group_by(type) %>% 
  get_summary_stats(data, type = "mean_sd") # questionable variance equivalence

pitch_power %>% 
  group_by(type, config) %>% 
  get_summary_stats(data, type = "mean_sd") # variances are reasonably equiv

pitch_power[49:204,] %>% 
  group_by(type) %>% 
  get_summary_stats(data, type = "mean_sd") # variances are equiv


# visualization
bxp <- ggboxplot(freq_power, x = "type", y = "data", add = "point")
bxp

bxp <- ggboxplot(binaural_roll_power, x = "type", y = "data", add = "point")
bxp

bxp <- ggboxplot(binaural_yaw_power, x = "type", y = "data", add = "point")
bxp

bxp <- ggboxplot(pitch_power, x = "type", y = "data", add = "point")
bxp


#outliers
freq_power %>%
  group_by(type) %>%
  identify_outliers(data)

binaural_roll_power %>%
  group_by(type) %>%
  identify_outliers(data)

binaural_yaw_power %>%
  group_by(type) %>%
  identify_outliers(data)

pitch_power %>%
  group_by(type) %>%
  identify_outliers(data)

# check normaility assumption - all data passes normality assumption - q plots look decent too I think
freq_power %>%
  group_by(type, config, dir) %>%
  shapiro_test(data)
ggqqplot(freq_power, "data", facet.by = "type")

binaural_roll_power %>%
  group_by(type) %>%
  shapiro_test(data)
ggqqplot(freq_power, "data", facet.by = "type")

binaural_yaw_power %>%
  group_by(type) %>%
  shapiro_test(data)
ggqqplot(freq_power, "data", facet.by = "type")

pitch_power %>%
  group_by(type) %>%
  shapiro_test(data)
ggqqplot(freq_power, "data", facet.by = "type")

pitch_power %>%
  group_by(type,config) %>%
  shapiro_test(data)


# need to check homoscedascity because I think they have diff variances

# calculate effect size's using glass's delta

# binaural roll
binaural_roll_power_ef <- (-4.97-15.1)/8.62

# binaural yaw
binaural_yaw_power_ef <- (2.88-14.4)/6.56

# binaural yaw
pitch_power_ef <- (-12.6-(-4.74))/6.17

