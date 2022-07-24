# Revenue
Tables required:
1. order_items - subtotal
2. orders - date

Assumptions:
1. `order_item_subtotal` is the total price for the order_item (i.e. order_item_quantity * order_item_product_price).

Example query:
```sql
select sum(subtotal)
from orders join order_items
on orders.order_id = order_items.order_item_order_id
group by order_id
where order_date >= 2022-06-01 and order_date <= 2022-06-30
```
What should be created here to improve performance:
1. Create a partition for `order_date` (orders table) in terms of year
2. Create index on `order_id` (created because is defined as primary key)
3. Create index on foreign key `order_item_product_id` at `order_items` table


# Item sales
Tables required:
1. order_items - quantity
2. orders - date

Example query:
```sql
select sum(quantity)
from orders join order_items
group by order_items.product_id, orders.order_date
where order_date >= {time_period}
```
What should be created here to improve performance:
1. Create index on `product_id` (created when defined as primary key)
2. Create a partition for `order_date` (orders table) in terms of year

# Price changes
Assumptions:
1. It is a slowly changing dimension

Tables required:
1. order_items - product_price, order_items_product_id
2. products - price

What should be created here to improve performance:
1. Create a partition for `order_date` (orders table) in terms of year
2. Create index on foreign key `order_item_product_id` at `order_items` table

# Product
Tables required:
1. products
2. order_items
3. orders
4. Categories

Example query:
```sql
select
from products join order_items
on products.product_id = order_items.order_item_product_id

```

What should be created here to improve performance:
1. Create index on `product_id`, `order_item_id` and `order_id` (created when defined as primary key)
2. Create index on foreign keys on the following tables:
    - orders: order_customer_id
    - order_items: order_item_product_id
    - products: product_category_id
    - categories: category_department_id

# Customer
Tables required:
1. customers

What should be created here to improve performance:
1. Create index on customer_id (created when defined as primary key)
2. Create a partition for `order_date` (orders table) in terms of year

# Date

What should be created here to improve performance:
1. Create a partition for order_date (done in #1 in revenue)

# Conclusion
After considering all the different use cases that the business need for analysis, the following should be created:
1. Partitioning of the orders table by date because it is used quite often. Partitioning will reduce the number of rows that the database has to scan during query.
2. Making sure that the indexes of the primary keys are created.
3. Foreign keys are added to ensure referential integrity of the data.
4. To improve the lookup times, indexes for the foreign keys are added as well.

# ER Diagram
![ER Diagram](https://github.com/tokxinyi/SL-DE-Case-Study//blob/main/er_diagram.png)