# SQL

1.  Out of various RDBMS available applications, **MySQL** is the most widely used and its community version is free to use.

2.  SQL is case-insensitive. Although it is a good practice to capitalise all the **clause** keywords.
    Ex: **USE** my_database;

3.  The order in which certain clauses are executed is important, they won't work if the order isn't followed. For example:

    ```
    SELECT *
    FROM customers
    WHERE customer_id = 1
    ORDER BY first_name
    ```

    Note: FROM, WHERE, ORDER BY are optional clauses.

4.  Comments can be inserted inside the query editor by appending **--** ahead of the statement.

5.  **SELECT** clause, arithmetic operation and column aliases using the **AS** clause. In order to provide a column name with space in it, it needs to be put in inverted quotes. Parenthesis can be used to manage order of precedence of operators.

    ```
    SELECT
     first_name,
     last_name,
     points,
     (points + 10) * 100 AS 'first name'
    ```

6.  To filter out duplicate entries in a column, use **DISTINCT** keyword after **SELECT** clause.

    ```
    SELECT DISTINCT city
    FROM customers
    ```

7.  Operators used in SQL: <,>,>=, <=, (!= and <>)

    ```
    SELECT points, first_name
    FROM customers
    WHERE state = 'VA'

    WHERE birth_date > '1990-01-01'  // to show people born after Jan 1, 1990

    //Using AND, OR, NOT
    WHERE (birth_date > '1990-01-01' OR points > 1000) AND state = 'VA'
    WHERE NOT (birth_date > '1990-01-01' OR points > 1000)
    ```

8.  **IN** operator:

    ```
    SELECT *
    FROM customers
    WHERE state IN ('VA', 'FL', 'GA')
    ```

9.  When checking whether an attirbute is within a range of values, we use **BETWEEN** operator, the terminal values of this range are inclusive:

    ```
     SELECT *
     FROM customers
     WHERE points BETWEEN 1000 AND 3000

     SELECT *
     FROM customers
     WHERE birth_date BETWEEN '1990/01/01' AND '2000/01/01'

    ```

10. **LIKE** operator allows us to check for certain string patterns in attirbutes, the condition is case-insensitive:

    ```
    SELECT *
    FROM customers
    WHERE last_name LIKE '%b%'

    WHERE last_name LIKE '_y'
    ```

    Here **%** sign depicts - **_Any number of characters at that position_**

    **\_** depicts **Number of characters that should be there at that position**, **\_** means 1 character, **\_\_** means 2 characters.

11. **REGEXP** allows us to use Regular Expression in our search queries;

    ```
    *WHERE* last_name REGEXP 'field' // 'checking the existence of the string "field" in the last_name attirbute
    ```

    Other characters used in **REGEXP**:

    1. **^** : Indicates the beginning condition for a string. Ex: '^field'
    2. **$** : Indicates the ending condition for a string. Ex: 'field$'.
    3. **|** : OR operator within REGEXP. Ex: 'field|mac' => customers with the name field or mac in their last name.
    4. **[]** : Set of characters that should take a position.
       Ex: '[abc]def, allowed string woudld be: adef, bdef, cdef'
       '[a-c]def' same as above, with range hyphen

12. Check for **NULL** condition in a query. Ex: WHERE phone IS NULL.

13. **ORDER BY** This clause helps with sorting of data column wise. MySQL supports sorting of data based on a column even if that column is not rendered using the **SELECT** clause.

    ```
    1.
    SELECT first_name, last_name
    FROM customers
    ORDER BY state DESC,  first_name

    Note: In this example we're sorting the result in descending order by the name of the state and in alphabetical order as per the first_name

    2.
    SELECT first_name, last_name, 10 AS points
    FROM customers
    ORDER BY 1,2

    Note: In this example, we;re giving an alias column of value 10 as points and ordering the result by 1 and 2 which means the first and second columns mentioned after the SELECT clause.

    3. Exercise Example
    SELECT *, quantity * unit_price AS total_price
    FROM order_items
    WHERE order_id = 2
    ORDER BY total_price DESC
    ```

14. **LIMIT** clause limits the number of records returned in a query response. Ex: Exercise Solution
    ```
    SELECT *
    FROM customers
    ORDER BY points DESC
    LIMIT 3
    ```
15. **JOIN**
    Ex:

    ```
    SELECT order_id, o.customer_id, first_name, last_name
    FROM orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
    ```

    Here, the JOIN clause means **Inner Join**, **Inner** is optional.
    **o and c** are aliases for orders and customers tables.

16. **Joining Tables across Databases:**
    Depending on the current database being **_USED_** as in the **USE** clause, the tables can be selected from different databases as illustrated below:

    ```
    USE sql_inventory;

    SELECT *
    FROM sql_store.order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    ```

