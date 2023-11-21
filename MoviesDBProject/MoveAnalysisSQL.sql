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

-- Which director did make most popular movie in English and french language
SELECT
	p.Person_name,
    l.language_name,
    COUNT(m.movie_id) AS number_of_movies,
    MAX(m.popularity) AS most_popular_movie_per_language
FROM
	movie m
	INNER JOIN movie_crew mc
	ON m.movie_id = mc.movie_id
    INNER JOIN person p
    ON mc.person_id = p.person_id
	INNER JOIN movie_languages ml
	ON m.movie_id = ml.movie_id
	INNER JOIN language l
	ON ml.language_id = l.language_id
WHERE mc.job = 'Director'
AND(l.language_name = 'English' OR l.language_name = 'French')
GROUP BY p.person_name, l.language_name
ORDER BY MAX(m.popularity) DESC
LIMIT 1;


-- Make a list of actors and actress who played a role after 2010.
SELECT 
	p.person_name,
    m.title,
	m.release_date
FROM Person p
	INNER JOIN movie_crew mc
    ON p.person_id = mc.person_id
    INNER JOIN movie m
    ON mc.movie_id = m.movie_id
WHERE YEAR(release_date) > 2010
	AND mc.job = 'Characters'
ORDER BY 1,2,3;
    





















































































































































































































































































































































































































































































































































































































































































































































































































    


