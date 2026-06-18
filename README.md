# Retail Sales & Inventory Analytics | SQL Project

## Overview

This project analyzes **retail sales, profitability, inventory performance, customer behavior, and store efficiency** for a national electronics retailer using **SQL, SQLite, dimensional modeling, and business analytics**.

The objective was to answer **executive-level business questions** and generate **data-driven recommendations** to improve operational efficiency, profitability, customer value, and inventory management.

The analysis was performed on a large-scale retail database containing:

* **5M+ sales records**
* Inventory transactions
* Customer segmentation data
* Product-level performance
* Store performance across South African provinces

---

## Business Problem

A national electronics retailer wanted to better understand:

* Which provinces contribute the most to business performance
* Whether store saturation is affecting efficiency
* If inventory shortages are limiting growth
* Which brands and products drive profitability
* Which customer segments generate the highest value
* Which stores experience inventory challenges

The goal was to transform raw transactional data into **executive-level business insights for strategic decision-making**.

---

## Project Objectives

This project focuses on:

✔ Sales performance analysis
✔ Profitability analysis
✔ Customer analytics
✔ Inventory management insights
✔ Store performance evaluation
✔ Provincial business comparisons
✔ Time-series and trend analysis
✔ Strategic business recommendations

---

## Tools & Technologies

| Tool | Purpose |
|--------|----------|
| SQL (SQLite) | Data querying and analytics |
| VS Code | SQL development environment |
| Python | Data generation and preparation |
| Excel | Data validation |
| DBDiagram | Star schema modeling |
| GitHub | Project version control |

---

## Data Model

The project uses a **Star Schema architecture** to support scalable retail analytics, inventory reporting, and time-based business analysis.


### Fact Tables

#### FactSales

Contains transactional sales information:

* SalesID
* ProductID
* CustomerID
* StoreID
* DateID
* Quantity
* TotalAmount
* Profit
  

#### FactInventory

Contains inventory performance data:

* InventoryID
* ProductID
* StoreID
* DateID
* StockReceived
* StockSold
* CurrentStock
* StockStatus

### Dimension Tables

#### DimProduct

Product details including:

* Brand
* Product Type
* CPU
* Operating System
* Selling Price

#### DimCustomer

Customer segmentation data:

* Segment
* Province
* AgeGroup
* Gender
* JoinDate

#### DimStore

Store and location information:

* Province
* City
* Store Type
* Store Size
* OpeningYear
#### DimDate
Calendar dimension used for time-based analysis:

* FullDate
* Year
* Quarter
* Month
* MonthName
* Day
---

## Star Schema

<img width="578" height="323" alt="image" src="https://github.com/user-attachments/assets/6fc861a9-5ab2-4b68-b8c8-82e41b027815" />



---

# Executive Business Questions & Analysis

---

## Q1. Which province contributes the most to company performance?

### Business Question

Which province generates the highest **revenue and profit**?

### SQL Query

```sql
SELECT
    ds.Province,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue,
    ROUND(SUM(fs.Profit),2) AS Profit
FROM FactSales fs
JOIN DimStore ds
    ON fs.StoreID = ds.StoreID
GROUP BY ds.Province
ORDER BY Revenue DESC;
```

### Output

<img width="242" height="112" alt="image" src="https://github.com/user-attachments/assets/6f526230-f36a-4fde-b109-bd988ec3b340" />


### Key Insight

**Gauteng is the strongest contributor to company performance**, generating the highest revenue (**R7.63B**) and profit (**R1.47B**).

### Recommendation

Continue investing in Gauteng while identifying opportunities to improve store-level efficiency.

---

## Q2. Which province is most efficient?

### Business Question

Which province performs best after normalizing revenue by store count?

### SQL Query
```Sql
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
```


### Output

<img width="430" height="133" alt="image" src="https://github.com/user-attachments/assets/050a2a5d-321a-462c-818e-a77cd071a0f1" />


### Key Insight

**Western Cape achieved the highest revenue per store**, outperforming Gauteng despite having fewer stores.

This indicates **stronger operational efficiency**.

### Recommendation

Replicate successful Western Cape operating strategies in lower-performing provinces.

---

## Q3. Is store saturation reducing efficiency?

### Business Question

Does store density reduce customer concentration?

### SQL Query
``` Sql
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
```

### Output

<img width="386" height="144" alt="image" src="https://github.com/user-attachments/assets/a9bcce6d-9643-4985-aa88-78ee6d4d2855" />


### Key Insight

Although Gauteng generated the highest revenue, it had the **lowest customers per store**.

This suggests **market cannibalization caused by store concentration**.

### Recommendation

Review Gauteng store density to improve customer distribution and operational efficiency.

