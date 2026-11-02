-- Когортная таблица: retention D1 и D7 отдельно для каждой когорты.
-- Одна строка ответа = одна когорта (пользователи, пришедшие в один день).

WITH cohorts AS (
    SELECT user_id, MIN(event_date) AS cohort_date
    FROM events
    GROUP BY user_id
),
user_days AS (
    SELECT e.user_id,
           c.cohort_date,
           e.event_date - c.cohort_date AS day_num
    FROM events AS e
    JOIN cohorts AS c ON e.user_id = c.user_id
)
SELECT
    cohort_date,
    COUNT(DISTINCT user_id) AS users,
    ROUND(COUNT(DISTINCT CASE WHEN day_num = 1 THEN user_id END) * 100.0
          / COUNT(DISTINCT user_id), 1) AS d1_pct,
    ROUND(COUNT(DISTINCT CASE WHEN day_num = 7 THEN user_id END) * 100.0
          / COUNT(DISTINCT user_id), 1) AS d7_pct
FROM user_days
GROUP BY cohort_date
ORDER BY cohort_date;
