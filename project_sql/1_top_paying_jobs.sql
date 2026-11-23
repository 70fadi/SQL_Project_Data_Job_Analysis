/*
Question: What are the top-paying Data Analyst jobs?

Objective:
Identify the 10 highest-paying Data Analyst positions
located in London, UK.

Criteria:
- Only include Data Analyst job titles.
- Focus on positions located in London, UK.
- Exclude job postings without a specified annual salary.
- Include company names for each job posting.

Why?
Highlight the highest-paying opportunities for Data Analysts
and provide insight into salary expectations and employment options.
*/


/*
Step 1: Select relevant job posting information.

Fields include:
- Job ID and title.
- Job location and employment type.
- Average annual salary.
- Job posting date.
- Company name.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::date,
    name AS company_name

FROM job_postings_fact

/*
Step 2: Join company information.

LEFT JOIN connects job postings with company details
using company_id, allowing company names to be included.
*/

LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id

/*
Step 3: Apply filtering criteria.

Only include:
- Data Analyst positions.
- Jobs located in London, UK.
- Job postings with a specified annual salary.
*/

WHERE job_title_short = 'Data Analyst'
    AND job_location = 'London, UK'
    AND salary_year_avg IS NOT NULL

/*
Step 4: Rank job opportunities by annual salary.

Highest-paying positions appear first.
LIMIT restricts the output to the top 10 results.
*/

ORDER BY salary_year_avg DESC
LIMIT 10;
