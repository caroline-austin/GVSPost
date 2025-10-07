#1# add libraries needed
library(tidyverse)
library(ggpubr)
library(rstatix)
library(dplyr)
library('ARTool')
library(lmtest)
library(BradleyTerry2)

#navigate to the directory
setwd("C:/Users/caroa/OneDrive/Documents")
#load all data organized by coupling scheme
#C:/Users/Caroline Austin/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS
freq_power<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/Data/freq_power_anova.csv")
mag_power<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/Data/mag_anova.csv")
psd_power<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/Data/psd_anova.csv")
freq_psd<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/Data/freq_psd_anova.csv")

verbal<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/Data/group_verbal.csv")
sub_verbal<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/Data/sub_verbal.csv")
congruent<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/Data/congruent.csv")
congruentC<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/DataC/congruent.csv")

verbal$condition1 <-factor(verbal$condition1)
verbal$condition2 <-factor(verbal$condition2)

sub_verbal$condition1 <-factor(sub_verbal$condition1)
sub_verbal$condition2 <-factor(sub_verbal$condition2)
sub_verbal$SID <-factor(sub_verbal$SID)

congruent$SID <-factor(congruent$SID)
congruentC$SID <-(congruentC$SID+10)
congruentC$SID <-factor(congruentC$SID)
congruent_total <- rbind(congruent, congruentC)

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

#mag_power$Var <- log(mag_power$Var)
mag_power$type <- factor(mag_power$type)
mag_power$freq_interest <- factor(mag_power$freq_interest)
mag_power$config <- factor(mag_power$config)
mag_power$dir <- factor(mag_power$dir)
mag_power$sub <- factor(mag_power$sub)

pitch_mag<-subset(mag_power, dir == "pitch")
roll_mag<-subset(mag_power, dir == "roll")

neck_mag <- subset(mag_power, config == "Neck")
shoulder_mag <- subset(mag_power, config == "Shoulder")
forehead_mag <- subset(mag_power, config == "Forehead")

#psd_power$Var <- log10(psd_power$Var)

psd_power$type <- factor(psd_power$type)
psd_power$freq_interest <- factor(psd_power$freq_interest)
psd_power$config <- factor(psd_power$config)
psd_power$dir <- factor(psd_power$dir)
psd_power$sub <- factor(psd_power$sub)

pitch_psd<-subset(psd_power, dir == "pitch")
roll_psd<-subset(psd_power, dir == "roll")

neck_psd <- subset(psd_power, config == "Neck")
shoulder_psd <- subset(psd_power, config == "Shoulder")
forehead_psd <- subset(psd_power, config == "Forehead")

freq_psd$type <- factor(freq_psd$type)
freq_psd$freq_interest <- factor(freq_psd$freq_interest)
freq_psd$config <- factor(freq_psd$config)
freq_psd$dir <- factor(freq_psd$dir)
freq_psd$sub <- factor(freq_psd$sub)

pitch_freq_psd<-subset(freq_psd, dir == "pitch")
roll_freq_psd<-subset(freq_psd, dir == "roll")

neck_freq_psd <- subset(freq_psd, config == "Neck")
shoulder_freq_psd <- subset(freq_psd, config == "Shoulder")
forehead_freq_psd <- subset(freq_psd, config == "Forehead")

####################################
# run verbal stats (Bradley Terry Model)
BT_motion_model <- (BTm(cbind(motion_wins1,motion_wins2),  condition1, condition2, data =verbal))
summary(BT_motion_model)
#% likelihood compared to reference
exp(BT_motion_model$coefficients)/(1+exp(BT_motion_model$coefficients))

BT_tingling_model <- (BTm(cbind(tingling_wins1,tingling_wins2),  condition1, condition2, data =verbal))
summary(BT_tingling_model)
exp(BT_tingling_model$coefficients)/(1+exp(BT_tingling_model$coefficients))

BT_vis_model <- (BTm(cbind(vis_wins1,vis_wins2),  condition1, condition2, data =verbal))
summary(BT_vis_model)
exp(BT_vis_model$coefficients)/(1+exp(BT_vis_model$coefficients))

