#select sID from student order by GPA desc limit 5;
#select sID from student order by GPA desc limit 5,5;
#select major from apply where major like 'E_';
#select TRUNCATE(student.GPA,4)FROM student;
#select *,sID from student;
#select sName from student where sName like '_A_';
#SELECT * FROM student WHERE sID not IN(SELECT sID FROM apply)
#select sName as name from student union all select cName as name from college;
#(select sName from student Union select cName from college) order by sName;
#select distinct a1.sID from apply a1,apply a2 where a1.sID=a2.sID and a1.major='CS' and a2.major='EE';
-- select distinct a1.sID from apply a1,apply a2 where a1.sID=a2.sID and a1.major='CS' and a2.major<>'EE';
-- select sID,sName from student where sID in (select sID from apply where major='CS');
-- select GPA from student where sID in (select sID from apply where major='CS') and sID NOT IN (select sID from apply where major='EE');
-- select cName,state from college c1 where exists (select * from college c2 where c1.state=c2.state and c1.cName<>c2.cName);
-- select sName,GPA from student c1 where not exists (select * from student c2 where c2.GPA>c1.GPA);
-- select GPA from student,apply where major='CS';
-- select sName from student s1 where not exists (select * from apply where not exists ());  查询申请了所有学校的学生
-- select avg(GPA) from student where sID in(select sID from apply where major='CS');

SELECT 
    title
FROM
    movie
WHERE
    director = 'Steven Spielberg';  -- 第一题
    
SELECT DISTINCT
    year
FROM
    movie,
    rating
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
        movie, rating
    WHERE
        movie.mID = rating.mID) AS t
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
    
SELECT 
    name,title
FROM
    movie
        JOIN
    rating ON movie.mID = rating.mID
        JOIN
    reviewer ON rating.rID = reviewer.rID order by name,title;  -- 第十二题
    
SELECT DISTINCT
    title
FROM
    (movie
    JOIN rating ON movie.mID = rating.mID
    JOIN reviewer ON rating.rID = reviewer.rID)
WHERE
    title NOT IN (SELECT 
            title
        FROM
            (movie
            JOIN rating ON movie.mID = rating.mID
            JOIN reviewer ON rating.rID = reviewer.rID)
        WHERE
            name = 'Chris Jackson');  -- 第十三题

SELECT 
    a1.name
FROM
    (SELECT 
        *
    FROM
        rating
    JOIN reviewer USING (rID)) AS a1,
    (SELECT 
        *
    FROM
        rating
    JOIN reviewer USING (rID)) AS a2
WHERE
    a1.stars = a2.stars AND a1.mID = a2.mID
        AND a1.rID <> a2.rID
ORDER BY a1.name ASC;  -- 第十四题

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
    title, MAX(stars) - MIN(stars)
FROM
    movie
        JOIN
    rating USING (mID)
GROUP BY mID
ORDER BY (MAX(stars) - MIN(stars)) DESC , title;  -- 第十六题


SELECT 
    AVG(a1.stars) - AVG(a2.stars)
FROM
    (SELECT 
        stars
    FROM
        rating
    WHERE
        mID IN (SELECT 
                mID
            FROM
                movie
            WHERE
                year < 1980)) AS a1,
    (SELECT 
        stars
    FROM
        rating
    WHERE
        mID IN (SELECT 
                mID
            FROM
                movie
            WHERE
                year > 1980)) AS a2;  -- 第十七题
                
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
    JOIN rating USING (mID)
    WHERE
        director IS NOT NULL) a1
GROUP BY director;  -- 第二十一题
