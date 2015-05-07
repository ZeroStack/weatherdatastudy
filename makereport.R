#Set to relevant working directoy where files are located
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

# Load relevant libraries
library("knitr")
library("markdown")
library("rmarkdown")
library("ggplot2")
library("ggthemes")
library("scales")
library("reshape2")
library("plyr")
library("lubridate")
library("dplyr")


#Read clean weather data into R
# All data
data <- read.csv("weather_clean.csv")

# Data by Month
data.monthlysummary <- read.csv("weatherMonthlysummary.csv")

# Data by City
data.citysummary <- read.csv("weatherCitysummary.csv")

# Function to create basic heatmap
createHeatmap <- function(data.citysummary) {
        city <- data.citysummary

        #names(city) <- c("City", "Min.Temp", "Max.Temp", "Rain", "Evap", "Sun.hours", "9am.Temp", "9am.Hum",
        #                  "9am.Cloud", "3pm.Temp", "3pm.Hum", "3pm.Cloud")

        city <- melt(city)
        city <- ddply(city, .(variable), transform, rescale = rescale(value))
        
        
        p <- ggplot(city, aes(variable, City)) + geom_tile(aes(fill = rescale),
                                                            colour = "white") + scale_fill_gradient(low = "white",
                                                                                                   high = "steelblue")
        base_size <- 8
        x <- p + theme_grey(base_size = base_size) +
          labs(x = "", y = "") +
          scale_x_discrete(expand = c(0, 0)) +
          scale_y_discrete(expand = c(0, 0)) +
          theme(
               axis.ticks = element_blank(), 
               axis.text.x = element_text(size = base_size *1.5, angle = 330, hjust = 0, colour = "grey50"),
               axis.text.y = element_text(size = base_size * 1.5)
               )
        
        return(x)

}

createTempgraph1 <- function(data) {
  
  p <- ggplot(data, aes(x = Minimum.Temperature
                        ,y = Maximum.Temperature
                        ,color = City
                        ) 
              ) +
    geom_point() +
    geom_hline(yintercept = c(25,35), linetype="dotted") +
    geom_vline(xintercept=c(20,25), linetype="dotted") +
    ggtitle("Max vs Min Temperature, 2014-2015") +
    ylab("Maximum Temperature (Celsius)") +
    xlab("Minimum Temperature (Celsius)")
  return(p)
}

createTempgraph2 <- function(data) {
  p <- ggplot(data, aes(x = ((Maximum.Temperature+Minimum.Temperature)/2)
                        ,fill = City
                        #,y = Maximum.Temperature
                        #,color = City
                        )) +
    geom_histogram() +
    #facet_grid(City ~ .)
    #facet_wrap(~City) +
    ggtitle("Density of Average Temperature, 2014-2015") +
    ylab("") +
    xlab("Average Temperature (Celsius)")
}

createTempgraph3 <- function(data) {
  data$Date <- parse_date_time(data$Date, "%Y-%m-%d")
  
  base_size <- 8
  
  p <- ggplot(data, aes(x = Date
                        ,y = X9am.Temperature
                        #,color = City
  ) 
  ) +
  geom_point(alpha = (1/3), size = 3, aes(y = (X9am.Temperature-X3pm.Temperature), group=City, color = 'red')) +

  scale_x_datetime(breaks=date_breaks('4 month'),
                   labels = date_format('%y-%m-%d')) +
    theme(legend.position="none",
      axis.ticks = element_blank(), 
      axis.text.x = element_text(size = base_size *1.5, angle = 330, hjust = 0, colour = "grey50"),
      axis.text.y = element_text(size = base_size * 1.5)
    ) + facet_grid(~ City) + ylab("") +
    ggtitle("Change in Temperature from 9am-3pm (Celsius), 2014-2015")
}

createRaingraph <- function(data) {

  ggplot(data, aes(x = City, y = Rainfall.mm, fill = City)) + 
    stat_summary(fun.y = sum, geom = "bar") +
  ggtitle("Cumalative Rainfall (mm), 2014-2015") +
    ylab("") +
    theme(legend.position="none")

    
}

