  update msfo.CORSA_LOG 
  set actual_aut = 0 
  where reportid = '{report_id}';


update msfo.CORSA_LOG set actual_aut = 1 where load_id = '{load_id}';
