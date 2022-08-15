--=============================================================================
--	Filename:	procs.sql
--	Author:		Nanaji Veturi
--	Date:		OCT/10/2010
--	Description:
--	This file contains the Procedures  for the UI
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_T_TP_TRANS_AUTH_DELETE')@

CREATE PROCEDURE EDIDB2A.SP_UI_T_TP_TRANS_AUTH_DELETE 
	(
	IN  p_TPID 			VARCHAR(40), 
	IN  p_TPQLFRID 		VARCHAR(2), 
	IN  p_TRANNUM 		VARCHAR(4), 
	IN  p_TRANVERNUM 	VARCHAR(12), 
	IN  p_GS01FUNCLID 	VARCHAR(2), 
	IN  P_DIRIND 		VARCHAR(1),
	OUT p_ERR_CODE		INTEGER,
	OUT p_ERR_DESC		VARCHAR(255)
	)
 LANGUAGE SQL 
 MODIFIES SQL DATA 
 BEGIN 

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

	DECLARE v_sqlcode 		INTEGER ; 
	DECLARE v_sqlcode1 		INTEGER ; 
	DECLARE SQLCODE		INTEGER DEFAULT 0; 

--============================================================================
--  Setup the EXIT Handle for all SQL Exceptions
--============================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	VALUES (SQLCODE) INTO v_sqlcode; 

--=============================================================================
--	Deleting Data from the Table T_TP_GS_CTRL_NUM
--=============================================================================

DELETE FROM EDIDB2A.T_TP_GS_CTRL_NUM WHERE TP_ID=p_TPID AND TP_QLFR_ID=p_TPQLFRID AND TRAN_NUM=p_TRANNUM; 

VALUES (SQLCODE) INTO v_sqlcode; 

--=============================================================================
--	Deleting Data from the Table T_TP_TRAN_AUTH
--=============================================================================

DELETE FROM  EDIDB2A.T_TP_TRAN_AUTH WHERE  TP_ID=p_TPID AND TP_QLFR_ID=p_TPQLFRID AND TRAN_NUM=p_TRANNUM AND TRAN_VER_NUM=p_TRANVERNUM 	AND GS01_FUNCL_ID=p_GS01FUNCLID AND DIR_IND=P_DIRIND; 

VALUES (SQLCODE) INTO v_sqlcode1; 

