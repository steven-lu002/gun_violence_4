# Project Proposal

## Sunny Lee, Nicola Beirer, Steven Lu, Haokun Cai

## 14 May 2019
### Link to ShinyApp! :-)
[Link to ShinyApp](https://stevenlu002.shinyapps.io/Frontpage/)
### Project Description
#### Dataset
The dataset that we are going to use is from a github repo containing csv files on gun violence. This data is collected from [gun violence archives](https://www.gunviolencearchive.org/) and can be accessed from the csv files located on the [repo](https://github.com/jamesqo/gun-violence-data). This data was collected through the use of python scripts in order to sort and clean the data. The filters include things such as incident, location, date, gun type, etc.
#### Target Audience
Our target audiences are State legislatures looking at gun control laws and parents looking at gun statistics based on age, and anyone concerned with their safety regarding gun violence cases. This is due to the impact that this analysis could have. The correlation between gun types and violence results could assist in determining the potential gun control laws and the impacted age group could be informative for parents looking for gun statistics.
#### Major Questions
- How many guns used in violence are stolen versus legally bought?
- How does the type of gun affect the number of killed/ injured within a given incident.
- What is the most impacted age group (victims/ participants) in different regions?

### Technical Description
#### Reading the Data
The dataset we are sourcing from is located on github in the form of csv files. The set located on the github spans from 2014 to 2018. Due to the large set of data, the csv file is split into two different stages. Each of these stages include information that we need, thus we will read both of the csv files which will be wrangled later.
#### Data Wrangling
The dataset located on the repo is separated into two different stages; therefore, our dataset will combine the two stages to form a complete set. However, due to the amount of irrelevant information (in the scope of our project) we will also filter out the data to include only the relevant information. For example, our project has a focus on the type of gun, thus we will keep this information while participant status is less important. The changes to the data will be fairly minimal other than the changes mentioned above. However we do foresee changes to the dataset through the introduction of new categories formed for the current filters such as average number of guns stolen from a region.
#### Relevant Libraries
Other than the common libraries that will used to wrangle data such as dplyr and common graphics tools such as ggplot2, we will be using shiny to create interactive visualizations of the data.
#### What questions, if any, will you be answer with statistical analysis/ machine learning
Our analysis will mostly be through statistical analysis between the correlation within the data. Our conclusions will attempt to determine if there is correlation present and whether or not that result is due to causation. The correlation that we are attempting to examine will be the connection between weapon type and the number of victims as well as violence with legally bought guns versus stolen/ black-market weapons.
#### Major Challenges
- Due to the large nature of our data, the time it might take to sort and filter the data will be time consuming. The graphics and data wrangling may take a significant amount of time due to the varying processing powers within our computers.
- The data itself may have some incomplete entries which will be difficult to navigate, we will have to decide whether to omit the data or to mutate it in a way to filter the various missing entries.
- Time commitments and scheduling conflicts that each person has may restrict the amount of time we have to work together.
