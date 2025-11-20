#1# add libraries needed
library(tidyverse)
library(ggpubr)
library(rstatix)
library(dplyr)
library('ARTool')

#navigate to the directory
setwd("C:/Users/caroa/OneDrive/Documents")
#load all data organized by coupling scheme
#C:/Users/Caroline Austin/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS
freq_power<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/PitchMontageTesting/Data/freq_power_log_anova.csv")
mag_psd<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/PitchMontageTesting/Data/mag_anova.csv")

freq_power$type <- factor(freq_power$type)
freq_power$freq_interest <- factor(freq_power$freq_interest)
freq_power$config <- factor(freq_power$config)
freq_power$dir <- factor(freq_power$dir)
freq_power$sub <- factor(freq_power$sub)

# sort data into roll and pitch subsets for focused analysis
binaural_power <- subset(freq_power, config == "Binaural")
binaural_roll_power <- subset(binaural_power, dir == "roll")
binaural_yaw_power <- subset(binaural_power, dir == "yaw")

pitch_power <- subset(freq_power, dir == "pitch")
pitch_power <- subset(pitch_power, config != "Binaural")
####
#mag_psd$data <- log(mag_psd$data)
mag_psd$type <- factor(mag_psd$type)
mag_psd$freq_interest <- factor(mag_psd$freq_interest)
mag_psd$config <- factor(mag_psd$config)
mag_psd$dir <- factor(mag_psd$dir)
mag_psd$sub <- factor(mag_psd$sub)

# sort data into roll and pitch subsets for focused analysis
binaural_mag <- subset(mag_psd, config == "Binaural")
binaural_roll_mag <- subset(binaural_mag, dir == "roll")
binaural_yaw_mag <- subset(binaural_mag, dir == "yaw")

pitch_mag <- subset(mag_psd, dir == "pitch")
pitch_mag <- subset(pitch_mag, config != "Binaural")
########################################################
angle_disp<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/PitchMontageTesting/Data/ang_disp_anova.csv")

angle_disp$type <- factor(angle_disp$type)
angle_disp$config <- factor(angle_disp$config)
angle_disp$profile <- factor(angle_disp$profile)
angle_disp$dir<- factor(angle_disp$dir)
angle_disp$sub <- factor(angle_disp$sub)

# sort data into roll and pitch subsets for focused analysis
binaural_disp <- subset(angle_disp, config == "Binaural")
binaural_roll_disp <- subset(binaural_disp, dir == "roll")

binaural_roll_disp_neg <- binaural_roll_disp  %>%
  mutate(data = ifelse(profile =="DCLeft_Back", data*-1, data))

binaural_roll_disp_gvs <- subset(binaural_roll_disp, type == "exp")

binaural_roll_disp_gvs_neg <- binaural_roll_disp_gvs  %>%
  mutate(data = ifelse(profile =="DCLeft_Back", data*-1, data))

pitch_disp <- subset(angle_disp, dir == "pitch")
pitch_disp <- subset(pitch_disp, config != "Binaural")

pitch_disp_neg <- pitch_disp  %>%
  mutate(data = ifelse(profile =="DCLeft_Back", data*-1, data))

pitch_disp_gvs <- subset(pitch_disp, type == "exp")

pitch_disp_gvs_neg <- pitch_disp_gvs  %>%
  mutate(data = ifelse(profile =="DCLeft_Back", data*-1, data))


########################################################
# Frequency Analysis
# run binaural anovas
binaural_roll_power.aov <- anova_test(data = binaural_roll_power[,1:6], dv = data, wid = sub, within = c(type , freq_interest))
get_anova_table(binaural_roll_power.aov) # use this for paper because significant interaction now

anova_result_roll <- aov(data ~  type + freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_power[,1:6])
#anova_result <- aov(data ~  type * freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_power[,1:6])
summary(anova_result_roll)

binaural_yaw_power.aov <- anova_test(data = binaural_yaw_power[,1:6], dv = data, wid = sub, within = c("type" , "freq_interest" ))
get_anova_table(binaural_yaw_power.aov) # can use this or the below test for paper

