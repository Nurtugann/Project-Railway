from collections import deque
from datetime import date, datetime
from operator import concat
import pyodbc
import random
import secrets
import time
cnxn1 = ("Driver={SQL Server Native Client 11.0};"
                            "Server=WIN-BGSHC8G6GV7;"
                            "Database=railway3;"
                            "Trusted_Connection=yes;")
cnxn=pyodbc.connect(cnxn1,autocommit=True)
cursor=cnxn.cursor()
list_of_cities=['Aktau','Qyzylorda','Shymkent','Almaty','Astana','Aqtobe','Atyrau']
list_of_city_id=['ALA','QYZ','SHYM','AST','ATA','AQT','ATY']


list_of_trains=['Earth','Mercury','Venus','Jupiter','Saturn','Neptune','Additional']

#for customers
list_of_random_male_names=['Larry ',
'Derrick ',
'Joe ',
'Joshua ',
'William ',
'Paul ',
'Daniel ',
'Kevin ']
list_of_random_female_names=['Rachel',
'Kim ',
'Rita ',
'Vickie ',
'Virginia ',
'Maxine ',
'Angela ',
'Nora ']

list_of_random_surnames=['Dickson','Mccann','Lowery','Bateman','Jacobs','Serrano','Lovell','Mcnally']

    

#for discount_cards
'''for i in range(10):
    customer_id=concat('S',str(1000000+i))
    card_id=concat('Card',str(10000000+i))
    number_of_trips=random.randrange(0,20)
    year=random.randrange(2020,2023,1)
    month=random.randrange(1,12,1)
    if month==2:
        day=random.randrange(1,28)
    else:
        day=random.randrange(1,31)
    start_date=datetime.datetime(year,month,day)
    end_date=datetime.datetime(year+2,month,day)
    query="INSERT INTO discount_cards(card_id,customer_id,number_of_trips,start_date,end_date) VALUES ('{0}','{1}',{2},'{3}','{4}')".format(card_id,customer_id,number_of_trips,start_date,end_date)
    cursor.execute(query)'''
def fill_trains_table():
    for i in range(len(list_of_cities)):
        for j in range(len(list_of_trains)):
            is_full_train='not full'
            train_name=list_of_trains[i]
            train_id=concat('T'+train_name[:1]+list_of_city_id[i],str(10+j+1))
            train_name=concat(list_of_trains[j]+'-',list_of_city_id[i])
            query="INSERT INTO trains(train_id,train_name,is_full_train) VALUES ('{0}','{1}','{2}')".format(train_id,train_name,is_full_train)
            cursor.execute(query)
def fill_stations_table():
    for i in range(0,len(list_of_cities)):
        station_id=concat(list_of_city_id[i],'001')
        station_name=concat(list_of_cities[i],'-1')
        query="INSERT INTO stations(station_id,station_name) VALUES ('{0}','{1}')".format(station_id,station_name)
        cursor.execute(query)
def fill_carriage_table():
    for i in range(len(list_of_cities)):
        for k in range(len(list_of_trains)):
            for j in range(10):
                is_full_carriage='not full'
                train_name=list_of_trains[i]
                city_name=list_of_city_id[i]
                train_id_fk=concat('T'+train_name[:1]+list_of_city_id[i],str(10+k+1))
                carriage_number=j+1
                carriage_id=concat('CRG'+train_name[:1]+list_of_city_id[i],str(100+j+1)+str(100+k+1))
                class_name=random.randrange(0,2,1)
                if class_name==1:
                    class_name='VIP class'
                else:
                    class_name='ussual class'
                is_it_women_carriage=random.randrange(0,2,1)
                if is_it_women_carriage==1:
                    is_it_women_carriage=='true'
                else:
                    is_it_women_carriage=='false'
                query="INSERT INTO cariages(train_id,carriage_id,carriage_number,class, is_it_for_women,is_full_carriage) VALUES ('{0}','{1}',{2},'{3}','{4}','{5}')".format(train_id_fk,carriage_id,carriage_number,class_name,is_it_women_carriage,is_full_carriage)
                cursor.execute(query)
