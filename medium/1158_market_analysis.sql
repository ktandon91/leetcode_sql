-- Write your PostgreSQL query statement below
SELECT 
  u.user_id AS buyer_id,
  u.join_date,
  coalesce(
    sum(
        case 
            when EXTRACT(YEAR FROM o.order_date) = 2019 then 1
            else 0
        end
    ),
    0
  ) as orders_in_2019
FROM Users u 
LEFT JOIN Orders o ON o.buyer_id = u.user_id
LEFT JOIN Items i ON o.item_id = i.item_id
GROUP BY u.user_id, u.join_date;
