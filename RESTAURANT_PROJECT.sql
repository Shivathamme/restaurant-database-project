CREATE DATABASE RESTAURANTSDB;
USE RESTAURANTSDB;
CREATE TABLE consumers (
    Consumer_ID VARCHAR(10) PRIMARY KEY,
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    Latitude DECIMAL(10,7),
    Longitude DECIMAL(10,7),
    Smoker VARCHAR(10),
    Drink_Level VARCHAR(50),
    Transportation_Method VARCHAR(50),
    Marital_Status VARCHAR(20),
    Children VARCHAR(20),
    Age INT,
    Occupation VARCHAR(50),
    Budget VARCHAR(10)
);

CREATE TABLE restaurants (
    Restaurant_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    Zip_Code VARCHAR(10),
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    Alcohol_Service VARCHAR(50),
    Smoking_Allowed VARCHAR(50),
    Price VARCHAR(10),
    Franchise VARCHAR(5),
    Area VARCHAR(10),
    Parking VARCHAR(50)
);
SELECT * FROM RESTAURANTS;

CREATE TABLE restaurant_cuisine (
    Restaurant_ID INT,
    Cuisine VARCHAR(255),
    PRIMARY KEY (Restaurant_ID, Cuisine),
    FOREIGN KEY (Restaurant_ID) REFERENCES restaurants(Restaurant_ID)
);
SELECT * FROM RESTAURANT_CUISINE;
CREATE TABLE consumer_preferences (
    Consumer_ID VARCHAR(10),
    Preferred_Cuisine VARCHAR(255),
    PRIMARY KEY (Consumer_ID, Preferred_Cuisine),
    FOREIGN KEY (Consumer_ID) REFERENCES consumers(Consumer_ID)
);
SELECT * FROM CONSUMER_PREFERENCES;

CREATE TABLE ratings (
    Consumer_ID VARCHAR(10),
    Restaurant_ID INT,
    Overall_Rating INT,
    Food_Rating INT,
    Service_Rating INT,
    PRIMARY KEY (Consumer_ID, Restaurant_ID),
    FOREIGN KEY (Consumer_ID) REFERENCES consumers(Consumer_ID),
    FOREIGN KEY (Restaurant_ID) REFERENCES restaurants(Restaurant_ID)
);
SELECT * FROM RATINGS;

-- 1. List all details of consumers who live in the city of 'Cuernavaca'. 
SELECT * FROM CONSUMERS
WHERE CITY = 'CUERNAVACA' ;

-- 2. Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'. 

SELECT CONSUMER_ID,AGE,OCCUPATION FROM CONSUMERS
WHERE OCCUPATION = 'STUDENT' AND SMOKER = 'YES';

-- 3.List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level.
SELECT NAME, CITY,ALCOHOL_SERVICE,PRICE FROM RESTAURANTS
WHERE ALCOHOL_SERVICE = 'WINE & BEER'  AND PRICE = 'MEDIUM' ;

SELECT * FROM RESTAURANTS;

-- 4. Find the names and cities of all restaurants that are part of a 'Franchise'. 
SELECT NAME , CITY FROM RESTAURANTS
WHERE FRANCHISE = 'YES' ;

SELECT * FROM RATINGS;
-- 5.Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory' (which corresponds to a value of 2, according to the data dictionary). 
SELECT CONSUMER_ID,RESTAURANT_ID,OVERALL_RATING FROM RATINGS
WHERE OVERALL_RATING = 2; 

-- JOINs with Subqueries
-- 1.List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.

SELECT R.NAME,R.CITY FROM RESTAURANTS R JOIN RATINGS T ON R.RESTAURANT_ID = T.RESTAURANT_ID WHERE T.OVERALL_RATING = 2;


-- 2.Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'.
SELECT R.CONSUMER_ID, R.AGE FROM CONSUMERS R
JOIN RATINGS T ON R.CONSUMER_ID = T.CONSUMER_ID 
JOIN RESTAURANTS E ON E.RESTAURANT_ID = T.RESTAURANT_ID
WHERE E.CITY = 'SAN LUIS POTOSI' ;

-- 3.List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
SELECT R.NAME FROM RESTAURANTS R 
JOIN RESTAURANT_CUISINE T ON R.RESTAURANT_ID = T.RESTAURANT_ID 
JOIN RATINGS E ON E.RESTAURANT_ID = T.RESTAURANT_ID
WHERE T.CUISINE = 'MEXICAN' AND E.CONSUMER_ID = 'U1001' ;


