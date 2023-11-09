DROP DATABASE IF EXISTS QUANLYBANHANG;
CREATE DATABASE QUANLYBANHANG;
use QUANLYBANHANG;

CREATE TABLE CUSTOMERS(
customer_id varchar(4) primary key not null,
name varchar(100) not null,
email varchar(100) not null,
phone varchar(25) not null unique,
address varchar(255) not null unique
);

CREATE TABLE ORDERS(
order_id varchar(4) primary key not null,
customer_id varchar(4) not null,
order_date date not null,
total_amount double not null,
foreign key (customer_id) references CUSTOMERS(customer_id)
);

CREATE TABLE PRODUCTS(
product_id varchar(4) primary key not null,
name varchar(255) not null,
description text,
price double not null,
status bit default(1) not null
);

CREATE TABLE ORDERS_DETAILS(
order_id varchar(4) not null,
product_id varchar(4) not null,
quantity int(11) not null,
price double not null,
primary key(order_id,product_id),
foreign key (order_id) references orders(order_id),
foreign key (product_id) references PRODUCTS(product_id)
);

insert into customers(customer_id,name,email,phone,address) values("C001","Nguyễn Trung Mạnh","manhnt@gmail.com","984756322","Cầy Giấy, Hà Nội"),
("C002","Hồ Hải Nam","namhh@gmail.com","984875926","Ba Vì, Hà Nội"),
("C003","Tô Ngọc Vũ","vutn@gmail.com","904725784","Mộc Châu, Sơn La"),
("C004","Phạm Ngọc Anh","anhpn@gmail.com","984635365","Vinh , Nghệ An"),
("C005","Trương Minh Cường","cuongtm@gmail.com","9897356242","Hai Bà Trưng, Hà Nội");

insert into products(product_id,name,description,price) values("P001","Iphone 13proMax","Bản 512GB, xanh lá",22999999),
("P002","Dell Vostro V3510","Core i5, RAM 8GB",14999999),
("P003","Macbook Pro M2","8CPU 10GPU 8GB 256GB",28999999),
("P004","Apple Watch Ultra","Titanium Alpine loop Small",18999999),
("P005","Airpods 2 2022","Spatial Audio",4090000);

INSERT INTO ORDERS(order_id, customer_id, total_amount,order_date) value
("H001","C001",52999997,"2023/2/22"),
("H002","C001",80999997,"2023/3/11"),
("H003","C002",54359998,"2023/1/22"),
("H004","C003",102999995,"2023/3/14"),
("H005","C003",80999997,"2022/3/12"),
("H006","C004",110449994,"2023/2/1"),
("H007","C004",79999996,"2023/3/29"),
("H008","C005",29999998,"2023/2/14"),
("H009","C005",28999999,"2023/1/10"),
("H010","C005",149999994,"2023/4/1");

INSERT INTO ORDERS_DETAILS(order_id, product_id, price,quantity) value
("H001", "P002", 14999999,1),
("H001", "P004", 18999999,2),
("H002", "P001", 22999999,1),
("H002", "P003", 28999999,2),
("H003", "P004", 18999999,2),
("H003", "P005", 4090000,4),
("H004", "P002", 14999999,3),
("H004", "P003", 28999999,2),
("H005", "P001", 12999999,1),
("H005", "P003", 28999999,2),
("H006", "P005", 4090000,5),
("H006", "P002", 14999999,6),
("H007", "P004", 18999999,3),
("H007", "P001", 22999999,1),
("H008", "P002", 14999999,2),
("H009", "P003", 28999999,1),
("H010", "P003", 28999999,2),
("H010", "P001", 22999999,4);

-- Bài 3: Truy vấn dữ liệu
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
SELECT name, email, phone, address FROM customers;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
-- thoại và địa chỉ khách hàng).
SELECT distinct name,phone, address FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE year(orders.order_date) = "2023"and MONTH(orders.order_date) = "3";

-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm 
-- tháng và tổng doanh thu ).
SELECT month(order_date) as Thang, sum(total_amount) as Tongdoanhthu FROM orders
WHERE YEAR(order_date) = 2023
GROUP BY month(order_date)
order by month(order_date);

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
-- hàng, địa chỉ , email và số điên thoại).
SELECT name, address, email, phone FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE MONTH(orders.order_date) <> 2 and YEAR(orders.order_date) = 2023;

