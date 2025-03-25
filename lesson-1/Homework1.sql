create table student(
	id int,
	name varchar(50),
	age int,
)

Alter table student
Alter column id int not null;

drop table if exists product
Create table product(
 product_id int,
 product_name varchar(50),
 price decimal,
 )
Alter table product
Add Constraint UQ_product_id Unique(product_id);

ALTER TABLE product
DROP CONSTRAINT UQ_product_id;

Alter table product
Add Constraint UQ_product_id Unique(product_id);

Alter table product
Add Constraint UQ_product_id2 Unique(product_id, product_name);
 

 Create table orders(
	order_id int primary key,
	customer_name varchar(50),
	order_date Date
 )

 ALter table orders
 Drop Constraint PK__orders__465962299966F410;


 Create table category(
	category_id int primary key,
	category_name varchar(50),
 )

 Create table item(
	item_id int primary key,
	item_name varchar(50),
	category_id int foreign key references category(category_id)
)

Alter table item
Drop Constraint FK__item__category_i__5535A963;

Alter table item
Add Foreign Key (category_id)
References category(category_id);

drop table if exists account
Create table account(
	account_id int primary key,
	balance decimal check(balance>=0),
	account_type VARCHAR(20) CHECK (account_type IN ('Saving', 'Checking'))
)

Alter table account
drop constraint CK__account__account__5DCAEF64;

Alter table account
drop constraint CK__account__balance__5CD6CB2B;

Alter table account
add check(balance>=0);

Alter table account
add check(account_type IN ('Saving', 'Checking'));


create table customer(
	customer_id int primary key,
	name varchar(255),
	city varchar(50) Default 'Unknown',
)

ALter table customer
drop constraint DF__customer__city__628FA481;

Alter table customer
add default 'Unknown' for city;

drop table if exists invoice
Create table invoice(
	invoice_id int identity(1, 1),
	amount decimal(10, 2)
)

insert into invoice values
	(12.2),
	(32.2),
	(42.4),
	(12.6),
	(16.2)

Set Identity_insert invoice on;

insert into invoice(invoice_id, amount) values(100, 42.03)

Set Identity_insert invoice off;

create table books(
	book_id int primary key identity,
	title varchar(255) not null,
	price decimal(10,2) check(price>0),
	genre varchar(50) default  'Unknown'
)

insert into books(title, price) values
	('1984', 11.2)
insert into books(title, price, genre) values
	('Animal farm', 9.07, 'dystopian')

select * from books



