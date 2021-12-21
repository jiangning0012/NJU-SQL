from pymysql import connect
import pymysql.cursors

connection=pymysql.connect(host='localhost',port=3306,user='root',password='6261123jiangN',
db='OrderDB',charset='utf8mb4',cursorclass=pymysql.cursors.DictCursor)

try:
    cursor=connection.cursor()

    sql='''
    delete from Employee e
    where e.salary>5000;
    '''
    cursor.execute(sql)
    sql='''
    select e.employeeNo,e.employeeName,e.salary 
    from Employee e;
    '''
    cursor.execute(sql)
    result=cursor.fetchall()
    for data in result:
        print(data)
except Exception:print("error!")

cursor.close()
connection.close()

