-----------------------
-- Practice Joins #1 --
----------------------- 

SELECT * FROM invoice
INNER JOIN invoice_line on invoice.invoice_id = invoice_line.invoice_id
WHERE unit_price > 0.99;

-- Practice Joins #2 -- 

SELECT i.invoice_date, c.first_name, c.last_name, i.total FROM invoice i
INNER JOIN customer c on i.customer_id = c.customer_id;

-- Practice Joins #3 -- 

SELECT c.first_name, c.last_name, e.first_name, e.last_name FROM customer c
INNER JOIN employee e ON c.support_rep_id = e.employee_id;

-- Practice Joins #4 -- 

SELECT al.title, ar.name from album al
INNER JOIN artist ar ON al.artist_id = ar.artist_id;

-- Practice Joins #5 -- 

SELECT pt.track_id from playlist_track pt
INNER JOIN playlist p ON pt.playlist_id = p.playlist_id
WHERE p.name = 'Music';

-- Practice Joins #6 -- 

SELECT t.name FROM playlist p
INNER JOIN playlist_track pt ON p.playlist_id = pt.playlist_id
INNER JOIN track t ON pt.track_id = t.track_id
WHERE p.playlist_id = 5;

-- Practice Joins #7 -- 

SELECT t.name, p.name FROM playlist p
INNER JOIN playlist_track pt ON p.playlist_id = pt.playlist_id
INNER JOIN track t ON pt.track_id = t.track_id;

-- Practice Joins #8 -- 

SELECT t.name, al.title from album al
INNER JOIN track t ON t.album_id = al.album_id
INNER JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Alternative & Punk';

-- Practice Joins BLACK DIAMOND -- 

SELECT t.name, g.name, al.title, ar.name from track t
INNER JOIN playlist_track pt ON pt.track_id = t.track_id
INNER JOIN playlist p ON p.playlist_id = pt.playlist_id
INNER JOIN album al ON t.album_id = al.album_id
INNER JOIN artist ar ON ar.artist_id = al.artist_id
INNER JOIN genre g ON g.genre_id = t.genre_id
WHERE p.name = 'Music';



--------------------------------
-- Practice Nested Queries #1 -- 
--------------------------------

SELECT * FROM invoice
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99);

-- Practice Nested Queries #2 -- 

SELECT * FROM playlist_track
WHERE playlist_id IN (SELECT playlist_id FROM playlist WHERE playlist.name = 'Music');

-- Practice Nested Queries #3 -- 

SELECT t.name FROM track t
WHERE track_id IN (SELECT track_id FROM playlist_track 
WHERE playlist_id IN 
(SELECT playlist_id FROM playlist WHERE playlist.name = 'Music'));

-- Practice Nested Queries #4 -- 

SELECT * FROM track t 
WHERE genre_id IN (SELECT genre_id FROM genre WHERE genre.name = 'Comedy');

-- Practice Nested Queries #5 -- 

SELECT * FROM track t 
WHERE album_id IN (SELECT album_id FROM album WHERE album.title = 'Fireball');

-- Practice Nested Queries #6-- 

SELECT * FROM track
WHERE album_id IN (SELECT album_id FROM album WHERE artist_id IN (SELECT artist_id FROM artist WHERE artist.name = 'Queen'));




-------------------------------
-- Practice Updating Rows #1 -- 
-------------------------------

UPDATE customer
SET fax = null
WHERE fax IS NOT null;

-- Practice Updating Rows #2-- 

UPDATE customer 
SET company = 'Self'
WHERE company IS NULL;

-- Practice Updating Rows #3-- 

UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

-- Practice Updating Rows #4-- 

UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl'
RETURNING *;

-- Practice Updating Rows #5-- 

UPDATE track t
SET composer = 'The darkness around us'
WHERE t.genre_id IN (SELECT genre_id FROM genre g WHERE g.name = 'Metal') AND t.composer IS null;




--------------------------
-- Practice Group By #1 -- 
--------------------------

SELECT COUNT(track_id), genre.name FROM track
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY genre.name;

-- Practice Group By #2-- 

SELECT COUNT(*), genre.name FROM track
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Pop' OR genre.name = 'Rock'
GROUP BY genre.name;

-- Practice Group By #3-- 

SELECT COUNT(al.album_id), ar.name FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id
GROUP BY ar.name;




------------------------------
-- Practice Use Distinct #1 -- 
------------------------------

SELECT DISTINCT composer FROM track;

-- Practice Use Distinct #2 -- 

SELECT DISTINCT billing_postal_code FROM invoice;

-- Practice Use Distinct #3 -- 

SELECT DISTINCT company FROM customer;




-----------------------------
-- Practice Delete Rows #1 -- 
-----------------------------

DELETE FROM practice_delete
WHERE type = 'bronze';

-- Practice Delete Rows #2 -- 

DELETE FROM practice_delete
WHERE type = 'silver';

-- Practice Delete Rows #3 -- 

DELETE FROM practice_delete
WHERE value = 150;



--------------------------
-- eCommerce Simulation -- 
--------------------------

CREATE TABLE users ( 
  id SERIAL PRIMARY KEY,
  name TEXT,
  email TEXT
);

INSERT INTO users ( name, email) 
VALUES 
('Jerry', 'jerry@email.com'),
('David', 'david@email.com'),
('Harold', 'harold@email.com');

CREATE TABLE product ( 
  product_id SERIAL PRIMARY KEY,
  name TEXT,
  price NUMERIC
);

INSERT INTO product ( name, price ) 
VALUES 
('Fishing Pole', 50.99),
('Basketball', 29.99),
('Snorkel', 19.99);

CREATE TABLE orders ( 
  order_id SERIAL PRIMARY KEY,
  product_id INT
);

INSERT INTO orders ( product_id ) 
VALUES 
(1),
(2),
(3);

SELECT * FROM product p
INNER JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id = 1;

SELECT * FROM orders;

SELECT SUM(price) from product p
INNER JOIN orders o ON o.product_id = p.product_id
WHERE o.order_id = 2;

ALTER TABLE orders
ADD FOREIGN KEY (order_id) REFERENCES users (id);

ALTER TABLE orders
ADD COLUMN user_id INT REFERENCES users (id)

UPDATE orders
SET user_id = 1
WHERE order_id = 1;

UPDATE orders
SET user_id = 2
WHERE order_id = 2;

UPDATE orders
SET user_id = 3
WHERE order_id = 3;

SELECT * FROM orders o
INNER JOIN users u ON o.user_id = u.id;

SELECT COUNT(*) FROM orders o
INNER JOIN users u ON o.user_id = u.id
WHERE u.id = 1;

SELECT COUNT(*) FROM orders o
INNER JOIN users u ON o.user_id = u.id
WHERE u.id = 2;

SELECT COUNT(*) FROM orders o
INNER JOIN users u ON o.user_id = u.id
WHERE u.id = 3;

-- Black Diamond --

SELECT SUM(price) FROM product p
INNER JOIN orders o ON p.product_id = o.product_id
INNER JOIN users u ON o.user_id = u.id
WHERE u.id = 1;

SELECT SUM(price) FROM product p
INNER JOIN orders o ON p.product_id = o.product_id
INNER JOIN users u ON o.user_id = u.id
WHERE u.id = 2;

SELECT SUM(price) FROM product p
INNER JOIN orders o ON p.product_id = o.product_id
INNER JOIN users u ON o.user_id = u.id
WHERE u.id = 3;