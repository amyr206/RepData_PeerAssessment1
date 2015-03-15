# setwd("C:/Users/Amy Richards/Documents/r_programming/reproresearch/project1/RepData_PeerAssessment1")

# Copyright Amy Richards 2015

# PURPOSE:
# --------
# This script is the code for Peer Assessment 1 markdown project for the Johns  
# Hopkins Coursera Data Science Specialization class, Reproducible Research.
# This is not the actual project, which needs to be submitted as an .Rmd
# Project description:
# https://class.coursera.org/repdata-012/human_grading/view/courses/973513/assessments/3/submissions

# WHAT THIS SCRIPT DOES:
# ----------------------
# Uses data from personal monitoring/fitness devices to make a few plots
# Unzips data from a zipfile in my forked repo
# Cleans the data
# Calcs total steps/day, creates a histogram, calcs mean/median of total steps
# Creates timeseries plot across intervals of avg steps, identify interval w/max 
# of steps
# Identifies missing data and impute missing values, create histogram, 
# calc mean/median
# Differentiate weekdays/weekends, create panel timeseries across intervals of
# avg steps
# 
# OUTPUT:
# -------
# Plots

# REQUIRED FILES:
# ---------------
# This script assumes that the repo was forked correctly and the user's working
# directory is set to it.

# REQUIRED LIBRARIES:
# -------------------
# dplyr, lubridate, and stringr are used. If you don't have them installed, use
# install.packages(c("dplyr", "lubridate", "stringr")before running this script.

# load our buddies lubridate and stringr
library("dplyr")
library("lubridate")
library("stringr")


# read the data
rawdata <- read.table(unz("activity.zip", "activity.csv"), 
                      header = TRUE, 
                      sep = ",", 
                      na.strings = "NA")

# create a tidy analysis dataset with all the necessary fields to conduct the 
# analysis.
# - We'll be making time series plots, so create a new column in which the values 
# in the date and interval columns are converted to POSIXct format
# - Impute missing values from the interval column in a new column
# - We'll be comparing weekdays and weekends, so create a new column with
# - weekday/weekend factor

oldanalysisdata <- tbl_df(rawdata) %>% 
        mutate(dateandtime = ymd_hms(paste(date, str_pad(interval, 4, pad = 0), "00"))) %>%
        filter(!is.na(steps)) %>%
        group_by(interval) %>%
        summarize(meansteps = mean(steps)) 


testanalysisdata <- tbl_df(rawdata) %>% 
        mutate(intervalstoplot = ymd_hms(paste(today(), str_pad(interval, 4, pad = 0), "00"))) %>%
        filter(!is.na(steps)) %>%
        group_by(intervalstoplot) %>%
        summarize(meansteps = mean(steps))

dailystepsimputed <- tbl_df(rawdata) %>% 
        filter(is.na(steps)) %>%
        left_join(avgsteps, by = "interval") %>%
        select(date, interval, meansteps) %>%
        rename("steps" = meansteps)

dailystepscompletecases <- tbl_df(rawdata) %>%
        filter(!is.na(steps))

sumalldailysteps <- dailystepsimputed %>%
        bind_rows(dailystepscompletecases) %>%
        group_by(date) %>%
        summarize(sumsteps = sum(steps))

        
#count(analysisdata, is.na(steps))
