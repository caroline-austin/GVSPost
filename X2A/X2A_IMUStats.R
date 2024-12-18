#1# add libraries needed
library(tidyverse)
library(ggpubr)
library(rstatix)

#navigate to the directory
setwd("C:/Users/caroa/OneDrive/Documents")
#load all data organized by coupling scheme
#C:/Users/Caroline Austin/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS
freq_power<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/PitchMontageTesting/Data/freq_power_anova.csv")


# run anova
freq_power.aov <- anova_test(data = freq_power[,1:6], dv = data, wid = sub, within = c("type" , "config" , "dir", "freq_interest" ))
get_anova_table(freq_power.aov)

#run follow up t tests
pairwise.t.test(freq_power[,1],freq_power[,5],p.adj = "bonf")


## visualize the data and check anova assumptions
# summary statistics
freq_power %>% 
  group_by(type) %>% 
  get_summary_stats(data, type = "mean_sd")

freq_power %>% 
  group_by(type, config, dir) %>% 
  get_summary_stats(data, type = "mean_sd")

# visualization
bxp <- ggboxplot(freq_power, x = "type", y = "data", add = "point")
bxp


#outliers
freq_power %>%
  group_by(type) %>%
  identify_outliers(data)

# normaility assumption
freq_power %>%
  group_by(type, config, dir) %>%
  shapiro_test(data)
ggqqplot(freq_power, "data", facet.by = "type")

# need to check homoscedascity because I think they have diff variances


