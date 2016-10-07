# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

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
# Anything with type "ON-ROAD" should be included if it wasn't picked up already
motor_vehicleNEI <- NEI[NEI$SCC %in% motor_vehicleSCC$SCC | NEI$type == "ON-ROAD", ] 

# Selects only the data for Baltimore City, Maryland (fips = "24510")
BaltMVData <- motor_vehicleNEI[motor_vehicleNEI$fips == "24510" , ] 
# Selects only the data for LA COunty, California (fips = "06037")
LACMVData <- motor_vehicleNEI[motor_vehicleNEI$fips == "06037" , ] 

# Aggregate the data by year
BaltaggData <- aggregate(Emissions ~ year, BaltMVData, sum)
LACaggData <- aggregate(Emissions ~ year, LACMVData, sum)

# Plot the data using a barplot in the base plotting system
png(filename = "plot6.png", width = 800, height = 800) 
# There is no point just comparing the raw figures, as we are interested in 
# "Which city has seen greater changes over time", but LA County had far higher 
# emissions to begin with. Hence the raw values are compared on the same axis, 
# and then the data is scaled compared to the emissions in each area in 1999 
# to see how emissions have changed over time. 
#
# We see that LA County's emissions have stayed roughly constant whereas Baltimore 
# City's have more than halved.
#
par(mfrow = c(2, 2))
barplot(BaltaggData$Emissions, names.arg = BaltaggData$year, main =
          "Emissions from motor vehicle-related sources in Baltimore City", ylab =
          "PM2.5 emissions, tons", xlab = "Year", ylim = c(0, 5000)) 
barplot(LACaggData$Emissions, names.arg = LACaggData$year, main =
          "Emissions from motor vehicle-related sources in LA County", ylab =
          "PM2.5 emissions, tons", xlab = "Year", ylim = c(0, 5000))
barplot((BaltaggData$Emissions/BaltaggData[1,2]*100), names.arg = BaltaggData$year, main =
          "Scaled Baltimore City Emissions, 1999 = 100", ylab =
          "PM2.5 emissions, tons", xlab = "Year", ylim = c(0, 140)) 
barplot((LACaggData$Emissions/LACaggData[1,2]*100), names.arg = LACaggData$year, main =
          "Scaled LA County Emissions, 1999 = 100", ylab =
          "PM2.5 emissions, tons", xlab = "Year", ylim = c(0, 140)) 
dev.off()
