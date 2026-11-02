-- День максимальной активности каждого пользователя.
-- RANK, а не ROW_NUMBER: при ничьей в ответ попадут оба дня.

WITH daily AS (
    SELECT user_id, order_date, SUM(amount) AS spent
    FROM orders
    GROUP BY user_id, order_date
),
ranked AS (
    SELECT user_id, order_date, spent,
           RANK() OVER (PARTITION BY user_id ORDER BY spent DESC) AS rnk
    FROM daily
)
SELECT user_id, order_date, spent
FROM ranked
WHERE rnk = 1
ORDER BY user_id, order_date;
