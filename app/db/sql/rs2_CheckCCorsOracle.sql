  SELECT max(EntryCode) as EntryCode
     ,sum(vl) as Sum_VL 
FROM msfo.CORSA_corrections_current
where UserName=$1
GROUP BY upper(EntryCode) HAVING sum(vl)<>0 ;