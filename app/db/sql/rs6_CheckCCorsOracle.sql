  select DISTINCT cc.entrycode, c.UserName 
FROM msfo.CORSA_CORRECTIONS_CURRENT cc 
   INNER JOIN 
(select distinct c.reportid, c.entrycode, c.UserName from msfo.CORSA_CORRECTIONS c 
    INNER JOIN msfo.CORSA_log l ON l.load_id=c.load_id 
    where l.actual_man=1 AND c.addednull=0 
    Union all 
    select distinct reportid, entrycode, UserName from msfo.CORSA_CORRECTIONS_current
    ) c 
    ON c.reportid=cc.reportid
	AND upper(c.entrycode)=upper(cc.entrycode) 
	AND c.UserName <>cc.UserName 
    WHERE cc.UserName=$1;