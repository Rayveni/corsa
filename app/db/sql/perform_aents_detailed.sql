 --CmdTxt = "CALL msfo." & ProcName & "('" & v_version_pub & "')"
/*insert into msfo.CORSA_DA_current
    select da.* from msfo.CORSA_DA
    join msfo.CORSA_DA_ENTRIES de on de.entrycode = da.entrycode
    join msfo.CORSA_REPORTDATES rd on rd.reportdate = da.dt_rep
    where proc_name = $1 and rd.reportid = $2

*/
--CmdTxt = "CALL msfo.CORSA_DA_round('" & CorsaUser & "')"  $3

 insert into msfo.CORSA_CORRECTIONS_CURRENT 
select  * from msfo.CORSA_CORRECTIONS_actual 
where reportid='{reportid}';

update msfo.CORSA_CORRECTIONS_CURRENT 
set load_id={load_id}
where UserName='{UserName}';

/*
insert into msfo.CORSA_SEGMENTS_CURRENT 
select  * from msfo.CORSA_seg_to_segcur 
where reportid=$6 and UserName=$7
*/

---CmdTxt = "CALL msfo.CORSA_DA_REPLACE(" & LoadIDCorsa & ", '" & CorsaUser & "')"
