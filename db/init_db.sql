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
  SYSID numeric,
  SESSIONTIME date,
  PRELIM varchar(255) COLLATE pg_catalog.default,
  CORR_COMMENT varchar(1000) COLLATE pg_catalog.default,
  CHANGETIME date,
  TYPE_AUTO numeric,
  ADDEDNULL numeric,
  ENTRYCODE varchar(255) COLLATE pg_catalog.default,
  VL_SEG numeric,
  CONSTRAINT CORSA_CORRECTIONS_pkey PRIMARY KEY (LOAD_ID)
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
	
	
	CREATE TABLE msfo.corsa_corrections_actual (
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
);

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

