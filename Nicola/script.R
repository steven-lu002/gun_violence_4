library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)

data <- read.csv('./complete.stage2.2017.csv', stringsAsFactors = F)
filtered <- data %>%
  select(
    state,
    city_or_county,
    latitude,
    longitude,
    participant_age_group,
    participant_status,
    participant_type
  )
long_data <- filtered %>%
  gather(
    key = 'key',
    value = 'value',
    participant_age_group,
    participant_status,
    participant_type
  )
filtered <- filtered %>%
              mutate('Adult' = str_detect(participant_age_group, coll('Adult'))) %>%
              mutate('Teen' = str_detect(participant_age_group, coll('Teen'))) %>%
              mutate('Child' = str_detect(participant_age_group, coll('Child')))
adult_data <- filtered %>%
                filter(Adult == TRUE)
teen_data <- filtered %>%
                filter(Teen == TRUE)
child_data <- filtered %>%
                filter(Child == TRUE)
#adult_data <- adult_data %>%
#                group_by(state) %>%
#                summarise(n())
#teen_data <- teen_data %>%
#  group_by(state) %>%
#  summarise(n())
#child_data <- child_data %>%
#  group_by(state) %>%
#  summarise(n())
            
