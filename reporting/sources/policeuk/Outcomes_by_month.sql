SELECT c.year, c.month_date, c."month", c.month_name, count(distinct f.crime_id) as crimes
FROM main_core.calendar as c 
 join main_core.fact_crimes_and_outcomes as f on c.month_date = f.outcome_month_date
where c.year >=2020 
group by all
  order by c.year,c.month_date;