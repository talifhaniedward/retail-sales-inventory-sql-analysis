-- SQLite
SELECT
    dd.Year,
    dd.Quarter,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue
FROM FactSales fs
JOIN DimDate dd
    ON fs.DateID = dd.DateID
GROUP BY dd.Year, dd.Quarter
ORDER BY Revenue DESC;