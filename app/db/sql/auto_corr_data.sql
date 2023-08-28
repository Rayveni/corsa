  select * from (
    select 0.1 as nrow, coalesce(sum(vl),0) as sum_vl from msfo.CORSA_REPORT_IAS5 where reportid = '{report_id}' and ias5 like '4%' UNION ALL 
    select 1 as nrow, coalesce(sum(vl),0) as sum_vl from msfo.CORSA_REPORT_IAS5 where reportid = '{report_id}' and ias5 like '5%' UNION ALL 
    select 2 as nrow, coalesce(sum(vl),0) as sum_vl from msfo.CORSA_REPORT_IAS5 where reportid = '{report_id}' and ias5 like '590%' UNION ALL 
    select 3 as nrow, coalesce(sum(vl),0) as sum_vl from msfo.CORSA_REPORT_IAS5 where reportid = '{report_id}' and ias5 like '59010%' UNION ALL 
    select 4 as nrow, coalesce(sum(vl),0) as sum_vl from msfo.CORSA_REPORT_IAS5 where reportid = '{report_id}' and ias5 like '59020000%' UNION ALL 
    select 5 as nrow, coalesce(sum(vl),0) as sum_vl from msfo.CORSA_REPORT_IAS5 where reportid = '{report_id}' and ias5 like '11110200%' UNION ALL 
    select 6 as nrow, coalesce(sum(vl),0) as sum_vl from msfo.CORSA_REPORT_IAS5 where reportid = '{report_id}' and ias5 like '21110200%' UNION ALL 
    select 7 as nrow, coalesce(sum(vl),0) as sum_vl from msfo.CORSA_REPORT_IAS5 where reportid = '{report_id}' and ias5 like '11110100%' UNION ALL 
    select 8 as nrow, coalesce(sum(vl),0) as sum_vl from msfo.CORSA_REPORT_IAS5 where reportid = '{report_id}' and ias5 like '21110100%'
    ) t order by nrow;
