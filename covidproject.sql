-- Copy the coviddeaths table.
create table coviddeaths_new 
like coviddeaths;

insert coviddeaths_new
select *
from coviddeaths;

--          change format of date
-- Add a column to put changes
alter table coviddeaths_new
add column date_format date;
-- Modify the format from text to date format
update coviddeaths_new
set date_format = str_to_date(`date`, '%d/%m/%Y');

-- check if changes happened

select *
from coviddeaths_new
order by date_format;

-- modify the position of date_format
alter table coviddeaths_new
modify column date_format date
after location;

-- drop date column 'old' column

alter table coviddeaths_new
drop column `date`;

select *
from coviddeaths_new
order by date_format;

-- total cases VS total deaths

select location, date_format, total_cases, total_deaths, (total_cases / total_deaths) * 100 DeathsPercentage
from coviddeaths_new
where location != 'Afghanistan'
and continent is not null;

-- Total Cases vs Population
select Location, date_format, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
from coviddeaths_new
where continent is not null;

-- look for compraison between highest cases infected compared by PercentPopulationInfected

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths_new
Group by Location, Population
order by PercentPopulationInfected desc; 

-- Knowing the biggest number of deaths at each location

Select location, MAX(cast(total_deaths as signed)) as TotalDeathCount
from coviddeaths_new
group by location
;

-- Break this explanation by continent
select continent, max(cast(total_deaths as signed)) as TotalDeathCount
from coviddeaths_new
group by continent
order by TotalDeathCount desc;

-- Comparison between highest percentageNewDeath by continent
select continent,  sum(new_cases), sum(cast(new_deaths as signed)) TotalNewDeaths, sum(cast(new_deaths as signed))/sum(new_cases)*100 PercentageNewDeath
from coviddeaths_new
group by continent
order by PercentageNewDeath desc
;

-- Group by date the highest value of deaths
select `date_format`, location, sum(new_cases), sum(cast(new_deaths as signed)) TotalNewDeaths, 
        sum(cast(new_deaths as signed))/sum(new_cases)*100 PercentageNewDeath
from coviddeaths_new
group by `date_format`, location
order by `date_format`;

-- Get into vaccination process
--
SELECT 
  cod.continent, cod.location, cod.date_format, cod.population, cov.people_fully_vaccinated
  from coviddeaths_new  cod
  join covidvaccinations cov
  on cod.location = cov.location
  and cod.date_format = cov.`date`;

SHOW COLUMNS FROM covidvaccinations;




