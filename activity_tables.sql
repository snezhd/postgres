CREATE DATABASE activity_tables;

\connect activity_tables

CREATE TABLE sport_activities (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    age INTEGER,
    activity VARCHAR(50),
    happiness_code VARCHAR(1)
);

INSERT INTO sport_activities (first_name, last_name,age, activity, 
            happiness_code) 
    VALUES  ('Peter', 'Yovchev', 24, 'running', 'A'),
            ('Sara', 'Popova', 22, 'dancing', 'B'),
            ('Petia', 'Ivanova', 23, 'running', 'B'),
            ('Vlado', 'Ivanov', 25, 'swimming', 'C'),
            ('Hristo', 'Nikolov', 24, 'jumping', 'D'),
            ('Katia', 'Yordanova', 25, 'running', 'E'),
            ('Mery', 'Popova', 26, 'dancing', 'A'),
            ('Ivan', 'Conev', 22, 'hiking', 'E'),
            ('Ani', 'Popova', 23, 'jumping', 'F'),
            ('Antoanet', 'Hristova', 26, 'swimming', 'B'),
            ('Kamen', 'Hristov', 25, 'swimming', 'A'),
            ('Maria', 'Dimitrova', 21, 'dancing', 'C'),
            ('Ivaila', 'Kumuva', 23, 'hiking', 'D'),
            ('Simona', 'Todorova', 24, 'running', 'A'),
            ('Teodor', 'Kostadinov', 25, 'jumping', 'E'),
            ('Miro', 'Stefanov', 26, 'running', 'C'),
            ('Plamena', 'Ivanova', 23, 'dancing', 'B'),
            ('Michaela', 'Yovcheva', 24, 'hiking', 'C'),
            ('Plamen', 'Todorov', 25, 'running', 'A'),
            ('Ivailo', 'Stefanov', 24, 'jumping', 'D'),
            ('Martin', 'Iliev', 30, 'hiking', 'A'),
            ('Kalin', 'Petrov', 29, 'running', 'B'),
            ('Lara', 'Spasova', 28, 'dancing', 'C'),
            ('Klara', 'Dimitrova', 26, 'running', 'B'),
            ('Polia', 'Hristova', 27, 'swimming', 'E');
                                                


CREATE TABLE happiness_rate (
    happiness_code CHAR NOT NULL,
    meaning Varchar(15)
);

INSERT INTO happiness_rate VALUES
    ('A', 'really happy'),
    ('B', 'happy'),
    ('C', 'satisfied'),
    ('D', 'OK'),
    ('E', 'tired'),
    ('D', 'disappointed');



CREATE TABLE frequencies (
    id SERIAL PRIMARY KEY,
    sport_activities_id INTEGER REFERENCES sport_activities,
    duration_min REAL,
    weekly INTEGER,
    calories REAL
);

INSERT INTO frequencies (sport_activities_id, duration_min, weekly, calories) 
    VALUES  (5, 60, 2, 400),
            (10, 50, 3, 300),
            (11, 20, 4, 180),
            (9, 45, 2, 350),
            (8, 25, 1, 259),
            (6, 35, 2, 280),
            (1, 15, 5, 150),
            (3, 70, 1, 680),
            (12, 30, 4, 500),
            (16, 20, 3, 400),
            (15, 25, 2, 410),
            (7, 60, 2, 600),
            (18, 40, 3, 650),
            (4, 15, 3, 200),
            (20, 5, 5, 150);


-- Basic queries


SELECT duration_min, calories 
    FROM frequencies
    ORDER BY duration_min;


SELECT duration_min, calories 
    FROM frequencies
    WHERE calories > 259
    ORDER BY duration_min;


SELECT duration_min, AVG(calories) 
    FROM frequencies
    GROUP BY duration_min;


SELECT MAX(weekly),
       AVG(calories) 
    FROM frequencies
    GROUP BY weekly
    ORDER BY weekly ASC;


SELECT sport_activities_id, duration_min, calories 
    FROM frequencies
    WHERE duration_min > 30 AND calories > 250
    ORDER BY sport_activities_id DESC;


SELECT first_name, last_name, age, activity 
    FROM sport_activities
    WHERE activity 
    IN ('running', 'hiking', 'jumping');


SELECT  sport_activities.first_name, 
        sport_activities.activity, 
        frequencies.weekly, 
        frequencies.calories
    FROM sport_activities
    JOIN frequencies
    ON sport_activities.id = frequencies.sport_activities_id;




-- Complex queries


SELECT  s.first_name,
        s.last_name,
        s.activity,
        h.meaning AS happy
    FROM sport_activities AS s 
    INNER JOIN happiness_rate AS h 
    ON s.happiness_code = h.happiness_code;


SELECT  s.id,
        s.activity,
        AVG(f.calories)
    FROM sport_activities AS s
    INNER JOIN frequencies AS f
    ON s.id = f.sport_activities_id
    GROUP BY s.id,
             s.activity
    ORDER BY s.id DESC;


SELECT  s.first_name,
        s.age,
        AVG(f.calories) AS avg_calories
    FROM sport_activities AS s
    INNER JOIN frequencies AS f
    ON s.id = f.sport_activities_id
    WHERE s.activity = 'running'
    AND s.age > 23
    GROUP BY s.first_name,
             s.age;


SELECT  s.first_name,
        s.age,
        AVG(f.weekly) AS avg_weekly
    FROM sport_activities AS s
    INNER JOIN frequencies AS f
    ON s.id = f.sport_activities_id
    GROUP BY s.age,
             s.first_name
    HAVING AVG(f.weekly) > 2                -- HAVING filters aggregate results
    ORDER BY s.age ASC;


SELECT  s.id,
        s.first_name,
        s.activity
    FROM sport_activities AS s
    WHERE s.id 
                IN (
                    SELECT sport_activities_id         -- implementing subquery
                    FROM frequencies
                    WHERE weekly > 2
                    );


SELECT  s.first_name,
        s.activity,
        s.age,
        h.meaning AS happy
    FROM sport_activities AS s
    INNER JOIN happiness_rate AS h
    ON s.happiness_code = h.happiness_code
    WHERE s.age >
                  (SELECT AVG(age)
                    FROM sport_activities)
    ORDER BY age DESC;  
