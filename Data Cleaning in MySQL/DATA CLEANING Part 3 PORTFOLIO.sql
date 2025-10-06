-- NULL and BLANK VALUES

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL  # don't use = NULL
AND percentage_laid_off IS NULL;
-- Remove in step 4, removing rows and columns

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry #to see what this is doing SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2
SET industry = 'Travel'
WHERE industry = 'Airbnb';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'JEWEL';

SELECT *
FROM layoffs_staging2
WHERE company = 'Juul';

UPDATE layoffs_staging2
SET industry = 'Consumer'
WHERE industry = 'Juul';

SELECT *
FROM layoffs_staging2
WHERE company = 'Carvana';

UPDATE layoffs_staging2
SET industry = 'Transportation'
WHERE industry = 'Carvana';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';
