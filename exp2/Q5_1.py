from pymysql import connect
import pymysql.cursors

connection=pymysql.connect(host='localhost',port=3306,user='root',password='6261123jiangN',
db='OrderDB',charset='utf8mb4',cursorclass=pymysql.cursors.DictCursor)

try:
    cursor=connection.cursor()
    department="业务科"
    sql='''
    update Employee e
    set e.salary=e.salary+200
    where e.department=%s;
    '''
    cursor.execute(sql,department)
    sql='''
    select e.employeeNo,e.employeeName,e.department,e.salary 
    from Employee e;
    '''
    cursor.execute(sql)
    result=cursor.fetchall()
    for data in result:
        print(data)
except Exception:print("error!")

cursor.close()
connection.close()

