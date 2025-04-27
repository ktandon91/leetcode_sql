# Solution 1 complex query slow
with unique_products as(
    select distinct product_id from Products
), filtered_data AS (
    SELECT 
        product_id, 
        new_price, 
        change_date, 
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY change_date DESC) AS row_number
    FROM Products
    WHERE change_date < DATE '2019-08-17'
)
SELECT up.product_id, 
    case when fd.new_price is null then 10 
         else fd.new_price
         end as price
from unique_products up left join filtered_data fd 
on up.product_id = fd.product_id
where row_number is null or row_number = 1;


# Solution 2 union fast
(
  SELECT 
    product_id, 
    10 AS price
  FROM Products
  GROUP BY product_id
  HAVING MIN(change_date) > DATE '2019-08-16'
)
UNION
(
  SELECT 
    p2.product_id, 
    p2.new_price
  FROM Products p2
  WHERE (p2.product_id, p2.change_date) IN (
    SELECT 
      product_id, 
      MAX(change_date) AS recent_date
    FROM Products
    WHERE change_date <= DATE '2019-08-16'
    GROUP BY product_id
  )
);
