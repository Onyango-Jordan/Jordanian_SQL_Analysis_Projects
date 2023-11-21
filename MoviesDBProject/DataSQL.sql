USE movies;

-- How much did movies cost per unit?
SELECT 
	title,
    budget,
    runtime,
    ROUND((budget/runtime), 0) AS movie_budget_per_minute
FROM movie
ORDER BY movie_budget_per_minute DESC;

-- What are the ten most expensive movies to be produced?
SELECT
	title,
    budget
FROM movie
ORDER BY budget DESC
LIMIT 10;

-- Which ten movies have got the largest budget more than the average budget of the movies?
SELECT
	movie_id,
    title,
    budget,
    revenue
FROM movie
WHERE budget >
	(SELECT
		AVG(budget)
	FROM movie)
ORDER BY budget DESC
LIMIT 10;

-- How old are the movies as at now, give the latest movies?
SELECT
	title,
    release_date,
    (YEAR(CURDATE()) - YEAR(release_date)) AS age
FROM movie
ORDER BY age
LIMIT 10;

-- In which year did the producer make movies regardless of the number of movies?
SELECT
	DISTINCT YEAR(release_date) AS Year
FROM movie
ORDER BY 1 DESC;

-- What are the 10 leat popular movies and which companies did produce them:
SELECT
	m.title,
    pc.company_name,
    m.popularity
FROM movie m
	INNER JOIN movie_company mc
	ON m.movie_id = mc.movie_id
    INNER JOIN production_company pc
    ON mc.company_id = pc.company_id
ORDER BY m.popularity
LIMIT 10;

-- Which movies did cost less than 50000 and and which genres were they, give ten movies?
SELECT
	m.title,
    g.genre_name,
    m.budget,
    m.revenue
FROM genre g
	INNER JOIN movie_genres mg
    ON g.genre_id = mg.genre_id
    INNER JOIN movie m
    ON mg.movie_id = m.movie_id
WHERE m.budget < 50000
ORDER BY m.budget ASC
LIMIT 10;
    
    





















































































































































































































































































































































































































































































































































































































































































































































































































    

