Select *
From [Portfolio project]..Vaccination$
Order by 3,4
 
Select * 
From [Portfolio project]..covid$
Order by 3,4

Select location,date,total_cases,total_deaths,population
From [Portfolio project]..covid$
Order by 3,4

--Calculating the infected rate under the percentage of population 

Select location,date,total_deaths,population, (total_cases/population)*100 as PercentagePopulationinfected
From [Portfolio project]..covid$
Order by 1,2

--Calculating the mortality rate for the population of India

Select location,date,total_deaths, population, (total_deaths/population)*100 as PercentagePopulationinfected
From [Portfolio project]..covid$
Where location like '%India%'
Order by 1,2

--Calculating the Infection rates for various countries

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as Infectionpercentage
From [Portfolio project]..covid$
Group by population,location
Order by Infectionpercentage desc

--Showing the countries with highest death count for population

Select location, MAX(total_deaths) as TotalDeath
From [Portfolio project]..covid$
Where continent is not null
Group by location
Order by TotalDeath desc

--Continent-wise breakdown for the Infection

Select location,MAX(total_deaths) as TotalDeaths
From [Portfolio project]..covid$
Where continent is null
Group by location
Order by TotalDeaths desc 


Select continent,MAX(total_deaths) as TotalDeaths
From [Portfolio project]..covid$
Where continent is not null
Group by continent
Order by TotalDeaths desc 

--Understanding the highest death rate per population

Select location,date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths , SUM(cast(new_deaths as int))/SUM(cast(new_cases as int))*100 as Deathpercentage 
From [Portfolio project]..covid$
Where continent is not null
Group by  date,location
Order by 1,2 desc


--Total population VS Vaccination
With PopvsVac(Continent,Location,Date,Population,New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,SUM (convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
From [Portfolio project]..Vaccination$ vac
Join [Portfolio project]..covid$  dea
      On dea.location = vac.location
	  and dea.date = vac.date
Where  dea.continent is not null
)

Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac





DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated


Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,SUM (CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location 
Order by dea.location,dea.date) as RollingPeopleVaccinated
From [Portfolio project]..Vaccination$ vac
Join [Portfolio project]..covid$  dea
      On dea.location = vac.location
	  and dea.date = vac.date
--Where  dea.continent is not null


Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

--Storing data for visualisations
Create view PercentPopulationVaccinated as 
Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,SUM (CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location 
Order by dea.location,dea.date) as RollingPeopleVaccinated
From [Portfolio project]..Vaccination$ vac
Join [Portfolio project]..covid$  dea
      On dea.location = vac.location
	  and dea.date = vac.date
Where  dea.continent is not null

