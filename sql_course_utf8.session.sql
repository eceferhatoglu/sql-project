SELECT * FROM job_postings_fact LIMIT 50;

SELECT EXTRACT(MONTH FROM job_posted_date) FROM job_postings_fact LIMIT 5;

-- query for finding the avg yearly and hourly salary for posts after june 1. group by schedule type.

SELECT 
    job_schedule_type, AVG(salary_hour_avg) hourly_avg, AVG(salary_year_avg) yearly_avg
FROM 
    job_postings_fact 
WHERE
    job_posted_date >= '2023-06-01'
GROUP BY    
    job_schedule_type
ORDER BY
    yearly_avg ASC;


--query to find companies that have posted jobs offering health insurance, 
--where these postings were made in the second quarter of 2023.

SELECT
    COUNT (DISTINCT name)
FROM 
    job_postings_fact j
LEFT JOIN
    company_dim c ON j.company_id = c.company_id
WHERE
    job_health_insurance = TRUE AND
    EXTRACT(MONTH FROM j.job_posted_date) IN (4,5,6);

--practice problem:
--create tables from other tables
--jan, feb, mar tables

CREATE TABLE january_jobs AS
SELECT *
FROM
    job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
SELECT *
FROM
    job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
SELECT *
FROM
    job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;


/* label new column as follows
anywhere jobs as remote,
new york, ny jobs as local
otherwise - onsite */

SELECT 
    COUNT(job_id),
    CASE 
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
    END AS location
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location;


SELECT * 
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = '1' 
) AS temp_jan;


--companies that are offering jobs that dont have requirement for degree

SELECT DISTINCT c.name
FROM job_postings_fact j
LEFT JOIN company_dim c
ON j.company_id = c.company_id
WHERE j.job_no_degree_mention = TRUE;


SELECT name
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention
);

--find the companies that have the most job openings

WITH temp_table AS (
SELECT company_id, COUNT(company_id) total_posts
FROM job_postings_fact
GROUP BY company_id)
SELECT c.name, t.total_posts
FROM temp_table t
JOIN company_dim c
ON t.company_id = c.company_id
ORDER BY t.total_posts DESC;



--identify the top 5 skills that are most mentioned. subquery to find
--the skills IDs with the highest counts in the skillsjobdim then join
--with skilldim table.


SELECT s.skill_id, s.skills, most_mentioned
FROM skills_dim s
JOIN
(SELECT skill_id, COUNT(skill_id) most_mentioned
FROM skills_job_dim
GROUP BY skill_id
ORDER BY most_mentioned DESC
LIMIT 5) j
ON j.skill_id = s.skill_id;


/* determine the size category (small,medium,large) for each company
by first indentifying the number of job postings they have.
small is less then 10, medium bw 10 and 50, large more than 50. */


SELECT *,
    CASE
        WHEN job_posts < 10 THEN 'Small'
        WHEN job_posts BETWEEN 10 AND 50 THEN 'Medium'
        WHEN job_posts > 50 THEN 'Large'
    END AS company_size
FROM (
    SELECT company_id, COUNT(*) job_posts
    FROM job_postings_fact
    GROUP BY company_id)
ORDER BY job_posts ASC;
 

/*find the count of the remote job postings per skill
-display the top 5 skills by their demand in remote data analyst jobs
-include skill ID, name and count of postings requiring the skill
*/


WITH top_remote_skills_ID AS (
    SELECT skill_id, COUNT(*) top_skills
    FROM job_postings_fact j
    JOIN skills_job_dim s
    ON j.job_id = s.job_id
    WHERE j.job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    GROUP BY skill_id
) 

SELECT s.skill_id, s.skills, top_skills post_count
FROM top_remote_skills_ID t
JOIN skills_dim s
ON s.skill_id = t.skill_id
ORDER BY top_skills DESC
LIMIT 5;



/*get the corresponding skill and skill type
for each job posting in q1.
includes those without any skills too.*/


WITH quarter AS (
SELECT *
FROM january_jobs

UNION ALL

SELECT * 
FROM february_jobs

UNION ALL 

SELECT *
FROM march_jobs)

SELECT count(sd.skills) skill_count, sd.skills, sd.type --q.salary_year_avg,q.job_title_short, s.skill_id
FROM quarter q

JOIN skills_job_dim s
ON q.job_id = s.job_id

JOIN skills_dim sd
ON sd.skill_id = s.skill_id 

WHERE q.salary_year_avg > 70000 AND q.job_title_short = 'Data Analyst'

GROUP BY sd.skills, sd.type

ORDER BY skill_count DESC


