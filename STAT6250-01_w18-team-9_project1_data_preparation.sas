*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
This file prepares the dataset described below for analysis.

[Dataset Name] Employment, Unemployment(2007-2016), and Median Household Income (2015 only)

[Experimental Units] United States Department of Agriculture Economic Research 
Service, County-level Data Sets

[Number of Observations] 3274

[Number of Features] 47

[Data Source] https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.xls?v=42894

[Data Dictionary] https://www.ers.usda.gov/data-products/county-level-data-sets/

FIPStxt:Dataset unique identifier, (renamed FIPStxt to FIPS_Code as a primary 
key to match variable decscription databse) 
State:State-County
Area_name:State or County name
Rural_urban_continuum_code_2013:Rural-urban Continuum Code, 2013
Urban_influence_code_2013:Urban Influence Code, 2013
Metro_2013:Metro nonmetro dummy 0=Nonmetro 1=Metro (Based on 2013 OMB 
Metropolitan Area delineation)
Civilian_labor_force_2007:Civilian labor force annual average, 2007
Employed_2007:Number employed annual average, 2007
Unemployed_2007:Number unemployed annual average, 2007
Unemployment_rate_2007:Unemployment rate, 2007
Civilian_labor_force_2008:Civilian labor force annual average, 2008
Employed_2008:Number employed annual average, 2008
Unemployed_2008:Number unemployed annual average, 2008
Unemployment_rate_2008:Unemployment rate, 2008
Civilian_labor_force_2009:Civilian labor force annual average, 2009
Employed_2009:Number employed annual average, 2009
Unemployed_2009:Number unemployed annual average, 2009
Unemployment_rate_2009:Unemployment rate, 2009
Civilian_labor_force_2010:Civilian labor force annual average, 2010
Employed_2010: Number employed annual average, 2010
Unemployed_2010:Number unemployed annual average, 2010
Unemployment_rate_2010:Unemployment rate, 2010
Civilian_labor_force_2011:Civilian labor force annual average, 2011
Employed_2011:Number employed annual average, 2011
Unemployed_2011:Number unemployed annual average, 2011
Unemployment_rate_2011:Unemployment rate, 2011
Civilian_labor_force_2012:Civilian labor force annual average, 2012
Employed_2012: Number employed annual average, 2012
Unemployed_2012:Number unemployed annual average, 2012
Unemployment_rate_2012:Unemployment rate, 2012
Civilian_labor_force_2013:Civilian labor force annual average, 2013
Employed_2013:Number employed annual average, 2013
Unemployed_2013:Number unemployed annual average, 2013
Unemployment_rate_2013:Unemployment rate, 2013
Civilian_labor_force_2014:Civilian labor force annual average, 2014
Employed_2014:Number employed annual average, 2014
Unemployed_2014:Number unemployed annual average, 2014
Unemployment_rate_2014:Unemployment rate, 2014
Civilian_labor_force_2015:Civilian labor force annual average, 2015
Employed_2015: Number employed annual average, 2015
Unemployed_2015:Number unemployed annual average, 2015
Unemployment_rate_2015:Unemployment rate, 2015
Civilian_labor_force_2016:Civilian labor force annual average, 2016
Employed_2016:Number employed annual average, 2016
Unemployed_2016:Number unemployed annual average, 2016
Unemployment_rate_2016:Unemployment rate, 2016
Median_Household_Income_2015:Median household Income Annual Average, 2015
Med_HH_Income_Percent_of_State_Total_2015:County Household Median Income as 
a percent of the State Total Median Household Income (deleted)

[Unique ID Schema] The column ‘FIPS_Code’ is a primary key.
;


* environmental setup;


* setup environmental parameters;
%let inputDatasetURL =
https://github.com/stat6250/team-9_project1/blob/master/Unemployment.xls?raw=true
;


* load raw unemployment dataset over the wire;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xls";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    Unemployment_raw,
    &inputDatasetURL.,
    xls
)

* check raw Unemployment dataset for duplicates with respect to its primary key;
proc sort
        nodupkey
        data=Unemployment_raw
        dupout=Unemployment_raw_dups
        out=_null_
    ;
    by FIPS_Code
    ;
run;


* build analytic dataset from Unemployment dataset with the least number of
columns andminimal cleaning/transformation needed to address research 
questions in corresponding data-analysis files;
data unemployment_analytic_file;
    retain
		FIPS_Code
		State
		Area_name
		Rural_urban_continuum_code_2013
		Urban_influence_code_2013
		Metro_2013
		Civilian_labor_force_2007
		Employed_2007
		Unemployed_2007
		Unemployment_rate_2007
		Civilian_labor_force_2008
		Employed_2008
		Unemployed_2008
		Unemployment_rate_2008
		Civilian_labor_force_2009
		Employed_2009
		Unemployed_2009
		Unemployment_rate_2009
		Civilian_labor_force_2010
		Employed_2010
		Unemployed_2010
		Unemployment_rate_2010
		Civilian_labor_force_2011
		Employed_2011
		Unemployed_2011
		Unemployment_rate_2011
		Civilian_labor_force_2012
		Employed_2012
		Unemployed_2012
		Unemployment_rate_2012
		Civilian_labor_force_2013
		Employed_2013
		Unemployed_2013
		Unemployment_rate_2013
		Civilian_labor_force_2014
		Employed_2014
		Unemployed_2014
		Unemployment_rate_2014
		Civilian_labor_force_2015
		Employed_2015
		Unemployed_2015
		Unemployment_2015_rate
		Civilian_labor_force_2016
		Employed_2016
		Unemployed_2016
		Unemployment_rate_2016
		Median_Household_2015_Income
		
    ;
	keep
		FIPS_Code
		State
		Area_name
		Rural_urban_continuum_code_2013
		Urban_influence_code_2013
		Metro_2013
		Civilian_labor_force_2007
		Employed_2007
		Unemployed_2007
		Unemployment_rate_2007
		Civilian_labor_force_2008
		Employed_2008
		Unemployed_2008
		Unemployment_rate_2008
		Civilian_labor_force_2009
		Employed_2009
		Unemployed_2009
		Unemployment_rate_2009
		Civilian_labor_force_2010
		Employed_2010
		Unemployed_2010
		Unemployment_rate_2010
		Civilian_labor_force_2011
		Employed_2011
		Unemployed_2011
		Unemployment_rate_2011
		Civilian_labor_force_2012
		Employed_2012
		Unemployed_2012
		Unemployment_rate_2012
		Civilian_labor_force_2013
		Employed_2013
		Unemployed_2013
		Unemployment_rate_2013
		Civilian_labor_force_2014
		Employed_2014
		Unemployed_2014
		Unemployment_rate_2014
		Civilian_labor_force_2015
		Employed_2015
		Unemployed_2015
		Unemployment_2015_rate
		Civilian_labor_force_2016
		Employed_2016
		Unemployed_2016
		Unemployment_rate_2016
		Median_Household_2015_Income
		
    ;
	set Unemployment_raw;
run;