-- 4.Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
SELECT C.* FROM CONSUMERS C 
JOIN consumer_preferences R ON R.CONSUMER_ID = C.CONSUMER_ID
WHERE R.PREFERRED_CUISINE = 'AMERICAN' AND C.BUDGET = 'MEDIUM' ;


-- 5.List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants
SELECT C.NAME ,C.CITY FROM RESTAURANTS C 
JOIN RATINGS R ON R.RESTAURANT_ID = C.RESTAURANT_ID
WHERE FOOD_RATING < (SELECT AVG(FOOD_RATING) FROM RATINGS);

SELECT * FROM RATINGS;
-- 6.Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but have NOT rated any restaurant that serves 'Italian' cuisine.
SELECT DISTINCT C.CONSUMER_ID,C.AGE,C.OCCUPATION FROM CONSUMERS C
JOIN RATINGS R ON R.CONSUMER_ID = C.CONSUMER_ID
JOIN RESTAURANT_CUISINE E ON E.RESTAURANT_ID = R.RESTAURANT_ID 
WHERE E.CUISINE != 'ITALIAN' AND R.OVERALL_RATING <= 1 ;


-- 7.List restaurants (Name) that have received ratings from consumers older than 30.
SELECT R.NAME FROM RESTAURANTS R
JOIN RATINGS E ON E.RESTAURANT_ID = R.RESTAURANT_ID
JOIN CONSUMERS C ON C.CONSUMER_ID = E.CONSUMER_ID
WHERE C.AGE < 30 AND E.OVERALL_RATING <= 1;


-- 8.Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).
SELECT C.CONSUMER_ID,C.OCCUPATION FROM CONSUMERS C 
JOIN CONSUMER_PREFERENCES E ON E.CONSUMER_ID = C.CONSUMER_ID
JOIN RATINGS R ON R.CONSUMER_ID = E.CONSUMER_ID
WHERE R.OVERALL_RATING <= 1 AND E.PREFERRED_CUISINE = 'MEXICAN' ;


-- 9.List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city where at least one 'Student' consumer lives.
SELECT R.NAME, R.CITY FROM RESTAURANTS R 
JOIN RESTAURANT_CUISINE E ON E.RESTAURANT_ID = R.RESTAURANT_ID
JOIN RATINGS C ON C.RESTAURANT_ID = E.RESTAURANT_ID
JOIN CONSUMERS A ON A.CONSUMER_ID = C.CONSUMER_ID
WHERE CUISINE = 'PIZZERIA' AND OCCUPATION = 'STUDENT' ;

SELECT * FROM RESTAURANTS;
-- 10.Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.
SELECT C.CONSUMER_ID,C.AGE FROM CONSUMERS C
JOIN RATINGS E ON E.CONSUMER_ID = C.CONSUMER_ID 
JOIN RESTAURANTS R ON R.RESTAURANT_ID = E.RESTAURANT_ID 
WHERE C.DRINK_LEVEL = 'SOCIAL DRINKERS' AND R.PARKING = 'NO' ;

-- Emphasizing WHERE Clause and Order of Execution
-- 1.List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. Show only students who have rated more than 2 restaurants.
SELECT C.CONSUMER_ID, COUNT(DISTINCT T.RESTAURANT_ID) AS 'COUNT OF RESTAURANT RATED' FROM CONSUMERS C
JOIN RATINGS T ON C.CONSUMER_ID = T.CONSUMER_ID
WHERE C.OCCUPATION = 'STUDENT'
GROUP BY C.CONSUMER_ID
HAVING COUNT(DISTINCT T.RESTAURANT_ID) >2;

/* 2.We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division). List the Consumer_ID, Age, 
and this calculated Engagement_Score, but only for consumers whose Engagement_Score would be exactly 2 and who use 'Public' transportation.*/
SELECT CONSUMER_ID, AGE,(AGE/10) AS ENGAGEMENT_SCORE FROM CONSUMERS WHERE (AGE/10) = 2 AND TRANSPORTATION_METHOD = 'PUBLIC' ;

/* 3.For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name, City, and its calculated average Overall_Rating, 
but only for restaurants located in 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.*/
SELECT R.NAME,R.CITY,AVG(T.OVERALL_RATING) AS AVG_RATING FROM RESTAURANTS R 
JOIN RATINGS T ON R.RESTAURANT_ID = T.RESTAURANT_ID
WHERE R.CITY = 'CUERNAVACA'
GROUP BY R.NAME
HAVING AVG(T.OVERALL_RATING) > 1.0;

