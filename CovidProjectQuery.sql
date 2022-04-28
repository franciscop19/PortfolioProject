-- When importing one of the Excel tables (CovidVaccinations), it had empty values ('') and no NULL values. So to convert those empty values to NULL values:

UPDATE CovidVaccinations 
SET [new_tests] = NULLIF([new_tests], '')
UPDATE CovidVaccinations 
SET [total_tests_per_thousand] = NULLIF([total_tests_per_thousand], '')
UPDATE CovidVaccinations 
SET [new_tests_per_thousand] = NULLIF([new_tests_per_thousand], '')
UPDATE CovidVaccinations 
SET [new_tests_smoothed] = NULLIF([new_tests_smoothed], '')
UPDATE CovidVaccinations 
SET [new_tests_smoothed_per_thousand] = NULLIF([new_tests_smoothed_per_thousand], '')
UPDATE CovidVaccinations 
SET [positive_rate] = NULLIF([positive_rate], '')
UPDATE CovidVaccinations 
SET [tests_per_case] = NULLIF([tests_per_case], '')
UPDATE CovidVaccinations 
SET [tests_units] = NULLIF([tests_units], '')
UPDATE CovidVaccinations 
SET [total_vaccinations] = NULLIF([total_vaccinations], '')
UPDATE CovidVaccinations 
SET [people_vaccinated] = NULLIF([people_vaccinated], '')
UPDATE CovidVaccinations 
SET [people_fully_vaccinated] = NULLIF([people_fully_vaccinated], '')
UPDATE CovidVaccinations 
SET [total_boosters] = NULLIF([total_boosters], '')
UPDATE CovidVaccinations 
SET [new_vaccinations] = NULLIF([new_vaccinations], '')
UPDATE CovidVaccinations 
SET [new_vaccinations_smoothed] = NULLIF([new_vaccinations_smoothed], '')
UPDATE CovidVaccinations 
SET [total_vaccinations_per_hundred] = NULLIF([total_vaccinations_per_hundred], '')
UPDATE CovidVaccinations 
SET [people_vaccinated_per_hundred] = NULLIF([people_vaccinated_per_hundred], '')
UPDATE CovidVaccinations 
SET [people_fully_vaccinated_per_hundred] = NULLIF([people_fully_vaccinated_per_hundred], '')
UPDATE CovidVaccinations 
SET [total_boosters_per_hundred] = NULLIF([total_boosters_per_hundred], '')
UPDATE CovidVaccinations 
SET [new_vaccinations_smoothed_per_million] = NULLIF([new_vaccinations_smoothed_per_million], '')
UPDATE CovidVaccinations 
SET [new_people_vaccinated_smoothed] = NULLIF([new_people_vaccinated_smoothed], '')
UPDATE CovidVaccinations 
SET [new_people_vaccinated_smoothed_per_hundred] = NULLIF([new_people_vaccinated_smoothed_per_hundred], '')
UPDATE CovidVaccinations 
SET [stringency_index] = NULLIF([stringency_index], '')
UPDATE CovidVaccinations 
SET [population] = NULLIF([population], '')
UPDATE CovidVaccinations 
SET [population_density] = NULLIF([population_density], '')
UPDATE CovidVaccinations 
SET [median_age] = NULLIF([median_age], '')
UPDATE CovidVaccinations 
SET [aged_65_older] = NULLIF([aged_65_older], '')
UPDATE CovidVaccinations 
SET [aged_70_older] = NULLIF([aged_70_older], '')
UPDATE CovidVaccinations 
SET [gdp_per_capita] = NULLIF([gdp_per_capita], '')
UPDATE CovidVaccinations 
SET [extreme_poverty] = NULLIF([extreme_poverty], '')
UPDATE CovidVaccinations 
SET [cardiovasc_death_rate] = NULLIF([cardiovasc_death_rate], '')
UPDATE CovidVaccinations 
SET [diabetes_prevalence] = NULLIF([diabetes_prevalence], '')
UPDATE CovidVaccinations 
SET [female_smokers] = NULLIF([female_smokers], '')
UPDATE CovidVaccinations 
SET [male_smokers] = NULLIF([male_smokers], '')
UPDATE CovidVaccinations 
SET [handwashing_facilities] = NULLIF([handwashing_facilities], '')
UPDATE CovidVaccinations 
SET [hospital_beds_per_thousand] = NULLIF([hospital_beds_per_thousand], '')
UPDATE CovidVaccinations 
SET [life_expectancy] = NULLIF([life_expectancy], '')
UPDATE CovidVaccinations 
SET [human_development_index] = NULLIF([human_development_index], '')
UPDATE CovidVaccinations 
SET [excess_mortality_cumulative_absolute] = NULLIF([excess_mortality_cumulative_absolute], '')
UPDATE CovidVaccinations 
SET [excess_mortality_cumulative] = NULLIF([excess_mortality_cumulative], '')
UPDATE CovidVaccinations 
SET [excess_mortality] = NULLIF([excess_mortality], '')
UPDATE CovidVaccinations 
SET [excess_mortality_cumulative_per_million] = NULLIF([excess_mortality_cumulative_per_million], '')



SELECT *
FROM CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 3, 4


SELECT location, 
	   date,
	   total_cases,
	   new_cases,
	   total_deaths,
	   population
FROM CovidDeaths
ORDER BY 1, 2


-- Looking at Total Cases vs Total Deaths

SELECT location, 
	   date,
	   total_cases,
	   total_deaths,
	   DeathPercentage = (total_deaths/total_cases)*100
FROM CovidDeaths
ORDER BY 1, 2


-- Total Cases vs Population

SELECT location, 
	   date,
	   total_cases,
	   population,
	   PopulationPercentage = (total_cases/population)*100
