-- SQLite
SELECT
    ds.Province,
    COUNT(DISTINCT fs.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT ds.StoreID) AS NumberOfStores,
    ROUND(
        COUNT(DISTINCT fs.CustomerID) * 1.0 /
        COUNT(DISTINCT ds.StoreID),
    2) AS CustomersPerStore
FROM FactSales fs
JOIN DimStore ds
    ON fs.StoreID = ds.StoreID
GROUP BY ds.Province
ORDER BY CustomersPerStore DESC;