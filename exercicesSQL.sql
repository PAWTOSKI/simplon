#Requetes avancees

#1.Afficher tout les emprunt ayant été réalisé en 2006. Le mois doit être écrit en toute lettres lettre et le résultat doit s’afficher dans une seul colonne.

select concat( rental_id,'  ',MONTHNAME(rental_date))as 'rental_id  month' 
FROM rental 
WHERE YEAR(RENTAL_DATE)=2006;

#2.Afficher la colonne qui donne la durée de location des films en jour.

select rental_id, DATEDIFF(return_date, rental_date)  as 'duration_day' 
FROM rental;

#3.Afficher les emprunts réalisés avant 1h du matin en 2005. Afficher la date dans un
#format lisible.

select rental_id, HOUR(rental_date) as hour_rent FROM rental 
WHERE YEAR(RENTAL_DATE)=2005 AND HOUR(rental_date) <=1 ;


#4.Afficher les emprunts réalisé entre le mois d’avril et le moi de mai. La liste doit être trié du plus ancien au plus récent.

select rental_id, MONTH(rental_date) as month_rent 
FROM rental 
WHERE MONTH(RENTAL_DATE) between 4 AND 5 ;

#5.Lister les film dont le nom ne commence pas par le « Le ».

SELECT f.title 
FROM film as f
WHERE left(f.title, 3) NOT REGEXP "^Le |The"  ;

#6.Lister les films ayant la mention « PG 13 » ou « NC 17 ». Ajouter une colonne qui affichera « oui » si « NC 17 » et « non » Sinon.

SELECT f.rating, f.title, IF (f.rating='NC-17', 'Yes', 'No') 
FROM film AS f
WHERE f.rating in ('PG-13', 'NC-17')
;

#7.Fournir la liste des catégorie qui commence par un ‘A’ ou un ‘C’. (Utiliser LEFT).

SELECT cat.name 
FROM category as cat
WHERE LEFT(cat.name,1) in ('A','C');

#8.Lister les trois premiers caractères des noms des catégorie.

SELECT LEFT(cat.name,3) 
FROM category as cat
;

#9.Lister les premiers acteurs en remplaçant dans leur prenom les E par des A.

SELECT replace(act.last_name,'A','E') as last_name , act.first_name
FROM actor as act
;

# Pour aller plus Loin 
#1 Afficher les 10 locations les plus longues (nom/prenom client, film, video club, durée)

SELECT ROUND ((TO_SECONDS(rent.return_date)-TO_SECONDS(rent.rental_date) ), 0) as duration_hour, f.title
FROM customer AS cust
INNER JOIN rental AS rent ON cust.customer_id=rent.customer_id
INNER JOIN inventory AS inv ON inv.inventory_id=rent.inventory_id
INNER JOIN film  AS f ON inv.film_id=f.film_id
ORDER BY duration_hour DESC
LIMIT 10
;

#2 Afficher les 10 meilleurs clients actifs par montant dépensé (nom/prénom client, montant dépensé)

SELECT CONCAT(cust.last_name, ' ' ,cust.first_name) as customer_, SUM(pay.amount) as amount
FROM payment as pay
INNER JOIN customer AS cust ON cust.customer_id=pay.customer_id
GROUP BY customer_
ORDER BY amount DESC
LIMIT 10
;

#3 Afficher la durée moyenne de location par film triée de manière descendante

SELECT AVG((TO_SECONDS(rent.return_date)-TO_SECONDS(rent.rental_date))/(60*60) ) as duration_hour, f.title
FROM customer AS cust
INNER JOIN rental AS rent ON cust.customer_id=rent.customer_id
INNER JOIN inventory AS inv ON inv.inventory_id=rent.inventory_id
INNER JOIN film  AS f ON inv.film_id=f.film_id
GROUP BY f.title
ORDER BY duration_hour
;



#4 Afficher tous les films n'ayant jamais été empruntés

SELECT f.title 
FROM film as f
LEFT JOIN inventory AS inv ON inv.film_id=f.film_id
LEFT JOIN rental AS rent ON rent.inventory_id=inv.inventory_id
WHERE rent.inventory_id is null and inv.film_id is Null
;

#5 Afficher le nombre d'employés (staff) par video club

SELECT st.store_id, SUM(sta.staff_id) as sum_staff FROM store as st
INNER JOIN staff AS sta ON sta.store_id=st.store_id
GROUP BY st.store_id
;

