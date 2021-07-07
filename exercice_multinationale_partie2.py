#!/usr/bin/env python
# coding: utf-8

# In[2]:




#tables:  
#task_performed (en attente), other_duties(en attente),other_database(en attente),
#employement_sector

import pandas as pd 
from sqlalchemy import create_engine
import json
import re
import numpy as np
import os
from cryptography.fernet import Fernet


# In[3]:


#récupération des clés de cryptage

path=os.path.abspath('ressources\config_encrypted.txt')
path_k=os.path.abspath('ressources\key.txt')

#path='\ressources\config.txt'
#path_k='\ressources\config_encrypted.txt'


# In[4]:


#pour encrypter fichier config.txt:
"""with open (os.path.realpath(path), 'rb') as file:
            file=file.read()
output_file=os.path.join(os.getcwd(), 'ressources\config_encrypted.txt')

key=Fernet.generate_key()
print(key)
fernet=Fernet(key)
encrypted=fernet.encrypt(file)
with open (output_file, 'wb') as file:
            file.write(encrypted)"""


# In[5]:


# ressource utilisé pour encrypter dossier: 
#https://www.linkedin.com/pulse/python-encrypting-config-files-michael-heitz/?articleId=6557975990306430977

class connector_():
    def __init__(self, path_input, path_key):
        #//mettre en property
        with open(path_key, 'rb') as file:
            self.__key=file.read()
            
        with open(path_input, 'rb') as file:
            self.__config=file.read()
        try:
            fernet=Fernet(self.__key)
            data=fernet.decrypt(self.__config)
        except:
            print ("clé Fernet incorrecte ou déjà entré")

            
      
   
            
        self.__config=json.loads(data)
        host=self.__config['host']
        nameuser=self.__config['name']
        passw=self.__config['password']
        port=self.__config['port']
        dbname=self.__config['db']
        
        print('1111')                 
       # self.engine=create_engine()
        self.engine=create_engine(f"mysql+pymysql://{nameuser}:{passw}@{host}:{port}/{dbname}")
                                
                                  
                                  
        

        



            
        
    
#{'name': 'root', 'host': 'localhost', 'password': 'root', 'port': '3306', 'db': 'simplon'}
#connector_a=create_engine(f'mysql+pymysql://{name}:{password}@{host}:{port}/{db}')

    


# In[6]:


connector1=connector_(path, path_k)
path="ressources/Data_Professional_Salary_Survey_Responses_1.xlsx"
data=pd.read_excel(path).replace(np.nan, 'nan')


# In[7]:


#table looking_jobs


db='simplon'

    
        
table="looking_job"

connector1.engine.connect().execute(f"DELETE FROM {db}.{table};")
connector1.engine.connect().execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

path="ressources/Data_Professional_Salary_Survey_Responses_1.xlsx"

looking_job=pd.DataFrame( {'look_job': data['LookingForAnotherJob'].unique() },
                            columns=['look_job']
                        ).astype('str')

# attention le nom de la colonne doit être en conformité avec la table prévue sur SQL

looking_job=looking_job.drop_duplicates()
looking_job.index+=1
looking_job.to_sql('looking_job', con=connector1.engine, if_exists='append', index= False)


# In[8]:


# table "KindsOfTasksPerformed"

table="task"

connector1.engine.connect().execute(f"DELETE FROM {db}.{table};")
connector1.engine.connect().execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")


data1=pd.read_excel(path)['KindsOfTasksPerformed'].astype('str').unique()
temp='' 
for row in data1:
    temp+=f' {row} '

temp=re.sub(r'[ +[\,|&] +|  {2-8}]', ',', temp).split(',')

#non sélection des termes dont un espace est présent à l'un des extrêmités du terme
#la fonction list est appelé afin que la variable "temp" dispose d'un index exploitable par pandas


temp=list(set([i for i in temp if not re.match(r'^ .+|.+ \Z',i)]))

task=pd.DataFrame({'tas_name':temp}).replace(np.nan, 'Nan')
task.to_sql('task', con=connector1.engine, index=False, if_exists='append' )


# In[ ]:





# In[9]:


#table sondage
table='sondage'

connector1.engine.connect().execute(f"DELETE FROM {db}.{table};")
connector1.engine.connect().execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")



sondage= pd.DataFrame({'sdg_year': data['Survey Year'].unique()}, columns = ['sdg_year']).astype('str')
sondage.drop_duplicates(inplace=True)
sondage.index+=1
sondage.to_sql('sondage', if_exists='append', con=connector1.engine, index=False)


# In[10]:


# table education

