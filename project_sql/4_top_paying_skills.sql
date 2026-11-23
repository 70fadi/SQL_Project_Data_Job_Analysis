/*
Question: What are the top skills based on salary?

Objective:
Identify the 25 highest-paying skills associated with
Data Analyst positions in London, UK.

Criteria:
- Focus on Data Analyst job titles.
- Include only positions with specified annual salaries.
- Filter for jobs located in London, UK.
- Calculate the average annual salary associated with each skill.
- Rank skills by average salary in descending order.

Why?
Understand which skills are associated with higher-paying
Data Analyst opportunities, helping job seekers identify
potentially valuable skills to develop and improve their
earning potential.
*/


/*
Step 1: Connect job postings to their associated skills.

INNER JOIN skills_job_dim:
Connects each job posting to its associated skill IDs.

INNER JOIN skills_dim:
Retrieves the corresponding skill names.

This allows salaries to be analysed against
the skills requested by employers.
*/

SELECT
    skills_dim.skills,

    /*
    Step 2: Calculate the average annual salary for each skill.

    AVG calculates the mean annual salary across
    job postings associated with each skill.

    ROUND(..., 2) limits the result to two decimal places.
    */

    ROUND(AVG(salary_year_avg), 2) AS avg_salary

FROM job_postings_fact

INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id

/*
Step 3: Apply filtering criteria.

Only include:
- Data Analyst positions.
- Jobs located in London, UK.
- Job postings with a specified annual salary.

NULL salary values are excluded because they cannot
contribute to a meaningful average salary calculation.
*/

WHERE job_title_short = 'Data Analyst'
    AND job_location = 'London, UK'
    AND salary_year_avg IS NOT NULL

/*
Step 4: Group results by skill.

Each skill receives its own average salary calculation,
allowing salary comparisons across different skills.
*/

GROUP BY skills_dim.skills

/*
Step 5: Rank skills by average annual salary.

ORDER BY:
Displays the highest average salaries first.

LIMIT 25:
Returns the 25 highest-paying skills.
*/

ORDER BY avg_salary DESC
LIMIT 25;