---

## Q4. Is inventory availability affecting provincial performance?

### Business Question

Which provinces experience the highest inventory shortages?

### SQL Query
```sql
SELECT
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
GROUP BY ds.Province
ORDER BY StockoutRate DESC;
```
### Output

<img width="366" height="142" alt="image" src="https://github.com/user-attachments/assets/28bf33e7-20a5-4d26-b01c-f3a0fa2e7dc8" />


### Key Insight

**Eastern Cape recorded the highest stockout rate (11.98%)**, potentially affecting sales performance.

### Recommendation

Improve inventory planning and replenishment forecasting.

---

## Q5. Which stores struggle the most with inventory availability?

### Business Question

Which stores face the highest stockout risk?

### SQL Query
```sql
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
```

### Output

<img width="548" height="269" alt="image" src="https://github.com/user-attachments/assets/c3f451ab-3f93-46d1-8f1c-35390b7e6353" />


### Key Insight

Multiple stores in **Eastern Cape and KwaZulu-Natal recorded stockout rates above 15%**, indicating supply chain inefficiencies.

### Recommendation

Conduct targeted inventory audits for high-risk stores.

---

## Q6. Which brands drive company revenue and profit?

### Business Question

Which brands contribute most to revenue generation?

### SQL Query
```sql
SELECT
    dp.Brand,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue,
    ROUND(SUM(fs.Profit),2) AS Profit
FROM FactSales fs
JOIN DimProduct dp
    ON fs.ProductID = dp.ProductID
GROUP BY dp.Brand
ORDER BY Revenue DESC;
```
### Output

<img width="207" height="208" alt="image" src="https://github.com/user-attachments/assets/3bee4887-7ef6-4018-bc8a-1ee85bcb2355" />


### Key Insight

**HP, Dell, and Lenovo dominate revenue and profit generation**.

### Recommendation

Strengthen supplier partnerships with top-performing brands.

---

## Q7. Which products within each brand drive revenue and profit?

### Business Question

Which product categories generate the highest revenue?

### SQL Query
```sql
SELECT
    dp.Brand,
    dp.ProductType,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue,
    ROUND(SUM(fs.Profit),2) AS Profit
FROM FactSales fs
JOIN DimProduct dp
    ON fs.ProductID = dp.ProductID
GROUP BY dp.Brand, dp.ProductType
ORDER BY Revenue DESC;
```

### Output

<img width="280" height="395" alt="image" src="https://github.com/user-attachments/assets/8a9cce2c-97b3-4e73-800a-3d28b2d4e61a" />


### Key Insight

**Laptops are the primary revenue drivers across all brands**.

### Recommendation

Prioritize laptop inventory planning and promotional campaigns.

---

## Q8. Which product categories have the highest profit margins?

### Business Question

Which products maximize profitability?

### SQL Query
```sql
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
```
### Output

<img width="373" height="266" alt="image" src="https://github.com/user-attachments/assets/3e9ac26f-7dad-4e1e-b990-33eaa6f800a1" />


### Key Insight

**Accessories generated the highest margins (~35%)**, despite lower revenue.

### Recommendation

Increase **cross-selling and product bundling** to maximize margins.

---

## Q9. Which customer segments generate the most revenue and profit?

### Business Question

Which customer segment delivers the highest business value?

### SQL Query
```sql
SELECT
    dc.Segment,
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
GROUP BY dc.Segment
ORDER BY Revenue DESC;
```
### Output

<img width="433" height="121" alt="image" src="https://github.com/user-attachments/assets/b9e2076f-d319-4912-a52b-ae1048bd90cb" />


### Key Insight

**Corporate customers generated the highest revenue and revenue per customer**.

### Recommendation

Expand B2B sales strategies and enterprise partnerships.

---

## Q10. Which provinces have the highest-value customers?

### Business Question

Which province generates the highest revenue per customer?

### SQL Query
```sql
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
```
### Output

<img width="452" height="140" alt="image" src="https://github.com/user-attachments/assets/69c983b3-8ff5-422d-8c6c-307d9bc3a703" />


### Key Insight

**KwaZulu-Natal recorded the highest revenue per customer**.

### Recommendation

Explore customer retention and expansion strategies in KZN.

---

## Q11. Are high stockout provinces losing revenue because of inventory shortages?

### Business Question

Are stock shortages limiting business performance?

### SQL Query
```sql
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
```
### Output

<img width="566" height="143" alt="image" src="https://github.com/user-attachments/assets/4bda8a1e-4e01-42bd-be37-b3178a211b1f" />


### Key Insight

**Eastern Cape and KwaZulu-Natal recorded higher stockout rates and lower revenue performance**, suggesting inventory shortages may constrain growth.