anova_result_yaw <- aov(data ~  type + freq_interest  + Error(sub/(type*freq_interest)), data = binaural_yaw_power[,1:6])
#anova_result <- aov(data ~  type * freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_power[,1:6])
summary(anova_result_yaw)

# run pitch anova
pitch_power.aov <- anova_test(data = pitch_power[,1:6], dv = data, wid = sub, within = c("type" , "freq_interest", "config" ))
get_anova_table(pitch_power.aov)

anova_result_pitch <- aov(data ~  type + freq_interest  + Error(sub/(type*freq_interest)), data = pitch_power[,1:6])
#anova_result <- aov(data ~  type * freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_power[,1:6])
summary(anova_result_pitch) # can use this or above test for paper

# run full anova
freq_power.aov <- anova_test(data = freq_power[,1:6], dv = data, wid = sub, within = c("type" , "config" , "dir", "freq_interest" ))
get_anova_table(freq_power.aov)

#run follow up t tests - not used in paper just fun to look at
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
pairwise.t.test(pitch_power[49:204,1],pitch_power[49:204,2],p.adj = "bonf") # exp/control excluding 1Hz


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
####################################
# Frequency Analysis magnitude cals
# run binaural anovas
binaural_roll_mag.aov <- anova_test(data = binaural_roll_mag[,1:6], dv = data, wid = sub, within = c(type , freq_interest))
get_anova_table(binaural_roll_mag.aov) # use this for paper because significant interaction now

anova_result_roll <- aov(data ~  type + freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_mag[,1:6])
#anova_result <- aov(data ~  type * freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_mag[,1:6])
summary(anova_result_roll)
shapiro_test((anova_result_roll$`sub:freq_interest`$residuals))
shapiro_test((anova_result_roll$`sub:type`$residuals))

binaural_yaw_mag.aov <- anova_test(data = binaural_yaw_mag[,1:6], dv = data, wid = sub, within = c("type" , "freq_interest" ))
get_anova_table(binaural_yaw_mag.aov) # can use this or the below test for paper

anova_result_yaw <- aov(data ~  type + freq_interest  + Error(sub/(type*freq_interest)), data = binaural_yaw_mag[,1:6])
#anova_result <- aov(data ~  type * freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_mag[,1:6])
summary(anova_result_yaw)
shapiro_test((anova_result_yaw$`sub:freq_interest`$residuals))
shapiro_test((anova_result_yaw$`sub:type`$residuals))

# run pitch anova
pitch_mag.aov <- anova_test(data = pitch_mag[,1:6], dv = data, wid = sub, within = c("type" , "freq_interest", "config" ))
get_anova_table(pitch_mag.aov)

anova_result_pitch <- aov(data ~  type + freq_interest  + Error(sub/(type*freq_interest)), data = pitch_mag[,1:6])
#anova_result <- aov(data ~  type * freq_interest  + Error(sub/(type*freq_interest)), data = binaural_roll_mag[,1:6])
summary(anova_result_pitch) # can use this or above test for paper
shapiro_test((anova_result_pitch$`sub:freq_interest`$residuals))
shapiro_test((anova_result_pitch$`sub:type`$residuals))

# run full anova
mag_psd.aov <- anova_test(data = mag_psd[,1:6], dv = data, wid = sub, within = c("type" , "config" , "dir", "freq_interest" ))
get_anova_table(mag_psd.aov)

#run follow up t tests - not used in paper just fun to look at
# binaural roll - t-tests
pairwise.t.test(binaural_roll_mag[,1],binaural_roll_mag[,2],p.adj = "bonf") # exp/control
pairwise.t.test(binaural_roll_mag[,1],binaural_roll_mag[,5],p.adj = "bonf") # freq of interest
pairwise.t.test(binaural_roll_mag[1:120,1],binaural_roll_mag[1:120,2],p.adj = "bonf") # exp/control without 1 Hz

# binaural yaw - t-tests
pairwise.t.test(binaural_yaw_mag[,1],binaural_yaw_mag[,2],p.adj = "bonf") # exp/control
pairwise.t.test(binaural_yaw_mag[,1],binaural_yaw_mag[,5],p.adj = "bonf") # freq of interest

