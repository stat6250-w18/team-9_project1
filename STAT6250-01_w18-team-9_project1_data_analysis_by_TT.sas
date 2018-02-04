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
'Research Question 1: What is the mean value for the US unemployment rates by counties in 2015?'
;

title2
'Rationale: This would help provide insights on the US unemployment rates per counties in 2015'
;

footnote1
'Based on the above output, the mean which is the average of all unemployment rates in the US in 2015 is 5.47%. In other words, there are 5.47% of civilian labor force are not being employed during this period.'
;

footnote2
'The lowest minimum rate is 1.70% and the highest rate is 23.50% so we can conclude there is a very huge difference in term of unemploymentrates among counties in 2015. By that, we also see that the unemployment is not equally distributed among the districts.'
;

footnote3
'The unemployment statistics can be seen as an indicator for the following data analysis steps which might help provide insights of the unemployment ratesby states'
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
'Research Question 2: What are the top twenty counties with the highest mean values of "Median_Household_2015_Income"?'
;

title2
'Rationale: This would help identify the top 20 richest counties in the US.'
;

footnote1
'Based on the above output, we are able to identify the top 20 richest county in the country in case job seekers are looking for a new place for job relocation while still maintaining their household income.'
;

footnote2
'Based on the above output, we are also able to identify most richest counties in term of median house income in 2015 are mostly located in East Coast.'
;

footnote3
'Further analysis to look for geographic patterns is clearly indicated, given such high mean household income in West Coast are only located in Bay Area, California.'
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
'Research Question 3: What is the distribution of all counties that have unemployment rate in 2016 less than 5.46% and the median househould income greater than $100,000?'
;

title2
'Rationale: This would help job seekers look for any counties that have lower unemployement rates in 2016 and median household income higher than $100,000'
;

footnote1
'Based on the above output, there are only 12 counties in 2016 met conditions where the unemployement rate is less than the national unemployment rate mean and the medidan household income is higher than $100,000'
;
*
Methodology: Use proc freq to create one-way frequency

Limitations: This methodology does not account for any counties/districts with 
missing data.

Possible Follow-up: Carefully review the variables for employment rate, 
unemployment rate, and median household income, clean up the missing data and
maybe use an average rate as a proxy for increasing the accuracy. 
;

proc freq 
	data=unemployment_analytic_file
	;
	tables 
		Unemployment_rate_2016
	;
	where Unemployment_rate_2016<5.46
		and Rural_urban_continuum_code_2013=1
		and Median_Household_2015_Income>100000	
	;
run;
title;
footnote;
