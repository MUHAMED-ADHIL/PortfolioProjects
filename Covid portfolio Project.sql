Select * from PortfolioProject..CovidDeaths
order by 3,4;

--Select * from PortfolioProject..CovidVaccinations
--order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2;

--Death Percentage
Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercernt
from PortfolioProject..CovidDeaths
where location like 'india'
order by 1,2;


--percent of population got covid
Select location,date,population,total_cases, (total_deaths/population)*100 AS DeathPercernt
from PortfolioProject..CovidDeaths
where location like 'india'
order by 1,2;

--countries with highest infection rate
Select location,population,max(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like 'india'
group by location,population
order by PercentPopulationInfected desc;


--Countries with highest deathcount per population
Select location, MAX(cast(total_deaths  as int)) as totalDeathcount
from PortfolioProject..CovidDeaths
--where location like 'india'
where continent is not null
group by location
order by totalDeathcount desc;


--by continent highest death count
Select continent, MAX(cast(total_deaths  as int)) as totalDeathcount
from PortfolioProject..CovidDeaths
--where location like 'india'
where continent is not null
group by continent
order by totalDeathcount desc;


--Global numbers

Select date,sum(new_cases) as Sum_newcases, sum(cast(new_deaths as int)) as sum_newdeaths , (sum(cast(new_deaths as int))/sum(new_cases))*100 as Death_percentage
from PortfolioProject..CovidDeaths
--where location like 'india'  
where continent is not null
group by date
order by 1,2;


Select sum(new_cases) as Sum_newcases, sum(cast(new_deaths as int)) as sum_newdeaths , (sum(cast(new_deaths as int))/sum(new_cases))*100 as Death_percentage
from PortfolioProject..CovidDeaths
--where location like 'india'  
where continent is not null
--group by date
order by 1,2;


--total population vs vaccination


Select dea.continent,dea.location,dea.date ,dea.population , vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int))  OVER (partition by dea.location order by dea.location,dea.date) as PeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN
PortfolioProject..CovidVaccinations vac
ON dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3




--USE CTE
with PopvsVac(Continent,Location,Date,population,new_vaccinations,PeopleVaccinated)
as
(
Select dea.continent,dea.location,dea.date ,dea.population , vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int))  OVER (partition by dea.location order by dea.location,dea.date) as PeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN
PortfolioProject..CovidVaccinations vac
ON dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(PeopleVaccinated/population)*100 AS VAC_Percent from PopvsVac

--TEMP TABLE

drop table if exists #PercentPopulationVaccinated
Create table  #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccination numeric,
PeopleVaccinated numeric
)

 
insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date ,dea.population , vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int))  OVER (partition by dea.location order by dea.location,dea.date) as PeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN
PortfolioProject..CovidVaccinations vac
ON dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *,(PeopleVaccinated/population)*100 AS VAC_Percent from #PercentPopulationVaccinated


--VIEW



create view PopulationVaccinated as 
Select dea.continent,dea.location,dea.date ,dea.population , vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int))  OVER (partition by dea.location order by dea.location,dea.date) as PeopleVaccinated
from PortfolioProject..CovidDeaths dea
JOIN
PortfolioProject..CovidVaccinations vac
ON dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PopulationVaccinated


