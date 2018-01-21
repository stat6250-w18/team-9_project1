*******************************************************************************;
* Added an 80-character banner for reference **********************************;
*******************************************************************************;

*
STAT6250-01_w18-team-9_project1_data_preparation.sas
This file loads the data set to be used in our analysis.

[Dataset Name] Employment, Unemployment, and Median Household Income (annual 
average 2016 unemployment and 2015 income latest)

[Experimental Units] United States Department of Agriculture Economic Research 
Service, County-level Data Sets

[Number of Observations] 3274

[Number of Features] 48

[Data Source] https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.xls?v=42894

[Data Dictionary] https://www.ers.usda.gov/data-products/county-level-data-sets/

[Unique ID Schema] The column ‘FIPStxt’ is a primary key.

;


* setup environmental parameters;

%let inputDatasetUrl = 
https://github.com/stat6250/team-9_project1/blob/master/Unemployment.xls
;


* load raw dataset over the wire;
filename tempfile TEMP;
proc http
	method="get"
	url="&inputDatasetURL."
	out=template
	;
run;
proc import
	file=tempfile
	out=Unemployment_raw
	dbms=xls
	;
run;
filename tempfile clear;

* check raw Unemployment dataset for duplicate with respect to its composite key;
proc sort 
	nodupkey data=Unemployment_raw 
	dupout=Unemployment_raw_dups 
	out=_null_;
	by FIPStxt;
run;




