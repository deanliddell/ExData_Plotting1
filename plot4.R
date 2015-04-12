# ------------------------------------------------------------------------------
# B E G I N   D A T A S E T
# ------------------------------------------------------------------------------
# Create a subset of the household_power_consumption.txt when reading file to 
# match the assignment: Date/Time range = 01/02/2007 00:00:00 -> 03/02/2007 
# 00:00:00
#
# Note: source file is in working directory; also, using Notepad++ for a quick 
# check of the file, determined that the first record started at 16/12/2006 
# 17:24:00 and the following instruction had to skip 66636 records to start at 
# 01/02/2007 00:00:00 and read 2881 rows to end at 03/02/2007 00:00:00. (This
# approach is specific to this assignment; were this file put to other use, then
# a search and compare operation (i.e. grep) would have to be used to find the
# starting and ending records of interest.) Be sure to use the parameter 
# stringsAsFactors = FALSE to accommodate the later need to convert the character 
# fields to POSIXct calendar dates and times.
#
if (exists("household") && is.data.frame(get("household"))) {
  # We have already created the datset of interest.
  # Skip this step and go on to create the plot(s).
} else {
  household <- read.delim("household_power_consumption.txt", 
                          header = TRUE, 
                          sep = ";", 
                          skip = 66636, 
                          nrows = 2881, 
                          stringsAsFactors = FALSE)
  
  # After the data.frame is read into "household" the columns need to be renamed 
  # to the original schema. This became necessary because the "header" parameter
  # of the "read.delim" was ignored.
  #
  colnames(household) <- c("Date",
                           "Time",
                           "Global_active_power",
                           "Global_reactive_power",
                           "Voltage",
                           "Global_intensity",
                           "Sub_metering_1",
                           "Sub_metering_2",
                           "Sub_metering_3")
  
  # The structure of the Date and Time fields are "character" type. We need to 
  # convert these to POSIXct calendar dates and times. Note that we are using 
  # the original formats contained in the file, i.e., dd/mm/yyyy hh:mm:ss. The 
  # simplist method is to add a "DateTime" column to to table.
  #
  household$DateTime <- as.POSIXct(paste(as.Date(
                                   household$Date,
                                   format = "%d/%m/%Y"),
                                   household$Time))
}
# ------------------------------------------------------------------------------
# E N D   D A T A S E T
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# B E G I N   P L O T
# ------------------------------------------------------------------------------
# Plot 4 repeats plot 2 and plot 3, and graphs two additional relationships in a
# 2 X 2 grid. Since the assignment illustrates plot 2 above plot 3 we can
# determine that this grid is in column order.
#

# Set the output device driver to PNG and give the parameters to define the file
# size, default print size, background color, and type for windows.
#
png(file = "plot4.png",
    width = 480, 
    height = 480, 
    units = "px", 
    pointsize = 12,
    bg = "white",
    type = "cairo")

# Setting the query graphical paramaters (par) is key to rendering the correct
# grid format. We want to establish the column order (mfcol), and set the margin 
# (mar) around each plot c(bottom, left, top, right) and the out margin (oma) 
# around the entire graph c(bottom, left, top, right) 
#
par(mfcol = c(2,2), mar = c(4,4,2,1), oma = c(0,0,0,0))

# Use the "with" function to apply a block of expressions against the data such
# that the plot and its overlays produce a graph that displays the colors, axis
# axis labels, title, and legend illustrated in the project assignment. order
# the plots in the same order as the assignment (i.e. 2, 3, etc.).
#
with(household, {
     plot(Global_active_power ~ DateTime, 
          type = "l", 
          xlab = "",
          ylab = "Global Active Power")
     plot(Sub_metering_1 ~ DateTime, 
          type = "l", 
          xlab = "",
          ylab = "Energy sub metering")
     lines(Sub_metering_2 ~ DateTime, 
           col = "red")
     lines(Sub_metering_3 ~ DateTime, 
           col = "blue")     
     legend("topright",
            col = c("black","red","blue"),
            bty = "n",
            lty = 1,
            lwd = 2,
            legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
     plot(Voltage ~ DateTime, 
          type = "l", 
          xlab = "datetime", 
          ylab = "Voltage")
     plot(Global_reactive_power ~ DateTime,
          type = "l",
          xlab = "datetime",
          ylab = "Global_reactive_power")
})

# Turn this device driver (PNG) off (restore to console output).
#
dev.off()