BT_metallic_model <- (BTm(cbind(metallic_wins1,metallic_wins2),  condition1, condition2, data =verbal))
summary(BT_metallic_model)
exp(BT_metallic_model$coefficients)/(1+exp(BT_metallic_model$coefficients))
#############################
# use the t-test in the paper not the binomial
binom.test(verbal$motion_wins1[1], 40, p=0.5) # Forehead-Shoulder
binom.test(verbal$motion_wins1[2], 40, p=0.5) # Shoulder-Neck
binom.test(verbal$motion_wins1[3], 40, p=0.5) # Neck-Forehead

t.test(sub_verbal$motion_wins1[1:10]/4, mu = 0.5) # Forehead- Shoulder
t.test(sub_verbal$motion_wins1[11:20]/4, mu = 0.5) # Shoulder- Neck
t.test(sub_verbal$motion_wins1[21:30]/4, mu = 0.5) # Neck- Forehead

binom.test(verbal$tingling_wins1[1], 40, p=0.5) # Forehead-Shoulder
binom.test(verbal$tingling_wins1[2], 40, p=0.5) # Shoulder-Neck
binom.test(verbal$tingling_wins1[3], 40, p=0.5) # Neck-Forehead

t.test(sub_verbal$tingling_wins1[1:10]/4, mu = 0.5) # Forehead- Shoulder
t.test(sub_verbal$tingling_wins1[11:20]/4, mu = 0.5) # Shoulder- Neck
t.test(sub_verbal$tingling_wins1[21:30]/4, mu = 0.5) # Neck- Forehead

t.test(sub_verbal$vis_wins1[1:10]/4, mu = 0.5) # Forehead- Shoulder
t.test(sub_verbal$vis_wins1[11:20]/4, mu = 0.5) # Shoulder- Neck
t.test(sub_verbal$vis_wins1[21:30]/4, mu = 0.5) # Neck- Forehead

t.test(sub_verbal$metallic_wins1[1:10]/4, mu = 0.5) # Forehead- Shoulder
t.test(sub_verbal$metallic_wins1[11:20]/4, mu = 0.5) # Shoulder- Neck
t.test(sub_verbal$metallic_wins1[21:30]/4, mu = 0.5) # Neck- Forehead

##################################
# stats on consistency between sway and verbal reports
t.test(congruent$correct, mu = 0.5)
t.test(congruent_total$correct, mu = 0.5)

total_congruent = sum(congruent$correct)*12
total_congruentC = sum(congruentC$correct)*28
total_responses = 120
total_responsesC = 280

total_congruent_BC = total_congruent+total_congruentC
total_responses_BC = total_responses +total_responsesC

binom.test(total_congruent, total_responses, p=0.5)
binom.test(total_congruent_BC, total_responses_BC, p=0.5)

#################################
# run pitch only anova
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

pairwise.t.test(pitch_power[,1],pitch_power[,4],p.adj = "bonf") # pitch only montage

#################################
# run pitch only anova # mag # use in paper
pitch_mag.aov <- anova_test(data = pitch_mag[,1:6], dv = Var, wid = sub, within = c(  "config" )) # paper
get_anova_table(pitch_mag.aov)

anova_result_pitch_mag <- aov(Var ~  config  + Error(sub/(config)), data = pitch_mag[,1:6])
shapiro_test((anova_result_pitch_mag$`sub:config`$residuals))
plot(anova_result_pitch_mag$`sub:config`$residuals)

# run roll only anova
roll_mag.aov <- anova_test(data = roll_mag[,1:6], dv = Var, wid = sub, within = c(  "config" ))
get_anova_table(roll_mag.aov)

anova_result_roll_mag <- aov(Var ~  config   + Error(sub/(config)), data = roll_mag[,1:6])
shapiro_test((anova_result_roll_mag$`sub:config`$residuals))

# run pitch v. roll anova
mag_power_dir.aov <- anova_test(data = mag_power[,1:6], dv = Var, wid = sub, within = c(  "config", "dir" ))
get_anova_table(mag_power_dir.aov)

anova_result_all_mag <- aov(Var ~  config  +dir  + Error(sub/(config*dir)), data = mag_power[,1:6])
shapiro_test((anova_result_all_mag$`sub:config`$residuals))

# post hoc tests
pairwise.t.test(mag_power[,1],mag_power[,3],p.adj = "bonf") # montage
pairwise.t.test(mag_power[,1],mag_power[,4],p.adj = "bonf") # direction

