----update full_edges set ["reciever"]  = replace(["reciever"] , '"','')

select sourcetype, count(*)
from
(
	select [ "sender"] as source, n1.status as sourcetype, ["reciever"] as target, n2.status as targettype,sum(cast(["count"] as int)) as amt
	from [dbo].[full_edges] e
		 join full_nodes n1 on e.[ "sender"] = n1.[Email_id]
		 join full_nodes n2 on e.["reciever"] = n2.[Email_id]
	group by [ "sender"], n1.status ,["reciever"], n2.status
--	order by amt desc
) 
X 
where amt>50
group by sourcetype 
order by count(*)

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



