  insert into msfo.CORSA_CORRECTIONS_ORE 
  select  * from msfo.CORSA_CORRECTIONS_CURRENT 
  where vl_seg>30000 and UserName='{user}';


delete from msfo.CORSA_CORRECTIONS_CURRENT 
where type_auto=2 and UserName='{user}';



insert into msfo.CORSA_CORRECTIONS 
select  * from msfo.CORSA_CURRENT_PLUS_ADDEDNULL 
where addednull=0 and UserName='{user}';

