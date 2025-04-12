select 
    {{ dbt_utils.generate_surrogate_key(['reported_by']) }} as police_force_id
  , upper(reported_by) as police_force
from {{ ref('crimes') }}
group by all
union
select 
    {{ dbt_utils.generate_surrogate_key(['reported_by']) }} as police_force_id
  , upper(reported_by) as police_force
from {{ ref('outcomes') }}
group by all