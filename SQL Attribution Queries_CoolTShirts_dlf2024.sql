/* Get familiar with CoolTShirts */
/* Inspect page_visits table */ 
SELECT * FROM page_visits LIMIT 7;

/* Task 1 - identify campaigns and sources */
/*  number of distinct campaigns */
SELECT COUNT(DISTINCT utm_campaign) AS 'campaign_count'
FROM page_visits;
-- there are 8 campaigns
/* number of distinct sources */
SELECT COUNT(DISTINCT utm_source) AS 'source_count'
FROM page_visits;
-- there are 6 sources
/* relationship between campaigns and sources */
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits
ORDER BY 2;
/* Most campaigns are run on unique sources, with the exception of google and email which have been assigned 2 different campaigns each. */ 

/* Task 2 - pages on the CoolTShirts website */
SELECT DISTINCT page_name
FROM page_visits;
/* There are 4 pages: landing_page, shopping_cart, checkout, and purchase */  

/* User journey */
/* number of unique users */
SELECT COUNT(DISTINCT user_id) AS 'user_total_count'
FROM page_visits;
-- There are 1979 unique users

/* Task 3 - User first journey: first touches per campaign */
WITH first_touch AS (
    SELECT user_id,
           MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id
)
SELECT pv.utm_campaign, utm_source,
       COUNT(DISTINCT ft.user_id) AS ft_user_count
FROM first_touch ft
JOIN page_visits pv ON ft.user_id = pv.user_id AND ft.first_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY ft_user_count DESC;

/* Task 4 - User last journey: last touches per campaign */
WITH last_touch AS (
    SELECT user_id,
           MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id
)
SELECT pv.utm_campaign, utm_source,
       COUNT(DISTINCT lt.user_id) AS lt_user_count
FROM last_touch lt
JOIN page_visits pv ON lt.user_id = pv.user_id AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY lt_user_count DESC;

/* Task 5 - number of purchasing customers */
SELECT COUNT(DISTINCT user_id) AS 'purchasing_user'
FROM page_visits
WHERE page_name = '4 - purchase';
-- 361 visitors made a purchase

/* Task 6 - User last journey: last touches per campaign leading to purchase */
WITH last_touch AS (
    SELECT user_id,
           MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase' -- Move the filter here to only include visits to the purchase page
    GROUP BY user_id
)
SELECT pv.utm_campaign, utm_source,
       COUNT(DISTINCT lt.user_id) AS purchasing_user
FROM last_touch lt
JOIN page_visits pv ON lt.user_id = pv.user_id AND lt.last_touch_at = pv.timestamp
WHERE pv.page_name = '4 - purchase' -- This line is optional if the filter is already applied in the CTE
GROUP BY pv.utm_campaign, pv.utm_source
ORDER BY purchasing_user DESC;





