use default;
create external table chicago_crime_raw (
	id string, 
	case_no string, 
	crime_date string, 
	block string, 
	iucr string, 
	primary_type string, 
	description string, 
	location_description string,
	arrest string, 
	domestic string,
	beat string, 
	district string, 
	ward string, 
	community_area string, 
	fbi_code string, 
	coordinate_x string, 
	coordinate_y string, 
	year string, 
	updated_on string, 
	latitude string, 
	longitude string, 
	location string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\"",
   "escapeChar"    = "\\"
)  
STORED AS TEXTFILE
LOCATION  '/user/cloudera/rawdata/crime/chicago';

create table chicago_crime (
	id string, 
	case_no string, 
	crime_date string, 
	block string, 
	iucr string, 
	primary_type string, 
	description string, 
	location_description string,
	arrest string, 
	domestic string,
	beat string, 
	district string, 
	ward string, 
	community_area string, 
	fbi_code string, 
	coordinate_x string, 
	coordinate_y string, 
	updated_on string, 
	latitude string, 
	longitude string, 
	location string
)
partitioned by (year string)
stored as parquet;

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table chicago_crime partition(year)
select id, case_no, crime_date, block, iucr, primary_type, description, location_description, arrest, domestic, beat, district, ward, community_area, fbi_code, coordinate_x, coordinate_y, updated_on, latitude, longitude, location, year 
from chicago_crime_raw where crime_date != 'Date';
set hive.exec.dynamic.partition.mode=strict;