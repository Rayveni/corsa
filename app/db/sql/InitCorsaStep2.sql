 insert into msfo.CORSA_CORRECTIONS
select  * from msfo.CORSA_CURRENT_PLUS_ADDEDNULL 
where UserName='{user}';

delete from msfo.CORSA_segments where reportid='{report_id}' and UserName = '{user}';

INSERT INTO msfo.CORSA_Segments 
SELECT sc.ReportID, EntryLineCode, UserName, SEG15 || Cur, VL*VL_RATIO, sc.Ratio_name 
       FROM msfo.CORSA_Segments_Current sc 
        INNER JOIN 
        (select * from msfo.CORSA_Segments_rates 
        union all 
         select reportid, '_', null, 1 from msfo.CORSA_Segments_rates group by reportid)  sr 
        ON upper(sc.Ratio_name) = upper(sr.Ratio_name) AND sc.ReportID = sr.ReportID 
        where UserName='{user}';

insert into msfo.Corsa_ENTRYLINECODES
select distinct upper(ENTRYLINECODE), upper(ENTRYCODE), sessiontime from msfo.Corsa_CORRECTIONS_CURRENT
where upper(ENTRYLINECODE) not in (select ENTRYLINECODE from msfo.Corsa_ENTRYLINECODES)
;
MERGE INTO msfo.CORSA_ENTRYCODES ec
USING
    (SELECT ENTRYCODE, corrname_l, sessiontime FROM
      (      
      SELECT ENTRYCODE, corrname_l, sessiontime, rank() over (PARTITION BY ENTRYCODE ORDER BY vl_seg_min) AS rnk
      FROM 
             (SELECT upper(ENTRYCODE) AS ENTRYCODE, corrname_l, sessiontime, MIN(vl_seg) AS vl_seg_min
             FROM msfo.Corsa_CORRECTIONS_CURRENT
             WHERE corrname_l IS NOT NULL AND (REPLACE(REPLACE(REPLACE(REPLACE(corrname_l,'.',null),',',null),'-',null),' ',null) ~ '^\d+(\.\d+)?$')is not true
             GROUP BY upper(ENTRYCODE), corrname_l, sessiontime
             ) tt
       ) ttt
    WHERE rnk=1         
    ) ecn
ON (ecn.ENTRYCODE = ec.ENTRYCODE AND upper(ecn.corrname_l)=upper(ec.corrname) AND ec.timeto=DATE'2999-12-31')
WHEN NOT MATCHED THEN INSERT VALUES (ecn.entrycode, ecn.corrname_l, ecn.sessiontime, DATE'2999-12-31')
; 

MERGE INTO msfo.CORSA_ENTRYCODES ec
USING
      (SELECT entrycode, MAX(timefrom) AS timefrom FROM msfo.CORSA_ENTRYCODES GROUP BY entrycode) t
ON (ec.entrycode = t.entrycode)
and  ec.timefrom <> t.timefrom AND ec.timeto=  DATE'2999-12-31' 
WHEN MATCHED THEN UPDATE
     SET timeto = t.timefrom 
;  