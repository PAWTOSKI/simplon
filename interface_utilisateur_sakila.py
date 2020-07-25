##importation des paquets nécessaires

import sqlalchemy as sqla
from sqlalchemy import create_engine
import pandas as pd
import matplotlib.pyplot as plt

#création du "connect object" au travers la commande create_engine et de l'objet de requête 
engine=create_engine('mysql+pymysql://PW:wilfredi1@localhost')
query_="SELECT city from sakila.city"
data_=pd.read_sql_query(query_, engine)
data_=data_['city'].tolist() ## mise en liste du dataframme des noms de ville pour l'implémenter dans la commande d'entrée



# interface par le terminal pour choisir la ville et l'année voulues
city_sql='no_stop'
while city_sql=='no_stop':     #utilisation de la boucle pour évite toute entrée de nom de ville incorrecte
    city_sql=input(f'choisissez la ville souhaité pour l"étude parmi la liste suivante {data_} .\n Faites votre choix: ')
    if city_sql not in data_: 
        city_sql='no_stop'
        print ('erreur de frappe.veuillez réessayez svp')
year_sql=int(  input('veuillez tapez l année voulue pour l analyse ( ex: 2005) : ')  )

# requête élaborée pour extraire les données pertinentes relatives aux 
query_=f'SELECT  AVG(p.amount) as avg_ ,SUM(p.amount) as sum_, YEAR(p.payment_date) as year_, WEEK(p.payment_date) as week_ from sakila.city as ci INNER JOIN sakila.address AS a ON a.city_id=ci.city_id INNER JOIN sakila.store as s on s.address_id=a.address_id INNER JOIN sakila.customer as c ON c.store_id=s.store_id INNER JOIN sakila.payment as p ON p.customer_id=c.customer_id WHERE ci.city="{city_sql}" GROUP BY year_ ,week_ HAVING year_={year_sql} ;'
data_=pd.read_sql_query(query_, engine)

# Mise en représentaton graphique de l'évolution des ventes et du montat d'achat moyen,sous forme d'histogramme 
x=data_['week_']
y1=data_['sum_']
y2=data_['avg_']
fig, ax=plt.subplots(2,1, figsize=(20,20), sharex=True)
ax[0].plot(x,y1,c='red')
ax[0].set_xlabel(' Semaines dans l année choisie')
ax[0].set_ylabel('montant (Euros)')
ax[0].set_title('Montant cumulée d emprunts pour chaque semaine')
ax[0].grid(True)
ax[1].plot(x, y2)
ax[1].set_ylabel('montant (Euros)')
ax[1].set_title(f'Montant moyen par achat pour chaque semaine durant l"année {year_sql}, pour la ville')
ax[1].grid(True)






## interface pour l'entrée par le terminal de la catégorie et de l'année voulues
data_=pd.read_sql_query( "SELECT DISTINCT name FROM sakila.category" , engine)
data_=data_['name'].tolist()  ## mise en liste du dataframme des noms de ville pour l'implémenter dans la commande d'entrée
category1_sql='no stop'
category2_sql='no stop'
while category1_sql=='no stop' and category2_sql=='no stop':  # boucle "wile" permettant d'éviter toute entrée érronée de catégorie
    category1_sql=input(f'tapez la catégorie souhaitée parmi les choix ci contre. {data_} \n faites votre choix: ')
    category2_sql=input(f'tapez la deuxième catégorie souhaitée parmi les choix ci contre. {data_} \n faites votre choix: ')
    if category1_sql not in data_ or category2_sql not in data_ :
        category1_sql='no stop'
        category2_sql='no stop'
        print('erreur de frappe. veuillez réessayez avec l orthographe exact')



#entrée des variables souhaitées par l'utilisateur
        
data_=pd.read_sql_query("SELECT store_id FROM sakila.store", engine)
data_=data_['store_id'].tolist()
store_sql=int(input(f'veuillez taper l identifiant du magasin voulu dans la liste si contre {data_} : ' ))
year_sql=int( input('veuillez tapez l année voulue pour l analyse ( ex: 2005) : ')  )
query1_=f'SELECT WEEK(p.payment_date) as week_, SUM(p.amount) as amount_ from sakila.category as ca INNER JOIN sakila.film_category as f_a ON ca.category_id=f_a.category_id INNER JOIN sakila.film as f on f.film_id=f_a.film_id INNER JOIN sakila.inventory as inv on inv.film_id=f.film_id INNER JOIN  sakila.store as st on st.store_id=inv.store_id INNER JOIN sakila.customer as c on c.store_id=st.store_id INNER JOIN sakila.payment as p on p.customer_id=c.customer_id WHERE c.store_id={store_sql} and ca.name="{category1_sql}" and YEAR(p.payment_date)={year_sql} GROUP BY week_;'
query2_=f'SELECT WEEK(p.payment_date) as week_, SUM(p.amount) as amount_ from sakila.category as ca INNER JOIN sakila.film_category as f_a ON ca.category_id=f_a.category_id INNER JOIN sakila.film as f on f.film_id=f_a.film_id INNER JOIN sakila.inventory as inv on inv.film_id=f.film_id INNER JOIN  sakila.store as st on st.store_id=inv.store_id INNER JOIN sakila.customer as c on c.store_id=st.store_id INNER JOIN sakila.payment as p on p.customer_id=c.customer_id WHERE c.store_id={store_sql} and ca.name="{category2_sql}" and YEAR(p.payment_date)={year_sql} GROUP BY week_;'

data1_=pd.read_sql_query(query1_, engine) #données liées à catégorie 1
data2_=pd.read_sql_query(query2_, engine) #données liées à catégorie 2



# mise en représentation graphique de l'évolution des ventes en fonction de la catégorie, de l'année et de la ville choisies

data_=pd.merge(data1_, data2_, on ='week_')
graph=data_.plot(kind='bar', x='week_', y=['amount__x','amount__y'], grid=True, figsize=(15,15) )
graph.set_xlabel( f'semaines de l année {year_sql}')
graph.set_ylabel(f'recettes entrantes (euros) ')
graph.set_title( f'histogramme comparative des évolutions d"emprunts pour le magasin {store_sql} durant l"année {year_sql}')
graph.legend([f'catégorie: {category1_sql}', f'catégorie: {category2_sql}' ])
























































        







    
        
    



