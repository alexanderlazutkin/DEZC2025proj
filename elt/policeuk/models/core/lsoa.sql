select 
  ' N/A' as lsoa_code
, ' NOT AVAILABLE' as lsoa_name     
union all
select 
  lsoa_code
, upper(lsoa_name) as lsoa_name
from {{ ref('crimes') }}
group by all
union 
select 
  lsoa_code
, upper(lsoa_name) as lsoa_name
from {{ ref('outcomes') }}
group by all