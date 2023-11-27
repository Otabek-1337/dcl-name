-- SQL_DCL_YourName_Surname_Task.sql

-- 1. Create a new user with the username "rentaluser" and the password "rentalpassword".
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';

-- Give the user the ability to connect to the database but no other permissions.
GRANT CONNECT ON DATABASE dvdrental TO rentaluser;

-- 2. Grant "rentaluser" SELECT permission for the "customer" table.
GRANT SELECT ON TABLE customer TO rentaluser;

-- Check to make sure this permission works correctly—write a SQL query to select all customers.
SELECT * FROM customer;

-- 3. Create a new user group called "rental" and add "rentaluser" to the group.
CREATE GROUP rental;
ALTER USER rentaluser ADD TO GROUP rental;

-- 4. Grant the "rental" group INSERT and UPDATE permissions for the "rental" table.
GRANT INSERT, UPDATE ON TABLE rental TO rental;

-- Insert a new row and update one existing row in the "rental" table under that role.
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date)
VALUES ('2023-11-25', 1, 1, '2023-11-30');

UPDATE rental SET return_date = '2023-12-01' WHERE rental_id = 1;

-- 5. Revoke the "rental" group's INSERT permission for the "rental" table.
REVOKE INSERT ON TABLE rental FROM rental;

-- Try to insert new rows into the "rental" table to make sure this action is denied.
-- The following statement should fail.
-- INSERT INTO rental (rental_date, inventory_id, customer_id, return_date)
-- VALUES ('2023-11-26', 2, 2, '2023-12-02');

-- 6. Create a personalized role for any customer already existing in the dvd_rental database.
-- The name of the role must be client_{first_name}_{last_name}.
-- The customer's payment and rental history must not be empty.
CREATE ROLE client_John_Doe;

-- Configure that role so that the customer can only access their own data in the "rental" and "payment" tables.
GRANT SELECT ON TABLE rental TO client_John_Doe;
GRANT SELECT ON TABLE payment TO client_John_Doe;

-- Write a query to make sure this user sees only their own data.
SET ROLE client_John_Doe;
SELECT * FROM rental WHERE customer_id = (SELECT customer_id FROM customer WHERE first_name = 'John' AND last_name = 'Doe');
SELECT * FROM payment WHERE customer_id = (SELECT customer_id FROM customer WHERE first_name = 'John' AND last_name = 'Doe');
