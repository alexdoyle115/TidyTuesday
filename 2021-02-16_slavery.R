## Tidy tuesday ####
## Week 8
## Alex Doyle
## 2021-02-16

# Loading of required packages 
library(tidytuesdayR)
library(tidyverse)
library(ggplot2)
library(gganimate)

# data from TidyTuesday github page
tuesdata <- tidytuesdayR::tt_load('2021-02-16')


census <- tuesdata$census
head(census)

census$region <- as.factor(census$region)
levels(census$region)

# Splitting up data set to create new factor
census_regions <- census[-c(1:39), ]
census_regions <- census_regions[-c(53:68), ]
black_free <- census_regions <- select(census_regions, c(2, 3, 7))

census_regions <- census[-c(1:39), ]
census_regions <- census_regions[-c(53:68), ]
black_slaves <- census_regions <- select(census_regions, c(2, 3, 8))

black_free <- cbind(state = "free", black_free)
black_slaves <- cbind(state = "enslaved", black_slaves)

black_free <- black_free %>%
  rename(population = black_free)

black_slaves <- black_slaves %>%
  rename(population = black_slaves)

population <- rbind(black_free, black_slaves)
population$population <- population$population/1000000

# Using combined data to create a ggplot 
p <- ggplot(population, aes(fill = state, x = division, y = population)) + 
  geom_bar(position = "stack", stat = "identity") +
  labs(x = "Region of America", 
       y = "Number of people (millions)", 
       title = "Regional population (1790 - 1880)", 
       fill = "Slavery Status",
       caption = "Tidy Tuesday Week 8 | Alex Doyle | #DuBoisChallenge") +
  scale_fill_manual(values=c("#000000", "#9900CC")) +
  theme(axis.text.x = element_text(angle = 20))

# Annimating said plot
p + transition_time(year) +
  labs(title = "Black population of US regions (1790 - 1870)", 
       subtitle = "Year: {as.integer(frame_time)}" )

# Saving plot
anim_save("slavery_abolishment.gif")
