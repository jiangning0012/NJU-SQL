from pymysql import connect
import pymysql.cursors

connection=pymysql.connect(host='localhost',port=3306,user='root',password='XXXXXXXXXXXXX',
db='OrderDB',charset='utf8mb4',cursorclass=pymysql.cursors.DictCursor)

try:
    cursor=connection.cursor()
    sql='''
    insert Customer values(
        'C20080002','泰康股份有限公司',  '010-5422685',  '天津市', '220501'
        );
    '''
    cursor.execute(sql)
    sql='''
        select * from Customer;
    '''
    cursor.execute(sql)
    result=cursor.fetchall()
    for data in result:
        print(data)
except Exception:print("error!")

cursor.close()
connection.close()