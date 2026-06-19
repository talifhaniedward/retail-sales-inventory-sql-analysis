-- SQLite
SELECT
    dd.Year,
    dd.MonthName,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue
FROM FactSales fs
JOIN DimDate dd
    ON fs.DateID = dd.DateID
GROUP BY dd.Year, dd.Month
ORDER BY dd.Year, dd.Month;