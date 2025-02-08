SELECT  DISTINCT type FROM netflix;
SELECT * FROM netflix;

-- 15 Business Problems
-- 1. Count the number of Movies vs TV Shows

SELECT type, COUNT(*) AS total_content
FROM netflix
GROUP BY type;

-- 2. find the most common rating for movies and TV shows

SELECT type, rating
FROM
(
SELECT type, rating, COUNT(*),
RANK () OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY 1,2
)AS t1
WHERE ranking = 1

-- 3. List all movies in a specific year (e.g., 2020)

SELECT title,type, release_year
FROM netflix
WHERE type = 'Movie'
AND release_year = 2020

-- 4. Find the top 5 countries with the most content on netflix
--SELECT country, COUNT(show_id) FROM netflix
--GROUP BY 1;

SELECT 
	UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	COUNT(show_id) as total_content
FROM 
	netflix
GROUP BY 1
ORDER BY 2 DESC LIMIT(6);

-- 5. Identify the longest movie

SELECT type, title, duration FROM netflix
WHERE type = 'Movie'
AND duration = (SELECT MAX(duration) FROM netflix);

-- 6. Find content added in last 5 years

--SELECT CURRENT_DATE - INTERVAL '5 years'
SELECT date_added, type, title FROM netflix
WHERE date_added >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/ TV shows by diretor 'Rajiv Chilaka'!
SELECT type, title, director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
SELECT type, title, duration FROM netflix
WHERE type = 'TV Show'
AND SPLIT_PART(duration,' ',1)::numeric > 5

-- 9. Count the number of content items in each genre
SELECT * FROM netflix
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(show_id) as total_content
FROM 
	netflix
GROUP BY 1
ORDER BY 2 DESC;

-- 10. Find each year and the average numbers of content release by India on netflix. Return top 5 year with highest avg content release
--First formatting the dates to one single format

SELECT DISTINCT date_added FROM netflix LIMIT 20;
SELECT 
    date_added,
    CASE 
        WHEN date_added ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
            THEN TO_DATE(date_added, 'DD/MM/YYYY')
        WHEN date_added ~ '^[0-9]{2}-[A-Za-z]{3}-[0-9]{2}$' 
            THEN TO_DATE(date_added, 'DD-Mon-YY')
        WHEN date_added ~ '^[A-Za-z]{3} [0-9]{2}, [0-9]{4}$' 
            THEN TO_DATE(date_added, 'Mon DD, YYYY')
        WHEN date_added ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN TO_DATE(date_added, 'YYYY-MM-DD')
        ELSE NULL
    END AS standardized_date
FROM netflix
LIMIT 20;
UPDATE netflix
SET date_added = 
    CASE 
        WHEN date_added ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
            THEN TO_CHAR(TO_DATE(date_added, 'DD/MM/YYYY'), 'YYYY-MM-DD')
        WHEN date_added ~ '^[0-9]{2}-[A-Za-z]{3}-[0-9]{2}$' 
            THEN TO_CHAR(TO_DATE(date_added, 'DD-Mon-YY'), 'YYYY-MM-DD')
        WHEN date_added ~ '^[A-Za-z]{3} [0-9]{2}, [0-9]{4}$' 
            THEN TO_CHAR(TO_DATE(date_added, 'Mon DD, YYYY'), 'YYYY-MM-DD')
        WHEN date_added ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN date_added  -- Already in correct format
        ELSE NULL
    END;
	ALTER TABLE netflix 
ALTER COLUMN date_added TYPE DATE 
USING TO_DATE(date_added, 'YYYY-MM-DD');

-- Formatting done

SELECT 
    title, 
    EXTRACT(YEAR FROM date_added) AS year
FROM netflix;

SELECT EXTRACT(YEAR FROM date_added) AS year,
COUNT(*) 
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC LIMIT 5

-- 11. Find all movies that are documentaries
SELECT type, title, listed_in
FROM netflix
WHERE type = 'Movie' 
AND listed_in ILIKE 'Documentaries'

-- 12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL

--13. Find how many movies actor Salman Khan appeared in last 10 years
SELECT type, title, casts, release_year
FROM netflix
WHERE casts like '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 15

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
SELECT UNNEST(STRING_TO_ARRAY(casts,',')),
COUNT(*) AS total_contents
FROM netflix
WHERE country ILIKE 'India'
GROUP BY 1 
ORDER BY 2 DESC LIMIT 10

--15. Categorize the content based on the presence of keywords 'kill' and 'violence' in the description field. 			
--	  Label content contaiing these keuwords as 'Bad' and all other content as 'Good'. Count how many fall into each category.

WITH new_table
AS
(
SELECT *,
CASE
	WHEN description ILIKE '%kill%' OR
		 description ILIKE '%violence%'
	THEN 'Bad_content'
	ELSE 'Good_content'
END category
FROM netflix
)
SELECT category, COUNT(*) as total_content
FROM new_table
GROUP BY 1
