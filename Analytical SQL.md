# Select Query
```sql
select product_id
from
(
    -- products that have sold for more than 30 days in the last 60 days
    select product_id
    from
    (
        -- products sold in the last 60 days
        select items.product_id, last_2_mths_orders.order_date
        from 
        (
            select p.product_id, i.order_item_order_id
            from products p join order_items i
            on p.product_id = i.order_item_product_id
        ) as items
        inner join
        (
            select order_id, order_date
            from orders
            where order_date >= NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-60
        ) as last_2_mths_orders
        on items.order_item_order_id = last_2_mths_orders.order_id
    ) as products_last_2_mths
    group by order_date, product_id
    having count(*) > 30
) as a
left outer join
(
    -- products that have been sold in the last week
    select items.product_id
    from 
    (
        select p.product_id, i.order_item_order_id
        from products p join order_items i
        on p.product_id = i.order_item_product_id
    ) as items
    inner join
    (
        -- all the orders made in the past week
        select order_id
        from orders
        where order_date >= NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7
        and order_date < NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER
    ) as last_week_orders
    on items.order_item_order_id = last_week_orders.order_id
) as b
where b.product_id is null

```

# Implementing Business Logics in Data Marts

![Star Diagram](https://github.com/tokxinyi/blob/main/star_diagram.png)

We can create the sales fact view with the sales numbers aggregated based on the dates, product_id or other columns based on requirements. Then the business units can get the aggregated data without having to use filters or group by.