WITH CTE AS (
    SELECT product_id, year as first_year, quantity, price, RANK() OVER (PARTITION BY product_id order by year) as rank 
    FROM Sales
)
select product_id, first_year, quantity, price from CTE where rank=1;