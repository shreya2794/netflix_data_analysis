#  Netflix Data Analysis using SQL

## Overview
This project explores and analyzes the Netflix dataset using SQL. It answers insightful business questions about content trends, genres, countries, durations, and cast/directors by writing and executing well-structured SQL queries.

## Dataset
The data for this project is sourced from the Kaggle dataset:
**Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Objectives
The project aims to:
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Tools & Technologies
- SQL (PostgreSQL)
- pgAdmin or any SQL environment
- Basic knowledge of RDBMS and data analysis

##  Key SQL Concepts Used
- SELECT, GROUP BY, ORDER BY
- DISTINCT, COUNT, RANK, AVG
- CASE, WITH (CTE), EXTRACT, TO_DATE
- String functions: TRIM(), UNNEST(), STRING_TO_ARRAY(), SPLIT_PART(), ILIKE, POSITION(), SUBSTRING()

## Schema
DROP TABLE IF EXISTS netflix;
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

## Queries Solved
- Problem 1. Count number of movies and TV shows.
- Problem 2. Most common rating for each content type.
- Problem 3. List movies released in a specific year.
- Problem 4. Top 5 countries with most content.
- Problem 5. Identify the longest movie by duration.
- Problem 6. Content added in the last 5 years.
- Problem 7. Movies/TV shows by director 'Rajiv Chilaka'.
- Problem 8. TV shows with more than 5 seasons.
- Problem 9. Count of content in each genre.
- Problem 10.Indian content trends:
          i) Year-wise content added from India
          ii) Average content added per year
          iii) Contribution % per year
- Problem 11. All movies that are documentaries.
- Problem 12. Content without a listed director.
- Problem 13. Movies featuring 'Salman Khan' in the last 10 years.
- Problem 14. Top 10 actors in Indian content.
- Problem 15. Content categorized as "Good" or "Bad" based on description keywords.

## Getting Started
To run the analysis:
- Create the netflix table using the provided schema.
- Import Netflix dataset using link provided above.
- Execute the SQL queries in your preferred SQL environment.

##  Developer
**Shreya Dandale**  
B.Tech in Electronics & Telecommunication, JSPM RSCOE Pune (2026)   
🌐 [GitHub](https://github.com/shreya2794) • [LinkedIn](www.linkedin.com/in/shreya-dandale) 

