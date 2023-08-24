  SELECT EntryLineCode,
vl,
vl-Round(vl,2) AS IsRnd 
FROM msfo.CORSA_corrections_current cc 
INNER JOIN msfo.CORSA_REPORTDATES rd ON 
cc.ReportID = rd.ReportID 
WHERE UserName=$1 and VL - Round(VL, 2) <> 0;