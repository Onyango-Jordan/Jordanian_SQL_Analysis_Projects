-- I have first created a new schema(database) by the name AccidentAnalytics using SSMS.
-- The next step is to import the thwo .csv files into ssms and database as tables.

-- The below questions will be answered to give us some insights into the accident analysis exercise

-- Q1; How many accidents have occured in urban areas vs rural areas?

SELECT
	Area,
	COUNT(AccidentIndex) AS number_of_accidents
FROM accident
GROUP BY 
	Area;

-- Q2: Which Day of the week has the highest number of accidents?

SELECT
	Day,
	COUNT(AccidentIndex) AS number_of_accidents
FROM accident
GROUP BY Day
ORDER BY number_of_accidents DESC
-- LIMIT 1;

--OR

SELECT 
	Day
FROM   (
		SELECT
			Day,
			COUNT(AccidentIndex) AS total_accidents
		FROM accident
		GROUP BY Day
		) a
ORDER BY a.total_accidents DESC;

-- Q3: What is the average age of vehicles involved in Accidents based on their type

SELECT
	VehicleType,
	COUNT(AccidentIndex) AS total_accidents,
	AVG(AgeVehicle) AS Average_age
FROM vehicle
WHERE AgeVehicle IS NOT NULL
GROUP BY VehicleType
ORDER BY 1, 2 DESC, 3 DESC;

-- Q4: Identify any trends in accidents based on the age of vehicles involved

SELECT
	AgeGroup,
	COUNT(AccidentIndex) AS total_accidents,
	AVG(AgeVehicle) AS Average_Year
FROM (
	SELECT
		AccidentIndex,
		AgeVehicle,
		CASE
			WHEN AgeVehicle BETWEEN 0 AND 5 THEN 'New'
			WHEN AgeVehicle BETWEEN 6 AND 10 THEN 'Regular'
			ELSE 'Old'
		END AS AgeGroup
	FROM vehicle
	) AS a
GROUP BY
	AgeGroup;

--Q5: Do accidents often involve left-hand side vehicles

SELECT
	LeftHand,
	COUNT(AccidentIndex) AS total_accidents
FROM vehicle
GROUP BY LeftHand
HAVING
	LeftHand IS NOT NULL;

--Q6; What is the relationship between journey purpose and the sverity of accidents?

SELECT
	v.JourneyPurpose,
	COUNT(a.severity) AS total_accidents,
	CASE
		WHEN COUNT(a.Severity) BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT(a.Severity) BETWEEN 1000 AND 3000 THEN 'Moderate'
		ELSE 'High'
	END AS 'Level'
FROM vehicle v
	INNER JOIN accident a
	ON v.AccidentIndex = a.AccidentIndex
GROUP BY
	v.JourneyPurpose
ORDER BY 
	'total_accidents' DESC;

