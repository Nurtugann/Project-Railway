from collections import deque
from datetime import date, datetime
from operator import concat
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

query="select count(*) from passengers where gender = 'male'"
cursor.execute(query)
males = 0
for i in cursor:
    males = int(str(i[0]))

query="select count(*) from passengers where gender = 'female'"
cursor.execute(query)
females = 0
for i in cursor:
    females = int(str(i[0]))

print(males,females)

import matplotlib.pyplot as plt
names = ['males', 'females']
values = [males,females]
colors = ['blue', 'pink']


rects = plt.bar(names, values, color = colors, width= 0.3)
plt.bar_label(rects)
plt.show()