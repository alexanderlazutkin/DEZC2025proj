select 
    {{ dbt_utils.generate_surrogate_key(['crime_type']) }} AS crime_type_id
  , upper(crime_type) as crime_type
from {{ ref('crimes') }}
group by all