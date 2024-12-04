-- CREATE DATABASE

CREATE DATABASE codex_marketanalysis;


-- USE DATABASE

USE codex_marketanalysis;


-- CREATE dim_cities TABLE

CREATE TABLE dim_cities (
    city_id VARCHAR(10) PRIMARY KEY,
    city VARCHAR(15) NOT NULL,
    tier VARCHAR(10)
);


-- LOAD DATA TO dim_cities TABLE

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\dim_cities.csv'
INTO TABLE dim_cities
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- CREATE dim_respondents TABLE

CREATE TABLE dim_respondents (
    respondent_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    Age VARCHAR(10),
    gender ENUM('Male', 'Female', 'Non-binary'),
    city_id VARCHAR(10)
);


-- LOAD DATA TO dim_respondents TABLE

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\dim_repondents.csv'
INTO TABLE dim_respondents
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ERROR occured for FOREIGN KEY CONSTRAINT

-- TROUBLESHOOTING FOR FOREIGN KEY CONSTRAINT

		SHOW COLUMNS FROM dim_cities;      -- shows the table structure
		SHOW COLUMNS FROM dim_respondents;


		ALTER TABLE dim_respondents
		MODIFY city_id VARCHAR(10) NOT NULL;   -- altered city_id to not have any null values


		SELECT DISTINCT
    (city_id), LENGTH(city_id) AS Length
FROM
    dim_cities
ORDER BY city_id;


		SELECT DISTINCT
    (city_id), LENGTH(city_id) AS Length
FROM
    dim_respondents
ORDER BY city_id;


		UPDATE dim_respondents 
SET 
    city_id = TRIM(city_id);       -- dim_respondents has city_id length as '6' whereas dim_cities has '5'
		-- did not work


		SELECT 
    city_id,
    ASCII(SUBSTRING(city_id, 1, 1)) AS first_char,
    ASCII(SUBSTRING(city_id, LENGTH(city_id), 1)) AS last_char
FROM
    dim_respondents
WHERE
    LENGTH(city_id) = 6;


		UPDATE dim_respondents 
SET 
    city_id = REPLACE(city_id, CHAR(13), '')
WHERE
    LENGTH(city_id) = 6;


		ALTER TABLE dim_respondents
		ADD CONSTRAINT fk_city_id
		FOREIGN KEY (city_id) REFERENCES dim_cities(city_id);
        
-- After the troubleshooting the LOAD DATA command is executed again


-- CREATE fact_survey_responses TABLE

CREATE TABLE fact_survey_responses (
    response_ID INT PRIMARY KEY,
    respondent_ID INT,
    consume_frequency VARCHAR(20),
    consume_time VARCHAR(30),
    consume_reason VARCHAR(30),
    heard_before ENUM('Yes', 'No'),
    brand_perception ENUM('Negative', 'Neutral', 'Positive'),
    general_perception ENUM('Dangerous', 'Effective', 'Healthy', 'Not sure'),
    tried_before ENUM('Yes', 'No'),
    taste_experience INT CHECK (taste_experience BETWEEN 1 AND 5),
    reasons_preventing_trying VARCHAR(50),
    current_brands VARCHAR(20),
    reasons_for_choosing_brands VARCHAR(25),
    improvements_desired VARCHAR(50),
    ingredients_expected VARCHAR(15),
    health_concerns ENUM('Yes', 'No'),
    interest_in_natural_or_organic ENUM('Yes', 'No', 'Not sure'),
    marketing_channels VARCHAR(20),
    packaging_preference VARCHAR(35),
    limited_edition_packaging ENUM('Yes', 'No', 'Not sure'),
    price_range VARCHAR(10),
    purchase_location VARCHAR(30),
    typical_consumption_situations VARCHAR(30),
    FOREIGN KEY (respondent_id)
        REFERENCES dim_respondents (respondent_id)
);


-- LOAD DATA TO fact_survey_responses TABLE

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\fact_survey_responses.csv'
INTO TABLE fact_survey_responses
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- VARCHAR counts white spaces between words. So, the table is altered and the LOAD DATA command is executed again

ALTER TABLE fact_survey_responses
MODIFY consume_time VARCHAR(35);


-- SUCCESSFULLY ALL THE FILES ARE LOADED


-- EXPLORING THE DATA AND TRANSFORMING THE DATA


