USE sakila;
-- 1a
SELECT * FROM actor;
-- 1b
SELECT CONCAT(first_name, ' ',last_name) AS 'Actor Name' FROM actor;
-- 2a
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';
-- 2b
SELECT first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';
-- 2c
SELECT first_name, last_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;
-- 2d
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a
ALTER TABLE actor ADD description BLOB;
-- 3b
ALTER TABLE actor DROP description;
-- 4a
SELECT last_name AS 'Last Name', COUNT(last_name) AS 'Count' FROM actor GROUP BY last_name;
-- 4b
SELECT last_name AS 'Last Name', COUNT(last_name) AS 'Count' FROM actor GROUP BY last_name HAVING COUNT(last_name) >= 2;
-- 4c
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- 4d
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO';
-- 5a
CREATE TABLE address (
address_id INT AUTO_INCREMENT NOT NULL,
address VARCHAR(50) NOT NULL,
address2 VARCHAR(50),
district VARCHAR(20) NOT NULL,
city_id INT NOT NULL,
postal_code VARCHAR(10),
phone VARCHAR(20) NOT NULL,
location GEOMETRY NOT NULL,
last_update TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT '0000-00-00 00:00:00',
PRIMARY KEY (address_id),
FOREIGN KEY (city_id) REFERENCES city(city_id)
);
-- 6a
SELECT staff.first_name, staff.last_name, staff.address_id, address.address_id, address.address
FROM staff
INNER JOIN address ON address.address_id = staff.address_id;
-- 6b
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) AS 'Total Sales'
FROM payment
INNER JOIN staff on staff.staff_id = payment.staff_id
WHERE payment_date LIKE '2005-08%'
GROUP BY staff.staff_id;
-- 6c
SELECT film.title as 'Title', COUNT(film.title) AS 'Number of Actors'
FROM film_actor
INNER JOIN film on film.film_id = film_actor.film_id
GROUP BY film.title;
-- 6d
SELECT film.title as 'Title', COUNT(film.title) AS 'Copies in Inventory'
FROM inventory
INNER JOIN film on film.film_id = inventory.film_id
WHERE film.title = 'HUNCHBACK IMPOSSIBLE'
GROUP BY film.title;
-- 6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) as 'Total Amount Paid'
FROM payment
INNER JOIN customer ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;
-- 7a
SELECT title
FROM film
WHERE language_id IN(
	SELECT language_id
	FROM language 
	WHERE title IN (
		SELECT title 
		FROM film
		WHERE title LIKE "K%" OR title LIKE "Q%"
	)
);
-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN(
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN (
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'));
-- 7c
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address ON address.address_id = customer.address_id
INNER JOIN city ON city.city_id = address.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country.country = 'Canada';
-- 7d
select * from film_category;
select * from category;
select * from film;
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film_category
    WHERE category_id IN (
		SELECT category_id
        FROM category
        WHERE name = 'Family'));
-- 7e
SELECT title, COUNT(title)
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY COUNT(title) DESC;
-- 7f
SELECT store_id, SUM(amount)
FROM payment
INNER JOIN rental ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
GROUP BY store_id;
-- 7g
SELECT store_id, city.city, country.country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id;
-- 7h
SELECT category.name, SUM(payment.amount)
FROM payment
INNER JOIN rental ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC;
-- 8a
CREATE VIEW top_five_genres AS (
	SELECT category.name, SUM(payment.amount)
	FROM payment
	INNER JOIN rental ON rental.rental_id = payment.rental_id
	INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
	INNER JOIN film_category ON inventory.film_id = film_category.film_id
	INNER JOIN category ON category.category_id = film_category.category_id
	GROUP BY category.name
	ORDER BY SUM(payment.amount) DESC
);
-- 8b
SELECT * FROM top_five_genres;
-- 8c
DROP VIEW top_five_genres;