--Netflix Data Analysis
-- Creation of Table named netflix
CREATE TABLE netflix(
  show_id VARCHAR(6),
  type VARCHAR(10),
  title VARCHAR(150),
  director VARCHAR(208),
  casts VARCHAR(1000),
  country VARCHAR(150),
  date_added VARCHAR(50),
  release_year INT,
  rating VARCHAR(10),
  duration VARCHAR(15),
  listed_in VARCHAR(100),
  description VARCHAR(250)
);

-- Display whole table netflix
SELECT * FROM netflix;

-- Display total no. of entries in column named as total_count
SELECT COUNT(*) as total_count
FROM netflix;

-- from type column it shows the unique column entries
SELECT DISTINCT type
FROM netflix;

-- Problem 1. Count the number of movies and TV shows
SELECT type, COUNT(show_id) as total_count
FROM netflix
GROUP BY type;

-- Problem 2. Find the most common rating for movies and TV shows.

-- sub query used prints ratings there count and ranking , first fot monies and then for 
-- TV shows and when we add these to main query that uses this rank 1 and prints them to give most common rating
-- run these first for better understanding
--    SELECT type, rating, COUNT(*), 
-- 	         RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
-- 	  FROM netflix
-- 	  GROUP BY 1, 2
SELECT type, rating
FROM (
      SELECT type, rating, COUNT(*), 
	         RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	  FROM netflix
	  GROUP BY 1, 2
	 ) as t1
WHERE ranking = 1 ;

-- Problem 3. List all the movies releases in specific year (e.g..2020)
-- if I also wanted the type to be printed here then write select tiltle , type
-- group by is not neccesary only write if you are going to add aggregate function like MAX(),
-- COUNT() ,MIN(), SUM(), AVG()
SELECT title 
FROM netflix
WHERE release_year = 2020 AND type = 'Movie';

-- Problem 4. Find the top 5 countries with the most content on Netflix.
-- This is the subquery
-- SELECT
--    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) as new_country
-- FROM netflix
-- As one movie is released from diff country so that column has different countries in single row so 
-- string_to_array(country, ','): Splits "India, United States" into an array: ['India', 'United States'].
-- unnest(...): Converts that array into multiple rows.
-- TRIM(...): Removes leading/trailing spaces (e.g., " United States" becomes "United States")
SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) as new_country,
	   COUNT(show_id) as total_count
FROM netflix 
GROUP BY new_country 
ORDER BY total_count DESC
LIMIT 5;

--code 2
SELECT country, COUNT(*) AS total_count
FROM (
    SELECT TRIM(unnest(string_to_array(country, ','))) AS country
    FROM netflix
    WHERE country IS NOT NULL -- deletes nit ull values
) AS country_split
GROUP BY country
ORDER BY total_count DESC
LIMIT 5;

-- This gives all the column_names of particular table
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'netflix';

-- Problem 5. Identify the longest movie
-- duration is a column with values like: '90 min', '45 min', '1 Season'
-- POSITION('m' IN duration) finds the position (index) of the first 'm' character.
-- For '90 min', 'm' is at position 4.
-- So, POSITION('m' IN duration) - 1 = 4 - 1 = 3.
-- Then SUBSTRING(duration, 1, 3) gets the first 3 characters, which is '90 ' (including the space).
-- This gives us the numeric part of the duration.
--::int → Converts the string "90" into an integer.
--POSITION('m' IN duration) > 0 → Ensures the word "min" is present (because duration for TV shows
-- might say "2 Seasons" which shouldn't be parsed as minutes).
SELECT 
    title, 
    SUBSTRING(duration, 1, POSITION('m' IN duration) - 1)::int AS duration_minutes
FROM netflix
WHERE type = 'Movie' 
  AND duration IS NOT NULL 
  AND POSITION('m' IN duration) > 0
ORDER BY duration_minutes DESC
LIMIT 1;

-- Problem 6. Find the content added in last 5 years
-- SELECT CURRENT_DATE - INTERVAL '5 years' // calculates date exactly 5 years ago from today's date
-- TO_DATE(date_added, 'Month DD, YYYY') → Converts the text date like 'August 15, 2021' into a proper date type.
-- CURRENT_DATE - INTERVAL '5 years' → Calculates the date exactly 5 years ago from today.
SELECT title, type, date_added 
FROM netflix
WHERE date_added IS NOT NULL
      AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY TO_DATE(date_added, 'Month DD, YYYY') DESC;

-- Problem 7. Find the movies/TV shows by director 'Rajiv Chilaka'.
-- LIKE helps find text patterns in your data.
-- Use % for any number of characters, _ for single characters.
SELECT type, title, director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%' -- or this if director list has more that one director for one title
--
SELECT COUNT(*) AS total_titles -- no.of movies and TV shows
FROM netflix
WHERE director = 'Rajiv Chilaka'; -- we can write this

-- Problem 8. List all TV shows having more than 5 seasons
-- code 1.
SELECT title,
       SUBSTRING(duration,1,POSITION('S' IN DURATION)-1)::int AS seasons
FROM netflix
WHERE type = 'TV Show'
      AND SUBSTRING(duration,1,POSITION('S' IN DURATION)-1)::int >= 5
      AND duration IS NOT NULL
	  AND POSITION('S' IN DURATION)> 0
ORDER BY seasons
-- code 2.
SELECT 
     title,
	 SPLIT_PART(duration,' ',1)::int AS seasons
FROM netflix
WHERE type = 'TV Show'
      AND duration IS NOT NULL
	  AND SPLIT_PART(duration,' ',1)::int > 5
ORDER BY seasons

-- SPLIT_PART - string function in PostgreSQL that splits a string into parts using a delimiter and returns
-- a specific part by position.
-- string -	The full text you want to split
-- delimiter -	The character(s) used to split the string
-- position	- The part number you want to return (1-based index)
SELECT
   SPLIT_PART('Apple Banana Cherry',' ',2)
   
-- Problem 9. Count the number of content items in each genre
SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in,','))) as genre,-- as there are 3 genre for one type
       COUNT(*) AS total_count
