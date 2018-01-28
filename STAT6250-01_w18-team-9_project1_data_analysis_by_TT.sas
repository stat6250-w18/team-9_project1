*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding Employment, Unemployment, and Median Household Income 

STAT6250-01_w18-team-9_project1_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset unemployment_analytic_file;
%include '.\STAT6250-01_w18-team-9_project1_data_preparation.sas';


title1
'Research Question 1: What is the mean value for the US unemployment rates by 
counties in 2015?'
;

title2
'Rationale: This would help provide insights on the US unemployment rates per 
counties in 2015'
;

footnote1
'Based on the above output, the mean which is the average of all unemployment 
rates in the US in 2015 is 5.47%. In other words, there are 5.47% of civilian 
labor force are not being employed during this period.'
;

footnote2
'The lowest minimum rate is 1.70% and the highest rate is 23.50% so we can 
conclude there is a very huge difference in term of unemployment
rates among counties in 2015. By that, we also see that the unemployment is 
not equally distributed among the districts.'
;

footnote3
'The unemployment statistics can be seen as an indicator for the following 
data analysis steps which might help provide insights of the unemployment rates
by states'
;

*
Methodology: Use PROC MEANS to get the descpriptive stats of all the 
observations from the temporary dataset created in the corresponding data-prep 
file.

Limitations: This methodology does not account for any counties/districts with 
missing data.

Possible Follow-up Steps: Carefully review the variables for employment rate, 
unemployment rate, and median household income, clean up the missing data and
maybe use an average rate as a proxy for increasing the accuracy.
;


proc means
        min q1 mean q3 max
        data=unemployment_analytic_file
    ;
    var
        Unemployment_rate_2016
    ;
    output
        out=unemployment_analytic_file_temp
    ;
run;
title;
footnote;


title1
'Research Question 2: What are the top twenty counties with the highest mean 
values of "Median_Household_2015_Income"?'
;

title2
'Rationale: This would help identify the top 20 richest counties in the US.'
;

footnote1
'Based on the above output, we are able to identify the top 20 richest county
in the country in case job seekers are looking for a new place for job 
relocation while still maintaining their household income.'
;

footnote2
'Based on the above output, we are also able to identify most richest counties 
in term of median house income in 2015 are mostly located in East Coast.'
;

footnote3
'Further analysis to look for geographic patterns is clearly indicated, given 
such high mean household income in West Coast are only located in Bay Area, 
California.'
;
*
Methodology: Use PROC PRINT to print just the first twenty observations from
the temporary dataset created in the corresponding dataset file.

Limitations: This methodology does not account for counties with missing data,

Possible Follow-up Steps: More carefully clean the values of the variable
Percent_Eligible_FRPM_K12 so that the means computed do not include any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;
* 
Use PROC MEANS to compute the mean of Percent_Eligible_FRPM_K12 for
District_Name, and output the results to a temporary dataset, and use PROC SORT
to extract and sort just the means the temporary dateset, which will be used as
part of data analysis by IL.
;

proc means
        mean
        noprint
        data=Unemployment_analytic_file
    ;
    class
        Area_name
    ;
    var
        Median_Household_2015_Income
    ;
    output
        out=Unemployment_analytic_file_temp
    ;
run;

proc sort
        data=Unemployment_analytic_file_temp(where=(_STAT_="MEAN"))
    ;
    by
        descending Median_Household_2015_Income
    ;
run;
proc print
        noobs
        data=Unemployment_analytic_file_temp(obs=20)
    ;
    id
        Area_Name
    ;
    var
        Median_Household_2015_Income
    ;
run;
title;
footnote;


title1
'Research Question 3: Is it possible to use "Unmployment Rate" to predict 
"Median household income"?'
;

title2
'Rationale: This would help determine whether counties have high 
unemployment rates need further assistance from federal government .'
;

footnote1
'Based on the above output, there is no clear inferential pattern to predict
the unemployment rate from the median household income.'
;
*
Methodology: Use Proc format to create formats to bin values of 
Median_Household_2015_Income and Employment_2015 based upon their spread, and 
use proc freq to cross-tabulate bins.
Limitations: Even though predictive modeling is specified in the research 
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.
Follow-up Steps: A possible follow-up to this approach could use an inferential
statistical technique like beta regression, or use linear regression models to 
find the relationship.
;

proc means
        min q1 mean q3 max
        data=unemployment_analytic_file
    ;
    var
        Median_Household_2015_Income 
		Unemployment_2015_rate
    ;
    output
        out=unemployment_analytic_file_temp
    ;
run;
proc format;
    value Median_Household_2015_Income_bins
        low-40572="Q1 Income"
        40572-48724.97="Q2 Income"
        48724.97-54337="Q3 Income"
        54337-high="Q4 Income"
    ;
    value Unemployment_2015_rate_bins
        low-<4.2="Q1 UR "
        4.2-<5.74="Q2 UR "
        5.74-<6.6="Q3 UR"
        6.6-high="Q4 UR"
    ;
run;
proc freq
    data=unemployment_analytic_file
    ;
    table
        Median_Household_2015_Income*Unemployment_2015_rate
        / missing norow nocol nopercent
    ;
	format
         Median_Household_2015_Income Median_Household_2015_Income_bins.
         Unemployment_2015_rate Unemployment_2015_rate_bins.
    ;
run;
title;
footnote;
