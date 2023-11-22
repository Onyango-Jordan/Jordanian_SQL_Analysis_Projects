CREATE TABLE meat_poultry_egg_inspect (
	est_number varchar(50) CONSTRAINT est_number_key PRIMARY KEY,
	company varchar(100),
	street varchar(100),
	city varchar(30),
	st varchar(2),
	zip varchar(5),
	phone varchar(14),
	grant_date date,
	 activities text,
	dbas text
);
COPY meat_poultry_egg_inspect
FROM 'C:\Users\My_Directory\Downloads\MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- Create index on the column company for speedy queryng.
CREATE INDEX company_idx ON meat_poultry_egg_inspect (company);