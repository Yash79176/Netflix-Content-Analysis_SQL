# Netflix-Content-Analysis_SQL
SQL Project
Analysis of Netflix Movies and TV Shows from across the world was done using PostgreSQL.
![Netflix_Logo](https://github.com/Yash79176/Netflix-Content-Analysis_SQL/blob/main/NETFLIX_LOGO.jpg)

## Objective 
- Analyze the type of content that is availble on Netflix as Movies and TV Shows.
- Identify the most common ratings for Movies and TV Shows.
- List and Analyze the contents based on the release year, country, duration, casts and director.
- Categorize the content based on specific criteria such as genre, actors etc.

## Dataset
- The dataset for this project was sourced from the Kaggle dataset:
- Dataset Link - [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