-- 1. For analysing demographics age, and gender cannot be null

ALTER TABLE dim_respondents
		MODIFY Age VARCHAR(10) NOT NULL,
        MODIFY Gender ENUM('Male', 'Female', 'Non-binary') NOT NULL;

        
-- 2. If Heard_before is 'No' then Tried_before should be 'No'

UPDATE fact_survey_responses 
SET 
    Tried_before = 'No'
WHERE
    Heard_before = 'No';


-- 3. If Tried_before is 'No' then taste_experience should be '0'

UPDATE fact_survey_responses 
SET 
    taste_experience = NULL
WHERE
    tried_before = 'No';
    
    
/*
4. If tried_before is 'Yes' then reasons_preventing_trying should be 'NULL'. 
But, some of them might try the product and choose other brands which is reflected in current_brands. 
Hence, no need to update/modify reasons_preventing_trying.
*/

-- ANALYSIS

-- 1. Demographic Insights 

-- a. Who prefers energy drinks more?  (male/female/non-binary?)

-- overall preference
SELECT 
    gender, COUNT(gender) AS gender_count
FROM
    dim_respondents
GROUP BY gender
ORDER BY gender_count DESC;

-- active or frequent consumers
SELECT 
    d.gender, COUNT(d.gender) AS gender_count
FROM
    dim_respondents d
        JOIN
    fact_survey_responses f ON f.respondent_ID = d.respondent_id
WHERE
    consume_frequency <> 'Rarely'
GROUP BY gender
ORDER BY gender_count DESC;

-- b. Which age group prefers energy drinks more? 

SELECT 
    age, COUNT(age) AS age_count
FROM
    dim_respondents
GROUP BY age
ORDER BY age_count DESC;

-- c. Which age groups are most aware of our brand?

SELECT 
    d.age, COUNT(d.age) AS aware_count
FROM
    dim_respondents d
        JOIN
    fact_survey_responses f ON d.respondent_id = f.respondent_id
WHERE
    f.heard_before = 'yes'
GROUP BY d.age
ORDER BY aware_count DESC;


-- 2. Consumer Preferences

-- a. What are the preferred ingredients of energy drinks among respondents? 

SELECT 
    ingredients_expected,
    COUNT(respondent_ID) AS response_count,
    ROUND((COUNT(respondent_ID) * 100 / (SELECT 
                    COUNT(*)
                FROM
                    fact_survey_responses)),
            1) AS Percent
FROM
    fact_survey_responses
GROUP BY ingredients_expected
ORDER BY response_count DESC;

-- b. What packaging preferences do respondents have for energy drinks? 

SELECT packaging_preference,
    COUNT(respondent_ID) AS response_count,
    ROUND((COUNT(respondent_ID) * 100 / (SELECT 
                    COUNT(*)
                FROM
                    fact_survey_responses)),
            1) AS Percent
FROM
    fact_survey_responses
GROUP BY packaging_preference
ORDER BY response_count DESC;


-- 3. Competition Analysis: 

-- a. Who are the current market leaders? 

SELECT 
    current_brands,
    COUNT(respondent_ID) AS response_count,
    ROUND((COUNT(respondent_ID) * 100 / (SELECT 
                    COUNT(*)
                FROM
                    fact_survey_responses)),
            1) AS Percent
FROM
    fact_survey_responses
GROUP BY current_brands
ORDER BY response_count DESC;           

-- b. What are the primary reasons consumers prefer those brands over ours? 

SELECT 
    reasons_for_choosing_brands,
    COUNT(respondent_ID) AS response_count,
    ROUND((COUNT(respondent_ID) * 100 / (SELECT 
                    COUNT(*)
                FROM
                    fact_survey_responses)),
            1) AS Percent
FROM
    fact_survey_responses
GROUP BY reasons_for_choosing_brands
ORDER BY response_count DESC;


-- 4. Marketing Channels and Brand Awareness: 

-- a. Which marketing channels are most effective by city tier?

