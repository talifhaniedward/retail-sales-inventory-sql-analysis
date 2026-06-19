# Retail Sales & Inventory Analytics using SQL

## Overview

This project analyzes **retail sales, profitability, inventory performance, customer behavior, and store efficiency** for a national electronics retailer using **SQL, SQLite, dimensional modeling, and business analytics**.

The objective was to answer **executive-level business questions** and generate **data-driven recommendations** to improve operational efficiency, profitability, customer value, and inventory management.

The analysis was performed on a large-scale retail database containing:

* **1.2 million+ rows analyzed across 6 tables**
* Inventory transactions
* Customer segmentation data
* Product-level performance
* Store performance across South African provinces

---
## Key Project Metrics

- **1.2 million+ rows analyzed across 6 tables**
- **500,000 sales transactions**
- **500,000 inventory records**
- **100,000 unique customers**
- **100,000 products across 7 brands**
- **100 stores across 4 South African provinces**
- **3-year time-series (1,095 days: 2024–2026)**

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

[See full Q1 output here](outputs/q1_provincial_performance.csv)



### Key Insight

**Gauteng is the strongest contributor to company performance**, generating the highest revenue (**R7.63B**) and profit (**R1.47B**).

### Recommendation

Continue investing in Gauteng as the highest revenue-generating province, but focus on improving efficiency at the store level to maximise returns on that investment.
---


---

## Q2. Which province is most efficient?

### Business Question

Which province performs best after normalizing revenue by store count?

### SQL Query
```sql
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

[See full Q2 output here](outputs/q2_province_efficiency.csv)

### Key Insight

**Western Cape achieved the highest revenue per store**, outperforming Gauteng despite having fewer stores.

This indicates **stronger operational efficiency**.

### Recommendation

Review what Western Cape stores are doing differently and apply those same practices to stores in KwaZulu-Natal and Eastern Cape.

---

## Q3. Is store saturation reducing efficiency?

### Business Question

Does store density reduce customer concentration?

### SQL Query
```sql
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

[See full Q3 output here](outputs/q3_store_saturation.csv)


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

[See full Q4 output here](outputs/q4_inventory_availability.csv)

### Key Insight

**Eastern Cape recorded the highest stockout rate (11.98%)**, potentially affecting sales performance.

### Recommendation

Make Eastern Cape the priority for inventory improvement. With the highest stockout rate nationally, stores in this province are likely losing sales due to empty shelves.


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

[See full Q5 output here](outputs/q5_inventory_problem_stores.csv)

### Key Insight

Multiple stores in **Eastern Cape and KwaZulu-Natal recorded stockout rates above 15%**, indicating supply chain inefficiencies.

### Recommendation

Immediately audit the top 10 stores with the highest stockout rates and put an emergency restocking plan in place. These stores are the highest risk to daily revenue.


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

[See full Q6 output here](outputs/q6_brand_performance.csv)


### Key Insight

**HP, Dell, and Lenovo dominate revenue and profit generation**.

### Recommendation

Always keep HP, Dell, and Lenovo products in stock. These three brands drive the most revenue and profit a shortage of any of them will have a direct impact on the business.


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

[See full Q7 output here](outputs/q7_product_profitability.csv)


### Key Insight

**Laptops are the primary revenue drivers across all brands**.

### Recommendation

Keep laptop stock levels high at all times, especially in Eastern Cape and KwaZulu-Natal where stockouts are already a problem. Laptops are the top revenue driver across every brand.

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

[See full Q8 output here](outputs/q8_profit_margin_analysis.csv)


### Key Insight

**Monitors and Printers generated the highest profit margins**, despite lower revenue volumes.

### Recommendation

Train sales staff to recommend a Monitor or Printer with every Laptop or Desktop sale. These products have the highest profit margins and selling more of them will improve overall profitability.

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

[See full Q9 output here](outputs/q9_customer_segments.csv)


### Key Insight

**Corporate customers generated the highest revenue and revenue per customer**.

### Recommendation

Build a dedicated sales team for Corporate and Education customers. They spend the most per transaction giving them personalised service and volume discounts will grow their loyalty and increase revenue.

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

[See full Q10 output here](outputs/q10_high_value_customers)


