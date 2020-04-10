
-- Challange.sql
-- Number of [titles] Retiring
-- Create a new table using an INNER JOIN that contains the following information:
Select e.emp_no,
e.first_name, 
e.last_name,
tl.title, 
s.salary, 
s.from_date
INTO emp_salary_info
FROM employees AS e
INNER JOIN titles AS tl
ON (e.emp_no = tl.emp_no)
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no);

--  export done!!
-- 
-- Only the Most Recent Titles
-- In descending order (by date), list the frequency count of employee titles (i.e., how many employees share the same title?).
SELECT
  first_name,
  last_name,
	from_date,
count(*)
FROM emp_salary_info as esi
GROUP BY
  first_name,
  last_name,
  from_date
HAVING count(*) > 1
ORDER BY from_date DESC;


-- get count of duplicate names
SELECT
  first_name,
  last_name,
	from_date,
count(*)
INTO duplicate_names
FROM emp_salary_info as esi
GROUP BY
  first_name,
  last_name,
  from_date
HAVING count(*) > 1
ORDER BY from_date DESC;
-- 140270 duplicate entries

-- Display all duplicates
SELECT * FROM
  (SELECT *, count(*)
  OVER
    (PARTITION BY
      first_name,
      last_name
    ) AS count
  FROM emp_salary_info) tableWithCount
  WHERE tableWithCount.count > 1;
--   304966
-- export duplicate_names

-- select and gather all distincts
SELECT DISTINCT ON (first_name, last_name) * FROM emp_salary_info;

-- delete duplicates from the data
DELETE FROM emp_salary_info
WHERE emp_no IN
    (SELECT emp_no
    FROM 
        (SELECT emp_no,
         ROW_NUMBER() OVER( PARTITION BY (first_name, last_name)
        ORDER BY  emp_no ) AS row_num
        FROM emp_salary_info ) t
        WHERE t.row_num > 1 );

-- Who’s Ready for a Mentor?
-- get info about employees who are ready for mentors

SELECT e.emp_no,
 e.first_name,
e.last_name,
tl.title,
 tl.from_date,
 de.to_date,
e.birth_date
INTO mentor
FROM titles as tl
INNER JOIN employees as e
		ON (e.emp_no = tl.emp_no)
INNER JOIN dept_emp AS de
        ON (de.emp_no = tl.emp_no)
-- The birth date needs to be between January 1, 1965 and December 31, 1965.
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01');

-- export mentors.sql