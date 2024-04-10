DROP TABLE IF EXISTS OLYMPICS_HISTORY;
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY
(
	id INT,
	name VARCHAR,
	sex VARCHAR,
	age VARCHAR,
	height VARCHAR,
	weight VARCHAR,
	team VARCHAR,
	noc VARCHAR,
	games VARCHAR,
	year INT,
	season VARCHAR,
	city VARCHAR,
	sport VARCHAR,
	event VARCHAR,
	medal VARCHAR
);

DROP TABLE IF EXISTS OLYMPICS_HISTORY_NOC_REGION;
CREATE TABLE IF NOT EXISTS OLYMPICS_HISTORY_NOC_REGION
(
	noc VARCHAR,
	region VARCHAR,
	notes VARCHAR
);

Select * from OLYMPICS_HISTORY;
Select * from OLYMPICS_HISTORY_NOC_REGION;

--1. How many olympics games have been held?
Select count(distinct games) as total_games
from OLYMPICS_HISTORY;

--2. List down all Olympics games held so far.
Select distinct games as list_of_games
from OLYMPICS_HISTORY;

--3. Mention the total no of nations who participated in each olympics game?
Select oh.games, count(distinct ohr.region) as nations_participated
from OLYMPICS_HISTORY oh
join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
group by oh.games;

--4. Which year saw the highest and lowest no of countries participating in olympics?
with all_countries as
    (Select oh.games, count(distinct ohr.region) as total_countries
	from OLYMPICS_HISTORY oh
	join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
	group by oh.games)
select distinct
concat(first_value(games) over(order by total_countries)
, ' - '
, first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
concat(first_value(games) over(order by total_countries desc)
, ' - '
, first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
from all_countries
order by 1;

--5.  Which nation has participated in all of the olympic games?
Select ohr.region nation, count(distinct oh.games) games_played
from OLYMPICS_HISTORY oh
join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
group by ohr.region
having count(distinct oh.games) = (Select count(distinct games)
								  from olympics_history
								  where season = 'summer');
								  
--6. Identify the sport which was played in all summer olympics.
with cte as
	(Select sport, count(distinct year) as games_played
	from  olympics_history
	where season = 'Summer'
	group by sport)
select *, (Select max(games_played) from cte) total_games
from cte
where games_played = (Select max(games_played)
					 from cte);
					 
--7. Which Sports were just played only once in the olympics?
with cte as
	(Select sport, count(distinct games) as no_of_games
	from olympics_history
	group by sport)
Select distinct c.sport, c.no_of_games, oh.games
from cte c
join OLYMPICS_HISTORY oh on c.sport = oh.sport
where c.no_of_games = 1

--8. Fetch the total no of sports played in each olympic games.
Select games, count(distinct sport) no_of_sports
from olympics_history
group by games
order by 2 desc;

--9. Fetch oldest athletes to win a gold medal.
With cte as
	(Select distinct name, age::int
	from olympics_history
	where medal like 'Gold'
	and age != 'NA')
Select *
from cte
where age = (Select max(age)
	  from cte);
	  
--10. Find the Ratio of male and female athletes participated in all olympic games.
With cte as
	(Select id, sex
	from olympics_history)
Select
concat(
round(Sum(case when sex = 'F' then 1.00 else 0 end) / Sum(case when sex = 'F' then 1.00 else 0 end), 2),
'/',
round(Sum(case when sex = 'M' then 1.00 else 0 end) / Sum(case when sex = 'F' then 1.00 else 0 end), 2)) gender_ratio
from cte;

--11. Fetch the top 5 athletes who have won the most gold medals.
with cte as
	(Select id, name, count(medal) as medals_won
	from olympics_history
	where medal like 'Gold'
	group by id, name)
Select *
from cte
where medals_won in (Select distinct medals_won
				    from cte
					order by medals_won desc
					limit 5)
order by medals_won desc;

--12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
with cte as
	(Select id, name, count(medal) as medals_won
	from olympics_history
	where medal not like 'NA'
	group by id, name)
Select *
from cte
where medals_won in (Select distinct medals_won
				    from cte
					order by medals_won desc
					limit 5)
order by medals_won desc;

--13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
Select ohr.region country, count(oh.medal) as medals_won
from OLYMPICS_HISTORY oh
join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
where medal <> 'NA'
group by ohr.region
order by medals_won desc
limit 5;

--14. List down total gold, silver and broze medals won by each country.
Select ohr.region country,
sum(case when medal like 'Gold' then 1 else 0 end) gold,
sum(case when medal like 'Silver' then 1 else 0 end) silver,
sum(case when medal like 'Bronze' then 1 else 0 end) bronze
from OLYMPICS_HISTORY oh
join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
where medal <> 'NA'
group by ohr.region
order by gold desc, silver desc, bronze desc;

--15. List down total gold, silver and broze medals won by each country corresponding to each olympic games.
Select oh.games, ohr.region country,
sum(case when medal like 'Gold' then 1 else 0 end) gold,
sum(case when medal like 'Silver' then 1 else 0 end) silver,
sum(case when medal like 'Bronze' then 1 else 0 end) bronze
from OLYMPICS_HISTORY oh
join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
where medal <> 'NA'
group by ohr.region, oh.games
order by games, country;

--16. Which countries have never won gold medal but have won silver/bronze medals?
with cte as
	(Select ohr.region Country,
	sum(case when medal like 'Gold' then 1 else 0 end) gold,
	sum(case when medal like 'Silver' then 1 else 0 end) silver,
	sum(case when medal like 'Bronze' then 1 else 0 end) bronze
	from OLYMPICS_HISTORY oh
	join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
	group by ohr.region)
select *
from cte
where gold = 0
and (silver > 0 or bronze > 0)
order by silver desc, bronze desc;

--17. In which Sport/event, India has won highest medals.
Select sport, count(1) as medal_won
from OLYMPICS_HISTORY
where medal <> 'NA'
and team = 'India'
group by sport
order by medal_won desc
limit 1;

--18. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
Select ohr.region Country, oh.sport, oh.games, count(1) as medals_won
from OLYMPICS_HISTORY oh
join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
where oh.medal <> 'NA' and ohr.region = 'India' and oh.sport = 'Hockey'
group by ohr.region, oh.games, oh.sport
order by medals_won desc;

--19. Find the average age of players of different countries by sex.
Select ohr.region Country, oh.sex, round(avg(age::int), 2)
from OLYMPICS_HISTORY oh
join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
where age <> 'NA'
group by ohr.region, oh.sex;

--20. Find players with maximum medals from each country.
with cte as
	(Select ohr.region country, oh.name, count(1) as medals
	from OLYMPICS_HISTORY oh
	join OLYMPICS_HISTORY_NOC_REGION ohr on oh.noc = ohr.noc
	where medal <> 'NA'
	group by ohr.region, oh.name)
Select *
from cte
where (country, medals) in (Select country, max(medals)
						  from cte
						  group by country)
order by medals desc, country desc;