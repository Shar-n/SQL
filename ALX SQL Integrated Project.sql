USE md_water_services;

-- List of tables in the databse
SHOW TABLES;

-- A view of the location table 
SELECT * FROM location
LIMIT 5;

-- A view of the visits table
SELECT * FROM visits
LIMIT 5;

-- A view of the water source table
SELECT * FROM water_source
LIMIT 5;

-- A view of data_dictionary
SELECT * FROM data_dictionary;

-- Unique types of water sources
SELECT DISTINCT type_of_water_source
FROM water_source;

-- visits to water sources
SELECT * FROM visits
WHERE time_in_queue > 500;

-- Type of water cources that have to queue for long
SELECT * FROM water_source
Where source_id IN ("AkKi00881224", "AkLu01628224", "AkRu05234224", "HaRu19601224", "HaZa21742224", "SoRu37635224", "SoRu36096224",  "SoRu38776224");

/*records where the subject_quality_score is 10 -- only looking for home taps -- and where the source
was visited a second time.*/
SELECT * FROM water_quality
WHERE subjective_quality_score = 10 AND visit_count = 2;

/*Did you notice that we recorded contamination/pollution data for all of the well sources?
Find the right table and print the first few rows.*/
SELECT * FROM well_pollution
LIMIT 5;

-- So, write a query that checks if the results is Clean but the biological column is > 0.01.
SELECT * FROM well_pollution
WHERE results ="clean" AND biological > 0.01;

/*To find these descriptions, search for the word Clean with additional characters after it.
As this is what separates incorrect descriptions from the records that should have "Clean".*/
SELECT * FROM well_pollution
WHERE description like "clean%" AND biological > 0.01;

-- Copy table before updating
CREATE TABLE md_water_services.well_pollution_copy AS (
SELECT * FROM md_water_services.well_pollution
);

/*
Case 1a: Update descriptions that mistakenly mention
`Clean Bacteria: E. coli` to `Bacteria: E. coli`
*/
SET SQL_SAFE_UPDATES = 0;
UPDATE well_pollution_copy 
SET description = 'Bacteria: E. coli'
WHERE description ="Clean Bacteria: E. coli";

/*
Case 1b: Update the descriptions that mistakenly mention
`Clean Bacteria: Giardia Lamblia` to `Bacteria: Giardia Lamblia
*/
UPDATE well_pollution_copy 
SET description = 'Bacteria: Giardia Lamblia'
WHERE description ="Clean Bacteria: Giardia Lamblia";

/*
Case 2: Update the `result` to `Contaminated: Biological` where
`biological` is greater than 0.01 plus current results is `Clean`
*/
UPDATE well_pollution_copy
SET results = 'Contaminated: Biological'
WHERE biological > 0.01 AND results = "Clean";

-- Test query to see if our updating is correct
SELECT * FROM well_pollution_copy
WHERE description like "clean%" AND biological > 0.01;

-- Still testing
SELECT * FROM well_pollution_copy
WHERE description LIKE "Clean_%" OR (results = "Clean" AND biological > 0.01);

-- The real thing
-- Case 1a
UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE description = "Clean Bacteria: E. coli";

-- Case 1b
UPDATE well_pollution
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = "Clean Bacteria: Giardia Lamblia";

-- Case 2
UPDATE well_pollution
SET results = 'Contaminated: Biological'
WHERE biological > 0.01 AND results = "Clean";

-- Delete well polution copy
DROP TABLE md_water_services.well_pollution_copy;

SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;

SELECT *  FROM well_pollution
WHERE description
IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);

-- MCQ 1 Q3
SELECT MAX(number_of_people_served)
FROM water_source;

SELECT *
FROM water_source
WHERE number_of_people_served = 3998;

SELECT *
FROM water_source
WHERE number_of_people_served > 3997;

or sort the list to find the top record:

SELECT *
FROM water_source
ORDER BY number_of_people_served DESC;

-- MCQ 1 Q1: What is the address of Bello Azibo?
SELECT address
FROM employee
WHERE employee_name = "Bello Azibo";

-- MCQ 1 Q2: What is the name and phone number of our Microbiologist?
SELECT employee_name, phone_number
FROM employee
WHERE position = "Micro Biologist";

-- MCQ 1 Q3: What is the source_id of the water source shared by the most number of people?
SELECT *
FROM water_source
ORDER BY number_of_people_served DESC;

-- MCQ 1 Q4: What is the population of Maji Ndogo? 
SELECT *
FROM data_dictionary WHERE description LIKE "%population%";

SELECT * 
FROM global_water_access 
WHERE name = "Maji Ndogo";

