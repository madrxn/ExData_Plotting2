########################################################################
#
# Exploratory Data Analysis Project 2 - plot2.R
# Written By: madrxn (https://github.com/madrxn)
#
# GOAL: Use the base plotting system to explore if the total emissions
#       for PM2.5 decreased in the Baltimore City (fips=24510) from
#       1999 to 2008.
#
# plot2.R script does the following:
#   1) reads PM2.5 emissions data (summarySCC_PM25.rds)
#   2) selectes desired columns (fips,Emissions, and year) and subsets 
#      by Baltimore City (fips=24510)
#   3) calculates total emissions for each year (1999,2002,2005,2008)
#   4) opens png device, creates "plot2.png" in working directory
#   5) generates plot of total PM2.5 Emissions by year and sends output  
#      to plot2.png
#   6) closes png device
#
########################################################################

# loads dplyr
library(dplyr)

#1) reads in PM2.5 emissions data for 1999, 2002, 2005, and 2008
NEI <- readRDS("./summarySCC_PM25.rds")

#2) selects desired columns and subsets by Baltimore (fips=24510)
NEI <- NEI %>%
        select(fips, year, Emissions) %>%
        subset(fips==24510)

#3) groups subseted data by year and calculates the total emissions for each year
total <- NEI %>%
         group_by(year) %>%
         summarize(Emissions = sum(Emissions))

#4) opens png device
png(filename = "./plot2.png", width = 650, height = 480, units = "px")

#5) plots total Emissiosn by year
with(total, plot(year, Emissions,
                 type = "b", 
                 xlab = "Year", 
                 ylab = "Total PM2.5 Emissions (ton)", 
                 main = "Total PM2.5 Emissions for Baltimore City\n From 1999, 2002, 2005, 2008",
                 sub = "There was an overall decrease in PM2.5 from 1999 to 2008.",
                 font.sub = 3))

#6) turns off png device
dev.off()
