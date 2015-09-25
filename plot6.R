#######################################################################
#
# Exploratory Data Analysis Project 2 - plot6.R
# Written By: madrxn (https://github.com/madrxn)
#
# GOAL: Use the ggplot2 plotting system to compare total emissions form  
#       on-road motor vehicle sources in Baltimore and Los Angeles from  
#       1999 to 2008.
# 
# plot6.R script does the following:
#   1) reads in PM2.5 emissions data (summarySCC_PM25.rds) and subsets 
#      selected column for Baltimore (fips=24510) and LA (fips=06037)
#   2) reads in Classification Code Table (SCC) 
#      ("Source_Classification_Code.rds") and subsets for Mobile On-Road 
#      Vehicles in EI.Sector column
#   3) mereges emissions and SCC subsetted data frames
#   4) recodes fips data values and stores in City column
#   5) ecodes EI.Sector data values and stores in On.Road.Vehicle column
#   6) opens png device, creates "plot6.png" in working directory
#   7) creats overlay plot of total emissions by year for each on-road 
#      vehicle type, using qplot, and prints output to plot6.png
#   8) closes png device
#
########################################################################

#load dplyr and ggplot2
library(dplyr)
library(ggplot2)


#1) reads in PM2.5 emissions data and subsets selected columns for Baltimore (fips=24510) and LA (fips=06037)
NEI <- readRDS("./summarySCC_PM25.rds")
NEI <- NEI %>%
        select(fips, SCC, year, Emissions) %>%
        subset(fips=="24510" | fips=="06037")

#2) reads in Classification Code Table (SCC) and subsets for Mobile On-Road Vehicles
SCC <- readRDS("Source_Classification_Code.rds")
i <- grep("Mobile.*vehicle", SCC$EI.Sector, ignore.case=TRUE)
SCC <- SCC[i,]

#3) mereges NEI and SCC subsetted data frames
Mobile.Vehicle <- merge(NEI,SCC, by = "SCC")

#4) recodes fips data and stores in City column
Mobile.Vehicle$City[Mobile.Vehicle$fips=="24510"] <- "Baltimore"
Mobile.Vehicle$City[Mobile.Vehicle$fips=="06037"] <- "Los Angeles"

#5) recodes EI.Sector data and stores in On.Road.Vehicle column
Mobile.Vehicle$On.Road.Vehicle[Mobile.Vehicle$EI.Sector=="Mobile - On-Road Diesel Heavy Duty Vehicles"] <- "Diesel Heavy Duty"
Mobile.Vehicle$On.Road.Vehicle[Mobile.Vehicle$EI.Sector=="Mobile - On-Road Diesel Light Duty Vehicles"] <- "Diesel Light Duty"
Mobile.Vehicle$On.Road.Vehicle[Mobile.Vehicle$EI.Sector=="Mobile - On-Road Gasoline Heavy Duty Vehicles"] <- "Gasoline Heavy Duty"
Mobile.Vehicle$On.Road.Vehicle[Mobile.Vehicle$EI.Sector=="Mobile - On-Road Gasoline Light Duty Vehicles"] <- "Gasoline Light Duty"

#5) opens png device
png(filename = "./plot6.png", width = 650, height = 480, units = "px")

#6) creats two-facet overlay plot of total emissions by year for each on-road vehicle type in Baltimore and LA
qp <- qplot(year, Emissions, data=Mobile.Vehicle,
            color = On.Road.Vehicle, 
            geom = c("line", "point"),
            facets= .~ City,
            stat = "summary",
            fun.y = "sum",
            xlab = "Year",
            ylab = "Total PM2.5 Emissions (ton)",
            main = "Emissions For On-Road Motor Vehicle Sources In \n  Baltimore and Los Angeles From 1999 to 2008.")
print(qp)

#7) turns off png device
dev.off()




########################################################################
#
# Plots total emissions by year for all on-road motor vehicles for each  
# city
#
# qp <- qplot(year, Emissions, data=Mobile.Vehicle,
#            color = City, 
#            geom = c("line", "point"),
#            stat = "summary",
#            fun.y = "sum",
#            xlab = "Year",
#            ylab = "Total PM2.5 Emissions (ton)",
#            main = "Emissions For On-Road Motor Vehicle Sources In \n  Baltimore and Los Angeles From 1999 to 2008.")
# print(qp)