17. **Self-Join**: Ex:

    ```
    USE sql_hr;

    SELECT e.employee_id, e.first_name, m.first_name AS manager
    FROM employees e
    JOIN employees m
    	ON e.reports_to = m.employee_id
    ```

18. **Joining Multiple Tables:** Ex:

    ```
    USE sql_store;

    SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
    FROM orders o
    JOIN customers c
    	ON o.customer_id = c.customer_id
    JOIN order_statuses os
        ON o.status = os.order_status_id
    ```

19. **Composite Primary Key:** A key which contains more than one column to create a unique key combination.

20. **Compound Join**. Ex:

    ```
    SELECT *
    FROM order_items oi
    JOIN order_items oin
        ON oi.order_id = oin.order_id
        AND oi.product_id = oin.product_id

    ```

21. **Explicit vs Implicit Join:** Both the statements work equivalently. Ex:

    ```
    -- Explicit Join Syntax
    SELECT *
    FROM orders 0
    JOIN customers c
    	ON o.customer_id = c.customer_id

    -- Implicit Join Syntax
    SELECT *
    FROM orders o, customers c
    WHERE o.customer_id = c.customer_id
    ```

22. **OUTER JOINS:** Two types: **LEFT JOIN** and **RIGHT JOIN**.
    In **LEFT** join all the records from the left table are returned irrespective of the join condition and the same applies for right table in a **RIGHT** join. Ex:

    ```
    SELECT
    c.customer_id, c.first_name, o.order_id
    FROM customers c
    LEFT JOIN orders o
    	ON c.customer_id = o.customer_id
    ORDER BY c.customer_id
    ```

    Note: When we only write **JOIN** it invariably means **Inner Join**. **LEFT JOIN** and **RIGHT JOIN** can also be written as **LEFT OUTER JOIN** and **RIGHT OUTER JOIN**

23. **OUTER JOIN between Multiple Tables:** Ex:

    ```
    SELECT
        c.customer_id,
        c.first_name,
        o.order_id

    FROM customers c
    LEFT JOIN orders o
    	ON c.customer_id = o.customer_id
    LEFT JOIN shippers sh
    	ON o.shipper_id = sh.shipper_id
    ORDER BY c.customer_id
    ```

24. **USING Clause:** The **USING** clause can only be used if the columns in the **ON** clause are named same in both the tables.

    ```
    SELECT *
    FROM order_items oi
    JOIN order_items_notes oin
        ON oi.order_id = oin.order_id AND
    	oi.product_id = oin.product_id

    -- with USING clause the above query can be written as
    SELECT *
    FROM order_items oi
    JOIN order_items_notes oin
        USING (order_id, product_id)

    -- Exercise Solution
    SELECT
        p.date,
        c.name AS client,
        p.amount,
        pm.name

    FROM clients c

    JOIN payments p
    	USING (client_id)

    JOIN payment_methods pm
    	ON p.payment_method = pm.payment_method_id
    ```

25. **NATURAL JOIN:**  We let the sql engine figure out the join on its own. That's why it is not a recommended JOIN to use.

26. **CROSS JOIN:** It is used to combine or join every record from the first table with every record of the second table.
    ```
    -- Implicit Syntax
    SELECT 
	c.first_name AS customer,
    p.name AS product

    FROM customers c, orders o
    ORDER BY c.first_name

    -- Explicit Syntax (Recommended)
    SELECT 
	c.first_name AS customer,
    p.name AS product

    FROM customers c
    CROSS JOIN orders o
    ORDER BY c.first_name
    ```
27. **UNIONS:** Used to combine rows from different queries against same or different tables.
    ```
    SELECT 
	order_id,
    order_date,
    'Active' AS status

    FROM orders
    WHERE order_date >= '2019-01-01'

    UNION

    SELECT 
    	order_id,
        order_date,
        'Archived' AS status

    FROM orders
    WHERE order_date < '2019-01-01'
    ```
    Note: The number of columns rendered by individual queries, being UNIONed together, should be equal else SQL will throw an error.

    ```
    -- Exercise Question Solution
    SELECT
	    customer_id,
        first_name,
        points,
        'Bronze' AS type

    FROM customers
    WHERE points < 2000

    UNION

    SELECT
    	customer_id,
        first_name,
        points,
        'Silver' AS type
    FROM customers
    WHERE points BETWEEN 2000 AND 3000

    UNION

    SELECT
    	customer_id,
        first_name,
        points,
        'Gold' AS type
    FROM customers
    WHERE points >= 3000

    ORDER BY first_name
    ```

