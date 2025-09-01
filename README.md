# 🚀 Business Analytics: Food & Grocery Delivery Platform

[![SQL](https://img.shields.io/badge/SQL-Query%20Analysis-blue)](https://www.mysql.com/)
[![Business Intelligence](https://img.shields.io/badge/Business-Intelligence-orange)](https://en.wikipedia.org/wiki/Business_intelligence)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A detailed **Exploratory Data Analysis (EDA)** and **Business Intelligence** case study performed using **SQL** on an anonymized dataset simulating a real-world food and grocery delivery platform. The project focuses on extracting key performance indicators (KPIs) to solve critical business problems and provide strategic recommendations.

## 📊 Project Overview

In the hyper-competitive quick-commerce industry, leveraging data is key to survival. This project simulates the role of a Business Analyst/Data Analyst tasked with helping a delivery platform understand its operational inefficiencies, customer retention challenges, and profitability drivers.

The analysis moves beyond simple querying to build a **strategic decision-making framework**, providing actionable insights backed by data.

## 🎯 Objectives

-   To design and execute SQL queries for extracting crucial business metrics.
-   To analyze customer behavior, operational efficiency, and financial performance.
-   To generate insights for optimizing revenue growth, cost management, and customer loyalty.
-   To recommend actionable, data-backed strategies for business growth.

## 🗃️ Dataset Schema

The analysis is based on four core tables:

1.  **`orders`**: Contains order details like `order_id`, `customer_id`, `order_date`, `total_amount`, `cost`, and `delivery_status`.
2.  **`customers`**: Holds customer information including `customer_id`, `city`, `signup_date`, and `payment_method`.
3.  **`delivery`**: Stores logistics data such as `delivery_id`, `rider_id`, `delivery_time`, and `expected_time`.
4.  **`products`**: Includes product details like `product_id`, `category`, `product_name`, and `cost`.

## 🔍 Key Analysis & SQL Insights

The project delves into 10 critical business areas, including:

1.  **Customer Segmentation**: Classified users into One-time, Low-frequency, and Loyal customers to measure retention.
2.  **Product Performance**: Identified top revenue-generating categories and their margins.
3.  **Geographic Analysis**: Mapped revenue concentration across cities to identify growth opportunities.
4.  **Month-over-Month AOV**: Tracked changes in Average Order Value to understand spending trends.
5.  **Profitability by Category**: Analyzed which product categories drive the highest profit margins.
6.  **Rider Efficiency**: Evaluated delivery partner performance based on on-time delivery rates.
7.  **Geographic Heatmaps**: Visualized order and revenue distribution to guide resource allocation.
8.  **Retention vs. Churn**: Measured the impact of operational issues (like late deliveries) on customer retention.

## 💡 Major Findings & Recommendations

-   **Customer Retention:** ~57% of customers are low-frequency. Implement a structured loyalty program and targeted win-back campaigns.
-   **Operational Cost:** Rider efficiency varies significantly. Introduce dynamic allocation, route optimization, and performance-linked incentives.
-   **Geographic Strategy:** Revenue is highly concentrated in top cities. Recommend hyperlocal marketing and assortment strategies for Tier 2/3 cities.
-   **Profitability:** High-revenue products aren't always high-margin. Suggest re-prioritizing promotions and negotiating vendor costs for low-margin essentials.
-   **AOV Volatility:** Observed significant monthly fluctuations. Advise investigating promo impact and implementing upsell strategies.

## 🛠️ Technical Implementation

The analysis was conducted using **PostgreSQL**-compatible SQL syntax, utilizing advanced features like:
-   Common Table Expressions (CTEs)
-   Window Functions (e.g., `LAG`, `RANK`)
-   Conditional Aggregation (`FILTER` clauses, `CASE` statements)
-   JOIN operations across multiple tables
