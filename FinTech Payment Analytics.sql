CREATE DATABASE payment_analytics_db;

USE payment_analytics_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE merchants (
    merchant_id INT PRIMARY KEY,
    merchant_name VARCHAR(100),
    merchant_category VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    merchant_id INT,
    transaction_date DATETIME,
    amount DECIMAL(12,2),
    payment_method VARCHAR(30),
    transaction_status VARCHAR(30),
    failure_reason VARCHAR(100),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (merchant_id)
        REFERENCES merchants(merchant_id)
);

INSERT INTO customers VALUES
(1,'Rahul Sharma','Mumbai','2025-01-05'),
(2,'Priya Verma','Delhi','2025-01-10'),
(3,'Amit Patel','Pune','2025-01-15'),
(4,'Sneha Joshi','Bangalore','2025-02-01'),
(5,'Rohan Gupta','Hyderabad','2025-02-10');

INSERT INTO merchants VALUES
(101,'Amazon','E-Commerce','Bangalore'),
(102,'Swiggy','Food Delivery','Bangalore'),
(103,'Flipkart','E-Commerce','Bangalore'),
(104,'Apollo Pharmacy','Healthcare','Pune'),
(105,'IRCTC','Travel','Delhi');

INSERT INTO transactions VALUES
(1001,1,101,'2025-03-01 10:15:00',4500,'UPI','Success',NULL),
(1002,2,102,'2025-03-01 12:30:00',850,'Credit Card','Success',NULL),
(1003,3,103,'2025-03-02 15:45:00',7200,'UPI','Failed','Insufficient Balance'),
(1004,4,104,'2025-03-03 09:20:00',1200,'Debit Card','Success',NULL),
(1005,5,105,'2025-03-03 18:10:00',3500,'Net Banking','Success',NULL),
(1006,1,102,'2025-03-04 20:15:00',1800,'UPI','Failed','Technical Error'),
(1007,3,101,'2025-03-05 11:40:00',12500,'Credit Card','Success',NULL),
(1008,2,104,'2025-03-06 14:25:00',2500,'UPI','Success',NULL);
SELECT * FROM customers;
select * from merchants;
select * from transactions;
select
    count(*) as total_transactions
from transactions;
select
   count(*) as successful_transactions
from transactions
where transaction_status = 'Success'; 
select
    count(*) as falied_transactions
from transactions
where transaction_status = 'failed';
SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN transaction_status = 'Success'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS success_rate
FROM transactions;
SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN transaction_status = 'Failed'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS success_rate
FROM transactions;
select
    sum(amount) as total_transaction_value
from transactions;
select
    sum(amount)as successful_transaction_value
from transactions
where transaction_status = 'success';
select 
   round(avg(amount),2) as average_transaction_value
from transactions;
select 
    payment_method,
    count(*) as transaction_count
from transactions
group by payment_method
order by transaction_count desc;
SELECT
    payment_method,
    COUNT(*) AS successful_transactions,
    SUM(amount) AS successful_transaction_value
FROM transactions
WHERE transaction_status = 'Success'
GROUP BY payment_method
ORDER BY successful_transaction_value DESC;
SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    
    SUM(
        CASE
            WHEN transaction_status = 'Failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN transaction_status = 'Failed'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate

FROM transactions
GROUP BY payment_method
ORDER BY failure_rate DESC;
SELECT
    payment_method,
    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN transaction_status = 'Success'
            THEN 1
            ELSE 0
        END
    ) AS successful_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN transaction_status = 'Success'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS success_rate

FROM transactions
GROUP BY payment_method
ORDER BY success_rate DESC;
select
     m.merchant_name,
     COUNT(t.transaction_id) AS transaction_count
FROM merchants m
JOIN transactions t
     ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_name
ORDER BY transaction_count DESC;
SELECT 
	m.merchant_name,
	COUNT(t.transaction_id) AS successful_transactions,
	SUM(t.amount) AS transaction_value