/*  Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any restaurant is equal to their Service_Rating for that same restaurant,
 but only consider ratings where the Overall_Rating was 2.*/
 SELECT C.CONSUMER_ID,C.AGE FROM CONSUMERS C 
 JOIN RATINGS T ON C.CONSUMER_ID = T.CONSUMER_ID
 WHERE C.MARITAL_STATUS = 'MARRIED'
 AND T.FOOD_RATING = T.SERVICE_RATING
 AND T.OVERALL_RATING = 2;
 
 /* List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers who are 'Employed' and have given a Food_Rating of 0 to at 
 least one restaurant located in 'Ciudad Victoria'.*/
 SELECT C.CONSUMER_ID,C.AGE,R.NAME FROM CONSUMERS C 
 JOIN RATINGS T ON C.CONSUMER_ID = T.CONSUMER_ID
 JOIN RESTAURANTS R ON R.RESTAURANT_ID = T.RESTAURANT_ID
 WHERE C.OCCUPATION = 'EMPLOYED'
 AND T.FOOD_RATING = 0 AND R.CITY = 'CIUDAD VICTORIA' ;
 
 -- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures
/*1. Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, Age, and the Name of any Mexican restaurant they have rated with 
an Overall_Rating of 2.*/

WITH MEX_REST AS (SELECT CONSUMER_ID,AGE FROM CONSUMERS WHERE CITY = 'SAN LUIS POTOSI')
SELECT DISTINCT C.CONSUMER_ID, C.AGE, R.NAME AS REST_NAME,RC.CUISINE FROM MEX_REST C
JOIN RATINGS T ON C.CONSUMER_ID = T.CONSUMER_ID
JOIN RESTAURANTS R ON T.RESTAURANT_ID = R.RESTAURANT_ID
JOIN RESTAURANT_CUISINE RC ON R.RESTAURANT_ID = RC.RESTAURANT_ID 
WHERE RC.CUISINE='MEXICAN' AND T.OVERALL_RATING = 2;

/* 2.For each Occupation, find the average age of consumers. Only consider consumers who have made at least one rating. 
(Use a derived table to get consumers who have rated).*/
SELECT C.OCCUPATION,AVG(C.AGE) AS AVG_AGE
FROM CONSUMERS C
JOIN (SELECT DISTINCT CONSUMER_ID FROM RATINGS) R ON C.CONSUMER_ID = R.CONSUMER_ID
GROUP BY C.OCCUPATION;

/* Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings within each restaurant based on Overall_Rating (highest first).
 Display Restaurant_ID, Consumer_ID, Overall_Rating, and the RatingRank.*/
 WITH MY_RATING AS (
 SELECT R.RESTAURANT_ID,T.CONSUMER_ID,T.OVERALL_RATING ,R.CITY,
 CASE OVERALL_RATING
 WHEN 2 THEN 'HIGH'
 WHEN 1 THEN 'MEDIUM'
 ELSE 'LOW'
 END AS RATINGRANK 
 FROM RATINGS T
 JOIN RESTAURANTS R ON T.RESTAURANT_ID = R.RESTAURANT_ID
 )
 SELECT RESTAURANT_ID, CONSUMER_ID OVERALL_RATING, RATINGRANK FROM MY_RATING WHERE CITY = 'CUERNAVACA' ORDER BY OVERALL_RATING DESC;

 /* For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and also display the average Overall_Rating given by that specific 
 consumer across all their ratings.*/
 
SELECT R.CONSUMER_ID,R.RESTAURANT_ID,R.OVERALL_RATING,AVG(R.OVERALL_RATING) OVER (PARTITION BY R.CONSUMER_ID) AS AVG_RATING_BY_CONSUMERM FROM RATINGS R;

/* 5.Using a CTE, identify students who have a 'Low' budget. Then, for each of these students, list their top 3 most preferred cuisines based on the order 
they appear in the Consumer_Preferences table (assuming no explicit preference order, use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER)*/

