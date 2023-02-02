SELECT *
From PortfolioProject..CovidDeaths
Where continent is not NULL
order by 3, 4

--SELECT *
--From PortfolioProject..CovidVaccinations
--order by 3, 4


-- Select data that is going to be used

SELECT location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not NULL
-- below query helps find objects in the database whose names we are not sure of. I wasn't sure if it is UnitedStates or United States.
-- Where location like '%states'
-- where location like 'india'
order by 1, 2


-- Looking at Total Cases vs population
-- shows what percentage of population got covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'
and continent is not NULL


-- Looking at countries with highest infection rate compared to popultion 

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- where location like '%states%'
Group by location, population
-- order by 1, 2
order by PercentPopulationInfected desc



-- showing continent with highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
-- cast funcation converts a value of any type into a specific datatype 
From PortfolioProject..CovidDeaths
-- where location like '%states%'
Where continent is not NULL
Group by continent 
order by TotalDeathCount desc



-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not NULL
-- Group by date 
order by 1, 2

-- Trail
-- GLOBAL NUMBERS

--SELECT location, total_cases, CONCAT(ROUND(total_cases/1000000, 2), ' Million') as Cases_more_1M
--From PortfolioProject..CovidDeaths
--WHERE location NOT LIKE '%world%'
--and total_cases >= 1000000
---- Group by date 
--order by total_cases desc


-- Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations 
, SUM(CONVERT(int, dea.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
order by 1, 2, 3

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
-- order by 2, 3
)

SELECT *
From PopvsVac