#6 Afficher les 10 villes avec le plus de video clubs

SELECT SUM(st.store_id) as sum_store, ci.city
FROM store AS st
INNER JOIN address AS addr ON addr.address_id=st.address_id
INNER JOIN city AS ci ON ci.city_id=addr.city_id
GROUP BY ci.city
;

#7 Afficher le film le plus long dans lequel joue Johnny Lollobrigida

SELECT f.title, f.length
FROM film as f
INNER JOIN film_actor as f_a ON f_a.film_id=f.film_id
INNER JOIN actor as act ON act.actor_id=f_a.actor_id
WHERE CONCAT( act.first_name,' ',act.last_name)='Johnny Lollobrigida'
AND f.length IN 
(SELECT max(f.length)
FROM film as f
INNER JOIN film_actor as f_a ON f_a.film_id=f.film_id
INNER JOIN actor as act ON act.actor_id=f_a.actor_id)
;

#8 Afficher le temps moyen de location du film 'Academy dinosaur'

SELECT AVG(TO_seconds(rent.return_date)-TO_seconds(rent.rental_date))/(60*60) AS avg_duration, f.title
FROM film as f
INNER JOIN inventory AS inv ON inv.film_id=f.film_id
INNER JOIN rental AS rent ON rent.inventory_id=inv.inventory_id
GROUP BY f.title
HAVING f.title REGEXP 'Academy dinosaur'
;

#9 Afficher les films avec plus de deux exemplaires en inventaire (store id, titre du film, nombre d'exemplaires)

SELECT f.title, st.store_id, COUNT(inv.film_id) as count_produits
FROM film AS f
INNER JOIN inventory AS inv ON inv.film_id=f.film_id
INNER JOIN store as st ON st.store_id=inv.store_id
GROUP BY f.title
HAVING count_produits>2
;

#10 Lister les films contenant 'din' dans le titre

SELECT f.title 
FROM film AS f
WHERE f.title REGEXP 'din'
;

#11 Lister les 5 films les plus empruntés

SELECT f.title, count(rent.rental_id) AS count_rent
FROM film AS f
INNER JOIN inventory AS inv ON inv.film_id=f.film_id
INNER JOIN rental AS rent ON rent.inventory_id=inv.inventory_id
GROUP BY f.title
ORDER by count_rent DESC
LIMIT 5
;

#12 Lister les films sortis en 2003, 2005 et 2006

SELECT f.film_id, f.release_year
FROM film AS f
WHERE f.release_year IN (2003, 2005, 2006) 
;

#13 Afficher les films ayant été empruntés mais n'ayant pas encore été restitués, triés par date d'emprunt. Afficher seulement les 10 premiers.

SELECT f.title, rent.rental_date
FROM film as f
INNER JOIN INVENTORY as inv ON inv.film_id=f.film_id
INNER JOIN rental as rent ON rent.inventory_id=inv.inventory_id
WHERE rent.return_date is null;

#14 Afficher les films d'action durant plus de 2h

SELECT f.title, (f.length/60) as hour_duration 
FROM film as f
WHERE f.length/60>2
;


#15 Afficher tous les utilisateurs ayant emprunté des films avec la mention NC-17

SELECT cust.customer_id
FROM customer AS cust
INNER JOIN rental AS rent ON cust.customer_id=rent.customer_id
INNER JOIN inventory AS inv ON inv.inventory_id=rent.inventory_id
INNER JOIN film  AS f ON inv.film_id=f.film_id
GROUP BY f.title
;


#16 Afficher les films d'animation dont la langue originale est l'anglais

select f.title, lang.name as original_language
FROM film as f
INNER JOIN language as lang ON lang.language_id=f.original_language_id
WHERE lang.name like '%English%';

#17 Afficher les films dans lesquels une actrice nommée Jennifer a joué (bonus: en même temps qu'un acteur nommé Johnny)

SELECT f.title
FROM film as f
INNER JOIN film_actor as f_a ON f_a.film_id=f.film_id
INNER JOIN actor as act ON act.actor_id=f_a.actor_id
WHERE act.first_name regexp 'Jennifer|Johny'
;

#18 Quelles sont les 3 catégories les plus empruntées?

SELECT cat.name , COUNT(rent.rental_id) as count_category
FROM category as cat 
INNER JOIN film_category AS f_c ON cat.category_id=f_c.category_id
INNER JOIN film AS f ON f_c.film_id=f.film_id
INNER JOIN inventory AS inv ON inv.film_id=f.film_id
INNER JOIN rental AS rent ON rent.inventory_id=inv.inventory_id
GROUP BY cat.name
ORDER BY count_category DESC
LIMIT 3
;

