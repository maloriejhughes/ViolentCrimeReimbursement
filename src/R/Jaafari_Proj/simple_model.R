plot(counties_with_race$percent_nonwhite,counties_with_race$percent_denied)
library(tidyverse)
counties_with_race2<- counties_with_race %>%filter(avg_processed_per_year>20)
mod<-lm(percent_denied~percent_nonwhite +factor(State) +  log(avg_processed_per_year),data=counties_with_race)
summary(mod)
#counties_with_race$num_nonwhite<-counties_with_race$
mod2<-lm(log(total_denied)~percent_nonwhite +factor(State) +  log(total_processed_all_years),data=counties_with_race)
summary(mod2)

plot(counties_with_race2$percent_nonwhite,counties_with_race2$percent_denied)
100*0.003899*10
