SELECT 
    title
FROM
    movie
WHERE
    director = 'Steven Spielberg';  -- 第一题
    
SELECT DISTINCT
    year
FROM
    movie join
    rating using(mID)
WHERE
    stars = 4 OR stars = 5
ORDER BY year ASC;  -- 第二题

SELECT 
    title
FROM
    movie
WHERE
    title NOT IN (SELECT 
            title
        FROM
            movie,
            rating
        WHERE
            movie.mID = rating.mID);  -- 第三题
            
SELECT 
    name
FROM
    reviewer,
    rating
WHERE
    reviewer.rID = rating.rID
        AND ratingDate IS NULL;  -- 第四题
        
SELECT 
    name, title, stars, ratingDate
FROM
    movie,
    rating,
    reviewer
WHERE
    movie.mID = rating.mID
        AND rating.rID = reviewer.rID
ORDER BY name , title , stars ASC; -- 第五题

SELECT 
    Reviewer.name, Movie.title
FROM
    Movie
        JOIN
    (SELECT 
        Rating.mID, Rating.rID, Rating.stars, Rating.ratingDate
    FROM
        Rating, (SELECT 
        Rating.mID,
            Rating.rID,
            MAX(Rating.stars) AS maxStars,
            MAX(Rating.ratingDate) AS maxDate
    FROM
        Rating
    GROUP BY mID , rID
    HAVING COUNT(rId) = 2 AND COUNT(mID) = 2) AS nan
    WHERE
        Rating.mID = nan.mID
            AND Rating.rID = nan.rID
            AND Rating.stars = nan.maxStars
            AND Rating.ratingDate = maxDate) AS nannan ON Movie.mID = nannan.mID
        JOIN
    Reviewer ON Reviewer.rID = nannan.rID; -- 第六题

SELECT 
    name, title
FROM
    rating AS a1,
    rating AS a2,
    movie,
    reviewer
WHERE
    a1.rID = a2.rID AND a1.mID = a2.mID
        AND a1.stars < a2.stars
        AND a1.ratingDate < a2.ratingDate
        AND a1.mID = movie.mID
        AND a1.rID = reviewer.rID; -- 第六题

SELECT 
    title, MAX(stars)
FROM
    (SELECT 
        movie.mID, rating.rID, movie.title, rating.stars
    FROM
        movie, rating
    WHERE
        movie.mID = rating.mID) AS t
GROUP BY t.mID
HAVING COUNT(*) > 0
ORDER BY title ASC; -- 第七题

SELECT 
    title, AVG(stars)
FROM
    (SELECT 
        title, stars
    FROM
        movie
    LEFT JOIN rating USING (mID)) AS t
GROUP BY t.title
ORDER BY AVG(stars) DESC , title ASC; -- 第八题

SELECT 
    name
FROM
    rating
        JOIN
    reviewer USING (rID)
GROUP BY rID
HAVING COUNT(stars) > 2;  -- 第九题

SELECT 
    name
FROM
    rating
        JOIN
    reviewer USING (rID)
GROUP BY rID
HAVING SUM(CASE
    WHEN stars IS NOT NULL THEN 1
    ELSE 0
END) > 2;  -- 第九题

SELECT DISTINCT
    name
FROM
    (movie
    JOIN rating ON movie.mID = rating.mID
    JOIN reviewer ON rating.rID = reviewer.rID)
WHERE
    title = 'Gone with the Wind';  -- 第十题

SELECT 
    name, title, stars
FROM
    movie
        JOIN
    rating ON movie.mID = rating.mID
        JOIN
    reviewer ON rating.rID = reviewer.rID
WHERE
    director = name;  -- 第十一题
    
SELECT title as name from movie
union
select name from reviewer
order by name;  -- 第十二题
    
SELECT DISTINCT
    title
FROM
    (movie
    LEFT JOIN rating ON movie.mID = rating.mID
    LEFT JOIN reviewer ON rating.rID = reviewer.rID)
WHERE
    title NOT IN (SELECT 
            title
        FROM
            (movie
            LEFT JOIN rating ON movie.mID = rating.mID
            LEFT JOIN reviewer ON rating.rID = reviewer.rID)
        WHERE
            name = 'Chris Jackson');  -- 第十三题

select distinct a1.name,a2.name from
reviewer a1,
reviewer a2,
rating a3,
rating a4
where a1.rID=a3.rID and a2.rID=a4.rID and a3.mID=a4.mID and a1.name<a2.name order by a1.name;  -- 第十四题

SELECT 
    a1.name, a1.title, a1.stars
FROM
    (SELECT 
        *
    FROM
        movie
    JOIN rating USING (mID)
    JOIN reviewer USING (rID)) a1
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            (SELECT 
                *
            FROM
                movie
            JOIN rating USING (mID)
            JOIN reviewer USING (rID)) a2
        WHERE
            a2.stars < a1.stars);  -- 第十五题

SELECT 
    title, MAX(stars) - MIN(stars) as 'rating spread'
FROM
    movie
        LEFT JOIN
    rating USING (mID)
GROUP BY mID
ORDER BY (MAX(stars) - MIN(stars)) DESC , title;  -- 第十六题


select
    AVG(a1.stars1) - AVG(a2.stars2)
from 
(select avg(stars) as stars1 from rating join movie using(mid) group by title having max(year)>1980) as a1,
(select avg(stars) as stars2 from rating join movie using(mid) group by title having max(year)<1980) as a2;  -- 第十七题
                
SELECT 
    title, director
FROM
    movie
WHERE
    director IN (SELECT 
            director
        FROM
            movie
        GROUP BY director
        HAVING COUNT(*) >= 2)
ORDER BY director , title;  -- 第十八题(1)

SELECT 
    a1.title, a1.director
FROM
    movie a1,
    movie a2
WHERE
    a1.director = a2.director
        AND a1.title <> a2.title
ORDER BY a1.director , a1.title;  -- 第十八题(2)

SELECT 
    avgstar1, title
FROM
    (SELECT 
        title, AVG(stars) avgstar1, AVG(stars) avgstar2
    FROM
        movie
    JOIN rating USING (mID)
    GROUP BY mID) AS t1
WHERE
    avgstar1 = (SELECT 
            MAX(avgstar2)
        FROM
            (SELECT 
                title, AVG(stars) avgstar1, AVG(stars) avgstar2
            FROM
                movie
            JOIN rating USING (mID)
            GROUP BY mID) AS t2);  -- 第十九题
            
SELECT 
    avgstar1, title
FROM
    (SELECT 
        title, AVG(stars) avgstar1, AVG(stars) avgstar2
    FROM
        movie
    JOIN rating USING (mID)
    GROUP BY mID) AS t1
WHERE
    avgstar1 = (SELECT 
            MIN(avgstar2)
        FROM
            (SELECT 
                title, AVG(stars) avgstar1, AVG(stars) avgstar2
            FROM
                movie
            JOIN rating USING (mID)
            GROUP BY mID) AS t2);  -- 第二十题
            
SELECT 
    director, title, MAX(stars)
FROM
    (SELECT 
        *
    FROM
        movie
    LEFT JOIN rating USING (mID)
    WHERE
        director IS NOT NULL) a1
GROUP BY director;  -- 第二十一题