FROM netflix
GROUP BY genre
ORDER BY total_count DESC

-- Problem 10. i) How much content was added to Netflix each year from India?
--            ii) Find the average number of Indian content added per year
--           iii) List each year with the total number of Indian titles added to Netflix, and calculate the
--                percentage contribution of that year's titles to the total Indian content on the platform.

-- code i)How much content was added to Netflix each year from India?
SELECT 
      EXTRACT(YEAR FROM TO_DATE(date_added, 'MONTH DD, YYYY')) AS year,
	  COUNT(*) as content
FROM netflix
WHERE country = 'India'
GROUP BY 1 -- or we can write GROUP BY year
ORDER BY year

-- code ii) Calculate the average number of Indian movies and TV shows added to Netflix each year,
-- based on the date they were added.
SELECT
     ROUND(AVG(content), 0)-- 0 means how many digit till I want to round the avg value if I wrote 
	                       -- 1 there then it would be 162.0
FROM (SELECT 
           EXTRACT(YEAR FROM TO_DATE(date_added, 'MONTH DD, YYYY')) AS year,
	       COUNT(*) as content
      FROM netflix
      WHERE country = 'India'
      GROUP BY 1 -- or we can write GROUP BY year
      ORDER BY year
) 

-- code iii) List each year with the total number of Indian titles added to Netflix,
-- and calculate the percentage contribution of that year's titles to the total Indian content on the platform.
SELECT
     EXTRACT(YEAR FROM TO_DATE(date_added, 'MONTH DD, YYYY')) AS year,
	 COUNT(*),
	 ROUND
	 (COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
	 ,2) AS content_contribution
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY year

  -- eg
  -- Display all the  countries that have released the content 
  -- as some content is releases by many countries so they are in string so we separated them and then made a list
  SELECT TRIM(UNNEST(STRING_TO_ARRAY(country,','))) as new_country
  FROM netflix 
  GROUP BY new_country

  -- Display all the content and release year for content released from India
  SELECT title,
         release_year
  FROM netflix
  WHERE country = 'India'
        

-- Problem 11.  List all the movies that are documentaries.
SELECT title , listed_in
FROM netflix
WHERE type = 'Movie'
      AND listed_in ILIKE '%documentaries%' -- ILIKE used to see if the content in between % is present

   -- eg
   -- List all the content/title that are documentaries.It is difficult to use this is subquery for solving 
   -- as where makes a problem so we udes diff way
   SELECT title, list
   FROM(
        SELECT title,
        TRIM(UNNEST(STRING_TO_ARRAY(listed_in,','))) as list
        FROM netflix
       )
   WHERE list = 'Documentaries'
   --
   SELECT title , listed_in
   FROM netflix
   WHERE type = 'Movie'
         AND listed_in ILIKE '%documentaries%'
		 
-- Problem 12. Find all content without a director
SELECT title, director
FROM netflix
WHERE director IS NULL

-- Problem 13. Find how many movies 'Salman Khan' appeared in last 10 years
SELECT title, release_year, casts
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
      AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- Problem 14. Find the top 10 actors who have appeared in the highest number of movies prodeuced in India.
SELECT
     TRIM(UNNEST(STRING_TO_ARRAY(casts,','))) as actors,
	 COUNT(*) as total_count
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY actors
ORDER BY total_count DESC
LIMIT 10

-- Problem 15. Categorize the content based on the presence of the keywords like 'kill' and 'voilence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. 
-- Count how many items fall into each category.

-- The WITH clause creates a temporary table (new_table) with a category column based on keywords
WITH new_table AS(
 SELECT *,
    CASE
       WHEN description ILIKE '%kill%'
         OR description ILIKE '%voilence%' THEN 'bad_content'
	   ELSE 'Good_content'
    END AS category
 FROM netflix
)
SELECT
      category,
	  COUNT(*) as total_content
FROM new_table
GROUP BY category--1


