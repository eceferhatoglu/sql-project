/* 
Question: What are the most sought-after skills for data analyst roles that are non-remote?
- Inner join for skills, as we do not want jobs that list no skills.
*/

SELECT
    s.skills,
    COUNT(s.skills)
FROM
    skills_job_dim sj 
INNER JOIN 
    skills_dim s ON s.skill_id = sj.skill_id
INNER JOIN 
    job_postings_fact j ON j.job_id = sj.job_id
WHERE 
    job_title_short = 'Data Analyst' AND
    j.job_location != 'Anywhere'
GROUP BY skills
ORDER BY COUNT(skills) DESC
LIMIT 10


/* 
Question: What are the most sought-after skills data analyst roles that are remote?
*/

SELECT
    s.skills,
    COUNT(s.skills)
FROM
    skills_job_dim sj 
INNER JOIN 
    skills_dim s ON s.skill_id = sj.skill_id
INNER JOIN 
    job_postings_fact j ON j.job_id = sj.job_id
WHERE 
    job_title_short = 'Data Analyst' AND
    j.job_location = 'Anywhere'
GROUP BY skills
ORDER BY COUNT(skills) DESC
LIMIT 10

--Python and SQL are the most in-demand skills, by a wide margin, for both remote and traditional jobs.


/*Question: What are the most sought-after skills for top-paying Data analyst roles that are non-remote?
- Using the previous query of top-paying jobs as a CTE.
- Aggragate all associated skills of the job posts rather than duplicating rows for every single skill, ensuring no job posts are lost.
(So instead of getting the top 10 paying jobs overall, we get the top 10 paying jobs that also have their skills stated.)
*/

WITH jobs_table AS (
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
    job_location != 'Anywhere'
ORDER BY 
    salary_year_avg DESC
)

SELECT
    jt.*,
    STRING_AGG(s.skills, ', ') AS skills
FROM 
    jobs_table jt
INNER JOIN 
    skills_job_dim sj ON sj.job_id = jt.job_id
INNER JOIN 
    skills_dim s ON s.skill_id = sj.skill_id
GROUP BY
    jt.job_id,
    jt.job_title,
    jt.job_location,
    jt.job_schedule_type,
    jt.company_name,
    jt.salary_year_avg
LIMIT 10

-- After extracting the results as a CSV file and using COUNTIF on Excel: 9 SQL, 3 Excel and 3 Tableau.


/* 
Question: What are the most sought-after skills for top-paying Data analyst roles that are remote?
- To compare these to the results for traditional jobs.
*/

WITH jobs_table AS (
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
)

SELECT
    jt.*,
    STRING_AGG(s.skills, ', ') AS skills
FROM 
    jobs_table jt
INNER JOIN 
    skills_job_dim sj ON sj.job_id = jt.job_id
INNER JOIN 
    skills_dim s ON s.skill_id = sj.skill_id
GROUP BY
    jt.job_id,
    jt.job_title,
    jt.job_location,
    jt.job_schedule_type,
    jt.company_name,
    jt.salary_year_avg
LIMIT 10

-- 10 SQL, 5 Excel, 5 Tableau
-- Very similar results, with SQL maintaining a significant lead over other skills.