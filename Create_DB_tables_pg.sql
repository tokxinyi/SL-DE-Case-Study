-- Postgres Table Creation Script
--

--
-- Table structure for table departments
--

CREATE TABLE departments (
  department_id INT NOT NULL,
  department_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (department_id)
);

--
-- Table structure for table categories
--

CREATE TABLE categories (
  category_id INT NOT NULL,
  category_department_id INT NOT NULL,
  category_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (category_id)
); 

--
-- Table structure for table products
--

CREATE TABLE products (
  product_id INT NOT NULL,
  product_category_id INT NOT NULL,
  product_name VARCHAR(45) NOT NULL,
  product_description VARCHAR(255) NOT NULL,
  product_price FLOAT NOT NULL,
  product_image VARCHAR(255) NOT NULL,
  PRIMARY KEY (product_id)
);

--
-- Table structure for table customers
--

CREATE TABLE customers (
  customer_id INT NOT NULL,
  customer_fname VARCHAR(45) NOT NULL,
  customer_lname VARCHAR(45) NOT NULL,
  customer_email VARCHAR(45) NOT NULL,
  customer_password VARCHAR(45) NOT NULL,
  customer_street VARCHAR(255) NOT NULL,
  customer_city VARCHAR(45) NOT NULL,
  customer_state VARCHAR(45) NOT NULL,
  customer_zipcode VARCHAR(45) NOT NULL,
  PRIMARY KEY (customer_id)
); 

--
-- Table structure for table orders
--

CREATE TABLE orders (
  order_id INT NOT NULL,
  order_date TIMESTAMP NOT NULL,
  order_customer_id INT NOT NULL,
  order_status VARCHAR(45) NOT NULL,
  PRIMARY KEY (order_id)
);

--
-- Table structure for table order_items
--

CREATE TABLE order_items (
  order_item_id INT NOT NULL,
  order_item_order_id INT NOT NULL,
  order_item_product_id INT NOT NULL,
  order_item_quantity INT NOT NULL,
  order_item_subtotal FLOAT NOT NULL,
  order_item_product_price FLOAT NOT NULL,
  PRIMARY KEY (order_item_id)
);



-- partitions (postgresql syntax, may differ for other databases)
alter table orders rename to orders_old; -- assuming the table has been created before


create table orders(
  order_id INT NOT NULL,
  order_date TIMESTAMP NOT NULL,
  order_customer_id INT NOT NULL,
  order_status VARCHAR(45) NOT NULL,
  PRIMARY KEY (order_id, order_date)
) partition by range (order_date);

create table orders_2022 partition of orders
for values from ('2022-01-01 00:00:00') to ('2022-12-31 00:00:00');

create table orders_2021 partition of orders
for values from ('2021-01-01 00:00:00') to ('2021-12-31 00:00:00');

create table orders_2020 partition of orders
for values from ('2020-01-01 00:00:00') to ('2020-12-31 00:00:00');

-- adding foreign keys
alter table orders 
add foreign key (order_customer_id) references customers(customer_id);

--alter table order_items
--add foreign key (order_item_order_id) references orders(order_id);
-- not able to enforce this foreign key because orders now have a primary key of (order_id and order_date) and order_items does not have order_date data

alter table order_items 
add foreign key (order_item_product_id) references products(product_id);

alter table products 
add foreign key (product_category_id) references categories(category_id);

alter table categories
add foreign key (category_department_id) references departments(department_id);


-- migrate data
insert into public.orders (order_id, order_date, order_customer_id, order_status) 
as select * from orders_old;

-- drop the old table after data migration
drop table public.orders_old cascade;


-- create indexes for the foreign keys
create index order_customer_id
on orders (order_customer_id);

create index order_items_product_id
on order_items(order_item_product_id);

create index product_category_id
on products(product_category_id);

create index category_department_id
on categories(category_department_id);
