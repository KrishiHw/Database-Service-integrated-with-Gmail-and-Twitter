/* 
 * MySQL Script - initializeDataBase.sql.
 */

USE CUSTOMER_RECORDS;

-- create CUSTOMERS table in the database
CREATE TABLE IF NOT EXISTS CUSTOMERS (CustomerID INT, Name VARCHAR(50), Address VARCHAR(50),Email VARCHAR(50),PRIMARY KEY (CustomerID))

-- create CUSTOMER_BILLS table in the database
CREATE TABLE IF NOT EXISTS CUSTOMER_BILLS ( BillNo int, CustomerID INT, Amount VARCHAR(50),DateCreated VARCHAR(50),
PRIMARY KEY (BillNo),
FOREIGN KEY (CustomerID) REFERENCES CUSTOMERS(CustomerID))


