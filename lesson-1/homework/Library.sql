CREATE TABLE Book(
	book_id int primary key Identity,
	title varchar(255),
	author varchar(255),
	published_year int check(published_year>0)
)

CREATE TABLE Member(
	member_id int primary key Identity,
	name varchar(55),
	email varchar(55) NOT NULL UNIQUE,
	phone_number varchar(20)
)

CREATE TABLE Loan(
	loan_id int primary key Identity,
	book_id int foreign key references book(book_id),
	member_id int foreign key references member(member_id),
	loan_date DATE,
	return_date DATE NULL,
)


-- Insert sample books
INSERT INTO Book (title, author, published_year) VALUES 
('1984', 'George Orwell', 1949),
('To Kill a Mockingbird', 'Harper Lee', 1960),
('The Great Gatsby', 'F. Scott Fitzgerald', 1925);

-- Insert sample members
INSERT INTO Member (name, email, phone_number) VALUES 
('Alice Johnson', 'alice@example.com', '123-456-7890'),
('Bob Smith', 'bob@example.com', '987-654-3210');

-- Insert sample loans
INSERT INTO Loan (book_id, member_id, loan_date, return_date) VALUES 
(1, 1, '2024-03-01', '2024-03-10'),
(2, 2, '2024-03-05', NULL),        
(3, 1, '2024-03-07', NULL);    