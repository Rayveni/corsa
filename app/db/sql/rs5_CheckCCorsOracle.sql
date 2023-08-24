  SELECT EntryLineCode,
		vl, 
		comm_simpl
  FROM msfo.CORSA_corrections_current cc 
  INNER JOIN msfo.CORSA_REPORTDATES rd 
  ON cc.ReportID = rd.ReportID 
    WHERE UserName=$1 
	and coalesce(comm_simpl,'Недопустимое значение')='Недопустимое значение' 
   order by 1;