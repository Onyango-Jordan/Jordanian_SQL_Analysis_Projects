USE hresourcedb;
SET sql_safe_updates = 1;

# WE will first rename the id column which has an ambigous name. we will name it to make it easy for queryng.
ALTER TABLE hr
	CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NOT NULL;

# The birthdate is also in text format.We need to change it to date type for easy and accurate analysis.
UPDATE hr
SET birthdate = 
	CASE
		WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN birthdate  LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
        ELSE NULL
	END;
    
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;
    
# Modifyng and changing the hire_date column data type from  text to date format
UPDATE hr
SET hire_date = 
	CASE
		WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN hire_date  LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
        ELSE NULL
	END;
    
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;


# Modifyng and changing the termdate column data type from  text to date format
UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;


# Adding a column for age of employees.
ALTER TABLE hr
ADD COLUMN age INT;

UPDATE HR 
SET age = TIMESTAMPDIFF(YEAR,birthdate, CURDATE());






