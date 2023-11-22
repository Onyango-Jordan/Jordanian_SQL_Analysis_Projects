-- DATA INSPECTION

-- Q1. Let us first check if there are companies that have got duplicate addresses
SELECT
	company, --company_name
	street, --street address
	city, --city of company
	st ,--state
	COUNT(*) AS number_of_companies_per_address
FROM meat_poultry_egg_inspect
GROUP BY company, street, city, st
	HAVING COUNT(*) > 1
ORDER BY 1, 2, 3, 4;

/* This returns 23 rows which means there are 23 companies with more than one facility
in the same address.This can be true or it can be an issue of wrong data entry. */

-- Q2. How mach of the processing companies are in each state?
SELECT
	st AS state,
	COUNT(*) AS number_of_companies_per_state
FROM meat_poultry_egg_inspect
GROUP BY state
ORDER BY state;

/*In the result the last row the st column has a null value while the count column is 3,
This means that there are rows in the st Column with NULL values */

-- Q3. Find the companies that dont have a state address assigned to them
SELECT
	company,
	street,
	city,
	st
FROM meat_poultry_egg_inspect
WHERE st IS NULL;

/* From this query we find out that 3 companies have got no state record.
We can now go back to the original data source to get these records*/

-- Q4. Are there records with inconsistent data values. This we do by finding out how many locations each company owns a plant.

SELECT
	company,
	COUNT(*) AS number_of_plants
FROM meat_poultry_egg_inspect
GROUP BY company
ORDER BY company ASC;

/* From this query you will notice that the names of companies are different,
based on the different locations they are in and hence this will not provide an accurate 
result during analysis */

-- Q 5. We want to check if the ZIP codes are okay(in US format, which has 5 characters), a Zipcode which doesnt have 5 characters is malformed
SELECT
	LENGTH(zip) AS Zip_length,
	COUNT(*) AS number_of_zips
FROM meat_poultry_egg_Inspect
GROUP BY LENGTH(zip)
ORDER BY LENGTH(zip) ASC
-- OR
SELECT 
	st,
	COUNT(*) AS zip_counts
FROM meat_poultry_egg_inspect
WHERE LENGTH(zip) < 5
GROUP BY st
ORDER BY st ASC;

/* From the query we find out that 86 zip codes have got a length of 3 characters, 496 zipcodes
have got a length of 4 and 5705 zip codes have got a length of 5. The zipcodes with 
characters below 5 will need to be modified/corrected. */

/* So far we have got 3 issues we need to correct from the table, they are
	- Missing valuesfor the states column as previously found.
	- Inconsistent spelling of at least one company's name.
	- Inaccurate ZIP codes due to file conversion during importation of the CSV file
*/

-- DATA MODIFICATION 

-- We will first backup the meat_poultry_egg inspect table before we start modifyng it.
CREATE TABLE meat_poultry_egg_inspect_backup
AS(SELECT * FROM meat_poultry_egg_inspect);

-- To confirm if the result is an exact copy of the original table we do as below

SELECT
	(SELECT COUNT(*) FROM meat_poultry_egg_inspect) AS original_table,
	(SELECT COUNT(*) FROM meat_poultry_egg_inspect_backup) AS backup_table;
	

-- Restoring missing values to the state column
-- we first set a column copy of the st column and te add data to the st_copy_column

ALTER TABLE meat_poultry_egg_inspect
	ADD COLUMN st_copy VARCHAR(2);

UPDATE meat_poultry_egg_inspect
SET st_copy = st; -- This will fill the st_copy column with the values from the st column.

SELECT
	st,
	st_copy
FROM meat_poultry_egg_inspect
ORDER BY st; -- This query confirms if the update statement has worked correctly

-- Updating rows where the st values are missing

SELECT * 
FROM meat_poultry_egg_inspect
WHERE st IS NULL; -- This statement will give us an overall detail of the entities with missing st data values

/* From the internet search we can now kbow that Atlas Inspection Inc is in Minnesota(MN),
Hall-Namie packings s in Alabama(AL) and Jones Dairy is in Wisconsin(WI)
*/

-- Updating the missing data values on the st column
UPDATE meat_poultry_egg_inspect
SET st =
	(CASE 
		WHEN est_number = 'V18677A' THEN 'MN'
		WHEN est_number = 'M45319+P45319' THEN 'AL'
		WHEN est_number = 'M263A+P263A+V263A' THEN 'WI'
	 	ELSE st
	END
	 )
WHERE st IS NULL;


-- Updating values for consistency, in this case wew will use the company Armour- Eckrich meats to show how to do this
ALTER TABLE meat_poultry_egg_inspect
	ADD COLUMN company_standard VARCHAR(100); -- This is a copy of the company column
	
UPDATE meat_poultry_egg_inspect
SET company_standard = company;
	
/* We are going to update all companies with the word Armour, to a standar as Armour-Eckrich Meats,
with Advance as AdvancePierre Foods and with Cargill as Cargil,Inc.
*/

UPDATE meat_poultry_egg_inspect
SET company_standard =
	(
		CASE
			WHEN company_standard LIKE 'Armour%' THEN 'Armour-Eckrich Meats'
			WHEN company_standard LIKE 'Advance%' THEN 'AdvancePierre Foods' 
			WHEN company_standard LIKE 'Cargill%' THEN 'Cargill, Inc'
			ELSE company_standard
		END
	);

-- Repairing the zipcodes with lengths below 5 i.e 3 and 4

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN zip_copy varchar(5); --make a new column of zipcode copies

UPDATE meat_poultry_egg_inspect
SET zip_copy = zip; --update the new column with data from original column

-- Its now time to repair the zipcodes
UPDATE meat_poultry_egg_inspect
SET zip =
	(
		CASE
			WHEN st IN('PR', 'VI') AND length(zip) = 3 THEN '00' || zip
			WHEN st IN('CT', 'MA', 'ME', 'NH', 'NJ', 'RI', 'VT') AND length(zip) = 4 THEN '0' || zip
			ELSE zip
		END
	);
	





































































































































































































































































































































































































































