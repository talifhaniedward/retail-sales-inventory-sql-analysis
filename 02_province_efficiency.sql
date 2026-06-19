-- SQLite
SELECT
    ds.Province,
    COUNT(DISTINCT ds.StoreID) AS NumberOfStores,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue,
    ROUND(SUM(fs.Profit),2) AS Profit,
    ROUND(
        SUM(fs.TotalAmount) * 1.0 /
        COUNT(DISTINCT ds.StoreID),
    2) AS RevenuePerStore
FROM FactSales fs
JOIN DimStore ds
    ON fs.StoreID = ds.StoreID
GROUP BY ds.Province
ORDER BY RevenuePerStore DESC;