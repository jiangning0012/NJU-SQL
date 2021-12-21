from pymysql import connect
import pymysql.cursors

connection=pymysql.connect(host='localhost',port=3306,user='root',password='6261123jiangN',
db='OrderDB',charset='utf8mb4',cursorclass=pymysql.cursors.DictCursor)

try:
    cursor=connection.cursor()
    sql='''
    select c.customerName,c.address,c.telephone
    from Customer c;
    '''
    cursor.execute(sql)
    result=cursor.fetchone()
    tplt="{0:{3}<10}\t{1:{3}<4}\t{2:{3}<12}"
    print(tplt.format("客户名称","客户地址","客户电话",chr(12288)))
    print(tplt.format(result['customerName'],result['address'],
    result['telephone'],chr(12288)))
    while result:
        print(tplt.format(result['customerName'],result['address'],
        result['telephone'],chr(12288)))
        result=cursor.fetchone()
except Exception:print("error!")

cursor.close()
connection.close()

