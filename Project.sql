select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select year(date), max(total_laid_off)
from layoffs_staging2
group by year(date)
order by 1 desc;


select substring(date,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(date,1,7) is not null
group by `Month`
order by 1 desc;

with rolling_total as(
select substring(date,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(date,1,7) is not null
group by `Month`
order by 1 desc
)

select `Month`, sum(total_off) over(order by `Month`) as rolling
from rolling_total;


select company, year(date), sum(total_laid_off)
from layoffs_staging2
group by company, year(date)
order by 3 desc;


with company_year(company,years,total_off) as(
select company, year(date), sum(total_laid_off)
from layoffs_staging2
group by company, year(date)
order by 3 desc
),company_year_rank as(
select *, dense_rank() over (partition by years order by total_off desc) as ranking
from company_year
where years is not null
order by ranking asc
)

select *
from company_year_rank
where ranking > 5;

