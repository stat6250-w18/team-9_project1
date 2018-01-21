*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding Employment, Unemployment, and Median Household Income in 
the USA.

Dataset Name: Unemployment_analytic_file created in external file
STAT6250-01_w18-team-9_project1_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup
;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset Unemployment_analytic_file;
%include '.\STAT6250-01_w18-team-9_project1_data_preparation.sas';

*
'Research Question 1: What are the top 5 counties in the US with the lowest 
unemployment rate and and highest median household income in 2015?'

'Rationale: This would help identify the most counties with the lowest 
unemployment rate for job seekers.'

'Research Question 2: What are the top 5 counties in California with the 
lowest unemployment rate and highest median household income in 2015?

'Rationale: This would help identify the best counties in California to live 
in term of job seeking and median household income.'

'Research Question 3: What are the differences between the top 5 counties in 
the US vs. the top 5 counties in California in term of median household income?'

'Rationale: This would help identify California is still the best state to 
look for job.'
;
