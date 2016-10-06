#Check whether the raw data has been downloaded, and download it if necessary
data_local <- "~/Coursera/Data Science JHU/004 Exploratory Data Analysis/Week 4 Course Project/rawdata.zip"
data_URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if (!file.exists(data_local)){
  download.file(data_URL, data_local)
}

#Check whether the raw data has been unzipped and unzip if necessary
data_unzipped <- "~/Coursera/Data Science JHU/004 Exploratory Data Analysis/Week 4 Course Project/data"
if(!dir.exists(data_unzipped)){
  dir.create(data_unzipped)
  unzip(data_local, exdir = data_unzipped)
}
 
print("u mad bro?")
