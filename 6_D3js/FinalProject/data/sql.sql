----update full_edges set ["reciever"]  = replace(["reciever"] , '"','')

--select [ "sender"] as source, n1.status as sourcetype, ["reciever"] as target, n2.status as targettype,sum(cast(["count"] as int)) as amt
--from [dbo].[full_edges] e
--	 join full_nodes n1 on e.[ "sender"] = n1.[Email_id]
--	 join full_nodes n2 on e.["reciever"] = n2.[Email_id]
--group by [ "sender"], n1.status ,["reciever"], n2.status
--order by amt desc



select * from full_edges
--nodes
select id-1, '{"name":"'+email_id+'","group":"'+ case when status ='N/A' then 'none' else status end+'"},' from full_nodes order by id


select '{"source":'+ CAST(source AS VARCHAR(10))+',"target":'+CAST(target AS VARCHAR(10))+',"value":'+ CAST(value AS VARCHAR(10))+'},' 
from
(
	select n1.Id -1  as source, n2.id -1 as target,sum(cast(["count"] as int)) as value
	from [dbo].[full_edges] e
		 join full_nodes n1 on e.[ "sender"] = n1.[Email_id]
		 join full_nodes n2 on e.["reciever"] = n2.[Email_id]
	group by n1.id, n2.id
)
X