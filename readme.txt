General utility files
file_path_info
file_path_info2
get_filetype

X2A Pitch Montage Testing Analysis Code (GVSPostX2A_)

GVSPostX2A - 1: grabs reporting data from the excel sheet and then saves in a matlab file A20XX.m

GVSPostX2A_Aggregate - 3: takes each subjects A20XXExtract.m File and combines all of the responses into a single aggregate variable that contains info for all subjects. This data is saved in the main Data folder instead of the indv subject folders filename: All_X2A

GVSPostX2A_Plot - 4: has multiple different plots that can be generated depending on what is specified - some are now obselete

GVSPostX2ATest - 2: takes the raw data from A20XX.m and organizes the data into useful variables (map variables indicate the responses for different questions) then save into A20XXExtract.m

IMUmetrics

IndvSubjReports_plot: 4b

IndvSubjReportsAllProfMaxCurrent_plot: 4c

MapAreaPlot - function used in plotting scripts to make the sand plots

MapStackedBarPlot - function used in plotting scripts to make the stacked bar charts

MotionMap - I think that this function is obselete and replaced by TextMatchMap

PlotMap - 

RatingMap - I think that this function is obselete and replaced by TextMatchMap

TextMatchMap - not sure if this is the most uptodate (a different version may exist in GVSPostX2ATest) but basically checks a data column for specific a string(s) if it finds the string(s) then it records it in a "map" variable.

X1A Dynamic GVS + Tilt (Roll) in (TTS_GVS_ and GVSTTS)

PlotGVSTTSPerception - function that will plot Shot reports against actual tilt, tilt velocity, and commanded GVS

PlotGVSTTSPerceptionSHOTonly - function that plots Shot reports

SumOfSinesPlot

TTS_GVS_Files - 1: pulls data from the TTS output files and operator excel sheet and saves into matlab files - mostly stable for actual subjects - may need to make some improvements

TTS_GVS_GroupPlot - X: plots group data

TTS_GVS_GroupPlotSHOTonly - X: plots group data

TTS_GVS_IndvGroupByProfile - 2: takes individual trial data for a subject and groups the data based on the SumOfSines (physical motion) profile that was associated with the trial - I think that this is stable it can definitely handle extra trials, not sure about not enough profiles

TTS_GVSIndvPlot - 4: plots the shot reports for the individual subject across all 6 profiles and additive v. canceling GVS - this code is pretty stable can handle extra trials, not sure about not enough profiles

TTS_GVS_IndvPlotBiasAdjust 3(optional): calculates the average left/right bias across all of the no GVS trial and then applies the bias correction for all trials for that subject. This code is now stable though additional work could/should be done to make code more concise and commented.

TTS_GVS_Measures_Group:X? calculates and plots the RMS and Var for the aggregated/averaged data for the SHOT reports

TTS_GVS_Measures_Indv: 4 or 5? Calculates the RMS and Var for the subject's SHOT reports and then plots them - cannot currently handle extra or missing files

TTS_GVS_Sync_Check - was used to check that the TCP was working and that for the angle proportional GVS that it is in fact synced up

TTS_GVS_TrialCheck 3(optional): plots all of the GVS, tilt, and SHOT data so that we can verify that the correct trials were run and that the subject did the task properly - if any trial is not useable the matlab file generated for it should be deleted (can keep raw TTS excel file) and then in the operator excel sheet set the TTS trial number to 0. This code is now stable and can handle extra trials, not sure if can handle missing trials

TTSprofiles_lannaSOSedit - used to make the original TTS profiles ; the code that makes the GVS profiles based on the TTS profiles is stored elsewhere (can be found on the linux laptop)


