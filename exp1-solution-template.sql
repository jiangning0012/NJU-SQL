-- 姓名：姜宁
-- 学号：191840116
-- 提交前请确保本次实验独立完成，若有参考请注明并致谢。

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1

select count(*) as speciesCount
from species
where description like '%this%' ;

-- END Q1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2

select p.username as username,sum(pm.power) as totalPhonemonPower
from player p,phonemon pm
where p.id=pm.player and (p.username='Cook' or p.username='Hughes')
group by p.id;

-- END Q2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3

select t.title as title,count(p.id) as numberOfPlayers
from team t,player p
where p.team=t.id
group by t.id
order by count(p.id) desc;

-- END Q3

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4

select sp.id as idSpecies,sp.title as title
from species sp,type ty
where (sp.type1=ty.id and ty.title='grass') or 
(sp.type2=ty.id and ty.title='grass');

-- END Q4

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5

select p.id as idPlayer,p.username as username
from player p
where p.id not in (
	select pc.player
    from purchase pc,item i
    where pc.item=i.id and i.type='F'
    );

-- END Q5

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6

select p.level as level,
	sum(pc.quantity*i.price) as totalAmountSpentByAllPlayersAtLevel
from player p,purchase pc,item i
where pc.item=i.id and pc.player=p.id
group by p.level
order by sum(pc.quantity*i.price) desc;

-- END Q6

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7

select newtable.item as item,newtable.title as title,
	newtable.numTimesPurchased as numTimesPurchased
from (
	select i.id as item,i.title as title,count(pc.id) as numTimesPurchased
    from item i,purchase pc
    where i.id=pc.item
    group by i.id
    ) newtable
where newtable.numTimesPurchased=ALL(
	select max(_newtable.numTimesPurchased)
    from (
		select i.id as item,i.title as title,count(pc.id) as numTimesPurchased
		from item i,purchase pc
		where i.id=pc.item
		group by i.id
		) _newtable
    );
               
-- END Q7

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8

select p.id as playerID,p.username as username,count(newtable.itemID) as numberDistinctFoodItemsPurchased
from player p,(
	select distinct i.id as itemID
    from purchase pc,item i
    where pc.item=i.id and i.type='F'
)newtable
where not exists(
	select * from item i  -- 没有被选择过的食物
	where not exists(
		select * from purchase pc where p.id=pc.player and i.id=pc.item
		) and i.type='F'
	);

-- END Q8

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9

select finaltable.numberOfPhonemonPairs as numberOfPhonemonPairs,
	finaltable.distance as distanceX
from(
	select count(newtable.distance) as numberOfPhonemonPairs,newtable.distance as distance
	from (
		select round(sqrt(power(pm1.latitude-pm2.latitude,2)+power(pm1.longitude-pm2.longitude,2))*100,4) as distance
		from phonemon pm1,phonemon pm2
		where pm1.id>pm2.id
		) newtable
	group by newtable.distance
) finaltable
where finaltable.distance=ALL(
	select min(_finaltable.distance)
    from (
		select count(newtable.distance) as numberOfPhonemonPairs,newtable.distance as distance
		from (
			select round(sqrt(power(pm1.latitude-pm2.latitude,2)+power(pm1.longitude-pm2.longitude,2))*100,4) as distance
			from phonemon pm1,phonemon pm2
			where pm1.id>pm2.id
			) newtable
		group by newtable.distance
		) _finaltable
);

-- END Q9

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10

select p.username as username,tp.title as typeTitle
from player p,type tp
where not exists(
	select * from species sp where not exists(		-- 所有没有被选择的物种
		select * from phonemon pm where pm.player=p.id and pm.species=sp.id -- and (sp.type1=tp.id or sp.type2=tp.id)
	) and (sp.type1=tp.id or sp.type2=tp.id)
);

-- END Q10