WITH LowBudgetStudents AS ( SELECT Consumer_ID FROM Consumers WHERE Occupation = 'Student' AND Budget = 'Low'),
RankedPreferences AS ( SELECT cp.Consumer_ID, cp.Preferred_Cuisine, ROW_NUMBER() OVER ( PARTITION BY cp.Consumer_ID ORDER BY cp.Consumer_ID, cp.Preferred_Cuisine) AS rn
FROM Consumer_Preferences cp
JOIN LowBudgetStudents lbs ON cp.Consumer_ID = lbs.Consumer_ID)
SELECT Consumer_ID, Preferred_Cuisine
FROM RankedPreferences
WHERE rn <= 3
ORDER BY Consumer_ID, rn;

/* 6. Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating, and the Overall_Rating of the next 
restaurant they rated (if any), ordered by Restaurant_ID (as a proxy for time if rating time isn't available). Use a derived table to filter for the consumer's 
ratings first.*/

SELECT 
    dt.Restaurant_ID,
    dt.Overall_Rating,
    LEAD(dt.Overall_Rating) OVER (ORDER BY dt.Restaurant_ID) AS Next_Rating
FROM (
    SELECT Restaurant_ID, Overall_Rating
    FROM Ratings
    WHERE Consumer_ID = 'U1008'
) AS dt
ORDER BY dt.Restaurant_ID;

/* 7.Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, and City of all Mexican restaurants that have an average Overall_Rating 
greater than 1.5. */

CREATE VIEW HighlyRatedMexicanRestaurants AS
SELECT 
    R.Restaurant_ID,
    R.Name,
    R.City
FROM Restaurants R
JOIN Ratings RT 
    ON R.Restaurant_ID = RT.Restaurant_ID
JOIN Restaurant_Cuisine RC 
    ON RC.Restaurant_ID = R.Restaurant_ID
WHERE RC.Cuisine = 'Mexican'
GROUP BY R.Restaurant_ID, R.Name, R.City
HAVING AVG(RT.Overall_Rating) > 1.5;

select * from HighlyRatedMexicanRestaurants;

/* 8. First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, using a CTE to find consumers who prefer 'Mexican' cuisine, 
list those consumers (Consumer_ID) who have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.*/

WITH MexicanPrefConsumers AS (
    SELECT DISTINCT Consumer_ID
    FROM Consumer_Preferences
    WHERE Preferred_Cuisine = 'Mexican'
)
SELECT m.Consumer_ID
FROM MexicanPrefConsumers m
WHERE NOT EXISTS (
    SELECT 1
    FROM Ratings rt
    JOIN HighlyRatedMexicanRestaurants h
        ON rt.Restaurant_ID = h.Restaurant_ID
    WHERE rt.Consumer_ID = m.Consumer_ID
);

/* 9. Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and a minimum Overall_Rating as input. It should return the Consumer_ID, 
Overall_Rating, Food_Rating, and Service_Rating for that restaurant where the Overall_Rating meets or exceeds the threshold.*/

DELIMITER $$
CREATE PROCEDURE GetRestaurantRatingsAboveThreshold (
    IN in_Restaurant_ID INT,
    IN in_MinRating DECIMAL(3,1)
)
BEGIN
    SELECT 
        Consumer_ID,
        Overall_Rating,
        Food_Rating,
        Service_Rating
    FROM Ratings
    WHERE Restaurant_ID = in_Restaurant_ID
      AND Overall_Rating >= in_MinRating;
END $$
DELIMITER ;
select * from restaurants;
CALL GetRestaurantRatingsAboveThreshold(132560, 1.0);

/*10 Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. If there are ties in rating, include all tied restaurants. 
Display Cuisine, Restaurant_Name, City, and Overall_Rating.*/

SELECT Cuisine, Restaurant_Name, City, Overall_Rating
FROM (
    SELECT 
        RC.Cuisine,
        R.Name AS Restaurant_Name,
        R.City,
        AVG(rt.Overall_Rating) AS Overall_Rating,
        RANK() OVER (PARTITION BY RC.Cuisine ORDER BY AVG(rt.Overall_Rating) DESC) AS rnk
    FROM Restaurants R
    JOIN Ratings rt 
        ON R.Restaurant_ID = rt.Restaurant_ID
    JOIN Restaurant_Cuisine RC 
        ON R.Restaurant_ID = RC.Restaurant_ID
    GROUP BY RC.Cuisine, R.Name, R.City
) ranked
WHERE rnk <= 2
ORDER BY Cuisine, Overall_Rating DESC;