#19 Quelles sont les 10 villes où on a fait le plus de locations?

SELECT Count(rent.rental_id) as count_rent, ci.city
FROM rental as rent
INNER JOIN customer AS cust ON cust.customer_id=rent.customer_id
INNER JOIN  address AS addr ON addr.address_id=cust.address_id
INNER JOIN city AS ci ON ci.city_id=addr.city_id
GROUP BY ci.city
ORDER BY count_rent DESC
LIMIT 10
;

#20 Lister les acteurs ayant joué dans au moins 1 film

SELECT concat(act.first_name,' ',act.last_name) as actor_
FROM actor as act
WHERE exists 
(select 1 
FROM film_actor as f_a
INNER JOIN film as f ON f_a.film_id=f.film_id
WHERE act.actor_id=f_a.actor_id)
;

SELECT concat(act.first_name,' ',act.last_name), f_a.actor_id, f_a.film_id as actor_
FROM actor as act
LEFT JOIN film_actor as f_a ON act.actor_id=f_a.actor_id
LEFT JOIN film as f ON f_a.film_id=f.film_id 
WHERE f_a.film_id is NULL
;

#Jointures 
#1.Lister les 10 premiers films ainsi que leur langues.

SELECT f.title, lan.name
FROM film as f
INNER JOIN language as lan ON lan.language_id=f.language_id
ORDER BY f.title ASC
LIMIT 10;

#2.Afficher les film dans les quel à joué « JENNIFER DAVIS » sortie en 2006.

select f.title 
FROM film AS f
INNER JOIN film_actor AS f_a ON f_a.film_id=f.film_id
INNER JOIN actor AS act ON act.actor_id=f_a.actor_id
WHERE concat(act.first_name, ' ',act.last_name)='JENNIFER DAVIS'
;

#3.Afficher le noms des client ayant emprunté « ALABAMA DEVIL ».

SELECT cust.last_name 
FROM film as f
INNER JOIN inventory AS inv ON inv.film_id=f.film_id
INNER JOIN rental AS rent ON rent.inventory_id=inv.inventory_id
INNER JOIN customer as cust ON cust.customer_id=rent.customer_id
WHERE f.title REGEXP 'ALABAMA DEVIL'
;

#4.Afficher les films louer par des personne habitant à « Woodridge ». Vérifié s’il y a des films qui n’ont jamais été emprunté.

SELECT f.title
FROM film as f
LEFT JOIN inventory AS inv ON inv.film_id=f.film_id
LEFT JOIN rental AS rent ON rent.inventory_id=inv.inventory_id
INNER JOIN customer as cust ON cust.customer_id=rent.customer_id
INNER JOIN address AS addr ON addr.address_id=cust.address_id
INNER JOIN city as ci ON ci.city_id=addr.city_id
WHERE ci.city LIKE '%Woodridge%';

#5.Quel sont les 10 films dont la durée d’emprunt à été la plus courte ?

SELECT f.title, (TO_seconds(return_date) - TO_SECONDS(rental_date) )/(60*60) AS DURATION_HOUR
FROM film as f
INNER JOIN inventory AS inv ON inv.film_id=f.film_id
INNER JOIN rental AS rent ON rent.inventory_id=inv.inventory_id
#WHERE return_date IS NOT NULL
ORDER BY DURATION_HOUR ASC
LIMIT 10
;


#6.Lister les films de la catégorie « Action » ordonnés par ordre alphabétique.

SELECT f.title 
FROM film as f
INNER JOIN film_category as f_a ON f_a.film_id=f.film_id
INNER JOIN category AS cat ON cat.category_id=f_a.category_id
WHERE cat.name='Action'
ORDER BY f.title ASC
;

#7.Quel sont les films dont la duré d’emprunt à été inférieur à 2 jour ?

SELECT f.title, (TO_seconds(return_date) - TO_SECONDS(rental_date) )/(60*60*24) AS DURATION_JOUR
FROM film as f
INNER JOIN inventory AS inv ON inv.film_id=f.film_id
INNER JOIN rental AS rent ON rent.inventory_id=inv.inventory_id
WHERE  (TO_seconds(return_date) - TO_SECONDS(rental_date) )/(60*60*24) <2
;





