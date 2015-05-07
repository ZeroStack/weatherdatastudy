
Which Australian capital city has the best weather?
========================================================

The following were initial tables and graphs to better understand the data. This is a rough draft; this document was made in quickly without thorough proofreading.

## Heatmap Summary

A heatmap displaying all relevant variables against the cities. The darker the colour for a particular city, the higher the value in relation to peer cities.

Values were calculated based on a yearly average of all the data.


![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png) 

\*Note: Adelaide has no data for 3am.Cloud and 9am.Cloud

For instance, Brisbane clearly has the darkest values for most variables. This means in relation to other cities, it had the highest values. Melbourne, on the other hand, had the lowest values for most variables.

\newpage

## Temperature

Temperature plotted with the Minimum against the Maximum.

Intercepts were added to isolate an ideal minimum temperature range of 20-25 Celcius and maximum temperature range of 25-35.

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 

56 rows containing missing values were removed when plotting this graph.

With this, Brisbane appears to be isolated in the desired region (box created by 4 intercepts). We can further explore this in a density plot to confirm \(following page).



\newpage


The density plot is a great way to observe the concentration of data points across a variable.

The average temperature was obtained by calculating the average of Maximum and Minium temperature. This provided a more comprising metric to summarise the data.

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

Brisbane had the highest minimum and maxiumum temperature. All cities share a similar pattern of temperature density.

\newpage

In order to obersve how irratic the temperature was throughout the year. A difference was determined by subtracting the temperature in the morning (9am) from temperature in the afternoon (3pm).

This difference shows how much the temperature reduced as the day progressed by 6 hours.

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

57 Rows contain missing values were removed.

Once more, Brisbane appears to show the most desirable temperature, as it has the least change throughout the day (going lower).

\newpage

## Rainfall & Evaporation

From the bar graph below sums the rainfall for every city throughout the year. It can be observed that Brisbane had the highest amount of rainfall during the year, where as Melbourne had the least.

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

142 rows containing missing values were removed when plotting this graph.

\newpage


Results from evaporation showed that Brisbane had the highest, and Adelaide had the least.

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png) 

142 rows containing missing values were removed when plotting this graph.


\newpage

The graph below was an attempt to summarise rain and evaporation by subtracting evaporation from rain. 

It was suprising to find that generally the level of evaporation was higher than rainfall as this yielded some negative results. 

It was beyond my circle of competence to use this specific metric as an indicator.

Colours indiciate a different month.


![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png) 

51 rows contained missing values were removed when plotting this graph.


\newpage

## Sunshine Hours

The graph below shows the density of sunshine hours throughout the year.

It can be observed that Perth has the highest density of the most sunshine hours.

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png) 

\newpage

## Relative Humidity

The humidity indiciator was calculated by getting the average of relative humidity at 9am and 3pm.


![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 

54 Rows were removed when plotting this graphs.

\newpage

## Cloud Amount

The cloud amount metric was calculated by getting the average of oktas at 9am and 3pm.

Adelaide had no data, and Perth had the lowest cloud amount.

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-1.png) 