# pitch - t-tests
pairwise.t.test(pitch_mag[,1],pitch_mag[,2],p.adj = "bonf") # exp/control
pairwise.t.test(pitch_mag[,1],pitch_mag[,5],p.adj = "bonf") # freq of interest
pairwise.t.test(pitch_mag[,1],pitch_mag[,3],p.adj = "bonf") # montage
pairwise.t.test(pitch_mag[49:204,1],pitch_mag[49:204,2],p.adj = "bonf") # exp/control excluding 1Hz


# full data t-test
pairwise.t.test(mag_psd[,1],mag_psd[,2],p.adj = "bonf") #exp/control
pairwise.t.test(mag_psd[,1],mag_psd[,5],p.adj = "bonf") #freq of interest
pairwise.t.test(mag_psd[,1],mag_psd[,3],p.adj = "bonf") #montage
pairwise.t.test(mag_psd[,1],mag_psd[,4],p.adj = "bonf") # axis of interest


## visualize the data and check anova assumptions
# summary statistics
mag_psd %>% 
  group_by(type) %>% 
  get_summary_stats(data, type = "mean_sd")

mag_psd %>% 
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
bxp <- ggboxplot(mag_psd, x = "type", y = "data", add = "point")
bxp

bxp <- ggboxplot(binaural_roll_power, x = "type", y = "data", add = "point")
bxp

bxp <- ggboxplot(binaural_yaw_power, x = "type", y = "data", add = "point")
bxp

bxp <- ggboxplot(pitch_power, x = "type", y = "data", add = "point")
bxp


#outliers
mag_psd %>%
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
mag_psd %>%
  group_by(type, config, dir) %>%
  shapiro_test(data)
ggqqplot(mag_psd, "data", facet.by = "type")

binaural_roll_power %>%
  group_by(type) %>%
  shapiro_test(data)
ggqqplot(mag_psd, "data", facet.by = "type")

binaural_yaw_power %>%
  group_by(type) %>%
  shapiro_test(data)
ggqqplot(mag_psd, "data", facet.by = "type")

pitch_power %>%
  group_by(type) %>%
  shapiro_test(data)
ggqqplot(mag_psd, "data", facet.by = "type")

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

########################################################
# Displacement Analysis

# run binaural anovas
#binaural_roll_disp.aov <- anova_test(data = binaural_roll_disp[,1:6], dv = data, wid = sub, within = c(type , profile))
#get_anova_table(binaural_roll_disp.aov)

#anova_result_roll_disp <- aov(data ~  type + profile  + Error(sub/(type*profile)), data = binaural_roll_disp[,1:6])
#anova_result <- aov(data ~  type * profile  + Error(sub/(type*freq_interest)), data = binaural_roll_disp[,1:6])
#summary(anova_result_roll_disp)

# binaural roll violates the homoscedacity assumptions for anovas so instead use non-parametric version
anova_result_roll_disp_int <- aov(data ~  type * profile  + Error(sub/(type*profile)), data = binaural_roll_disp_neg[,1:6])
summary(anova_result_roll_disp_int)
anova_result_roll_disp <- anova(art(data ~  type * profile  + Error(sub/(type*profile)), data = binaural_roll_disp_neg[,1:6]))
summary(anova_result_roll_disp)

# run pitch anova
pitch_disp.aov <- anova_test(data = pitch_disp[,1:6], dv = data, wid = sub, within = c("type" , "profile", "config" ))
get_anova_table(pitch_disp.aov)

anova_result_pitch <- aov(data ~  type  + Error(sub/(type)), data = pitch_disp[,1:6])
summary(anova_result_pitch)

# run full anova
angle_disp.aov <- anova_test(data = angle_disp[,1:6], dv = data, wid = sub, within = c("type" , "config" , "dir", "profile" ))
get_anova_table(angle_disp.aov)


#run follow up t tests 
# binaural roll - t-tests
pairwise.t.test(binaural_roll_disp_neg[,1],binaural_roll_disp_neg[,2],p.adj = "bonf") # exp/control # n = 12
wilcox.test((binaural_roll_disp_gvs[1:6,1]), (binaural_roll_disp_gvs[7:12,1]), paired = TRUE) # profile n=6 *paper stat* *used in paper*
pairwise.t.test(binaural_roll_disp_gvs[,1],binaural_roll_disp_gvs[,5],p.adj = "bonf") # profile # n=6 (should use non-parametric^)

