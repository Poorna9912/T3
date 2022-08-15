CALL EDIDB2A.SP_UTIL_DROP( 'TABLE EDIDB2A.T_TP_TRAN_AUTH');
CALL EDIDB2A.SP_UTIL_DROP( 'TABLE EDIDB2A.T_TP_TRAN_DUP_CHK');
CALL EDIDB2A.SP_UTIL_DROP( 'TABLE EDIDB2A.T_TP_CHNL');
CALL EDIDB2A.SP_UTIL_DROP( 'TABLE EDIDB2A.T_TP_834_GRP_AUTH');
CALL EDIDB2A.SP_UTIL_DROP( 'TABLE EDIDB2A.T_TP_ISA_CTRL_NUM');
CALL EDIDB2A.SP_UTIL_DROP( 'TABLE EDIDB2A.T_TP_GS_CTRL_NUM');
CALL EDIDB2A.SP_UTIL_DROP( 'TABLE EDIDB2A.T_TP_XREF');
CALL EDIDB2A.SP_UTIL_DROP( 'TABLE EDIDB2A.T_TP');
CALL EDIDB2A.SP_UTIL_DROP( 'TABLE EDIDB2A.T_TP_SLA');
CALL EDIDB2A.SP_UTIL_DROP( 'TABLE T_TP_TA1_ERRS') ;

