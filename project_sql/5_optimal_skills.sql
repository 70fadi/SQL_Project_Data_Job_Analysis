/*
Question: What are the most optimal skills to learn?

Objective:
Identify skills that combine high job demand with high
average annual salaries for Data Analyst positions.

Criteria:
- Focus on Data Analyst job titles.
- Include remote positions only.
- Exclude job postings without specified annual salaries.
- Identify skills appearing in more than 10 job postings.
- Calculate average annual salary for each skill.
- Rank skills by average salary and demand.

Why?
Identify skills that offer a combination of strong market demand
and higher earning potential, helping job seekers prioritise
their learning and career development.
*/


/*
Step 1: Calculate skill demand.

Identify how frequently each skill appears across
remote Data Analyst job postings with specified salaries.

Metrics:
- Skill ID: Unique identifier for each skill.
- Skill Name: Name of the required skill.
- Demand Count: Number of distinct job postings
  associated with each skill.
*/

WITH skills_demand AS (

    SELECT
        skills_dim.skill_id,
        skills_dim.skills,

        COUNT(DISTINCT skills_job_dim.job_id) AS demand_count

    FROM job_postings_fact

    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id

    INNER JOIN skills_dim
        ON skills_dim.skill_id = skills_job_dim.skill_id

    WHERE job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL

    GROUP BY
        skills_dim.skill_id,
        skills_dim.skills

),

/*
Step 2: Calculate the average salary associated with each skill.

AVG calculates the average annual salary across
remote Data Analyst job postings requiring each skill.

ROUND(..., 0) rounds the average salary
to the nearest whole number.

Only positions with specified annual salaries
are included in the calculation.
*/

average_salary AS (

    SELECT
        skills_job_dim.skill_id,

        ROUND(AVG(salary_year_avg), 0) AS avg_salary

    FROM job_postings_fact

    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id

    INNER JOIN skills_dim
        ON skills_dim.skill_id = skills_job_dim.skill_id

    WHERE job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL

    GROUP BY
        skills_job_dim.skill_id

)

/*
Step 3: Combine skill demand and average salary.

INNER JOIN connects both CTEs using skill_id,
allowing demand and salary metrics to be analysed together.

Filter:
- Only include skills appearing in more than 10 job postings.

Ranking:
- Highest average salary first.
- Highest job demand as a secondary ranking criterion.

LIMIT 25 returns the top 25 skills.
*/

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary

FROM skills_demand

INNER JOIN average_salary
    ON skills_demand.skill_id = average_salary.skill_id

WHERE demand_count > 10

ORDER BY
    average_salary DESC,
    demand_count DESC

LIMIT 25;
