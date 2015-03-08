# Checks to see if the data is in any reasonable location, if it can't find it or the base zip file, then it downloads and extracts to a data subfolder. 
if(file.exists("data/household_power_consumption.txt")){
        filedest = "data/household_power_consumption.txt"
} else if(file.exists("household_power_consumption.txt")){
        filedest = "household_power_consumption.txt"
} else if(file.exists("exdata_data_household_power_consumption.zip")){
        require(utils)
        unzip("exdata_data_household_power_consumption.zip", exdir = "data")
        filedest = "data/household_power_consumption.txt"
} else {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "exdata_data_household_power_consumption.zip", method = "curl")
        require(utils)
        unzip("exdata_data_household_power_consumption.zip", exdir = "data")
        filedest = "data/household_power_consumption.txt"
}

# This data set is very large, so I only want to extract the relevant data when reading the text file into R storage. Will only be using data from 2007-02-01 and 2007-02-02.  These start at row 66638 and end at row 69517 (for a total of 2880 rows)
# the header will be read in seperately

# The column names, read seperately. 
heads <- read.table("data/household_power_consumption.txt",sep =";",nrows = 1)
dat <- read.table("data/household_power_consumption.txt", sep = ";", skip = 66637, nrows = 2880, na.strings = "?", stringsAsFactors = FALSE)
heads <- sapply(heads, as.character)
colnames(dat)<-heads
dat$DateTime <- strptime(paste(dat$Date,dat$Time), format ="%d/%m/%Y %T")

png(filename = "plot3.png")
plot(dat$DateTime,dat$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
lines(dat$DateTime,dat$Sub_metering_1)
lines(dat$DateTime, dat$Sub_metering_2,col="red")
lines(dat$DateTime, dat$Sub_metering_3,col="blue")
legend("topright", lty=1, col = c("black","blue","red"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()



