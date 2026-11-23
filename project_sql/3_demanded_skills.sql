/*
Question: What are the most in-demand skills for Data Analysts?

Objective:
Identify the top 5 most frequently requested skills
for Data Analyst positions in London, UK.

Criteria:
- Focus on Data Analyst job titles.
- Include all available job postings.
- Filter for positions located in London, UK.
- Identify the five most frequently requested skills.

Why?
Identify the skills most frequently demanded by employers
in the London Data Analyst job market, helping job seekers
prioritise their learning and professional development.
*/


/*
Step 1: Connect job postings to their associated skills.

INNER JOIN skills_job_dim:
Links job postings to their associated skill IDs.

INNER JOIN skills_dim:
Retrieves the corresponding skill names.

This allows each job posting to be associated
with the skills requested by employers.
*/

SELECT
    skills_dim.skills,

    /*
    Step 2: Count how many job postings request each skill.

    COUNT(job_id) calculates the number of job-skill
    associations for each skill.
    */

    COUNT(skills_job_dim.job_id) AS job_count

FROM job_postings_fact

INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id

/*
Step 3: Filter the dataset.

Only include:
- Data Analyst positions.
- Job postings located in London, UK.
*/

WHERE job_title_short = 'Data Analyst'
    AND job_location = 'London, UK'

/*
Step 4: Group results by skill.

This combines job postings requesting the same skill,
allowing demand to be measured across the dataset.
*/

GROUP BY skills_dim.skills

/*
Step 5: Rank skills by demand.

ORDER BY:
Displays the most frequently requested skills first.

LIMIT 5:
Returns only the five most in-demand skills.
*/

ORDER BY job_count DESC
LIMIT 5;
