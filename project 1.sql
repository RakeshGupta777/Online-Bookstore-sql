CREATE TABLE Books (
    Book_ID int PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
select* from Books;
copy Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
from 'C:/Program Files/PostgreSQL/17/data/03_Books.csv'
csv header;
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
select* from Customers;
copy Customers(Customer_ID, Name, Email, Phone, City, Country)
from 'C:/Program Files/PostgreSQL/17/data/05_Customers.csv'
csv header;
create table Orders(
	Order_ID int primary key,
	Customer_ID int references Customers(Customer_ID),
	Book_ID int references Books(Book_ID),
	Order_Date date,
	Quantity int,
	Total_Amount numeric(10,2)
);
select* from Orders;
SET datestyle = 'MDY';
copy Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
from 'C:/Program Files/PostgreSQL/17/data/04_Orders.csv'
csv header;
-- 1) Retrieve all books in the "Fiction" genre:
select *  from Books
where genre='Fiction';

-- 2) Find books published after the year 1950:
select * from Books
where published_year>1950;
-- 3) List all customers from the Canada:
select* from Customers
where country='Canada';
-- 4) Show orders placed in November 2023:
select* from Orders
where Order_date between '2023-11-01' and '2023-11-30';
-- 5) Retrieve the total stock of books available:
select sum(stock) as total_stock_available
from Books;
 --(6)Find the details of the most expensive book again
 select * from Books
 order by price desc
 limit 1;
-- 7) Show all customers who ordered more than 1 quantity of a book:
 select * from Orders
 where quantity>1;
 -- 8) Retrieve all orders where the total amount exceeds $20:
 select * from Orders
 where total_amount>20;
 -- 9) List all genres available in the Books table:
 select distinct genre from Books;
 -- 10) Find the book with the lowest stock:
 select * from Books
 order by stock asc
 limit 1;
 -- 11) Calculate the total revenue generated from all orders:
 select sum(total_amount) as total_revenue
 from Orders;
 - Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
 select b.genre, sum(o.quantity)
 from Orders o
 join 
Books b
 on o.book_id=b.book_id
 group by b.genre;
 -- 2) Find the average price of books in the "Fantasy" genre:
select avg(price) as average_price
from Books
where genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;




-- 4) Find the most frequently ordered book:
select b.book_id,b.title,count(o.order_id) as order_count
from Orders o
join Books b
on o.book_id=b.book_id
group by b.book_id,o.order_id
order by  order_count desc
limit 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from Books
order by price desc
limit 3;


-- 6) Retrieve the total quantity of books sold by each author:
 select b.author, sum(o.quantity)
 from Orders o
 join 
Books b
 on o.book_id=b.book_id
 group by b.author;

-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city
FROM Customers c
JOIN Orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.city, c.customer_id
HAVING SUM(o.total_amount) > 30;



-- 8) Find the customer who spent the most on orders:
select c.customer_id,c.name,sum(o.total_amount) as orders_amount
from Orders o
join Customers c
on o.customer_id=c.customer_id
group by c.customer_id,c.name
order by orders_amount desc

--9) Calculate the stock remaining after fulfilling all orders:
select b.Book_ID, b.title, b.stock, coalesce(sum(quantity), 0) as Order_quantity, 
	b.stock - coalesce(sum(o.Quantity), 0) as Remaining_quantity
from Books b
left join orders o on b.Book_ID = o.Book_ID
group by b.Book_ID;
-- Useful Queries

-- 1) Top 5 Selling Books
select b.Title, sum(o.Quantity) as Total_sold
from Orders o
join Books b on o.Book_ID = b.Book_ID
group by b.Title
Order by Total_sold desc 
Limit 5;

-- 2) Monthly Revenue
select DATE_TRUNC('month', Order_Date) as Month,
sum(Total_Amount) as Revenue
from orders
group by Month
Order by Month;

-- 3) Top 5 customers by Spend
select c.Name, sum(o.Total_Amount) as Total_Spent 
from Orders o
join Customers c on o.Customer_ID = c.Customer_ID
group by c.Name
order by Total_Spent desc 
limit 5;

-- 4) Total Quantity sold by Genre
select b.Genre, sum(o.Quantity) as Total_Sold 
from Orders o
join Books b on o.Book_ID = b.Book_ID
group by Genre;

-- 5) Low stock books 
select Title, Stock
from Books
order by Stock Asc 
Limit 5;


