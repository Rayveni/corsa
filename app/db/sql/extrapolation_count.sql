  select count(*) as _cnt 
  from msfo.CORSA_corrections_current
  where COALESCE (vl,0) <> 0 and comm_simpl='Экстраполяция' and UserName= $1;
