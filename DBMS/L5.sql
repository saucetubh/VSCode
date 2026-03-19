-- Student Solution
-- IMPORTANT: Rename this file to <your_student_id>_Lab5.sql
-- Example: 2021A7PS0001G_Lab5.sql
--
-- Write your SQL queries below
-- Each query should be separated by semicolons
-- If you don't know the answer to a question, just write a semicolon (;)
-- DO NOT COPY '->' character from mysql in solution file !
-- IMPORTANT: Make sure strings and words don't break into new lines, i.e., a complete word should remain in single line.
-- Example of wrong query:(table name breaking into new line)
--      SELECT * FROM PASSE
--      NGERS; 
-- Example of wrong query: (keyword breaking into new line)
--      (SELECT passenger_id FROM PASSENGERS) UNI
--      ON (SELECT passenger_id FROM TICKETS); 

-- Example of wrong query: (string breaking into new line)
--      (SELECT passenger_id FROM PASSENGERS) WHERE name = "John
--      Wick" 

-- Q1: SELECT (without join, must use nested select)
select distinct name,date_of_birth from directors where directorID in (select directorID from movies where genre='Crime' and nationality='Indian') order by date_of_birth;

-- Q2: SELECT (without join, must use nested select)
select distinct name from actors where nationality!='Indian' and actorID in (select actorID from characters_webseries) and actorID not in (select actorID from characters_movies) order by name;

-- Q3: SELECT (without join, must use nested select)
select distinct directorID,name from directors where directorID in (select directorID from movies 
where year(date_of_release) between 2010 and 2020 and box_office_crores >= all (select box_office_crores from movies where year(date_of_release) between 2010 and 2020));

-- Q4: SELECT (without join, must use nested select)
select webseriesID,count(season_number) as no_of_seasons,sum(no_of_episodes) as total_no_of_episodes from seasons where webseriesID in (select webseriesID from characters_webseries where name in ('Ross Geller', 'Sheldon Cooper', 'Penny Hofstadter') or actorID in (select actorID from actors 
where name in ('Bryan Cranston', 'Millie Bobby Brown'))) group by webseriesID order by sum(no_of_episodes) desc;

-- Q5: SELECT (without join, must use nested select)
;

-- Q6: SELECT (must use join, without nested select)
select distinct d.name,d.date_of_birth from directors d join movies m on d.directorID=m.directorID where d.nationality='Indian' and m.genre='Crime' order by date_of_birth;

-- Q7: SELECT (must use join, without nested select)
select distinct a.name from actors a join characters_webseries cw on a.actorID=cw.actorID left join characters_movies cm on a.actorID=cm.actorID where a.nationality!='Indian' and cm.movieID is null order by a.name;

-- Q8: SELECT (must use join, without nested select)
select d.directorID,d.name from directors d join movies m on d.directorID=m.directorID where year(m.date_of_release) between 2010 and 2020 order by m.box_office_crores desc limit 1;

-- Q9: SELECT (must use join, without nested select)
select s.webseriesID,count(s.season_number) as no_of_seasons,sum(s.no_of_episodes) as total_no_of_episodes from seasons s 
join characters_webseries cw on s.webseriesID=cw.webseriesID join actors a on a.actorID=cw.actorID 
where cw.name in ('Ross Geller', 'Sheldon Cooper', 'Penny Hofstadter') or a.name in ('Bryan Cranston', 'Millie Bobby Brown') 
group by s.webseriesID order by sum(s.no_of_episodes) desc;

-- Q10: SELECT (must use join, without nested select)
select cm.name as characterName,m.name as movieName,a.name as playedBy from movies m join characters_movies cm on m.movieID=cm.movieID join actors a on a.actorID=cm.actorID join directors d on d.directorID=m.directorID where d.name='Christopher Nolan' and a.date_of_birth>d.date_of_birth order by cm.name;

-- End of solution
