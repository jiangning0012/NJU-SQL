from pymysql import connect
import pymysql.cursors

connection=pymysql.connect(host='localhost',port=3306,user='root',password='6261123jiangN',
db='OrderDB',charset='utf8mb4',cursorclass=pymysql.cursors.DictCursor)

try:
    cursor=connection.cursor()
    # sql='select e.employeeNo as employeeNo,e.employeeName as employeeName, e.salary as salary \
    #     from Employee e \
    #     order by e.salary;'
    sql='''
    select new_table.employeeNo as employeeNo,
	    new_table.employeeName as employeeName,
        new_table.salary as salary,
        new_table.rownum as rownum
    from (
        select ee.employeeNo,ee.employeeName,ee.salary,
            @rownum:=@rownum+1 as num_temp,
            @incnum:=case
            when @nowsal=ee.salary then @incnum
            when @nowsal:=ee.salary then @rownum
            end as rownum
        from(
                select e.employeeNo,e.employeeName,e.salary
                from Employee e
                order by e.salary desc
            ) as ee,
            (
                select @rownum:=0,@nowsal:=NULL,@incnum:=0
            ) r
        
    ) as new_table
    where new_table.rownum<=20;
    '''
    cursor.execute(sql)
    result=cursor.fetchall()
    for data in result:
        print(data)
except Exception:print("error!")

cursor.close()
connection.close()

