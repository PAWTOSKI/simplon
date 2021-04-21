import random


liste_départ=['comment allez vous ?', 'pourquoi venez vous me voir ?','comment s"est passé votre journée? ']


keywords=['père', 'mère','copain','copine','maman','papa','ami','amie']
keyword=[]


liste_q=['pourquoi me posez vous cette question?', 'oseriez vous poser cette question ?', 'je ne peux malheureusement pas répondre à cette question' ]

liste_vague=['j"entends bien. ' , 'je sens une pointe de regret. ', 'est-ce une bonne nouvelle ? ', f'oui c"est ça le problème. ', f'Pensez vous ce que vous dites?', f'Hum.....il se peut.']
insultes=['idiot', 'abruti']
réponses_insulte=['faites attention, la politesse est exigée ici', 'attention, Hadopi vous surveille' ]
liste_fin=['marre', 'au revoir' , 'à bientôt']
salutations=["au revoir, merci pour votre utilisation", "hasta luego"]
relance=['je n"ai pas compris votre déclaration. Pouvez-vous répeter s"il vous plait? ','votre phrase ne m"est pas parvenue. répétez la s"il vous plaît']
reponse=input(random.choice(liste_départ))
#reponse=input(liste_départ[ random.randint(0,len(liste_départ)-1)  ]  )

interrupteur=True


while interrupteur==True:
       keyword=[]
       keyword=[m for m in reponse.split(' ') if (m.lower() in keywords) or (m=='?') or (m.lower() in insultes ) or ( m.lower() in liste_fin )  ]
    
       
      
           
       if not(keyword):
           reponse=input(random.choice(relance))
            
          

       elif  keyword[0] in keywords:
            liste_réponses=[f'comment va votre {keyword[0]} ?', f'la relation avec votre {keyword[0]} vous pose t"elle problème ?' , f'pourquoi penser vous en ce moment à votre {keyword[0]}?']

            reponse=input(random.choice(liste_réponses))


       elif keyword[0]=='?' :
            reponse=input(random.choice(liste_q))
            


       elif keyword[0] in insultes:
            reponse=input(random.choice(réponses_insulte))

       elif  keyword[0] in liste_fin:
            interrupteur=False
            
       else:
            reponse=input(random.choice(relance))
            
      
     


print(random.choice(salutations))