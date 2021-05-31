/*SQL Data Exploration*/

SELECT * FROM ProjectPortfolio.dbo.CovidDeath
ORDER BY 4,5;

-- Count Total Cases & Total Deaths for each location
SELECT location, date, new_cases, SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) AS rolling_cases,
	new_deaths, SUM(cast(new_deaths as int)) OVER (PARTITION BY location ORDER BY location, date) AS rolling_deaths
FROM ProjectPortfolio..CovidDeath
WHERE continent is not null
ORDER BY 1,2;

-- Total death & case per location (TAB)
SELECT location, MAX(total_cases) as totalcase, MAX(cast(total_deaths as int)) as totaldeaths
FROM ProjectPortfolio..CovidDeath
WHERE continent is not null 
GROUP BY location
ORDER BY totaldeaths desc

-- Total death & case per continent (TAB)
SELECT location, MAX(total_cases) as totalcase, MAX(cast(total_deaths as int)) as totaldeaths
FROM ProjectPortfolio..CovidDeath
WHERE continent is null AND location not in('European Union', 'International')-- to see per continent
GROUP BY location
ORDER BY totalcase desc

-- Total death & case per continent per day(TAB)
SELECT location, date, total_cases, cast(total_deaths as int) as total_deaths
FROM ProjectPortfolio..CovidDeath
WHERE continent is null AND location not in('European Union', 'International')-- to see per continent
ORDER BY 1,2

-- New death & case per continent per day(TAB)
SELECT location, date, new_cases, cast(new_deaths as int) as new_deaths
FROM ProjectPortfolio..CovidDeath
WHERE continent is null AND location not in('European Union', 'International')-- to see per continent
ORDER BY 1,2

-- Total death & case per continent (2)
SELECT continent, MAX(total_cases) as totalcase, MAX(cast(total_deaths as int)) as totaldeaths
FROM ProjectPortfolio..CovidDeath
WHERE continent is not null
GROUP BY continent
ORDER BY totalcase desc

-- Prevalency Rate per continent(TAB)
SELECT dth.location, MAX(dth.total_cases) as cases, MAX(pop.population) as population, (MAX(dth.total_cases/pop.population)*100) as prevalency
FROM ProjectPortfolio..CovidDeath dth JOIN ProjectPortfolio..CovidDesc pop ON dth.location = pop.location AND dth.date = pop.date
WHERE dth.continent is null AND dth.location not in('European Union', 'International')-- to see per continent
GROUP BY dth.location
ORDER BY prevalency desc


-- Fatality Rate per continent(TAB)
SELECT dth.location, MAX(cast(dth.total_deaths as int)) as total_deaths, MAX(dth.total_cases) as total_cases, (MAX(cast(dth.total_deaths as int))/MAX(dth.total_cases))*100 as fatality
FROM ProjectPortfolio..CovidDeath dth
WHERE dth.continent is null AND dth.location not in('European Union', 'International')-- to see per continent
GROUP BY dth.location
ORDER BY fatality desc

-- Total cases & total deaths per day worldwide (TAB)
SELECT date, SUM(total_cases) as total_cases, SUM(cast(total_deaths as int)) as total_deaths
FROM ProjectPortfolio..CovidDeath
WHERE continent is not null
GROUP BY date
ORDER BY date

-- New cases & new deaths per day worldwide (TAB)
SELECT date, SUM(new_cases) as new_cases, SUM(cast(new_deaths as int)) as new_deaths
FROM ProjectPortfolio..CovidDeath
WHERE continent is not null
GROUP BY date
ORDER BY date

-- Create view to store rolling cases and rolling deaths
DROP VIEW IF EXISTS CasesDeathTotal;
CREATE VIEW CasesDeathTotal AS
SELECT location, date, new_cases, SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) AS rolling_cases,
	new_deaths, SUM(cast(new_deaths as int)) OVER (PARTITION BY location ORDER BY location, date) AS rolling_deaths
FROM ProjectPortfolio..CovidDeath
WHERE continent is not null

SELECT * FROM CasesDeathTotal
ORDER BY 1,2

-- Prevalency Rate (using view)
SELECT death.location, MAX(death.rolling_cases) as cases, MAX(pop.population) as population, (MAX(death.rolling_cases/pop.population)) as prevalency_rate
FROM CasesDeathTotal death
	JOIN ProjectPortfolio..CovidDesc pop ON death.location = pop.location AND death.date = pop.date
GROUP BY death.location
ORDER BY prevalency_rate desc

-- vaccinated 
SELECT location, MAX(cast(total_vaccinations as int)) as total_vaccinations
FROM ProjectPortfolio..CovidVacc
WHERE continent is not null
GROUP BY location
ORDER BY total_vaccinations desc

-- vaccinated vs population
SELECT vacc.location, MAX(cast(vacc.total_vaccinations as int)) as total_vaccinations, MAX(pop.population) as population
FROM ProjectPortfolio..CovidVacc vacc JOIN ProjectPortfolio..CovidDesc pop ON vacc.location = pop.location AND vacc.date = pop.date
WHERE vacc.continent is not null
GROUP BY vacc.location
ORDER BY total_vaccinations desc

--Create view to store total vaccination data per location (TAB)
If exists(select 1 from sys.views where name='VaccTotal' and type='v') DROP VIEW VaccTotal
CREATE VIEW VaccTotal AS
SELECT vacc.location, vacc.date, pop.population, vacc.new_vaccinations, SUM(CONVERT(int, vacc.new_vaccinations)) OVER (PARTITION BY vacc.location ORDER BY vacc.location, vacc.date) as totalvaccinations
FROM ProjectPortfolio..CovidVacc vacc JOIN ProjectPortfolio..CovidDesc pop ON vacc.location = pop.location AND vacc.date = pop.date
WHERE vacc.continent is not null

SELECT * FROM VaccTotal
ORDER BY 1,2

-- Vaccination percentage per location
SELECT *, (totalvaccinations/population)*100 as percent_vacc
FROM VaccTotal
ORDER BY 1,2

-- Test per location per day
DROP VIEW IF EXISTS CovidTest
CREATE VIEW CovidTest AS
SELECT vacc.location, vacc.date, population, vacc.new_tests, SUM(CONVERT(int, vacc.new_tests)) OVER (PARTITION BY vacc.location ORDER BY vacc.location, vacc.date) as totaltests
FROM ProjectPortfolio..CovidVacc vacc JOIN ProjectPortfolio..CovidDesc pop ON vacc.location = pop.location AND vacc.date = pop.date
WHERE vacc.continent is not null
--ORDER BY 1,2

-- Test percentage per location (TAB)
SELECT *
FROM CovidTest
ORDER BY 1,2


