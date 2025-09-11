#1# add libraries needed
library(tidyverse)
library(ggpubr)
library(rstatix)
library(dplyr)
library('ARTool')
library(lmtest)
library(BradleyTerry2)

library(lme4)
library(lmerTest)
library(emmeans)


#navigate to the directory
setwd("C:/Users/caroa/OneDrive/Documents")
#load all data organized by coupling scheme
#C:/Users/Caroline Austin/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS
freq_power<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/DataC/freq_power_anova.csv")
freq_psd<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/DataC/freq_psd_anova.csv")
verbal<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/DataC/verbal.csv")
congruent<-read.csv(file = "C:/Users/caroa/UCB-O365/Bioastronautics File Repository - File Repository/Torin Group Items/Projects/Motion Coupled GVS/NewPitchMontageTesting/DataC/congruent.csv")

verbal$condition1 <-factor(verbal$condition1)
verbal$condition2 <-factor(verbal$condition2)

congruent$SID <-factor(congruent$SID)

freq_power$type <- factor(freq_power$type)
freq_power$freq_interest <- factor(freq_power$freq_interest)
freq_power$config <- factor(freq_power$config)
freq_power$dir <- factor(freq_power$dir)
freq_power$sub <- factor(freq_power$sub)
freq_power$mA <- factor(freq_power$mA)
freq_power$condition <- paste(freq_power$config, freq_power$mA)
freq_power$condition <-factor(freq_power$condition)

#freq_power<-subset(freq_power, mA != "0.1")
#freq_power<-subset(freq_power, mA != "1")
#freq_power<-subset(freq_power, mA != 0.1)
#freq_power<-subset(freq_power, mA != 1)
#freq_power<-subset(freq_power, order <= 6)

pitch_power<-subset(freq_power, dir == "pitch")
roll_power<-subset(freq_power, dir == "roll")
# (mA == "1" & config == "Four")
#   (mA == "2" & config == "Three")

#freq_power1 <-subset(freq_power, ((mA == "1" & config == "Four") | (mA == "2" & config == "Three")) )
#freq_power2 <-subset(freq_power, ((mA == "2" & config == "Four") | (mA == "4" & config == "Three")) )

freq_power1 <-subset(freq_power, ((mA == "1" & config == "Four") | (mA == "1" & config == "Three")) )
freq_power2 <-subset(freq_power, ((mA == "2" & config == "Four") | (mA == "2" & config == "Three")) )

pitch_power1 <-subset(freq_power1,  dir == "pitch" )
pitch_power2 <-subset(freq_power2,  dir == "pitch" )


temples_power <- subset(freq_power, config == "Four")
shoulder_power <- subset(freq_power, config == "Three")


freq_psd$type <- factor(freq_psd$type)
freq_psd$freq_interest <- factor(freq_psd$freq_interest)
freq_psd$config <- factor(freq_psd$config)
freq_psd$dir <- factor(freq_psd$dir)
freq_psd$sub <- factor(freq_psd$sub)
freq_psd$mA <- factor(freq_psd$mA)
freq_psd$condition <- paste(freq_psd$config, freq_psd$mA)
freq_psd$condition <-factor(freq_psd$condition)

pitch_psd<-subset(freq_psd, dir == "pitch")
roll_psd<-subset(freq_psd, dir == "roll")
# (mA == "1" & config == "Four")
#   (mA == "2" & config == "Three")

#freq_psd1 <-subset(freq_psd, ((mA == "1" & config == "Four") | (mA == "2" & config == "Three")) )
#freq_psd2 <-subset(freq_psd, ((mA == "2" & config == "Four") | (mA == "4" & config == "Three")) )

freq_psd1 <-subset(freq_psd, ((mA == "1" & config == "Four") | (mA == "1" & config == "Three")) )
freq_psd2 <-subset(freq_psd, ((mA == "2" & config == "Four") | (mA == "2" & config == "Three")) )

freq_psd_match <-subset(freq_psd, ((mA == "1" & config == "Four") | (mA == "1" & config == "Three") | (mA == "2" & config == "Four") | (mA == "2" & config == "Three")) | (mA =="0.1") )

pitch_psd1 <-subset(freq_psd1,  dir == "pitch" )
pitch_psd2 <-subset(freq_psd2,  dir == "pitch" )
pitch_psd_match <-subset(freq_psd_match,  dir == "pitch" )

temples_psd <- subset(freq_psd, config == "Four")
shoulder_psd <- subset(freq_psd, config == "Three")


####################################
# run verbal stats -> checking binomial probability?
t.test(verbal$motion_wins1, mu = 10)

total_wins =  # there are 2 forced choice comparisons per condition
total_responses = 20; # 2*10 subj

