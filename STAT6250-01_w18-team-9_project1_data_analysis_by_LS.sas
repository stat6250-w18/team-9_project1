*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding Employment, Unemployment rate(2007-2016) and Median homehold Income(2015)
Dataset Name: Unemployment_analytic_file created in external file
STAT6250-01_s18-team-9_project1_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset FRPM1516_analytic_file;
%include '.\STAT6250-01_w18-team-9_project1_data_preparation.sas';


title1
'Research Question: What is the basic information about the civilian_labor_force_2016 and the unemployment_rate_2016?'
;

title2
'Rationale: This should help providing the basic number about these two column, which can compare with the specific area or state.'
;

footnote1
'Based on the above output, the minimum of civilian labor force in 2016 is 92.0, the maximum is 5043254.0 and mean is 49662.4.'
;

footnote2
'Moreover, we can see that the minimum of unemployment rate in 2016 is 1.70%, the maximum is 23.5 and mean is 5.5%.'
;

footnote3
'Further analysis to look for the relationship between the civilian labor force and the unemployment rate.'
;
*
Methodology: Compute five-number summaries about the civilian labor force and the unemployment rate.
Limitations:  This methodology does not account for state with missing data,
nor does it attempt to validate data in any way.
Possible Follow-up Steps:  More carefully clean the values of the variable
Unemployment_rate_2016 and civilian_labor_force so that the statistics computed do not include any
possible illegal values, and better handle missing data.
;

proc means
		min q1 mean q3 max
		data=unemployment_analytic_file
	;
	var
		civilian_labor_force_2016
		unemployment_rate_2016
	;
	output
		out=unemployment_analytic_file_temp
	;
run;
title;
footnote;


title1
'Research Question: What are the top twenty area with the highest values of "Unemployment_rate_2016"?'
;

title2
'Rationale: This should help the government to identify the counties in the most need of improving employment level based upon Unemployment rate at the closest year.'
;

footnote1
'Based on the above output, Imperial county in CA has the highest unemployment rate(2016) of 23.50%, and this is over the mean value about 18.00%.'
;

footnote2
'Moreover, we can see that the range of the top twenty high level unemployment rate counties is 6.70%, which is 16.80-23.50%.'
;

footnote3
'Further analysis to look for the reason of the high unemployment rate counties, such as location or the relationship between the unemployment rate and number.'
;
*
Methodology: Use PORC SORT to decending the column "Unemployment_rate_2016", and
Use PROC PRINT to print just the first twenty observations from
the dataset file.
Limitations: If there are duplicate values with respect to the columns specified, then
rows are typically moved around as little as possible, meaning that they will
remain in the same order as in the original dataset.
Possible Follow-up Steps: More carefully clean the duplicate values of the variable
unemployment rate before we submit this code, do some noduplicate checks in data prep file.
;
proc sort
        data=Unemployment_analytic_file
    ;
    by
        descending Unemployment_rate_2016
    ;
run;
proc print
        noobs
        data=Unemployment_analytic_file(obs=20)
    ;
    id
        Area_Name
		Unemployed_2016
    ;
    var
        Unemployment_rate_2016
    ;
run;
title;
footnote;


title1
'Research Question: What are the range of the unemployment rate at 2016 for each state?'
;

title2
'Rationale: This should help the government to identify the difference of unemployment rate(2016) in each state, which may deal with the unemployment issue in specific place.'
;

footnote1
'Based on the above output, CA has the biggest range of unemployment rate(2016) of 20.50%, which show big difference of unemployment issue between the differnent area in CA.'
;

footnote2
'Moreover, we can see that the states which have many N obs(>20), their range always equal or larger than 3.0%.'
;

footnote3
'Further analysis to look for the reason of the high unemployment rate, why the same state will have a big difference of unemployment rate, such location, education and race.'
;
*
Methodology: Use PORC MEANS to max, min and range the data of "Unemployment_rate_2016" for "state" 
and output the results to a temporary dataset.
Limitations:  This methodology does not account for state with missing data,
nor does it attempt to validate data in any way.
Possible Follow-up Steps:  More carefully clean the values of the variable
Unemployment_rate_2016 so that the statistics computed do not include any
possible illegal values, and better handle missing data.
;

proc means
		max
		min
		range
		maxdec=1
		data=Unemployment_analytic_file
	;
	class
		state
	;
	var
		Unemployment_rate_2016
	;
	output
		out=Unemployment_analytic_file_temp
	;
run;
title;
footnote;

