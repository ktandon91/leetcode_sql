-- Write your PostgreSQL query statement below
-- Solution 1
with cte as (
    select customer_id, order_date, customer_pref_delivery_date,
    (
        CASE 
            when order_date = customer_pref_delivery_date then 1
            else 0
        END
    ) as immediate_order,
    row_number() over (partition by customer_id order by order_date)
    from Delivery
)
select round(avg(immediate_order)*100, 2) as immediate_percentage from cte where row_number=1;

-- Solution 2
SELECT ROUND(
    AVG(
        CASE 
            WHEN order_date !=  customer_pref_delivery_date THEN 0
            ELSE 1
        END
    )*100, 2
) as immediate_percentage 
FROM Delivery
WHERE (customer_id, order_date) in (
    SELECT customer_id, min(order_date)
    FROM Delivery
    GROUP BY customer_id
)

-- Solution 3
SELECT (
  SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1.0 ELSE 0.0 END)::decimal / COUNT(*)::decimal * 100
) as immediate_percentage 
FROM Delivery
WHERE (customer_id, order_date) IN (
  SELECT customer_id, MIN(order_date)
  FROM Delivery
  GROUP BY customer_id
)