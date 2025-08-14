-- 1. Create Database and Table
CREATE DATABASE IF NOT EXISTS Netflix;
USE Netflix;

CREATE TABLE IF NOT EXISTS netflix
(
    show_id VARCHAR(50),
    type VARCHAR(10),
    title VARCHAR(250),
    director VARCHAR(550),
    casts VARCHAR(1050),
    country VARCHAR(550),
    date_added VARCHAR(55),
    release_year INT,
    rating VARCHAR(15),
    duration VARCHAR(15),
    listed_in VARCHAR(250),
    description VARCHAR(550)
);

-- 2. View all data
SELECT * FROM netflix;

-- 3. Count the number of Movies vs TV Shows
SELECT type, COUNT(*) AS total_count
FROM netflix
GROUP BY type;

-- 4. Most common rating for movies and TV shows
SELECT type, rating, COUNT(*) AS rating_count
FROM netflix
GROUP BY type, rating
ORDER BY type, rating_count DESC;

-- 5. List all movies released in 2020
SELECT *
FROM netflix
WHERE release_year = 2020;

-- 6. Top 5 countries with the most content
-- Note: Works only if 'country' contains single values. 
-- For comma-separated multiple countries, you need a helper table or JSON split.
SELECT country, COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

-- 7. Identify the longest movie
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;

-- 8. Content added in the last 5 years
SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- 9. All movies/TV shows by director 'Rajiv Chilaka'
-- For multiple directors, use FIND_IN_SET if comma-separated
SELECT *
FROM netflix
WHERE FIND_IN_SET('Rajiv Chilaka', director) > 0;

-- 10. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type='TV Show'
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- 11. Count content items in each genre
-- For multiple genres, simple method (comma-separated) using LIKE for demonstration
SELECT listed_in AS genre, COUNT(*) AS total_content
FROM netflix
GROUP BY listed_in
ORDER BY total_content DESC;

-- 12. Average number of content released per year by India (Top 5)
SELECT release_year, COUNT(*) AS total_release
FROM netflix
WHERE country='India'
GROUP BY release_year
ORDER BY total_release DESC
LIMIT 5;

-- 13. List all movies that are documentaries
SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries%';

-- 14. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL OR director='';

-- 15. How many movies actor 'Salman Khan' appeared in last 10 years
SELECT *
FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND release_year >= YEAR(CURDATE()) - 10;

-- 16. Top 10 actors with most movies produced in India
-- Simple version for single actors; for multiple comma-separated actors, use a helper table
SELECT casts AS actor, COUNT(*) AS total_movies
FROM netflix
WHERE country='India'
GROUP BY casts
ORDER BY total_movies DESC
LIMIT 10;

-- 17. Categorize content based on description keywords 'kill' and 'violence'
SELECT
    CASE
        WHEN description LIKE '%kill%' COLLATE utf8mb4_general_ci
          OR description LIKE '%violence%' COLLATE utf8mb4_general_ci
        THEN 'Bad'
        ELSE 'Good'
    END AS category,
    type,
    COUNT(*) AS content_count
FROM netflix
GROUP BY category, type
ORDER BY type;
