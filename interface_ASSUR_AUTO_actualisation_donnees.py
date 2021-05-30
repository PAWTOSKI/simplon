#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 20 13:40:49 2020

@author: pw
"""

#import des paquets nécessaires

from sqlalchemy import create_engine
import pandas as pd
import numpy as np
import re
from datetime import date

connexion=create_engine('mysql+pymysql://PW:wilfredi1@localhost')
data=pd.read_sql_query('SELECT * from ASSUR_AUTO.CONTRATS',connexion)



#entrée des données personnelles relatives au client et au contrat souscrit
commande= True
while commande==True:
    CL_NOM=str( input('tapez un nom de client: ') ).upper() 
    CL_PRENOM=str( input('tapez le prénom du client: ') ).lower()
    CL_ADRESSE=str (input ('tapez l"adresse du client sous le format "N°rue ,nom de la rue": ') )

    CL_VILLE=str( input('tapez le code postale de la ville figurant sur l"adresse: ') )

    pattern=r'(.*)\D(.*)'
    match=re.search(pattern, CL_VILLE)
    if match or len(CL_VILLE)!=5:
        raise ValueError
    CL_COORDONEES=str( input('tapez l"adresse mail du client sous la forme: ') ) 
    CO_CATEGORIE=str( input('tapez la catégorie de contrat souscrit: ') )
    CO_BONUS_MALUS=str( input('tapez le bonus ou malus du contrat: ') )
    D_J=str( input('tapez la date du jour de souscription du contrat: ') ) 
    D_M=str( input('tapez le mois sous format numérique de souscription du contrat: ') ) 
    D_A=str( input('tapez l année de souscription du contrat: ') ) 
    CO_DATE=f'{D_A}/{D_M}/{D_J}'


# Commande alternative à la condition que l'ID soit fourni automatiquement et unique :connexion.execute('ALTER TABLE ASSUR_AUTO.CLIENTS MODIFY CL_ID INT(11) NOT NULL AUTO_INCREMENT;')
#connexion.execute('insert into ASSUR_AUTO.CLIENTS (CL_ID, CL_NOM, CL_PRENOM, CL_ADRESSE, CL_VILLE, CL_COORDONEES) VALUES ("%s","%s","%s","%s","%s","%s");' %(CL_ID, CL_NOM, CL_PRENOM, CL_ADRESSE, CL_VILLE, CL_COORDONEES)  )
    max_id='( SELECT (max(CL_ID)+1) FROM ASSUR_AUTO.CLIENTS AS CL)'
    connexion.execute(f'insert into ASSUR_AUTO.CLIENTS (CL_ID, CL_NOM, CL_PRENOM, CL_ADRESSE, CL_VILLE, CL_COORDONEES) VALUES  ( {max_id},"{CL_NOM}","{CL_PRENOM}", "{CL_ADRESSE}", "{CL_VILLE}","{CL_COORDONEES}")')

#max_id_contrat permet d'instancier une id unique et etant attribuant automatiquement
    max_id_contrat='(SELECT (max(CO_ID_CONTRAT)+1) FROM ASSUR_AUTO.CONTRATS AS CO)'
    connexion.execute(f'INSERT INTO ASSUR_AUTO.CONTRATS(CO_ID_CONTRAT , CO_DATE, CO_CATEGORIE, CO_BONUS_MALUS, CO_CLIENTS_FK ) VALUES ({max_id_contrat}, "{CO_DATE}", "{CO_CATEGORIE}",{CO_BONUS_MALUS}, {max_id}-1 ) ')
    commande=input('tapez "True si vous désirez entrer un nouveau client ,ou "False" pour achever l actualisation des données: ')
    



