-- ============================================================
-- SUPPLY CHAIN & LOGISTICS INTELLIGENCE SYSTEM
-- SQL ANALYSIS
-- Dataset: DataCo Smart Supply Chain
-- Database: SQLite
-- ============================================================


-- ============================================================
-- 1. OVERALL SUPPLY CHAIN KPIs
-- ============================================================

SELECT
    SUM(Sales) AS Total_Revenue,
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    SUM("Order Item Quantity") AS Total_Units_Sold,
    ROUND(
        SUM(Sales) / COUNT(DISTINCT "Order Id"),
        2
    ) AS Average_Order_Value,
    ROUND(AVG("Days for shipping (real)"), 2) AS Average_Delivery_Days,
    ROUND(AVG(Late_delivery_risk) * 100, 2) AS Late_Delivery_Rate
FROM supply_chain_data;


-- ============================================================
-- 2. PRODUCT PERFORMANCE
-- ============================================================

SELECT
    "Product Name",
    SUM(Sales) AS Total_Revenue,
    SUM("Order Item Quantity") AS Units_Sold,
    COUNT(DISTINCT "Order Id") AS Total_Orders
FROM supply_chain_data
GROUP BY "Product Name"
ORDER BY Total_Revenue DESC;


-- ============================================================
-- 3. CATEGORY PERFORMANCE
-- ============================================================

SELECT
    "Category Name",
    SUM(Sales) AS Total_Revenue,
    SUM("Order Item Quantity") AS Units_Sold,
    COUNT(DISTINCT "Order Id") AS Total_Orders
FROM supply_chain_data
GROUP BY "Category Name"
ORDER BY Total_Revenue DESC;


-- ============================================================
-- 4. REGIONAL PERFORMANCE
-- ============================================================

SELECT
    "Order Region",
    SUM(Sales) AS Total_Revenue,
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    SUM("Order Item Quantity") AS Units_Sold,
    ROUND(AVG("Days for shipping (real)"), 2) AS Avg_Delivery_Days
FROM supply_chain_data
GROUP BY "Order Region"
ORDER BY Total_Revenue DESC;


-- ============================================================
-- 5. CUSTOMER SEGMENT PERFORMANCE
-- ============================================================

SELECT
    "Customer Segment",
    SUM(Sales) AS Total_Revenue,
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    SUM("Order Item Quantity") AS Units_Sold
FROM supply_chain_data
GROUP BY "Customer Segment"
ORDER BY Total_Revenue DESC;


-- ============================================================
-- 6. SHIPPING MODE ANALYSIS
-- ============================================================

SELECT
    "Shipping Mode",
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    ROUND(AVG("Days for shipping (real)"), 2) AS Avg_Delivery_Days,
    ROUND(AVG("Days for shipment (scheduled)"), 2) AS Avg_Scheduled_Days,
    ROUND(AVG(Late_delivery_risk) * 100, 2) AS Late_Delivery_Rate
FROM supply_chain_data
GROUP BY "Shipping Mode"
ORDER BY Late_Delivery_Rate DESC;


-- ============================================================
-- 7. DELIVERY PERFORMANCE
-- ============================================================

SELECT
    CASE
        WHEN Late_delivery_risk = 1 THEN 'Late'
        ELSE 'On-Time'
    END AS Delivery_Status,
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    ROUND(
        COUNT(DISTINCT "Order Id") * 100.0 /
        (SELECT COUNT(DISTINCT "Order Id")
         FROM supply_chain_data),
        2
    ) AS Percentage
FROM supply_chain_data
GROUP BY Delivery_Status;


-- ============================================================
-- 8. REGIONS WITH HIGHEST LATE DELIVERY
-- ============================================================

SELECT
    "Order Region",
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    SUM(
        CASE
            WHEN Late_delivery_risk = 1 THEN 1
            ELSE 0
        END
    ) AS Late_Order_Items,
    ROUND(
        AVG(Late_delivery_risk) * 100,
        2
    ) AS Late_Delivery_Rate
FROM supply_chain_data
GROUP BY "Order Region"
ORDER BY Late_Delivery_Rate DESC;


-- ============================================================
-- 9. SHIPPING COST ANALYSIS
-- ============================================================

SELECT
    "Shipping Mode",
    ROUND(AVG("Order Item Total"), 2) AS Avg_Order_Item_Value,
    ROUND(AVG("Days for shipping (real)"), 2) AS Avg_Delivery_Days,
    COUNT(DISTINCT "Order Id") AS Total_Orders
FROM supply_chain_data
GROUP BY "Shipping Mode"
ORDER BY Avg_Delivery_Days DESC;


-- ============================================================
-- 10. MONTHLY SALES TREND
-- ============================================================

SELECT
    strftime('%Y-%m', "order date (DateOrders)") AS Month,
    SUM(Sales) AS Monthly_Revenue,
    COUNT(DISTINCT "Order Id") AS Monthly_Orders,
    SUM("Order Item Quantity") AS Monthly_Units
FROM supply_chain_data
GROUP BY Month
ORDER BY Month;


-- ============================================================
-- 11. MONTH-OVER-MONTH REVENUE GROWTH
-- Uses LAG window function
-- ============================================================

WITH Monthly_Sales AS (
    SELECT
        strftime('%Y-%m', "order date (DateOrders)") AS Month,
        SUM(Sales) AS Revenue
    FROM supply_chain_data
    GROUP BY Month
),

Growth_Calculation AS (
    SELECT
        Month,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Month) AS Previous_Month_Revenue
    FROM Monthly_Sales
)

