with 
first_registered_crime as (
SELECT
  month_date
, crime_id
, crime_type_id
, police_force_id
, lsoa_code
, location
, region
, file_id
, loaded_dt
from {{ ref('fact_crimes') }}
where rn = 1 or crime_id is null
),
last_outcome as (
SELECT
  month_date
, crime_id
, outcome_type_id
, loaded_dt
from {{ ref('fact_outcomes') }}
where rn = 1 --or crime_id is null
)

select 
    c.crime_id
  , c.crime_type_id
  , c.police_force_id
  , c.lsoa_code
  , c.location
  , c.region
  , coalesce(o.outcome_type_id,' N/A') as outcome_type_id
  , c.month_date as registered_month_date
  , o.month_date as outcome_month_month_date
  , datediff('month',c.month_date ,o.month_date) as duration_months
  , case when o.month_date is null then true else false end as is_missing_outcome
  , c.file_id
  , greatest(o.loaded_dt, c.loaded_dt) as loaded_dt
from first_registered_crime as c
  join last_outcome as o on o.crime_id = c.crime_id
-- where c.crime_id != 'ASB incident'
-- and is_missing_outcome = false
