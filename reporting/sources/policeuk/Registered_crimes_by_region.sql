SELECT region, year, crimes
  , lag(crimes) OVER (PARTITION BY region ORDER BY year) as prev_year
  , crimes/lag(crimes) OVER (PARTITION BY region ORDER BY year) as year_over_year
FROM (
SELECT f.region
      , c.year
      , count(distinct f.crime_id) as crimes
FROM main_core.fact_crimes_and_outcomes as f 
 join main_core.calendar as c on c.month_date = f.registered_month_date
group by all
  ) as t;