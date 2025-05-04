-- SQL Project - Data Cleaning & EDA

use world_layoff;

select *from layoffs;

CREATE TABLE layoff_staging
LIKE layoffs;

SELECT * from layoff_staging;

INSERT layoff_staging
SELECT * FROM layoffs;

select * from layoff_staging;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary 

SELECT company, location, total_laid_off, date, percentage_laid_off, industry, source, stage, funds_raised, country,
       COUNT(*) AS count
FROM layoff_staging
GROUP BY company, location, total_laid_off, date, percentage_laid_off, industry, source, stage, funds_raised, country
HAVING COUNT(*) > 1;

UPDATE layoff_staging
SET company = TRIM(company);

SELECT distinct industry from layoff_staging;
SELECT distinct country from layoff_staging;

select date, str_to_date(date,'%m/%d/%Y') from layoff_staging;

UPDATE layoff_staging
SET date = STR_TO_DATE (date,'%m/%d/%Y');

ALTER TABLE layoff_staging
modify column date DATE;

SELECT * from layoff_staging where total_laid_off is NULL AND  percentage_laid_off is NULL;

SELECT * from layoff_staging where industry is NULL
OR industry = '';

UPDATE layoff_staging
SET industry = NULL
WHERE industry = '';

UPDATE layoff_staging
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE layoff_staging
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

SELECT *
FROM layoff_staging
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

SELECT *
FROM layoff_staging
WHERE total_laid_off IS NULL;

SELECT *
FROM layoff_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoff_staging
MODIFY COLUMN total_laid_off INT;

DELETE FROM layoff_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoff_staging
SET percentage_laid_off = REPLACE(percentage_laid_off, '%', '');

ALTER TABLE layoff_staging
MODIFY percentage_laid_off DECIMAL(5,2);
 
SELECT * 
FROM layoff_staging;

-- EDA

-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers

SELECT MAX(CAST(percentage_laid_off AS UNSIGNED)) FROM layoff_staging;

SELECT MIN(total_laid_off) FROM layoff_staging;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoff_staging
WHERE  percentage_laid_off IS NOT NULL;

-- Which companies had 100 which is basically 100 percent of the company laid off

SELECT * FROM layoff_staging WHERE percentage_laid_off = 100;

-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT * FROM layoff_staging WHERE percentage_laid_off = 100 ORDER BY funds_raised DESC;

-- Companies with the most Total Layoffs
SELECT company, sum(total_laid_off) FROM layoff_staging GROUP BY company order by 2 DESC LIMIT 10;

SELECt min(date), max(date) FROM layoff_staging;

SELECT industry, sum(total_laid_off) FROM layoff_staging GROUP BY industry order by 2 DESC;

-- by location
SELECT location, SUM(total_laid_off)
FROM layoff_staging
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- this it total in the past 5 years or in the dataset
SELECT country, sum(total_laid_off) FROM layoff_staging GROUP BY country order by 2 DESC;

SELECT year(date), sum(total_laid_off) FROM layoff_staging GROUP BY year(date) order by 1 DESC;

SELECT stage, sum(total_laid_off) FROM layoff_staging GROUP BY stage order by 1 DESC;

SELECT * FROM layoff_staging;

SELECT substring(date,1,7) as month , SUM(total_laid_off) FROM layoff_staging
WHERE substring(date,1,7) IS NOT NULL
GROUP BY month ORDER BY month;

-- Rolling Total of Layoffs Per Month

WITH CTE AS(
SELECT substring(date,1,7) as month , SUM(total_laid_off) as total_off FROM layoff_staging
WHERE substring(date,1,7) IS NOT NULL
GROUP BY month ORDER BY month)
SELECT month, total_off, SUM(total_off) over (order by month) as rolling_total FROM CTE;


-- Now let's look at that per year.
SELECT company, sum(total_laid_off) FROM layoff_staging GROUP BY company order by 2 DESC;

SELECT company, year(date), sum(total_laid_off) FROM layoff_staging GROUP BY company, year(date) order by 3 DESC ;

WITH company_year (Company, Years, Total_laid_off) as(
SELECT company, year(date), sum(total_laid_off) 
FROM layoff_staging 
GROUP BY company, year(date)
), Company_Year_Rank as (
SELECT *, DENSE_RANK() OVER (PARTITION BY Years order by Total_laid_off DESC) as Ranks FROM company_year
WHERE Years IS NOT NULL ) 

SELECT * FROM Company_Year_Rank WHERE Ranks <= 5;

-- TOP 5 companies in each year That laid off from 2020 - 2025
