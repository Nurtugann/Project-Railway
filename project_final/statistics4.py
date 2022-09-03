from collections import deque
from datetime import date, datetime
from operator import concat
from turtle import color
import pyodbc
import random
import secrets
import time
cnxn1 = ("Driver={SQL Server Native Client 11.0};"
                            "Server=WIN-BGSHC8G6GV7;"
                            "Database=railway1;"
                            "Trusted_Connection=yes;")
cnxn=pyodbc.connect(cnxn1,autocommit=True)
cursor=cnxn.cursor()

query="select COUNT(*) from customers where customer_id in (select customer_id from discount_cards)"
cursor.execute(query)
withh = 0
for i in cursor:
    withh = int(i[0])


query="select COUNT(*) from customers where customer_id not in (select customer_id from discount_cards)"
cursor.execute(query)
without = 0
for i in cursor:
    without = int(i[0])    

names = ['with_dis_card','without_dis_card']

import matplotlib.pyplot as plt



rects = plt.bar(names, [withh, without], color = ['red','blue'])
plt.bar_label(rects)
plt.show()