-- MCQ 1 Q5: Which SQL query returns records of employees who are Civil Engineers residing in Dahabu or living on an avenue?
SELECT *
FROM employee
WHERE position = 'Civil Engineer' AND (province_name = 'Dahabu' OR address LIKE '%Avenue%');

-- MCQ 1 Q6: Create a query to identify potentially suspicious field workers based on an anonymous tip. This is the description we are given:
-- The employee’s phone number contained the digits 86 or 11. 
-- The employee’s last name started with either an A or an M. 
-- The employee was a Field Surveyor.
SELECT *
FROM Employee e
WHERE (e.employee_name LIKE '%A%' OR e.employee_name LIKE '%M%')
  AND (e.phone_number LIKE '%86%' OR e.phone_number LIKE '%11%')
  AND position = "Field Surveyor";

-- MCQ 1 Q7: What is the result of the following query? Choose the most appropriate description of the results set.
SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;

--  Answer: 4916 records are returned. This query describes the pollution samples that had an insignificant amount of biological contamination.

-- MCQ 1 Q8: Which query will identify the records with a quality score of 10, visited more than once?
SELECT * 
FROM water_quality
WHERE visit_count >= 2 AND subjective_quality_score = 10

-- MCQ 1 Q9: You have been given a task to correct the phone number for the employee named 'Bello Azibo'.
	-- The correct number is +99643864786.
	-- Write the SQL query to accomplish this.
UPDATE employee
SET phone_number = '+99643864786'
WHERE employee_name = 'Bello Azibo';

--MCQ 1 Q10: How many rows of data are returned for the following query?
SELECT * 
FROM well_pollution
WHERE description
IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);
--Answer: 570 

-- Part 2
SELECT * FROM employee;

