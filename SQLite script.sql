CREATE TABLE Book (
    call_no INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    subject TEXT NOT NULL
);
CREATE TABLE Patron (
    patron_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_of_birth DATE NOT NULL
);
CREATE TABLE Address (
    address_id INTEGER PRIMARY KEY,
    patron_id INTEGER NOT NULL,
    address TEXT NOT NULL,
    FOREIGN KEY (patron_id) REFERENCES Patron(patron_id)
);
CREATE TABLE Loan_transaction (
    trans_id INTEGER PRIMARY KEY,
    patron_id INTEGER NOT NULL,
    call_no INTEGER NOT NULL,
    loan_fee INTEGER NOT NULL,
    loan_fee_paid BOOL NOT NULL,
    date_checked_out DATE NOT NULL,
    date_returned DATE NULL,
    FOREIGN KEY (patron_id) REFERENCES Patron(patron_id),
    FOREIGN KEY (call_no) REFERENCES Book(call_no)
);
SELECT*FROM Address;
SELECT*FROM Book;
SELECT*FROM Loan_transaction;
SELECT*FROM Patron;
ALTER TABLE Patron ADD email CHAR(40);
CREATE TABLE Seniors AS
 SELECT*FROM Patron WHERE date_of_birth < '1973-02-16';
UPDATE Patron SET email='sql4life@books.com' WHERE patron_id='101';
SELECT Book.subject, Book.title FROM Book;
SELECT DISTINCT book.subject FROM Book;
SELECT book.title, book.subject FROM Book WHERE book.subject='Advertising';
SELECT*FROM Book WHERE Book.call_no=2000;
SELECT*FROM Loan_transaction WHERE Loan_transaction.loan_fee > 5;
SELECT Loan_transaction.call_no FROM Loan_transaction WHERE Loan_transaction.patron_id=140 
AND Loan_transaction.loan_fee_paid='yes';
SELECT*FROM Book WHERE book.title LIKE '%Database%';
SELECT*FROM Book WHERE book.title LIKE '_r%';
SELECT*FROM Book WHERE book.call_no BETWEEN 800 AND 1300;
SELECT*FROM Loan_transaction WHERE Loan_transaction.date_returned IS NULL;

SELECT Loan_transaction.patron_id, Patron.first_name, Patron.last_name 
FROM Loan_transaction LEFT JOIN Patron ON Loan_transaction.patron_id=Patron.patron_id 
WHERE Loan_transaction.loan_fee_paid='yes' AND Loan_transaction.date_returned IS NOT NULL 
ORDER BY Loan_transaction.patron_id;

SELECT Patron.first_name, Patron.last_name FROM Patron WHERE Patron.patron_id IN (127,124,137,114);
SELECT Book.title FROM Book WHERE Book.subject IN ('Computing','Literature');

SELECT Patron.patron_id, Patron.first_name, Patron.last_name FROM Patron 
WHERE Patron.date_of_birth BETWEEN '1990-00-00' AND '2020-00-00';

SELECT COUNT(*) AS Numbers_of_outstanding_books FROM Loan_transaction WHERE loan_transaction.date_returned IS NULL;
SELECT SUM(Loan_transaction.loan_fee) AS Total_fee FROM Loan_transaction;
SELECT AVG(Loan_transaction.loan_fee) AS Average_fee FROM Loan_transaction;

SELECT COUNT(*) AS Total_number_of_books_late FROM Loan_transaction 
WHERE JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out) > 10;

SELECT JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out) AS Date_late,* FROM Loan_transaction 
WHERE JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out) > 10;

SELECT JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out) AS Date_late,*,
CASE WHEN loan_fee_paid='yes' THEN (JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out)-10)*5
WHEN loan_fee_paid='no' THEN loan_fee+((JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out)-10)*5)
ELSE NULL END AS Late_fee
 FROM Loan_transaction 
WHERE JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out) > 10;

SELECT*FROM Book Order BY Book.title;

SELECT*FROM Book ORDER BY Book.call_no, Book.subject;

SELECT Loan_transaction.patron_id, Loan_transaction.loan_fee FROM Loan_transaction GROUP BY Loan_transaction.patron_id;

SELECT strftime('%m', Loan_transaction.date_checked_out) AS Month, COUNT(*) FROM Loan_transaction 
WHERE strftime('%Y', Loan_transaction.date_checked_out)='2021' GROUP BY strftime('%m', Loan_transaction.date_checked_out);

SELECT COUNT(*), Book.subject FROM Loan_transaction LEFT JOIN Book ON Loan_transaction.call_no=Book.call_no WHERE Loan_transaction.date_returned
IS NULL GROUP BY Book.subject;

SELECT Patron.patron_id, Patron.first_name, Patron.last_name, Loan_transaction.call_no FROM Patron  LEFT JOIN Loan_transaction 
ON Patron.patron_id=Loan_transaction.patron_id;

SELECT Patron.patron_id, Patron.first_name, Patron.last_name, Patron.email,
CASE
WHEN loan_fee_paid='yes' and (JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out)) > 10
 THEN (JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out)-10)*5 
WHEN loan_fee_paid='yes' and (JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out)) <= 10
THEN 0
WHEN loan_fee_paid='no'  and (JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out)) > 10 
THEN loan_fee+((JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out)-10)*5)
WHEN loan_fee_paid='no'  and (JULIANDAY(Loan_transaction.date_returned) - JULIANDAY(Loan_transaction.date_checked_out)) <= 10 
THEN loan_fee
ELSE NULL END AS own_fee
 FROM Loan_transaction LEFT JOIN Patron ON Loan_transaction.patron_id=Patron.patron_id WHERE Loan_transaction.date_returned IS NOT NULL;