 update msfo.CORSA_LOG 
 set actual_man = 0 
 where reportid = '{report_id}' and UserName= '{user}';

  update msfo.CORSA_LOG 
 set actual_man = 1
 where load_id = '{load_id}' ;