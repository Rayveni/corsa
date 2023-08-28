create schema msfo;

CREATE TABLE msfo.CORSA_CORRECTIONS (
  LOAD_ID numeric NOT NULL,
  REPORTID varchar(255) COLLATE pg_catalog.default,
  CORRNAME_L varchar(1000) COLLATE pg_catalog.default,
  IAS5_L varchar(255) COLLATE pg_catalog.default,
  VL numeric,
  ENTRYLINECODE varchar(255) COLLATE pg_catalog.default,
  USERNAME varchar(255) COLLATE pg_catalog.default,
  LOADDATE date,
  LOADTIME date,
  SYSID varchar(255),
  SESSIONTIME date,
  PRELIM varchar(255) COLLATE pg_catalog.default,
  CORR_COMMENT varchar(1000) COLLATE pg_catalog.default,
  CHANGETIME date,
  TYPE_AUTO numeric,
  ADDEDNULL numeric,
  ENTRYCODE varchar(255) COLLATE pg_catalog.default,
  VL_SEG numeric,
  COMM_SIMPL varchar(50)
 
)
;

CREATE TABLE msfo.CORSA_CORRECTIONS_CURRENT (
  LOAD_ID numeric NOT NULL,
  REPORTID varchar(255) COLLATE pg_catalog.default,
  CORRNAME_L varchar(1000) COLLATE pg_catalog.default,
  IAS5_L varchar(255) COLLATE pg_catalog.default,
  VL numeric,
  ENTRYLINECODE varchar(255) COLLATE pg_catalog.default,
  USERNAME varchar(255) COLLATE pg_catalog.default,
  LOADDATE date,
  LOADTIME date,
  SYSID varchar(255),
  SESSIONTIME date,
  PRELIM varchar(255) COLLATE pg_catalog.default,
  CORR_COMMENT varchar(1000) COLLATE pg_catalog.default,
  CHANGETIME date,
  TYPE_AUTO numeric,
  ADDEDNULL numeric,
  ENTRYCODE varchar(255) COLLATE pg_catalog.default,
  VL_SEG numeric,
  COMM_SIMPL varchar(50)
)
;

CREATE TABLE msfo.CORSA_LOG (
  LOAD_ID SERIAL PRIMARY KEY,
  REPORTID varchar(255) COLLATE pg_catalog.default NOT NULL,
  USERNAME varchar(255) COLLATE pg_catalog.default NOT NULL,
  SESSIONTIME date NOT NULL,
  LOAD_FILE varchar(1000) COLLATE pg_catalog.default,
  TOCOMPARE int4,
  SESSIONTIME_PREV date,
  STATUS varchar(255) COLLATE pg_catalog.default,
  DURATION date,
  ACTUAL_MAN int4,
  ACTUAL_AUT int4
)
;	


CREATE TABLE msfo.CORSA_DA_CURRENT 
   (	DT_REP DATE, 
	REPORTID varchar(50), 
	ENTRYLINECODE varchar(50), 
	SUM_KRUR numeric, 
	SUM_ROUND_KRUR numeric, 
	SUM_ROUNDED_KRUR numeric, 
	IAS5 varchar(50), 
	ENTRYCODE varchar(50), 
	USERNAME varchar(50), 
	ENTRY_NAME varchar(255), 
	COMM varchar(255), 
	PRELIM varchar(255), 
	CORR_COMMENT varchar(1000), 
	COMM_SIMPL varchar(255), 
	VL_SEG numeric
   ) ;
   
    CREATE TABLE msfo.CORSA_REPORTDATES 
   (REPORTID varchar(100) NOT NULL, 
	Q numeric, 
	YE numeric, 
	REPORTDATE DATE NOT NULL, 
	REPORTID_PREV varchar(100), 
	RD_CURRENT numeric, 
	--"BLOCKED" numeric, 
	RD_COMMENT varchar(1000), 
	PREC numeric, 
	BLOCKED_COMM varchar(1000), 
	BSPLFILE varchar(1000));
	
	
	

