-- SQLite
WITH SalesByProvince AS (
    SELECT
        ds.Province,
        ROUND(SUM(fs.TotalAmount),2) AS Revenue,
        ROUND(SUM(fs.Profit),2) AS Profit
    FROM FactSales fs
    JOIN DimStore ds
        ON fs.StoreID = ds.StoreID
    GROUP BY ds.Province
),

InventoryByProvince AS (
    SELECT
        ds.Province,
        COUNT(*) AS TotalInventoryRecords,

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
    GROUP BY ds.Province
)

SELECT
    s.Province,
    s.Revenue,
    s.Profit,
    i.TotalInventoryRecords,
    i.OutOfStockProducts,
    i.StockoutRate
FROM SalesByProvince s
JOIN InventoryByProvince i
    ON s.Province = i.Province
ORDER BY i.StockoutRate DESC;
