#quetsion 1:afficher le nombre de films dans lesquels a joué l'acteur johny lollobrigida regoupé par catégorie
SELECT COUNT(f.title) as count_f, f.title  
FROM film as f 
JOIN film_actor as f_a on f_a.film_id=f.film_id 
JOIN actor AS a ON a.actor_id=f_a.actor_id 
JOIN film_category as f_c on f_c.film_id=f.film_id 
JOIN category as c on c.category_id=f_c.category_id
WHERE (a.first_name='JOHNNY' and a.last_name='LOLLOBRIGIDA')
GROUP BY c.name, f.title
;

#correction 1

# question 2: ecrire la requete qui affiche les catégories dans lesquels johnny lollobrigida totalise plus de 3 films
SELECT c.name FROM category AS c 
JOIN film_category AS f_c ON f_c.category_id=c.category_id
JOIN film AS f ON f.film_id=f_c.film_id 
JOIN film_actor AS f_a ON f.film_id=f_a.film_id
JOIN actor as a ON a.actor_id = f_a.actor_id
WHERE (a.last_name='LOLLOBRIGIDA')
GROUP BY c.name
HAVING COUNT(f.title)>=3;
;

#correction question 2



#question 3 : afficher la durée moyenne d'emprunt des films par acteurs
SELECT AVG(DATEDIFF(r.return_date, r.rental_date)), a.last_name FROM rental as r
JOIN inventory AS inv on inv.inventory_id=r.inventory_id 
JOIN film AS f ON f.film_id=inv.film_id
JOIN film_actor AS f_a ON f_a.film_id=f.film_id
JOIN actor AS a ON a.actor_id=f_a.actor_id
GROUP BY a.last_name;


#correction 3 




# question 4 : afficher l'argent total dépensé au vidéo clu par chaque clients , classé par ordre décroissants
SELECT SUM(p.amount) as sum_total, c.last_name FROM payment AS p
JOIN customer AS c ON c.customer_id=p.customer_id
GROUP BY last_name
order BY sum_total DESC;


#correction question 4




# question 5 : afficher tous les films ayant été loué 10 fois ou plus
SELECT f.title, COUNT(r.rental_date) FROM film as f
JOIN inventory as inv ON inv.film_id=f.film_id
JOIN rental AS r ON r.inventory_id=inv.inventory_id
GROUP BY f.title
HAVING COUNT(r.rental_date) >=10 ;


#correction question 5




#question 6 : quels acteurs ont le prénom "Scartlett"? 
 SELECT a.first_name, a.last_name FROM actor as a WHERE a.first_name='Scarlett';
 
 
 
#correction question 6


#question 7: quels acteurs ont le nom de famille "Johansson" ? 
SELECT a.first_name, a.last_name from actor as a WHERE a.last_name='Johansson';

#correction question 7


#question 8: combien de noms de familles d'acteurs distincts y a t'il ?
SELECT COUNT( DISTINCT a.first_name) FROM actor as a;

#correction question 8


#question 9 : quels noms de famille ne sont pas répétés?
SELECT a.first_name, COUNT(a.first_name)  FROM actor as a GROUP BY a.first_name HAVING COUNT(a.first_name)=1;


#correction question 9



#question 10: quels noms de famille apparaissent plus d'une fois ? 
SELECT a.first_name, COUNT(a.first_name)  FROM actor as a GROUP BY a.first_name HAVING COUNT(a.first_name)>1;


#correction question 10



#question 11: quel acteur est apparu dans le plus grand nombre de films ?
SELECT f_a.actor_id, COUNT(f_a.actor_id) as count_ FROM actor as a 
JOIN film_actor AS f_a ON f_a.actor_id=a.actor_id  
GROUP BY f_a.actor_id 
HAVING count_=MAX(count_);