FROM merchants m
JOIN transactions t
	ON m.merchant_id = t.merchant_id
WHERE t.transaction_status = 'Success'
GROUP BY m.merchant_name
ORDER BY transaction_value DESC;
SELECT 
    m.merchant_name,
    SUM(t.amount) AS transaction_value
FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
WHERE t.transaction_status = 'Success'
GROUP BY m.merchant_name
ORDER BY transaction_value DESC 
LIMIT 3;
SELECT
     m.merchant_name,
     COUNT(t.transaction_id) AS failed_transactions,
     SUM(t.amount) AS failed_transaction_value
FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
WHERE t.transaction_status = 'Failed'
GROUP BY m.merchant_name
ORDER BY failed_transactions DESC;
SELECT
    m.merchant_name,

    COUNT(t.transaction_id) AS total_transactions,

    SUM(
        CASE
            WHEN t.transaction_status = 'Success'
            THEN 1
            ELSE 0
        END
    ) AS successful_transactions,

    SUM(
        CASE
            WHEN t.transaction_status = 'Failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions

FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_name
ORDER BY total_transactions DESC;
SELECT
    m.merchant_name,

    COUNT(t.transaction_id) AS total_transactions,

    SUM(
        CASE
            WHEN t.transaction_status = 'Failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN t.transaction_status = 'Failed'
                THEN 1
                ELSE 0
            END
        ) / COUNT(t.transaction_id),
        2
    ) AS failure_rate

FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_name
ORDER BY failure_rate DESC;
WITH merchant_summary AS (
    SELECT
         m.merchant_id,
         m.merchant_name,
         SUM(t.amount) AS transaction_value
	FROM merchants m
    JOIN transactions t
        ON m.merchant_id = t.merchant_id
	WHERE t.transaction_status = 'Success'
    GROUP BY 
        m.merchant_id,
        m.merchant_name
)
SELECT
     merchant_name,
     transaction_value,
	
     DENSE_RANK() OVER (
         ORDER BY transaction_value DESC
         ) AS merchant_rank
         
FROM merchant_summary;
SELECT
     c.customer_id,
     c.customer_name,
     COUNT(t.transaction_id) AS transaction_count
FROM customers c
JOIN transactions t
	ON c.customer_id = t.customer_id 
GROUP BY
     c.customer_id,
     c.customer_name
ORDER BY transaction_count DESC;
select 
	 c.customer_id,
     c.customer_name,
     SUM(t.amount) AS total_transaction_value
FROM customers c
JOIN transactions t 
    ON c.customer_id = t.customer_id
GROUP BY
     c.customer_id,
     c.customer_name
ORDER BY total_transaction_value DESC;
select 
	 c.customer_id,
     c.customer_name,
     COUNT(t.transaction_id) AS successful_transactions
FROM customers c
JOIN transactions t 
    ON c.customer_id = t.customer_id
WHERE t.transaction_status = 'Success'
GROUP BY
     c.customer_id,
     c.customer_name
HAVING COUNT(t.transaction_id) >= 2
ORDER BY successful_transactions DESC;
SELECT
    c.customer_id,
    c.customer_name,
    SUM(t.amount) AS total_spend
FROM customers c
JOIN transactions t 
    ON c.customer_id = t.customer_id
WHERE t.transaction_status = 'Success'
GROUP BY
     c.customer_id,
     c.customer_name