CREATE TABLE T_TP
(
	TP_ID                	VARCHAR(40) NOT NULL ,
	TP_QLFR_ID           	VARCHAR(2) NOT NULL ,
	TP_TYPE_CD           	CHAR(1) ,
	PRTNR_NME            	VARCHAR(30) ,
	ELE_DLTD_ID          	CHAR(1) ,
	SEG_DLTD_ID          	CHAR(1) ,
	PRTNR_ADR_TXT        	VARCHAR(35) ,
	PRTNR_CY_NME         	VARCHAR(30) ,
	PRTNR_STT_CD         	VARCHAR(4) ,
	PRTNR_ZIP_CD         	VARCHAR(9) ,
	PRTNR_CNTC_NME       	VARCHAR(9) ,
	PRTNR_CNTC_PH_NUM    	VARCHAR(13) ,
	PRTNR_CNTC_PH_EXT_NUM	VARCHAR(4) ,
	PRTNR_CNTC_EMAIL_ID  	VARCHAR(60) ,
	EDDI_ID              	CHAR(9) ,
	ISA01_ATHR_INFO_QLFR_CD VARCHAR(2) ,
	ISA02_ATHR_INFO_ID   	VARCHAR(10) ,
	ISA03_SEC_INFO_QLFR_CD 	VARCHAR(2) ,
	ISA04_SEC_INFO_ID    	VARCHAR(10) ,
	ISA05_SNDR_QLFR_CD   	CHAR(2) ,
	ISA06_SNDR_ID        	VARCHAR(15) ,
	ISA07_RECR_QLFR_CD   	CHAR(2) ,
	ISA08_RECR_ID        	VARCHAR(15) ,
	ISA11_REPT_SEPRT_CD  	CHAR(1) ,
	ISA12_VER_NUM        	VARCHAR(5) ,
	ISA14_ACKN_RQ_IND    	CHAR(1) ,
	ISA15_USE_IND        	CHAR(1) ,
	ISA16_CMPNT_ELE_SEPRT_IND CHAR(1) ,
	SND_TECH_ACKN1_IND   	CHAR(1) ,	-- Send TA1 Flag used to indicate whether TP wants to receive TA1
	EXPCT_TECH_ACKN1_IND 	CHAR(1) ,
	HIGH_LVL_ACKN_IND    	CHAR(1) ,	-- Send 999 Flag used to Indicate whether TP wants to receive 999
	CREA_BY				 	VARCHAR(30),
	CREA_TS              	TIMESTAMP DEFAULT CURRENT TIMESTAMP,
	UPDT_BY              	VARCHAR(30) ,
	UPDT_TS              	TIMESTAMP,
	DELETE_IND           	CHAR(1) DEFAULT '0'
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP ADD CONSTRAINT  X_TP PRIMARY KEY (TP_ID,TP_QLFR_ID);

CREATE TABLE T_TP_834_GRP_AUTH
(
	TP_ID                VARCHAR(40) NOT NULL ,
	TP_QLFR_ID           CHAR(2) NOT NULL ,
	GRP_NUM              CHAR(5) NOT NULL ,
	MEMS_SYS_ID          CHAR(4) ,
	MAP_NME              VARCHAR(50) ,
	GRP_NME              VARCHAR(30) ,
	GRP_EMAIL_ID         VARCHAR(50) ,
	HOLD_IND             CHAR(1) ,
	RVW_IND              CHAR(1) ,
	UPDT_BY              VARCHAR(30) ,
	UPDT_TS              TIMESTAMP 
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP_834_GRP_AUTH	ADD CONSTRAINT  X_TP_834_GRP_AUTH PRIMARY KEY (TP_ID,TP_QLFR_ID,GRP_NUM);

CREATE TABLE T_TP_CHNL
(
	TP_ID                VARCHAR(40) NOT NULL ,
	TP_QLFR_ID           VARCHAR(2) NOT NULL ,
	TRAN_NUM             VARCHAR(4) NOT NULL ,
	TRAN_VER_NUM         VARCHAR(12) NOT NULL ,
	DIR_IND              CHAR(1) NOT NULL ,
	CHNL_TYPE_CD         CHAR(1) NOT NULL ,
	CHNL_NME             VARCHAR(80) ,
	UPDT_BY              VARCHAR(30) ,
	UPDT_TS              TIMESTAMP 
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP_CHNL 	ADD CONSTRAINT  X_TP_CHNL PRIMARY KEY (TP_ID,TP_QLFR_ID,TRAN_NUM,TRAN_VER_NUM,DIR_IND,CHNL_TYPE_CD);

CREATE TABLE T_TP_GS_CTRL_NUM
(
	TP_ID                VARCHAR(40) NOT NULL ,
	TP_QLFR_ID           VARCHAR(2) NOT NULL ,
	TRAN_NUM             VARCHAR(5) NOT NULL ,
	GS_CTRL_NUM          INTEGER ,
	ST_CTRL_NUM          INTEGER 
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP_GS_CTRL_NUM	ADD CONSTRAINT  X_TP_GS PRIMARY KEY (TP_ID,TP_QLFR_ID,TRAN_NUM);

CREATE TABLE T_TP_ISA_CTRL_NUM
(
	TP_ID                VARCHAR(40) NOT NULL ,
	TP_QLFR_ID           VARCHAR(2) NOT NULL ,
	ISA_CTRL_NUM         INTEGER 
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP_ISA_CTRL_NUM	ADD CONSTRAINT  X_TP_ISA_CTRL_NUM PRIMARY KEY (TP_ID,TP_QLFR_ID);

CREATE TABLE T_TP_SLA
(
	BACKEND_SYS_ID       VARCHAR(50) NOT NULL ,
	TRAN_NUM             VARCHAR(4) NOT NULL ,
	TMEOUT_NUM           INTEGER 
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP_SLA	ADD CONSTRAINT  X_TP_SLA PRIMARY KEY (BACKEND_SYS_ID,TRAN_NUM);

CREATE TABLE T_TP_TRAN_AUTH
(
	TP_ID                VARCHAR(40) NOT NULL ,
	TP_QLFR_ID           CHAR(2) NOT NULL ,
	TRAN_NUM             CHAR(4) NOT NULL ,
	TRAN_VER_NUM         VARCHAR(12) NOT NULL ,
	DIR_IND              CHAR(1) NOT NULL ,
	GS01_FUNCL_ID        CHAR(2) NOT NULL ,
	LOB_IND              CHAR(1) ,
	GS02_SNDR_CD         VARCHAR(15) ,
	GS03_RECR_CD         VARCHAR(15) ,
	TECH_ACKN1_IND       CHAR(1) ,
	GS07_RSPB_AGY_CD     CHAR(2) ,
	C999_IND             CHAR(1) ,
	CLM_ACKN277_IND      CHAR(1) ,
	C997_IND             CHAR(1) ,
	ACTV_IND             CHAR(1) ,
	CMPL_LVL_CD          CHAR(1) ,
	CMPL_RPT_IND         CHAR(1) ,
	UPDT_BY              VARCHAR(30) ,
	UPDT_TS              TIMESTAMP,
	CREA_BY              VARCHAR(30),
	CREA_TS              TIMESTAMP DEFAULT CURRENT TIMESTAMP
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP_TRAN_AUTH	ADD CONSTRAINT  X_TP_TRAN_AUTH PRIMARY KEY (TP_ID,TP_QLFR_ID,TRAN_NUM,TRAN_VER_NUM,DIR_IND,GS01_FUNCL_ID);

CREATE TABLE T_TP_TRAN_DUP_CHK
(
	TP_ID                VARCHAR(40) NOT NULL ,
	TP_QLFR_ID           VARCHAR(2) NOT NULL ,
	CRC_CD               VARCHAR(3750) ,
	CURR_INDX_NUM        INTEGER 
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP_TRAN_DUP_CHK	ADD CONSTRAINT  X_TP_TRAN_DUP_CHK PRIMARY KEY (TP_ID,TP_QLFR_ID);

CREATE TABLE T_TP_XREF
(
	ALIAS_TP_ID          VARCHAR(40) NOT NULL ,
	ALIAS_TP_QLFR_ID     VARCHAR(2) NOT NULL ,
	TP_ID                VARCHAR(40) ,
	TP_QLFR_ID           VARCHAR(2) ,
	LOC_TXT              VARCHAR(50) 
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP_XREF	ADD CONSTRAINT  X_TP_XREF PRIMARY KEY (ALIAS_TP_ID,ALIAS_TP_QLFR_ID);

CREATE TABLE T_TP_TA1_ERRS (
	FILE_ID 			BIGINT NOT NULL,
	TA1_ERR_CD 			BIGINT NOT NULL,
	TP_QLFR 			VARCHAR(2),
	TP_ID 				VARCHAR(40),
	TA1_ERR_TYPE 		CHARACTER(1),
	AAA_CD 				CHARACTER(3),
	ICHG_ACKN_CD 		CHARACTER(1),
	TRAN_NUM_ST01 		INTEGER,
	TRAN_VER_GS08 		VARCHAR(12),
	SNDR_ID_QLFR_ISA05 	VARCHAR(2),
	SNDR_ID_ISA06 		VARCHAR(15),
	ISA_CTRL_NUM_ISA13 	INTEGER,
	ICHG_DT_ISA09 		DATE,
	ICHG_TME_ISA10 		TIME,
	TA1_STATE 			CHARACTER(1)
)IN TBSP_TABLES INDEX IN TBSP_INDEX;

ALTER TABLE T_TP_TA1_ERRS	ADD CONSTRAINT  X_T_TP_TA1_ERRS PRIMARY KEY (FILE_ID,TA1_ERR_CD);
