# Data Jobs SQL Project


## Introduction
This project uses SQL queries to extract insights from thousands of real-world job postings, with a special emphasis on the differences between working remotely and on-site.
This project explores the data analyst job market using the [dataset](https://sql.lukebarousse.com/#/d/jobs) by Luke Barousse. 

SQL queries are used to extract insights from thousands of real-world job postings, evaluating salary trends, skill demands, and optimal career choices. The analysis places a special emphasis on the differences between working remotely and on-site.


Check out [sql_project_files](/sql_project_files/) for SQL queries!

## Background
The analysis tackles several foundational questions for job seekers and data professionals, such as:
* Is there a salary difference between remote and non-remote data analyst job postings?
* Do remote and non-remote roles demand the same technical skill sets?
* What are the highest-paying data analyst jobs overall, and specifically for remote positions?
* What are the most sought-after skills for remote versus non-remote roles, including within top-paying positions?
* Which specific technical skills drive the highest average salaries and represent the most optimal choices for career growth?

## Tools 
* **SQL**: The core language used for querying, data extraction, filtering, conditional aggregation, and CTEs.
* **PostgreSQL**: The database management system used to host and interact with the dataset.
* **VS Code**: The code editor utilized for writing and executing queries.
* **Excel**: Utilized alongside CSV exports for frequency counting (`COUNTIF`) and analysis (pivot tables).
* **Git & GitHub**: Version control and repository hosting.

## Analysis & Key Findings

### 1. Top-Paying Data Analyst Jobs (Remote vs. Non-Remote)
The project begins by identifying the highest-paying Data Analyst opportunities overall, and then isolates those that offer remote flexibility (`job_location = 'Anywhere'`). 

### 2. Salary Comparison
A single conditional aggregation query was used to evaluate the average yearly salary difference between remote and non-remote postings:
* There is **no significant difference** between remote and non-remote roles, with remote salaries being marginally higher (**$94,770** vs. **$93,622**).

### 3. Most In-Demand Skills
By joining job postings with skill dimensions, we track which skills appear most frequently for both environments:
* **Python** and **SQL** are the most in-demand skills by a wide margin across *both* remote and traditional jobs.

### 4. Skills for Top-Paying Roles
Using CTEs and string aggregation (`STRING_AGG`), the project investigates the skills tied directly to the top 10 highest-paying roles:
* **Non-Remote Top Paying:** Analysis via Excel/CSV exports revealed high concentrations of SQL, Excel, and Tableau.
* **Remote Top Paying:** Showed very similar results, with SQL maintaining a massive lead over other competencies.

### 5. Top-Paying and Optimal Skills
By grouping and filtering for skills with a high frequency of postings (greater than 100 posts to ensure reliability):
* **Top-Paying Skills:** Big data and processing tools like **Spark, Databricks, and Hadoop** command the highest average salaries.
* **Optimal Skills:** Combining high demand with high pay indicates that enterprise cloud platforms like **Azure and AWS** lead the top volume tiers.


## Conclusions
1. **Flexibility Without Pay Cuts:** Data analysts do not need to sacrifice salary for location flexibility; remote and non-remote positions offer virtually identical average compensation.
2. **Core Tech Remains Universal:** Regardless of location or pay tier, SQL and Python remain most sought-after skills for data analysts.
3. **Top-Paying Priorities:** While general demand favors Python, top-paying roles are heavily dominated by SQL, Excel, and Tableau.
4. **High-Value Specialization:** While SQL and Python can get you hired, mastery of big data frameworks (Spark, Hadoop) and cloud platforms (Azure, AWS) unlocks peak earning potential.


