# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999-2008 
# for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the 
# ggplot2 plotting system to make a plot answer this question.

library(ggplot2)

# Check whether the raw data has been downloaded, and download it if necessary
data_local <- "~/Coursera/Data Science JHU/004 Exploratory Data Analysis/Week 4 Course Project/rawdata.zip"
data_URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if (!file.exists(data_local)){
  download.file(data_URL, data_local)
}

# Check whether the raw data has been unzipped and unzip if necessary
data_unzipped <- "~/Coursera/Data Science JHU/004 Exploratory Data Analysis/Week 4 Course Project/data"
if(!dir.exists(data_unzipped)){
  dir.create(data_unzipped)
  unzip(data_local, exdir = data_unzipped)
}

# Check if data is already loaded, takes a while to reload each time
reload.data <- (readline(" Reload data? (Y/N) "))

if(reload.data == "Y") {
  # Copied from assignment instruction on reading RDS files 
  NEI <- readRDS("data/summarySCC_PM25.rds")
  SCC <- readRDS("data/Source_Classification_Code.rds")
}

# Selects only the data for Baltimore City, Maryland (fips = "24510")
BaltData <- NEI[NEI$fips == "24510", ]

# Changes year from an integer to a factor
BaltData$year <- as.factor(BaltData$year)

# Plot the data using a barplot in the ggplot2 system. 
png(filename = "plot3.png") 

a <- ggplot(data = BaltData, aes(x = year, y = Emissions, fill = type)) + 
  geom_bar(stat = "identity") + facet_grid(.~type) + guides(fill = FALSE)  + 
  xlab("Year") + ylab("PM2.5 Emissions, tons") + 
  labs(title = "Emissions in Baltimore City, MD, by type of source")

print(a)

dev.off()
