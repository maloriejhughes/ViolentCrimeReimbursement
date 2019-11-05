
Loui_totals <- read_csv("/Users/MHughes/Documents/2018/02_Jaafari_Proj/DATA/RAW/Loui_totals.csv")
nj_totals <- read_csv("/Users/MHughes/Documents/2018/02_Jaafari_Proj/DATA/RAW/NJ_totals.csv")
penn_totals <- read_csv("/Users/MHughes/Documents/2018/02_Jaafari_Proj/DATA/RAW/Penn_totals.csv")

# For Pennsylvania, New Jersey and Louisiana:
# Out of total claims denied for 2010-2015, what percentage were because the claim had a hand in their own crime (HIC/Claims Denied — can leave out 2010/22 for NJ)




state_totals<- read_csv("/Users/MHughes/Documents/2018/02_Jaafari_Proj/DATA/RAW/STATE_TOTALS_2010-2015.csv")
#For New York (2011-2015):
#  Out of total murder claims, what percentage were denied b/c of a hand in their own crime?

state_totals%>% group_by(State) %>% summarize(Percent_of_Denials_bc_HIC=round(100*sum(`Denied b/c HIC`,na.rm=TRUE)/sum(`Claims Denied`,na.rm=TRUE),2)
                                              ,Percent_Murder_Claims_Denied_bc_HIC=round(100*sum(`Denied b/c HIC`,na.rm=TRUE)/sum(`Murder Claims`,na.rm=TRUE))
                                              )

```{r}

percent_minority<-read_csv("/Users/MHughes/Documents/2018/02_Jaafari_Proj/DATA/RAW/CensusRacialData2013.csv")

percent_minority<- percent_minority%>%  mutate(percent_nonwhite=Black+Latino)

percent_minority$minority_binned<-NA
percent_minority$minority_binned=ifelse(percent_minority$percent_nonwhite<=25,25,percent_minority$minority_binned)
percent_minority$minority_binned=ifelse(percent_minority$percent_nonwhite>25 & percent_minority$percent_nonwhite<=50 ,50,percent_minority$minority_binned)
percent_minority$minority_binned=ifelse(percent_minority$percent_nonwhite>50 & percent_minority$percent_nonwhite<=75 ,75,percent_minority$minority_binned)
percent_minority$minority_binned=ifelse(percent_minority$percent_nonwhite>75 & percent_minority$percent_nonwhite<=100 ,100,percent_minority$minority_binned)


counties_with_race<-merge(data.county,percent_minority,by.x=c("County","State"),by.y=c("County","State"))
state_denials_summary<-counties_with_race%>% filter(avg_processed_per_year>20)%>%filter(percent_denied>0)%>%group_by(State,minority_binned)%>%
 summarize(Average_Percent_Denied=round(mean(percent_denied)))
  
  

datatable(counties_with_race,  rownames = FALSE, extensions = c('Buttons','FixedColumns'),  options = list(pageLength = 100, fixedColumns = list(leftColumns = 1),
                                                                                                            dom = 'Bfrtip',columnDefs = list(list(searchable = FALSE, targets = 1))
                                                                                                            , 
                                                                                                            buttons = 
                                                                                                              list( list(
                                                                                                                extend = 'collection',
                                                                                                                buttons = list(list(extend='csv',
                                                                                                                                    filename = 'avgPercentDenied_by_PercentMinority'),
                                                                                                                               list(extend='excel',
                                                                                                                                    filename = paste0('avgPercentDenied_by_PercentMinority') ) ),text="Download"
                                                                                                                
                                                                                                                
                                                                                                              ))))



```

```{r}


top_three_minority_counties <- counties_with_race%>% group_by(State) %>% top_n(n = 3, wt = percent_nonwhite) %>% arrange(State,percent_nonwhite) %>% select(State,County, minority_binned,Black,Latino,percent_nonwhite, percent_denied)

lowest_three_minority_counties<- counties_with_race%>% group_by(State) %>% top_n(n = -3, wt = percent_nonwhite) %>% arrange(State,percent_nonwhite) %>% select(State,County, minority_binned,Black,Latino,percent_nonwhite, percent_denied)

high_low_minority<-rbind(top_three_minority_counties,lowest_three_minority_counties)
high_low_minority<-high_low_minority%>%arrange(State,percent_nonwhite) 

datatable(high_low_minority,  rownames = FALSE, extensions = c('Buttons','FixedColumns'),  options = list(pageLength = 100, fixedColumns = list(leftColumns = 1),
                                                                                                           dom = 'Bfrtip',columnDefs = list(list(searchable = FALSE, targets = 1))
                                                                                                           , 
                                                                                                           buttons = 
                                                                                                             list( list(
                                                                                                               extend = 'collection',
                                                                                                               buttons = list(list(extend='csv',
                                                                                                                                   filename = 'avgPercentDenied_by_PercentMinority'),
                                                                                                                              list(extend='excel',
                                                                                                                                   filename = paste0('avgPercentDenied_by_PercentMinority') ) ),text="Download"
                                                                                                               
                                                                                                               
                                                                                                             ))))



```

