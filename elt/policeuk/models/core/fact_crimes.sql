{{ 
  config(materialized = 'table', full_refresh = true)
}}

select 
      row_number() OVER (partition by crime_id ORDER BY month_date) as rn
    , month_date
    , case when crime_id is null then 'ASB incident' else {{ dbt_utils.generate_surrogate_key(['crime_id']) }} end as crime_id
    , {{ dbt_utils.generate_surrogate_key(['crime_type']) }} as crime_type_id
    , {{ dbt_utils.generate_surrogate_key(['reported_by']) }} as police_force_id
    , lsoa_code
    , location
    , region
    , {{ dbt_utils.generate_surrogate_key(['file_name']) }} as file_id
    , loaded_dt
from {{ ref('crimes') }}



