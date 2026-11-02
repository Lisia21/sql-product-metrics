-- Sticky factor = средний DAU / MAU.
-- Показывает, какая доля месячной аудитории заходит в обычный день.
-- Ориентиры: мессенджер ~50%, доставка или банк ~10%.

WITH daily AS (                  -- DAU: уникальные пользователи за каждый день
    SELECT event_date, COUNT(DISTINCT user_id) AS dau
    FROM events
    WHERE event_date BETWEEN '2026-10-01' AND '2026-10-31'
    GROUP BY event_date
)
SELECT
    ROUND(AVG(dau), 2) AS avg_dau,
    (SELECT COUNT(DISTINCT user_id)
     FROM events
     WHERE event_date BETWEEN '2026-10-01' AND '2026-10-31') AS mau,
    ROUND(AVG(dau) * 100.0
          / (SELECT COUNT(DISTINCT user_id)
             FROM events
             WHERE event_date BETWEEN '2026-10-01' AND '2026-10-31'), 1) AS sticky_pct
FROM daily;