HAVING SUM(t.amount)> 10000
ORDER BY total_spend DESC;
SELECT
    c.customer_id,
    c.customer_name,

    COUNT(t.transaction_id) AS total_transactions,

    SUM(
        CASE
            WHEN t.transaction_status = 'Success'
            THEN 1
            ELSE 0
        END
    ) AS successful_transactions,

    SUM(
        CASE
            WHEN t.transaction_status = 'Failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,

    SUM(t.amount) AS total_transaction_value

FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY total_transaction_value DESC;
WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(t.amount) AS successful_spending
    FROM customers c
    JOIN transactions t
        ON c.customer_id = t.customer_id
    WHERE t.transaction_status = 'Success'
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
     customer_id,
     customer_name,
     successful_spending,
     
     DENSE_RANK() OVER (
         ORDER BY successful_spending DESC
	  ) AS customer_rank
      
FROM customer_summary
ORDER BY customer_rank;
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY transaction_month;

SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    COUNT(*) AS transaction_count,
    SUM(amount) AS transaction_value
FROM transactions
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY transaction_month;

SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    COUNT(*) AS successful_transactions,
    SUM(amount) AS successful_transaction_value
FROM transactions
WHERE transaction_status = 'Success'
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY transaction_month;

SELECT 
     HOUR(transaction_date) AS transaction_hour,
     COUNT(*) AS transaction_count
FROM transactions
GROUP BY HOUR (transaction_date)
ORDER BY transaction_count DESC;

SELECT
     DATE(transaction_date) AS transaction_date,
     COUNT(*) AS transaction_count
FROM transactions
GROUP BY DATE (transaction_date)
ORDER BY transaction_count DESC
LIMIT 1;

WITH hourly_transactions AS (
    SELECT
        HOUR(transaction_date) AS transaction_hour,
        COUNT(*) AS transaction_count
    FROM transactions
    GROUP BY HOUR(transaction_date)
)

SELECT
    transaction_hour,
    transaction_count,
    RANK() OVER (
        ORDER BY transaction_count DESC
    ) AS hour_rank
FROM hourly_transactions
ORDER BY hour_rank;

SELECT
    failure_reason,
    COUNT(*) AS failed_transactions,
    SUM(amount) AS failed_transaction_value
FROM transactions
WHERE transaction_status = 'Failed'
GROUP BY failure_reason
ORDER BY failed_transactions DESC;

SELECT
     transaction_id,
     customer_id,
     merchant_id,
     transaction_date,
     amount,
     payment_method,
     failure_reason
FROM transactions
WHERE transaction_status = 'Failed'
   AND amount > 5000
ORDER BY amount DESC;
     
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(t.transaction_id) AS failed_transactions,
    SUM(t.amount) AS failed_transaction_value
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
WHERE t.transaction_status = 'Failed'
GROUP BY c.customer_id, c.customer_name
ORDER BY failed_transactions DESC;

SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN transaction_status = 'Failed'
                THEN amount
                ELSE 0
            END
        ) / SUM(amount),
        2
    ) AS failed_transaction_value_percentage
FROM transactions;

SELECT
    transaction_id,
    customer_id,
    merchant_id,
    amount,
    payment_method,
    transaction_status,
    failure_reason,
    CASE
        WHEN amount > 10000 THEN 'High Value'
        WHEN transaction_status = 'Failed' AND amount > 5000
            THEN 'High Value Failed'
        ELSE 'Normal'
    END AS risk_candidate
FROM transactions
ORDER BY amount DESC;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(t.amount) AS total_spend
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
WHERE t.transaction_status = 'Success'
GROUP BY c.customer_id, c.customer_name
HAVING SUM(t.amount) > (
    SELECT AVG(customer_spend)
    FROM (
        SELECT
            customer_id,
            SUM(amount) AS customer_spend
        FROM transactions
        WHERE transaction_status = 'Success'
        GROUP BY customer_id
    ) AS customer_summary
)
ORDER BY total_spend DESC;

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(t.amount) AS total_spend
    FROM customers c
    JOIN transactions t
        ON c.customer_id = t.customer_id
    WHERE t.transaction_status = 'Success'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spend,
    DENSE_RANK() OVER (
        ORDER BY total_spend DESC
    ) AS customer_rank
FROM customer_spending
ORDER BY customer_rank
LIMIT 3;

WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(amount) AS total_spend
    FROM transactions
    WHERE transaction_status = 'Success'
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_spend,
    ROUND(
        100.0 * total_spend /
        SUM(total_spend) OVER (),
        2
    ) AS spending_percentage
FROM customer_spending
ORDER BY total_spend DESC;

WITH merchant_spending AS (
    SELECT
        m.merchant_name,
        SUM(t.amount) AS merchant_value
    FROM merchants m
    JOIN transactions t
        ON m.merchant_id = t.merchant_id
    WHERE t.transaction_status = 'Success'
    GROUP BY m.merchant_name
)
SELECT
    merchant_name,
    merchant_value,
    ROUND(
        100.0 * merchant_value /
        SUM(merchant_value) OVER (),
        2
    ) AS contribution_percentage
FROM merchant_spending
ORDER BY merchant_value DESC;

WITH ranked_transactions AS (
    SELECT
        customer_id,
        transaction_id,
        transaction_date,
        amount,
        transaction_status,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS transaction_number
    FROM transactions
)
SELECT
    customer_id,
    transaction_id,
    transaction_date,
    amount,
    transaction_status
FROM ranked_transactions
WHERE transaction_number = 1
ORDER BY customer_id;

WITH ranked_transactions AS (
    SELECT
        customer_id,
        transaction_id,
        transaction_date,
        amount,
        transaction_status,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date DESC
        ) AS transaction_number
    FROM transactions
)
SELECT
    customer_id,
    transaction_id,
    transaction_date,
    amount,
    transaction_status
FROM ranked_transactions
WHERE transaction_number = 1
ORDER BY customer_id;

SELECT
    customer_id,
    transaction_id,
    transaction_date,
    amount,
    LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY transaction_date
    ) AS previous_transaction_amount
FROM transactions
ORDER BY customer_id, transaction_date;

WITH transaction_history AS (
    SELECT
        customer_id,
        transaction_id,
        transaction_date,
        amount,
        LAG(amount) OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS previous_amount
    FROM transactions
)
SELECT
    customer_id,
    transaction_id,
    amount,
    previous_amount,
    amount - previous_amount AS amount_change
FROM transaction_history
ORDER BY customer_id, transaction_date;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(
        CASE
            WHEN t.transaction_status = 'Success' THEN 1
            ELSE 0
        END
    ) AS successful_transactions,
    SUM(
        CASE
            WHEN t.transaction_status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_transactions
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY failed_transactions DESC;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(
        CASE
            WHEN t.transaction_status = 'Success'
            THEN 1
            ELSE 0
        END
    ) AS successful_transactions,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN t.transaction_status = 'Success'
                THEN 1
                ELSE 0
            END
        ) / COUNT(t.transaction_id),
        2
    ) AS success_rate
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY success_rate DESC;

SELECT
    customer_id,
    payment_method,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY customer_id, payment_method
ORDER BY customer_id, transaction_count DESC;

SELECT
    payment_method,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY payment_method
ORDER BY transaction_count DESC
LIMIT 1;

SELECT
    payment_method,
    SUM(amount) AS transaction_value
FROM transactions
WHERE transaction_status = 'Success'
GROUP BY payment_method
ORDER BY transaction_value DESC
LIMIT 1;

SELECT
    m.merchant_name,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(AVG(t.amount), 2) AS average_transaction_value
FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_name
ORDER BY average_transaction_value DESC;

SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(
        CASE
            WHEN transaction_status = 'Success'
            THEN 1
            ELSE 0
        END
    ) AS successful_transactions,
    SUM(
        CASE
            WHEN transaction_status = 'Failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN transaction_status = 'Success'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS success_rate
FROM transactions
GROUP BY payment_method
ORDER BY success_rate DESC;

SELECT
    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN transaction_status = 'Success'
            THEN 1
            ELSE 0
        END
    ) AS successful_transactions,

    SUM(
        CASE
            WHEN transaction_status = 'Failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,

    SUM(amount) AS total_transaction_value,

    SUM(
        CASE
            WHEN transaction_status = 'Success'
            THEN amount
            ELSE 0
        END
    ) AS successful_transaction_value,

    ROUND(AVG(amount), 2) AS average_transaction_value,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN transaction_status = 'Success'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS success_rate,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN transaction_status = 'Failed'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS failure_rate

FROM transactions;

SELECT
    COUNT(*) AS total_transactions,

    SUM(CASE
        WHEN transaction_status = 'Success' THEN 1
        ELSE 0
    END) AS successful_transactions,

    SUM(CASE
        WHEN transaction_status = 'Failed' THEN 1
        ELSE 0
    END) AS failed_transactions,

    ROUND(
        100.0 * SUM(CASE
            WHEN transaction_status = 'Success' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS success_rate,

    SUM(amount) AS total_transaction_value,

    SUM(CASE
        WHEN transaction_status = 'Success' THEN amount
        ELSE 0
    END) AS successful_transaction_value,

    ROUND(AVG(amount), 2) AS average_transaction_value

FROM transactions;

SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,

    COUNT(*) AS total_transactions,

    SUM(CASE
        WHEN transaction_status = 'Success' THEN 1
        ELSE 0
    END) AS successful_transactions,

    SUM(CASE
        WHEN transaction_status = 'Failed' THEN 1
        ELSE 0
    END) AS failed_transactions,

    SUM(amount) AS transaction_value

FROM transactions
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY transaction_month;

SELECT
    payment_method,
    COUNT(*) AS total_transactions,

    SUM(CASE
        WHEN transaction_status = 'Success' THEN 1
        ELSE 0
    END) AS successful_transactions,

    SUM(CASE
        WHEN transaction_status = 'Failed' THEN 1
        ELSE 0
    END) AS failed_transactions,

    SUM(amount) AS transaction_value,

    ROUND(
        100.0 * SUM(CASE
            WHEN transaction_status = 'Success' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS success_rate

FROM transactions
GROUP BY payment_method
ORDER BY transaction_value DESC;

SELECT
    m.merchant_name,
    m.merchant_category,

    COUNT(t.transaction_id) AS total_transactions,

    SUM(CASE
        WHEN t.transaction_status = 'Success' THEN 1
        ELSE 0
    END) AS successful_transactions,

    SUM(CASE
        WHEN t.transaction_status = 'Failed' THEN 1
        ELSE 0
    END) AS failed_transactions,

    SUM(t.amount) AS transaction_value,

    ROUND(
        100.0 * SUM(CASE
            WHEN t.transaction_status = 'Success' THEN 1
            ELSE 0
        END) / COUNT(t.transaction_id),
        2
    ) AS success_rate

FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_name,
    m.merchant_category
ORDER BY transaction_value DESC;

SELECT
    failure_reason,
    COUNT(*) AS failed_transactions,
    SUM(amount) AS failed_transaction_value,

    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*)
         FROM transactions
         WHERE transaction_status = 'Failed'),
        2
    ) AS failure_percentage

FROM transactions
WHERE transaction_status = 'Failed'
GROUP BY failure_reason
ORDER BY failed_transactions DESC;  

SELECT
    c.customer_id,
    c.customer_name,
    c.city,

    COUNT(t.transaction_id) AS total_transactions,

    SUM(CASE
        WHEN t.transaction_status = 'Success' THEN 1
        ELSE 0
    END) AS successful_transactions,

    SUM(CASE
        WHEN t.transaction_status = 'Failed' THEN 1
        ELSE 0
    END) AS failed_transactions,

    SUM(CASE
        WHEN t.transaction_status = 'Success'
        THEN t.amount
        ELSE 0
    END) AS successful_spending

FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id

GROUP BY
    c.customer_id,
    c.customer_name,
    c.city

ORDER BY successful_spending DESC;