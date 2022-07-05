USE sakila;



-- checking the content of the tables
SELECT * FROM sakila.film;
SELECT * FROM sakila.inventory;

-- 1) How many copies of the film Hunchback Impossible exist in the inventory system?

-- Answer without using subqueries

SELECT f.title, count(i.inventory_id)
FROM sakila.film f
JOIN sakila.inventory i
USING (film_id)
WHERE title='Hunchback Impossible'
GROUP BY f.title;

-- Answer: we have 6 copies in inventory

-- now using subqueries. I could have used only one, but in that case we would also get the film_id

SELECT nr_copies
FROM (SELECT i.film_id, count(film_id) AS nr_copies
	FROM sakila.inventory i
	GROUP BY film_id
	HAVING film_id = (SELECT f.film_id
			   FROM sakila.film f
               WHERE f.title='Hunchback Impossible')) sub2;





-- 2) List all films whose length is longer than the average of all the films.

SELECT f.title, f.length
FROM sakila.film f
WHERE f.length >
		(SELECT AVG(f.length)
			FROM sakila.film f);



-- 3) Use subqueries to display all actors who appear in the film Alone Trip.

SELECT a.first_name, a.last_name 
FROM sakila.actor a
WHERE a.actor_id IN
	(SELECT fa.actor_id
	FROM sakila.film_actor fa
	WHERE fa.film_id IN (SELECT f.film_id
						FROM sakila.film f
						WHERE f.title='Alone Trip')) ;




-- 4)  Identify all movies categorized as family films.

SELECT f.title 
FROM sakila.film f
WHERE f.film_id IN
	(SELECT fc.film_id 
	FROM sakila.film_category fc
	WHERE fc.category_id =
			(SELECT c.category_id 
			FROM sakila.category c
			WHERE c.name = "Family")) ;





-- 5) Get name and email from customers from Canada using subqueries. Do the same with joins.

-- using subqueries

SELECT c.first_name, c.last_name, c.email 
FROM sakila.customer c
WHERE c.address_id IN    
		(SELECT ad.address_id 
		FROM sakila.address ad
		WHERE ad.city_id IN    
            (SELECT ci.city_id 
			FROM sakila.city ci
			WHERE ci.country_id = 
				(SELECT c.country_id 
				FROM sakila.country c
				WHERE c.country = 'Canada')));


-- using JOIN


SELECT c.first_name, c.last_name, c.email 
FROM sakila.customer c
JOIN sakila.address ad
USING (address_id)
JOIN sakila.city ci
USING (city_id) 
JOIN sakila.country co
USING (country_id)
WHERE co.country='Canada';





-- 6)  Which are films starred by the most prolific actor? 



SELECT a.first_name, a.last_name, f.film_id
FROM sakila.film f
JOIN sakila.film_actor fa
USING (film_id)
JOIN sakila.actor a
USING (actor_id)
WHERE actor_id = 
	(SELECT fa.actor_id
	FROM sakila.film_actor fa
	GROUP BY fa.actor_id
	ORDER BY count(film_id) DESC
	LIMIT 1) ;
 








