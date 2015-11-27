----update full_edges set ["reciever"]  = replace(["reciever"] , '"','')

select  * --sum(amt)
from
(
	select [ "sender"] as source, n1.status as sourcetype, ["reciever"] as target, n2.status as targettype,sum(cast(["count"] as int)) as amt
	from [dbo].[full_edges] e
		 join full_nodes n1 on e.[ "sender"] = n1.[Email_id]
		 join full_nodes n2 on e.["reciever"] = n2.[Email_id]
	group by [ "sender"], n1.status ,["reciever"], n2.status
	--order by amt desc
) 
X 
where source = 'sara.shackleton@enron.com' amt>50
and (sourcetype='CEO' or targettype='CEO')
order by amt desc



group by sourcetype 
order by count(*)



select * 
from full_nodes 
where email_id in
(
'mark.metts@enron.com',
'steven.elliott@enron.com',
'bill.cordes@enron.com',
'kevin.hannon@enron.com',
'kristina.mordaunt@enron.com',
'rockford.meyer@enron.com',
'jeffrey.mcmahon@enron.com',
'stanley.horton@enron.com',
'greg.piper@enron.com',
'gene.humphrey@enron.com',
'adam.umanoff@enron.com',
'jeremy.blachman@enron.com',
'marty.sunde@enron.com',
'dana.gibbs@enron.com',
'wes.colwell@enron.com',
's..muller@enron.com',
'charlene.jackson@enron.com',
'dick.westfahl@enron.com',
'rob.walls@enron.com',
'louise.kitchen@enron.com',
'jeffrey.shankman@enron.com',
'john.wodraska@enron.com',
'rick.bergsieker@enron.com',
'philippe.bibi@enron.com',
'paula.rieker@enron.com',
'sally.beck@enron.com',
'david.haug@enron.com',
'john.echols@enron.com',
'gary.hickerson@enron.com',
'richard.lewis@enron.com',
'robert.hayes@enron.com',
'danny.mccarty@enron.com',
'michael.kopper@enron.com',
'dan.leff@enron.com',
'john.lavorato@enron.com',
'david.berberian@enron.com',
'timothy.detmering@enron.com',
'ken.powers@enron.com',
'joe.gold@enron.com',
'james.bannantine@enron.com',
'richard.shapiro@enron.com',
'john.sherriff@enron.com',
'rex.shelby@enron.com',
'joseph.deffner@enron.com',
'joe.kishkill@enron.com',
'greg.whalley@enron.com',
'mike.mcconnell@enron.com',
'jim.piro@enron.com',
'david.delainey@enron.com',
'tod.lindholm@enron.com',
'kenneth.lay@enron.com',
'bob.butts@enron.com',
'cindy.olson@enron.com',
'rebecca.mcdonald@enron.com',
'george.mcclellan@enron.com',
'robert.hermann@enron.com',
'matthew.scrimshaw@enron.com',
'mark.haedicke@enron.com',
'raymond.bowen@enron.com',
'jay.fitzgerald@enron.com',
'michael.moran@enron.com',
'brian.redmond@enron.com',
'tim.belden@enron.com',
'w.duran@enron.com',
'terence.thorn@enron.com',
'andrew.fastow@enron.com',
'tracy.foy@enron.com',
'christopher.calger@enron.com',
'ken.rice@enron.com',
'vince.kaminski@enron.com',
'chip.cox@enron.com',
'jere.overdyke@enron.com',
'frank.stabler@enron.com',
'jeff.skilling@enron.com',
'jeffrey.sherrick@enron.com',
'james.prentice@enron.com',
'mark.pickering@enron.com',
'steven.kean@enron.com',
'kulvinder.fowler@enron.com',
'george.wasaff@enron.com',
'thomas.white@enron.com',
'diomedes.christodoulou@enron.com',
'phillip.allen@enron.com',
'vicki.sharp@enron.com',
'michael.brown@enron.com',
'james.hughes@enron.com',
'richard.dimichele@enron.com',
'sanjay.bhatnagar@enron.com',
'rebecca.carter@enron.com',
'john.buchanan@enron.com',
'julia.murray@enron.com',
'kevin.garland@enron.com',
'keith.dodson@enron.com',
'scott.yeager@enron.com',
'joe.hirko@enron.com',
'janet.dietrich@enron.com',
'james.derrick@enron.com',
'mark.frevert@enron.com',
'lou.pai@enron.com',
'frank.bay@enron.com',
'rod.hayslett@enron.com',
'jim.fallon@enron.com',
'mark.koenig@enron.com',
'larry.izzo@enron.com',
'elizabeth.tilney@enron.com',
'a..martin@enron.com',
'rick.buy@enron.com',
'richard.causey@enron.com',
'mitchell.taylor@enron.com',
'jeff.donahue@enron.com',
'ben.glisan@enron.com')



select max(["date"]) from [dbo].[full_edges] e


2002-06-21


alter view vwedges
as



select source, target, '{"source":'+ CAST(source AS VARCHAR(10))+',"target":'+CAST(target AS VARCHAR(10))+',"value":'+ CAST(value AS VARCHAR(10))+'},'  as txt
from
(
	select n1.Id -1 as source, n2.id -1 as target,sum(cast(["count"] as int)) as value
	from [dbo].[full_edges] e
		 join full_nodes n1 on e.[ "sender"] = n1.[Email_id]
		 join full_nodes n2 on e.["reciever"] = n2.[Email_id]	
	group by n1.id, n2.id
	
	--order by value desc
)
X



where value>=100


--nodes
select id-1, '{"name":"'+email_id+'","group":"'+ case when status ='N/A' then 'none' else status end+'"},' from full_nodes 
where  id-1 in
(
	select distinct source from vwedges
	union
	select distinct target from vwedges
)
order by id




select  status, count(*)
from [dbo].full_nodes 
group by status
order by 2

select  * from [dbo].full_nodes 
where email_id like '%heard%'
order by status





select * from [full_edges]
where [ "sender"] = 'marie.heard@enron.com'



select * 
from vwedges
where source = 0 and target = 114




select *
from [dbo].[full_edges] e









select n1.Id  as source, n2.id as target,sum(cast(["count"] as int)) as value
from [dbo].[full_edges] e
		join full_nodes n1 on e.[ "sender"] = n1.[Email_id]
		join full_nodes n2 on e.["reciever"] = n2.[Email_id]	
group by n1.id, n2.id
UNION
select n2.id as source, n1.Id  as target,sum(cast(["count"] as int)) as value
from [dbo].[full_edges] e
		join full_nodes n1 on e.[ "sender"] = n1.[Email_id]
		join full_nodes n2 on e.["reciever"] = n2.[Email_id]	
group by n1.id, n2.id