/*11. First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. Then, using this view and a CTE, find the top 5
 consumers by their average overall rating. For these top 5 consumers, list their Consumer_ID, their average rating, and the number of 'Mexican' restaurants they 
 have rated. */


-- 1 Create or replace the view for consumer average ratings
CREATE OR REPLACE VIEW ConsumerAverageRatings AS
SELECT 
    Consumer_ID,
    AVG(Overall_Rating) AS Avg_Overall_Rating
FROM Ratings
GROUP BY Consumer_ID;

-- 2️ Single query using CTE to get top 5 consumers and count Mexican restaurants rated
WITH TopConsumers AS (
    SELECT Consumer_ID, Avg_Overall_Rating
    FROM ConsumerAverageRatings
    ORDER BY Avg_Overall_Rating DESC
    LIMIT 5
)
SELECT 
    tc.Consumer_ID,
    tc.Avg_Overall_Rating,
    COUNT(rc.Restaurant_ID) AS Mexican_Restaurants_Rated
FROM TopConsumers tc
LEFT JOIN Ratings rt
    ON tc.Consumer_ID = rt.Consumer_ID
LEFT JOIN Restaurant_Cuisine rc
    ON rt.Restaurant_ID = rc.Restaurant_ID
    AND rc.Cuisine = 'Mexican'
GROUP BY tc.Consumer_ID, tc.Avg_Overall_Rating
ORDER BY tc.Avg_Overall_Rating DESC;

/* 12.Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input.

The procedure should:
1 .Determine the consumer's "Spending Segment" based on their Budget:
'Low' -> 'Budget Conscious'
'Medium' -> 'Moderate Spender'
'High' -> 'Premium Spender'
NULL or other -> 'Unknown Budget'*/

DELIMITER $$

CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance(IN in_Consumer_ID VARCHAR(10))
BEGIN
    SELECT 
        Consumer_ID,
        CASE 
            WHEN Budget = 'Low' THEN 'Budget Conscious'
            WHEN Budget = 'Medium' THEN 'Moderate Spender'
            WHEN Budget = 'High' THEN 'Premium Spender'
            ELSE 'Unknown Budget'
        END AS Spending_Segment
    FROM Consumers
    WHERE Consumer_ID = in_Consumer_ID;
END $$

DELIMITER ;

CALL GetConsumerSegmentAndRestaurantPerformance('U1001');

/* 2.For all restaurants rated by this consumer:
List the Restaurant_Name.
The Overall_Rating given by this consumer.
The average Overall_Rating this restaurant has received from all consumers (not just the input consumer).
A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 'At Average', or 'Below Average' compared to the restaurant's overall average rating.
Rank these restaurants for the input consumer based on the Overall_Rating they gave (highest rating = rank 1).*/

DELIMITER $$

CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance(IN in_Consumer_ID VARCHAR(10))
BEGIN
    -- Step 1: Show consumer's spending segment
    SELECT 
        Consumer_ID,
        CASE 
            WHEN Budget = 'Low' THEN 'Budget Conscious'
            WHEN Budget = 'Medium' THEN 'Moderate Spender'
            WHEN Budget = 'High' THEN 'Premium Spender'
            ELSE 'Unknown Budget'
        END AS Spending_Segment
    FROM Consumers
    WHERE Consumer_ID = in_Consumer_ID;

    -- Step 2: Restaurants rated by this consumer with performance comparison
    SELECT 
        r.Name AS Restaurant_Name,
        cr.Overall_Rating AS Consumer_Rating,
        AVG(rt.Overall_Rating) AS Avg_Restaurant_Rating,
        CASE
            WHEN cr.Overall_Rating > AVG(rt.Overall_Rating) THEN 'Above Average'
            WHEN cr.Overall_Rating = AVG(rt.Overall_Rating) THEN 'At Average'
            ELSE 'Below Average'
        END AS Performance_Flag,
        RANK() OVER (ORDER BY cr.Overall_Rating DESC) AS Consumer_Rank
    FROM Ratings cr
    JOIN Restaurants r ON cr.Restaurant_ID = r.Restaurant_ID
    JOIN Ratings rt ON cr.Restaurant_ID = rt.Restaurant_ID
    WHERE cr.Consumer_ID = in_Consumer_ID
    GROUP BY r.Restaurant_ID, r.Name, cr.Overall_Rating
    ORDER BY cr.Overall_Rating DESC;
END $$

DELIMITER ;

CALL GetConsumerSegmentAndRestaurantPerformance('U1008');
