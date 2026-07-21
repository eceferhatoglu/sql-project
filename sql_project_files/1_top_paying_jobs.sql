/* 
Question: What are the top-paying data analyst jobs?
- Restrict to 'Data Analyst' titles and exclude postings with missing salary data.
- Order by salary to highlight the highest-paying opportunities.
*/

SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    name AS company_name,
    salary_year_avg
FROM 
    job_postings_fact j
LEFT JOIN 
    company_dim c ON j.company_id = c.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10


/* 
Question: What are the top-paying data analyst jobs that are also remote?
- Filtering exclusively for remote ('Anywhere') locations.
*/

SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    name AS company_name,
    salary_year_avg
FROM 
    job_postings_fact j
LEFT JOIN 
    company_dim c ON j.company_id = c.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY 
    salary_year_avg DESC
LIMIT 10


/* 
Question: What is the average yearly salary difference between remote ('Anywhere') and non-remote Data Analyst job postings?
- Using conditional aggregation (CASE statements) inside the AVG function to calculate separate averages for remote and non-remote locations in a single query.
*/

SELECT 
    AVG(CASE WHEN job_location = 'Anywhere' THEN salary_year_avg END) AS remote,
    AVG(CASE WHEN job_location != 'Anywhere' THEN salary_year_avg END) AS non_remote
FROM 
    job_postings_fact 
WHERE
    job_title_short = 'Data Analyst';

--No significant difference between remote and non-remote roles, with remote salaries being slightly higher (94,770 vs. 93,622).