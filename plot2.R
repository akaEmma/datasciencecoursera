## household pow consumption project for Week 1 of Exploratory Data Analysis
## This first bit is all data prep

# load the file
pow$Date <- as.Date(pow$Date, format = "%d/$m/%Y") #reformat Date for ease of use later

## fix the date format

library(lubridate) #load the package for fixing the date nicely
pow$Date <- dmy(pow$Date) #fix the date nicely

## select the time we're interested in
## it is the subset of "pow" where the date ranges from 2/1/2007 to 2/2/2007

ourtime <- pow[(pow$Date=="2007-02-01") | (pow$Date=="2007-02-02"),]

## Now get everything into the correct format for plotting

ourtime$Global_active_power <- as.numeric(as.character(ourtime$Global_active_power))
ourtime$Global_reactive_power <- as.numeric(as.character(ourtime$Global_reactive_power))
ourtime$Voltage <- as.numeric(as.character(ourtime$Voltage))
ourtime <- transform(ourtime, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")
ourtime$Sub_metering_1 <- as.numeric(as.character(ourtime$Sub_metering_1))
ourtime$Sub_metering_2 <- as.numeric(as.character(ourtime$Sub_metering_2))
ourtime$Sub_metering_3 <- as.numeric(as.character(ourtime$Sub_metering_3))

### End of data prep

### Plot 2

plot2 <- function(ourtime) {
  plot(ourtime$timestamp,ourtime$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
  dev.copy(png, file="plot2.png", width=480, height=480)
  dev.off()
}
