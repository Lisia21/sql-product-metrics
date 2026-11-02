-- GMV нарастающим итогом по дням (window function).
-- Шаг 1 сворачивает заказы в выручку за день, шаг 2 накапливает её по датам.

WITH daily_gmv AS (
    SELECT order_date, SUM(amount) AS gmv
    FROM orders
    GROUP BY order_date
)
SELECT
    order_date,
    gmv,
    SUM(gmv) OVER (ORDER BY order_date) AS gmv_running_total
FROM daily_gmv
ORDER BY order_date;