# motion
# all are significantly different from 0.5 in the expected direction except the 2 conditions
# where current at the mastoids is the same (1 and 10 where p is around 0.5)
binom.test(verbal$motion_wins1[1], total_responses, p=0.5) # Temples 1mA, Shoulder 2mA 
binom.test(verbal$motion_wins1[2], total_responses, p=0.5) # Temples 2mA, Shoulder 2mA
binom.test(verbal$motion_wins1[3], total_responses, p=0.5) # Temples 3mA, Shoulder 2mA
binom.test(verbal$motion_wins1[4], total_responses, p=0.5) # Temples 4mA, Shoulder 2mA
binom.test(verbal$motion_wins1[5], total_responses, p=0.5) # Temples 1mA, Shoulder 3mA 
binom.test(verbal$motion_wins1[6], total_responses, p=0.5) # Temples 2mA, Shoulder 3mA 
binom.test(verbal$motion_wins1[7], total_responses, p=0.5) # Temples 3mA, Shoulder 3mA 
binom.test(verbal$motion_wins1[8], total_responses, p=0.5) # Temples 4mA, Shoulder 3mA 
binom.test(verbal$motion_wins1[9], total_responses, p=0.5) # Temples 1mA, Shoulder 4mA 
binom.test(verbal$motion_wins1[10], total_responses, p=0.5) # Temples 2mA, Shoulder 4mA 
binom.test(verbal$motion_wins1[11], total_responses, p=0.5) # Temples 3mA, Shoulder 4mA 
binom.test(verbal$motion_wins1[12], total_responses, p=0.5) # Temples 4mA, Shoulder 4mA 


# tingling
# all are significantly different from 0.5 in the expected direction except the 2 conditions
# where current at the mastoids is the same (1 and 10 where p is around 0.5)
binom.test(verbal$tingling_wins1[1], total_responses, p=0.5) # Temples 1mA, Shoulder 2mA 
binom.test(verbal$tingling_wins1[2], total_responses, p=0.5) # Temples 2mA, Shoulder 2mA
binom.test(verbal$tingling_wins1[3], total_responses, p=0.5) # Temples 3mA, Shoulder 2mA
binom.test(verbal$tingling_wins1[4], total_responses, p=0.5) # Temples 4mA, Shoulder 2mA
binom.test(verbal$tingling_wins1[5], total_responses, p=0.5) # Temples 1mA, Shoulder 3mA 
binom.test(verbal$tingling_wins1[6], total_responses, p=0.5) # Temples 2mA, Shoulder 3mA 
binom.test(verbal$tingling_wins1[7], total_responses, p=0.5) # Temples 3mA, Shoulder 3mA 
binom.test(verbal$tingling_wins1[8], total_responses, p=0.5) # Temples 4mA, Shoulder 3mA 
binom.test(verbal$tingling_wins1[9], total_responses, p=0.5) # Temples 1mA, Shoulder 4mA 
binom.test(verbal$tingling_wins1[10], total_responses, p=0.5) # Temples 2mA, Shoulder 4mA 
binom.test(verbal$tingling_wins1[11], total_responses, p=0.5) # Temples 3mA, Shoulder 4mA 
binom.test(verbal$tingling_wins1[12], total_responses, p=0.5) # Temples 4mA, Shoulder 4mA 


# visual
# all are significantly different from 0.5 in the expected direction except the 2 conditions
# where current at the mastoids is the same (1 and 10 where p is around 0.5)
binom.test(verbal$vis_wins1[1], total_responses, p=0.5) # Temples 1mA, Shoulder 2mA 
binom.test(verbal$vis_wins1[2], total_responses, p=0.5) # Temples 2mA, Shoulder 2mA
binom.test(verbal$vis_wins1[3], total_responses, p=0.5) # Temples 3mA, Shoulder 2mA
binom.test(verbal$vis_wins1[4], total_responses, p=0.5) # Temples 4mA, Shoulder 2mA
binom.test(verbal$vis_wins1[5], total_responses, p=0.5) # Temples 1mA, Shoulder 3mA 
binom.test(verbal$vis_wins1[6], total_responses, p=0.5) # Temples 2mA, Shoulder 3mA 
binom.test(verbal$vis_wins1[7], total_responses, p=0.5) # Temples 3mA, Shoulder 3mA 
binom.test(verbal$vis_wins1[8], total_responses, p=0.5) # Temples 4mA, Shoulder 3mA 
binom.test(verbal$vis_wins1[9], total_responses, p=0.5) # Temples 1mA, Shoulder 4mA 
binom.test(verbal$vis_wins1[10], total_responses, p=0.5) # Temples 2mA, Shoulder 4mA 
binom.test(verbal$vis_wins1[11], total_responses, p=0.5) # Temples 3mA, Shoulder 4mA 
binom.test(verbal$vis_wins1[12], total_responses, p=0.5) # Temples 4mA, Shoulder 4mA 

