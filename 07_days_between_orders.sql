-- Пауза между заказами пользователя (LAG) и заказы после долгого перерыва.
-- У первого заказа предыдущего нет, LAG вернёт NULL — такие строки не проходят фильтр.

WITH gaps AS (
    SELECT user_id, order_id, order_date,
           order_date - LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS days_gap
    FROM orders
)
SELECT user_id, order_id, order_date, days_gap
FROM gaps
WHERE days_gap > 5
ORDER BY user_id, order_date;
