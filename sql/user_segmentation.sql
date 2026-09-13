SELECT COUNT(*) AS total_rows FROM users_clean;
-- 用户消费分层：按四分位数阈值切分
SELECT
    User_ID,
    Location,
    Total_Spending,
    Average_Order_Value,
    Purchase_Frequency,
    CASE
        WHEN Total_Spending <= 1257.5 THEN '低消费'
        WHEN Total_Spending <= 3298.5 THEN '中消费'
        ELSE '高消费'
    END AS spending_tier
FROM users_clean
ORDER BY Total_Spending DESC
LIMIT 20;
-- 按地区对比客单价、购买频率、平均消费
SELECT
    Location,
    COUNT(*) AS user_count,
    ROUND(AVG(Average_Order_Value), 2) AS avg_order_value,
    ROUND(AVG(Purchase_Frequency), 2) AS avg_purchase_freq,
    ROUND(AVG(Total_Spending), 2) AS avg_total_spending
FROM users_clean
GROUP BY Location
ORDER BY avg_total_spending DESC;
-- 地区 × 消费分层交叉占比
SELECT
    Location,
    spending_tier,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Location), 2) AS pct
FROM (
    SELECT
        User_ID,
        Location,
        Total_Spending,
        CASE
            WHEN Total_Spending <= 1257.5 THEN '低消费'
            WHEN Total_Spending <= 3298.5 THEN '中消费'
            ELSE '高消费'
        END AS spending_tier
    FROM users_clean
) t
GROUP BY Location, spending_tier
ORDER BY Location, spending_tier;