table='education'
connector1.engine.connect().execute(f"DELETE FROM {db}.{table};")
connector1.engine.connect().execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

education= pd.DataFrame({"edu_title":data["Education"].unique()}, columns=['edu_title']).astype('str')
education.drop_duplicates(inplace=True)
education.index+=1
education.to_sql('education', if_exists='append', con=connector1.engine, index=False)


# In[11]:


# table how_many_companies
# attention, il faut élargir le champ autorisé de caractères
table='How_Many_Companies'

connector1.engine.connect().execute(f"DELETE FROM {db}.{table};")
connector1.engine.connect().execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")


how_many_companies= pd.DataFrame({"mcp_many_companies":data['HowManyCompanies'].unique()},
                                 columns=['mcp_many_companies']
                                ).astype('str')

how_many_companies.drop_duplicates(inplace=True)
how_many_companies.index+=1


how_many_companies.to_sql('How_Many_Companies', if_exists='append', con=connector1.engine, index=False)


# In[12]:


#table employement_status

table='employment_status'

connector1.engine.connect().execute(f"DELETE FROM {db}.{table};")
connector1.engine.connect().execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

employment_status=pd.DataFrame({"emp_status" : data["EmploymentStatus"].unique()}, 
                                 columns = ["emp_status"]
                              ).astype('str')

employment_status.drop_duplicates(inplace=True)
employment_status.index+=1


employment_status.to_sql('employment_status', if_exists = "append", con = connector1.engine, index = False)


# In[13]:


# table PopulationOfLargestCityWithin20Miles

table='largest_city'

connector1.engine.execute(f"DELETE FROM {db}.{table};")
connector1.engine.execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

largest_city=pd.DataFrame({'pop_name': data['PopulationOfLargestCityWithin20Miles'].unique() }, 
                          columns=["pop_name"]
                        ).astype('str')

largest_city.drop_duplicates(inplace=True)
largest_city.index+=1

largest_city.to_sql('largest_city', if_exists='append', con=connector1.engine, index=False)


# In[14]:


# table carreer_plan 

table='carreer_plan'
connector1.engine.execute(f"DELETE FROM {db}.{table};")
connector1.engine.execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

carreer_plan=pd.DataFrame({"cap_plan":data['CareerPlansThisYear'].unique()},
                         columns=['cap_plan']
                        ).astype('str')

carreer_plan.drop_duplicates(inplace=True)
carreer_plan.index+=1

carreer_plan.to_sql('carreer_plan', if_exists='append', con=connector1.engine, index=False)


# In[15]:


# table certification

table='certification'
connector1.engine.execute(f"DELETE FROM {db}.{table};")
connector1.engine.execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

certification=pd.DataFrame({"cert_name":data['Certifications'].unique()},
                           columns=['cert_name']
                        ).astype('str')

certification.drop_duplicates(inplace=True)
certification.index+=1

certification.to_sql('certification', if_exists='append', con=connector1.engine, index=False)


# In[16]:


# table job

##uniformisation des chaînes de caractères entre parenthèses de la colonne ['otherjobduties'] 
# et de la colonne{}
 
jobs=data['OtherJobDuties'].str.findall(pat=r'\([^\)]+\,+[^\)]+\)')
#print('reml   \n\n\n  ',data1['OtherJobDuties'].unique())


for job in jobs:
    
#condition vérifiant si l'itération ne se réalise pas sur liste vide, et bien
# sur un intitulé de tâches encore présents dans le data['JobTtile']

    if job!=[] and any(data['OtherJobDuties'].str.contains(job[0])):
        
# ici , le pattern job[0] est sélectionné sans les parenthèses

        job_temp=job[0][1:-1].replace(', ', ' and ')
    
# remplacement des extraits entre parenthèses avec des ',' par des extraits sans ','

        data['OtherJobDuties']=data['OtherJobDuties'].str.replace(pat=job[0],
                                                                   repl=job_temp)
        data['JobTitle']= data['JobTitle'].str.replace(pat=job[0],
                                                        repl=job_temp)
        
        
##
table='job'
connector1.engine.execute(f"DELETE FROM {db}.{table};")
connector1.engine.execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

jobs=pd.DataFrame({'job_name': data['JobTitle'].unique() }, 
                 columns=['job_name']
                ).astype('str')

jobs.drop_duplicates(inplace=True)
jobs.index+=1

jobs.to_sql('job', if_exists='append', con=connector1.engine, index=False)

print(jobs)


# In[17]:


# table database

table='database'
connector1.engine.execute(f"DELETE FROM {db}.{table};")
connector1.engine.execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

