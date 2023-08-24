  update msfo.CORSA_corrections_current 
  set comm_simpl=$1 
  where comm_simpl= $2 and UserName=$3 and Load_id=$4;
  