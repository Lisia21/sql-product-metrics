-- Retention D7: какая доля пользователей вернулась на 7-й день после первого захода.
-- Classic — ровно на 7-й день; rolling — на 7-й день или позже.
-- Знаменатель — вся когорта, включая тех, кто не вернулся ни разу.

WITH cohorts AS (                -- шаг 1: день первого захода каждого пользователя (день 0)
    SELECT user_id, MIN(event_date) AS cohort_date
    FROM events
    GROUP BY user_id
),
user_days AS (                   -- шаг 2: номер дня для каждого захода
    SELECT e.user_id,
           e.event_date - c.cohort_date AS day_num
    FROM events AS e
    JOIN cohorts AS c ON e.user_id = c.user_id
)
SELECT
    ROUND(COUNT(DISTINCT CASE WHEN day_num = 7  THEN user_id END) * 100.0
          / COUNT(DISTINCT user_id), 1) AS d7_classic_pct,
    ROUND(COUNT(DISTINCT CASE WHEN day_num >= 7 THEN user_id END) * 100.0
          / COUNT(DISTINCT user_id), 1) AS d7_rolling_pct
FROM user_days;
