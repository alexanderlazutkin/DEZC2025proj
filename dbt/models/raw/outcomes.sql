{{ config(materialized = 'table') }}

SELECT
  month_date
, crime_id
, outcome_type
, reported_by
, longitude
, latitude
, coalesce(lsoa_code,' N/A') as lsoa_code
, upper(lsoa_name) as lsoa_name
, coalesce(upper(replace(location,'On or near','')),'NO LOCATION') as location
, upper(SPLIT_PART( SPLIT_PART(file_name, '/', -1),  '-', -2 )) as region
, file_name
, loaded_dt
FROM {{ source('s3', 'outcomes') }}
