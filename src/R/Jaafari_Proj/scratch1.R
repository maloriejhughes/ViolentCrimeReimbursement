library(readr)
library(tidyverse)
library(stargazer)
library(highcharter)
RAW_PATH<-"~/Documents/2018/02_Jaafari_Proj/DATA/RAW/"
data<-read_csv(paste0(RAW_PATH,"VCAP_STATE_TOTALS_MASTER.csv"))

data<-data %>% filter(!is.na(County)) %>%
  mutate(Avg_Paid=replace(Avg_Paid, Avg_Paid=='#DIV/0!', 0)) %>% 
  as.data.frame() 

# remove characters from $$ columns and convert to numeric
data$Avg_Paid<-gsub('$','',data$Avg_Paid,fixed=TRUE)
data$Avg_Paid<-gsub(',','',data$Avg_Paid)
data$Avg_Paid<-as.numeric(as.character(data$Avg_Paid)) # as.character first to be safe.

data$Total_Paid<-gsub('$','',data$Total_Paid,fixed=TRUE)
data$Total_Paid<-gsub(',','',data$Total_Paid)
data$Total_Paid<-as.numeric(as.character(data$Total_Paid)) # as.character first to be safe.

data.clean<-data%>% filter(!is.na(County)) %>%mutate(County=replace(County,County=="Out of state","Out Of State"))%>%
  mutate(County=replace(County,County=="No county","No County"))%>%
  filter(!County %in% c("TOTAL"
                        ,"Does not include claims being processed"
                        , "OTHER"
                        , "No County"
                        ,"Out Of State"
  ) ) %>% data.frame()




  
  
data.county<-data.clean %>% group_by(State,County) %>%summarize(county_state=paste0(unique(County),", ",unique(State))
                                                                                      ,avg_processed_per_year=round(mean(Processed,na.rm=TRUE),2)
                                                                , total_processed_all_years=sum(Processed,na.rm=TRUE)
                                                                ,percent_denied=round(100*sum(Denied,na.rm=TRUE)/(sum(Denied,na.rm=TRUE)+sum(Processed,na.rm=TRUE)))
                                                                ,total_denied=sum(Denied,na.rm=TRUE)
                                                                                      , avg_num_paid=round(mean(Num_Paid,na.rm=TRUE),2)
                                                                                      
                                                                                      ,total_num_paid=sum(Num_Paid,na.rm=TRUE)
                                                                
                                                                                      ,percent_unpaid=round(100*(sum(Processed,na.rm=TRUE)-sum(Num_Paid,na.rm=TRUE))/sum(Processed,na.rm=TRUE))
) %>% filter(avg_processed_per_year>20)

data.county<-data.county %>% data.frame()%>% arrange(desc(percent_denied)) %>% mutate(county_state=factor(county_state,levels=county_state))
#%>% filter(between(row_number(), 1, 15))


datatable(ama.use,  rownames = FALSE, extensions = c('Buttons','FixedColumns'),  options = list(pageLength = 100, fixedColumns = list(leftColumns = 1),
                                                                                                dom = 'Bfrtip',columnDefs = list(list(searchable = FALSE, targets = 1))
                                                                                                , 
                                                                                                buttons = 
                                                                                                  list( list(
                                                                                                    extend = 'collection',
                                                                                                    buttons = list(list(extend='csv',
                                                                                                                        filename = paste0('unrestricted_CrossPromo_',trimws(SHOW_NAME) )),
                                                                                                                   list(extend='excel',
                                                                                                                        filename = paste0('unrestricted_CrossPromo_',trimws(SHOW_NAME) ) ) ),text="Download"
                                                                                                    
                                                                                                    
                                                                                                  ))))