#correction question 11
SELECT a.actor_id, COUNT(f_a.actor_id) as count_, a.last_name, a.first_name FROM actor AS a
JOIN film_actor AS f_a ON f_a.actor_id=a.actor_id  
GROUP BY f_a.actor_id
ORDER BY count_ DESC
LIMIT 1;


#question 12:  Insérez un enregistrement représentant Mary Smith louant "Academy Dinosaur" de Mike Hillyer au magasin 1 aujourd'hui. 

INSERT INTO rental(customer_id, inventory_id,rental_date)  VALUES  ('1','1',NOW() );


#question 13) Afficher les 10 locations les plus longues (nom/prenom client, film, video club, durée)
SELECT TIMEDIFF(r.return_date,r.rental_date) as time_,  c.first_name, c.last_name, f.title,  c.store_id 
FROM film AS f 
INNER JOIN inventory AS inv ON inv.film_id=f.film_id 
INNER JOIN rental AS r ON r.inventory_id=inv.inventory_id
INNER JOIN customer AS c ON c.customer_id=r.customer_id
ORDER BY time_ DESC Limit 10;


#question 14) Afficher les 10 meilleurs clients actifs par montant dépensé (nom/prénom client, montant dépensé)
SELECT SUM(p.amount) as sum_, c.first_name, c.last_name FROM payment AS p
INNER JOIN customer AS c ON c.customer_id=p.customer_id
GROUP BY p.customer_id 
ORDER BY sum_ DESC LIMIT 10;


#question 15)  Afficher la durée moyenne de location par film triée de manière descendante
SELECT AVG(TIMEDIFF(return_date, rental_date)) as avg_, f.title FROM film AS f 
INNER JOIN inventory AS inv ON inv.film_id=f.film_id 
INNER JOIN rental AS r ON r.inventory_id=inv.inventory_id
GROUP BY f.title
ORDER BY avg_ ASC
LIMIT 10 ;


#question 16) Afficher tous les films n'ayant jamais été empruntés
SELECT f.title, r.rental_date FROM film as f
INNER JOIN inventory as inv ON inv.film_id=f.film_id
LEFT JOIN rental as r ON r.inventory_id=inv.inventory_id
WHERE r.inventory_id IS NULL
;


#question 17)  Afficher le nombre d'employés (staff) par video club
SELECT Count(s.first_name), s.store_id FROM staff as s
GROUP BY s.store_id;


# question 18) Afficher les 10 villes avec le plus de video clubs
SELECT city, COUNT(a.address_id) as count_v FROM city as ci
JOIN address as a ON ci.city_id=a.city_id
GROUP BY city
ORDER by count_v DESC 
Limit 10;


# question 19) Afficher le film le plus long dans lequel joue Johnny Lollobrigida
SELECT f.title, f.length from film as f
INNER JOIN film_actor as f_a ON f_a.film_id=f.film_id
INNER JOIN actor as a ON a.actor_id=f_a.actor_id
WHERE a.first_name='Johnny' and a.last_name='Lollobrigida'
ORDER BY f.length DESC
limit 1 ; 
;


# question 20) Afficher le temps moyen de location du film 'Academy dinosaur
SELECT AVG(DAtediff(return_date, rental_date)) as avg_, f.title FROM film AS f 
INNER JOIN inventory AS inv ON inv.film_id=f.film_id 
INNER JOIN rental AS r ON r.inventory_id=inv.inventory_id
GROUP BY f.title
HAVING f.title ='Academy dinosaur'
 ;

# question 21) Afficher les films avec plus de deux exemplaires en inventaire (store id, titre du film, nombre d'exemplaires)

SELECT COUNT(inv.film_id) as count_f, f.title
FROM film AS f 
INNER JOIN inventory as inv ON inv.film_id=f.film_id
GROUP BY f.title
HAVING count_f >2
;

# question 22)  Lister les films contenant 'din' dans le titre
SELECT f.title FROM film AS f
WHERE f.title LIKE '%din%'
;