databases=pd.DataFrame({'db_name': data['PrimaryDatabase'].unique() }, 
                      columns=['db_name']
                     ).astype('str')

databases.drop_duplicates(inplace=True)
databases.index+=1

databases.to_sql('database' , if_exists='append', con=connector1.engine, index=False)


# In[ ]:





# In[18]:


# table country

table='country'
connector1.engine.execute(f"DELETE FROM {db}.{table};")
connector1.engine.execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

country=pd.DataFrame({'ctr_name': data['Country'].unique() }, 
                     columns=['ctr_name']
                        ).astype('str')

country.drop_duplicates(inplace=True)
country.index+=1

country.to_sql('country' , if_exists='append', con=connector1.engine, index=False)


# In[19]:


# table employement_sector

table='employment_sector'
connector1.engine.execute(f"DELETE FROM {db}.{table};")
connector1.engine.execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

employement_sector=pd.DataFrame({'sec_name': data['EmploymentSector'].unique() },
                               columns=['sec_name']).astype('str')
employement_sector.drop_duplicates(inplace=True)
employement_sector.index+=1

employement_sector.to_sql('employment_sector' , if_exists='append', con=connector1.engine, index=False)


# In[20]:


#insertion des données dans la table principale 



def insert_(dict_fk,df0,**kwargs) :
    
    for table in kwargs:
            print('label :',table)
            table=kwargs[table]
            print(table)
            label=table.columns[0]
            label_id=label[0:label.index('_')]+'_id'

           
          
            table=table.reset_index()
            
            
            
    
            table=table.set_index(label).rename(
                                               columns={'index':label_id})
        
            
            #print('table   \n ',table)
            df0=df0.merge(table, right_index=True, left_on=dict_fk[label_id])
            
    df0.index=np.arange(1,df0.shape[0]+1)
    #df0.to_csv('essai.csv')
    return df0

        


# ## Table sondage_item
# 
# ###  formatage des colonnes

# In[21]:


sondage_item=data.astype('str')

sondage_item_fk={'sdg_id':'Survey Year', 'ctr_id':'Country',
          'db_id':'PrimaryDatabase', 'emp_id':'EmploymentStatus',
         'job_id':'JobTitle', 'mcp_id':'HowManyCompanies', 'edu_id':'Education',
          'cert_id':'Certifications','pop_id':'PopulationOfLargestCityWithin20Miles',
          'sec_id':'EmploymentSector', 'look_id':'LookingForAnotherJob', 
          'cap_id':'CareerPlansThisYear', 
         }

sondage_item=insert_( 
        dict_fk=sondage_item_fk, 
        df0=sondage_item,
        df1=sondage,
        df2=employement_sector, 
        df4=employment_status, df5=databases, df6=looking_job,
        df7=education, df8=how_many_companies, df9=largest_city, df10=carreer_plan, 
        df11=certification, df12=jobs, df13=country)


#création des primary key des sondages de la table sondage_item : sdg_id

sondage_item['sgi_id']=sondage_item.index

##

sondage_item.replace(regex='Yes', value=1, inplace=True)
sondage_item.replace(regex=r'[No|nan]', value=0, inplace=True)

#création d'une colonne "Gender", répertoriant de manière modulo 2 valeurs alternatives:'male' / 'female'

sondage_item['Gender']=sondage_item['Gender'].apply(lambda x:'male' if x=='0' else 'female')
sondage_item['Timestamp']=pd.to_datetime(sondage_item['Timestamp'])

#harmonisation des valeurs du nombre d'employés répertoriés dans la colonne 
# "CompanyEmployeesOverall"

for fourchette in re.findall(r'\d+-\d+', 
                             str(sondage_item['CompanyEmployeesOverall'].unique()) ):
    
    min_, max_=fourchette.split('-')
    mean_=round((int(min_)+int(max_))/2)
    sondage_item.replace(fourchette, mean_, inplace=True)


# In[22]:


columns=['Survey Year', 'Timestamp', 'SalaryUSD', 'PostalCode', 'YearsWithThisDatabase',
        'ManageStaff','YearsWithThisTypeOfJob','OtherPeopleOnYourTeam','CompanyEmployeesOverall',
         'DatabaseServers','EducationIsComputerRelated','HoursWorkedPerWeek',
         'TelecommuteDaysPerWeek','NewestVersionInProduction','OldestVersionInProduction',
         'Gender', 'sgi_id']