-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
-- sản phẩm, tên sản phẩm và số lượng bán ra).
SELECT products.product_id as "Mã sản phẩm", name,sum(od.quantity) as "Số lượng bán" FROM products
JOIN orders_details od ON od.product_id = products.product_id
JOIN orders ON orders.order_id = od.order_id
WHERE year(orders.order_date) = 2023 and month(orders.order_date) = 3
GROUP BY products.product_id, name;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
SELECT DISTINCT customers.customer_id as "Mã Khách hàng", name, sum(total_amount) as "Tổng chi tiêu" FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE YEAR(orders.order_date) = 2023
GROUP BY customers.customer_id, name
ORDER BY sum(total_amount) desc;

-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm)
SELECT customers.name as "Người mua", sum(orders.total_amount) as "Tổng tiền", orders.order_date as "Ngày mua", sum(orders_details.quantity) as "Tổng số lượng" FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
JOIN orders_details ON orders_details.order_id = orders.order_id
group by customers.name,orders.order_date
HAVING sum(orders_details.quantity) >= 5;

-- Bài 4: Tạo View, Procedure
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn .
CREATE VIEW order_view as
SELECT distinct c.name, c.phone, c.address, sum(o.total_amount) as "Tổng tiền", o.order_date as "Ngày tạo hóa đơn"  FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.name, c.phone, c.address,o.order_date;

SELECT * FROM order_view;

-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
-- số đơn đã đặt.
CREATE VIEW CustomerInfo AS
SELECT customers.name, customers.address, customers.phone, COUNT(orders.customer_id) AS total_orders
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.customer_id
GROUP BY customers.customer_id;

SELECT * FROM CustomerInfo;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm.
CREATE VIEW product_view as
SELECT products.name as "Tên sản phẩm", products.price as "Giá", sum(od.quantity) as "Số lượng đã bán" FROM products
JOIN orders_details od ON od.product_id = products.product_id
GROUP BY products.name, products.price;

SELECT * FROM product_view;

-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer.
CREATE INDEX customer_phone ON customers(phone);
CREATE INDEX customer_email ON customers(email);

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
DELIMITER //
CREATE PROCEDURE showCustomer(customer_idP varchar(4))
BEGIN
	SELECT * FROM customers
    WHERE customers.customer_id = customer_idP;
END
// DELIMITER ;
CALL showCustomer("C002");

-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
DELIMITER //
CREATE PROCEDURE product_p()
BEGIN
	SELECT * FROM products;
END 
// DELIMITER ;
call product_p();

-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
DELIMITER //
CREATE PROCEDURE order_p(customer_order varchar(4))
BEGIN 
	SELECT * FROM orders
    WHERE orders.customer_id = customer_order;
END
// DELIMITER ;
call order_p("C002");

-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
-- tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
delimiter //
create procedure create_new_order(in in_order_id varchar(4),in in_customer_id varchar(4),in total_amount double,in order_date date)
begin
    insert into orders (order_id,customer_id, total_amount, order_date)
    values (in_order_id,in_customer_id, total_amount, order_date);
    select in_order_id;
end //
delimiter ;
call create_new_order("H024","C005", 1000, "2023-11-08");

-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc.
DELIMITER //
CREATE PROCEDURE sell_product(start_dateP Date, end_dateP  Date)
BEGIN
     SELECT products.name, SUM(orders_details.quantity) AS total_sold
    FROM products
    JOIN orders_details ON products.product_id = orders_details.product_id
    JOIN orders ON orders.order_id = orders_details.order_id
    WHERE orders.order_date BETWEEN start_dateP AND end_dateP
    GROUP BY products.product_id;
END;
// DELIMITER ;
CALL sell_product("2023/01/01","2023/02/01");

-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê.
DELIMITER //
CREATE PROCEDURE sell_date(sell_year YEAR, sell_month int)
BEGIN
    SELECT od.product_id, p.name, SUM(od.quantity) AS total_quantity_sold
    FROM ORDERS_DETAILS od
    JOIN ORDERS o ON od.order_id = o.order_id
    JOIN PRODUCTS p ON od.product_id = p.product_id
    WHERE MONTH(o.order_date) = sell_month AND YEAR(o.order_date) = sell_year
    GROUP BY od.product_id, p.name
    ORDER BY total_quantity_sold DESC;
END
// DELIMITER ;
CALL sell_date(2023, 2);