### Recommendation

Improve supply chain responsiveness in underperforming provinces.


## Q12. How has revenue changed over time?
### Business Question

What are the monthly revenue trends and seasonal patterns?

### SQL Query
``` sql
SELECT
    dd.Year,
    dd.MonthName,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue
FROM FactSales fs
JOIN DimDate dd
    ON fs.DateID = dd.DateID
GROUP BY dd.Year, dd.Month
ORDER BY dd.Year, dd.Month;
```
### Output

<img width="167" height="399" alt="image" src="https://github.com/user-attachments/assets/4828d4ad-3751-40ab-bb07-7d75db66a1d2" />

See full output here:
[See full Q12 output here](./q12_monthly_revenue.csv)

### Key Insight

**Revenue remained relatively stable across the 3-year period, indicating predictable business performance.**

However:

* January consistently delivered the strongest revenue
* February showed recurring revenue dips

This suggests strong seasonal patterns in customer purchasing behavior.

### Recommendation
* Increase stock levels and marketing campaigns ahead of January peaks.
* Introduce promotions in February to reduce seasonal slowdowns.

## Q13. Which quarter generates the highest revenue?
### Business Question

Which quarter contributes most to company revenue?

### SQL Query
```sql
SELECT
    dd.Year,
    dd.Quarter,
    ROUND(SUM(fs.TotalAmount),2) AS Revenue
FROM FactSales fs
JOIN DimDate dd
    ON fs.DateID = dd.DateID
GROUP BY dd.Year, dd.Quarter
ORDER BY Revenue DESC;
```
### Output

<img width="167" height="308" alt="image" src="https://github.com/user-attachments/assets/6a545b78-da0a-4bbf-967a-7349868616ec" />


### Key Insight

**Revenue remained highly consistent across all quarters.**

However:

* Q3 2026 recorded the highest quarterly revenue (R1.54B)
* Q1 2025 recorded the lowest revenue (R1.48B)

This reinforces seasonal patterns identified in monthly analysis.

### Recommendation
* Replicate Q3 sales strategies in weaker quarters.
* Investigate February and early Q1 performance dips.
* Improve quarterly promotional planning.


---

# Executive Summary

## Key Findings

✅ Gauteng generated the highest total revenue and profit.

✅ Western Cape achieved the strongest revenue efficiency per store.

✅ Gauteng may be experiencing **store saturation**.

✅ Eastern Cape recorded the highest stockout rates.

✅ HP and Dell dominate business performance.

✅ Laptops drive revenue while accessories maximize margins.

✅ Corporate customers are the highest-value segment.

---

# Strategic Business Recommendations

### 1. Optimize Gauteng Store Density

Reduce market cannibalization by reviewing store concentration.

### 2. Improve Eastern Cape Inventory Planning

Strengthen replenishment forecasting to reduce stockouts.

### 3. Replicate Western Cape Success

Apply best-performing operational strategies nationally.

### 4. Increase Accessory Cross-Selling

Bundle accessories with laptops and desktops to improve margins.

### 5. Expand Corporate Customer Strategy

Focus on high-value B2B customers.

---

## Skills Demonstrated

### SQL Skills

* SQL Joins
* Aggregations
* GROUP BY
* CASE WHEN
* KPI Analysis
* Date-Based Analysis
* Business Query Optimization

### Analytics Skills

* Retail Analytics
* Customer Segmentation
* Inventory Analytics
* Profitability Analysis
* Executive Storytelling

### Data Modeling Skills

* Star Schema Design
* Fact & Dimension Modeling
* DimDate Calendar Modeling
* Relational Database Design
* Data Warehouse Concepts

---

## Repository Structure

```text
retail-sales-inventory-sql-analysis/
│
├── data/
│   └── RetailDW.db
│
├── sql_queries/
│   ├── 00_dim_date.sql
│   ├── 01_provincial_performance.sql
│   ├── 02_province_efficiency.sql
│   ├── 03_store_saturation.sql
│   ├── 04_inventory_availability.sql
│   ├── 05_inventory_problem_stores.sql
│   ├── 06_brand_performance.sql
│   ├── 07_product_profitability.sql
│   ├── 08_profit_margin_analysis.sql
│   ├── 09_customer_segments.sql
│   ├── 10_high_value_customers.sql
│   ├── 11_stockout_vs_revenue.sql
│   ├── 12_monthly_revenue_trends.sql
│   └── 13_quarterly_revenue_trends.sql
│
├── screenshots/
│
├── README.md
│
└── RetailDW.db
```

---

## Author

**Talifhani Edward Nedambale**
Junior Data Analyst | SQL | Python | Power BI | Data Analytics