news_names_columns={'Survey Year' : 'survey_year', 'SalaryUSD' : 'salary_usd', 
        'PostalCode': 'postal_code', 'YearsWithThisDatabase':'years_with_db',
        'ManageStaff':'manage_staff', 'YearsWithThisTypeOfJob':'years_with_job', 
        'OtherPeopleOnYourTeam':'other_people', 'CompanyEmployeesOverall':'company_employee',
              'DatabaseServers':'database_servers', 'EducationIsComputerRelated':'education_computer',
              'HoursWorkedPerWeek':'hours_worked', 'TelecommuteDaysPerWeek':'telecommute',
              'NewestVersionInProduction':'newest_version', 
              'OldestVersionInProduction':'oldest_version'
                    }

news_columns=list(news_names_columns.values() ) + list( sondage_item_fk.keys())+['Timestamp'] 
sondage_item.rename(columns=news_names_columns, inplace=True)


# In[23]:


sondage_item


# ### exportation de la table "sondage_item" vers la base SQL

# In[ ]:


table='sondage_item'
connector1.engine.execute(f"DELETE FROM {db}.{table};")
connector1.engine.execute(f"ALTER TABLE {db}.{table} AUTO_INCREMENT=0;")

sondage_item[news_columns].to_sql('sondage_item', con=connector1.engine, if_exists='append',
                             index=False
                            )


# # Création des tables d'associations

# ### table task_performed

# In[24]:


data=pd.read_excel(path).replace(np.nan, 'nan')


# In[25]:


#table task_performed

table_association=[]
#production du champ de combinaisons possibles de toutes les id de sondages avec chaque type de tâche
for task_ in task['tas_name'].unique():
    pattern=re.compile(f'.*{task_}.*')
    mask=data['KindsOfTasksPerformed'].str.match(pat=pattern)
    table_association.extend([(i,task_) for i in data[mask].index.astype('str')])

task_performed=pd.DataFrame({'sgi_id':[sgi_id[0] for sgi_id in table_association ],
                            'tas_name': [sgi_id[1] for sgi_id in table_association]
                            }
                            ) 

task_performed=task_performed.merge(task.reset_index(), on= 'tas_name')
task_performed=task_performed.rename(columns={'index':'tas_id'})

# harmonisation des id des tâches de la table "task performed" avec les
# indices présents sur SQL

task_performed['tas_id']+=1

table='task_performed'
connector1.engine.execute(f'DELETE FROM {db}.{table} ;')
connector1.engine.execute(f'ALTER TABLE {db}.{table} AUTO_INCREMENT=0 ;')

task_performed[['sgi_id','tas_id']].to_sql('task_performed', 
                      con=connector1.engine, 
                      if_exists='append',
                     index=False
                     )


# In[26]:


table_association=[]

# faut obtenir la liste de toutes les mentions de métier, ce de manière unique
for job_ in data['OtherJobDuties'].unique():

# on exclue toute intitulé type '' de job :
    if job_!='':
        pattern=re.compile(f'.*{job_}.*')
        mask=data['OtherJobDuties'].str.match(pat=pattern)
        table_association.extend([(i,job_) for i in data[mask].index.astype('str')])


table_association=pd.DataFrame(table_association,
                              columns=['sgi_id', 'job_name']) 

table_association=table_association.merge(
                                        jobs.reset_index(), 
                                        left_on='job_name',
                                        right_on='job_name'
                                    ).rename(
                                        columns={'index':'job_id'}
)


table='other_duties'
connector1.engine.execute(f'DELETE FROM {db}.{table} ;')
connector1.engine.execute(f'ALTER TABLE {db}.{table} AUTO_INCREMENT=0 ;')
table_association.drop_duplicates(inplace=True)
table_association[['job_id', 'sgi_id']].to_sql('other_duties',
                                              con=connector1.engine,
                                              if_exists='append',
                                              index=False
                                              )
        
table_association#!!


# #### table other_database

# In[27]:


databases


# In[28]:



##ressource utilisée: https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Index.item.html

other_databases=data[['OtherDatabases']]
other_databases['db_id']=3
for database in databases['db_name'].unique():
    mask=other_databases['OtherDatabases'].str.contains(database)
    other_databases['db_id'][mask]=databases.loc[databases['db_name']==database].index.item()
other_databases.index+=1
other_databases=other_databases.reset_index().rename(columns={'index':'sgi_id'})


# In[29]:


table='other_database'
connector1.engine.execute(f'DELETE FROM {db}.{table} ;')
connector1.engine.execute(f'ALTER TABLE {db}.{table} AUTO_INCREMENT=0 ;')
other_databases[['sgi_id', 'db_id']].to_sql("other_database", 
                                            con=connector1.engine, 
                                            if_exists='append',
                                            index=False)


# In[30]:


sondage_item


# In[31]:


how_many_companies


# In[ ]:




