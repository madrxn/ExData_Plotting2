#######################################################################
#
# Exploratory Data Analysis Project 2 - plot3.R
# Written By: madrxn (https://github.com/madrxn)
#
# GOAL: Use the ggplot2 plotting system to explore which source type
#       (point,nonpoint,onroad,nonraod) variable had and increase or
#       decrease in total PM2.5 emissions for Baltimore (fips = 24510)
#       from 1999 to 2008.
#
# plot3.R script does the following:
#   1) reads data PM2.5 emissions data (summarySCC_PM25.rds)
#   2) selects desired columns (fips, year, type, Emissions)and subsets
#      based on Baltimore (fips=24510)
#   3) opens png device, creates "plot3.png" in working directory
#   4) creates overlay plot of total PM2.5 Emissions by year for each 
#      source "type". uses qplot arguments 'color=type' to subset for 
#      variable "type" with 'stat=summary' and 'fun.y=sum' to calculate 
#      total emissions. prints output to plot3.png
#   5) closes png device
#
########################################################################

# loads dplyr and ggplot2
library(dplyr)
library(ggplot2)

#1) reads data
NEI <- readRDS("./summarySCC_PM25.rds")

#2) selects desired columns and subsets by Baltimore (fips=24510)
NEI_Balt <- NEI %>%
            select(fips, year, type, Emissions) %>%
            subset(fips==24510)

#3) opens png device
png(filename = "./plot3.png", width = 650, height = 480, units = "px")

#4 creates overlay line plot of Emissions by Year grouped by type 
qp <- qplot(year, Emissions, data=NEI_Balt,
        color = type, 
        geom = c("line", "point"),
        stat = "summary",
        fun.y = "sum",
        xlab = "Year",
        ylab = "Total PM2.5 Emissions (ton)",
        main = "Total PM2.5 Emissions for Baltimore City From 1999 to 2008.")
print(qp)


#5) turns off png device
dev.off()