FROM CovidDeaths
ORDER BY 1, 2


-- Looking at countries with highest infection rate vs population

SELECT location,
	   [HighestInfectionCount] = MAX(total_cases),
	   population,
	   [InfectionRate] = MAX((total_cases/population))*100
FROM CovidDeaths
GROUP BY location, population
ORDER BY InfectionRate DESC


-- Highest death rates per country

SELECT location,
	   [TotalDeathsCount] = MAX(cast(total_deaths as INT)),
	   population,
	   [DeathRate] = MAX((total_deaths/population))*100
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY DeathRate DESC


-- Highest death rates per continent

SELECT continent,
	   [DeathRate] = MAX((total_deaths/population))*100,
	   [TotalDeathsCount] = MAX(cast(total_deaths as INT))
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY DeathRate DESC


-- There was a continent that had '' data, so I transformed it to NULL value for the code to work:

/* 
UPDATE CovidDeaths
SET continent = NULLIF(continent, '')
*/

-- Checking if it worked:

SELECT continent
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent


-- Running it again:

SELECT continent,
	   [DeathRate] = MAX((total_deaths/population))*100,
	   [TotalDeathsCount] = MAX(cast(total_deaths as INT))
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY DeathRate DESC



-- Looking at global numbers by date

SELECT date,
	   [SumNewCases] = SUM(new_cases),
	   [SumNewDeaths] = SUM(CAST(new_deaths AS INT)),
	   [SumDeathRate] = ((SUM(CAST(new_deaths AS INT)))/(SUM(new_cases)))*100
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2


-- Today's total global numbers:

SELECT [TotalCases] = SUM(new_cases),
       [TotalDeaths] = SUM(CAST(new_deaths AS INT)),
       [TotalDeathRate] = ((SUM(CAST(new_deaths AS INT)))/(SUM(new_cases)))*100
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2


-- Joining the 2 tables to look at Total population vs Vaccinations

SELECT *
FROM CovidDeaths A
JOIN CovidVaccinations B ON A.location = B.location AND A.date = B.date


SELECT A.continent,
	   A.location,
	   A.date,
	   A.population,
	   B.new_vaccinations,
	   [vaccinated_people] = SUM(CAST(FLOOR(B.new_vaccinations) AS BIGINT)) OVER(PARTITION BY A.location ORDER BY A.location, A.date)
FROM CovidDeaths A
JOIN CovidVaccinations B ON A.location = B.location AND A.date = B.date
WHERE A.continent IS NOT NULL



-- Using CTE to look at the vaccination rate

WITH PopvsVac (continent, location, date, population, new_vaccinations, vaccinated_people)
AS
(
SELECT A.continent,
	   A.location,
	   A.date,
	   A.population,
	   B.new_vaccinations,
	   [vaccinated_people] = SUM(CAST(FLOOR(B.new_vaccinations) AS BIGINT)) OVER(PARTITION BY A.location ORDER BY A.location, A.date)
FROM CovidDeaths A
JOIN CovidVaccinations B ON A.location = B.location AND A.date = B.date
WHERE A.continent IS NOT NULL
)

SELECT *,
	   [vaccination_rate] = (vaccinated_people/population)*100
FROM PopvsVac



-- Another way of doing the previous analysis: with a Temp table

DROP TABLE IF EXISTS
CREATE TABLE PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
vaccinated_people numeric
)

INSERT INTO PercentPopulationVaccinated
SELECT A.continent,
	   A.location,
	   A.date,
	   A.population,
	   B.new_vaccinations,
	   [vaccinated_people] = SUM(CAST(FLOOR(B.new_vaccinations) AS BIGINT)) OVER(PARTITION BY A.location ORDER BY A.location, A.date)
FROM CovidDeaths A
JOIN CovidVaccinations B ON A.location = B.location AND A.date = B.date
WHERE A.continent IS NOT NULL

SELECT *,  [vaccination_rate] = (vaccinated_people/population)*100
FROM PercentPopulationVaccinated



-- Creating views for visualizations:

CREATE VIEW View_PercentPopulationVaccinated AS
SELECT A.continent,
	   A.location,
	   A.date,
	   A.population,
	   B.new_vaccinations,
	   [vaccinated_people] = SUM(CAST(FLOOR(B.new_vaccinations) AS BIGINT)) OVER(PARTITION BY A.location ORDER BY A.location, A.date)
FROM CovidDeaths A
JOIN CovidVaccinations B ON A.location = B.location AND A.date = B.date
WHERE A.continent IS NOT NULL



CREATE VIEW View_CasesVsDeaths AS
SELECT location, 
	   date,
	   total_cases,
	   total_deaths,
	   DeathPercentage = (total_deaths/total_cases)*100
FROM CovidDeaths



CREATE VIEW View_CasesVsPopulation AS
SELECT location, 
	   date,
	   total_cases,
	   population,
	   PopulationPercentage = (total_cases/population)*100
FROM CovidDeaths



CREATE VIEW View_InfectionRate AS
SELECT location,
	   [HighestInfectionCount] = MAX(total_cases),
	   population,
	   [InfectionRate] = MAX((total_cases/population))*100
FROM CovidDeaths
GROUP BY location, population



CREATE VIEW View_DeathRatePerCountry AS
SELECT location,
	   [TotalDeathsCount] = MAX(cast(total_deaths as INT)),
	   population,
	   [DeathRate] = MAX((total_deaths/population))*100
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population



CREATE VIEW View_DeathsPerContinent AS
SELECT continent,
	   [DeathRate] = MAX((total_deaths/population))*100,
	   [TotalDeathsCount] = MAX(cast(total_deaths as INT))
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent


