  update msfo.corsa_corrections_current cc 
set vl=0 where cc.username='{user}'
and cc.comm_simpl='Экстраполяция автоматическая';

merge into msfo.corsa_corrections_current cc
using (select ca.*
, rd.reportid as reportid_new 
from msfo.corsa_corrections_actual ca 
join msfo.corsa_reportdates rd on rd.reportid_prev=ca.reportid) cao
on cao.reportid_new=cc.reportid and upper(cao.entrylinecode)=upper(cc.entrylinecode)
  and cc.comm_simpl='Экстраполяция автоматическая' and cc.username='{user}' 
when matched then update
  set vl=coalesce(cao.vl* (case when cc.reportid like '%01' then 1/12 else cast(substr(cc.reportid,-2,2) as numeric)/(cast(substr(cc.reportid,-2,2) as numeric)-1) end ),0);


merge into msfo.corsa_corrections_current cc
using
  (
  select
    cc.entrylinecode, 
    round(cc.vl)-cc.vl as drnd, 
    ccs.drnd_sum, rank()over (partition by cc.entrycode order by abs(vl) desc) as rnk
  from (select * from msfo.corsa_corrections_current where username='{user}' and comm_simpl='Экстраполяция автоматическая') cc
  join (select entrycode, sum(round(vl)-vl) as drnd_sum from msfo.corsa_corrections_current 
		where username='{user}' and comm_simpl='Экстраполяция автоматическая' group by entrycode) ccs
  on ccs.entrycode=cc.entrycode
  ) ccd
on (upper(ccd.entrylinecode)=upper(cc.entrylinecode))
when matched then update
     set vl=round(cc.vl+ccd.drnd+(case when rnk=1 then -drnd_sum else 0 end),3)
;