# metallic
# all are significantly different from 0.5 in the expected direction except the 2 conditions
# where current at the mastoids is the same (1 and 10 where p is around 0.5)
binom.test(verbal$metallic_wins1[1], total_responses, p=0.5) # Temples 1mA, Shoulder 2mA 
binom.test(verbal$metallic_wins1[2], total_responses, p=0.5) # Temples 2mA, Shoulder 2mA
binom.test(verbal$metallic_wins1[3], total_responses, p=0.5) # Temples 3mA, Shoulder 2mA
binom.test(verbal$metallic_wins1[4], total_responses, p=0.5) # Temples 4mA, Shoulder 2mA
binom.test(verbal$metallic_wins1[5], total_responses, p=0.5) # Temples 1mA, Shoulder 3mA 
binom.test(verbal$metallic_wins1[6], total_responses, p=0.5) # Temples 2mA, Shoulder 3mA 
binom.test(verbal$metallic_wins1[7], total_responses, p=0.5) # Temples 3mA, Shoulder 3mA 
binom.test(verbal$metallic_wins1[8], total_responses, p=0.5) # Temples 4mA, Shoulder 3mA 
binom.test(verbal$metallic_wins1[9], total_responses, p=0.5) # Temples 1mA, Shoulder 4mA 
binom.test(verbal$metallic_wins1[10], total_responses, p=0.5) # Temples 2mA, Shoulder 4mA 
binom.test(verbal$metallic_wins1[11], total_responses, p=0.5) # Temples 3mA, Shoulder 4mA 
binom.test(verbal$metallic_wins1[12], total_responses, p=0.5) # Temples 4mA, Shoulder 4mA 

########

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
##################################
# stats on consistency between sway and verbal reports
t.test(congruent$correct, mu = 0.5)

total_congruent = sum(congruent$correct)*28 # there are 28 forced choice comparisons
total_responses = 280; # 28*10 subj

binom.test(total_congruent, total_responses, p=0.5)

################################# IMU stats
# run linear mixed model
pitch_power_lme_model <- lmer(Var ~ config * mA + (1 | sub), data = pitch_power)

# run pitch only anova
# pooling the pitch data there is no difference between the montages
pitch_power.aov <- anova_test(data = pitch_power[,1:8], dv = Var, wid = sub, within = c(  "config", "order", "mA" ))
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
pairwise.t.test(freq_power[,1],freq_power[,5],p.adj = "bonf") # current amplitude
pairwise.t.test(freq_power[,1],freq_power[,3],p.adj = "bonf") # order

pairwise.t.test(roll_power[,1],roll_power[,4],p.adj = "bonf") # roll only montage
##use this one for the paperv
pairwise.t.test(pitch_power[,1],pitch_power[,9],p.adj = "bonf") # pitch only montage
pairwise.t.test(pitch_power[,1],pitch_power[,9],p.adj = "none") # pitch only montage

pairwise.t.test(freq_power1[,1],freq_power1[,4],p.adj = "bonf") #diff in sway for montage in pitch and roll at 1mA
pairwise.t.test(freq_power2[,1],freq_power2[,4],p.adj = "bonf") # diff in sway for montage in pitch and roll at 2mA

pairwise.t.test(pitch_power1[,1],pitch_power1[,4],p.adj = "bonf") #diff in sway for montage in pitch at 1mA
pairwise.t.test(pitch_power2[,1],pitch_power2[,4],p.adj = "bonf") #diff in sway for montage in pitch at 2mA

########## median stats
pitch_psd.aov <- anova_test(data = pitch_psd[,1:8], dv = Var, wid = sub, within = c(  "config", "mA" ))
get_anova_table(pitch_psd.aov)

anova_result_pitch_psd <- aov(Var ~  config  + Error(sub/(config)), data = pitch_psd[,1:6])
shapiro_test((anova_result_pitch_psd$`sub:config`$residuals))

pairwise.t.test(pitch_psd[,1],pitch_psd[,8],p.adj = "bonf") # pitch only montage

pairwise.t.test(freq_psd1[,1],freq_psd1[,3],p.adj = "bonf") #diff in sway for montage in pitch and roll at 1mA
pairwise.t.test(freq_psd2[,1],freq_psd2[,3],p.adj = "bonf") # diff in sway for montage in pitch and roll at 2mA

pairwise.t.test(pitch_psd1[,1],pitch_psd1[,3],p.adj = "bonf") #diff in sway for montage in pitch at 1mA
pairwise.t.test(pitch_psd2[,1],pitch_psd2[,3],p.adj = "bonf") #diff in sway for montage in pitch at 2mA

pairwise.t.test(pitch_psd_match[,1],pitch_psd_match[,8],p.adj = "bonf") # pitch only montage

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
