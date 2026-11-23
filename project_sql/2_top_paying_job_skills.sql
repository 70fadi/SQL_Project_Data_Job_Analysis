/*
Question: What skills are required for the top-paying Data Analyst jobs?

Objective:
Identify the skills required for the 10 highest-paying Data Analyst
positions in London, UK.

Criteria:
- Focus on Data Analyst positions.
- Only include jobs located in London, UK.
- Exclude job postings without a specified annual salary.
- Select the 10 highest-paying positions.
- Identify all skills associated with these positions.

Why?
Understand which skills are most frequently required for high-paying
Data Analyst positions, helping job seekers identify valuable skills
to develop and improve their competitiveness in the job market.
*/


WITH top_paying_jobs AS (

    /*
    Step 1: Identify the 10 highest-paying Data Analyst jobs.

    Retrieve:
    - Job ID.
    - Job title.
    - Average annual salary.
    - Company name.

    Join company_dim to retrieve company names.

    Filter for London-based Data Analyst positions
    with specified annual salaries.

    Order by salary in descending order and limit
    the results to the top 10 jobs.
    */

    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name

    FROM job_postings_fact

    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id

    WHERE job_title_short = 'Data Analyst'
        AND job_location = 'London, UK'
        AND salary_year_avg IS NOT NULL

    ORDER BY salary_year_avg DESC
    LIMIT 10

)

/*
Step 2: Identify the skills associated with the selected jobs.

INNER JOIN skills_job_dim:
Connects each job posting to its associated skill IDs.

INNER JOIN skills_dim:
Retrieves the corresponding skill names.

The result displays each of the top 10 jobs
alongside all its associated skills.

Results are ordered by annual salary in descending order.

Note:
No final LIMIT is applied because the objective is to retrieve
ALL skills associated with the 10 selected jobs, rather than
limiting the output to just 10 job-skill combinations.
*/

SELECT
    top_paying_jobs.*,
    skills_job_dim.skill_id,
    skills_dim.skills AS skill_name

FROM top_paying_jobs

INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id

ORDER BY salary_year_avg DESC;