## Inserting, Updating, and Deleting Data
- - - 
28. **Insertion of Row in a Table:** 
    ```
    INSERT INTO customers (
	    first_name,
        last_name,
        birth_date,
        address,
        city,
        state)
    VALUES (
        'John',
        'Smith',
        '1996-05-27',
        'Sample Address',
        'Some city',
        'CA')
    ```
    In the code above, we have mentioned the columns we're explicitly specifying the values for. The order in which we list out the columns doesn't matter but the order of values should follow the same order as the column names.

    We can choose to not mention these columns and fill-in the values in the same order as in the schema and supply values like **DEFAULT**, **NULL** to let SQL populate those column values with the default or null values respectively.

29. **Insertion of Multiple Rows in a Table:** 
    ```
    INSERT INTO products (
	    name,
        quantity_in_stock,
        unit_price
        )
    VALUES 
    	('Product1', 10, 1.5),
    	('Product2', 20, 2.5),
        ('Product3', 30, 3.5)
    ```
30. **Inserting Data Into Multiple Tables:** 
    ```
    INSERT INTO orders (
	    customer_id,
        order_date,
        status
    )
    VALUES (
        1,'2019-01-02',1
    );

    INSERT INTO order_items
    VALUES
        (LAST_INSERT_ID(),1,1,2.95), 
        (LAST_INSERT_ID(),2,1,3.95)
    ```
    **LAST_INSERT_ID** returns the ID(order_id) of the row created by the first SQL Query, insert query (in the orders table)

31. **Copying Contents of a Table:** For creating the copy of a table, **CREATE TABLE** clause
    ```
    CREATE TABLE orders_archived AS
    SELECT * FROM orders        --> This line is a sub-query (A valid SQL query part of another SQL query)
    ```
    The above command DOES NOT copy the schema and its rules to the new table.
    In order to copy only a subset of rows to a new table:
    ```
    INSERT INTO orders_archived
    SELECT *
    FROM orders
    WHERE order_date < '2019-01-01'
    ```
    
    Exercise Solution:
    ```
    USE sql_invoicing;
    CREATE TABLE invoices_archived AS
    SELECT 
    	invoice_id,
    	number,
        c.name AS client,
        invoice_total,
        payment_total,
        due_date,
        payment_date
    FROM invoices i 
    JOIN clients c
    	USING (client_id)
    WHERE i.payment_date IS NOT NULL
    ```

32. **Updating Row Data:** By using the **UPDATE** and **SET** clauses we can update the data of a row in a table.
    ```
    UPDATE invoices                  ----> UPDATE <table_name>
    SET payment_total = 10,          ----> Column Value(s) to be updated
    	payment_date = '2019-03-01'

    WHERE invoice_id = 1            -----> Locating the row to be updated
    
    --------------------------------------------
    WHERE invoice_id IN (3,4)       -----> Updating Multiple Rows at once
    ```
    ```
    Using a Sub-query inside an Update Query
    USE sql_invoicing;

    UPDATE invoices
    SET 
    	payment_total = invoice_total * 0.5,
    	payment_date = due_date
    WHERE client_id IN
    			(SELECT client_id 
    			FROM clients
    			WHERE state IN ('CA','NY'))
    ```
    In the above example, The Subquery inside of parenthesis is executed first by SQL Engine and Fed into the main query.
    The **IN** operator, in the **WHERE** clause signifies that the sub-query returns more than one rows.

33. **DELETE clause, Deleting Rows:**
    ```
    DELETE FROM invoices
    WHERE invoice_id = 1

    OR by using a sub-query,

    DELETE FROM invoices
    WHERE client_id = (
	    SELECT *
	    FROM clients
	    WHERE name = 'Myworks'
    )
    ```
34. **Summarizing Data:**
    Built-in ***Aggregation Functions***: **MAX(), MIN(), SUM(), AVG(), SUM(), COUNT()**
    ```
    SELECT 
	    MAX(invoice_total) AS highest,   ----> Returns the Highest Value 
        MIN(invoice_total) AS lowest,   ----> Returns the Lowest Value
        AVG(invoice_total) AS average,  ----> Returns the Average Value
        
        SUM(invoice_total * 1.1) AS total,----> Returns the Total Value with 1.1 multiplied in each entry
        
        COUNT(invoice_total) AS number_of_invoices, ---> Returns no. of entries
        COUNT(payment_date) AS count_of_payments,

        COUNT(*) AS total_records,  ---> Returns total no. of records in the table
        
        COUNT(DISTINCT client_id) AS unique_records  --> Returns number of unique values in the given column (client_id) in this case

    FROM invoices
    WHERE invoice_date > '2019-07-01'               ---> Filter
    ```
     
        