def fill_coupe_table():
    for i in range(len(list_of_cities)):
        for k in range(len(list_of_trains)):
            for j in range(10):
                for h in range(5):
                    is_full_coupe='not full'
                    train_name=list_of_trains[i]
                    city_name=list_of_city_id[i]
                    carriage_id_fk=concat('CRG'+train_name[:1]+list_of_city_id[i],str(100+j+1)+str(100+k+1))
                    coupe_id=concat('CP'+train_name[:1]+list_of_city_id[i],str(100+j+1)+str(100+k+1)+str(1000+h+1))
                    coupe_number=h
                    query="INSERT INTO coupes(carriage_id,coupe_id,coupe_number,is_full_coupe) VALUES ('{0}','{1}',{2},'{3}')".format(carriage_id_fk,coupe_id,coupe_number,is_full_coupe)
                    cursor.execute(query)
def fill_seat_table():
    for i in range(len(list_of_cities)):
        for k in range(len(list_of_trains)):
            for j in range(10):
                for h in range(5):
                    for l in range(4):
                        train_name=list_of_trains[i]
                        city_name=list_of_city_id[i]
                        seat_id=concat('CP'+train_name[:1]+list_of_city_id[i],str(100+j+1)+str(100+k+1)+str(1000+h+1)+str(10000+l+1))
                        coupe_id_fk=concat('CP'+train_name[:1]+list_of_city_id[i],str(100+j+1)+str(100+k+1)+str(1000+h+1))
                        seat_number=l
                        status='free'
                        query="INSERT INTO seats(coupe_id,seat_id,seat_number,status) VALUES ('{0}','{1}',{2},'{3}')".format(coupe_id_fk,seat_id,seat_number,status)
                        cursor.execute(query)
#for tickets
def fill_tickets_table(number_of_customers):
   for i in range(number_of_customers):
        customer_id=concat('cust',str(1000000+i))
        randomly_discountc_owner=random.randrange(0,2,1)
        gender_decide=random.randrange(0,2,1)
        full_name_cust=if_gender_is(gender_decide)
        login_of_customer=generate_nickname(full_name_cust)
        password_of_customer=generate_random_password()
        query="INSERT INTO Customers(customer_id,cust_login,cust_password) VALUES ('{0}','{1}','{2}')".format(customer_id,login_of_customer,password_of_customer)
        cursor.execute(query)
        rand_row_train_table=random.randrange(1,49,1)
        random_num_of_trips=random.randrange(1,21,1)
        if randomly_discountc_owner==1:
                card_id=concat('card',str(10000000+i))
                year=random.randrange(2020,2023,1)
                month=random.randrange(1,12,1)
                if month==2:
                    day=random.randrange(1,28)
                else:
                    day=random.randrange(1,31)
                start_date=date(year,month,day)
                end_date=date(year+2,month,day)
                query="INSERT INTO discount_cards(card_id,customer_id,number_of_trips,start_date,end_date) VALUES ('{0}','{1}',{2},'{3}','{4}')".format(card_id,customer_id,random_num_of_trips,start_date,end_date)
                cursor.execute(query)
        query='SELECT train_id FROM (SELECT ROW_NUMBER() OVER(ORDER BY train_id) row_num,* FROM trains) AS TMP_TABLE WHERE row_num={0}'.format(rand_row_train_table)
        cursor.execute(query)
        for train_id_el in cursor:
            train_target_id=(str(train_id_el[0]))
        query="SELECT station_id_start FROM (SELECT ROW_NUMBER() OVER(ORDER BY train_id) row_num, station_id_start FROM schedules WHERE train_id='{0}') AS TMP_TABLE WHERE row_num={1}".format(train_target_id,1)
        cursor.execute(query)
        for station_id_start_el in cursor:
            station_id_start_target=(str(station_id_start_el[0]))
        query="SELECT station_id_end FROM(SELECT ROW_NUMBER() OVER(ORDER BY train_id) row_num, station_id_end FROM schedules WHERE train_id='{0}') AS TMP_TABLE WHERE row_num={1}".format(train_target_id,random.randrange(2,8,1))
        cursor.execute(query)
        for station_id_end_el in cursor:
           station_id_end_target=(str(station_id_end_el[0]))
        for j in range(random.randrange(1,4,1)):
            ticket_id='ticket'+str(random.randrange(1,10000000000,1))
            passenger_id=concat('P',str(random.randrange(1,10000000000,1)))
            age=random.randrange(0,110)
            gender_ruler=random.randrange(0,2,1)
            class_carriage=random.randrange(0,2,1)
            if class_carriage==0:
                class_carriage='ussual class'
            else:
                class_carriage='VIP class'
            full_name=if_gender_is(gender_ruler)
            if gender_ruler==1:
                gender='female'
            else:
                gender='male'
            if gender=='male':
                woman_carriage=0
            else:
                woman_carriage=random.randrange(0,2,1)
            pass
            query="INSERT INTO passengers(passenger_id,full_name,age,gender) VALUES ('{0}','{1}','{2}','{3}')".format(passenger_id,full_name,age,gender)
            cursor.execute(query)
            query="INSERT INTO tickets(ticket_id,passenger_id,customer_id,initial_cost_of_ticket,final_cost_of_ticket,woman_carriage,carriage_class,train_id,station_id_start,station_id_end) VALUES ('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}')".format(ticket_id,passenger_id,customer_id,0,0,woman_carriage,class_carriage,train_target_id,station_id_start_target,station_id_end_target)
            cursor.execute(query)

            
                

