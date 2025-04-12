select 
   date as month_date
 , EXTRACT(YEAR FROM date) AS year
 , EXTRACT(QUARTER FROM date) as quarter
 , EXTRACT(MONTH FROM date) AS month
 , monthname(date) as month_name
from generate_series(DATE '2019-01-01', DATE '2026-01-01', INTERVAL 1 MONTH) AS d(date)

/*
WITH dates as 
(
   {{ dbt_date.get_date_dimension("2019-01-01", "2026-01-01") }}
)

select  cast(date_day as date) as month_date
      , Quarter(date_day) as quarter
      , Year(date_day) as year
      , Month(date_day) as month
      , {{ dbt_date.month_name('date_day') }} as month_name
from dates
where {{ dbt_date.day_of_month("date_day") }} = 1
*/