### Key Insight

**KwaZulu-Natal recorded the highest revenue per customer**.

### Recommendation

Protect the customer base in KwaZulu-Natal. These customers spend the most per transaction introduce a loyalty programme to retain them and attract more customers with the same spending profile..

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

[See full Q11 output here](outputs/q11_stockout_vs_revenue.csv)

### Key Insight

**Eastern Cape and KwaZulu-Natal recorded higher stockout rates and lower revenue performance**, suggesting inventory shortages may constrain growth.

### Recommendation

Treat inventory shortages in Eastern Cape and KwaZulu-Natal as a revenue problem, not just a supply chain problem. Fixing stock availability in these provinces is one of the fastest ways to grow revenue there.



## Q12. How has revenue changed over time?
### Business Question

What are the monthly revenue trends and seasonal patterns?

### SQL Query
```sql
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

[See full Q12 output here](outputs/q12_monthly_revenue.csv)

### Key Insight

**Revenue remained relatively stable across the 3-year period, indicating predictable business performance.**

However:

* January consistently delivered the strongest revenue
* February showed recurring revenue dips

This suggests strong seasonal patterns in customer purchasing behavior.

### Recommendation
* Stock up and increase marketing spend every December to prepare for the January peak.
* Launch a targeted promotion every February to prevent the recurring revenue dip that happens every year.

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

[See full Q13 output here](outputs/q13_quarterly_revenue.csv)

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

✅ Laptops drive revenue while Monitors and Printers maximize margins.

✅ Corporate customers are the highest-value segment.

---

# Strategic Business Recommendations

### 1. Optimize Gauteng Store Density

Reduce market cannibalization by reviewing store concentration.

### 2. Improve Eastern Cape Inventory Planning

Strengthen replenishment forecasting to reduce stockouts.

### 3. Replicate Western Cape Success

Apply best-performing operational strategies nationally.

### 4. Increase Cross-Selling of High-Margin Products

Bundle Monitors and Printers with Laptops and Desktops to improve overall margins.

### 5. Expand Corporate Customer Strategy

Focus on high-value B2B customers.

---

## Skills Demonstrated

### SQL Skills

* SQL Joins
* Aggregations
* GROUP BY
* CASE WHEN
* CTEs (Common Table Expressions)
* Views
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

## How to Run This Project
Prerequisites
* DB Browser for SQLite — free tool to open and query the database
* VS Code — optional, for editing SQL files
Steps
1. Clone the repository
```bash
git clone https://github.com/talifhaniedward/retail-business-analytics-sql-project.git
```
2. Extract the database
* Go to the `data/` folder
* Extract `RetailDW.db.zip`
* You will get `RetailDW.db`
3. Open the database
* Open DB Browser for SQLite
* Click Open Database
* Select `RetailDW.db`
4. Run the queries
* Go to the `sql_queries/` folder
* Open any `.sql` file
* Copy the query
* Paste it into DB Browser under the Execute SQL tab
* Click Run ▶️
5. View the outputs
* All query results are saved in the `outputs/` folder as CSV files
* Open any CSV file in Excel to view the results without running the database
---

## Repository Structure

```text
retail-business-analytics-sql-project/
│
├── data/                    
│   └── RetailDW.db.zip
│
├── sql_queries/
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
├── outputs/
│   ├── q1_provincial_performance.csv
│   ├── q2_province_efficiency.csv
│   ├── q3_store_saturation.csv
│   ├── q4_inventory_availability.csv
│   ├── q5_inventory_problem_stores.csv
│   ├── q6_brand_performance.csv
│   ├── q7_product_profitability.csv
│   ├── q8_profit_margin_analysis.csv
│   ├── q9_customer_segments.csv
│   ├── q10_high_value_customers.csv
│   ├── q11_stockout_vs_revenue.csv
│   ├── q12_monthly_revenue.csv
│   └── q13_quarterly_revenue.csv
│
└── README.md
```


## Author

**Talifhani Edward Nedambale**

Junior Data Analyst | SQL | Python | Power BI | Data Analytics

- LinkedIn: http://www.linkedin.com/in/talifhani-edward-nedambale/
- GitHub: https://github.com/talifhaniedward
