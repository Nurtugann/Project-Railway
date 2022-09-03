import matplotlib.pyplot as plt
from kivy.lang.builder import Builder
from kivymd.app import MDApp
from kivy.uix.screenmanager import Screen,ScreenManager
from kivymd.uix.picker import MDDatePicker
import pyodbc
import random

from kivy.properties import StringProperty, BooleanProperty

class DatabaseConnection:
    def get_connection():
        cnxn1 =("Driver={SQL Server Native Client 11.0};"
                                    "Server=ALIKHAN\MSSQLSERVER05;"
                                    
                                    "Database=RAILWAY;"
                                    "Trusted_Connection=yes;")
        cnxn=pyodbc.connect(cnxn1,autocommit=True)
        cursor=cnxn.cursor()
        return cursor
    def addition_to_table_customers(login_of_customer,customer_password):
        cursor=DatabaseConnection.get_connection()
        query='SELECT TOP(1)customer_id FROM customers ORDER BY customer_id DESC'
        cursor.execute(query)
        for last_cust_id in cursor:
            customer_id=str(last_cust_id[0])
            customer_id=int(customer_id[4:])+1
            customer_id='cust'+str(customer_id)
        query="INSERT INTO Customers(customer_id,cust_login,cust_password) VALUES ('{0}','{1}','{2}')".format(customer_id,login_of_customer,customer_password)
        cursor.execute(query)
        
    def addition_to_table_passengers(full_name, age, gender):
        cursor=DatabaseConnection.get_connection()
        passenger_id='P'+str(random.randrange(1,10000000000,1))
        query="INSERT INTO passengers(passenger_id,full_name,age,gender) VALUES ('{0}','{1}','{2}','{3}')".format(passenger_id,full_name,age,gender)
        cursor.execute(query)
    def check_if_exists_in_db(column,value,additional_query):
        cursor=DatabaseConnection.get_connection()
        query="SELECT COUNT(*) FROM customers WHERE {0}='{1}' {2}".format(column,value,additional_query)
        cursor.execute(query)
        for i in cursor:
            is_existing=(int(i[0]))
        if is_existing>0:
            return True
        else:
            return False
    def check_trains_on_station(station_id):
        list_of_needed_trains=[]
        cursor=DatabaseConnection.get_connection()
        station_id_abrv=station_id[:3]
        query="SELECT train_id FROM schedules WHERE train_id LIKE '%{0}%' AND station_id_start='{1}'".format(station_id_abrv,station_id)
        cursor.execute(query)
        for i in cursor:
            list_of_needed_trains.append(str(i))
        return list_of_needed_trains
    def check_all_routes(train_id):
        list_of_needed_routes=[]
        cursor=DatabaseConnection.get_connection()
        query="SELECT * FROM schedules WHERE train_id ='{0}'".format(train_id)
        cursor.execute(query)
        for i in cursor:
            list_of_needed_routes.append(str(i))
        return list_of_needed_routes
class WinMan(ScreenManager):
    pass
class RegistrationPage(Screen):
   def do_registration(self):
       db_stuff=DatabaseConnection
       customer_login=self.ids.cust_login_reg.text
       customer_password=self.ids.cust_password_reg.text
       if db_stuff.check_if_exists_in_db('cust_login',customer_login,additional_query='')==True:
            print('Please make up new nickname {0} is occcupied'.format(customer_login))
            return False
       else:
            db_stuff.addition_to_table_customers(customer_login,customer_password)
            return True   
class EntryPage(Screen):
    def do_entry(self):
       customer_login=self.ids.cust_login.text
       customer_password=self.ids.cust_password.text
       check_if_exist=DatabaseConnection.check_if_exists_in_db('cust_login',customer_login,additional_query="AND cust_password='{0}'".format(customer_password))
       
       if check_if_exist==True:
            return True
       else:
            return False
        

class RailWaySystemPage(Screen):
    def show_calendar(self):
        date_dialog=MDDatePicker()
        date_dialog.open()
    
    
class ListOfStatistics(Screen):
    def show_statistics(self,what_statistics):
        cursor=DatabaseConnection.get_connection()
        if what_statistics=='gender statistics':
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

            
            names = ['males', 'females']
            values = [males,females]
            colors = ['blue', 'pink']


            rects = plt.bar(names, values, color = colors, width= 0.3)
            plt.bar_label(rects)
            plt.show()
        elif what_statistics=='statistics by status':
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

            names = ['pensioner', 'student', 'child', 'adult']
            values = [pensioner,student,child,adult]
            colors = ['blue', 'pink', 'green', 'yellow']


            rects = plt.bar(names, values, color = colors, width= 0.3)
            plt.bar_label(rects)
            plt.show()
        elif what_statistics=='the most popular station':
            query="select station_id_end, count(*) from tickets group by station_id_end"
            cursor.execute(query)
            names = []
            counts = []
            for i in cursor:
                name = str(i[0])
                count = int(i[1])
                names.append(name)
                counts.append(count)
            rects = plt.bar(names, counts)
            plt.bar_label(rects)
            plt.show()
        else:
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

            rects = plt.bar(names, [withh, without], color = ['red','blue'])
            plt.bar_label(rects)
            plt.show()
class BuyTickets(Screen):
    def find_me_all_trains(self):
        db_stuff=DatabaseConnection
        station_id_start=self.ids.station_id_start.text
        list_of_needed_trains=db_stuff.check_trains_on_station(station_id_start)
        self.ids.list_of_train.text=str(list_of_needed_trains)
class ShowAllRoutes(Screen):
    def find_me_all_routes(self):
        db_stuff=DatabaseConnection
        train_id=self.ids.train_id_target.text
        list_of_needed_routes=db_stuff.check_all_routes(train_id)
        self.ids.list_of_routes.text=str(list_of_needed_routes)
class RailWay(MDApp):
    def build(self):
        return Builder.load_file('design.kv')
if __name__ == '__main__':
    RailWay().run()