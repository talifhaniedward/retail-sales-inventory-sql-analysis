-- SQLite
SELECT
    ds.Province,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue,
    ROUND(SUM(fs.Profit),2) AS Profit
FROM FactSales fs
JOIN DimStore ds
    ON fs.StoreID = ds.StoreID
GROUP BY ds.Province
ORDER BY Revenue DESC;