SELECT 
    c.tier,
    COUNT(CASE
        WHEN f.marketing_channels = 'TV commercials' THEN 1
    END) AS TV_commercials_count,
    COUNT(CASE
        WHEN f.marketing_channels = 'Print media' THEN 1
    END) AS Print_media_count,
    COUNT(CASE
        WHEN f.marketing_channels = 'Online ads' THEN 1
    END) AS Online_ads_count,
    COUNT(CASE
        WHEN f.marketing_channels = 'Other' THEN 1
    END) AS Other_ads_count,
    COUNT(CASE
        WHEN f.marketing_channels = 'Outdoor billboards' THEN 1
    END) AS Outdoor_billboards_count,
    COUNT(*) AS response_count
FROM
    fact_survey_responses f
        JOIN
    dim_respondents d ON d.respondent_id = f.respondent_id
        JOIN
	dim_cities c ON c.city_id = d.city_id
GROUP BY c.tier;           

/* CASE statement is already counting the f.marketing_channels rows to categorize data
so no need to use GROUP BY f.marketing_channels

COUNT only counts non-null values, so when using COUNT(CASE WHEN ... THEN 1 END), the database must identify each row where the condition is true and exclude null results. 
With SUM, there’s no need to check for null values, as it simply adds up all numeric values (1s and 0s).
*/


-- 5. Brand Penetration:

-- a. What are the top reasons people in each city tier haven’t tried the product?

SELECT 
    c.tier,
    f.reasons_preventing_trying,
    COUNT(f.reasons_preventing_trying) AS response_count
FROM
    fact_survey_responses f
        JOIN
    dim_respondents d ON d.respondent_id = f.respondent_id
        JOIN
    dim_cities c ON d.city_id = c.city_id
WHERE
    f.tried_before = 'No' -- If they have tried before then 'reasons_preventing_trying' should be 'NULL'
GROUP BY c.tier, f.reasons_preventing_trying
ORDER BY response_count DESC;

-- b. Which cities do we need to focus more on? 

SELECT 
    c.city,
    COUNT(CASE
        WHEN heard_before = 'Yes' THEN 1
    END) AS heard_count,
    COUNT(CASE
        WHEN tried_before = 'Yes' THEN 1
    END) AS tried_count,
    COUNT(CASE
        WHEN
            heard_before = 'Yes'
                AND tried_before = 'No'
        THEN
            1
    END) AS heard_but_not_tried_count
FROM
    fact_survey_responses f
        JOIN
    dim_respondents d ON d.respondent_id = f.respondent_id
        JOIN
    dim_cities c ON c.city_id = d.city_id
GROUP BY c.city
ORDER BY heard_but_not_tried_count DESC;


-- 6. Customer feedback:

-- a. Analyze brand perception by gender and age group

-- when you want rows data as column names you use 'CASE' as case is used to create new columns

SELECT 
    d.gender,
    d.age,
    COUNT(CASE
        WHEN f.brand_perception = 'positive' THEN 1
    END) AS positive_count,
    COUNT(CASE
        WHEN f.brand_perception = 'negative' THEN 1
    END) AS negative_count,
    COUNT(CASE
        WHEN f.brand_perception = 'neutral' THEN 1
    END) AS neutral_count,
    COUNT(*) AS response_count
FROM
    fact_survey_responses f
        JOIN
    dim_respondents d ON d.respondent_id = f.respondent_id
GROUP BY d.gender, d.age
ORDER BY d.gender, d.age;


-- 7. Purchase Behavior: 

-- a. Where do respondents prefer to purchase energy drinks? 

SELECT 
    purchase_location,
    COUNT(purchase_location) AS location_count
FROM
    fact_survey_responses
GROUP BY purchase_location
ORDER BY location_count DESC;

-- b. What are the typical consumption situations for energy drinks among respondents? 

SELECT 
    typical_consumption_situations,
    COUNT(typical_consumption_situations) AS situation_count
FROM
    fact_survey_responses
GROUP BY typical_consumption_situations
ORDER BY situation_count DESC;

-- c. What is the price range preference?

SELECT 
    f.price_range,
    COUNT(price_range) AS price_count
FROM
    fact_survey_responses f
        JOIN
    dim_respondents d ON f.respondent_ID = d.respondent_id
GROUP BY f.price_range;


-- 8. Product Development:

-- a. Which area of business should we focus more on our product development?

SELECT 
    improvements_desired,
    COUNT(improvements_desired) AS improvements_desired_count
FROM
    fact_survey_responses
GROUP BY improvements_desired
ORDER BY improvements_desired_count DESC;


















