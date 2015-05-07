#Set to relevant working directoy where files are located
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

#load relevant libraries
library("XLConnect", quietly = TRUE)
library("dplyr")
library("stringr")
library("data.table")
library("lubridate")
library("ggplot2")

filename <- "weatherdata.xlsx"


# function to create list of sheets, insert filename
importWorksheets <- function(filename) {
  #load workbook
  workbook <- loadWorkbook(filename)
  #get sheet names
  sheet.names <- getSheets(workbook)
  #load worksheets
  return(sheet.list <- readWorksheet(workbook, sheet.names))
}

# function to create single dataframe from list of sheets
createDataframe <- function(sheet.list) {
  #length of list
  list.len <- length(sheet.list)
  #names of list elements
  list.names <- names(sheet.list)
  
  i <- 1
  while(i <= list.len) {
    #create individual data frame based on i'th sheet
    data <- as.data.frame(sheet.list[[i]], stringAsFactors = FALSE)
    #add column data on capital city, month, year
    #Relevant columns added, Direction of wind gust removed as well as time of maximum wind gust
    data <- mutate(data, Sheet.Name = list.names[i],
                  City = str_extract(Sheet.Name, "(Perth|Melbourne|Sydney|Brisbane|Adelaide)")
                  ,Date = parse_date_time(Date, guess_formats(Date, c("dmY", "%Y-%m-%d hms")))
                  ,Month = strftime(Date, "%b")                     
                  ) %>% select(City, Month, Date
                               ,Minimum.Temperature = Minimum.temperature...C.
                               ,Maximum.Temperature = Maximum.temperature...C.
                               ,Rainfall.mm = Rainfall..mm.
                               ,Evaporation.mm = Evaporation..mm.
                               ,Sunshine.Hours = Sunshine..hours.
                               #,Maximum.Wind.Speed.kmh = Speed.of.maximum.wind.gust..km.h.
                               #,Time.of.Maximum.Wind = Time.of.maximum.wind.gust
                               ,"9am.Temperature" = X9am.Temperature...C.
                               ,"9am.Relative.Humidity" = X9am.relative.humidity....
                               ,"9am.Cloud.Amount.oktas" = X9am.cloud.amount..oktas.
                               #,"9am.Wind.Speed.kmh" = X9am.wind.speed..km.h.
                               #,"9am.MSL.Pressure.hPA" = X9am.MSL.pressure..hPa.
                               ,"3pm.Temperature" = X3pm.Temperature...C.
                               ,"3pm.Relative.Humidity" = X3pm.relative.humidity....
                               ,"3pm.Cloud.Amount.oktas" = X3pm.cloud.amount..oktas.
                               #,"3pm.Wind.Speed.kmh" = X3pm.wind.speed..km.h.
                               #,"3pm.MSL.Pressure.hPa" = X3pm.MSL.pressure..hPa.
                               
                                )
    #some of the individual sheets had columns which were concatinated dates
    data$Col23 <- NULL
    #replace list element with cleaned dataframe with city
    sheet.list[[i]] <- data
    i <- i + 1
    
  }
  #return a binded dataframe of all list elements
  data <- rbindlist(sheet.list)
  #order data by date
  data <- data[order(data$Date),]
  return(data)
}


#Function to summarise data by month, insert cleaned raw data
monthlySummary <- function(data) {
        data$Date <- NULL
        #group data by city and month, and summarises every column by mean
        data.monthlysummary <- group_by(data, City, Month) %>%
                summarise_each(funs(mean(., na.rm = TRUE)))
                        
        return(data.monthlysummary)
}


#Function to summarise data by city
citySummary <- function(data) {
        
        # Remove Month column
        data$Month <- NULL
        data$Date <- NULL
        #group by city and summarise by city
        data.citysummary <- group_by(data, City) %>% 
                summarise_each(funs(mean(., na.rm = TRUE)))
        return(data.citysummary)
        
}

#Function to add metrics
data.addedmetrics <- function(data) {
        data <- mutate(data
                       ,Average.Temp = ((Maximum.Temperature+Minimum.Temperature)/2)
                       ,Average.Rel.Humidity = ((data$"9am.Relative.Humidity"+data$"3pm.Relative.Humidity")/2)
                       ,Average.Cloud.Amount = ((data$"9am.Cloud.Amount.oktas"+data$"3pm.Cloud.Amount.oktas")/2)
                       
        )
        return(data)
}

# Cleaned Weather Data ###
# Creates data as cleaned weather data
data <- createDataframe(importWorksheets(filename))
# Write data to csv
write.csv(data, "weather_clean.csv", row.names = FALSE)

# Monthly Summary #
data.monthlysummary <- monthlySummary(data)
write.csv(data.monthlysummary, "weatherMonthlysummary.csv", row.names = FALSE)

# City Summary #
data.citysummary <- citySummary(data)
write.csv(data.citysummary, "weatherCitysummary.csv", row.names = FALSE)

# City with added metrics
data.addedmetrics <- data.addedmetrics(data)
write.csv(data.addedmetrics, "dataAddedmetrics.csv", row.names = FALSE)
        