SELECT
    Month,
    ROUND(Revenue, 2) AS Revenue,
    ROUND(Previous_Month_Revenue, 2) AS Previous_Month_Revenue,
    ROUND(
        (Revenue - Previous_Month_Revenue)
        * 100.0 / Previous_Month_Revenue,
        2
    ) AS MoM_Growth_Percentage
FROM Growth_Calculation
ORDER BY Month;


-- ============================================================
-- 12. TOP PRODUCTS USING RANK
-- ============================================================

WITH Product_Revenue AS (
    SELECT
        "Product Name",
        SUM(Sales) AS Revenue
    FROM supply_chain_data
    GROUP BY "Product Name"
),

Ranked_Products AS (
    SELECT
        "Product Name",
        Revenue,
        RANK() OVER (ORDER BY Revenue DESC) AS Revenue_Rank
    FROM Product_Revenue
)

SELECT
    "Product Name",
    ROUND(Revenue, 2) AS Revenue,
    Revenue_Rank
FROM Ranked_Products
WHERE Revenue_Rank <= 10
ORDER BY Revenue_Rank;


-- ============================================================
-- 13. TOP PRODUCTS WITH DELIVERY ISSUES
-- ============================================================

SELECT
    "Product Name",
    SUM(Sales) AS Total_Revenue,
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    ROUND(AVG(Late_delivery_risk) * 100, 2) AS Late_Delivery_Rate
FROM supply_chain_data
GROUP BY "Product Name"
HAVING Late_Delivery_Rate > 50
ORDER BY Total_Revenue DESC;


-- ============================================================
-- 14. PRODUCT + REGION PERFORMANCE
-- ============================================================

SELECT
    "Order Region",
    "Product Name",
    SUM(Sales) AS Revenue,
    COUNT(DISTINCT "Order Id") AS Orders
FROM supply_chain_data
GROUP BY
    "Order Region",
    "Product Name"
ORDER BY
    "Order Region",
    Revenue DESC;


-- ============================================================
-- 15. CONDITIONAL AGGREGATION
-- ============================================================

SELECT
    "Shipping Mode",

    COUNT(DISTINCT "Order Id") AS Total_Orders,

    COUNT(
        DISTINCT CASE
            WHEN Late_delivery_risk = 1
            THEN "Order Id"
        END
    ) AS Late_Orders,

    COUNT(
        DISTINCT CASE
            WHEN Late_delivery_risk = 0
            THEN "Order Id"
        END
    ) AS On_Time_Orders,

    ROUND(
        COUNT(
            DISTINCT CASE
                WHEN Late_delivery_risk = 1
                THEN "Order Id"
            END
        ) * 100.0 /
        COUNT(DISTINCT "Order Id"),
        2
    ) AS Late_Delivery_Percentage

FROM supply_chain_data
GROUP BY "Shipping Mode";


-- ============================================================
-- 16. REGIONAL REVENUE RANKING
-- ============================================================

WITH Regional_Revenue AS (
    SELECT
        "Order Region",
        SUM(Sales) AS Revenue
    FROM supply_chain_data
    GROUP BY "Order Region"
)

SELECT
    "Order Region",
    ROUND(Revenue, 2) AS Revenue,
    DENSE_RANK() OVER (ORDER BY Revenue DESC) AS Region_Rank
FROM Regional_Revenue
ORDER BY Region_Rank;


-- ============================================================
-- 17. CUMULATIVE MONTHLY REVENUE
-- Uses SUM window function
-- ============================================================

WITH Monthly_Revenue AS (
    SELECT
        strftime('%Y-%m', "order date (DateOrders)") AS Month,
        SUM(Sales) AS Revenue
    FROM supply_chain_data
    GROUP BY Month
)

SELECT
    Month,
    ROUND(Revenue, 2) AS Monthly_Revenue,
    ROUND(
        SUM(Revenue) OVER (
            ORDER BY Month
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS Cumulative_Revenue
FROM Monthly_Revenue
ORDER BY Month;


-- ============================================================
-- 18. DELIVERY DELAY ANALYSIS
-- ============================================================

SELECT
    "Shipping Mode",
    ROUND(
        AVG(
            "Days for shipping (real)"
            - "Days for shipment (scheduled)"
        ),
        2
    ) AS Average_Delivery_Delay
FROM supply_chain_data
GROUP BY "Shipping Mode"
ORDER BY Average_Delivery_Delay DESC;


-- ============================================================
-- 19. HIGH-REVENUE PRODUCTS WITH HIGH LATE DELIVERY
-- ============================================================

WITH Product_Analysis AS (
    SELECT
        "Product Name",
        SUM(Sales) AS Revenue,
        AVG(Late_delivery_risk) * 100 AS Late_Rate
    FROM supply_chain_data
    GROUP BY "Product Name"
)

SELECT
    "Product Name",
    ROUND(Revenue, 2) AS Revenue,
    ROUND(Late_Rate, 2) AS Late_Delivery_Rate
FROM Product_Analysis
WHERE Late_Rate >= 50
ORDER BY Revenue DESC;


-- ============================================================
-- 20. FINAL MANAGEMENT SUMMARY
-- ============================================================

SELECT
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    SUM("Order Item Quantity") AS Total_Units,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(AVG(Sales), 2) AS Average_Sales_Per_Record,
    ROUND(AVG("Days for shipping (real)"), 2) AS Avg_Delivery_Days,
    ROUND(AVG(Late_delivery_risk) * 100, 2) AS Late_Delivery_Rate,
    ROUND(
        (1 - AVG(Late_delivery_risk)) * 100,
        2
    ) AS On_Time_Delivery_Rate
FROM supply_chain_data;


-- ============================================================
-- END OF SQL ANALYSIS
-- ============================================================