CREATE TABLE msfo.CORSA_DA 
   (	DT_REP DATE, 
	REPORTID varchar(50), 
	ENTRYLINECODE varchar(50), 
	SUM_KRUR numeric, 
	SUM_ROUND_KRUR numeric, 
	SUM_ROUNDED_KRUR numeric, 
	IAS5 varchar(50), 
	ENTRYCODE varchar(50), 
	USERNAME varchar(50), 
	ENTRY_NAME varchar(255), 
	COMM varchar(255), 
	PRELIM varchar(255), 
	CORR_COMMENT varchar(1000), 
	COMM_SIMPL varchar(255), 
	VL_SEG numeric
   ) ;
   
   CREATE TABLE msfo.CORSA_DA_ENTRIES 
   (	ENTRYCODE varchar(50) NOT NULL, 
	USERNAME varchar(50) NOT NULL, 
	ENTRY_NAME varchar(255), 
	PROC_NAME varchar(255), 
	TASK_ID varchar(255), 
	TASK_NAME varchar(255), 
	COMM varchar(255), 
	NROW numeric
   ) ;

CREATE TABLE msfo.CORSA_CORRECTIONS_ORE 
   (	LOAD_ID numeric, 
	REPORTID VARCHAR(255), 
	CORRNAME_L VARCHAR(1000), 
	IAS5_L VARCHAR(255), 
	VL numeric, 
	ENTRYLINECODE VARCHAR(255), 
	USERNAME VARCHAR(255), 
	LOADDATE DATE, 
	LOADTIME DATE, 
	SYSID varchar(255), 
	SESSIONTIME DATE, 
	PRELIM VARCHAR(255), 
	CORR_COMMENT VARCHAR(1000), 
	CHANGETIME DATE, 
	TYPE_AUTO numeric, 
	ADDEDNULL numeric, 
	ENTRYCODE VARCHAR(255), 
	VL_SEG numeric, 
	COMM_SIMPL VARCHAR(255));


CREATE TABLE MSFO.CORSA_SEGMENTS 
   (           REPORTID VARCHAR(255) NOT NULL, 
                ENTRYLINECODE VARCHAR(255) NOT NULL, 
                USERNAME VARCHAR(255) NOT NULL, 
                SEG15 VARCHAR(255) NOT NULL, 
                SEG_VL numeric, 
                RATIO_NAME VARCHAR(255)
				)
  ;

  CREATE TABLE MSFO.CORSA_SEGMENTS_CURRENT 
   (           REPORTID VARCHAR(255) NOT NULL, 
                USERNAME VARCHAR(255) NOT NULL, 
                ENTRYLINECODE VARCHAR(255) NOT NULL, 
                RATIO_NAME VARCHAR(255), 
                CUR VARCHAR(255), 
                VL numeric
                ) ;



CREATE TABLE MSFO.CORSA_SEGMENTS_RATES 
   (           REPORTID VARCHAR(255) NOT NULL, 
                RATIO_NAME VARCHAR(255) NOT NULL, 
                SEG15 VARCHAR(255) NOT NULL, 
                VL_RATIO numeric);



  CREATE TABLE MSFO.CORSA_ENTRYCODES 
   (           ENTRYCODE VARCHAR(255), 
                CORRNAME VARCHAR(1000), 
                TIMEFROM DATE, 
                TIMETO DATE
   ) ;
CREATE TABLE MSFO.CORSA_ENTRYLINECODES 
   (           ENTRYLINECODE VARCHAR(255) NOT NULL, 
                ENTRYCODE VARCHAR(255), 
                ADDED DATE
				);
				
				
CREATE TABLE MSFO.CORSA_PNL 
   (           REPORTID VARCHAR(255) NOT NULL, 
                SYMBOL VARCHAR(255) NOT NULL, 
                VL numeric
) ;


CREATE TABLE MSFO.CORSA_SYMNAMES 
   (           SYM VARCHAR(255) NOT NULL, 
                NAME_L1 VARCHAR(255), 
                NAME_L2 VARCHAR(255), 
                NAME_L3 VARCHAR(255), 
                NAME_L4 VARCHAR(255)) ;


  CREATE TABLE MSFO.CORSA_BALANCE 
   (           REPORTID VARCHAR(255) NOT NULL, 
                BACC VARCHAR(255) NOT NULL, 
                VL numeric) ;


  CREATE TABLE MSFO.CORSA_RASTOIAS 
   (           REPORTID VARCHAR(255) NOT NULL, 
                RAS2 VARCHAR(255) NOT NULL, 
                IAS5 VARCHAR(255)) ;
				
				
CREATE OR REPLACE VIEW MSFO.CORSA_CORRECTIONS_ACTUAL (LOAD_ID, REPORTID, CORRNAME_L, IAS5_L, VL, ENTRYLINECODE, USERNAME, LOADDATE, LOADTIME, SYSID, SESSIONTIME, PRELIM, CORR_COMMENT, CHANGETIME, TYPE_AUTO, ADDEDNULL, ENTRYCODE, VL_SEG, COMM_SIMPL) AS 
  WITH cca AS
  (
  SELECT
    t.LOAD_ID,
    t.REPORTID,
    t.CORRNAME_L,
    t.IAS5_L,
    t.VL,
    t.ENTRYLINECODE,
    t.USERNAME,
    t.LOADDATE,
    t.LOADTIME,
    t.SYSID,
    t.SESSIONTIME,
    t.PRELIM,
    t.CORR_COMMENT,
    t.CHANGETIME,
    t.TYPE_AUTO,
    t.ADDEDNULL,
    t.ENTRYCODE,
    t.VL_SEG,
    t.comm_simpl
  FROM
    msfo.CORSA_CORRECTIONS t
  INNER JOIN
    msfo.corsa_log l
  ON t.load_id = l.load_id
  WHERE (t.type_auto=0 AND l.actual_man=1) OR (t.type_auto=1 AND l.actual_aut=1)
  )

SELECT LOAD_ID,cca.REPORTID,CORRNAME_L,IAS5_L,VL,ENTRYLINECODE,USERNAME,LOADDATE,LOADTIME,SYSID,SESSIONTIME,PRELIM,CORR_COMMENT,CHANGETIME,TYPE_AUTO,ADDEDNULL,cca.ENTRYCODE,VL_SEG, cca.COMM_SIMPL
FROM cca /* WHEREcca.addednull=0

UNION ALL

SELECT c1.LOAD_ID,c1.REPORTID,c1.CORRNAME_L,c1.IAS5_L,c1.VL,c1.ENTRYLINECODE,c1.USERNAME,c1.LOADDATE,c1.LOADTIME,c1.SYSID,c1.SESSIONTIME,c1.PRELIM,c1.CORR_COMMENT,c1.CHANGETIME,c1.TYPE_AUTO,c1.ADDEDNULL,c1.ENTRYCODE,c1.VL_SEG,c1.COMM_SIMPL
FROM cca c1
LEFT JOIN (SELECT DISTINCT REPORTID, ENTRYCODE FROM cca WHERE addednull=0) c2 ON c1.REPORTID=c2.REPORTID AND c1.ENTRYCODE=c2.ENTRYCODE
WHERE c1.addednull=1 AND c2.REPORTID IS NULL;*/

LEFT JOIN (SELECT  REPORTID, ENTRYCODE FROM cca GROUP BY REPORTID, ENTRYCODE HAVING MIN(addednull)=1) c2
ON cca.REPORTID=c2.REPORTID AND cca.ENTRYCODE=c2.ENTRYCODE
WHERE c2.REPORTID IS NULL
;
CREATE TABLE MSFO.CORSA_BACC_NAMES 
   (           BACC VARCHAR(255) NOT NULL, 
                BACC_NAME VARCHAR(255)
				);

CREATE OR REPLACE VIEW MSFO.CORSA_REPORT_IAS5 (REPORTID, RAS2, VL, USERNAME, RAS2_NAME, RC_NAME, RCL_NAME, IAS5, INPCORR, ENTRYLINECODE) AS 
  SELECT
  inp.REPORTID,inp.RAS2,inp.VL,inp.USERNAME,inp.RAS2_NAME,
  inp.RAS2 || ' - ' || inp.RAS2_Name as RC_NAME, inp.RAS2 || ' - ' || inp.RAS2_Name as RCL_NAME,
  ias5, 'RAS' as InpCorr, null as EntryLineCode
FROM
  (
  SELECT cp.ReportID, 'PL_' || SYMBOL AS RAS2, cp.VL, 'RAS' as USERNAME, csn.NAME_L2 || ' - ' || csn.NAME_L3 || ' - ' || csn.NAME_L4 AS RAS2_Name
  FROM msfo.corsa_pnl cp
  LEFT JOIN msfo.CORSA_SYMNAMES csn ON cp.SYMBOL = csn.SYM

  UNION ALL

  SELECT ReportID, cb.BACC AS RAS2, VL, 'RAS' as USERNAME, cbn.BACC_NAME as RAS2_Name
  FROM msfo.corsa_balance cb
  LEFT JOIN msfo.CORSA_BACC_NAMES cbn ON cb.BACC = cbn.BACC
  ) INP
LEFT JOIN
  msfo.corsa_rastoias cra
ON inp.ras2 = cra.ras2 AND inp.ReportID = cra.ReportID

UNION ALL

SELECT
  cca.reportid, cca.entrycode, vl, username,
  --NULL, NULL, NULL,
  EL_NAmes.corrname, EL_NAmes.corrname, cca.entrylinecode || ' - ' || EL_NAmes.corrname,
  ias5_L, 'Corrections' as InpCorr, cca.EntryLineCode
FROM
  msfo.CORSA_corrections_actual cca
LEFT JOIN
  (
  SELECT EntryLineCode, CorrName
  FROM
  msfo.corsa_EntryCodes ec
  INNER JOIN msfo.corsa_EntryLineCodes elc ON ec.EntryCode = elc.EntryCode
  WHERE ec.timeto=DATE'2999-12-31'
  ) EL_NAmes
ON EL_NAmes.EntryLineCode = UPPER(cca.EntryLineCode)
;
CREATE OR REPLACE VIEW MSFO.CORSA_CURRENT_PLUS_ADDEDNULL as 
(
SELECT
  cc.load_id,
  cc.reportid,
  corrname_l,
  ias5_l,
  cc.vl,
  cc.entrylinecode,
  cc.username,
  loaddate,
  loadtime,
  sysid,
  sessiontime,
  prelim,
  corr_comment,
  CASE WHEN ca.vl IS NULL OR cc.vl<>coalesce(ca.vl,0) THEN sessiontime ELSE ca.changetime END AS changetime,
  cc.type_auto,
  0 AS addednull,
  entrycode,
  vl_seg,
  cc.comm_simpl
FROM
  msfo.corsa_corrections_current cc
LEFT JOIN
  (
  SELECT
    c.reportid, c.entrylinecode, c.vl, c.changetime
  FROM msfo.CORSA_CORRECTIONS_ACTUAL c
--  INNER JOIN corsa_log l ON l.load_id=c.load_id AND l.actual_man=1
  WHERE addednull=0
  ) ca
ON ca.reportid=cc.reportid AND ca.entrylinecode=cc.entrylinecode

UNION ALL

SELECT
  ls.load_id,
  ca.reportid,
  ca.corrname_l,
  ca.ias5_l,
  0 AS vl,
  ca.entrylinecode,
  ca.username,
  ca.loaddate,
  ca.loadtime,
  ca.sysid,
  ls.sessiontime,
  'Final' as prelim,
  ca.corr_comment,
  CASE WHEN ca.addednull = 1 THEN ca.changetime ELSE ls.sessiontime END AS changetime,
  0 AS type_auto,
  1 AS addednull,
  ca.entrycode,
  0 AS vl_seg,
  null as COMM_SIMPL
FROM
  (
  SELECT
    c.*
  FROM msfo.CORSA_CORRECTIONS_ACTUAL c
--  INNER JOIN corsa_log l ON l.load_id=c.load_id AND l.actual_man=1
  WHERE type_auto = 0
  ) ca
INNER JOIN
  (
  SELECT DISTINCT cc.load_id, cc.reportid, cc.username, sessiontime 
	  FROM msfo.corsa_corrections_current cc
  ) ls
ON ls.reportid=ca.reportid AND ls.username=ca.username
LEFT JOIN
  msfo.corsa_corrections_current cc
ON ca.reportid=cc.reportid AND upper(ca.entrylinecode)=upper(cc.entrylinecode) AND ca.username = cc.username
WHERE cc.reportid IS NULL
);





