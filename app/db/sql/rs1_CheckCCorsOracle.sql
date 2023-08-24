  SELECT max(EntryLineCode) as EntryLineCode
  , Count(*) as Cnt 
  FROM msfo.CORSA_corrections_current where UserName=$1
  GROUP BY upper(EntryLineCode) HAVING Count(*) > 1;