-- Create email address
SELECT
CONCAT(LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov') AS new_email
FROM employee;

-- Update to the real column
UPDATE employee
SET email = CONCAT(LOWER(REPLACE(employee_name, ' ', '.')),'@ndogowater.gov');

-- Phone number character
SELECT LENGTH(phone_number) FROM employee;
SELECT LENGTH(TRIM(phone_number)) FROM employee;

-- Update phone number
UPDATE employee
SET phone_number = TRIM(phone_number);

-- Employee count
SELECT town_name,
COUNT(town_name) AS no_of_employees
FROM employee
GROUP BY town_name;

-- Employee with most number of visits
SELECT assigned_employee_id,
SUM(visit_count) AS no_of_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY no_of_visits desc
LIMIT 3;

-- Highest employee visits details
SELECT employee_name, phone_number, email FROM employee
Where assigned_employee_id IN (1, 30, 34);

-- Count records per town in location table
SELECT town_name,
COUNT(town_name) AS records_per_town
FROM location
GROUP BY town_name
ORDER BY records_per_town desc;

-- Count records per province in location table
SELECT province_name,
COUNT(province_name) AS records_per_province
FROM location
GROUP BY province_name
ORDER BY records_per_province desc;

-- Together
SELECT town_name, province_name,
COUNT(town_name) AS records_per_town
FROM location
GROUP BY town_name, province_name
ORDER BY records_per_town desc;

-- Together by province name
SELECT province_name, town_name,
COUNT(town_name) AS records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name, records_per_town desc;

-- Investigating location
SELECT location_type,
COUNT(location_type) AS num_sources
FROM location
GROUP BY location_type;

-- Percentage of rural location
SELECT 23740 / (15910 + 23740) * 100 AS rural_percentage;

-- How many people did we survey in total?
SELECT SUM(number_of_people_served) AS total_no_of_people_surveyed
FROM water_source;

-- How many wells, taps and rivers are there?
SELECT type_of_water_source,
COUNT(type_of_water_source) AS num_of_sources
FROM water_source
GROUP BY type_of_water_source;

-- How many people share particular types of water sources on average?
SELECT type_of_water_source,
ROUND(AVG(number_of_people_served)) AS avg_people_per_source
FROM water_source
GROUP BY type_of_water_source;

-- How many people are getting water from each type of source?
SELECT type_of_water_source,
SUM(number_of_people_served) AS pop_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY pop_served desc;

-- Percentage from each source
SELECT type_of_water_source,
ROUND(SUM(number_of_people_served)/27628401 * 100) AS percentage_of_pop_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY percentage_of_pop_served desc;

-- Rank
SELECT type_of_water_source,
SUM(number_of_people_served) AS pop_served,
RANK() OVER (ORDER BY SUM(number_of_people_served) desc) AS rank_by_pop
FROM water_source
GROUP BY type_of_water_source;

-- Rank without tap in home
SELECT type_of_water_source,
SUM(number_of_people_served) AS pop_served,
RANK() OVER (ORDER BY SUM(number_of_people_served) desc) AS rank_by_pop
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY type_of_water_source;

-- Priority rank
SELECT source_id, type_of_water_source,
SUM(number_of_people_served) AS pop_served,
RANK() OVER (
	ORDER BY SUM(number_of_people_served) desc, 
    type_of_water_source) AS priority_rank
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY source_id, type_of_water_source;

-- Correct priority rank
SELECT source_id, type_of_water_source,
SUM(number_of_people_served) AS pop_served,
RANK() OVER (PARTITION BY type_of_water_source	ORDER BY SUM(number_of_people_served) desc, 
    type_of_water_source) AS priority_rank
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY source_id, type_of_water_source;

-- Correct priority using dense rank
SELECT source_id, type_of_water_source,
SUM(number_of_people_served) AS pop_served,
DENSE_RANK() OVER (PARTITION BY type_of_water_source	ORDER BY SUM(number_of_people_served) desc, 
    type_of_water_source) AS priority_rank
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY source_id, type_of_water_source;

-- Correct priority using row number
SELECT source_id, type_of_water_source,
SUM(number_of_people_served) AS pop_served,
ROW_NUMBER() OVER (PARTITION BY type_of_water_source	ORDER BY SUM(number_of_people_served) desc, 
    type_of_water_source) AS priority_rank
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY source_id, type_of_water_source;

-- Analysing queues
-- 1. How long did the survey take?
SELECT *,
DAY(time_of_record) AS day,
MONTH(time_of_record) AS month,
YEAR(time_of_record) AS year
FROM visits;

SELECT MIN(time_of_record), MAX(time_of_record)
FROM visits;

SELECT DATEDIFF(MAX(time_of_record), MIN(time_of_record)) AS length_of_survey_in_days
FROM visits;

-- 2. What is the average total queue time for water?
SELECT
AVG(NULLIF(time_in_queue, 0))
FROM visits;

-- 3. What is the average queue time on different days? Basicaly day of the week ppl collect water the most
SELECT
DAYNAME(time_of_record) AS day_of_the_week,
ROUND(AVG(NULLIF(time_in_queue, 0))) AS avg_queue_time
FROM visits
GROUP BY day_of_the_week;

-- 4. How can we communicate this information efficiently?
-- Time of day people collect water
SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00')AS hour_of_the_day,
ROUND(AVG(NULLIF(time_in_queue, 0))) AS avg_queue_time
FROM visits
GROUP BY hour_of_the_day
ORDER BY hour_of_the_day asc;

-- Pivot table for queue time on Sunday by the hour of the day
SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	DAYNAME(time_of_record),
	CASE
		WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
		ELSE NULL
	END AS Sunday
FROM visits
WHERE time_in_queue != 0; -- this exludes other sources with 0 queue times.

-- Pivot table for all the days of the week
SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Sunday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Monday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Tuesday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Wednesday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Thursday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Friday,
    ROUND(AVG(CASE
                WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
                ELSE NULL
            END),
            0) AS Saturday
FROM visits
WHERE time_in_queue != 0
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- MCQ 2 Q1: Which SQL query will produce the date format "DD Month YYYY" from the time_of_record column in the visits table, as a single column?
-- Note: Monthname() acts in a similar way to DAYNAME().
SELECT CONCAT(day(time_of_record), " ", monthname(time_of_record), " ", year(time_of_record)) FROM visits;

-- Q3: What are the names of the two worst-performing employees who visited the fewest sites, and how many sites did the worst-performing employee visit? 
-- Modify your queries from the “Honouring the workers” section.
SELECT assigned_employee_id, COUNT(visit_count) AS NO
FROM visits
GROUP BY assigned_employee_id
ORDER BY no ASC
LIMIT 2;

-- Q4: What does the following query do?
SELECT 
    location_id,
    time_in_queue,
    AVG(time_in_queue) OVER (PARTITION BY location_id ORDER BY visit_count) AS total_avg_queue_time
FROM 
    visits
WHERE 
visit_count > 1 -- Only shared taps were visited > 1
ORDER BY 
    location_id, time_of_record;
-- Answer: It computes an average queue time for shared taps visited more than once, which is updated each time a source is visited.

-- Q5: One of our employees, Farai Nia, lives at 33 Angelique Kidjo Avenue. What would be the result if we TRIM() her address?
SELECT TRIM('33 Angelique Kidjo Avenue  ');
--Answer: ‘33 Angelique Kidjo Avenue’

-- Q6: How many employees live in Dahabu?
SELECT COUNT(town_name)
FROM employee
WHERE town_name = "Dahabu";

-- Q7: How many employees live in Harare, Kilimani?
SELECT COUNT(town_name)
FROM employee
WHERE town_name = "Harare" AND province_name = "Kilimani";

-- Q8: How many people share a well on average?

-- Q9: Consider the query we used to calculate the total number of people served:
SELECT
SUM(number_of_people_served) AS population_served
FROM water_source
WHERE type_of_water_source LIKE "%tap%"
ORDER BY population_served;
-- Which of the following lines of code will calculate the total number of people using some sort of tap?
--Answer: WHERE type_of_water_source LIKE "%tap%"


-- Part3
DROP TABLE IF EXISTS `auditor_report`;
CREATE TABLE `auditor_report` (
`location_id` VARCHAR(32),
`type_of_water_source` VARCHAR(64),
`true_water_source_score` int DEFAULT NULL,
`statements` VARCHAR(255)
);
Select *
FROM auditor_report;
-- So first, grab the location_id and true_water_source_score columns from auditor_report.
SELECT location_id,true_water_source_score
FROM auditor_report;

-- join the visits table to the auditor_report table. Make sure to grab subjective_quality_score, record_id and location_id.
SELECT
a.location_id AS audit_location,
a.true_water_source_score,
v.location_id AS visit_location,
v.record_id
FROM
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id;

-- JOIN the visits table and the water_quality table, using the record_id as the connecting key.
SELECT
a.location_id AS audit_location,
a.true_water_source_score,
v.location_id AS visit_location,
v.record_id,
subjective_quality_score
FROM 
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id;

-- It doesn't matter if your columns are in a different format, because we are about to clean this up a bit. Since it is a duplicate, we can drop one of the location_id columns. Let's leave record_id and rename the scores to surveyor_score and auditor_score to make it clear which scores we're looking at in the results set.
SELECT
a.location_id AS location_id,
v.record_id,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id;

-- A good starting point is to check if the auditor's and exployees' scores agree. There are many ways to do it. We can have a WHERE clause and check if surveyor_score = auditor_score, or we can subtract the two scores and check if the result is 0.
SELECT
a.location_id AS location_id,
v.record_id,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
WHERE a.true_water_source_score = wq.subjective_quality_score;

-- You got 2505 rows right? Some of the locations were visited multiple times, so these records are duplicated here. To fix it, we set visits.visit_count= 1 in the WHERE clause. Make sure you reference the alias you used for visits in the join.
SELECT
a.location_id AS location_id,
v.record_id,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
WHERE v.visit_count = 1 AND
a.true_water_source_score = wq.subjective_quality_score;

-- With the duplicates removed I now get 1518. What does this mean considering the auditor visited 1620 sites? But that means that 102 records are incorrect. So let's look at those. You can do it by adding one character in the last query!
SELECT
a.location_id AS location_id,
v.record_id,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score;

-- So, to do this, we need to grab the type_of_water_source column from the water_source table and call it survey_source, using the source_id column to JOIN. Also select the type_of_water_source from the auditor_report table, and call it auditor_source.
SELECT
a.location_id AS location_id,
a.type_of_water_source AS auditor_source,
ws.type_of_water_source AS surveyor_source,
v.record_id,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN water_source ws
ON ws.source_id = v.source_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score;

-- JOIN the assigned_employee_id for all the people on our list from the visits table to our query. Remember, our query shows the shows the 102 incorrect records, so when we join the employee data, we can see which employees made these incorrect records.
SELECT
a.location_id AS location_id,
v.record_id,
v.assigned_employee_id,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score;

-- So now we can link the incorrect records to the employees who recorded them. The ID's don't help us to identify them. We have employees' names stored along with their IDs, so let's fetch their names from the employees table instead of the ID's.
SELECT
a.location_id AS location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN 
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN 
employee e
ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score;

-- Well this query is massive and complex, so maybe it is a good idea to save this as a CTE, so when we do more analysis, we can just call that CTE like it was a table. Call it something like Incorrect_records. Once you are done, check if this query SELECT * FROM Incorrect_records, gets the same table back.
WITH Incorrect_records AS(
SELECT
a.location_id AS location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN 
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN 
employee e
ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score
)
SELECT *
FROM Incorrect_records;

-- Let's first get a unique list of employees from this table.
WITH Incorrect_records AS(
SELECT
a.location_id AS location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN 
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN 
employee e
ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score
)
SELECT DISTINCT employee_name
FROM Incorrect_records;

-- Next, let's try to calculate how many mistakes each employee made. So basically we want to count how many times their name is in Incorrect_records list, and then group them by name, right?
WITH Incorrect_records AS(
SELECT
a.location_id AS location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN 
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN 
employee e
ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score
)
SELECT *
FROM Incorrect_records;

-- Let's first get a unique list of employees from this table.
WITH Incorrect_records AS(
SELECT
a.location_id AS location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN 
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN 
employee e
ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score
)
SELECT DISTINCT employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM Incorrect_records
GROUP BY employee_name;

-- So let's try to find all of the employees who have an above-average number of mistakes. Let's break it down into steps first: 1. We have to first calculate the number of times someone's name comes up. (we just did that in the previous query). Let's call it error_count.
WITH error_count AS(
SELECT DISTINCT employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM (
SELECT
a.location_id AS location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN 
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN 
employee e
ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score
) AS incorrect_records
GROUP BY employee_name
)
SELECT *
FROM error_count;

-- 2. average number of mistakes employees made. We can do that by taking the average of the previous query's results.
WITH error_count AS(
SELECT DISTINCT employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM (
SELECT
a.location_id AS location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN 
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN 
employee e
ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score
) AS incorrect_records
GROUP BY employee_name
)
SELECT AVG(number_of_mistakes) as avg_error_count_per_empl
FROM error_count;

-- 3. Finaly we have to compare each employee's error_count with avg_error_count_per_empl. We will call this results set our suspect_list. Remember that we can't use an aggregate result in WHERE, so we have to use avg_error_count_per_empl as a subquery.
WITH error_count AS(
SELECT DISTINCT employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM (
SELECT
a.location_id AS location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN 
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN 
employee e
ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score
) AS incorrect_records
GROUP BY employee_name
)
SELECT
employee_name,
number_of_mistakes
FROM error_count
WHERE number_of_mistakes >  (SELECT AVG(number_of_mistakes) as avg_error_count_per_empl
FROM error_count);

-- Convert Incorrect_records to a view
CREATE VIEW Incorrect_records AS (
SELECT
a.location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score,
a.statements AS statements
FROM
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN
employee e
ON e.assigned_employee_id = v.assigned_employee_id
WHERE
v.visit_count = 1
AND a.true_water_source_score != wq.subjective_quality_score);

SELECT * FROM incorrect_records;

-- Convert error count CTE to a View
CREATE VIEW error_count AS(
SELECT DISTINCT employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM (
SELECT
a.location_id AS location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM 
auditor_report a
JOIN 
visits v
ON a.location_id = v.location_id
JOIN
water_quality wq
ON v.record_id = wq.record_id
JOIN 
employee e
ON v.assigned_employee_id = e.assigned_employee_id
WHERE v.visit_count = 1 AND
a.true_water_source_score != wq.subjective_quality_score
) AS incorrect_records
GROUP BY employee_name
);
SELECT *
FROM error_count;

-- convert the suspect_list to a CTE
WITH suspect_list AS(
SELECT
employee_name,
number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (SELECT AVG(number_of_mistakes) as avg_error_count_per_empl FROM error_count)
) 
SELECT * 
FROM suspect_list;

-- Now we can filter that Incorrect_records view to identify all of the records associated with the four employees we identified.
WITH suspect_list AS(
SELECT
employee_name,
number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (SELECT AVG(number_of_mistakes) as avg_error_count_per_empl FROM error_count)
)
SELECT employee_name, location_id, statements
FROM incorrect_records
WHERE employee_name IN (SELECT employee_name FROM suspect_list);

-- Filter the records that refer to "cash"
WITH suspect_list AS(
SELECT
employee_name,
number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (SELECT AVG(number_of_mistakes) as avg_error_count_per_empl FROM error_count)
)
SELECT employee_name, location_id, statements
FROM incorrect_records
WHERE employee_name IN (SELECT employee_name FROM suspect_list)
AND statements LIKE "%cash%";

-- Check if there are any employees in the Incorrect_records table with statements mentioning "cash" that are not in our suspect list. This should be as simple as adding one word.
SELECT *
FROM incorrect_records
WHERE statements LIKE "%cash&";

OR
WITH suspect_list AS(
SELECT
employee_name,
number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (SELECT AVG(number_of_mistakes) as avg_error_count_per_empl FROM error_count)
)
SELECT employee_name, location_id, statements
FROM incorrect_records
WHERE employee_name NOT IN (SELECT employee_name FROM suspect_list)
AND statements LIKE "%cash%";

-- MCQ 3 Q1: The following query results in 2,698 rows of data being retrieved, but the auditor_report table only has 1,620 rows. Analyse the query and select the reason why this discrepancy occurs.
-- Hint: Think about the type of relationship between our tables.
SELECT
    auditorRep.location_id,
    visitsTbl.record_id,
    Empl_Table.employee_name,
    auditorRep.true_water_source_score AS auditor_score,
    wq.subjective_quality_score AS employee_score
FROM auditor_report AS auditorRep
JOIN visits AS visitsTbl
ON auditorRep.location_id = visitsTbl.location_id
JOIN water_quality AS wq
ON visitsTbl.record_id = wq.record_id
JOIN employee as Empl_Table
ON Empl_Table.assigned_employee_id = visitsTbl.assigned_employee_id;

--Answer: The visits table has multiple records for each location_id, which when joined with auditor_report, results in multiple records for each location_id.

-- Q2: What is the function of Incorrect_records in the following query?
WITH Incorrect_records AS ( −− This CTE fetches all of the records with wrong scores
SELECT
    auditorRep.location_id,
    visitsTbl.record_id,
    Empl_Table.employee_name,
    auditorRep.true_water_source_score AS auditor_score,
    wq.subjective_quality_score AS employee_score
FROM auditor_report AS auditorRep
JOIN visits AS visitsTbl
ON auditorRep.location_id = visitsTbl.location_id
JOIN water_quality AS wq
ON visitsTbl.record_id = wq.record_id
JOIN employee as Empl_Table
ON Empl_Table.assigned_employee_id = visitsTbl.assigned_employee_id
WHERE visitsTbl.visit_count =1 AND auditorRep.true_water_source_score != wq.subjective_quality_score)

SELECT
    employee_name,
    count(employee_name)
FROM Incorrect_records
GROUP BY Employee_name;
-- Answer: Incorrect_records filters and organises records with different scores between auditor and employee, preparing a tailored dataset for the main query.

-- Q3: In the suspect_list CTE, a subquery is used. What type of subquery is it, and what is its purpose in the query?
suspect_list AS (
SELECT employee_name, number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (SELECT AVG(number_of_mistakes) FROM error_count))

--Answer: The subquery is a scalar subquery used to calculate the average number_of_mistakes for comparison.

--Q4: A colleague proposed the following CTE as an alternative to the suspect_list we used previously, but it does not give the desired results. What will be the result of this subquery?
suspect_list AS (
    SELECT ec1.employee_name, ec1.number_of_mistakes
    FROM error_count ec1
    WHERE ec1.number_of_mistakes >= (
        SELECT AVG(ec2.number_of_mistakes)
        FROM error_count ec2
        WHERE ec2.employee_name = ec1.employee_name))
--Answer: The subquery is a correlated subquery that returns all of the employees that made errors.
	
-- Q9: Which of the following “suspects” is connected to the following civilian statement:
-- “Suspicion coloured villagers' descriptions of an official's aloof demeanour and apparent laziness. The reference to cash transactions casts doubt on their motives.”
SELECT employee_name, location_id, statements
FROM incorrect_records
WHERE statements LIKE "%Suspicion%" AND
employee_name IN ("Bello Azibo", "Zuriel Matembo", "Malachi Mavuso","Lalitha Kaburi");

SELECT employee_name, location_id, statements
FROM incorrect_records
WHERE statements LIKE "%Suspicion colored villagers' descriptions of an official's aloof demeanor and apparent laziness. The reference to cash transactions cast doubt on their motives%" AND
employee_name IN ("Bello Azibo", "Zuriel Matembo", "Malachi Mavuso","Lalitha Kaburi");

-- Q10: Consider the provided SQL query. What does it do?
SELECT
auditorRep.location_id,
visitsTbl.record_id,
auditorRep.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
wq.subjective_quality_score - auditorRep.true_water_source_score  AS score_diff
FROM auditor_report AS auditorRep
JOIN visits AS visitsTbl
ON auditorRep.location_id = visitsTbl.location_id
JOIN water_quality AS wq
ON visitsTbl.record_id = wq.record_id
WHERE (wq.subjective_quality_score - auditorRep.true_water_source_score) > 9;
-- Answer: The query retrieves the auditor records where employees assigned very high scores to very poor water sources.

-- Part 4
-- Start by joining location to visits.
SELECT
loc.province_name,
loc.town_name,
v.visit_count,
loc.location_id
FROM location loc
JOIN visits v
ON v.location_id = loc.location_id;

-- Now, we can join the water_source table on the key shared between water_source and visits.
SELECT
loc.province_name,
loc.town_name,
v.visit_count,
loc.location_id,
ws.type_of_water_source,
ws.number_of_people_served
FROM location loc
JOIN visits v
ON v.location_id = loc.location_id
JOIN water_source ws
ON v.source_id = ws.source_id;

-- add the visits.visit_count = 1 as a filter
SELECT
loc.province_name,
loc.town_name,
v.visit_count,
loc.location_id,
ws.type_of_water_source,
ws.number_of_people_served
FROM location loc
JOIN visits v
ON v.location_id = loc.location_id
JOIN water_source ws
ON v.source_id = ws.source_id
WHERE v.visit_count= 1;

-- Ok, now that we verified that the table is joined correctly, we can remove the location_id and visit_count columns.
SELECT
loc.province_name,
loc.town_name,
ws.type_of_water_source,
ws.number_of_people_served
FROM location loc
JOIN visits v
ON v.location_id = loc.location_id
JOIN water_source ws
ON v.source_id = ws.source_id
WHERE v.visit_count= 1;

-- Add the location_type column from location and time_in_queue from visits to our results set.
SELECT
loc.province_name,
loc.town_name,
ws.type_of_water_source,
loc.location_type,
ws.number_of_people_served,
v.time_in_queue
FROM location loc
JOIN visits v
ON v.location_id = loc.location_id
JOIN water_source ws
ON v.source_id = ws.source_id
WHERE v.visit_count= 1;

-- Last one! Now we need to grab the results from the well_pollution table. Use Inner join since well pollution is only for wells.
SELECT
loc.province_name,
loc.town_name,
ws.type_of_water_source,
loc.location_type,
ws.number_of_people_served,
v.time_in_queue,
wp.results
FROM visits v
LEFT JOIN well_pollution wp
ON wp.source_id = v.source_id
INNER JOIN location loc
ON v.location_id = loc.location_id
INNER JOIN water_source ws
ON ws.source_id = v.source_id
WHERE v.visit_count= 1;

-- make it a VIEW so it is easier and call it the combined_analysis_table.
CREATE VIEW combined_analysis_table AS
SELECT
loc.province_name,
loc.town_name,
ws.type_of_water_source AS source_type,
loc.location_type,
ws.number_of_people_served AS people_served,
v.time_in_queue,
wp.results
FROM visits v
LEFT JOIN well_pollution wp
ON wp.source_id = v.source_id
INNER JOIN location loc
ON v.location_id = loc.location_id
INNER JOIN water_source ws
ON ws.source_id = v.source_id
WHERE v.visit_count= 1;

-- Pivot table. we want to break down our data into provinces or towns and source types. If we understand where the problems are, and what we need to improve at those locations, we can make an informed decision on where to send our repair teams.
-- This is for province
WITH province_totals AS (-- This CTE calculates the population of each province. province_totals is a CTE that calculates the sum of all the people surveyed grouped by province.
SELECT
province_name,
SUM(people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name
)
-- SELECT *
-- FROM province_totals;
SELECT
cat.province_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS well
FROM combined_analysis_table cat
JOIN province_totals pt 
ON cat.province_name = pt.province_name
GROUP BY cat.province_name
ORDER BY cat.province_name;

-- Let's aggregate the data per town now.
WITH town_totals AS (-- This CTE calculates the population of each town
-- Since there are two Harare towns, we have to group by province_name and town_name
SELECT province_name, town_name, SUM(people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name,town_name
)
-- SELECT * 
-- FROM town_totals
SELECT
cat.province_name,
cat.town_name,
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table cat
JOIN -- Since the town names are not unique, we have to join on a composite key
town_totals tt ON cat.province_name = tt.province_name AND cat.town_name = tt.town_name
GROUP BY -- We group by province first, then by town.
cat.province_name,
cat.town_name
ORDER BY
cat.town_name;

-- store as a temp table
CREATE TEMPORARY TABLE town_aggregated_water_access 
WITH town_totals AS (-- This CTE calculates the population of each town
-- Since there are two Harare towns, we have to group by province_name and town_name
SELECT province_name, town_name, SUM(people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name,town_name
)
-- SELECT * 
-- FROM town_totals
SELECT
cat.province_name,
cat.town_name,
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table cat
JOIN -- Since the town names are not unique, we have to join on a composite key
town_totals tt ON cat.province_name = tt.province_name AND cat.town_name = tt.town_name
GROUP BY -- We group by province first, then by town.
cat.province_name,
cat.town_name
ORDER BY
cat.town_name;

SELECT *
FROM town_aggregated_water_access;

-- For example, which town has the highest ratio of people who have taps, but have no running water?
SELECT
province_name,
town_name,
ROUND(tap_in_home_broken/(tap_in_home_broken + tap_in_home) * 100, 0) AS Pct_broken_taps
FROM town_aggregated_water_access;

-- Our final goal is to implement our plan in the database.
/* We have a plan to improve the water access in Maji Ndogo, so we need to think it through, and as our 
final task, create a table where our teams have the information they need to fix, upgrade and repair water 
sources. They will need the addresses of the places they should visit (street address, town, province), 
the type of water source they should improve, and what should be done to improve it.
-- We should also make space for them in the database to update us on their progress. We need to know if 
the repair is complete, and the date it was completed, and give them space to upgrade the sources. 
Let's call this table Project_progress.*/

CREATE TABLE project_progress (
project_id SERIAL PRIMARY KEY,
/* Project_id −− Unique key for sources in case we visit the same source more than once in the future.*/
source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
/* source_id −− Each of the sources we want to improve should exist, and should refer to the source table.
This ensures data integrity.*/
Address VARCHAR(50), -- street address
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
Improvement VARCHAR(50), -- what the engineers should do at the place
Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
-- we want to limit the information the engineers give us so we limit source status
-- By DEFAULT all projects are in the "Backlog" which is like a TODO list.
-- CHECK() ensures only those three options will be accepted. This helps to maintain clean data.
Date_of_completion DATE, -- Engineers will add this the day the source has been upgraded.
Comments TEXT -- Engineers can leave comments. We use a TEXT type that has no limit on char length
);

SELECT
location.address,
location.town_name,
location.province_name,
water_source.source_id,
water_source.type_of_water_source,
well_pollution.results
FROM
water_source
LEFT JOIN
well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
visits ON water_source.source_id = visits.source_id
INNER JOIN
location ON location.location_id = visits.location_id;

-- First things first, let's filter the data to only contain sources we want to improve by thinking 
-- through the logic first.
-- 1. Only records with visit_count = 1 are allowed.
-- 2. Any of the following rows can be included:
-- a. Where shared taps have queue times over 30 min.
-- b. Only wells that are contaminated are allowed. so we exclude wells that are clean
-- c. Include any river and tap_in_home_broken sources.

-- Project progress query
SELECT
location.address,
location.town_name,
location.province_name,
water_source.source_id,
water_source.type_of_water_source,
well_pollution.results
FROM
water_source
LEFT JOIN
well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
visits ON water_source.source_id = visits.source_id
INNER JOIN
location ON location.location_id = visits.location_id
WHERE visits.visit_count = 1
AND (well_pollution.results != "Clean"
OR water_source.type_of_water_source IN ("river", "tap_in_home_broken")
OR (water_source.type_of_water_source = "shared_tap" AND visits.time_in_queue >= 30)
);

-- Update improvement column for all the source type
INSERT INTO project_progress (source_id, Address, Town, Province, Source_type, Improvement) 
SELECT water_source.source_id,
location.address,
location.town_name,
location.province_name,
water_source.type_of_water_source,
CASE
WHEN (type_of_water_source = "well" AND well_pollution.results = "Contaminated: Chemical")
	THEN "Install RO filter"
WHEN (type_of_water_source = "well" AND well_pollution.results = "Contaminated: Biological")
    THEN "Install UV and RO filter"
WHEN type_of_water_source = "river" THEN "Drill wells"
WHEN (type_of_water_source = "shared_tap" AND time_in_queue >= 30)
    THEN (CONCAT("Install ", FLOOR(visits.time_in_queue/30), ' taps nearby'))
WHEN type_of_water_source = "tap_in_home_broken"
	THEN "Diagnose local infrastructure"
ELSE NULL
END
FROM water_source
LEFT JOIN well_pollution
ON water_source.source_id = well_pollution.source_id
INNER JOIN visits
ON water_source.source_id = visits.source_id
INNER JOIN location
ON location.location_id = visits.location_id
WHERE visit_count = 1
AND ( results != "Clean"
OR type_of_water_source IN ("river", "tap_in_home_broken")
OR (type_of_water_source = "shared_tap" AND visits.time_in_queue >= 30));

-- MCQ 4 Q1: How many UV filters do we have to install in total?
SELECT *
FROM project_progress
WHERE Improvement LIKE "%UV%";

-- Q5: Which towns should we upgrade shared taps first?

-- Answer: Zuri, Abidjan, Bello - 71%, 53% and 53% of the population use shared taps in each of these towns.

-- Q6: Which of the following improvements is suggested for a chemically contaminated well with a queue time of over 30 minutes?

-- Answer: Install RO filter.
-- Q7: What is the maximum percentage of the population using rivers in a single town in the Amanzi province?
SELECT MAX(river)
FROM town_aggregated_water_access
WHERE province_name = 'Amanzi';

-- Q8: In which province(s) do all towns have less than 50% access to home taps (including working and broken)?
SELECT province_name
FROM town_aggregated_water_access
GROUP BY province_name
HAVING max(tap_in_home + tap_in_home_broken) < 50;

-- Q10
SELECT
project_progress.Project_id, 
project_progress.Town, 
project_progress.Province, 
project_progress.Source_type, 
project_progress.Improvement,
Water_source.number_of_people_served,
RANK() OVER(PARTITION BY Province ORDER BY number_of_people_served)
FROM  project_progress 
JOIN water_source 
ON water_source.source_id = project_progress.source_id
WHERE Improvement = "Drill Wells"
ORDER BY Province DESC, number_of_people_served;
