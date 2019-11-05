# Violent Crime Reimbursement

Data supporting investigative journalist Joeseph Jaafari's piece on bias in violent crime reimbursement.

Publication here: https://nationswell.com/every-murder-is-real-victims-compensation-philadelphia/amp/

Analysis here: https://maloriejhughes.github.io/ViolentCrimeReimbursement/

## Definitions
#### Average Processed per year:
This value is the number of claims processed per county averaged over the three years from 2013-2015.

#### Total Processes all years:
This value is the number of claims processed per county summed over the three years, 2013-2015.


#### Percent denied/Percent of Claims Denied:
To calculate the average percent of claims denied, counties named the following were removed from the analysis: "OTHER" , "No County", "Out Of State".  The data was grouped by County and State, and percent of claims denied for 2013-2015 was calculated as the sum of annual claims denied divided by the sum of annual claims processed.   This give one value for the entire time period, rather than an average of the three years.  This choice was made due to the rolling nature of processed claims and to avoid giving each of the three years significant leverage over the final value.  For a given county, if the number of claims processed varied notably across the three years, an average would not capture that.  For these reasons, the decision was made to aggregate over the three year period rather than average them.


#### Total Denied:
This value is the number of claims denied per county summed over the three years, 2013-2015.

#### Average number Paid:
This value is the number of claims paid per county averaged over the three years from 2013-2015.

#### Total Number Paid:
This value is the number of claims paid per county summed over the three years, 2013-2015.

#### Percent Unpaid: 
This value is the number of claims processed minus the number of claims paid, divided by the number of claims processed over the three year period.

#### Percent nonwhite:
The Percent nonwhite was calculated as 100 minus the percent of white residents according to the 2013 census.

## Findings
#### Relationship between Minority population and Claims denied:
To understand this relationship, a county-level regression model was built that included multiple explanatory variables.  The counties were treated as single observations, with the three years of observations aggregated for each county.  Counties with fewer than 20 average claims per year were excluded, because counties with so few claims are likely to review claims occurring so rarely differently than do counties facing higher volumes of claims to process each year.   The model focused on the explanatory variable “percent nonwhite” and included “state” and “total claims processed” as controls.  In order to achieve linearity in the model, the depended variable was transformed as the logarithm of total denials.  This allowed for an interpretation of “percentage change” between the percent of nonwhite residents and the total denials.  The model resulted in the following:

#### Model
Call:
lm(formula = log(total_denied) ~ percent_nonwhite + factor(State) + 
log(total_processed_all_years), data = counties_with_race)

Residuals:
Min       1Q   Median       3Q      Max 
-0.79475 -0.15894  0.02306  0.14006  0.68173 

Coefficients:
Estimate Std. Error t value Pr(>|t|)    
(Intercept)                    -2.699431   0.147517 -18.299  < 2e-16 ***
percent_nonwhite                0.003899   0.001280   3.045  0.00289 ** 
factor(State)Louisiana          0.334160   0.126859   2.634  0.00961 ** 
factor(State)Texas              0.721242   0.089263   8.080 7.53e-13 ***
log(total_processed_all_years)  1.039189   0.021546  48.231  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2659 on 114 degrees of freedom
Multiple R-squared:  0.9633,    Adjusted R-squared:  0.962 
F-statistic: 748.4 on 4 and 114 DF,  p-value: < 2.2e-16



#### Interpretation
The coefficient on percent_nonwhite is interpreted as: for a unit increase in the percent of nonwhite residents, the percent of denials increases by 100*(e^(0.003899)-1)=.39%.  So, holding state and total claims processed constant, for every 10% increase in the percent of nonwhite residents, percent of denials increases by about 4%. 


 








