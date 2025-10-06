-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoffs_staging2;

-- Look mostly at total_laid_off, as percentage_laid_off doesnt say much as no total no of employees.
-- couldn't you work out the total no of staff if you calculated from total laid off.

SELECT MAX(total_laid_off)
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- 1 = 100% (companies that went totally under) ordered by most laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- looking at companies that collapsed that had ALOT of funding
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- total no of employees each company has let go enccompassing the full date span of the table
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Earliest and latest date in the table (note spans first 3 years of covid pandemic).
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- what industry had the most layoffs throughout covid
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- which countries had the most layoffs throughout covid
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- which date did most layoffs occur (individual date)
SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;

-- which YEAR did most layoffs occur 
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- By Staging of the company
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

-- Rolling Sum - looking at the progression of layoff
-- date column starting at position 6 and taking 2 values
SELECT SUBSTRING(`date`,6,2) AS MONTH,  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `Month` # this combines all januarys etc. - not good practice
;

-- Rolling sum on month and year
SELECT SUBSTRING(`date`,1,7) AS MONTH, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month` # this combines all januarys etc.
ORDER BY 1 ASC
;

-- Includes monthly total and rolling total (cumulative total)
-- Adds current month to prior months rolling total. Shows progression.
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` # this combines all januarys etc.
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- How much companies were laying off per year
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
;

WITH Company_Year (company, `year`, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER (PARTITION BY `year` ORDER BY total_laid_off DESC) AS company_rank
FROM Company_Year
WHERE `year` IS NOT NULL
ORDER BY company_rank ASC;

-- Rank by top 5 countries each year
WITH Company_Year (company, `year`, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY `year` ORDER BY total_laid_off DESC) AS company_rank
FROM Company_Year
WHERE `year` IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE company_rank <= 5
;