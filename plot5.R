# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

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

# From looking through the data, motor vehicle sources can be interpreted 
# as anything with "motor" OR "vehicle" in the SCC$Short.Name vector. 
motor <- grepl("motor", SCC$Short.Name, ignore.case = TRUE)
vehicle <- grepl("vehicle", SCC$Short.Name, ignore.case = TRUE)
motor_vehicle <- vehicle | motor

# Subset the SCC data into motor vehicle related sources only
motor_vehicleSCC <- SCC[motor_vehicle, ]

# Use the SCC codes to identify the relevant rows in the NEI dataset
motor_vehicleNEI <- NEI[NEI$SCC %in% motor_vehicleSCC$SCC , ] 

# Selects only the data for Baltimore City, Maryland (fips = "24510")
BaltMVData <- motor_vehicleNEI[motor_vehicleNEI$fips == "24510" , ] 

# Aggregate the data by year
aggData <- aggregate(Emissions ~ year, BaltMVData, sum)

# Plot the data using a barplot in the base plotting system
png(filename = "plot5.png")
barplot(aggData$Emissions, names.arg = aggData$year, main =
          "Emissions from motor vehicle-related sources in Baltimore City", ylab =
          "PM2.5 emissions, tons", xlab = "Year")
dev.off()

