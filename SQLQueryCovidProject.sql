Select *
From PortofolioProject..CovidDeaths
order by 3,4 
/*
Select * 
From PortofolioProject..CovidVactinations
order by 3,4 
*/

--Selecting Data that we are going to be using

select location, date,total_cases,new_deaths,new_deaths,population
From PortofolioProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows the likelyhood pf dying if you contact covid in your country
select location, date,total_cases,total_deaths, Coalesce(total_deaths/Nullif(total_cases,0),0)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where location like 'Germany'
order by 1,2

--looking at the Total Cases vs Population

select location, date,total_cases,population, Coalesce(total_cases/Nullif(population,0),0)*100 as PercentofThePopulationInfected
From PortofolioProject..CovidDeaths
Where location like 'Germany'
order by 1,2

--Looking at the Highest Infection Rate compared to Population

select location,population, Max(total_cases) as HighestInfectionCount,  Max(Coalesce(new_cases/Nullif(population,0),0)*100) as PercentofThePopulationInfected
From PortofolioProject..CovidDeaths
Group by location,population
order by PercentofThePopulationInfected desc

--Let't break this up by continent

select continent,Max(cast (total_deaths as int)) as TotaldeathCount
from PortofolioProject..CovidDeaths
where continent is not NULL
group by continent
order by TotaldeathCount desc

--Looking at Total Population vs Vaccinated

P
order by 2,3,4

-- Use CTE
With PopvsVac(continent,location,date,population,New_vaccinations,RoolingpeopleVaccinated)
as (
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))over (Partition by dea.location order by dea.location,dea.date) as RoolingPeopleVaccinated
From PortofolioProject..CovidVactinations as vac
join PortofolioProject..CovidDeaths as dea
on dea.location=vac.location
and dea.date=vac.date
where vac.continent IS NOT NULL

)
select * ,RoolingpeopleVaccinated/population*100
from PopvsVac

With AGEvsPop(location,Population,Age70,ElderlyDeaths)
as(
select dea.location,MAX(dea.total_deaths) over (Partition by dea.location)as ElderlyDeaths,dea.population,vac.aged_70_older
from PortofolioProject..CovidVactinations as vac
join PortofolioProject..CovidDeaths as dea
on dea.location = vac.location
)
select * , ElderlyDeaths/population*100
From AgevsPop

--TempTable
DROP Table IF EXISTS #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vacciation numeric,
RollingPeoplevaccinated numeric
)

insert into #PercentPopulationVaccinated

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))over (Partition by dea.location order by dea.location,dea.date) as RoolingPeopleVaccinated
From PortofolioProject..CovidVactinations as vac
join PortofolioProject..CovidDeaths as dea
on dea.location=vac.location
and dea.date=vac.date
where vac.continent IS NOT NULL
Order by 2,3
select * 
From #PercentPopulationVaccinated

--Creatting View to store data for later visualisations

Create View PercentPopulationVaccinated1 as 

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))over (Partition by dea.location order by dea.location,dea.date) as RoolingPeopleVaccinated
From PortofolioProject..CovidVactinations as vac
join PortofolioProject..CovidDeaths as dea
on dea.location=vac.location
and dea.date=vac.date
where vac.continent IS NOT NULL

select *
From PercentPopulationVaccinated1

Create View PeoplevsVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))over (Partition by dea.location order by dea.location,dea.date) as RoolingPeopleVaccinated
From PortofolioProject..CovidVactinations as vac
join PortofolioProject..CovidDeaths as dea
on dea.location=vac.location
and dea.date=vac.date
where vac.continent IS NOT NULL

Create View ContactCovidinGermany as
select location, date,total_cases,total_deaths, Coalesce(total_deaths/Nullif(total_cases,0),0)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where location like 'Germany'
