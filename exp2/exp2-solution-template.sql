-- 姓名：XXX
-- 学号：XXX
-- 提交前请确保本次实验独立完成，若有参考请注明并致谢。

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1.1
delimiter //
drop procedure if exists product_info //
create procedure product_info(in productName varchar(40))
begin
	select om.customerNo,c.customerName,om.orderNo,od.quantity,od.quantity*od.price as totalPrice
	from OrderMaster om,OrderDetail od,Customer c,Product p
	where om.orderNo=od.orderNo and om.customerNo=c.customerNo
		and od.productNo=p.productNo and p.productName=productName
	order by (od.quantity*od.price) desc;
end //
delimiter ;
call product_info("32M DRAM");
-- END Q1.1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1.2
delimiter //
drop procedure if exists earlier_employee_info //
create procedure earlier_employee_info(in employeeNo char(8)) 
begin
	select e1.employeeNo,e1.employeeName,e1.gender,e1.hireDate,e1.department
    from Employee e1,(select e2.hireDate,e2.department from Employee e2 where e2.employeeNo=employeeNo) as newtable
    where e1.hireDate<newtable.hireDate and e1.department=newtable.department;
end //
delimiter ;
call earlier_employee_info("E2008005");
-- END Q1.2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2.1
delimiter //
drop function if exists average_product //
create function average_product(productName varchar(40)) 
	returns numeric(7,2) DETERMINISTIC
begin
	declare average numeric(7,2);
	select sum(newtable._sum)/sum(newtable._count) into average
    from (
		select p.productName as productName,od.quantity*od.price as _sum,od.quantity as _count
		from Product p,OrderDetail od
		where p.productName=productName and p.productNo=od.productNo
        ) as newtable;
	return average;
end //
delimiter ;
select distinct p.productName as productName,average_product(p.productName) as average
from Product p;

-- END Q2.1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2.2
delimiter //
drop function if exists quantity_product //
create function quantity_product(productNo char(9)) 
	returns int DETERMINISTIC
begin
	declare res int;
    select sum(od.quantity) into res
    from OrderDetail od
    where od.productNo=productNo;
    return res;
end //
delimiter ;
select p.productNo as productNo,p.productName as productName,
	quantity_product(p.productNo) as quantity
from Product p
where quantity_product(p.productNo)>4;

-- END Q2.2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3.1
/*
delimiter //
drop trigger if exists check_price //
create trigger check_price before insert on Product
for each row
begin
	if new.productPrice>1000 then set new.productPrice=1000;
    end if ;
end //
delimiter ;
*/
-- END Q3.1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3.2
/*
delimiter //
drop trigger if exists add_salary //
create trigger add_salary after insert on OrderMaster
for each row
begin
	update Employee e set e.salary=e.salary*1.05
    where e.hireDate>='19920101' and e.employeeNo=new.employeeNo;
    update Employee e set e.salary=e.salary*1.08
    where e.hireDate<'19920101' and e.employeeNo=new.employeeNo;
end //
delimiter ;
*/
-- END Q3.2

