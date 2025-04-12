select 
  ' N/A' as outcome_type_id
, ' NOT AVAILABLE' as outcome_type     
union all
select 
    {{ dbt_utils.generate_surrogate_key(['outcome_type']) }} as outcome_type_id
  , upper(outcome_type) as outcome_type
from {{ ref('outcomes') }}
group by all