def generate_nickname(cust_name):
    surname=str(cust_name).split()
    nickname=str(cust_name[0]+'.'+surname[1]+str(random.randrange(1,999))).lower()
    return nickname
def generate_random_password():
    random_password=secrets.token_urlsafe(10)
    return random_password

def if_gender_is(gender_ruler):
    if gender_ruler==1:
        full_name=concat(list_of_random_female_names[random.randrange(1,7,1)],list_of_random_surnames[random.randrange(1,7,1)])
    else:
        full_name=concat(list_of_random_male_names[random.randrange(1,7,1)],list_of_random_surnames[random.randrange(1,7,1)])
    return full_name

#for schedules

def schedule_for_trains(s_id_start,s_id_end,t_id,time_in,time_out,date_in,date_out,distance_between_stations):
    query="INSERT INTO schedules(station_id_start,station_id_end,train_id,time_in,time_out,date_in,date_out,distance_between_stations) VALUES ('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}')".format(s_id_start,s_id_end,t_id,time_in,time_out,date_in,date_out,distance_between_stations)
    cursor.execute(query)
def schedules(station_id_start,station_id_end,date_in,date_out):
   pass
def main_schedule(list_of_city_id,list_of_trains):
    for i in range(len(list_of_cities)):
        day_in=date.today().day 
        month=date.today().month
        dq=deque(list_of_city_id)
        dq.rotate(-i)
        dq_for_train_name=deque(list_of_trains)
        dq_for_train_name.rotate(-i)
        list_of_trains_deque=list(dq_for_train_name)
        list_of_city_id_deque=list(dq)
        for j in range(len(list_of_cities)):
            day_in=day_in+j
            for k in range(7):
                minutes=random.randrange(0,60,1)
                train_name=list_of_trains_deque[i]
                station_id_start=list_of_city_id_deque[j]+'001'
                if j!=len(list_of_cities)-1:
                    station_id_end=list_of_city_id_deque[j+1]+'001'
                else:
                    station_id_end=list_of_city_id_deque[0]+'001'
                train_id=concat('T'+train_name[:1]+list_of_city_id_deque[i],str(10+k+1))
                time_in='{0}:{1}:00.6170000'.format(j*3,minutes)
                time_out='{0}:{1}:00.6170000'.format(j*3+3,minutes)
                year=time.ctime()
                c_year=int(year[-4:])
                if month>11:
                    month=1
                    c_year+=1
                if day_in>30:
                    month+=1
                    day_in=day_in-30
                date_in=date(c_year,month,day_in)
                day_out=day_in+j
                if day_out>30:
                    month+=1
                    day_out=day_out-30
                
                date_out=date(c_year,month,day_out)
                #c_year+'-'+'0'+str(month)+'-'+str(day_out)
               
                schedule_for_trains(station_id_start,station_id_end,train_id,time_in,time_out,date_in,date_out,random.randrange(2500,5000,218))
                
fill_stations_table()
fill_trains_table()
fill_carriage_table()
fill_coupe_table()
fill_seat_table()
main_schedule(list_of_city_id,list_of_trains)
fill_tickets_table(1000)



#if all straight routes are busy, suggest some alternatives 