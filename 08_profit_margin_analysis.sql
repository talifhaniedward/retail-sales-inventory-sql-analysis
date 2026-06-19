-- SQLite
SELECT
    dp.Brand,
    dp.ProductType,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue,
    ROUND(SUM(fs.Profit),2) AS Profit,
    ROUND(
        SUM(fs.Profit) * 100.0 /
        SUM(fs.TotalAmount),
    2) AS ProfitMarginPct
FROM FactSales fs
JOIN DimProduct dp
    ON fs.ProductID = dp.ProductID
GROUP BY dp.Brand, dp.ProductType
ORDER BY ProfitMarginPct DESC;