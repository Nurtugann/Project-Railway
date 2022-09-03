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

query="select count(*) from passengers where pass_status = 'pensioner'"
cursor.execute(query)
pensioner = 0
for i in cursor:
    pensioner = int(str(i[0]))

query="select count(*) from passengers where pass_status = 'student'"
cursor.execute(query)
student = 0
for i in cursor:
    student = int(str(i[0]))

query="select count(*) from passengers where pass_status = 'child'"
cursor.execute(query)
child = 0
for i in cursor:
    child = int(str(i[0]))

query="SELECT count(*) FROM passengers where isnull(pass_status,0) = '0'"
cursor.execute(query)
adult = 0
for i in cursor:
    adult = int(str(i[0]))    


import matplotlib.pyplot as plt
names = ['pensioner', 'student', 'child', 'adult']
values = [pensioner,student,child,adult]
colors = ['blue', 'pink', 'green', 'yellow']


rects = plt.bar(names, values, color = colors, width= 0.3)
plt.bar_label(rects)
plt.show()