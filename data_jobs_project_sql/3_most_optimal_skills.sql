/* 
Question: What are the top-paying skills for Data Analyst roles?
- Calculating the average yearly salary for each skill, to identify which technical skills are associated with the highest compensation.
- Focus on skills with a high frequency of postings to ensure meaningful salary averages.
*/

SELECT 
    s.skills,
    CEIL(AVG(j.salary_year_avg)) salary_average,
    COUNT(j.job_id) post_count
FROM 
    job_postings_fact j
INNER JOIN 
    skills_job_dim sj ON j.job_id = sj.job_id
INNER JOIN 
    skills_dim s ON sj.skill_id = s.skill_id
WHERE
    j.job_title_short = 'Data Analyst' AND
    j.salary_year_avg IS NOT NULL
GROUP BY
    s.skills
HAVING
    COUNT(j.job_id) > 100
ORDER BY
    salary_average DESC
LIMIT 30

--Big data and processing tools like Spark, Databricks, and Hadoop command the highest average salaries.


/* 
Question: What are the most optimal skills to learn for Data Analyst roles?
- Combining high demand (post count) and high pay (average salary) to identify the best skills to focus on.
- Bucketing salaries: Rounding to the nearest 10,000.
- Again filter for skills that appear frequently to ensure the data is reliable.
*/

SELECT 
    s.skills,
    ROUND(AVG(j.salary_year_avg), -4) salary_average,
    COUNT(j.job_id) post_count
FROM 
    job_postings_fact j
INNER JOIN 
    skills_job_dim sj ON j.job_id = sj.job_id
INNER JOIN 
    skills_dim s ON sj.skill_id = s.skill_id
WHERE
    j.job_title_short = 'Data Analyst' AND
    j.salary_year_avg IS NOT NULL
GROUP BY
    s.skills
HAVING
    COUNT(j.job_id) > 100
ORDER BY
    salary_average DESC,
    post_count DESC
LIMIT 30

--Enterprise cloud platforms like Azure and AWS lead the top volume tiers.