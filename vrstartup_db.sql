/* Write a query for each employee. Provide their name, personality, the names of any projects they’ve chosen, and the number of incompatible co-workers */
SELECT last_name, first_name, personality, project_name,
CASE 
   WHEN personality = 'INFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
   WHEN personality = 'ISFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ'))
   -- ... etc.
   ELSE 0
END AS 'IMCOMPATS'
FROM employees
LEFT JOIN projects on employees.current_project = projects.project_id;

/* Write a query for the names of those employees, the personality type, and the names of the project they’ve chosen */
SELECT last_name, first_name, personality, project_name
FROM employees
INNER JOIN projects
ON employees.current_project = projects.project_id
WHERE personality = (
SELECT personality
FROM employees
WHERE current_project IS NOT NULL
GROUP BY personality
ORDER BY COUNT(personality) DESC
LIMIT 1);

/* Wrtie a query for the projects chosen by Employees with INTJ(most common trait amongst employees) personality trait */

SELECT project_name AS 'Projects Chosen by Employees with the most Common Personality Trait'
FROM projects
INNER JOIN employees
ON projects.project_id = employees.current_project
WHERE personality = (
SELECT personality
FROM employees
GROUP BY personality
ORDER BY COUNT(personality) DESC
LIMIT 1);
  


/* Write a query for which personality is most common */
SELECT personality AS 'Most Common Personality Trait Amongst Employees'
FROM employees
GROUP BY personality
ORDER BY COUNT(personality)
LIMIT 1;

/* Write a query to determine how many available positions are available for all the projects and determine if there are enough employees to fill those spots  */
SELECT COUNT(first_name) AS 'Number of Employees who need Projects'
FROM employees
WHERE current_project IS NULL;

SELECT (COUNT(*) * 2) - (
  SELECT COUNT(*)
  FROM employees
  WHERE current_project IS NOT NULL
  AND position = 'Developer')
  AS 'Number of Open Spots on Projects'
  FROM projects;

/* Write a query for projects chosen by mulitiple employees  */
SELECT project_name AS 'Project Chosen by Multiple Employees'
FROM projects
INNER JOIN employees
ON projects.project_id = employees.current_project
WHERE current_project is NOT NULL
GROUP BY current_project
HAVING COUNT(current_project) > 1;


/* Write a query for the name of the project chosen by the most employees  */
SELECT project_name AS 'Project Chosen the Most'
FROM projects
INNER JOIN employees
ON projects.project_id = employees.current_project
WHERE current_project is NOT NULL
GROUP BY project_name
ORDER BY COUNT(employee_id) DESC
LIMIT 1;



/*  Write a query of the names of the projects that were not chosen by any employee */
SELECT project_name AS 'Projects not Chosen'
FROM projects
WHERE project_id
NOT IN (
  SELECT current_project
  FROM employees
  WHERE current_project IS NOT NULL
);


/*  Write a query to determine who hasn't chosen a project yet' */
SELECT first_name, last_name
FROM employees
WHERE current_project IS NULL;

/* Write a query to see what is in the 2 tables and if there is way to join them.  */
SELECT *
FROM employees;

SELECT *
FROM projects;

