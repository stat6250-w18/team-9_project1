*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding free/reduced-price meals at CA public K-12 schools

Dataset Name: FRPM1516_analytic_file created in external file
STAT6250-02_s17-team-0_project1_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";



* load external file that generates analytic dataset FRPM1516_analytic_file;
%include '.\STAT6250-01_w18-team-9_project1_data_preparation';


title1
'Research Question1: What is the mean value for unempolyment and median household income in the US in 2015?'
;

title2
'Rationale: This should help provide basic information on unemployment and household income status.'
;

footnote1
'Based on the above output, the average value for unemployment in the U.S. in 2015 is 5.74, meaning 5.74% of the total labor force is not being employed.'
;

footnote2
'Moreover, we can see that the average median household income in the U.S. in 2015 is 48724.97 dollars.'
;

footnote3
'The income and emplpoyment statistics will be an indicator for the following data analysis steps, it is meaningful to look at into states statistics.'
;

*
Methodology: Use PROC MEANS to get the descpriptive statistics of all the 
observations from the temporary dataset created in the corresponding data-prep 
file, including Q1, Q3, Mean, Min and Max.

Limitations: This methodology does not account for districts with missing data,
such as Purto Rico area, and there is a huge gap between areas in the US, 
so the average lack of some credibility as an indicator.

Possible Follow-up Steps: Carefully review the variables for house median 
income and unemployment rate, clean up the missing data and maybe use an 
average rate as a proxy for increasing the accuracy.
;

proc means
        min q1 mean q3 max
        data=unemployment_analytic_file
    ;
    var
        Median_Household_2015_Income Unemployment_2015_rate
    ;
    output
        out=unemployment_analytic_file_temp
    ;
run;

title;
footnote;


title1
'Research Question2: What are the top 10 states with the highest mean values of unemployment rate in 2015?'
;

title2
'Rationale: This should show the states in the most need of improving emloyment status.'
;

footnote1
'Based on the above output, PR has the highest unemployment rate of 14.17%, which is almost 2.5 times of national average rate.'
;

footnote2
'When we compare the state median household income with the top ten highestunemployment rate states, we found all the states, execpt for PR and AK, are all below the national average household income amount.'
;

footnote3
'Surprisingly, AK is the only state with both high unemployment rate(1.63 times national average) and high median household income(1.25 times of national average).'
;

*
Methodology: Use PROC PRINT to print just the first 10 observations from
the temporary dataset created in the corresponding data-prep file.

Limitations: The missing data is not well treated, such as counties in AK.
Those will underestimate/overestimate the average statewide rate.

Follow-up Steps: A possible follow-up to this approach could use the 
national average rate as a proxy to replace the missing data.
;

proc print
        noobs
        data=unemployment_analytic_file_temp(obs=10)
    ;
    id
        State
    ;
    var
        Unemployment_2015_rate Median_Household_2015_Income
    ;
run;
title;
footnote;

title1
'Research Question3: Can "Unemployment Rate" be used to predict "Median household income"?'
;

title2
'Rationale: This would help determine whether outreach based upon high unemployment rate should be provided to increase household income. E.g., if unemployment is highly correlated with median household income, then areas with lower unemployment rate tend to have higher median household income.'
;

footnote1
"Based on the above output, there's no clear inferential pattern for predictingthe unemployment rate from the median household income since cell counts don't tend to follow trends for increasing or decreasing consistently."
;

footnote2
'However, this is an incredibly course analysis since only quartiles are used, so a follow-up analysis using a more sensitive instrument (like beta regression) might find useful correlations.'
;
*
Methodology: Use Proc means to get q1, q3, mean stats of each variable, create 
formats to bin values of Median_Household_2015_Income and Unemployment_2015_rate
based upon their spread, and use proc freq to cross-tabulate bins.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.

Follow-up Steps: A possible follow-up to this approach could use an inferential
statistical technique like beta regression, or use linear regression models 
to find the relationship.
;

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
