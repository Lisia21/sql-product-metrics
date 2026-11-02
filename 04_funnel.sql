-- Воронка install → signup → subscribe.
-- Считаем людей (COUNT DISTINCT), а не события: повторное действие не должно завышать шаг.
-- Узкое место — шаг с худшей конверсией, а не с наибольшим числом ушедших.

WITH funnel AS (
    SELECT
        COUNT(DISTINCT CASE WHEN action = 'install'   THEN user_id END) AS install,
        COUNT(DISTINCT CASE WHEN action = 'signup'    THEN user_id END) AS signup,
        COUNT(DISTINCT CASE WHEN action = 'subscribe' THEN user_id END) AS subscribe
    FROM app_events
)
SELECT
    install,
    signup,
    subscribe,
    ROUND(signup * 100.0 / install, 1)   AS install_to_signup_pct,
    ROUND(subscribe * 100.0 / signup, 1) AS signup_to_subscribe_pct
FROM funnel;