pairwise.t.test(roll_mag[,1],roll_mag[,3],p.adj = "bonf") # roll only montage
pairwise.t.test(pitch_mag[,1],pitch_mag[,3],p.adj = "bonf") # pitch only montage # paper
#######################################################################################
# run pitch only anova
pitch_psd.aov <- anova_test(data = pitch_psd[,1:6], dv = Var, wid = sub, within = c(  "config" ))
get_anova_table(pitch_psd.aov)

anova_result_pitch_psd <- aov(Var ~  config  + Error(sub/(config)), data = pitch_psd[,1:6])
shapiro_test((anova_result_pitch_psd$`sub:config`$residuals))

# run roll only anova
roll_psd.aov <- anova_test(data = roll_psd[,1:6], dv = Var, wid = sub, within = c(  "config" ))
get_anova_table(roll_psd.aov)

anova_result_roll_psd <- aov(Var ~  config   + Error(sub/(config)), data = roll_psd[,1:6])
shapiro_test((anova_result_roll_psd$`sub:config`$residuals))

# run pitch v. roll anova
psd_power_dir.aov <- anova_test(data = psd_power[,1:6], dv = Var, wid = sub, within = c(  "config", "dir" ))
get_anova_table(psd_power_dir.aov)

anova_result_all_psd <- aov(Var ~  config  +dir  + Error(sub/(config*dir)), data = psd_power[,1:6])
shapiro_test((anova_result_all_psd$`sub:config`$residuals))

# post hoc tests
pairwise.t.test(psd_power[,1],psd_power[,3],p.adj = "bonf") # montage
pairwise.t.test(psd_power[,1],psd_power[,4],p.adj = "bonf") # direction

pairwise.t.test(roll_psd[,1],roll_psd[,3],p.adj = "bonf") # roll only montage
pairwise.t.test(pitch_psd[,1],pitch_psd[,3],p.adj = "bonf") # pitch only montage

#######################################################################################
# run pitch only anova
pitch_freq_psd.aov <- anova_test(data = pitch_freq_psd[,1:6], dv = Var, wid = sub, within = c(  "config" ))
get_anova_table(pitch_freq_psd.aov)

anova_result_pitch_freq_psd <- aov(Var ~  config  + Error(sub/(config)), data = pitch_freq_psd[,1:6])
shapiro_test((anova_result_pitch_freq_psd$`sub:config`$residuals))

# run roll only anova
roll_freq_psd.aov <- anova_test(data = roll_freq_psd[,1:6], dv = Var, wid = sub, within = c(  "config" ))
get_anova_table(roll_freq_psd.aov)

anova_result_roll_freq_psd <- aov(Var ~  config   + Error(sub/(config)), data = roll_freq_psd[,1:6])
shapiro_test((anova_result_roll_freq_psd$`sub:config`$residuals))

# run pitch v. roll anova
freq_psd_dir.aov <- anova_test(data = freq_psd[,1:6], dv = Var, wid = sub, within = c(  "config", "dir" ))
get_anova_table(freq_psd_dir.aov)

anova_result_all_freq_psd <- aov(Var ~  config  +dir  + Error(sub/(config*dir)), data =freq_psd[,1:6])
shapiro_test((anova_result_all_freq_psd$`sub:config`$residuals))

# post hoc tests
pairwise.t.test(freq_psd[,1],freq_psd[,3],p.adj = "bonf") # montage
pairwise.t.test(freq_psd[,1],freq_psd[,4],p.adj = "bonf") # direction

pairwise.t.test(roll_freq_psd[,1],roll_freq_psd[,3],p.adj = "bonf") # roll only montage
pairwise.t.test(pitch_freq_psd[,1],pitch_freq_psd[,3],p.adj = "bonf") # pitch only montage

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
pitch_mag %>% 
  group_by(config) %>% 
  get_summary_stats(Var, type = "mean_sd")

#outliers
pitch_mag %>%
  group_by(config) %>%
  identify_outliers(Var)

# normaility assumption
pitch_mag %>%
  group_by(config) %>%
  shapiro_test(Var)
ggqqplot(pitch_mag, "Var", facet.by = "config")

# homoscedascity assumption
pitch_mag_model <- lm(Var ~ config, data = pitch_mag)
plot(pitch_mag_model$fitted.values, resid(pitch_mag_model),
     xlab = "Fitted Values", ylab = "Residuals",
     main = "Residuals vs Fitted")
abline(h = 0, col = "red")

bptest(pitch_mag_model)

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
