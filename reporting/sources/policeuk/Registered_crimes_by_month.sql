SELECT c.year, c.month_date, c."month", c.month_name
      , ct.crime_type
      , count(distinct f.crime_id) as crimes
FROM main_core.calendar as c 
 join main_core.fact_crimes_and_outcomes as f on c.month_date = f.registered_month_date
 join main_core.crime_type as ct on ct.crime_type_id = f.crime_type_id
where c.year >=2020 
group by all
  order by c.year,c.month_date;