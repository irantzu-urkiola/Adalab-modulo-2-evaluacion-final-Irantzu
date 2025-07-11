USE sakila;

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. */

SELECT DISTINCT title
FROM film;

/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/

SELECT title
FROM film
WHERE rating = 'PG-13';

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en
su descripción.*/

SELECT title, description
FROM film 
WHERE description LIKE '%amazing%';

/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/

SELECT title
FROM film
WHERE length > 120;

-- si queremos ordenar de forma descendente y qu veamos también su duración:

SELECT title, length
FROM film
WHERE length > 120
ORDER BY length DESC, title ASC;

/* 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame
nombre_actor y contenga nombre y apellido. */

SELECT CONCAT(first_name, ' ', last_name) AS nombre_actor
FROM actor;

/* 6 Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

/* 7 Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/

SELECT actor_id, first_name
FROM actor 
WHERE actor_id > 9 AND actor_id < 21
ORDER BY actor_id;

-- utilizando BETWEEN

SELECT actor_id, first_name
FROM actor 
WHERE actor_id BETWEEN 10 AND 20
ORDER BY actor_id;

/*8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".*/

SELECT title
FROM film 
WHERE rating NOT IN ('R', 'PG-13');

/*9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la
clasificación junto con el recuento.*/

SELECT rating, COUNT(film_id) AS numero_peliculas
FROM film
GROUP BY rating;

/*10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su
nombre y apellido junto con la cantidad de películas alquiladas.*/

SELECT c.customer_id, CONCAT(c.first_name, ' ' , c.last_name) AS nombre_apellido, COUNT(r.rental_id) AS peliculas_alquiladas
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, CONCAT(c.first_name, ' ' , c.last_name);

/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la
categoría junto con el recuento de alquileres.*/

SELECT ca.name AS categoria, COUNT(r.rental_id) AS alquileres
FROM category ca
JOIN film_category fc ON ca.category_id = fc.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY ca.name;

-- si lo queremos ordenado por recuento de alquileres DESC

SELECT ca.name AS categoria, COUNT(r.rental_id) AS alquileres
FROM category ca
JOIN film_category fc ON ca.category_id = fc.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY ca.name
ORDER BY COUNT(r.rental_id) DESC;


/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
muestra la clasificación junto con el promedio de duración.*/

SELECT rating, AVG(length) AS duración
FROM film
GROUP BY rating
ORDER BY duración DESC;

/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/

SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE title = 'Indian Love';

/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/

SELECT title
FROM film
WHERE description LIKE '%dog%' OR title LIKE '%cat%';  

/* 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.*/

SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- también es posible contar el número de actores que no tienen película asociada

SELECT COUNT(a.actor_id) AS actores_no_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/

SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- si queremos ver también el año de lanzamiento y en orden descendente respecto al año

SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010
ORDER BY release_year DESC;

/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".*/

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/

SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor, COUNT(fa.film_id) AS numero_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY CONCAT(a.first_name, ' ', a.last_name)
HAVING COUNT(fa.film_id) > 10;

-- ordenamos por numero peliculas DESC

SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor, COUNT(fa.film_id) AS numero_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY CONCAT(a.first_name, ' ', a.last_name)
HAVING COUNT(fa.film_id) > 10
ORDER BY COUNT(fa.film_id) DESC;

/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la
tabla film.*/

SELECT title
FROM film 
WHERE rating = 'R' AND length > 120;

-- si mostramos también la duración descendente

SELECT title, length
FROM film 
WHERE rating = 'R' AND length > 120
ORDER BY length DESC;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120
minutos y muestra el nombre de la categoría junto con el promedio de duración.*/

SELECT c.name AS categoria,  AVG(f.length) AS promedio_duracion
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor
junto con la cantidad de películas en las que han actuado.*/

SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor, COUNT(fa.film_id) AS numero_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY CONCAT(a.first_name, ' ', a.last_name)
HAVING COUNT(fa.film_id) > 5;

