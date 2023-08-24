  update msfo.CORSA_log set status = $1,
        duration = now()
        where Load_id=$2;
