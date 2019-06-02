library(dplyr)
library(ggplot2)

stage2test <- read.csv("data/stage2.02.2017.csv", stringsAsFactors = F)

grouped <- stage2test %>%
  select(gun_type, n_killed, n_injured) %>%
  group_by(gun_type) %>%
  summarise(n_killed = mean(n_killed), n_injured = mean(n_injured))