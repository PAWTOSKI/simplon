#!/usr/bin/env python
# coding: utf-8

# In[1]:





# In[ ]:





# In[ ]:


a,B=1,2
print(a,B)


# In[18]:


a=123.5
b=int(a)
print(b)
print(type(b))


# In[19]:


a, b=7, 3.14
c=str(a)
d=str(b)

print(type(c), type (d))
print(c,d)


# In[21]:


A=B=True
C=D=False
print((A or B) or (C or D))
print((A) or  (B and C))
print(A and B and (C or D))
print((A and B) or (not C))
print((not A) or D)


# In[22]:


print(abs(-3) + max(2,3))
print(min(4, 8, 0, -2))
print(( min(7,8) + max(4,6) ))
print(round(8.89)+round(6,3))
print(round(7.65))


# In[61]:


from math import *

a=3
b=-7
c=-23
d=((b**2)-(4*a*c))
coefficient1=(-b-d**0.5)/(2*a)
coefficient2=(-b+d**0.5)/(2*a)

print(d)


# In[62]:


rayon=int(input('veuillez saisir le rayon désirée: '))
hauteur=int(input('veuillez saisir la hauteur désirée: '))
volume=(rayon**2)*pi*hauteur/3
volume


# In[ ]:





# In[ ]:





# In[ ]:




