  INSERT INTO msfo.corsa_corrections_current(
	load_id, reportid, corrname_l, ias5_l, vl, entrylinecode, username, loaddate, loadtime, sysid, sessiontime, prelim, corr_comment, changetime, type_auto, addednull, entrycode, vl_seg, comm_simpl)
	VALUES ($1, $2, $3,$4, $5, $6, $7, $8, $9, $10,  $11,  $12,  $13,  $14,  $15,  $16,  $17,  $18,  $19);
