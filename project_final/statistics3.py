from collections import deque
from datetime import date, datetime
from operator import concat
import pyodbc
import random
import secrets
import time
cnxn1 = ("Driver={SQL Server Native Client 11.0};"
                            "Server=WIN-BGSHC8G6GV7;"
                            "Database=railway2;"
                            "Trusted_Connection=yes;")
cnxn=pyodbc.connect(cnxn1,autocommit=True)
cursor=cnxn.cursor()

query="select station_id_end, count(*) from tickets group by station_id_end"
cursor.execute(query)
names = []
counts = []
for i in cursor:
    name = str(i[0])
    count = int(i[1])
    names.append(name)
    counts.append(count)


import matplotlib.pyplot as plt



rects = plt.bar(names, counts)
plt.bar_label(rects)
plt.show()