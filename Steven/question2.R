# How does the type of gun affect the number of killed/ injured within a given incident.
# this file is to do the datawrangling required for the shiny and graphs
library(dplyr)
library(ggplot2)
library(stringr)

stage2 <- read.csv("complete.stage2.2017.csv", stringsAsFactors = F)

# filters everything out except for the needed information
group <- stage2 %>%
  select(gun_type, n_killed, n_injured) %>%
  group_by(gun_type) %>%
  summarise(n_killed = mean(n_killed), n_injured = mean(n_injured)) %>%
  drop_na(n_injured) %>%
  filter(n_injured != 0 | n_killed != 0) %>%
  filter(str_detect(gun_type, "1::") == FALSE)

group$gun_type <- str_replace_all(group$gun_type, fixed("0::"), "")
# group$gun_type <- str_replace_all(group$gun_type, fixed("["), "")
#group$gun_type <- str_replace_all(group$gun_type, fixed("]"), "")
names(group) = c("gun_type", "Killed", "Injured")

#writes to a new csv that is used in the shiny app
write.csv(group, "question2.csv", row.names = FALSE)

# ss <- ggplot(group, aes(gun_type, group$Killed)) + geom_bar(stat = "identity")
# print(ss) (test case)
# some how find out the number of cases?