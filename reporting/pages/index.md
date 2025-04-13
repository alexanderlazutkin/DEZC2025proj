## Crime statistics in UK

### Parameters
<Dropdown name=year>
    <DropdownOption value=-1 valueLabel="All Years"/>
    <DropdownOption value=2020/>
    <DropdownOption value=2021/>
    <DropdownOption value=2022/>
    <DropdownOption value=2023/>
    <DropdownOption value=2024/>
    <DropdownOption value=2025/>
</Dropdown>

### Registered crimes 

```Registered_crimes_by_month
select * 
from policeuk.Registered_crimes_by_month 
where year = '${inputs.year.value}' or '${inputs.year.value}' =-1
```
```Top5_region 
select region, year, crimes, prev_year, 1-year_over_year as year_over_year
from policeuk.Registered_crimes_by_region
where year = '${inputs.year.value}' or '${inputs.year.value}' =-1
order by region desc
limit 5;
```
<BarChart 
    data={Top5_region}
    title="Top 5 region crimes, {inputs.year.label}"
    x=region
    y=crimes 
    swapXY=true
/>

<DataTable data={Top5_region}> 
	<Column id=region title="Region"/>
	<Column id=crimes title="Current year"/>
	<Column id=prev_year title="Prev year"/>
    <Column id=year_over_year title="Y/Y Growth" fmt=pct1/>
</DataTable>

<BarChart 
    data={Registered_crimes_by_month}
    title="Registered crimes by types, {inputs.year.label}"
    series=crime_type
    x=month_date 
    y=crimes
    xFmt = "yyyy mmm"
/>
<DataTable data={Registered_crimes_by_month} />