-- ordenamos por aparicion en peliculas descendente

SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor, COUNT(fa.film_id) AS numero_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY CONCAT(a.first_name, ' ', a.last_name)
HAVING COUNT(fa.film_id) > 5
ORDER BY COUNT(fa.film_id) DESC;

/* 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona
las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una
fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)*/

-- probamos la función DATEDIFF

SELECT rental_id, DATEDIFF(return_date, rental_date) AS dias_alquilado
FROM rental
ORDER BY DATEDIFF(return_date, rental_date) DESC;

SELECT rental_id, DATEDIFF(rental_date, return_date) AS dias_alquilado
FROM rental
ORDER BY DATEDIFF(rental_date, return_date) DESC;

-- parece que la función DATEDIFF(fecha_inicial, fecha_final) que nos aportan no es correcta, sino que sería 
-- DATEDIFF(fecha_final, fecha_inicial)

SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IN (
	SELECT rental_id
    FROM rental 
    WHERE DATEDIFF(return_date, rental_date) > 5 
    );
       
-- si queremos también ver el número de días alquilado

SELECT DISTINCT f.title, DATEDIFF(r.return_date, r.rental_date) AS dias_alquilada
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IN (
	SELECT r.rental_id 
    FROM rental r
    WHERE DATEDIFF(r.return_date, r.rental_date) > 5 
    );


/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la
categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en
películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/

SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id
    FROM film_actor fa
	JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE name = 'Horror'
    );

/* BONUS

24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180
minutos en la tabla film con subconsultas.*/

SELECT f.title
FROM film f
WHERE length > 180 AND film_id IN (
	SELECT f.film_id
    FROM film_category fc
    WHERE category_id = (
      SELECT category_id
      FROM category
      WHERE name = 'Comedy'
    )
    );


/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La
consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que
han actuado juntos. Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un
alias diferente. */

SELECT A1.first_name AS actor1_first_name, 
	A1.last_name AS actor1_last_name,
    A2.first_name AS actor2_first_name, 
    A2.last_name AS actor2_last_name,
    COUNT(FA1.film_id) AS peliculas_juntos
FROM film_actor FA1         -- el SELF JOIN se hace con la tabla film_actor para emparejar 
JOIN film_actor FA2         -- los actores que están en la misma película
    ON FA1.film_id = FA2.film_id 
    AND FA1.actor_id < FA2.actor_id  -- Emparejamos actores distintos y EVITAMOS DUPLICADOS
    -- no utilizamos != porque daría duplicados ya que daría 2 filas para la misma combinación: actor1-actor2 y también actor2-actor1
JOIN actor A1 ON FA1.actor_id = A1.actor_id     -- para los datos del actor 1
JOIN actor A2 ON FA2.actor_id = A2.actor_id     -- para los datos del actor 2
GROUP BY A1.first_name, A1.last_name, A2.first_name, A2.last_name
HAVING COUNT(FA1.film_id) >= 1
ORDER BY peliculas_juntos DESC;

-- También es posible utilizar * en lugar de fillm_id para contar las películas:

SELECT A1.first_name AS actor1_first_name, 
	A1.last_name AS actor1_last_name,
    A2.first_name AS actor2_first_name, 
    A2.last_name AS actor2_last_name,
    COUNT(*) AS peliculas_juntos
FROM film_actor FA1         -- el SELF JOIN se hace con la tabla film_actor para emparejar los actores de la misma película
JOIN film_actor FA2 
    ON FA1.film_id = FA2.film_id 
    AND FA1.actor_id < FA2.actor_id  -- Emparejamos actores distintos y evitamos duplicados
JOIN actor A1 ON FA1.actor_id = A1.actor_id
JOIN actor A2 ON FA2.actor_id = A2.actor_id
GROUP BY A1.first_name, A1.last_name, A2.first_name, A2.last_name
HAVING COUNT(*) >= 1
ORDER BY peliculas_juntos DESC;