IF (v_sqlcode = 0 AND v_sqlcode1 <> 0) THEN
  
      SET p_ERR_CODE = v_sqlcode1;
      SET p_ERR_DESC = 'Rows deleted from table T_TP_GS_CTRL_NUM and deleted from table T_TP_TRAN_AUTH';
 	
 	ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 = 0) 	THEN
 
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Rows not deleted from table T_TP_GS_CTRL_NUM and deleted from table T_TP_TRAN_AUTH';
      
    ELSEIF (v_sqlcode = 0 AND v_sqlcode1 = 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Rows deleted from tables T_TP_GS_CTRL_NUM and T_TP_TRAN_AUTH';
     
    ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 <> 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Rows not deleted from tables T_TP_GS_CTRL_NUM and T_TP_TRAN_AUTH';
  END IF;

 END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_T_TP_INSERT')@

CREATE PROCEDURE EDIDB2A.SP_UI_T_TP_INSERT 
	( 
	IN 	p_TP_ID 					VARCHAR(40), 
	IN 	p_TP_QLFR 					VARCHAR(2), 
	IN 	p_PRTNR_NME 				VARCHAR(30), 
	IN 	p_PRTNR_ADR1 				VARCHAR(35), 
	IN 	p_PRTNR_CY 					VARCHAR(30), 
	IN 	p_PRTNR_STT_CD 				VARCHAR(4), 
	IN 	p_PRTNR_ZIP_CD 				VARCHAR(9), 
	IN 	p_TP_TYPE 					VARCHAR(1), 
	IN 	p_PRTNR_CNTC_NME 			VARCHAR(9), 
	IN 	p_PRTNR_CNTC_PH 			VARCHAR(13), 
	IN 	p_PRTNR_CNTC_EMAIL		    VARCHAR(60), 
	IN 	p_PRTNR_CNTC_PH_EXT 		VARCHAR(4), 
	IN 	p_ATHR_INFO_QLFR_ISA01 		VARCHAR(2), 
	IN 	p_ATHR_INFO_ISA02 			VARCHAR(10), 
	IN 	p_SEC_INFO_QLFR_ISA03 		VARCHAR(2), 
	IN 	p_SEC_INFO_ISA04 			VARCHAR(10), 
	IN 	p_SNDR_QLFR_ISA05 			VARCHAR(2), 
	IN 	p_SNDR_ID_ISA06 			VARCHAR(15), 
	IN 	p_RECR_QLFR_ISA07 			VARCHAR(2), 
	IN 	p_RECR_ID_ISA08 			VARCHAR(15), 
	IN 	p_VER_NUM_ISA12 			VARCHAR(5), 
	IN 	p_ACKN_RQ_ISA14 			VARCHAR(1), 
	IN 	p_USE_IND_ISA15 			VARCHAR(1), 
	IN 	p_ELE_DELIMITER				VARCHAR(1), 
	IN 	p_SEG_DELIMITER 			VARCHAR(1), 
	IN 	p_CMPNT_ELE_SEPARATOR_ISA16 VARCHAR(1), 
	IN 	p_REPT_SEPARATOR_ISA11 	  	VARCHAR(1),  
	IN 	p_EDDI_ID 			   		VARCHAR(9), 
	IN 	p_CREA_BY 					VARCHAR(30), 
	IN 	p_ISA_CTRL_NUM 				INTEGER,
	OUT p_ERR_CODE					INTEGER,
	OUT p_ERR_DESC					VARCHAR(255)
	)

LANGUAGE SQL 
MODIFIES SQL DATA 

BEGIN 

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

	DECLARE v_sqlcode 		INTEGER ;
	DECLARE v_sqlcode1 		INTEGER ;  
	DECLARE SQLCODE		INTEGER DEFAULT 0; 

--============================================================================
--  Setup the EXIT Handle for all SQL Exceptions
--============================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	VALUES (SQLCODE) INTO v_sqlcode; 

--=============================================================================
--	Inserting Data into the Table T_TP
--=============================================================================

INSERT INTO EDIDB2A.T_TP (TP_ID,TP_QLFR_ID,PRTNR_NME,PRTNR_ADR_TXT, PRTNR_CY_NME, PRTNR_STT_CD, PRTNR_ZIP_CD, PRTNR_CNTC_NME, PRTNR_CNTC_PH_NUM, PRTNR_CNTC_EMAIL_ID,PRTNR_CNTC_PH_EXT_NUM, ISA01_ATHR_INFO_QLFR_CD, ISA02_ATHR_INFO_ID, ISA03_SEC_INFO_QLFR_CD, ISA04_SEC_INFO_ID, ISA05_SNDR_QLFR_CD, ISA06_SNDR_ID, ISA07_RECR_QLFR_CD, ISA08_RECR_ID, ISA12_VER_NUM, ISA14_ACKN_RQ_IND,ISA15_USE_IND, ELE_DLTD_ID,SEG_DLTD_ID,ISA16_CMPNT_ELE_SEPRT_IND,ISA11_REPT_SEPRT_CD,EDDI_ID, CREA_BY,DELETE_IND) 
VALUES (p_TP_ID,p_TP_QLFR,p_PRTNR_NME,p_PRTNR_ADR1,p_PRTNR_CY,p_PRTNR_STT_CD,p_PRTNR_ZIP_CD, p_PRTNR_CNTC_NME,p_PRTNR_CNTC_PH,p_PRTNR_CNTC_EMAIL,p_PRTNR_CNTC_PH_EXT,p_ATHR_INFO_QLFR_ISA01, p_ATHR_INFO_ISA02,p_SEC_INFO_QLFR_ISA03,p_SEC_INFO_ISA04,p_SNDR_QLFR_ISA05,p_SNDR_ID_ISA06,p_RECR_QLFR_ISA07, p_RECR_ID_ISA08,p_VER_NUM_ISA12,p_ACKN_RQ_ISA14,p_USE_IND_ISA15,p_ELE_DELIMITER,p_SEG_DELIMITER, p_CMPNT_ELE_SEPARATOR_ISA16,p_REPT_SEPARATOR_ISA11,p_EDDI_ID,p_CREA_BY,'0'); 

VALUES (SQLCODE) INTO v_sqlcode; 

--=============================================================================
--	Inserting Data into the Table T_TP_ISA_CTRL_NUM
--=============================================================================

INSERT INTO EDIDB2A.T_TP_ISA_CTRL_NUM (TP_ID, TP_QLFR_ID, ISA_CTRL_NUM) 
VALUES (p_TP_ID,p_TP_QLFR,p_ISA_CTRL_NUM); 

VALUES (SQLCODE) INTO v_sqlcode1; 

IF (v_sqlcode = 0 AND v_sqlcode1 <> 0) THEN
  
      SET p_ERR_CODE = v_sqlcode1;
      SET p_ERR_DESC = 'Row inserted into table T_TP and insertion failed into table T_TP_ISA_CTRL_NUM';
 	
 	ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 = 0) 	THEN
 
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Insertion failed into table table T_TP and inserted into table T_TP_ISA_CTRL_NUM';
      
    ELSEIF (v_sqlcode = 0 AND v_sqlcode1 = 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Rows inserted into tables T_TP and T_TP_ISA_CTRL_NUM';
     
    ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 <> 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Rows insertion failed into tables T_TP and T_TP_ISA_CTRL_NUM';
  END IF;
END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_T_TP_TRANS_AUTH_EDIT')@

CREATE PROCEDURE EDIDB2A.SP_UI_T_TP_TRANS_AUTH_EDIT ( 
INOUT T_TP_ID VARCHAR(40), 
INOUT T_TRAN_NUM VARCHAR(4), 
INOUT T_TP_QLFR VARCHAR(2), 
INOUT T_TRAN_VER VARCHAR(12), 
INOUT T_FUNCL_ID_CD_GS01 VARCHAR(2), 
INOUT T_DIR VARCHAR(1), 
OUT T_LOB VARCHAR(1), 
OUT T_ACTV_FLAG VARCHAR(1), 
OUT T_GS_SNDR_CD_GS02 VARCHAR(15), 
OUT T_GS_RECR_CD_GS03 VARCHAR(15), 
OUT T_RSPB_AGY_CD_GS07 VARCHAR(2), 
OUT T_FLAG_TA1 VARCHAR(1), 
OUT T_FLAG_999 VARCHAR(1), 
OUT T_FLAG_277CA VARCHAR(1), 
OUT T_FLAG_997 VARCHAR(1), 
OUT T_CMPL_LVL VARCHAR(1), 
OUT T_PRTNR_NME VARCHAR(30), 
OUT T_GS_CTRL_NUM INTEGER, 
OUT T_ST_CTRL_NUM INTEGER,
OUT p_ERR_CODE		INTEGER,
OUT p_ERR_DESC		VARCHAR(255)
) 
LANGUAGE SQL 
MODIFIES SQL DATA 

BEGIN 

DECLARE v_sqlcode 		INTEGER ;
DECLARE v_sqlcode1 		INTEGER ;  
DECLARE SQLCODE		INTEGER DEFAULT 0; 

DECLARE EXIT HANDLER FOR SQLEXCEPTION 
VALUES (SQLCODE) INTO v_sqlcode; 

select a.TP_ID, a.TP_QLFR_ID, a.TRAN_NUM, a.TRAN_VER_NUM, a.GS01_FUNCL_ID, a.DIR_IND, a.LOB_IND, 
a.TECH_ACKN1_IND, a.GS02_SNDR_CD, a.GS03_RECR_CD, a.GS07_RSPB_AGY_CD, a.ACTV_IND, 
a.C999_IND, a.CLM_ACKN277_IND, a.C997_IND, a.CMPL_LVL_CD, b.PRTNR_NME 
INTO T_TP_ID, T_TP_QLFR, T_TRAN_NUM, T_TRAN_VER, T_FUNCL_ID_CD_GS01, T_DIR, T_LOB, T_ACTV_FLAG, 
T_GS_SNDR_CD_GS02, T_GS_RECR_CD_GS03, T_RSPB_AGY_CD_GS07, T_FLAG_TA1, T_FLAG_999, T_FLAG_277CA, 
T_FLAG_997, T_CMPL_LVL, T_PRTNR_NME from EDIDB2A.T_TP_TRAN_AUTH a, EDIDB2A.T_TP b 
where b.DELETE_IND = '0' and   a.TP_ID = b.TP_ID 
AND a.TP_ID =T_TP_ID 
AND a.TRAN_NUM =T_TRAN_NUM
AND a.TP_QLFR_ID =T_TP_QLFR
AND a.TRAN_VER_NUM = T_TRAN_VER
AND a.GS01_FUNCL_ID = T_FUNCL_ID_CD_GS01
AND a.DIR_IND =T_DIR; 

VALUES (SQLCODE) INTO v_sqlcode;

select c.GS_CTRL_NUM,c.ST_CTRL_NUM INTO T_GS_CTRL_NUM,T_ST_CTRL_NUM from EDIDB2A.T_TP_TRAN_AUTH a, EDIDB2A.T_TP_GS_CTRL_NUM c where a.TP_ID = c.TP_ID and a.TRAN_NUM =c.TRAN_NUM AND a.TP_ID =T_TP_ID AND a.TRAN_NUM =T_TRAN_NUM; 

VALUES (SQLCODE) INTO v_sqlcode1;

IF (v_sqlcode = 0 AND v_sqlcode1 <> 0) THEN
  
      SET p_ERR_CODE = v_sqlcode1;
      SET p_ERR_DESC = 'Row retrieved from tables T_TP_TRAN_AUTH, T_TP and Not retrieved from tables T_TP_TRAN_AUTH, T_TP_GS_CTRL_NUM';
 	
 	ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 = 0) 	THEN
 
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Row not retrieved from tables T_TP_TRAN_AUTH, T_TP and retrieved from tables T_TP_TRAN_AUTH, T_TP_GS_CTRL_NUM';
      
    ELSEIF (v_sqlcode = 0 AND v_sqlcode1 = 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Row retrieved from tables T_TP_TRAN_AUTH, T_TP and from tables T_TP_TRAN_AUTH, T_TP_GS_CTRL_NUM';
     
    ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 <> 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Row not retrieved from tables T_TP_TRAN_AUTH, T_TP and Not retrieved from tables T_TP_TRAN_AUTH, T_TP_GS_CTRL_NUM';
  END IF;
END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_T_TP_TRANS_AUTH_INSERT')@

CREATE PROCEDURE EDIDB2A.SP_UI_T_TP_TRANS_AUTH_INSERT
	(
	IN 	p_TP_ID 			VARCHAR(40),
	IN 	p_TRAN_NUM 			VARCHAR(4),
	IN 	p_TP_QLFR 			VARCHAR(2),
	IN 	p_TRAN_VER 			VARCHAR(12),
	IN 	p_FUNCL_ID_CD_GS01 	VARCHAR(2),
	IN 	p_DIR 				VARCHAR(1),
	IN 	p_LOB 				VARCHAR(1),
	IN 	p_ACTV_FLAG 		VARCHAR(1),
	IN 	p_GS_SNDR_CD_GS02 	VARCHAR(15),
	IN 	p_GS_RECR_CD_GS03 	VARCHAR(15),
	IN 	p_RSPB_AGY_CD_GS07 	VARCHAR(2),
	IN 	p_FLAG_TA1 			VARCHAR(1),
	IN 	p_FLAG_999 			VARCHAR(1),
	IN 	p_FLAG_277CA 		VARCHAR(1),
	IN 	p_FLAG_997 			VARCHAR(1),
	IN 	p_CMPL_LVL 			VARCHAR(1),
	--	CMPL_RPT_IND 		CHARACTER(1),
	IN 	p_UPDT_BY 			VARCHAR(30),
	--	UPDT_TS 			TIMESTAMP,
	IN 	p_GS_CTRL_NUM 		INTEGER,
	IN 	p_ST_CTRL_NUM 		INTEGER,
	OUT p_ERR_CODE			INTEGER,
	OUT p_ERR_DESC			VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN 

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

	DECLARE v_sqlcode 		INTEGER ;
	DECLARE v_sqlcode1 		INTEGER ;  
	DECLARE SQLCODE			INTEGER DEFAULT 0; 

--============================================================================
--  Setup the EXIT Handle for all SQL Exceptions
--============================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	VALUES (SQLCODE) INTO v_sqlcode;

--=============================================================================
--	Inserting Data into the Table T_TP_GS_CTRL_NUM
--=============================================================================

INSERT INTO EDIDB2A.T_TP_GS_CTRL_NUM(TP_ID,TP_QLFR_ID,TRAN_NUM,GS_CTRL_NUM,ST_CTRL_NUM) 
VALUES(p_TP_ID,p_TP_QLFR,p_TRAN_NUM,p_GS_CTRL_NUM,p_ST_CTRL_NUM);

VALUES (SQLCODE) INTO v_sqlcode;

--=============================================================================
--	Inserting Data into the Table T_TP_TRAN_AUTH
--=============================================================================

INSERT INTO EDIDB2A.T_TP_TRAN_AUTH (TP_ID, TP_QLFR_ID, TRAN_NUM, TRAN_VER_NUM, DIR_IND, GS01_FUNCL_ID, LOB_IND, GS02_SNDR_CD, GS03_RECR_CD, TECH_ACKN1_IND,GS07_RSPB_AGY_CD, C999_IND, CLM_ACKN277_IND, C997_IND, ACTV_IND, CMPL_LVL_CD, UPDT_BY, UPDT_TS)
values (p_TP_ID,p_TP_QLFR,p_TRAN_NUM,p_TRAN_VER,p_DIR,p_FUNCL_ID_CD_GS01,p_LOB,p_GS_SNDR_CD_GS02,
p_GS_RECR_CD_GS03,p_ACTV_FLAG,p_RSPB_AGY_CD_GS07,p_FLAG_999,p_FLAG_277CA,p_FLAG_997,p_FLAG_TA1,p_CMPL_LVL,p_UPDT_BY,CURRENT TIMESTAMP);

VALUES (SQLCODE) INTO v_sqlcode1;

IF (v_sqlcode = 0 AND v_sqlcode1 <> 0) THEN
  
      SET p_ERR_CODE = v_sqlcode1;
      SET p_ERR_DESC = 'Row inserted into table T_TP_GS_CTRL_NUM and insertion failed into table T_TP_TRAN_AUTH';
 	
 	ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 = 0) 	THEN
 
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Insertion failed into table table T_TP_GS_CTRL_NUM and inserted into table T_TP_TRAN_AUTH';
      
    ELSEIF (v_sqlcode = 0 AND v_sqlcode1 = 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Rows inserted into tables T_TP_GS_CTRL_NUM and T_TP_TRAN_AUTH';
     
    ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 <> 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Rows insertion failed into tables T_TP_GS_CTRL_NUM and T_TP_TRAN_AUTH';
  END IF;
END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_T_TP_TRANS_AUTH_UPDATE')@

CREATE PROCEDURE EDIDB2A.SP_UI_T_TP_TRANS_AUTH_UPDATE 
	(
	IN 	p_TP_ID 			VARCHAR(40), 
	IN 	p_TP_QLFR 			VARCHAR(2), 
	IN 	p_TRAN_NUM 			VARCHAR(4), 
	IN 	p_TRAN_VER 			VARCHAR(12), 
	IN 	p_FUNCL_ID_CD_GS01 	VARCHAR(2),
	IN 	p_DIR 				VARCHAR(1), 
	IN 	p_LOB 				VARCHAR(1), 
	IN 	p_ACTV_FLAG 		VARCHAR(1), 
	IN 	p_GS_SNDR_CD_GS02 	VARCHAR(15), 
	IN 	p_GS_RECR_CD_GS03 	VARCHAR(15), 
	IN 	p_RSPB_AGY_CD_GS07 	VARCHAR(2), 
	IN 	p_FLAG_TA1 			VARCHAR(1), 
	IN 	p_FLAG_999 			VARCHAR(1),
	IN 	p_FLAG_277CA 		VARCHAR(1), 
	IN 	p_FLAG_997 			VARCHAR(1), 
	IN 	p_CMPL_LVL 			VARCHAR(1), 
	IN 	p_GS_CTRL_NUM 		INTEGER, 
	IN 	p_ST_CTRL_NUM 		INTEGER, 
	IN 	p_Gs01Update 		VARCHAR(2), 
	IN 	P_TransVerUpdate 	VARCHAR(12), 
	IN 	P_TransDirUpdate 	VARCHAR(1), 
	IN 	P_UPDT_BY 			VARCHAR(30),
	OUT p_ERR_CODE			INTEGER,
	OUT p_ERR_DESC			VARCHAR(255)
	) 
LANGUAGE SQL 
MODIFIES SQL DATA 
BEGIN 

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

	DECLARE v_sqlcode 		INTEGER ;
	DECLARE v_sqlcode1 		INTEGER ;  
	DECLARE SQLCODE			INTEGER DEFAULT 0; 

--============================================================================
--  Setup the EXIT Handle for all SQL Exceptions
--============================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	VALUES (SQLCODE) INTO v_sqlcode; 

--=============================================================================
--	Updating the Table T_TP_TRAN_AUTH
--=============================================================================

UPDATE EDIDB2A.T_TP_TRAN_AUTH SET TRAN_VER_NUM =p_TRAN_VER, DIR_IND = p_DIR, GS01_FUNCL_ID =p_FUNCL_ID_CD_GS01, LOB_IND =p_LOB, GS02_SNDR_CD =p_GS_SNDR_CD_GS02, GS03_RECR_CD =p_GS_RECR_CD_GS03, TECH_ACKN1_IND =p_ACTV_FLAG, GS07_RSPB_AGY_CD =p_RSPB_AGY_CD_GS07, C999_IND =p_FLAG_999, CLM_ACKN277_IND =p_FLAG_277CA, C997_IND =p_FLAG_997, ACTV_IND =p_FLAG_TA1, CMPL_LVL_CD =p_CMPL_LVL, UPDT_BY=P_UPDT_BY, UPDT_TS= current timestamp  WHERE TP_ID=p_TP_ID AND TP_QLFR_ID=p_TP_QLFR AND TRAN_NUM =p_TRAN_NUM AND TRAN_VER_NUM =P_TransVerUpdate AND DIR_IND = P_TransDirUpdate AND GS01_FUNCL_ID =p_Gs01Update; 

VALUES (SQLCODE) INTO v_sqlcode; 

--=============================================================================
--	Updating the Table T_TP_GS_CTRL_NUM
--=============================================================================

UPDATE EDIDB2A.T_TP_GS_CTRL_NUM SET GS_CTRL_NUM=p_GS_CTRL_NUM, ST_CTRL_NUM=p_ST_CTRL_NUM WHERE  TP_ID=p_TP_ID AND TRAN_NUM=p_TRAN_NUM  AND TP_QLFR_ID=p_TP_QLFR;

VALUES (SQLCODE) INTO v_sqlcode1; 

 IF (v_sqlcode = 0 AND v_sqlcode1 <> 0) THEN
  
      SET p_ERR_CODE = v_sqlcode1;
      SET p_ERR_DESC = 'Update successful to table T_TP_TRAN_AUTH and Not successful to table T_TP_GS_CTRL_NUM';
 	
 	ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 = 0) 	THEN
 
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Update not successful to table T_TP_TRAN_AUTH and successful to table T_TP_GS_CTRL_NUM';
      
    ELSEIF (v_sqlcode = 0 AND v_sqlcode1 = 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Update successful to tables T_TP_TRAN_AUTH and T_TP_GS_CTRL_NUM';
     
    ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 <> 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Update not successful to tables T_TP_TRAN_AUTH and T_TP_GS_CTRL_NUM';
  END IF;
END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_T_TP_UPDATE')@

CREATE PROCEDURE EDIDB2A.SP_UI_T_TP_UPDATE 
	( 
	IN 	p_TPID 						VARCHAR(40), 
	IN 	p_TPQLFR 					VARCHAR(2), 
	IN 	p_PRTNRNME 					VARCHAR(30), 
	IN 	p_PRTNRADR1 				VARCHAR(35), 
	IN 	p_PRTNRCY 					VARCHAR(30), 
	IN 	p_PRTNRSTT_CD 				VARCHAR(4), 
	IN 	p_PRTNRZIP_CD 				VARCHAR(9), 
	IN 	p_PRTNRCNTC_NME 			VARCHAR(9), 
	IN 	p_PRTNRCNTC_PH 				VARCHAR(13), 
	IN 	p_PRTNRCNTC_EMAIL 			VARCHAR(60), 
	IN 	p_PRTNRCNTC_PH_EXT 			VARCHAR(4), 
	IN 	p_ATHRINFO_QLFR_ISA01 		VARCHAR(2), 
	IN 	p_ATHRINFO_ISA02 			VARCHAR(10), 
	IN 	p_SECINFO_QLFR_ISA03 		VARCHAR(2), 
	IN 	p_SECINFO_ISA04 			VARCHAR(10), 
	IN 	p_SNDRQLFR_ISA05 			VARCHAR(2), 
	IN 	p_SNDRID_ISA06 				VARCHAR(15), 
	IN 	p_RECRQLFR_ISA07 			VARCHAR(2), 
	IN 	p_RECRID_ISA08 				VARCHAR(15), 
	IN 	p_VERNUM_ISA12 				VARCHAR(6), 
	IN 	p_ACKNRQ_ISA14 				VARCHAR(1), 
	IN 	p_USEIND_ISA15 				VARCHAR(1), 
	IN 	p_ELEDELIMITER 				VARCHAR(1), 
	IN 	p_SEGDELIMITER 				VARCHAR(1), 
	IN 	p_CMPNTELE_SEPARATOR_ISA16 	VARCHAR(1), 
	IN 	p_REPTSEPARATOR_ISA11 		VARCHAR(1),
	IN 	p_EDDIID 					VARCHAR(9), 
	IN 	p_CREABY 					VARCHAR(30), 
	IN 	p_ISACTRL_NUM 				INTEGER,
	OUT p_ERR_CODE					INTEGER,
	OUT p_ERR_DESC					VARCHAR(255)
	) 
LANGUAGE SQL 
MODIFIES SQL DATA 
BEGIN 

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

	DECLARE v_todayDate 	TIMESTAMP; 
	DECLARE v_sqlcode 		INTEGER ;
	DECLARE v_sqlcode1 		INTEGER ;  
	DECLARE SQLCODE			INTEGER DEFAULT 0; 

--============================================================================
--  Setup the EXIT Handle for all SQL Exceptions
--============================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	VALUES (SQLCODE) INTO v_sqlcode;

--=============================================================================
--	Setting the data into variable
--=============================================================================

	SET v_todayDate= CURRENT TIMESTAMP; 

--=============================================================================
--	Updating the Table T_TP
--=============================================================================

UPDATE 	EDIDB2A.T_TP SET TP_QLFR_ID = p_TPQLFR, PRTNR_NME = p_PRTNRNME, PRTNR_ADR_TXT = p_PRTNRADR1, PRTNR_CY_NME = p_PRTNRCY, PRTNR_STT_CD = p_PRTNRSTT_CD, PRTNR_ZIP_CD = p_PRTNRZIP_CD, PRTNR_CNTC_NME = p_PRTNRCNTC_NME, PRTNR_CNTC_PH_NUM = p_PRTNRCNTC_PH, PRTNR_CNTC_PH_EXT_NUM = p_PRTNRCNTC_PH_EXT, PRTNR_CNTC_EMAIL_ID = p_PRTNRCNTC_EMAIL, EDDI_ID = p_EDDIID, ISA01_ATHR_INFO_QLFR_CD = p_ATHRINFO_QLFR_ISA01, ISA02_ATHR_INFO_ID = p_ATHRINFO_ISA02, ISA03_SEC_INFO_QLFR_CD = p_SECINFO_QLFR_ISA03 , ISA04_SEC_INFO_ID = p_SECINFO_ISA04, ISA05_SNDR_QLFR_CD = p_SNDRQLFR_ISA05, ISA06_SNDR_ID = p_SNDRID_ISA06, ISA07_RECR_QLFR_CD = p_RECRQLFR_ISA07, ISA08_RECR_ID = p_RECRID_ISA08, ISA11_REPT_SEPRT_CD = p_REPTSEPARATOR_ISA11, ISA12_VER_NUM = p_VERNUM_ISA12, ISA14_ACKN_RQ_IND = p_ACKNRQ_ISA14, ISA15_USE_IND = p_USEIND_ISA15, ELE_DLTD_ID = p_ELEDELIMITER, SEG_DLTD_ID = p_SEGDELIMITER, ISA16_CMPNT_ELE_SEPRT_IND = p_CMPNTELE_SEPARATOR_ISA16, UPDT_BY = p_CREABY, UPDT_TS = v_todayDate WHERE TP_ID= p_TPID; 

VALUES (SQLCODE) INTO v_sqlcode;

--=============================================================================
--	Updating the Table T_TP_ISA_CTRL_NUM
--=============================================================================

UPDATE 	EDIDB2A.T_TP_ISA_CTRL_NUM SET ISA_CTRL_NUM = p_ISACTRL_NUM  WHERE TP_ID = p_TPID; 

VALUES (SQLCODE) INTO v_sqlcode1;

 IF (v_sqlcode = 0 AND v_sqlcode1 <> 0) THEN
  
      SET p_ERR_CODE = v_sqlcode1;
      SET p_ERR_DESC = 'Update successful to table T_TP and Not successful to table T_TP_ISA_CTRL_NUM';
 	
 	ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 = 0) 	THEN
 
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Update not successful to table T_TP and successful to table T_TP_ISA_CTRL_NUM';
      
    ELSEIF (v_sqlcode = 0 AND v_sqlcode1 = 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Update successful to tables T_TP and T_TP_ISA_CTRL_NUM';
     
    ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 <> 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Update not successful to tables T_TP_TRAN_AUTH and T_TP_ISA_CTRL_NUM';
  END IF;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_T_TP_EDIT')@

CREATE PROCEDURE EDIDB2A.SP_UI_T_TP_EDIT 
	( 
	INOUT 	p_TP_ID 					VARCHAR(40), 
	OUT		p_PRTNR_NME 				VARCHAR(30), 
	OUT		p_ELE_DELIMITER 			CHARACTER(1), 
	OUT		p_SEG_DELIMITER 			CHARACTER(1), 
	OUT		p_PRTNR_ADR1 				VARCHAR(35), 
	OUT		p_PRTNR_CY 					VARCHAR(30), 
	OUT		p_PRTNR_STT_CD 				VARCHAR(4), 
	OUT		p_PRTNR_ZIP_CD 				VARCHAR(9), 
	OUT		p_PRTNR_CNTC_NME 			VARCHAR(9), 
	OUT		p_PRTNR_CNTC_PH 			VARCHAR(13), 
	OUT		p_PRTNR_CNTC_PH_EXT 		VARCHAR(4), 
	OUT		p_PRTNR_CNTC_EMAIL 			VARCHAR(60), 
	OUT		p_EDDI_ID 					CHARACTER(9), 
	OUT		p_ATHR_INFO_QLFR_CD_ISA01 	VARCHAR(2), 
	OUT		p_ATHR_INFO_ISA02 			VARCHAR(10), 
	OUT		p_SEC_INFO_QLFR_ISA03 		VARCHAR(2), 
	OUT		p_SEC_INFO_ISA04 			VARCHAR(10), 
	OUT		p_SNDR_QLFR_ISA05 			VARCHAR(2), 
	OUT		p_SNDR_ID_ISA06 			VARCHAR(15), 
	OUT		p_ISA07_RECR_QLFR_CD 		VARCHAR(2), 
	OUT		p_RECR_ID_ISA08 			VARCHAR(15), 
	OUT		p_TP_QLFR 					VARCHAR(2) , 
	OUT		p_REPT_SEPARATOR_ISA11 		CHARACTER(1), 
	OUT		p_VER_NUM_ISA12 			VARCHAR(5), 
	OUT		p_ACKN_RQ_ISA14 			CHARACTER(1), 
	OUT		p_USE_IND_ISA15 			CHARACTER(1), 
	OUT		p_CMPNT_ELE_SEPARATOR_ISA16 CHARACTER(1), 
	OUT		p_CREA_BY 					VARCHAR(30), 
	OUT		p_UPDT_BY 					VARCHAR(30), 
	OUT 	p_DELETE_IND 				CHARACTER(1), 
	OUT 	p_ISA_CTRL_NUM 				INTEGER,
	OUT 	p_ERR_CODE					INTEGER,
	OUT 	p_ERR_DESC					VARCHAR(255)
	) 
LANGUAGE SQL 
MODIFIES SQL DATA 

BEGIN 

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

	DECLARE v_sqlcode 		INTEGER ;
	DECLARE v_sqlcode1 		INTEGER ;  
	DECLARE SQLCODE		INTEGER DEFAULT 0; 

--============================================================================
--  Setup the EXIT Handle for all SQL Exceptions
--============================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	VALUES (SQLCODE) INTO v_sqlcode; 

--=============================================================================
--	Retreiving the data from the Table T_TP based on TP_ID 
--=============================================================================

SELECT TP_ID, PRTNR_NME, ELE_DLTD_ID, SEG_DLTD_ID, PRTNR_ADR_TXT, PRTNR_CY_NME, PRTNR_STT_CD, PRTNR_ZIP_CD, PRTNR_CNTC_NME, PRTNR_CNTC_PH_NUM, PRTNR_CNTC_PH_EXT_NUM, PRTNR_CNTC_EMAIL_ID, EDDI_ID, ISA01_ATHR_INFO_QLFR_CD, ISA02_ATHR_INFO_ID, ISA03_SEC_INFO_QLFR_CD, ISA04_SEC_INFO_ID, ISA05_SNDR_QLFR_CD, ISA06_SNDR_ID, ISA07_RECR_QLFR_CD, ISA08_RECR_ID, TP_QLFR_ID, ISA11_REPT_SEPRT_CD, ISA12_VER_NUM, ISA14_ACKN_RQ_IND, ISA15_USE_IND, ISA16_CMPNT_ELE_SEPRT_IND, CREA_BY, UPDT_BY, DELETE_IND INTO p_TP_ID,p_PRTNR_NME,p_ELE_DELIMITER,p_SEG_DELIMITER,p_PRTNR_ADR1,p_PRTNR_CY,p_PRTNR_STT_CD,p_PRTNR_ZIP_CD,p_PRTNR_CNTC_NME,p_PRTNR_CNTC_PH,p_PRTNR_CNTC_PH_EXT,p_PRTNR_CNTC_EMAIL,p_EDDI_ID,p_ATHR_INFO_QLFR_CD_ISA01,p_ATHR_INFO_ISA02,p_SEC_INFO_QLFR_ISA03,p_SEC_INFO_ISA04,p_SNDR_QLFR_ISA05 ,p_SNDR_ID_ISA06,p_ISA07_RECR_QLFR_CD,p_RECR_ID_ISA08,p_TP_QLFR ,p_REPT_SEPARATOR_ISA11,p_VER_NUM_ISA12,p_ACKN_RQ_ISA14,p_USE_IND_ISA15,p_CMPNT_ELE_SEPARATOR_ISA16,p_CREA_BY,p_UPDT_BY,p_DELETE_IND FROM EDIDB2A.T_TP a WHERE a.TP_ID =p_TP_ID ; 

VALUES (SQLCODE) INTO v_sqlcode; 

--=============================================================================
--	Retreiving the data from the Table T_TP_ISA_CTRL_NUM b based on TP_ID
--=============================================================================

SELECT b.ISA_CTRL_NUM INTO p_ISA_CTRL_NUM FROM EDIDB2A.T_TP_ISA_CTRL_NUM b WHERE  b.TP_ID=p_TP_ID; 

VALUES (SQLCODE) INTO v_sqlcode1;

 IF (v_sqlcode = 0 AND v_sqlcode1 <> 0) THEN
  
      SET p_ERR_CODE = v_sqlcode1;
      SET p_ERR_DESC = 'Row retrieved from table T_TP and Not retrieved from table T_TP_ISA_CTRL_NUM';
 	
 	ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 = 0) 	THEN
 
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Row not retrieved from table T_TP and retrieved from table T_TP_ISA_CTRL_NUM';
      
    ELSEIF (v_sqlcode = 0 AND v_sqlcode1 = 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Row retrieved from tables T_TP and T_TP_ISA_CTRL_NUM';
     
    ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 <> 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Row not retrieved from tables T_TP and T_TP_ISA_CTRL_NUM';
  END IF;
END@


--=============================================================================
--	Procedure:	SP_WIP_INSERT
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP('PROCEDURE EDIDB2A.SP_WIP_INSERT')@

CREATE PROCEDURE EDIDB2A.SP_WIP_INSERT
(
	IN	p_TRAN_NUM		CHAR(9),
	IN	p_FILE_NME		VARCHAR(255),
	IN	p_FILE_ID		BIGINT,
	IN	p_ORIG_FILE_ID	BIGINT,
	IN	p_WIP_STT_CD	CHAR(1),
	IN	p_WIP_ACT_CD	CHAR(1),
	IN	p_CREATED_BY	VARCHAR(15),
	IN	p_RSUBM_PNT		CHAR(1),
	IN	p_PERF_DUP_CHK	CHAR(1),
	IN	p_CMT			VARCHAR(150),
	OUT	p_ID			BIGINT,
	OUT p_ERR_CODE		BIGINT, 
	OUT p_ERR_DESC		VARCHAR(255)
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN

	DECLARE SQLCODE 		INTEGER DEFAULT 0;
	DECLARE v_sqlcode 		INTEGER;

	--======================================================================
	--	Setup the EXIT handler for all SQL exceptions
	--======================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION VALUES (SQLCODE) INTO v_sqlcode;

	--================================================================================
	--	Retrieve the ID of the New Record added into the WIP Table 
	--================================================================================
	INSERT INTO EDIDB2A.T_WIP
				(TRAN_NUM,FILE_NME,FILE_ID,ORIG_FILE_ID,
				CREATED_BY,CREATED_TS,ASSIGNED_TO,
				RSUBM_PNT_CD,PERF_DUP_CHK_CD,
				WIP_STT_CD,WIP_ACT_CD,
				CMT) 
	VALUES 
				(p_TRAN_NUM,p_FILE_NME,p_FILE_ID,p_ORIG_FILE_ID,
				p_WIP_STT_CD,p_WIP_ACT_CD,
				p_CREATED_BY,CURRENT TIMESTAMP,p_CREATED_BY,
				p_RSUBM_PNT,p_PERF_DUP_CHK,
				p_CMT);
	--	Retrieve the ID of the Last Inserted records Primary Key
	SET p_ID = IDENTITY_VAL_LOCAL();

	VALUES (sqlcode) INTO v_sqlcode;

	--=============================================================
	-- Please set the p_flag value based on the sqlcode
	--=============================================================

	IF (v_sqlcode = 0) THEN
		-- If the record exist for this Sender ID then set p_flag is 1
		SET p_ERR_CODE = 0; 
		SET p_ERR_DESC = 'Successfully Inserted a Record into T_WIP::ID' || char(p_ID);
	ELSE
		-- For any sqlexceptions set p_flag is sqlcode
		SET p_ERR_CODE = v_sqlcode;
		SET p_ERR_DESC = 'Failed to insert a Record into the T_WIP::' || char(p_TRAN_NUM) || p_FILE_NME;
	END IF;

END@

CALL EDIDB2A.SP_UTIL_DROP('PROCEDURE EDIDB2A.SP_UI_T_TP_COPY_PROFILE')@


CREATE PROCEDURE EDIDB2A.SP_UI_T_TP_COPY_PROFILE
	(
	IN 	p_OLD_TPID 		VARCHAR(40),
	IN 	p_OLD_TPQLFRID 	VARCHAR(2),
	IN 	p_NEW_TPID 		VARCHAR(40),
	IN 	p_NEW_TPQLFRID 	VARCHAR(2),
	OUT p_ERR_CODE		INTEGER,
	OUT p_ERR_DESC		VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

	DECLARE v_count 			INTEGER;
	DECLARE v_count1 			INTEGER;
	DECLARE v_TP_ID 			VARCHAR(40);      
	DECLARE v_TP_QLFR_ID 		VARCHAR(2);       
	DECLARE v_TRAN_NUM 			VARCHAR(4);       
	DECLARE v_TRAN_VER_NUM 		VARCHAR(12);      
	DECLARE v_DIR_IND 			CHARACTER(1);       
	DECLARE v_GS01_FUNCL_ID 	VARCHAR(2);       
	DECLARE v_LOB_IND 			CHARACTER(1);        
	DECLARE v_GS02_SNDR_CD		VARCHAR(15);      
	DECLARE v_GS03_RECR_CD 		VARCHAR(15);      
	DECLARE v_TECH_ACKN1_IND 	CHARACTER(1);       
	DECLARE v_GS07_RSPB_AGY_CD 	VARCHAR(2);       
	DECLARE v_C999_IND 			CHARACTER(1);       
	DECLARE v_CLM_ACKN277_IND 	CHARACTER(1);       
	DECLARE v_C997_IND 			CHARACTER(1);       
	DECLARE v_ACTV_IND 			CHARACTER(1);       
	DECLARE v_CMPL_LVL_CD 		CHARACTER(1);       
	DECLARE v_CMPL_RPT_IND 		CHARACTER(1);       
	DECLARE v_UPDT_BY 			VARCHAR(30);      
	DECLARE v_UPDT_TS 			TIMESTAMP;      
	DECLARE v_CREA_BY 			VARCHAR(30);      
	DECLARE v_CREA_TS 			TIMESTAMP;
	DECLARE v_GS_CTRL_NUM 		INTEGER;
	DECLARE v_ST_CTRL_NUM		INTEGER;
	DECLARE v_sqlcode	 		INTEGER ;
	DECLARE v_sqlcode1 			INTEGER ;  
	DECLARE SQLCODE				INTEGER DEFAULT 0;
	
--============================================================================
--  Declaring cursor TRANS_AUTH_LIST_COPY_CURSR for trans_auth_copy
--============================================================================

DECLARE TRANS_AUTH_LIST_COPY_CURSR CURSOR FOR select TRAN_NUM,TRAN_VER_NUM,DIR_IND,GS01_FUNCL_ID,LOB_IND,GS02_SNDR_CD,GS03_RECR_CD,TECH_ACKN1_IND,GS07_RSPB_AGY_CD,C999_IND,CLM_ACKN277_IND,C997_IND,ACTV_IND,CMPL_LVL_CD,CMPL_RPT_IND,UPDT_BY,UPDT_TS,CREA_BY,CREA_TS from EDIDB2A.T_TP_TRAN_AUTH where TP_ID=P_OLD_TPID and TP_QLFR_ID=P_OLD_TPQLFRID;

--============================================================================
--  Declaring cursor GS_CNRL_NUM_COPY_CURSR for Gs_Cntrl_Num_Copy
--============================================================================

DECLARE GS_CNRL_NUM_COPY_CURSR CURSOR FOR SELECT TRAN_NUM,GS_CTRL_NUM,ST_CTRL_NUM 
	FROM EDIDB2A.T_TP_GS_CTRL_NUM WHERE TP_ID=P_OLD_TPID and TP_QLFR_ID=P_OLD_TPQLFRID;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (SQLCODE) INTO v_sqlcode ;
--============================================================================
--  These two statements take the count of No of Records in each table
--============================================================================	

SELECT COUNT(*) INTO v_count from EDIDB2A.T_TP_TRAN_AUTH where TP_ID=P_OLD_TPID and TP_QLFR_ID=P_OLD_TPQLFRID;
SELECT COUNT(*) INTO v_count1 from EDIDB2A.T_TP_GS_CTRL_NUM where TP_ID=P_OLD_TPID and TP_QLFR_ID=P_OLD_TPQLFRID;

--=============================================================================
--	Opening the cursor TRANS_AUTH_LIST_COPY_CURSR
--=============================================================================

	OPEN TRANS_AUTH_LIST_COPY_CURSR;
	
	WHILE (v_count <> 0) DO
	FETCH FROM TRANS_AUTH_LIST_COPY_CURSR INTO
	v_TRAN_NUM,
	v_TRAN_VER_NUM ,
	v_DIR_IND ,
	v_GS01_FUNCL_ID ,
	v_LOB_IND,        
	v_GS02_SNDR_CD ,
	v_GS03_RECR_CD ,      
	v_TECH_ACKN1_IND ,
	v_GS07_RSPB_AGY_CD ,       
	v_C999_IND ,
	v_CLM_ACKN277_IND ,       
	v_C997_IND,
	v_ACTV_IND ,       
	v_CMPL_LVL_CD , 
	v_CMPL_RPT_IND ,       
	v_UPDT_BY , 
	v_UPDT_TS ,      
	v_CREA_BY ,
	v_CREA_TS ;--

	VALUES (SQLCODE) INTO v_sqlcode ;
	
--=============================================================================
--	Inserting Data into the Table T_TP_TRAN_AUTH
--=============================================================================

INSERT INTO EDIDB2A.T_TP_TRAN_AUTH
	(TP_ID, TP_QLFR_ID, TRAN_NUM, TRAN_VER_NUM, DIR_IND, GS01_FUNCL_ID, LOB_IND, GS02_SNDR_CD, GS03_RECR_CD, TECH_ACKN1_IND, GS07_RSPB_AGY_CD, C999_IND, CLM_ACKN277_IND, C997_IND, ACTV_IND, CMPL_LVL_CD, CMPL_RPT_IND, UPDT_BY, UPDT_TS, CREA_BY, CREA_TS)
VALUES (P_NEW_TPID,P_NEW_TPQLFRID,v_TRAN_NUM,v_TRAN_VER_NUM,v_DIR_IND,v_GS01_FUNCL_ID,v_LOB_IND,v_GS02_SNDR_CD,v_GS03_RECR_CD,v_TECH_ACKN1_IND,v_GS07_RSPB_AGY_CD,v_C999_IND,v_CLM_ACKN277_IND,v_C997_IND,v_ACTV_IND,v_CMPL_LVL_CD,v_CMPL_RPT_IND,v_UPDT_BY,v_UPDT_TS,v_CREA_BY,v_CREA_TS);

	VALUES (SQLCODE) INTO v_sqlcode ;

	SET v_count = v_count - 1;--
	END WHILE;

--=============================================================================
--	Closing the cursor TRANS_AUTH_LIST_COPY_CURSR
--=============================================================================

--CLOSE TRANS_AUTH_LIST_COPY_CURSR;

--=============================================================================
--	Opening the cursor GS_CNRL_NUM_COPY_CURSR
--=============================================================================

	OPEN GS_CNRL_NUM_COPY_CURSR;
	
	WHILE (v_count1 <> 0) do
	
	FETCH FROM GS_CNRL_NUM_COPY_CURSR INTO 
	v_TRAN_NUM,
	v_GS_CTRL_NUM,
	v_ST_CTRL_NUM;--
	
	VALUES (SQLCODE) INTO v_sqlcode1 ;
					
	INSERT INTO EDIDB2A.T_TP_GS_CTRL_NUM
	(TP_ID, TP_QLFR_ID, TRAN_NUM, GS_CTRL_NUM, ST_CTRL_NUM)
	VALUES 
	(P_NEW_TPID,P_NEW_TPQLFRID,v_TRAN_NUM,v_GS_CTRL_NUM,v_ST_CTRL_NUM);
	
	VALUES (SQLCODE) INTO v_sqlcode1 ;
		
	SET v_count1 = v_count1 - 1;--
	END WHILE;

--=============================================================================
--	Closing the cursor GS_CNRL_NUM_COPY_CURSR
--=============================================================================

	--CLOSE GS_CNRL_NUM_COPY_CURSR;
	
	IF (v_sqlcode = 0 AND v_sqlcode1 <> 0) THEN
  
      SET p_ERR_CODE = v_sqlcode1;
      SET p_ERR_DESC = 'Row inserted into table T_TP_TRAN_AUTH and insertion failed into table T_TP_GS_CTRL_NUM';
 	
 	ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 = 0) THEN
 
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Insertion failed into table table T_TP_TRAN_AUTH and inserted into table T_TP_GS_CTRL_NUM';
      
    ELSEIF (v_sqlcode = 0 AND v_sqlcode1 = 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Rows inserted into tables T_TP_TRAN_AUTH and T_TP_GS_CTRL_NUM';
     
    ELSEIF (v_sqlcode <> 0 AND v_sqlcode1 <> 0) THEN
    
      SET p_ERR_CODE = v_sqlcode ;
      SET p_ERR_DESC = 'Rows insertion failed into tables T_TP_TRAN_AUTH and T_TP_GS_CTRL_NUM';
	END IF;
	
	CLOSE TRANS_AUTH_LIST_COPY_CURSR;
	CLOSE GS_CNRL_NUM_COPY_CURSR;
	
END@

