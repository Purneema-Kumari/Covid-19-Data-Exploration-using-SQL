/*
Covid 19 Data Exploration 
Skills used: Joins, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/



Select *
From SQLProject1..CovidDeaths
where continent is not null
order by 3,4

--Select *
--From SQLProject1..CovidVaccination
--order by 3,4

--Select the data that we are going to use

Select location, date, total_cases, new_cases, total_deaths, population
From SQLProject1..CovidDeaths
where continent is not null
order by 1,2

--Looking at the Total Cases vs Total Deaths
-- Likelihood of dying if you contract covid in India
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From SQLProject1..CovidDeaths
where location like '%India%'
and continent is not null
order by 1,2


-- Looking at the Total  Cases Vs Population
-- Shows what percentage of population got Covid

Select location, date, total_cases, population, (total_cases/population)*100 as PercentagePopulationInfected
From SQLProject1..CovidDeaths
--where location like '%India%'
where continent is not null
order by 1,2


--Looking at Countries with Highest Infection Rate compared to Population

Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
From SQLProject1..CovidDeaths
--where location like '%India%'
where continent is not null
Group by location, population
order by PercentagePopulationInfected desc


--Showing Countries with Highest Death Count per population

Select location, max(cast(total_deaths as int)) as TotalDeathCount
From SQLProject1..CovidDeaths
--where location like '%India%'
where continent is not null
Group by location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT

--Showing continents with the highest death count per population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From SQLProject1..CovidDeaths
--where location like '%India%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBER

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From SQLProject1..CovidDeaths
--Where location like '%India%'
where continent is not null 
--Group By date
order by 1,2



--Looking at Total Poulation vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From SQLProject1..CovidDeaths dea
Join SQLProject1..CovidVaccination vac 
   on dea.location = vac.location 
   and dea.date = vac.date
where dea.continent is not null 
order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
From SQLProject1..CovidDeaths dea
Join SQLProject1..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--Creating view to store data for later visualizations
Create view TotalDeathCount as
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From SQLProject1..CovidDeaths
--where location like '%India%'
where continent is not null
Group by continent
--order by TotalDeathCount desc
