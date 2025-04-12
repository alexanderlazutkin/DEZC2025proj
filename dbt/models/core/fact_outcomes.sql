{{ 
  config(materialized = 'table', full_refresh = true)
}}

select 
      row_number() OVER (partition by crime_id ORDER BY month_date DESC) as rn
    , month_date
    , case when crime_id is null then 'AsB incident' else {{ dbt_utils.generate_surrogate_key(['crime_id']) }} end as crime_id
    , {{ dbt_utils.generate_surrogate_key(['outcome_type']) }} as outcome_type_id
    , {{ dbt_utils.generate_surrogate_key(['reported_by']) }} as police_force_id
    , lsoa_code
    , location
    , region
    , {{ dbt_utils.generate_surrogate_key(['file_name']) }} as file_id
    , loaded_dt
from {{ ref('outcomes') }}


