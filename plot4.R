#######################################################################
#
# Exploratory Data Analysis Project 2 - plot4.R
# Written By: madrxn (https://github.com/madrxn)
#
# GOAL: Use the ggplot2 plotting system to explore how US emissions
#       form Coal Combustion-Related Sources have changed from 1999 
#       to 2008.
#
# plot4.R script does the following:
#   1) reads PM2.5 emissions data (summarySCC_PM25.rds) and  
#      
#   2) reads Classification Code Table ("Source_Classification_Code.rds")  
#      and subsets SCC data based EI.Sector having "Comb" and "Coal", for
#      coal combustion-realted sources
#   3) merges NEI data with substed SCC data
#   4) recodes EI.Sector data and stores recoded values in Sources
#      column 
#   5) opens png device, creates "plot4.png" in working directory
#   6) creats overlay plot of total emissions by year for each Coal 
#      Combustion-Related Sources. uses qplot arguments 'color=type' to  
#      subset for "Sources" with 'stat=summary' and 'fun.y=sum' to  
#      calculate total emissions. prints output to plot4.png 
#   7) closes png device
#
########################################################################

# loads dplyr and ggplot2
library(dplyr)
library(ggplot2)

#1) reads in PM2.5 emissions dataSource Classification Code Table (SCC)
NEI <- readRDS("./summarySCC_PM25.rds")

#2) reads in Source Classification Code data (SCC) and subsets for coal 
#   combustion-related sources based on EI.Sector  
SCC <- readRDS("Source_Classification_Code.rds")
i <- grep("Comb.*Coal", SCC$EI.Sector, ignore.case=TRUE)
coal <- SCC[i,]

#3) merges data for subseted data 
coal <- merge(NEI,coal, by = "SCC")

#4) recodes EI.Sector data and stores recoded values in Sources column 
coal$Sources[coal$EI.Sector=="Fuel Comb - Comm/Institutional - Coal"] <- "Comm/Institutional"
coal$Sources[coal$EI.Sector=="Fuel Comb - Electric Generation - Coal"] <- "Electric Generation"
coal$Sources[coal$EI.Sector=="Fuel Comb - Industrial Boilers, ICEs - Coal"] <- "Industrial Boilers, ICEs"


#5) opens png device
png(filename = "./plot4.png", width = 650, height = 480, units = "px")


#6) creats overlay plot of total emissions by year for each sector
qp <- qplot(year, Emissions, data=coal,
        color = Sources, 
        geom = c("line", "point"),
        stat = "summary",
        fun.y = "sum",
        xlab = "Year",
        ylab = "Total PM2.5 Emissions (ton)",
        main = "US Emissions From Coal Combustion-Related Sources \n From 1999 to 2008.")
print(qp)

#7) turns off png device
dev.off()







###########################################################################
#     Plots Total Emissions From All Coal Combustion-Related Sources 
#                Alternate Way To Plot using base plotting
#
# total <- coal %>%
#        group_by(year) %>%
#        summarize(Emissions = sum(Emissions))
#
# with(total, plot(year, Emissions, 
#                 type = "b", 
#                 xlab = "Year", 
#                 ylab = "Total PM2.5 Emissions (ton)", 
#                 main = "US Emissions From All Coal Combustion-Related Sources \n From 1999 to 2008.",
#                 sub = "PM2.5 Emissions in the US decreased from 1999 to 2008",
#                 font.sub = 3))
#
###########################################################################