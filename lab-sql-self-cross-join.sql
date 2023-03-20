USE sakila;

# 1. Get all pairs of actors that worked together.

SELECT 
    fa1.actor_id AS actor_1,
    fa2.actor_id AS actor_2,
    fa1.film_id		# since the film_id will have to be the same, one mention is enough
FROM
    film_actor fa1
        JOIN
    film_actor fa2
WHERE
    fa1.film_id = fa2.film_id
        AND fa1.actor_id < fa2.actor_id;	# using < symbol instead of <> to only get each pair one time on the output
        

# 2. Get all pairs of customers that have rented the same film more than 3 times.

SELECT 
    film_id, COUNT(inventory_id)
FROM
    inventory
GROUP BY film_id
HAVING COUNT(inventory_id) > 1;
# running this query, we can see that there are multiple film_ids associated with some of the inventory_ids in the table category (multiple foreign keys possible for each primary key)
# thus, in the following query, I will specify that the film_id of the rentals in question need to be the same

SELECT 
    i1.film_id,
    i2.film_id,
    r1.customer_id AS customer_1,
    r2.customer_id AS customer_2
FROM
    inventory i1
        JOIN
    inventory i2 USING (inventory_id)
        JOIN
    rental r1 USING (inventory_id)
        JOIN
    rental r2 USING (inventory_id)		# attempting to JOIN USING (rental_id) didn't work, so I'm using inventory_id instead
GROUP BY i1.film_id , i2.film_id , r1.customer_id , r2.customer_id
HAVING COUNT(*) > 3
    AND customer_1 < customer_2
    AND i1.film_id = i2.film_id;			
# No pairs of customers that have rented more than 3 times, but there is one that has rented 2 times (COUNT(*)>=2)


# 3. Get all possible pairs of actors and films.

## I will join the table actor with the table film_actor to extract the actor's name and then cross join with the table film to get all potential pairs
SELECT 
    f.title, a.first_name, a.last_name
FROM
    actor a
        JOIN
    film_actor fa USING (actor_id)
        CROSS JOIN
    film f
GROUP BY title , first_name , last_name;