# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the 
# base plotting system, make a plot showing the total PM2.5 emission from all sources for each 
# of the years 1999, 2002, 2005, and 2008.

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

# Aggregate the data by year 
aggData <- aggregate(Emissions ~ year, NEI, sum)

# Plot the data using a barplot in the base plotting system. The emissions in tons
# are divided by 1000 to give kilotons for clarity on the y-axis.
png(filename = "plot1.png")
barplot(aggData$Emissions/1000, names.arg = aggData$year, main = 
          "Total PM2.5 emissions in the United States", ylab = 
          "PM2.5 emissions, kilotons", xlab = "Year")
dev.off()