# question 23) Lister les 5 films les plus empruntés
SELECT COUNT(rental_date) as count_, f.title FROM film AS f 
INNER JOIN inventory AS inv ON inv.film_id=f.film_id 
INNER JOIN rental AS r ON r.inventory_id=inv.inventory_id
GROUP BY f.title
ORDER BY count_ DESC
LIMIT 5;


#question 24)  Lister les films sortis en 2003, 2005 et 2006
SELECT f.title, f.release_year FROM film as f
WHERE f.release_year IN (2003,2005,2006);


#)question 25) Afficher les films ayant été empruntés mais n'ayant pas encore été restitués, triés par date d'emprunt. Afficher seulement les 10 premiers.
SELECT f.title, f.film_id, r.rental_date FROM film as f
INNER JOIN inventory as inv ON inv.film_id=f.film_id
INNER JOIN rental as r ON r.inventory_id=inv.inventory_id
WHERE r.return_date IS NOT NULL
ORDER BY r.rental_date DESC;


#)14- Afficher les films d'action durant plus de 2h
SELECT f.title , f.length/60 FROM film AS f
WHERE f.length/60>2 
ORDER BY f.length DESC;


#)15- Afficher tous les utilisateurs ayant emprunté des films avec la mention NC-17
SELECT c.first_name, c.last_name, f.rating FROM customer as c
INNER JOIN rental AS r ON r.customer_id =c.customer_id
INNER JOIN inventory AS inv ON r.inventory_id=inv.inventory_id
INNER JOIN film AS f ON inv.film_id=f.film_id
WHERE f.rating='NC-17'
;


#)16- Afficher les films d'animation dont la langue originale est l'anglais
SELECT f.title, f.original_language_id, f.language_id , ca.name FROM film as f
INNER JOIN film_category AS f_a ON f_a.film_id=f.film_id
INNER JOIN category AS ca ON ca.category_id =f_a.category_id
WHERE f.language_id='1' and  ca.name='Animation'
;


#)17- Afficher les films dans lesquels une actrice nommée Jennifer a joué (bonus: en même temps qu'un acteur nommé Johnny)
SELECT f.title, f_a.film_id FROM film as f 
INNER JOIN film_actor as f_a ON f_a.film_id=f.film_id
WHERE f_a.actor_id=4; 

#bonus:
SELECT f_a.actor_id FROM film_actor as f_a 
JOIN film AS f ON f.film_id=f_a.film_id
WHERE f_a.actor_id=4 AND f_a.actor_id IN (SELECT f_a.film_id FROM film_actor as f_a 
WHERE f_a.actor_id=5) 
;

#)18- Quelles sont les 3 catégories les plus empruntées?
SELECT c.name , count(rental_date) as count_ FROM category as c
INNER JOIN film_category as f_a ON f_a.category_id=c.category_id
INNER JOIN film as f ON f.film_id=f_a.film_id
INNER JOIN inventory as inv ON inv.film_id=f.film_id
INNER JOIN rental as r ON r.inventory_id=inv.inventory_id
GROUP BY c.name
ORDER BY count_ DESC
LIMIT 3 ;


#)19- Quelles sont les 10 villes où on a fait le plus de locations?
SELECT ci.city , count(rental_date) as count_ FROM city as ci
INNER JOIN address as ad ON ad.city_id=ci.city_id
INNER JOIN customer as c ON c.address_id=ad.address_id
INNER JOIN rental as r ON r.customer_id=c.customer_id
GROUP BY ci.city
ORDER BY count_ DESC
LIMIT 10 ;


#)20- Lister les acteurs ayant joué dans au moins 1 film?
SELECT a.first_name, a.last_name, COUNT(f_a.film_id)  FROM actor as a
LEFT JOIN film_actor as f_a ON f_a.actor_id=a.actor_id
WHERE f_a.actor_id IS NOT NULL 
GROUP BY a.first_name, a.last_name ;
