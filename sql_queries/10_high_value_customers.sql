-- SQLite
SELECT
    dc.Province,
    COUNT(DISTINCT fs.CustomerID) AS UniqueCustomers,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue,
    ROUND(SUM(fs.Profit),2) AS Profit,
    ROUND(
        SUM(fs.TotalAmount) * 1.0 /
        COUNT(DISTINCT fs.CustomerID),
    2) AS RevenuePerCustomer
FROM FactSales fs
JOIN DimCustomer dc
    ON fs.CustomerID = dc.CustomerID
GROUP BY dc.Province
ORDER BY RevenuePerCustomer DESC;
