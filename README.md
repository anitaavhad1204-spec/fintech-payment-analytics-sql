# FinTech Payment Analytics 💳📊

## Project Overview

This project analyzes digital payment transaction data using SQL to understand transaction performance, customer behavior, merchant performance, payment methods, payment failures, and potential risk patterns.

The analysis is designed to support business decision-making and executive payment analytics dashboards.

## Business Objectives

- Analyze total transaction volume and transaction value
- Measure payment success and failure rates
- Analyze payment method performance
- Evaluate merchant performance
- Understand customer transaction behavior and spending
- Identify common payment failure reasons
- Analyze high-value and unusual transaction candidates
- Generate executive-level payment KPIs

## Database Tables

The project uses three main tables:

### Customers
- customer_id
- customer_name
- city
- signup_date

### Merchants
- merchant_id
- merchant_name
- merchant_category
- city

### Transactions
- transaction_id
- customer_id
- merchant_id
- transaction_date
- amount
- payment_method
- transaction_status
- failure_reason

## SQL Concepts Used

- SELECT, WHERE, ORDER BY
- GROUP BY and HAVING
- INNER JOIN and LEFT JOIN
- COUNT, SUM, AVG
- CASE WHEN
- Conditional Aggregation
- Common Table Expressions (CTEs)
- Subqueries
- RANK
- DENSE_RANK
- ROW_NUMBER
- LAG
- Date and Time Functions
- Window Functions

## Analysis Areas

### 1. Payment Performance
- Total transactions
- Successful transactions
- Failed transactions
- Success rate
- Failure rate
- Total transaction value
- Successful transaction value
- Average transaction value

### 2. Payment Method Analysis
- Transaction volume by payment method
- Transaction value by payment method
- Success rate by payment method
- Failure rate by payment method

### 3. Merchant Analysis
- Merchant transaction volume
- Merchant transaction value
- Merchant success/failure analysis
- Merchant ranking
- Average transaction value

### 4. Customer Analysis
- Customer transaction count
- Customer spending
- Successful spending
- Repeat customers
- High-value customers
- Customer success/failure behavior
- Customer ranking

### 5. Date & Time Analysis
- Monthly transaction trends
- Transaction volume by hour
- Transaction volume by day
- Peak transaction periods

### 6. Failure & Risk Analysis
- Failure reason analysis
- Failed transaction value
- High-value failed transactions
- Customer-level failures
- Unusual transaction candidates

### 7. Advanced SQL Analysis
- Customer spending contribution
- Merchant contribution
- First and latest transactions
- Previous transaction analysis using LAG
- Transaction amount changes
- Ranking and window-function analysis

## Key Findings from Sample Dataset

- Total transactions: 8
- Successful transactions: 6
- Failed transactions: 2
- Success rate: 75%
- Failure rate: 25%
- Total transaction value: ₹34,050
- Successful transaction value: ₹25,050
- Average transaction value: ₹4,256.25

In the sample dataset, UPI had the highest transaction volume, while Amazon had the highest successful transaction value.

## Tools

- MySQL
- SQL
- Power BI

## Project Purpose

This project demonstrates how SQL can be used to transform raw transaction data into business-focused insights and KPI outputs for data analysis and reporting.
