# Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999-2008?

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

# If the source is related to coal combustion, both "coal" and "comb" 
# will be present in the SCC$Short.Name vector. We want a logical vector 
# of the location of these sources
coal <- grepl("coal", ignore.case = TRUE, SCC$Short.Name)
comb <- grepl("comb", ignore.case = TRUE, SCC$Short.Name)
coal_comb <- coal & comb

# Subset the SCC data into coal combustion related sources only
coal_combSCC <- SCC[coal_comb, ]

# Use the SCC codes to identify the relevant rows in the NEI dataset
coal_combNEI <- NEI[NEI$SCC %in% coal_combSCC$SCC, ]

# Aggregate the data by year 
aggData <- aggregate(Emissions ~ year, coal_combNEI, sum)

# Plot the data using a barplot in the base plotting system. The emissions in tons
# are divided by 1000 to give kilotons for clarity on the y-axis.
png(filename = "plot4.png")
barplot(aggData$Emissions/1000, names.arg = aggData$year, main = 
          "Total PM2.5 emissions from coal combustion-related sources", ylab = 
          "PM2.5 emissions, kilotons", xlab = "Year", ylim = c(0, 650))
dev.off()