createEvaporationgraph <- function(data) {
  
  ggplot(data, aes(x = City, y = Evaporation.mm, fill = City)) + 
    stat_summary(fun.y = sum, geom = "bar") +
    ggtitle("Cumalative Evaporation (mm), 2014-2015") +
    ylab("") +
    theme(legend.position="none")
  
  
}

createRainEvapgraph <- function(data) {
  data$Date <- parse_date_time(data$Date, "%Y-%m-%d")
  
  base_size <- 8
  
  p <- ggplot(data, aes(x = Date
                        
                        #,color = City
  ) 
  ) +
    geom_line(alpha = (1/3), size = 1, aes(y = (Rainfall.mm-Evaporation.mm), group=City, color = Month)) +
    
    scale_x_datetime(breaks=date_breaks('4 month'),
                     labels = date_format('%y-%m-%d')) +
    theme(legend.position="none",
          #axis.ticks = element_blank(), 
          axis.text.x = element_text(size = base_size *1.5, angle = 330, hjust = 0, colour = "grey50"),
          axis.text.y = element_text(size = base_size * 1.5)
    ) + facet_grid(~ City) + ylab("") +
    ggtitle("Rain After Evaporation (mm), 2014-2015")
}

createSungraph <- function(data) {
        p <- ggplot(data, aes(x = (Sunshine.Hours)
                              ,fill = City
                              #,y = Maximum.Temperature
                              #,color = City
        )) +
                geom_histogram() +
                #facet_grid(City ~ .)
                #facet_wrap(~City) +
                ggtitle("Density of Sunshine (hours), 2014-2015") +
                ylab("") +
                xlab("Sunshine hours ")
}

createHumiditygraph <- function(data) {
        data$Date <- parse_date_time(data$Date, "%Y-%m-%d")
        
        base_size <- 8
        
        p <- ggplot(data, aes(x = Date
                              
                              #,color = City
        ) 
        ) +
                geom_line(size = 1, aes(y = ((X9am.Relative.Humidity+X3pm.Relative.Humidity)/2), group=City, color = City)) +
                
                scale_x_datetime(breaks=date_breaks('4 month'),
                                 labels = date_format('%y-%m-%d')) +
                theme(#legend.position="none",
                      #axis.ticks = element_blank(), 
                      axis.text.x = element_text(size = base_size *1.5, angle = 330, hjust = 0, colour = "grey50"),
                      axis.text.y = element_text(size = base_size * 1.5)
                ) + 
                facet_grid(~ City) +
                ggtitle("Humidity, 2014-2015") +
                ylab("Relative Humidity Average")
}

createCloudgraph <- function(data) {
        
        p <- ggplot(data, aes(x = ((X9am.Cloud.Amount.oktas+X3pm.Cloud.Amount.oktas)/2)
                              ,fill = City
                              #,y = Maximum.Temperature
                              #,color = City
        )) +
                geom_histogram() +
                #facet_grid(City ~ .)
                #facet_wrap(~City) +
                ggtitle("Cloud Amount (oktas), 2014-2015") +
                ylab("") +
                xlab("Cloud Amount")
}

heatmap.plot <- createHeatmap(data.citysummary)


temp.plot <- createTempgraph1(data)
temp.plot2 <- createTempgraph2(data)
temp.plot3 <- createTempgraph3(data)


rain.plot <- createRaingraph(data)
evaporation.plot <- createEvaporationgraph(data)



rain.evap.plot <- createRainEvapgraph(data)

sunshine.plot <- createSungraph(data)

humidity.plot <- createHumiditygraph(data)

cloud.plot <- createCloudgraph(data)

ggsave(filename="heatmap.jpg", plot=heatmap.plot) 
#, axis.text.x = theme_text(size = base_size *0.8, angle = 330, hjust = 0, colour = "grey50"))

#Create a pdf document with plots
render("report.Rmd", "pdf_document")
knit("report.Rmd")
markdownToHTML("report.md", "report.html", options = c("use_xhml"))

     
