

-- Netflix Project

-- step 1 create table 
create table netflix
(	show_id VARCHAR(7),
	type VARCHAR (8),
	title VARCHAR (150),
	director VARCHAR (210),
	country VARCHAR (25),
	date_added DATE,
	release_year INT,
	rating VARCHAR (10),
	duration VARCHAR (15),
	listed_in VARCHAR (85)
) ;


-- step 2 import data from csv file 
select * from netflix

-- 15 Business Problems

-- 1.Count the number of movies vs tv shows
-- 2.Find the most common rating for movies and tv shows 
-- 3.List all movies released in a specific year (eg. 2020)
-- 4.Find the top 5 countries with the most content on netflix 
-- 5.Identify the longest movies or tv show duration 
-- 6.Find content added in the last 5 Years
-- 7.Find all the movies/Tv shows by director 'Rajiv chilaka'!
-- 8.list all tv shows with more than 5 seasons 
-- 9.count the number of content items in each genre
-- 10.Find the average release year for content produced in a specific country
-- 11.List all movies that are documentaries 
-- 12.Find all content without a director 

--- solution
-- 1.Count the number of movies vs tv shows
	select 
		sum (case type 
			when 'Movie' then 1 else 0 end) as movie_count,
		sum(case type 
			when 'TV Show' then 1 else 0 end)as tv_shows
	from netflix;

	select type , count (*) as total_content from netflix
	group by type ;

-- 2.Find the most common rating for movies and tv shows 
	select * from (select type , rating ,count(*) ,
	rank() over (partition by type order by count(*) desc) as rnk
	from netflix 
	group by type , rating
	)t
	where rnk = 1;

-- 3.List all movies released in a specific year (eg. 2020)
	select *
	from netflix
	where type = 'Movie' and release_year = 2020

-- 4.Find the top 5 countries with the most content on netflix 
	select country , count(*) as total_content from netflix 
	group by country
	order by count(*) desc 
	limit 5;

-- 5.Identify the longest movies duration 
	select * from netflix 
	where 
	type = 'Movie'
	and duration = (select max(duration) from netflix);

-- 6.Find content added in the last 5 Years
	select * from netflix 
	where date_added >= current_date - interval '5 years';

-- 7.Find all the movies/Tv shows by director 'Rajiv chilaka'!
	select * from netflix 
	where director ilike 'Rajiv Chilaka';

-- 8.list all tv shows with more than 5 seasons 
	select * from netflix 
	where type = 'TV Show' and duration > '5 Seasons';
	
-- 9.count the number of content items in each genre
 select 
  unnest(STRING_TO_ARRAY(listed_in,',')) as genre,
   count (show_id)
 from netflix
group by 1


-- 10.Find each year and the average numbers of content release by india on netflix.
-- return top 5 year with highest avg content release !
	select  country ,extract (year from date_added) as year,
	count (*) as yearly_content,
	round (count(*)::numeric / (select count(*) from netflix where country = 'India')::numeric * 100,2) as avg_content_per_Year
	from netflix 
	where country = 'India'
	group by year, country
	order by count(*) desc 
	limit 5

-- 11.List all movies that are documentaries
select * from netflix 
where listed_in ilike '%documentaries%'

-- 12.Find all content without a director 
	select * from netflix 
	where director = 'Not Given'

	
	