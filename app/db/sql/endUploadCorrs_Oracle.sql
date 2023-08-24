  insert into msfo.CORSA_CORRECTIONS_ORE 
  select  * from msfo.CORSA_CORRECTIONS_CURRENT 
  where UserName= '{user}';


  delete from msfo.CORSA_CORRECTIONS_CURRENT 
  where type_auto=2 and UserName='{user}';
