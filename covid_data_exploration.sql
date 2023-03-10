select * from coviddeaths
order by 3,4 asc

select * from covidvaccinations
order by 3,4 asc

-- select data that we are going to be using
select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2

-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deaths_Percentage
from coviddeaths
where location like '%indonesia%'
order by 1,2

-- looking at total cases vs population
-- shows what percentage of population got covid
select location, date, total_cases, population, (total_deaths/population)*100 as infection_rate
from coviddeaths
where location like '%indonesia%'
order by 1,2

-- looking at countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestinfectionCount, max((total_cases/population))*100 as Percent_Population_infected
from coviddeaths
group by location, population
order by Percent_Population_infected desc

-- Showing the countries with the highest death count per population
select location, max(total_deaths) as Total_Death_Count
from coviddeaths
where continent is not null
group by location
order by Total_Death_Count desc

-- Break things down by continent
-- Showing continents with the highest death count per population
select continent, max(total_deaths) as Total_Death_Count
from coviddeaths
where continent is not null
group by continent
order by Total_Death_Count desc

-- Global Numbers
select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1,2

-- percentage of daily deaths by covid in the world
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as deathpercentage
from coviddeaths
where continent is not null
group by date
order by 1,2

-- death percentage by covid in the world
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as deathpercentage
from coviddeaths
where continent is not null
order by 1,2

-- Join
select *
from coviddeaths dea join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date

-- Looking at Total Population vs Total Vaccinations
select dea.continent, dea.location, dea.date, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3

