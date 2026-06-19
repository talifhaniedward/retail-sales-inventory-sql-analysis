-- SQLite
SELECT
    ds.StoreName,
    ds.Province,
    COUNT(*) AS TotalProducts,
    SUM(
        CASE
            WHEN fi.StockStatus = 'Out of Stock'
            THEN 1
            ELSE 0
        END
    ) AS OutOfStockProducts,
    ROUND(
        SUM(
            CASE
                WHEN fi.StockStatus = 'Out of Stock'
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        COUNT(*),
    2) AS StockoutRate
FROM FactInventory fi
JOIN DimStore ds
    ON fi.StoreID = ds.StoreID
GROUP BY ds.StoreName, ds.Province
HAVING COUNT(*) > 100
ORDER BY StockoutRate DESC
LIMIT 10;