# pitch - t-tests
pairwise.t.test(pitch_disp_neg[,1],pitch_disp_neg[,2],p.adj = "bonf") # exp/control
pairwise.t.test(pitch_disp_neg[,1],pitch_disp_neg[,3],p.adj = "bonf") # montage

wilcox.test((pitch_disp_gvs[1:6,1]), (pitch_disp_gvs[13:18,1]), paired = TRUE) # profile n= 6 non-parametric Forehead only - used in paper
wilcox.test((pitch_disp_gvs[7:12,1]), (pitch_disp_gvs[19:24,1]), paired = TRUE) # profile n= 6 non-parametric Temples only - used in paper

# test GVS cond when DC - is back to it's original direction
# should maybe be non-parametric
pairwise.t.test(pitch_disp_gvs[,1],pitch_disp_gvs[,5],p.adj = "bonf") # profile n = 12
wilcox.test((pitch_disp_gvs[1:12,1]), (pitch_disp_gvs[13:24,1]), paired = TRUE) # profile n= 12 non-parametric - used in paper

# test montage only for the GVS conditions
# should maybe be non-parametric
pairwise.t.test(pitch_disp_gvs[,1],pitch_disp_gvs[,3],p.adj = "bonf") # montage
wilcox.test((pitch_disp_gvs_neg[c(1:9, 19:27),1]), (pitch_disp_gvs_neg[c(10:18, 28:36),1]), paired = TRUE)


# full data t-test
pairwise.t.test(angle_disp[,1],angle_disp[,2],p.adj = "bonf") #exp/control
pairwise.t.test(angle_disp[,1],angle_disp[,5],p.adj = "bonf") #profile magnitude
pairwise.t.test(angle_disp[,1],angle_disp[,3],p.adj = "bonf") #montage
pairwise.t.test(angle_disp[,1],angle_disp[,4],p.adj = "bonf") # axis of interest


## visualize the data and check anova assumptions
# summary statistics
angle_disp %>% 
  group_by(type) %>% 
  get_summary_stats(data, type = "mean_sd") # mildly concerning variances

angle_disp %>% 
  group_by(type, config, dir) %>% 
  get_summary_stats(data, type = "mean_sd") # really only binaura roll variance is concerining

binaural_roll_disp %>% 
  group_by(type) %>% 
  get_summary_stats(data, type = "mean_sd") # concerning difference in variance!

pitch_disp %>% 
  group_by(type, config) %>% 
  get_summary_stats(data, type = "mean_sd") # variances are reasonably equiv


# visualization
bxp <- ggboxplot(angle_disp, x = "type", y = "data", add = "point")
bxp

bxp <- ggboxplot(binaural_roll_disp, x = "type", y = "data", add = "point")
bxp

bxp <- ggboxplot(pitch_disp, x = "type", y = "data", add = "point")
bxp


#outliers
angle_disp %>%
  group_by(type) %>%
  identify_outliers(data)

binaural_roll_disp %>%
  group_by(type) %>%
  identify_outliers(data)

pitch_disp %>%
  group_by(type) %>%
  identify_outliers(data)

# check normaility assumption - all data passes normality assumption - q plots look decent too I think
angle_disp %>%
  group_by(type, config, dir) %>%
  shapiro_test(data)
ggqqplot(angle_disp, "data", facet.by = "type")

binaural_roll_disp %>%
  group_by(type) %>%
  shapiro_test(data)
ggqqplot(binaural_roll_disp, "data", facet.by = "type")

pitch_disp %>%
  group_by(type) %>%
  shapiro_test(data)
ggqqplot(pitch_disp, "data", facet.by = "type")

pitch_disp %>%
  group_by(type,config) %>%
  shapiro_test(data)

# data is definitely not super homoscedastic for angle disp.- consider trying to 
# run non-parametric stats instead

# calculate effect size's using glass's delta

# binaural roll
#binaural_roll_disp_ef <- (-4.97-15.1)/8.62

# binaural yaw
#pitch_disp_ef <- (-12.6-(-4.74))/6.17

