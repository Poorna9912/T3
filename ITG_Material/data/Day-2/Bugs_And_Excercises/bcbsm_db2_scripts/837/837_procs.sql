
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_EXTRACT_DESTINATIONS')@

CREATE PROCEDURE EDIDB2A.SP_837_EXTRACT_DESTINATIONS (
    OUT p_dest_list		VARCHAR(100),
    OUT p_dest_count	INTEGER,
    OUT p_err_code 		BIGINT,
	OUT p_err_desc 		VARCHAR(255)
	)
	
  LANGUAGE SQL
  MODIFIES SQL DATA
  
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
DECLARE v_dest_list VARCHAR(1000);
DECLARE v_dest_ID VARCHAR(30);
DECLARE v_count INTEGER;

DECLARE DEST_CURSR  CURSOR FOR 
	SELECT DISTINCT(DEST_ID) 
	FROM EDIDB2A.T_837_CLM_CTRL_LOG 
	WHERE CLM_STT_CD = '10052' AND DEST_ID <> '';

	SET v_dest_list= ' ';
--=============================================================================
--	Find the Number of rows Retrieved from the table T_837_CLM_CTRL_LOG based on
-- CLM_STT_CD and DEST_ID
--=============================================================================
	SELECT COUNT(DISTINCT(DEST_ID)) INTO v_count 
		FROM EDIDB2A.T_837_CLM_CTRL_LOG 
		WHERE 	CLM_STT_CD = '10052' 
				AND DEST_ID <> '';
				
	SET p_dest_count=v_count;
	OPEN DEST_CURSR;
		WHILE (v_count <> 0)
		DO 
--=============================================================================
--  Fetch from the cursor into the variable declared           --=============================================================================
			FETCH FROM DEST_CURSR INTO v_dest_ID;
			SET v_dest_list=v_dest_list||'^'||v_dest_ID;
			SET v_count=v_count-1;
		END WHILE;
	CLOSE DEST_CURSR;
	SET p_dest_list=v_dest_list || '^';
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_EDI_ISA')@

CREATE PROCEDURE EDIDB2A.SP_837_GET_EDI_ISA
( IN p_ISA_ID 		   BIGINT,
 OUT p_ISA_outBuffer   VARCHAR(4000), 
 OUT p_ERR_CODE 	   BIGINT,
 OUT p_ERR_DESC 	   VARCHAR(255))
 
  BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
  DECLARE v_ISA_ID  				BIGINT;
  DECLARE v_ATHR_INFO_QLFR_CD  	    VARCHAR(2);
  DECLARE v_ATHR_INFO_ID  		    VARCHAR(10); 
  DECLARE v_SEC_INFO_QLFR_CD 		VARCHAR(2); 
  DECLARE v_SEC_INFO_ID 			VARCHAR(10); 
  DECLARE v_ISA_SNDR_QLFR_CD  	    VARCHAR(2);
  DECLARE v_ISA_SNDR_ID  			VARCHAR(15);
  DECLARE v_ISA_RECR_QLFR_CD  	    VARCHAR(2);
  DECLARE v_ISA_RECR_ID  			VARCHAR(15);
  DECLARE v_ISA_CREA_DT  			VARCHAR(20); 
  DECLARE v_ISA_CREA_TME 			VARCHAR(4); 
  DECLARE v_REPT_SEPRT_IND 		    CHAR(1); 
  DECLARE v_VER_NUM  				VARCHAR(15); 
  DECLARE v_ISA_CTRL_NUM  		    INTEGER; 
  DECLARE v_ACKN_RQ_IND  			CHAR(1); 
  DECLARE v_USE_IND  				CHAR(1); 
  DECLARE v_CMPNT_ELE_SEPRT_IND     VARCHAR(1); 
  DECLARE v_COUNT                   INTEGER;
  DECLARE v_ISA_CTRL_NUM_CHAR       VARCHAR(9);
  
  
--=============================================================================
--	Retreiving the Data from the Table T_837_ISA based on ISA_ID
--=============================================================================

SELECT ISA_ID,ATHR_INFO_QLFR_CD,ATHR_INFO_ID, SEC_INFO_QLFR_CD,
       SEC_INFO_ID, ISA_SNDR_QLFR_CD, ISA_SNDR_ID,ISA_RECR_QLFR_CD,
       ISA_RECR_ID,    EDIDB2A.EDIDATE_YYMMDD(ISA_CREA_DT),
       EDIDB2A.EDITIME_HHMM(TIME(ISA_CREA_TS)), REPT_SEPRT_IND,
       VER_NUM,ISA_CTRL_NUM,ACKN_RQ_IND, USE_IND,CMPNT_ELE_SEPRT_IND
       INTO 
       v_ISA_ID,v_ATHR_INFO_QLFR_CD,v_ATHR_INFO_ID,v_SEC_INFO_QLFR_CD,v_SEC_INFO_ID,
       v_ISA_SNDR_QLFR_CD,v_ISA_SNDR_ID,v_ISA_RECR_QLFR_CD,v_ISA_RECR_ID,v_ISA_CREA_DT,
       v_ISA_CREA_TME,v_REPT_SEPRT_IND,v_VER_NUM,v_ISA_CTRL_NUM,v_ACKN_RQ_IND,v_USE_IND,
       v_CMPNT_ELE_SEPRT_IND FROM EDIDB2A.T_837_ISA WHERE ISA_ID = p_ISA_ID;
       
       SET v_COUNT =  LENGTH(v_ISA_CTRL_NUM);
	   
	   IF ( v_COUNT < 9) THEN
	   
	   SELECT SUBSTR(CHAR((v_ISA_CTRL_NUM)+1000000000),2,10) INTO v_ISA_CTRL_NUM_CHAR  FROM SYSIBM.SYSDUMMY1;
	     
	   
       END IF;
       
       SET p_ISA_outBuffer = v_ATHR_INFO_QLFR_CD||'*'||v_ATHR_INFO_ID||'*'||v_SEC_INFO_QLFR_CD ||'*'||
       v_SEC_INFO_ID ||'*'||v_ISA_SNDR_QLFR_CD  ||'*'||v_ISA_SNDR_ID ||'*'||v_ISA_RECR_QLFR_CD ||'*'||
       v_ISA_RECR_ID ||'*'||v_ISA_CREA_DT ||'*'||v_ISA_CREA_TME  ||'*'||v_REPT_SEPRT_IND ||'*'||
       v_VER_NUM ||'*'|| v_ISA_CTRL_NUM_CHAR ||'*'||v_ACKN_RQ_IND||'*'||v_USE_IND ||'*'||v_CMPNT_ELE_SEPRT_IND;
        
       END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_EDI_GS')@

CREATE PROCEDURE EDIDB2A.SP_837_GET_EDI_GS(
	IN p_GS_ID 		BIGINT, 
	OUT p_GS_outBuffer VARCHAR(4000),
	OUT p_ERR_CODE 		BIGINT,
	OUT p_ERR_DESC 		VARCHAR(255))
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_GS_ID 		   BIGINT;
	DECLARE v_FUNCL_CD  	   VARCHAR(2);
	DECLARE v_GS_SNDR_CD       VARCHAR(15);
	DECLARE v_GS_RECR_CD  	   VARCHAR(15);
	DECLARE v_GS_DT  	       VARCHAR(10);
	DECLARE v_GS_TME  	       VARCHAR(4);
	DECLARE v_GS_CTRL_NUM  	   INTEGER;
	DECLARE v_RSPB_AGY_CD  	   VARCHAR(2);
	DECLARE v_VER_NUM          VARCHAR(12);
	DECLARE v_COUNT             INTEGER;
    DECLARE v_GS_CTRL_NUM_CHAR      VARCHAR(9);
--=============================================================================
--	Retreiving the Data from the Table T_837_GS based on GS_ID
--=============================================================================
	SELECT 
		GS_ID,	FUNCL_CD,   GS_SNDR_CD,	    GS_RECR_CD,
		EDIDB2A.EDIDATE_CCYYMMDD(GS_DT),
		EDIDB2A.EDITIME_HHMM(GS_TME),
		GS_CTRL_NUM ,    RSPB_AGY_CD,  VER_NUM        		
	INTO
		v_GS_ID,	v_FUNCL_CD,   v_GS_SNDR_CD,	 v_GS_RECR_CD, v_GS_DT,
		v_GS_TME,   v_GS_CTRL_NUM ,	 v_RSPB_AGY_CD,	 v_VER_NUM         
	FROM
		EDIDB2A.T_837_GS
	WHERE
		GS_ID = p_GS_ID;
		
		SET v_COUNT =  LENGTH(v_GS_CTRL_NUM);
	   
	   IF ( v_COUNT < 9) THEN
	   
	   SELECT SUBSTR(CHAR((v_GS_CTRL_NUM)+1000000000),2,10) INTO v_GS_CTRL_NUM_CHAR FROM SYSIBM.SYSDUMMY1;
	     
	   
       END IF;

	SET p_GS_outBuffer = 
		v_FUNCL_CD     ||'*'||v_GS_SNDR_CD    ||'*'||v_GS_RECR_CD  ||'*'||v_GS_DT     
        ||'*'||v_GS_TME ||'*'||v_GS_CTRL_NUM_CHAR  ||'*'||v_RSPB_AGY_CD ||'*'||v_VER_NUM;
				
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_EDI_ST')@

CREATE PROCEDURE EDIDB2A.SP_837_GET_EDI_ST(
	IN 	p_ST_ID 			BIGINT, 
	OUT p_ST_outBuffer 	VARCHAR(4000),
	OUT p_ERR_CODE 		BIGINT,
	OUT p_ERR_DESC 		VARCHAR(255))
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_ST_ID  		     BIGINT;
	DECLARE v_REF_ID             VARCHAR(50);
	DECLARE v_BHT_DT  	       	 DATE;
	DECLARE v_BHT_DT1  	       	 VARCHAR(10);
	DECLARE v_BHT_TS			 TIMESTAMP;
	DECLARE v_BHT_TS1			 VARCHAR(6);
	DECLARE v_SUBM_LST_NME  	 VARCHAR(60);
	DECLARE v_SUBM_FST_NME  	 VARCHAR(35);
	DECLARE v_SUBM_MID_NME  	 VARCHAR(25);
	DECLARE v_SUBM_ID  			 VARCHAR(80);
	DECLARE v_QLFR_SUBM_CD       VARCHAR(2);
	DECLARE v_RECR_LST_NME       VARCHAR(60);
	DECLARE v_QLFR_RECR_CD  	 VARCHAR(2);
	DECLARE v_RECR_ID 		     VARCHAR(80);
	DECLARE v_TRAN_CD 	         VARCHAR(3);
	DECLARE v_TRAN_SET_CTRL_NUM  INTEGER ;
	DECLARE v_TRAN_SET_PURP_CD   VARCHAR(2);
	DECLARE v_FILE_ID  		     BIGINT;
	DECLARE v_ISA_ID 			 BIGINT;
	DECLARE v_GS_ID 			 BIGINT;
	DECLARE v_CNTC_FUNC_CD 		 VARCHAR(2); 
	DECLARE v_QLFR_COMM_NUM  	 VARCHAR(2);
	DECLARE v_COMM_NUM           VARCHAR(256);
	DECLARE v_COUNT              INTEGER;
	DECLARE v_TRAN_SET_CTRL_NUM_CHAR VARCHAR(9);
	DECLARE v_SQLCODE 			INTEGER;
	DECLARE SQLCODE 			INTEGER DEFAULT 0;

--=============================================================================
--	SET UP EXIT HANDLER FOR ALL SQL QUERIES
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_SQLCODE;

--=============================================================================
--	Retreiving the Data from the Table T_837_ST based on ST_ID
--=============================================================================

	SELECT 
		ST_ID,
		REF_ID,
		EDIDB2A.EDIDATE_CCYYMMDD(BHT_DT),
		EDIDB2A.EDITIME_HHMM(TIME(BHT_TS)),
		coalesce(SUBM_LST_NME,'        '),
		coalesce(SUBM_FST_NME,''),
        SUBM_MID_NME,
        SUBM_ID,	 
        QLFR_SUBM_CD,	   
        RECR_LST_NME,	  
        QLFR_RECR_CD,	
		RECR_ID,
		TRAN_CD,	 
		TRAN_SET_CTRL_NUM, 
		TRAN_SET_PURP_CD,
		CNTC_FUNC_CD,
        QLFR_COMM_NUM,   
		COMM_NUM
	INTO
		v_ST_ID,	       
		v_REF_ID,	       
		v_BHT_DT1, 
		v_BHT_TS1,	         
		v_SUBM_LST_NME,	  
		v_SUBM_FST_NME,     
		v_SUBM_MID_NME,	   
		v_SUBM_ID,	  
		v_QLFR_SUBM_CD,        
		v_RECR_LST_NME,		
		v_QLFR_RECR_CD,	    
		v_RECR_ID,         
		v_TRAN_CD,	  
		v_TRAN_SET_CTRL_NUM,   
		v_TRAN_SET_PURP_CD,         
		v_CNTC_FUNC_CD,        
		v_QLFR_COMM_NUM,   
		v_COMM_NUM
	FROM
		EDIDB2A.T_837_ST
	WHERE
		ST_ID = p_ST_ID;
	
	VALUES (SQLCODE) INTO v_SQLCODE;
	SET p_ERR_CODE = v_SQLCODE;
	IF (v_SQLCODE = 0) THEN
		--	Eliminated this code on Oct/17/2010 @ 13:51
		--	SET v_COUNT =  LENGTH(v_TRAN_SET_CTRL_NUM);
		--	IF ( v_COUNT < 9) THEN
		--		SELECT SUBSTR(CHAR((v_TRAN_SET_CTRL_NUM)+1000000000),2,10) INTO v_TRAN_SET_CTRL_NUM_CHAR  FROM SYSIBM.SYSDUMMY1;
		--	END IF;

		SET p_ST_outBuffer = v_TRAN_CD ||'*'|| SUBSTR(CHAR((v_TRAN_SET_CTRL_NUM)+1000000000),2,10)  || '*' || '005010X222';
		SET p_ST_outBuffer = p_ST_outBuffer || '~' || chr(13) || chr(10);
		SET p_ST_outBuffer = p_ST_outBuffer || 'BHT' 
							||'*' || '0019' 
							||'*' || v_TRAN_SET_PURP_CD
							||'*' || v_REF_ID
							||'*' || v_BHT_DT1
							||'*' || v_BHT_TS1
							||'*' || 'CH';
	
		SET p_ST_outBuffer = p_ST_outBuffer || '~' || chr(13) || chr(10);
		SET p_ST_outBuffer = p_ST_outBuffer || 'NM1' 
							||'*'|| '41'
							||'*'|| '2'
							||'*'||	v_SUBM_LST_NME
							||'*'||	trim(v_SUBM_FST_NME)
							||'*'||	trim(v_SUBM_MID_NME)
							||'*'
							||'*'
							||'*'||	V_QLFR_SUBM_CD
							||'*'|| v_SUBM_ID;
	
		SET p_ST_outBuffer = p_ST_outBuffer || '~' || chr(13) || chr(10);
		SET p_ST_outBuffer = p_ST_outBuffer || 'PER'
							||'*'||v_CNTC_FUNC_CD
							||'*'||'PROCESSING DEPT'
							||'*'||v_QLFR_COMM_NUM
							||'*'|| v_COMM_NUM;	
												
		SET p_ST_outBuffer = p_ST_outBuffer || '~' || chr(13) || chr(10);
		SET p_ST_outBuffer = p_ST_outBuffer || 'NM1' 
							||'*'||'40'
							||'*'||'2'
							||'*'||v_RECR_LST_NME
							||'*'
							||'*'
							||'*'
							||'*'
							||'*'||v_QLFR_RECR_CD
							||'*'||v_RECR_ID;
	ELSE
		SET p_ERR_DESC = 'DB2::SP_837_GET_EDI_ST: DATA NOT FOUND. SQLCODE = ' || char(v_SQLCODE);
	END IF;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_EDI_BillingProvider')@

CREATE PROCEDURE EDIDB2A.SP_837_GET_EDI_BillingProvider(
			IN p_bpv_ID BIGINT, 
			OUT p_bpv_outBuffer VARCHAR(4000),
			OUT p_ERR_CODE 		BIGINT,
			OUT p_ERR_DESC 		VARCHAR(255)
)
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_NPI_ID        	VARCHAR(80);
	DECLARE v_PROV_ID 			BIGINT;
	DECLARE v_REF_ID 			VARCHAR(50);
	DECLARE v_ET_QLFR_IND 		CHARACTER(1);
	DECLARE v_FST_NME 			VARCHAR(35);
	DECLARE v_LST_NME 			VARCHAR(60);
	DECLARE v_MID_NME 			VARCHAR(25);
	DECLARE v_SFX_NME 			VARCHAR(10);
	DECLARE v_QLFR_ID			VARCHAR(2);
	DECLARE v_ADR1_TXT 			VARCHAR(55);
	DECLARE v_ADR2_TXT 			VARCHAR(55);
	DECLARE v_CY_NME 			VARCHAR(30);
	DECLARE v_STT_CD 			VARCHAR(2);
	DECLARE v_ZIP_CD 			VARCHAR(15);
	DECLARE v_CTRY_CD 			VARCHAR(3);
	DECLARE v_TAX_QLFR_CD 		VARCHAR(3);
	DECLARE v_TAX_ID 			VARCHAR(50);
	DECLARE v_LICE_QLFR1_CD 	CHARACTER(3);
	DECLARE v_LICE_ID1 			VARCHAR(50);
	DECLARE v_CNTC_NME 			VARCHAR(60);
	DECLARE v_CNTC_COMM_QLFR_CD VARCHAR(2);
	DECLARE v_CNTC_COMM_NUM 	VARCHAR(256);
	DECLARE v_CNTC_PAYR_ADR1_TXT VARCHAR(55);
	DECLARE v_CNTC_PAYR_ADR2_TXT VARCHAR(55);
	DECLARE v_CNTC_PAYR_CY_NME 	VARCHAR(30);
	DECLARE v_CNTC_PAYR_STT_CD	 VARCHAR(2);
	DECLARE v_CNTC_PAYR_ZIP_CD 	VARCHAR(15);
	DECLARE v_CNTC_PAYR_CTRY_CD VARCHAR(3);
	DECLARE v_FILE_ID 			BIGINT;
	DECLARE v_ISA_ID			BIGINT;
	DECLARE v_GS_ID 			BIGINT;
	DECLARE v_ST_ID				BIGINT;
	DECLARE v_LICE_QLFR2_CD 	VARCHAR(3);
	DECLARE v_LICE_ID2			VARCHAR(50);
	DECLARE v_PROV_ENTY_ID 		INTEGER;
	DECLARE v_CRNCY_CD 			VARCHAR(3);
	
	SET p_ERR_CODE = 0;
	
	IF(p_bpv_ID <= 0) THEN
		SET p_bpv_outBuffer='';--
	ELSE
--=============================================================================
--	Retreiving the Data from the Table T_837_PROV based on PROV_ID
--=============================================================================
		SELECT 
			NPI_ID,PROV_ID,REF_ID,
			ET_QLFR_IND,FST_NME,LST_NME,MID_NME,SFX_NME,QLFR_ID,
			ADR1_TXT,ADR2_TXT,CY_NME,
			STT_CD,ZIP_CD,CTRY_CD,
			TAX_QLFR_CD,TAX_ID,
			LICE_QLFR1_CD,LICE_ID1,
			CNTC_NME,CNTC_COMM_QLFR_CD,CNTC_COMM_NUM,
			CNTC_PAYR_ADR1_TXT,CNTC_PAYR_ADR2_TXT,CNTC_PAYR_CY_NME,
			CNTC_PAYR_STT_CD,CNTC_PAYR_ZIP_CD,CNTC_PAYR_CTRY_CD,
			FILE_ID,ISA_ID,GS_ID,ST_ID,
			LICE_QLFR2_CD,LICE_ID2,PROV_ENTY_ID,
			CRNCY_CD 
		INTO 
			v_NPI_ID,v_PROV_ID,v_REF_ID,
			v_ET_QLFR_IND,	v_FST_NME,	v_LST_NME,v_MID_NME,v_SFX_NME,v_QLFR_ID,
			v_ADR1_TXT,v_ADR2_TXT,v_CY_NME,
			v_STT_CD,v_ZIP_CD,v_CTRY_CD,
			v_TAX_QLFR_CD,v_TAX_ID,
			v_LICE_QLFR1_CD,v_LICE_ID1,
			v_CNTC_NME,v_CNTC_COMM_QLFR_CD,v_CNTC_COMM_NUM,
			v_CNTC_PAYR_ADR1_TXT,v_CNTC_PAYR_ADR2_TXT,v_CNTC_PAYR_CY_NME,
			v_CNTC_PAYR_STT_CD,v_CNTC_PAYR_ZIP_CD,v_CNTC_PAYR_CTRY_CD,
			v_FILE_ID,v_ISA_ID,v_GS_ID,v_ST_ID,
			v_LICE_QLFR2_CD,v_LICE_ID2,v_PROV_ENTY_ID,
			v_CRNCY_CD
		FROM 
			EDIDB2A.T_837_PROV 
		WHERE
			PROV_ID = p_bpv_ID;

		SET p_bpv_outBuffer = 
			trim(v_NPI_ID)||'*'||trim(CHAR(v_PROV_ID))||'*'||trim(v_REF_ID)
			||'*'||trim(v_ET_QLFR_IND)||'*'||trim(	v_FST_NME)||'*'||trim(v_LST_NME)||'*'||trim(v_MID_NME)||'*'||trim(v_SFX_NME)||'*'||trim(v_QLFR_ID)
			||'*'||trim(v_ADR1_TXT)||'*'||trim(v_ADR2_TXT)||'*'||trim(v_CY_NME)
			||'*'||trim(v_STT_CD)||'*'||trim(v_ZIP_CD)||'*'||trim(v_CTRY_CD)
			||'*'||trim(v_TAX_QLFR_CD)||'*'||trim(v_TAX_ID)
			||'*'||trim(v_LICE_QLFR1_CD)||'*'||trim(v_LICE_ID1)
			||'*'||trim(v_CNTC_NME)||'*'||trim(v_CNTC_COMM_QLFR_CD)||'*'||trim(v_CNTC_COMM_NUM)
			||'*'||trim(v_CNTC_PAYR_ADR1_TXT)||'*'||trim(v_CNTC_PAYR_ADR2_TXT)||'*'||trim(v_CNTC_PAYR_CY_NME)
			||'*'||trim(v_CNTC_PAYR_STT_CD)||'*'||trim(v_CNTC_PAYR_ZIP_CD)||'*'||trim(v_CNTC_PAYR_CTRY_CD)
			||'*'||trim(CHAR(v_FILE_ID))||'*'||trim(CHAR(v_ISA_ID))||'*'||trim(CHAR(v_GS_ID))||'*'||trim(CHAR(v_ST_ID))
			||'*'||trim(v_LICE_QLFR2_CD)||'*'||trim(v_LICE_ID2)||'*'||trim(CHAR(v_PROV_ENTY_ID))
			||'*'||trim(v_CRNCY_CD);
		
	END IF;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_EDI_SUBSCRIBER')@

CREATE PROCEDURE EDIDB2A.SP_837_GET_EDI_SUBSCRIBER( 
	IN 		P_SUBS_ID			BIGINT,
	OUT 	P_SUBS_OUTBUFFER	VARCHAR(3000),
	OUT 	p_ERR_CODE 			BIGINT,
	OUT 	p_ERR_DESC 			VARCHAR(255) 
)
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
     DECLARE v_SUBS_ID BIGINT; 
     DECLARE v_FILE_ID BIGINT; 
     DECLARE v_ISA_ID BIGINT; 
     DECLARE v_GS_ID BIGINT; 
     DECLARE v_ST_ID BIGINT; 
     DECLARE v_PROV_ID BIGINT; 
     DECLARE v_SUBS_FST_NME VARCHAR(35); 
     DECLARE v_SUBS_LST_NME VARCHAR(60); 
     DECLARE v_SUBS_MID_NME VARCHAR(25); 
     DECLARE v_BRTH_DT VARCHAR(10); 
     DECLARE v_GNDR_IND CHARACTER(1); 
     DECLARE v_SUBS_SSN_NUM VARCHAR(250); 
     DECLARE v_PAYR_RSP_SEQ_CD CHARACTER(1); 
     DECLARE v_REF_ID VARCHAR(50); 
     DECLARE v_INS_TYPE_CD VARCHAR(3); 
     DECLARE v_CLM_TYPE_CD VARCHAR(2); 
     DECLARE v_DTH_DT VARCHAR(10); 
     DECLARE v_WGT_CNT CHARACTER(10); 
     DECLARE v_PRGNT_IND CHARACTER(1); 
     DECLARE v_SFX_NME VARCHAR(10); 
     DECLARE v_SUBS_ADR1_TXT VARCHAR(55); 
     DECLARE v_SUBS_ADR2_TXT VARCHAR(55); 
     DECLARE v_SUBS_CY_NME VARCHAR(30); 
     DECLARE v_SUBS_STT_CD VARCHAR(2); 
     DECLARE v_SUBS_ZIP_CD VARCHAR(15); 
     DECLARE v_SUBS_CTRY_CD CHARACTER(3); 
     DECLARE v_PROP_CSLTY_CLM_NUM VARCHAR(50); 
     DECLARE v_PROP_CSLTY_CNTC_NME VARCHAR(60); 
     DECLARE v_PROP_CSLTY_CNTC_PH_NUM VARCHAR(256); 
     DECLARE v_PROP_CSLTY_CNTC_PH_EXT VARCHAR(256); 
     DECLARE v_PAYR_ID BIGINT; 
     DECLARE v_PAYR_NME VARCHAR(60); 
     DECLARE v_PAYR_QLFR_CD VARCHAR(2); 
     DECLARE v_PAYR_CD VARCHAR(80); 
     DECLARE v_PAYR_ADR1_TXT VARCHAR(55); 
     DECLARE v_PAYR_ADR2_TXT VARCHAR(55); 
     DECLARE v_PAYR_CY_NME VARCHAR(30); 
     DECLARE v_PAYR_STT_CD VARCHAR(2); 
     DECLARE v_PAYR_ZIP_CD VARCHAR(15); 
     DECLARE v_PAYR_CTRY_CD VARCHAR(3); 
     DECLARE v_PAYR_SECD_QLFR1_CD CHARACTER(3); 
     DECLARE v_PAYR_SECD_ID1 VARCHAR(50); 
     DECLARE v_PAYR_SECD_QLFR2_CD CHARACTER(3); 
     DECLARE v_PAYR_SECD_QLFR3_CD CHARACTER(3); 
     DECLARE v_PAYR_SECD_ID2 VARCHAR(50); 
     DECLARE v_PAYR_SECD_ID3 VARCHAR(50); 
     DECLARE v_BILL_PROV_SECD_QLFR1_CD VARCHAR(3); 
     DECLARE v_BILL_PROV_SECD_ID1 VARCHAR(50); 
     DECLARE v_BILL_PROV_SECD_QLFR2_CD VARCHAR(3); 
     DECLARE v_BILL_PROV_SECD_ID2 VARCHAR(50); 
     DECLARE v_PAT_CTRC_NUM VARCHAR(80); 
     DECLARE v_PAYR_IDN_QLFR_CD VARCHAR(2); 
     DECLARE v_INDI_REL_CD VARCHAR(2); 
     DECLARE v_IDN_QLFR_CD VARCHAR(2); 
     DECLARE v_ET_QLFR_IND CHARACTER(1); 
     DECLARE c_PAYR_ID VARCHAR(18) ; 

	SET p_ERR_CODE = 0;
    IF(p_subs_ID <=0) THEN 
     	SET p_subs_outBuffer='';--
 	ELSE
		SELECT coalesce(SUBS_FST_NME,''),coalesce(SUBS_LST_NME,''),coalesce(SUBS_MID_NME,''),
			EDIDB2A.EDIDATE_CCYYMMDD(BRTH_DT), coalesce(GNDR_IND,''),coalesce(SUBS_SSN_NUM,''), 
			coalesce(PAYR_RSP_SEQ_CD,''),coalesce(REF_ID ,''), coalesce(CLM_TYPE_CD,''), 
			EDIDB2A.EDIDATE_CCYYMMDD(DTH_DT), coalesce(WGT_CNT,''),coalesce(PRGNT_IND,''),
			coalesce(SFX_NME,''),coalesce(SUBS_ADR1_TXT,''), coalesce(SUBS_ADR2_TXT,''),
			coalesce(SUBS_CY_NME,''),coalesce(SUBS_STT_CD,''), coalesce(SUBS_ZIP_CD,''),
			coalesce(SUBS_CTRY_CD,''),coalesce(PROP_CSLTY_CLM_NUM,''), coalesce(PROP_CSLTY_CNTC_NME,''),	
			coalesce(PROP_CSLTY_CNTC_PH_NUM,''), coalesce(PROP_CSLTY_CNTC_PH_EXT,''), coalesce(INS_TYPE_CD,''),	
			coalesce(PAYR_NME,''),	coalesce(PAYR_QLFR_CD,''), coalesce(PAYR_CD,''),coalesce(PAYR_ADR1_TXT,''),	
			coalesce(PAYR_CY_NME,''), coalesce(PAYR_STT_CD,''),coalesce(PAYR_ZIP_CD,''),coalesce(PAYR_ADR2_TXT,''), 
			coalesce(PAYR_CTRY_CD,''),coalesce(PAYR_SECD_ID1,''),	coalesce(PAYR_SECD_QLFR1_CD,''), coalesce(PAYR_SECD_QLFR2_CD,''),
			coalesce(PAYR_SECD_ID2,''), coalesce(PAYR_SECD_QLFR3_CD,''),	coalesce(PAYR_SECD_ID3,''), coalesce(BILL_PROV_SECD_QLFR1_CD,''),
			coalesce(BILL_PROV_SECD_ID1,''), coalesce(BILL_PROV_SECD_QLFR2_CD,''),	coalesce(BILL_PROV_SECD_ID2,''), coalesce(FILE_ID,0),
			coalesce(ISA_ID,0), coalesce(GS_ID,0), coalesce(ST_ID,0), coalesce(PROV_ID,0),coalesce(SUBS_ID,0),coalesce(PAYR_ID,0), 
			coalesce(PAT_CTRC_NUM,''),	coalesce(PAYR_IDN_QLFR_CD,''),	coalesce(INDI_REL_CD,''), coalesce(ET_QLFR_IND,''),
			coalesce(IDN_QLFR_CD,'')
       INTO 
			v_SUBS_FST_NME,v_SUBS_LST_NME,v_SUBS_MID_NME,
			v_BRTH_DT,v_GNDR_IND,v_SUBS_SSN_NUM,
			v_PAYR_RSP_SEQ_CD,v_REF_ID,v_CLM_TYPE_CD,
			v_DTH_DT,v_WGT_CNT,v_PRGNT_IND,
			v_SFX_NME,v_SUBS_ADR1_TXT,v_SUBS_ADR2_TXT,
			v_SUBS_CY_NME,v_SUBS_STT_CD,v_SUBS_ZIP_CD,
			v_SUBS_CTRY_CD,v_PROP_CSLTY_CLM_NUM, v_PROP_CSLTY_CNTC_NME,
			v_PROP_CSLTY_CNTC_PH_NUM ,v_PROP_CSLTY_CNTC_PH_EXT, v_INS_TYPE_CD,
			v_PAYR_NME,v_PAYR_QLFR_CD,	  v_PAYR_CD,v_PAYR_ADR1_TXT,	
			v_PAYR_CY_NME, v_PAYR_STT_CD,	v_PAYR_ZIP_CD,	v_PAYR_ADR2_TXT,	
			v_PAYR_CTRY_CD,v_PAYR_SECD_ID1,	v_PAYR_SECD_QLFR1_CD, v_PAYR_SECD_QLFR2_CD, 
			v_PAYR_SECD_ID2,	v_PAYR_SECD_QLFR3_CD,	v_PAYR_SECD_ID3, v_BILL_PROV_SECD_QLFR1_CD,
			v_BILL_PROV_SECD_ID1,  v_BILL_PROV_SECD_QLFR2_CD,        v_BILL_PROV_SECD_ID2, v_FILE_ID,	
			v_ISA_ID,	v_GS_ID,	v_ST_ID,  v_PROV_ID,	v_SUBS_ID,	v_PAYR_ID, 
			v_PAT_CTRC_NUM, v_PAYR_IDN_QLFR_CD, v_INDI_REL_CD,	v_ET_QLFR_IND,
			v_IDN_QLFR_CD 
	   FROM	EDIDB2A.T_837_SUBS
	   WHERE	SUBS_ID = p_subs_ID;
       
		IF (v_PAYR_ID =0) THEN 
			SET c_PAYR_ID =''; 
		ELSE 
			SET c_PAYR_ID = CHAR(v_PAYR_ID); 
		END IF ;
		
		SET p_subs_outBuffer = trim(v_SUBS_FST_NME)	|| '*' ||trim(v_SUBS_LST_NME)|| '*' ||trim(v_SUBS_MID_NME)	|| '*' ||
         		   trim(v_BRTH_DT)	|| '*' || trim(v_GNDR_IND)	|| '*' ||trim(v_SUBS_SSN_NUM)	|| '*' || trim(char(v_SUBS_ID))	|| '*' ||
         		   trim(v_PAYR_RSP_SEQ_CD)	|| '*' ||	trim(v_REF_ID) || '*' || trim(v_CLM_TYPE_CD)	|| '*' ||
         		   trim(v_DTH_DT)	|| '*' || trim(v_WGT_CNT)	|| '*' || trim(v_PRGNT_IND)	|| '*' ||	trim(v_SFX_NME)|| '*' ||
         		   trim(v_SUBS_ADR1_TXT)|| '*' || trim(v_SUBS_ADR2_TXT)|| '*' ||		trim(v_SUBS_CY_NME)|| '*' ||
         		   trim(v_SUBS_STT_CD)|| '*' || trim(v_SUBS_ZIP_CD)	|| '*' ||	trim(v_SUBS_CTRY_CD)|| '*' ||	
         		   trim(v_PROP_CSLTY_CLM_NUM)|| '*' || trim(v_PROP_CSLTY_CNTC_NME)	|| '*' ||	
         		   trim(v_PROP_CSLTY_CNTC_PH_NUM)|| '*' || trim(v_PROP_CSLTY_CNTC_PH_EXT)|| '*' || trim(v_INS_TYPE_CD)	|| '*' ||	
         		   trim(v_PAYR_NME)	|| '*' ||	trim(v_PAYR_QLFR_CD)	|| '*' || trim(v_PAYR_CD)	|| '*' ||trim(v_PAYR_ADR1_TXT)	|| '*' ||	
         		   trim(v_PAYR_CY_NME)|| '*' || trim(v_PAYR_STT_CD)	|| '*' ||	trim(v_PAYR_ZIP_CD)|| '*' ||	
         		   trim(v_PAYR_ADR2_TXT)|| '*' || trim(v_PAYR_CTRY_CD)	|| '*' ||  trim(v_PAYR_SECD_QLFR1_CD)	|| '*' ||	
         		   trim(v_PAYR_SECD_ID1)|| '*' || trim(v_PAYR_SECD_QLFR2_CD)	|| '*' ||	trim(v_PAYR_SECD_QLFR3_CD)|| '*' || 
         		   trim(v_PAYR_SECD_ID2)	|| '*' || trim(v_PAYR_SECD_ID3)|| '*' || trim(v_BILL_PROV_SECD_QLFR1_CD)	|| '*' ||	
         		   trim(v_BILL_PROV_SECD_QLFR2_CD) || '*' || 	trim(v_BILL_PROV_SECD_ID1)|| '*' ||	trim(v_BILL_PROV_SECD_ID2)|| '*' || 
         		   trim(c_PAYR_ID)	|| '*' || trim(char(v_FILE_ID))	|| '*' ||	trim(char(v_ISA_ID))|| '*' ||trim(char(v_GS_ID))|| '*' || 
         		   trim(char(v_ST_ID))|| '*' ||	trim(char(v_PROV_ID))|| '*' ||trim(v_PAT_CTRC_NUM)	|| '*' || 
         		   trim(v_PAYR_IDN_QLFR_CD)	|| '*' ||trim(v_INDI_REL_CD)	|| '*' ||	trim(v_ET_QLFR_IND)|| '*' || trim(v_IDN_QLFR_CD); 
	END IF; 
END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_EDI_PATIENT')@	

CREATE PROCEDURE EDIDB2A.SP_837_GET_EDI_PATIENT
( IN p_pat_ID 		  BIGINT,
  OUT p_pat_outBuffer VARCHAR(3000), 
  OUT p_ERR_CODE 		BIGINT, 
  OUT p_ERR_DESC 		VARCHAR(255) )
  
  BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================  
  DECLARE v_PAT_ALT_ID BIGINT ;
  DECLARE v_PAT_FST_NME VARCHAR(35);
  DECLARE v_PAT_LST_NME VARCHAR(60); 
  DECLARE v_PAT_MID_NME VARCHAR(25); 
  DECLARE v_BRTH_DT VARCHAR(10); 
  DECLARE v_GNDR_CD VARCHAR(25); 
  DECLARE v_PAT_SSN_NUM VARCHAR(80);
  DECLARE v_PAT_ID BIGINT; 
  DECLARE v_PAT_ACCT_NUM VARCHAR(30); 
  DECLARE v_SUBS_IND CHAR(1); 
  DECLARE v_REL_CD CHAR(2); 
  DECLARE v_DTH_DT VARCHAR(10); 
  DECLARE v_WGT_CNT CHARACTER(10); 
  DECLARE v_PRGNT_IND CHARACTER(1); 
  DECLARE v_SFX_NME VARCHAR(10); 
  DECLARE v_ADR1_TXT VARCHAR(55); 
  DECLARE v_ADR2_TXT VARCHAR(55); 
  DECLARE v_CY_NME VARCHAR(30); 
  DECLARE v_STT_CD CHARACTER(2); 
  DECLARE v_ZIP_CD VARCHAR(15); 
  DECLARE v_CTRY_CD VARCHAR(3); 
  DECLARE v_PROP_CSLTY_CLM_NUM VARCHAR(50); 
  DECLARE v_PROP_CSLTY_CNTC_NME VARCHAR(60); 
  DECLARE v_PROP_CSLTY_CNTC_PH_NUM VARCHAR(256); 
  DECLARE v_PROP_CSLTY_CNTC_PH_EXT VARCHAR(256); 
  DECLARE v_ISA_ID BIGINT; 
  DECLARE v_GS_ID BIGINT; 
  DECLARE v_ST_ID BIGINT; 
  DECLARE v_PROV_ID BIGINT; 
  DECLARE v_SUBS_ID BIGINT; 
	DECLARE v_FILE_ID BIGINT; 

	SET p_ERR_CODE = 0;
	IF(p_pat_ID = 0) THEN 
		SET p_pat_outBuffer='0'; 
	ELSE 
	--=============================================================================
	--	Retreiving the Data from the Table T_837_PAT based on PAT_ID
	--=============================================================================
		SELECT 
			PAT_ALT_ID, 		PAT_FST_NME, 		PAT_LST_NME,		PAT_MID_NME, 
			EDIDB2A.EDIDATE_CCYYMMDD(BRTH_DT),	GNDR_CD, 
			coalesce(PAT_SSN_NUM,''), 	coalesce(PAT_ID,0), 			coalesce(PAT_ACCT_NUM,''), 
			SUBS_IND, 				REL_CD, 						EDIDB2A.EDIDATE_CCYYMMDD(DTH_DT), 
			coalesce(WGT_CNT,''), 		PRGNT_IND, 	SFX_NME, 
			ADR1_TXT, 				ADR2_TXT, 	CY_NME, 			STT_CD, 
			ZIP_CD, 					CTRY_CD, 
			PROP_CSLTY_CLM_NUM, 					PROP_CSLTY_CNTC_NME,
			PROP_CSLTY_CNTC_PH_NUM, 				PROP_CSLTY_CNTC_PH_EXT, 
			coalesce(ISA_ID,0), coalesce(GS_ID,0),		coalesce(ST_ID,0),	coalesce(PROV_ID,0),
			coalesce(SUBS_ID,0),coalesce(FILE_ID,0) 
		INTO 
			v_PAT_ALT_ID,	v_PAT_FST_NME,		v_PAT_LST_NME,	v_PAT_MID_NME,
			v_BRTH_DT,		v_GNDR_CD,
			v_PAT_SSN_NUM,	v_PAT_ID,			v_PAT_ACCT_NUM,
			v_SUBS_IND,		v_REL_CD,			v_DTH_DT,
			v_WGT_CNT,		v_PRGNT_IND,			v_SFX_NME,
			v_ADR1_TXT,		v_ADR2_TXT,			v_CY_NME,		v_STT_CD,
			v_ZIP_CD,		v_CTRY_CD,
			v_PROP_CSLTY_CLM_NUM,				v_PROP_CSLTY_CNTC_NME,
			v_PROP_CSLTY_CNTC_PH_NUM,			v_PROP_CSLTY_CNTC_PH_EXT,
			v_ISA_ID,		v_GS_ID,				v_ST_ID,			v_PROV_ID,
			v_SUBS_ID,v_FILE_ID
		FROM EDIDB2A.T_837_PAT 
		WHERE PAT_ID = p_pat_ID;
		
		SET p_pat_outBuffer= coalesce(trim(CHAR(v_PAT_ALT_ID)),'') ||'*'|| coalesce(trim(v_PAT_FST_NME),'') ||'*'|| coalesce(trim(v_PAT_LST_NME),'') ||'*'|| coalesce(trim(v_PAT_MID_NME),'')
                         ||'*'|| coalesce(trim(v_BRTH_DT),'') ||'*'|| coalesce(trim(v_GNDR_CD),'') ||'*'|| coalesce(trim(v_PAT_SSN_NUM),'') ||'*'|| coalesce(trim(char(v_PAT_ID)),'')
                         ||'*'|| coalesce(trim(v_PAT_ACCT_NUM),'') ||'*'|| coalesce(trim(v_SUBS_IND),'') ||'*'|| coalesce(trim(v_REL_CD),'') ||'*'|| coalesce(trim(v_DTH_DT),'')
                         ||'*'|| coalesce(trim(v_WGT_CNT),'') ||'*'|| coalesce(trim(v_PRGNT_IND),'') ||'*'|| coalesce(trim(v_SFX_NME),'') ||'*'|| coalesce(trim(v_ADR1_TXT),'') 
                         ||'*'|| coalesce(trim(v_ADR2_TXT),'') ||'*'|| coalesce(trim(v_CY_NME),'') ||'*'|| coalesce(trim(v_STT_CD),'') ||'*'|| coalesce(trim(v_ZIP_CD),'') 
                         ||'*'|| coalesce(trim(v_CTRY_CD),'') ||'*'|| coalesce(trim(v_PROP_CSLTY_CLM_NUM),'') ||'*'|| coalesce(trim(v_PROP_CSLTY_CNTC_NME),'') 
                         ||'*'|| coalesce(trim(v_PROP_CSLTY_CNTC_PH_NUM),'') ||'*'|| coalesce(trim(v_PROP_CSLTY_CNTC_PH_EXT),'') ||'*'|| coalesce(trim(char(v_ISA_ID)),'') 
                         ||'*'|| coalesce(trim(char(v_GS_ID)),'') ||'*'|| coalesce(trim(char(v_ST_ID)),'') ||'*'|| coalesce(trim(char(v_PROV_ID)),'') 
                         ||'*'|| coalesce(trim(char(v_SUBS_ID)),'') ||'*'|| coalesce(trim(char(v_FILE_ID)),''); 
                         
                         
    END IF; 
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_EDI_CLAIMS')@

CREATE PROCEDURE EDIDB2A.SP_837_GET_EDI_CLAIMS
	( 
	IN p_clm_ID BIGINT, 
	OUT p_clm_outBuffer CLOB, 
	OUT p_ERR_CODE BIGINT, 
	OUT p_ERR_DESC VARCHAR(255) 
	) 
BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
DECLARE v_clm_outBuffer 	CLOB; 
DECLARE v_sqlcode 			INTEGER ;
DECLARE SQLCODE				INTEGER DEFAULT 0; 

DECLARE EXIT HANDLER FOR SQLEXCEPTION 
VALUES (SQLCODE) INTO v_sqlcode;

	SET p_ERR_CODE = 0;
	IF(p_clm_ID > 0) THEN 
	--=============================================================================
	--	Retreiving the Data from the Table T_837_CLM_PCES_LOG based on CLM_ID and 
	-- CLM_STU_CD
	--=============================================================================
		SELECT 	CLM_OBJ INTO v_clm_outBuffer 
		FROM T_837_CLM_PCES_LOG 
		WHERE 
			CLM_ID = p_clm_ID 
			AND CLM_STU_CD =10052
		FETCH FIRST 1 ROWS ONLY;--
		SET p_clm_outBuffer= v_clm_outBuffer; --

		VALUES (SQLCODE) INTO v_sqlcode;

		IF (v_sqlcode <> 0) THEN 
			SET p_ERR_CODE = v_sqlcode; 
			SET p_ERR_DESC = 'DB2:RETRIEVED FAILED FROM T_837_CLM_PCES_LOG'; 
		END IF;
	ELSE
		SET p_ERR_CODE = 3990021; 
		SET p_ERR_DESC = 'DB2::SP_837_GET_EDI_CLAIMS:Claim Id <= 0'; 
		SET p_clm_outBuffer= '';--
	END IF;--
END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE SP_837_EXTRACT_LOCAL_CLAIMS')@

CREATE PROCEDURE EDIDB2A.SP_837_EXTRACT_LOCAL_CLAIMS (
    IN 	p_DEST_ID		VARCHAR(30),
    OUT p_outBuffer		CLOB(20000000),
    OUT p_CLM_COUNT		INTEGER,
	OUT p_ERR_CODE 		BIGINT,
	OUT p_ERR_DESC 		VARCHAR(255)
	)
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
DECLARE v_bpv_ID BIGINT;
DECLARE v_subs_ID BIGINT;
DECLARE v_clm_ID BIGINT;
DECLARE c_clm_ID BIGINT;
DECLARE c_bpv_ID BIGINT;
DECLARE c_subs_ID BIGINT;
DECLARE v_count INTEGER;
DECLARE v_pat_ID BIGINT ;
DECLARE c_pat_ID BIGINT ; 
DECLARE v_bpv_outBuffer VARCHAR(4000);
DECLARE v_subs_outBuffer VARCHAR(3000);
DECLARE v_pat_outBuffer VARCHAR(3000) ;
DECLARE v_clm_outBuffer CLOB(5M);
DECLARE v_isa_outBuffer VARCHAR(3000);
DECLARE v_gs_outBuffer VARCHAR(3000) ;
DECLARE v_st_outBuffer VARCHAR(3000) ;
DECLARE v_prev_SENDER_ID VARCHAR(15) ;
DECLARE v_SENDER_ID VARCHAR(15) ;
DECLARE v_prev_PAYER_ID  VARCHAR(80) ;
DECLARE v_PAYER_ID  VARCHAR(80) ;
DECLARE v_isa_ID BIGINT;
DECLARE v_gs_ID BIGINT ;
DECLARE v_st_ID BIGINT ;
--==============================================================================
--	Declare a Cursor to retrieve all the Claims for the Local Destination
--	That are ready to be Bulked and group them by the Sender_ID and Payer_ID
--==============================================================================

DECLARE ClaimsCursor CURSOR 
	FOR SELECT 	
			CLAIMS.SNDR_ID as SENDER_ID, 
			CLAIMS.PAYR_ID as PAYER_ID,
			CLAIMS.ISA_ID 	as ISA_ID,	
			CLAIMS.GS_ID 	as GS_ID, 
			CLAIMS.ST_ID 	as ST_ID,
			CLAIMS.PROV_ID 	as PROV_ID, 
			CLAIMS.SUBS_ID 	as SUBS_ID,
			CLAIMS.PAT_ID 	as PAT_ID,
			CLAIMS.CLM_ID as CLAIM_ID  
		FROM 	
			EDIDB2A.T_837_CLM_CTRL_LOG	CLAIMS 
		WHERE	
			CLAIMS.DEST_ID 		= p_DEST_ID 
			AND CLAIMS.CLM_STT_CD	= '10052' ;
			
	SET p_outBuffer=' ';
	SET c_bpv_ID = 0 ;
	SET c_subs_ID = 0 ;
	SET c_pat_ID = 0 ;
	SET p_clm_count =0;
	SET p_outBuffer='';
	
--==============================================================================
--	Used to determine the No. of Claims to be Bundled for this Destination
--==============================================================================

	SELECT 
			COUNT(DEST_ID) INTO v_count 
	FROM 
			EDIDB2A.T_837_CLM_CTRL_LOG 
	WHERE 
			DEST_ID = p_DEST_ID 
			AND CLM_STT_CD='10052';

--==============================================================================
--  Open the ClaimsCursor and loop around all the claims in the cursor 
--	to determine when to output the ISA Header and Payer Header or not.
--==============================================================================
OPEN ClaimsCursor;

--==============================================================================
-- 	We are performing this as we have a problem with CLOB Size. 
--	Need to look at this later.
--	This should be removed as we move to Production.
--==============================================================================
--IF(v_count > 125) THEN SET v_count = 125; END IF;--

--==============================================================================
--	Now loop around the Claims Cursor until we consume all the claims found
--	At the Start of the Loop initailize the 
--		Previous SENDER ID and 
--		Previous Payer ID
--==============================================================================
Set v_prev_SENDER_ID = '';
Set v_prev_PAYER_ID = '';

WHILE v_count <> 0
DO
--=============================================================================
--  Fetch from the cursor into the variable declared           --=============================================================================	
	FETCH FROM ClaimsCursor INTO 
		v_SENDER_ID,v_PAYER_ID, v_isa_ID, v_gs_ID, v_st_ID, v_bpv_ID,v_subs_ID,v_pat_ID,v_clm_ID;
		
	--==============================================================================
	--	Since this Record belongs to a Different SenderId or a Payer Id we need to 
	--	output the ISA GS and ST Records for this Claim
	--==============================================================================
	IF ((v_prev_SENDER_ID <> v_SENDER_ID) or (v_prev_PAYER_ID <> v_PAYER_ID )) THEN
		CALL EDIDB2A.SP_837_GET_EDI_ISA(v_isa_ID, v_isa_outBuffer,p_ERR_CODE,p_ERR_DESC);
		SET p_outBuffer = p_outBuffer || 'ISA' || '*' || v_isa_outBuffer;
		SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);

		CALL EDIDB2A.SP_837_GET_EDI_GS(v_gs_ID, v_gs_outBuffer,p_ERR_CODE,p_ERR_DESC);
		SET p_outBuffer = p_outBuffer || 'GS' || '*' || v_gs_outBuffer;
		SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);

		CALL EDIDB2A.SP_837_GET_EDI_ST(v_st_ID, v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
        SET p_outBuffer = p_outBuffer || 'ST' || '*' || v_st_outBuffer;
		SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);
		
		--==============================================================================
		--	Since this is a new ISA Header ensure that we also reset the PAYER_ID to 
		--	So that we also force the generation of the Claim Loops
		--==============================================================================
		SET v_prev_SENDER_ID 	= v_SENDER_ID;
		SET v_prev_PAYER_ID		= v_PAYER_ID;

	END IF;
	
	--==============================================================================
	--	Retrieve the Billing Provider Loop / Subscriber Loop and the Patient Loop
	--	and send it to the Back End.
	--==============================================================================
	CALL EDIDB2A.SP_837_GET_EDI_BillingProvider(v_bpv_ID, 	v_bpv_outBuffer,p_ERR_CODE,p_ERR_DESC);
	SET p_outBuffer = p_outBuffer || 'PRV' || '*' || v_bpv_outBuffer 	|| '~' || chr(13) || chr(10);

	CALL EDIDB2A.SP_837_GET_EDI_Subscriber(v_subs_ID, 		v_subs_outBuffer,p_ERR_CODE,p_ERR_DESC);
	SET p_outBuffer = p_outBuffer || 'SBR' || '*' || v_subs_outBuffer	|| '~' || chr(13) || chr(10);
	
	--==============================================================================
	--	Checkf if the Claim has a Patient Loop or not and then Output that if
	--	That Loop exists
	--==============================================================================
	IF (COALESCE(v_pat_ID,-1) <> -1) THEN
		if (v_pat_ID <> 0) THEN
			CALL EDIDB2A.SP_837_GET_EDI_PATIENT(v_pat_ID, 			v_pat_outBuffer,p_ERR_CODE,p_ERR_DESC);	
			SET p_outBuffer = p_outBuffer || 'PAT' || '*' || v_pat_outBuffer	|| '~' || chr(13) || chr(10);
		END IF;
	END IF;
	
	--==============================================================================
	--	Retrieve the Claim Blob which contains the CLM Loop and Service Lines
	--	and output that to the Buffer
	--==============================================================================
	CALL EDIDB2A.SP_837_GET_EDI_Claims(v_clm_ID,	v_clm_outBuffer,p_ERR_CODE,p_ERR_DESC);
	SET p_outBuffer = p_outBuffer || v_clm_outBuffer || chr(13) || chr(10); 
	
	--==============================================================================
	--	Increase the No. of Processed Claims Count;
	--	Decrease the Total Claims Count which is used for the Loop Condition
	--==============================================================================
	SET p_CLM_COUNT	=	p_CLM_COUNT + 1;
	SET v_count		=	v_count - 1;

END WHILE;--
CLOSE ClaimsCursor; 
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GetElements')@

CREATE PROCEDURE EDIDB2A.SP_837_GetElements(
	IN p_stID 		BIGINT,
	IN p_isaID 		BIGINT,
	IN p_subsID 	BIGINT,
	IN p_provID 	BIGINT,
	IN p_patID 		BIGINT,
	OUT outBuffer 	VARCHAR(1700),
	OUT p_ERR_CODE 	BIGINT,
	OUT p_ERR_DESC 	VARCHAR(255)
	)
BEGIN
-- ============================================================================
-- DECLARATION OF VARIABLES 
-- ============================================================================
DECLARE v_bht04 DATE;
DECLARE v_bht04char VARCHAR(15);
DECLARE v_isa06 VARCHAR(15);
DECLARE v_submNm109 VARCHAR(80);
DECLARE v_submPer01 CHARACTER(2);
DECLARE v_submPer03 CHARACTER(2);
DECLARE v_submPer04 VARCHAR(256);
DECLARE v_provNm101 INTEGER;
DECLARE v_provNm102 CHARACTER(1);
DECLARE v_provNm103 VARCHAR(60);
DECLARE v_provNm104 VARCHAR(35);
DECLARE v_provNm105 VARCHAR(35);
DECLARE v_provNm108 CHARACTER(2);
DECLARE v_provNm109 VARCHAR(255);
DECLARE v_provPer03 CHARACTER(2);
DECLARE v_provPer04 VARCHAR(256);
DECLARE v_subsSbr09 CHARACTER(2);
DECLARE v_subsSbr02 VARCHAR(2);
DECLARE v_subsSbr03 VARCHAR(50);
DECLARE v_subsSbr01 CHARACTER(1);
DECLARE v_subsSbr05 CHARACTER(3);
DECLARE v_subsNm102 CHARACTER(1);
DECLARE v_subsNm103 VARCHAR(60);
DECLARE v_subsNm104 VARCHAR(35);
DECLARE v_subsNm108 varchar(2);
DECLARE v_subsNm109 VARCHAR(250);
DECLARE v_subsDmg02 DATE;
DECLARE v_subsDmg02char VARCHAR(15);
DECLARE v_subsDmg03 CHARACTER(1);
DECLARE v_subsN301 VARCHAR(55);
DECLARE v_subsN401 VARCHAR(30);
DECLARE v_subsN402 CHARACTER(2);
DECLARE v_subsN403 VARCHAR(15);
DECLARE v_patPat01 CHARACTER(2);
DECLARE v_patDmg02 DATE;
DECLARE V_patDmg02char VARCHAR(15);
DECLARE v_provRef01_1 CHARACTER(3);
DECLARE v_provRef01_2 VARCHAR(50);
DECLARE v_provRef02_1 CHARACTER(3);
DECLARE v_provRef02_2 VARCHAR(50);
DECLARE v_provRef03_1 CHARACTER(3);
DECLARE v_provRef03_2 VARCHAR(50);
DECLARE v_provPrv03 VARCHAR(50);

	-- ============================================================================
	-- GET THE VALUES FROM THE TABLES AND ASSIGN TO VARIABLES
	-- ============================================================================
	SELECT ISA_SNDR_ID INTO v_isa06 
	FROM EDIDB2A.T_837_ISA 
	WHERE ISA_ID = p_isaID;
   --=============================================================================
   --	Retreiving the Data from the Table T_837_ST based on ST_ID  
   --=============================================================================
	SELECT SUBM_ID,CNTC_FUNC_CD,QLFR_COMM_NUM,COMM_NUM,BHT_DT 
	INTO v_submNm109,v_submPer01,v_submPer03,v_submPer04,v_bht04 
	FROM EDIDB2A.T_837_ST 
	WHERE ST_ID = p_stID;
   --=============================================================================
   --	Retreiving the Data from the Table T_837_PROV based on PROV_ID  
   --=============================================================================
	SELECT 	PROV_ENTY_ID,	ET_QLFR_IND,	LST_NME,			FST_NME,			QLFR_ID,		NPI_ID,
			TAX_QLFR_CD,	TAX_ID,			LICE_QLFR1_CD,		LICE_ID1,			LICE_QLFR2_CD,	LICE_ID1,
			REF_ID,			FST_NME,		CNTC_COMM_QLFR_CD,	CNTC_COMM_NUM 
	INTO
			v_provNm101,	v_provNm102,	v_provNm103,		v_provNm104,		v_provNm108,	v_provNm109,
			v_provRef01_1,	v_provRef01_2,	v_provRef02_1,		v_provRef02_2,		v_provRef03_1,	v_provRef03_2,
			v_provPrv03,	v_provNm105,	v_provPer03,		v_provPer04 
	FROM EDIDB2A.T_837_PROV 
	WHERE PROV_ID = p_provID;
    --=============================================================================
    --	Retreiving the Data from the Table T_837_SUBS based on SUBS_ID  
    --=============================================================================
	SELECT 	CLM_TYPE_CD,	INDI_REL_CD,	REF_ID,			PAYR_RSP_SEQ_CD,	INS_TYPE_CD,	ET_QLFR_IND,
			SUBS_LST_NME,	IDN_QLFR_CD,	SUBS_SSN_NUM,	DTH_DT,				GNDR_IND,		SUBS_ADR1_TXT,
			SUBS_CY_NME,	SUBS_STT_CD,	SUBS_ZIP_CD,	SUBS_FST_NME 
	INTO 	
			v_subsSbr09,	v_subsSbr02,	v_subsSbr03,	v_subsSbr01,		v_subsSbr05,	v_subsNm102,
			v_subsNm103,	v_subsNm108,	v_subsNm109,	v_subsDmg02,		v_subsDmg03,	v_subsN301,
			v_subsN401,		v_subsN402,		v_subsN403,		v_subsNm104 
	FROM EDIDB2A.T_837_SUBS 
	WHERE SUBS_ID = p_subsId;

	-- ============================================================================
	-- CHECKING THE DATE COLUMN IS NULL OR NOT IN THE TABLE IF THE DATE COLUMN IS
	-- NULL THEN WE PUT SPACE IN THE VARIABLE ELSE CHANGE THE DATE INTO CHAR
	-- ============================================================================ 
	--SELECT BHT_DT INTO v_bht04 FROM EDIDB2A.TBL_837_ST WHERE ST_ID = p_stID;
	
	IF(v_bht04 IS NULL) THEN
		SET v_bht04char = ' ';
	ELSE
		SET v_bht04char = CHAR(v_bht04);
	END IF;

	-- ============================================================================
	-- CHECKING THE DATE COLUMN IS NULL OR NOT IN THE TABLE IF THE DATE COLUMN IS
	-- NULL THEN WE PUT SPACE IN THE VARIABLE ELSE CHANGE THE DATE INTO CHAR
	-- ============================================================================ 
	
	IF(v_subsDmg02 IS NULL) THEN
		SET v_subsDmg02char = ' ';
	ELSE
		SET v_subsDmg02char = CHAR(v_subsDmg02);
	END IF;
	
	-- ============================================================================
	-- CHECKING THE DATE COLUMN IS NULL OR NOT IN THE TABLE IF THE DATE COLUMN IS
	-- NULL THEN WE PUT SPACE IN THE VARIABLE ELSE CHANGE THE DATE INTO CHAR
	-- ============================================================================ 
	IF(v_patDmg02 IS NULL) THEN
		SET v_patDmg02char = ' ';
	ELSE
		SET v_patDmg02char = CHAR(v_patDmg02);
	END IF; 
	
	-- ============================================================================
	-- CHECKING THE PATIENT ID IS ZERO OR NOT  SET THE OUTBUFFER
	-- ============================================================================

	IF (p_patID = 0) THEN
		SET v_patDmg02char = v_subsDmg02char;
		SET v_patPat01 = ' ';
		SET outBuffer = 'S' || '#$#' || v_bht04char || '#$#' || v_isa06 || '#$#' || v_submNm109 || '#$#' || v_submPer01 || '#$#'|| v_submPer03 || '#$#' || v_submPer04 || '#$#' || v_provPrv03 || '#$#' || TRIM(CHAR(v_provNm101)) || '#$#' || v_provNm102 || '#$#' || v_provNm103 || '#$#' || v_provNm104 || '#$#' || v_provNm105 || '#$#' || v_provNm108 || '#$#' || v_provNm109 || '#$#' || v_provPer03 || '#$#' || v_provPer04 || '#$#' ||  v_subsSbr01 || '#$#' || v_subsSbr02 || '#$#' || v_subsSbr03 || '#$#' ||  v_subsSbr05 || '#$#' || v_subsSbr09 || '#$#' || v_subsNm102 || '#$#' || v_subsNm103 || '#$#' || v_subsNm104 || '#$#' ||v_subsNm108 || '#$#' || v_subsNm109 || '#$#' || v_subsDmg02char || '#$#' || v_subsDmg03 || '#$#' || v_subsN301 || '#$#' || v_subsN401 || '#$#' || v_subsN402 || '#$#' || v_subsN403 || '#$#' || v_patDmg02char || '#$#' || v_provRef01_1 || '#$#' || v_provRef02_1 || '#$#' || v_provRef03_1 || '#$#' || v_provRef01_2 || '#$#' || v_provRef02_2 || '#$#' || v_provRef03_2 || '#$#' || v_patPat01 || '|' ;
	ELSE
    --=============================================================================
    --	Retreiving the Data from the Table T_837_PAT based on PAT_ID  
    --=============================================================================
		SELECT BRTH_DT,REL_CD INTO v_patDmg02,v_patPat01 FROM EDIDB2A.T_837_PAT WHERE PAT_ID = p_patID;
		SET outBuffer = 'D' || '#$#' || v_bht04char || '#$#' || v_isa06 || '#$#' || v_submNm109 || '#$#' || v_submPer01 || '#$#' || v_submPer03 || '#$#' || v_submPer04  || '#$#' || v_provPrv03 || '#$#' || TRIM(CHAR(v_provNm101)) || '#$#' || v_provNm102 || '#$#' || v_provNm103 || '#$#' || v_provNm104 || '#$#' || v_provNm105 || '#$#' || v_provNm108 || '#$#' || v_provNm109 || '#$#' || v_provPer03 || '#$#' || v_provPer04 || '#$#' ||  v_subsSbr01 || '#$#' || v_subsSbr02 || '#$#' || v_subsSbr03 || '#$#' || v_subsSbr05 || '#$#' || v_subsSbr09 || '#$#' || v_subsNm102 || '#$#' || v_subsNm103 || '#$#' || v_subsNm104 || '#$#' ||v_subsNm108 || '#$#' || v_subsNm109 || '#$#' || v_subsDmg02char || '#$#' || v_subsDmg03 || '#$#' || v_subsN301 || '#$#' || v_subsN401 || '#$#' || v_subsN402 || '#$#' || v_subsN403 || '#$#' || v_patDmg02char || '#$#' || v_provRef01_1 || '#$#' || v_provRef02_1 || '#$#' || v_provRef03_1 || '#$#' || v_provRef01_2 || '#$#' || v_provRef02_2 || '#$#' || v_provRef03_2 || '#$#' || v_patPat01 || '|' ;
	END IF;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_UPDATE_DOS')@

CREATE PROCEDURE EDIDB2A.SP_837_UPDATE_DOS(
	IN P_CLM_ID BIGINT,
	IN P_SNDR_ID VARCHAR(15),
	IN P_PAYR_ID VARCHAR(80),
	OUT P_ERR_CD INTEGER ,
	OUT P_ERR_DSC VARCHAR(255)  
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
    DECLARE SQLCODE	        INTEGER ;
	DECLARE V_SERV_FR_DT 	DATE;
	DECLARE V_SERV_TO_DT 	DATE;
	DECLARE v_sqlcode       INTEGER ;
	
	--=========================================================================
	--	Setup the EXIT handler for all SQL exceptions
	--=========================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION	VALUES (SQLCODE) INTO v_sqlcode;

	--=========================================================================
	--	Retrieve the DT_OF_SERV_FR and DT_OF_SERV_TO Records 
	--  corresponding to this Claim Id
	--=========================================================================
	SELECT 		MIN(SERV_FR_DT), 	MAX(SERV_TO_DT) 
		INTO  	V_SERV_FR_DT,		V_SERV_TO_DT 
	FROM EDIDB2A.T_837_SERVLN 
	WHERE CLM_ID=P_CLM_ID WITH UR;

	SET v_sqlcode = SQLCODE;

	UPDATE EDIDB2A.T_837_CLM_CTRL_LOG SET SERV_FR_DT= V_SERV_FR_DT ,
       SERV_TO_DT= V_SERV_TO_DT ,
       SNDR_ID   = P_SNDR_ID ,
       PAYR_ID   = P_PAYR_ID
	WHERE CLM_ID=P_CLM_ID WITH UR ;

	SET v_sqlcode = SQLCODE;	
	SET P_ERR_CD = v_sqlcode;
	SET P_ERR_DSC = 'VALID';
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_EDITS')@

CREATE PROCEDURE EDIDB2A.SP_837_GET_EDITS(
	IN p_lob CHAR(1), 
	IN p_sop CHAR(2), 
	OUT p_edits_list VARCHAR(5000), 
	OUT p_edits_cnt INT, 
	OUT P_ERR_CD INTEGER,
	OUT P_ERR_DSC VARCHAR(255)  
)
LANGUAGE SQL
BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_edits_List VARCHAR(5000);
	DECLARE v_first_Edit VARCHAR(5000) DEFAULT 'True';
	DECLARE v_edit_code VARCHAR(6) ;
	DECLARE v_cnt INT DEFAULT 0 ;
	DECLARE SQLSTATE CHAR(5) DEFAULT '00000' ;
	DECLARE v_length INT DEFAULT 0 ;

	DECLARE c_edit Cursor FOR 
		SELECT  EDIT_CD 
		FROM EDIDB2A.T_837_EDIT_CD 
		WHERE 
			LOB_IND = p_lob 
			AND 
			SRC_OF_PMT_CD = p_sop ;

	OPEN c_edit ;
--=============================================================================
--  Fetch from the cursor into the variable declared           --=============================================================================
	FETCH FROM c_edit INTO v_edit_code ;
	WHILE ( SQLSTATE = '00000' ) DO
		IF (v_first_edit = 'True') THEN
			SET v_first_edit = 'False';
			SET v_edits_list = '';--v_edit_code ;
		END IF ;
    
		SET v_edits_list = v_edits_list || '#$#'  || v_edit_code ;
		SET v_cnt = v_cnt + 1 ;
		
		FETCH FROM c_edit INTO v_edit_code ;
	END WHILE ;
	
	CLOSE c_edit ;
	
	SET v_length = LENGTH(v_edits_list);
	SET p_edits_list = SUBSTR(v_edits_list,4,v_length) ;

	SET p_edits_cnt = v_cnt;
	SET p_ERR_DSC = SQLSTATE ;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_SAVE_FILE')@

CREATE PROCEDURE EDIDB2A.SP_837_SAVE_FILE (
	IN	p_UU_ID 				BIGINT,
	IN	p_PRNT_FILE_ID 			BIGINT,
	IN	p_MAS_FILE_ID 			BIGINT,
	IN	p_FILE_NME 				VARCHAR(255),
	IN	p_LOB_CD				CHAR(1),
	IN	p_RECV_TS				TIMESTAMP,
	IN	p_PCES_TS				TIMESTAMP,
	IN	p_FILE_STT_CD			VARCHAR(8),
	IN	p_FILE_CMT_TXT			VARCHAR(120),
	IN	p_FILE_FMT_CD			CHAR(1),
	IN	p_DIR_CD				CHAR(1),
	IN  p_FILE_ROOT_DTRY_TXT 	VARCHAR(255),
	IN  p_FILE_SUB_DTRY_TXT 	VARCHAR(255),
	IN	p_FILE_VER_ID 			VARCHAR(8),
	IN  p_FILE_TYPE_CD			CHAR(1),
	IN	p_TEST_CD				CHAR(1),
	IN  P_FILE_ORGN_CD		    CHAR(1),
	IN  P_RECR_QLFR			    CHAR(2),
	IN  P_RECR_ID 			    VARCHAR(18),
	OUT	p_FILE_ID				BIGINT,
	OUT	p_ERR_CD				INTEGER,
	OUT p_ERR_DSC				VARCHAR(255)  
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN

	--==========================================================
	-- Setup the EXIT Handle to handle any SQL Exceptions
	--==========================================================
	DECLARE SQLCODE  INTEGER DEFAULT 000;
	DECLARE p_sqlcode INTEGER;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION	VALUES (SQLCODE) INTO p_ERR_CD;
	/*DECLARE exit handler for SQLEXCEPTION
	begin
		get diagnostics exception 1 p_ERR_DSC = MESSAGE_TEXT;
		set p_ERR_CD = SQLCODE;
	end;
	*/
	IF ((p_FILE_NME IS NOT NULL) and (p_FILE_NME <> '') )THEN 
		CALL EDIDB2A.get_file_seq_num(p_FILE_ID);
	--=============================================================================
    --	Insert the Data into Table  T_837_FILE_PCES_LOG
    --=============================================================================
		INSERT INTO EDIDB2A.T_837_FILE_PCES_LOG(
					FILE_ID,		UU_ID,			PRNT_FILE_ID,		MAS_FILE_ID,		FILE_NME,
					LOB_CD,			RECV_TS,		PCES_TS,			FILE_STT_CD,		CMT_TXT,
					FILE_FMT_CD,	DIR_CD,			FILE_ROOT_DTRY_TXT,	FILE_SUB_DTRY_TXT,	             	FILE_VER_ID,	FILE_TYPE_CD,	   TEST_CD,         FILE_ORGN_CD,RECR_QLFR,RECR_ID) 
		VALUES (
					p_FILE_ID,		p_UU_ID,		p_PRNT_FILE_ID,		p_MAS_FILE_ID,		p_FILE_NME,
					p_LOB_CD,		p_RECV_TS,		p_PCES_TS,			p_FILE_STT_CD,		p_FILE_CMT_TXT,
					p_FILE_FMT_CD,	p_DIR_CD,		p_FILE_ROOT_DTRY_TXT,P_FILE_SUB_DTRY_TXT,
					p_FILE_VER_ID,	P_FILE_TYPE_CD,	p_TEST_CD,P_FILE_ORGN_CD,P_RECR_QLFR,P_RECR_ID);
					
		VALUES (SQLCODE) INTO p_sqlcode;
		SET p_ERR_CD = p_sqlcode;
		IF (p_ERR_CD <> 0) THEN
			SET p_ERR_DSC = 'SP_837_SAVE_FILE::Failed Inserting Data into the Table';
		ELSE
			SET p_ERR_DSC = 'SP_837_SAVE_FILE::Successfully inserted records into the Table T_837_FILE_PCES_LOG';
		END IF;
	ELSE
		SET p_ERR_CD = 9001248;
		SET p_ERR_DSC = 'SP_837_SAVE_FILE::Could not Insert File into DB as File name is NULL';
	END IF ;	
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_SAVE_COMP_FILES')@


CREATE PROCEDURE EDIDB2A.SP_837_SAVE_COMP_FILES (
	IN	p_UU_ID 				BIGINT,
	IN	p_PRNT_FILE_ID 			BIGINT,
	IN	p_MAS_FILE_ID 			BIGINT,
	IN 	p_TA1_FILE_NME 			VARCHAR(255),
	IN	p_999_FILE_NME 			VARCHAR(255),
	IN	p_COMP_REP_FILE_NME		VARCHAR(255),
	IN	p_COMP_DAT_FILE_NME 	VARCHAR(255),
	IN	p_277CA_FILE_NME		VARCHAR(255),
	IN	p_VCLAIMS_FILE_NME		VARCHAR(255),
	IN	p_ICLAIMS_FILE_NME		VARCHAR(255),
	IN	p_SUBDIR_TA1 			VARCHAR(255),
	IN	p_SUBDIR_999 			VARCHAR(255),
	IN	p_SUBDIR_COMP 			VARCHAR(255),
	IN	p_SUBDIR_277CA 			VARCHAR(255),
	IN	p_SUBDIR_VCLAIMS 		VARCHAR(255),
	IN	p_SUBDIR_ICLAIMS 		VARCHAR(255),
	IN	p_ROOT_DIR 				VARCHAR(255),
	IN	p_LOB					CHAR(1),
	IN	p_EDI_VER				VARCHAR(8),
	IN	p_FILE_STT_ID			VARCHAR(6),
	IN	p_DIR_ID				CHAR(1),
	IN	p_TEST_CD				CHAR(1),
	IN  P_RECR_QLFR			    CHAR(2),
	IN  P_RECR_ID 			    VARCHAR(18),
	OUT P_FILEID_VALID          BIGINT,
	OUT P_FILEID_INVALID        BIGINT,
	OUT	p_ERR_CD				INTEGER,
	OUT	p_ERR_DSC				VARCHAR(255)  
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_FILE_TYP_ID CHAR(1);
	DECLARE v_FILE_FMT_ID CHAR(1);
	DECLARE v_FILE_ORGN_CD CHAR(1);

	-- ================================
	--	DECLARATION OF VARIABLES
	-- ================================
	DECLARE v_FILE_ID BIGINT;

	--==========================================================
	-- Setup the EXIT Handle to handle any SQL Exceptions
	--==========================================================
	DECLARE SQLCODE  INTEGER DEFAULT 000;
	DECLARE p_sqlcode INTEGER;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION	VALUES (SQLCODE) INTO p_sqlcode;

	IF ((p_TA1_FILE_NME IS NOT NULL) and (p_TA1_FILE_NME != ''))  THEN
		SET v_FILE_TYP_ID = 'T'; SET v_FILE_FMT_ID = 'A'; SET  v_FILE_ORGN_CD = 'X';
		CALL EDIDB2A.SP_837_SAVE_FILE(p_UU_ID,p_PRNT_FILE_ID,p_mas_file_id,p_TA1_FILE_NME,
				p_LOB,	CURRENT TIMESTAMP,CURRENT TIMESTAMP,p_FILE_STT_ID, 'TA1(ISA Acknowledgement)',
				v_FILE_FMT_ID,'O',p_ROOT_DIR,p_SUBDIR_TA1,p_EDI_VER,v_FILE_TYP_ID,
				p_TEST_CD,v_FILE_ORGN_CD,P_RECR_QLFR,P_RECR_ID,v_FILE_ID,p_ERR_CD,p_ERR_DSC);
		
	END IF ;
	
	IF ((p_999_FILE_NME IS NOT NULL) and (p_999_FILE_NME <> '') )THEN 
		SET v_FILE_TYP_ID = 'S'; SET v_FILE_FMT_ID = 'A'; SET  v_FILE_ORGN_CD = 'X';
		CALL EDIDB2A.SP_837_SAVE_FILE(p_UU_ID,p_PRNT_FILE_ID,p_mas_file_id,p_999_FILE_NME,
				p_LOB,	CURRENT TIMESTAMP,CURRENT TIMESTAMP,p_FILE_STT_ID, 'Funtional Group Acknowledgement',
				v_FILE_FMT_ID,'O',p_ROOT_DIR,p_SUBDIR_999,p_EDI_VER,v_FILE_TYP_ID,
				p_TEST_CD,v_FILE_ORGN_CD,P_RECR_QLFR,P_RECR_ID,v_FILE_ID,p_ERR_CD,p_ERR_DSC);
	END IF ;

	IF ((p_COMP_REP_FILE_NME IS NOT NULL) and (p_COMP_REP_FILE_NME <> '')) THEN
		SET v_FILE_TYP_ID = 'C'; SET v_FILE_FMT_ID = 'H'; SET  v_FILE_ORGN_CD = 'X';
		CALL EDIDB2A.SP_837_SAVE_FILE(p_UU_ID,p_PRNT_FILE_ID,p_mas_file_id,p_COMP_REP_FILE_NME,
				p_LOB,	CURRENT TIMESTAMP,CURRENT TIMESTAMP,p_FILE_STT_ID, 'Compliance Report ',
				v_FILE_FMT_ID,p_DIR_ID,p_ROOT_DIR,p_SUBDIR_COMP,p_EDI_VER,v_FILE_TYP_ID,
				p_TEST_CD,v_FILE_ORGN_CD,null,null,v_FILE_ID,p_ERR_CD,p_ERR_DSC);
	END IF ;

	IF ((p_COMP_DAT_FILE_NME IS NOT NULL) and (p_COMP_DAT_FILE_NME <> '')) THEN
		SET v_FILE_TYP_ID = 'D'; SET v_FILE_FMT_ID = 'H'; SET  v_FILE_ORGN_CD = 'X';
		CALL EDIDB2A.SP_837_SAVE_FILE(p_UU_ID,p_PRNT_FILE_ID,p_mas_file_id,p_COMP_DAT_FILE_NME,
				p_LOB,	CURRENT TIMESTAMP,CURRENT TIMESTAMP,p_FILE_STT_ID, 'Data for Compliance Report',
				v_FILE_FMT_ID,p_DIR_ID,p_ROOT_DIR,p_SUBDIR_COMP,p_EDI_VER,v_FILE_TYP_ID,
				p_TEST_CD,v_FILE_ORGN_CD,null,null,v_FILE_ID,p_ERR_CD,p_ERR_DSC);
	END IF ;
	
	IF ((p_277CA_FILE_NME IS NOT NULL) and (p_277CA_FILE_NME <> '')) THEN
		SET v_FILE_TYP_ID = 'W'; SET v_FILE_FMT_ID = 'H'; SET  v_FILE_ORGN_CD = 'X';
		CALL EDIDB2A.SP_837_SAVE_FILE(p_UU_ID,p_PRNT_FILE_ID,p_mas_file_id,p_277CA_FILE_NME,
				p_LOB,	CURRENT TIMESTAMP,CURRENT TIMESTAMP,p_FILE_STT_ID, 'Data for Compliance Report',
				v_FILE_FMT_ID,'O',p_ROOT_DIR,p_SUBDIR_277CA,p_EDI_VER,v_FILE_TYP_ID,
				p_TEST_CD,v_FILE_ORGN_CD,null,null,v_FILE_ID,p_ERR_CD,p_ERR_DSC);
	END IF ;
	
	IF ((p_VCLAIMS_FILE_NME IS NOT NULL) and (p_VCLAIMS_FILE_NME <> '')) THEN
		SET v_FILE_TYP_ID = '3'; SET v_FILE_FMT_ID = 'H'; SET  v_FILE_ORGN_CD = 'X';
		CALL EDIDB2A.SP_837_SAVE_FILE(p_UU_ID,p_PRNT_FILE_ID,p_mas_file_id,p_VCLAIMS_FILE_NME,
				p_LOB,	CURRENT TIMESTAMP,CURRENT TIMESTAMP,p_FILE_STT_ID, 'Data for Compliance Report',
				v_FILE_FMT_ID,p_DIR_ID,p_ROOT_DIR,p_SUBDIR_VCLAIMS,p_EDI_VER,v_FILE_TYP_ID,
				p_TEST_CD,v_FILE_ORGN_CD,null,null,v_FILE_ID,p_ERR_CD,p_ERR_DSC);
				
		SET P_FILEID_VALID = v_FILE_ID;
	END IF ;
	
	IF ((p_ICLAIMS_FILE_NME IS NOT NULL) and (p_ICLAIMS_FILE_NME <> '')) THEN
		SET v_FILE_TYP_ID = '3'; SET v_FILE_FMT_ID = 'H'; SET  v_FILE_ORGN_CD = 'X';
		CALL EDIDB2A.SP_837_SAVE_FILE(p_UU_ID,p_PRNT_FILE_ID,p_mas_file_id,p_ICLAIMS_FILE_NME,
				p_LOB,	CURRENT TIMESTAMP,CURRENT TIMESTAMP,p_FILE_STT_ID, 'Data for Compliance Report',
				v_FILE_FMT_ID,p_DIR_ID,p_ROOT_DIR,p_SUBDIR_ICLAIMS,p_EDI_VER,v_FILE_TYP_ID,
				p_TEST_CD,v_FILE_ORGN_CD,null,null,v_FILE_ID,p_ERR_CD,p_ERR_DSC);
				
		SET P_FILEID_INVALID = v_FILE_ID;
	END IF ;
	
	--==========================================================
	-- Place the Value of Sqlcode into the variable p_sqlcode 
	--==========================================================
	VALUES (SQLCODE) INTO p_ERR_CD;
	SET p_ERR_DSC = 'Done';
END@
--=============================================================================
--	Procedure: SP_CLAIM_BLOB_INSERT
--	Need to ensure that MB Flows use this stored proc instead of the SQL Statement
--	Added this on Aug/18/2010 @ 6:45PM
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_CLAIM_BLOB_INSERT')@

CREATE PROCEDURE EDIDB2A.SP_CLAIM_BLOB_INSERT(
	IN	p_CLM_OBJ		CLOB,
	IN	p_CLM_ID		BIGINT,
	IN	p_CLM_STU_CD	INTEGER,
	OUT	p_ID			BIGINT,
	OUT p_ERR_CODE		BIGINT, 
	OUT p_ERR_DESC		VARCHAR(255)
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE SQLCODE 		INTEGER DEFAULT 0;
	DECLARE v_sqlcode 		INTEGER;

	--======================================================================
	--	Setup the EXIT handler for all SQL exceptions
	--======================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION VALUES (SQLCODE) INTO v_sqlcode;

	--================================================================================
	--	Retrieve the ID of the New Record added into the WIP Table 
	--================================================================================
	INSERT INTO 
			EDIDB2A.T_837_CLM_PCES_LOG(CLM_ID,CLM_OBJ,CLM_STU_CD,MSG_TS) 
			VALUES (p_CLM_ID, p_CLM_OBJ,p_CLM_STU_CD,CURRENT TIMESTAMP);
				
	--	Retrieve the ID of the Last Inserted records Primary Key
	SET p_ID = IDENTITY_VAL_LOCAL();

	VALUES (sqlcode) INTO v_sqlcode;

	--=============================================================
	-- Please set the p_flag value based on the sqlcode
	--=============================================================

	IF (v_sqlcode = 0) THEN
		-- If the record exist for this Sender ID then set p_flag is 1
		SET p_ERR_CODE = 0; 
		SET p_ERR_DESC = 'Successfully Inserted a Record into T_837_CLM_PCES_LOG::ID' || char(p_ID);
	ELSE
		-- For any sqlexceptions set p_flag is sqlcode
		SET p_ERR_CODE = v_sqlcode;
		SET p_ERR_DESC = 'Failed to insert a Record into the T_837_CLM_PCES_LOG:: CLAIM ID' || char(p_CLM_ID);
	END IF;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_FILE_RECON')@

CREATE PROCEDURE EDIDB2A.SP_837_FILE_RECON(
	IN	p_FILE_ID		BIGINT,
	IN	p_VALID_CNT		INTEGER,
	IN	p_INVALID_CNT	INTEGER,
	IN	p_VALID_AMT		FLOAT,
	IN	p_INVALID_AMT	FLOAT,
	OUT p_ERR_CODE		BIGINT, 
	OUT p_ERR_DESC		VARCHAR(255)
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE SQLCODE 		INTEGER DEFAULT 0;
	DECLARE v_sqlcode 		INTEGER;

	--======================================================================
	--	Setup the EXIT handler for all SQL exceptions
	--======================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION VALUES (SQLCODE) INTO v_sqlcode;

	--=============================================================
	--	Update the T_837_FILE_PCES_LOG
	--=============================================================
	

		UPDATE EDIDB2A.T_837_FILE_PCES_LOG
				SET (VAL_CLM_CNT,INVAL_CLM_CNT,VAL_CLM_AMT,INVAL_CLM_AMT)
				=(p_VALID_CNT,p_INVALID_CNT,p_VALID_AMT,p_INVALID_AMT)
		WHERE FILE_ID = p_FILE_ID;

	VALUES (sqlcode) INTO v_sqlcode;

	--=============================================================
	-- Please set the p_flag value based on the sqlcode
	--=============================================================

	IF (v_sqlcode = 0) THEN
		-- If the record exist for this Sender ID then set p_flag is 1
		SET p_ERR_CODE = 0; 
		SET p_ERR_DESC = 'Successfully Updated a Record into T_837_FILE_PCES_LOG::ID' || char(p_FILE_ID);
	ELSE
		-- For any sqlexceptions set p_flag is sqlcode
		SET p_ERR_CODE = v_sqlcode;
		SET p_ERR_DESC = 'Failed to insert a Record into the T_837_FILE_PCES_LOG:: FILE ID' || char(p_FILE_ID);
	END IF;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_PERSIST_STUB_DATA')@

CREATE PROCEDURE EDIDB2A.SP_837_PERSIST_STUB_DATA(
	IN	p_CLM_ID		BIGINT,
	IN	p_STUB_BG_TS 	TIMESTAMP,
	IN	p_STUB_END_TS 	TIMESTAMP,
	IN	p_STUB_ERR_CD	INTEGER,
	IN	p_STUB_REQ		VARCHAR(120),
	IN	p_STUB_RESP		VARCHAR(120),
	OUT p_ERR_CODE		BIGINT, 
	OUT p_ERR_DESC		VARCHAR(255)
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_CLM_ID		BIGINT;
	DECLARE SQLCODE 		INTEGER DEFAULT 0;
	DECLARE v_sqlcode 		INTEGER;

	--======================================================================
	--	Setup the EXIT handler for all SQL exceptions
	--======================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION VALUES (SQLCODE) INTO v_sqlcode;

	--================================================================================
	--	Retrieve the ID of the New Record added into the WIP Table 
	--================================================================================
	SELECT	CLM_ID INTO v_CLM_ID 
	FROM EDIDB2A.T_837_CLM_PCES_TME_TRCK WHERE CLM_ID = p_CLM_ID;
	
	VALUES (sqlcode) INTO v_sqlcode;

	--=============================================================
	--	Please set the p_flag value based on the sqlcode
	--=============================================================
	IF (v_sqlcode = 0) THEN
		UPDATE EDIDB2A.T_837_CLM_PCES_TME_TRCK
				SET (STUB_BG_TS,	STUB_END_TS,STUB_ERR_CD,STUB_REQ,STUB_RESP)
				=(p_STUB_BG_TS,p_STUB_END_TS,p_STUB_ERR_CD,p_STUB_REQ,p_STUB_RESP)
		WHERE CLM_ID = p_CLM_ID;
	ELSEIF (v_sqlcode = 100) THEN
		INSERT INTO 
			EDIDB2A.T_837_CLM_PCES_TME_TRCK(CLM_ID,STUB_BG_TS,	STUB_END_TS,STUB_ERR_CD,STUB_REQ,STUB_RESP)
			VALUES (p_CLM_ID,p_STUB_BG_TS,p_STUB_END_TS,p_STUB_ERR_CD,p_STUB_REQ,p_STUB_RESP);
	ELSE
		--	For any sqlexceptions set p_flag is sqlcode
		SET p_ERR_CODE = v_sqlcode;
	END IF;

	VALUES (sqlcode) INTO v_sqlcode;

	--=============================================================
	-- Please set the p_flag value based on the sqlcode
	--=============================================================

	IF (v_sqlcode = 0) THEN
		-- If the record exist for this Sender ID then set p_flag is 1
		SET p_ERR_CODE = 0; 
		SET p_ERR_DESC = 'Successfully Inserted a Record into T_837_CLM_PCES_TME_TRCK::ID' || char(p_CLM_ID);
	ELSE
		-- For any sqlexceptions set p_flag is sqlcode
		SET p_ERR_CODE = v_sqlcode;
		SET p_ERR_DESC = 'Failed to insert a Record into the T_837_CLM_PCES_TME_TRCK:: CLAIM ID' || char(p_CLM_ID);
	END IF;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_PERSIST_ITS_DATA')@

CREATE PROCEDURE EDIDB2A.SP_837_PERSIST_ITS_DATA(
	IN	p_CLM_ID		BIGINT,
	IN	p_ITS_BG_TS 	TIMESTAMP,
	IN	p_ITS_END_TS 	TIMESTAMP,
	IN	p_ITS_ERR_CD	INTEGER,
	IN	p_ITS_REQ		VARCHAR(120),
	IN	p_ITS_RESP		VARCHAR(120),
	OUT p_ERR_CODE		BIGINT, 
	OUT p_ERR_DESC		VARCHAR(255)
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_CLM_ID		BIGINT;
	DECLARE SQLCODE 		INTEGER DEFAULT 0;
	DECLARE v_sqlcode 		INTEGER;

	--======================================================================
	--	Setup the EXIT handler for all SQL exceptions
	--======================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION VALUES (SQLCODE) INTO v_sqlcode;

	--================================================================================
	--	Retrieve the ID of the New Record added into the WIP Table 
	--================================================================================
	SELECT	CLM_ID INTO v_CLM_ID 
	FROM EDIDB2A.T_837_CLM_PCES_TME_TRCK WHERE CLM_ID = p_CLM_ID;
	
	VALUES (sqlcode) INTO v_sqlcode;

	--=============================================================
	--	Please set the p_flag value based on the sqlcode
	--=============================================================
	IF (v_sqlcode = 0) THEN
		UPDATE EDIDB2A.T_837_CLM_PCES_TME_TRCK
				SET (ITS_BG_TS,	ITS_END_TS,ITS_ERR_CD,ITS_REQ,ITS_RESP)
				=(p_ITS_BG_TS,p_ITS_END_TS,p_ITS_ERR_CD,p_ITS_REQ,p_ITS_RESP)
		WHERE CLM_ID = p_CLM_ID;
	ELSEIF (v_sqlcode = 100) THEN
		INSERT INTO 
			EDIDB2A.T_837_CLM_PCES_TME_TRCK(CLM_ID,ITS_BG_TS,ITS_END_TS,ITS_ERR_CD,ITS_REQ,ITS_RESP)
			VALUES (p_CLM_ID,p_ITS_BG_TS,p_ITS_END_TS,p_ITS_ERR_CD,p_ITS_REQ,p_ITS_RESP);
	ELSE
		--	For any sqlexceptions set p_flag is sqlcode
		SET p_ERR_CODE = v_sqlcode;
	END IF;

	VALUES (sqlcode) INTO v_sqlcode;

	--=============================================================
	-- Please set the p_flag value based on the sqlcode
	--=============================================================

	IF (v_sqlcode = 0) THEN
		-- If the record exist for this Sender ID then set p_flag is 1
		SET p_ERR_CODE = 0; 
		SET p_ERR_DESC = 'Successfully Inserted a Record into T_837_CLM_PCES_TME_TRCK::ID' || char(p_CLM_ID);
	ELSE
		-- For any sqlexceptions set p_flag is sqlcode
		SET p_ERR_CODE = v_sqlcode;
		SET p_ERR_DESC = 'Failed to insert a Record into the T_837_CLM_PCES_TME_TRCK:: CLAIM ID' || char(p_CLM_ID);
	END IF;
END@

--=============================================================================
--	Function:	SP_837_PERSIST_NPI_DATA()
--	Description:
--	Used to Persit NPI Meta data 
--	Author:	Nanaji Veturi
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_PERSIST_NPI_DATA')@


CREATE PROCEDURE EDIDB2A.SP_837_PERSIST_NPI_DATA(
	IN	p_CLM_ID		BIGINT,
	IN	p_NPI_BG_TS 	TIMESTAMP,
	IN	p_NPI_END_TS 	TIMESTAMP,
	IN	p_NPI_ERR_CD	INTEGER,
	IN	p_NPI_REQ		VARCHAR(350),
	IN	p_NPI_RESP		VARCHAR(350),
	OUT p_ERR_CODE		BIGINT, 
	OUT p_ERR_DESC		VARCHAR(255)
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_CLM_ID		BIGINT;
	DECLARE SQLCODE 		INTEGER DEFAULT 0;
	DECLARE v_sqlcode 		INTEGER;

	--======================================================================
	--	Setup the EXIT handler for all SQL exceptions
	--======================================================================

	DECLARE EXIT HANDLER FOR SQLEXCEPTION VALUES (SQLCODE) INTO v_sqlcode;

	--================================================================================
	--	Retrieve the ID of the New Record added into the WIP Table 
	--================================================================================
	SELECT	CLM_ID INTO v_CLM_ID 
	FROM EDIDB2A.T_837_CLM_PCES_TME_TRCK WHERE CLM_ID = p_CLM_ID;
	
	VALUES (sqlcode) INTO v_sqlcode;

	--=============================================================
	--	Please set the p_flag value based on the sqlcode
	--=============================================================
	IF (v_sqlcode = 0) THEN
		UPDATE EDIDB2A.T_837_CLM_PCES_TME_TRCK
				SET (NPI_BG_TS,	NPI_END_TS,NPI_ERR_CD,NPI_REQ,NPI_RESP)
				=(p_NPI_BG_TS,p_NPI_END_TS,p_NPI_ERR_CD,p_NPI_REQ,p_NPI_RESP)
		WHERE CLM_ID = p_CLM_ID;
	ELSEIF (v_sqlcode = 100) THEN
		INSERT INTO 
			EDIDB2A.T_837_CLM_PCES_TME_TRCK(CLM_ID,NPI_BG_TS,	NPI_END_TS,NPI_ERR_CD,NPI_REQ,NPI_RESP)
			VALUES (p_CLM_ID,p_NPI_BG_TS,p_NPI_END_TS,p_NPI_ERR_CD,p_NPI_REQ,p_NPI_RESP);
	ELSE
		--	For any sqlexceptions set p_flag is sqlcode
		SET p_ERR_CODE = v_sqlcode;
	END IF;

	VALUES (sqlcode) INTO v_sqlcode;

	--=============================================================
	-- Please set the p_flag value based on the sqlcode
	--=============================================================

	IF (v_sqlcode = 0) THEN
		-- If the record exist for this Sender ID then set p_flag is 1
		SET p_ERR_CODE = 0; 
		SET p_ERR_DESC = 'Successfully Inserted a Record into T_837_CLM_PCES_TME_TRCK::ID' || char(p_CLM_ID);
	ELSE
		-- For any sqlexceptions set p_flag is sqlcode
		SET p_ERR_CODE = v_sqlcode;
		SET p_ERR_DESC = 'Failed to insert a Record into the T_837_CLM_PCES_TME_TRCK:: CLAIM ID' || char(p_CLM_ID);
	END IF;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_INSERT_EDITS')@

CREATE PROCEDURE EDIDB2A.SP_837_INSERT_EDITS(
	IN 	P_CLM_ID		BIGINT ,
	IN 	p_edits_str		varchar(10000),
	IN 	P_SEPERATOR 	CHAR(1),
	IN 	P_ELEMINATOR 	CHAR(1),
	OUT P_ERROR_CD 		INTEGER,
	OUT P_ERROR_DESC 	VARCHAR(255),
	OUT P_COUNT INT)
LANGUAGE SQL 
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
DECLARE v_clm_id BIGINT ;
DECLARE v_fieldsep CHAR(1);
DECLARE v_edits_str varchar(10000);
DECLARE v_editStrLen integer;
declare v_editCurPos integer DEFAULT  1;
DECLARE v_field_delm_pos INTEGER DEFAULT 1;
DECLARE v_field_start_pos INTEGER DEFAULT 0 ;

DECLARE v_editcode VARCHAR(10);
DECLARE v_editLevel VARCHAR(10);
DECLARE v_svceLineNo INTEGER;
DECLARE v_editType VARCHAR(10);
DECLARE v_editStatus VARCHAR(10);
DECLARE v_errorCount VARCHAR(10);
DECLARE v_field_cnt INTEGER ; 

DECLARE v_start INTEGER DEFAULT 1;
DECLARE v_end_pos INTEGER DEFAULT 0 ;
DECLARE v_STU_CD  VARCHAR(6) ; 
DECLARE v_edits_cnt INTEGER DEFAULT 0 ;

DECLARE v_edit_fields_str VARCHAR(50) ;
DECLARE v_field VARCHAR(50);
DECLARE v_length INTEGER DEFAULT 0 ;

SET v_edits_str 	= p_edits_str;
SET v_clm_id 		= P_CLM_ID ;
set v_fieldsep		=P_SEPERATOR;

--	determine the size of the original string
set v_editStrLen 	= length(p_edits_str);
set v_field_start_pos = 1;
set v_start = 1;
WHILE ( v_start < v_editStrLen ) DO

	--	Identify the First Edit Code in this list of Edits
	--	using the edits delimiter(P_ELEMINATOR)
	SET v_end_pos 			= LOCATE(P_ELEMINATOR,v_edits_str,v_start) ;
	
	--	Handle the case where we only get one edit with out P_ELEMINATOR
	if ((v_end_pos = 0) and (v_start =1)) then
		SET v_edit_fields_str 	= v_edits_str;
		SET v_end_pos = v_editStrLen;
	elseif (v_end_pos = 0) then
		SET v_edit_fields_str 	= substr(v_edits_str,v_start);
		SET v_end_pos = v_editStrLen;
	else
		SET v_edit_fields_str 	= substr(v_edits_str,v_start,v_end_pos - v_start) ;
	end if;
	
	--=========================================================================
	--	set the position of the starting point of next Fields String
	--	to be the ending positon of the P_ELEMINATOR + 1
	--	also reset the 
	--=========================================================================
	set v_start = v_end_pos + 1;

	--=========================================================================
	--	Extract 6 Fields from the String and populate the corresponding
	--	parameters for inserting into DB
	--=========================================================================
	set v_field_cnt = 0;
	set v_field_start_pos = 1;
	WHILE ( v_field_cnt < 6 ) DO
		set v_field_cnt = v_field_cnt + 1;
		
		--	Determine the position of the Field Delimiter Positon
		SET v_field_delm_pos = LOCATE(v_fieldSep,v_edit_fields_str,v_field_start_pos);
		
		if (v_field_delm_pos = 0) then
			--SET ERROR_CODE  = ;
			--SET DESCRIPTION =  ;
			--EXIT WHILE LOOP;
			SET v_field = SUBSTR(v_edit_fields_str,v_field_start_pos);
		else
			--	extract the Current Field till the field delimiter
			SET v_field = SUBSTR(v_edit_fields_str,v_field_start_pos,v_field_delm_pos - v_field_start_pos);
		end if;
		/*if (v_field = NULL) then
			SET ERROR_CODE = ;
			SET DESCRIPTION =  "Fiels String : = " + v_edit_fields_str + "Field_cnt = " + v_field_cnt + "edits_cnt = " + v_edits_cnt ;
			
			 EXIT WHILE LOOP;
			
			DESCRIPTION = "Fiels String : = " + v_edit_fields_str + "Field_cnt = " + v_field_cnt + "edits_cnt = " + v_edits_cnt;
		end if*/
		
		--	Move the Starting Point of Next Field to the Field Delimiter Pos + 1
		set v_field_start_pos = v_field_delm_pos + 1;

	CASE(v_field_cnt)
		WHEN 1 THEN  
			SET v_editCode 		= v_field;
		WHEN 2 THEN 
			SET v_editLevel 	= v_field;
		WHEN 3 THEN 
			--SET v_svceLineNo	= INT(v_field);
			set v_svceLineNo = 1;
		WHEN 4 THEN 
			SET v_editType 		= v_field;
		WHEN 5 THEN 
			SET v_editStatus	=v_field;
		WHEN 6 THEN 
			SET v_errorCount	=v_field;
		end case;
		
	end while;

	--=========================================================================
	--	Now that we have extracted all the field that are necessary for an
	--	FEE EDIT Code to be inserted let us proceed ahead with an insert.
	--=========================================================================
	if (v_editStatus = '1') then
		INSERT INTO EDIDB2A.T_837_EDIT
			(	CLM_ID, 		EDIT_CD,		EDIT_LVL_CD,	SVC_LINE_NO, 
				EDIT_TYP_CD, 	EDIT_STU_CD , 	EDIT_TS )
		VALUES
			(	v_clm_id, 		v_editCode,		v_editLevel,	v_svceLineNo, 
				v_editType,		v_editStatus, 		CURRENT TIMESTAMP);
	end if;
	
	--	Increment the Edits count as we have processed one Edit Code
	SET v_edits_cnt = v_edits_cnt +1 ;
end while;
	
	IF ( v_edits_cnt > 0 ) THEN
		SET P_ERROR_CD = 0 ;
		SET P_ERROR_DESC = 'Data Inserted';
	ELSE
		SET P_ERROR_CD = 100 ;
		SET P_ERROR_DESC = 'Data Not Inserted';
	END IF ;
	SET p_count = v_edits_cnt ;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_CLM_PERSIST')@


CREATE PROCEDURE  EDIDB2A.SP_837_CLM_PERSIST
(
				IN  p_ClaimClob CLOB,

                IN  p_ClaimID  BIGINT,

                IN  p_Status   INTEGER,

                IN  p_stt_cd   varchar(5),

                IN  p_TraceNum VARCHAR(50),

                IN  p_FileId   BIGINT,

                IN  P_ISA_Id   BIGINT,

                IN  p_GSId     BIGINT,

                IN  p_STId     BIGINT,

                IN  p_PROVID   BIGINT,

                IN  p_SUBSID   BIGINT,

                IN  p_PATID    BIGINT,

                IN  p_CLM_AMT  DECIMAL(15,2),

                IN  p_RenderingProvName varchar(35),               

                IN  p_Rendering_Provider_Id varchar(80),
				
                IN  p_Patient_Account_Number varchar(38), -- CLM01

                IN  p_Destination_Id    varchar(30),

                IN  p_REND_PROV_ENTITY_TYPE_QLFR  CHAR(1),     

                IN  p_REND_PROV_ID_QLFR       CHAR(2), 
               

                IN  p_REND_PROV_ID_CD        varchar(20),
                IN  p_REND_PROV_COMMERCIAL_NUM  varchar(50), 
                IN 	p_PLC_SERV_CD 	    		CHAR(2),
				IN 	p_CLM_FRQ_CD 				INTEGER,
				IN 	p_DIAG_CD 		   VARCHAR(30),
				IN 	p_PAYR_CLM_CTRL_NUM  VARCHAR(50),      
				IN	p_TEST_CD 		CHAR(1),
				IN	p_CLAIM_TYPE_CD		CHAR(1),
                OUT p_errcode INTEGER ,

                OUT p_errdesc VARCHAR(250))
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN

--=============================================================================
--	Declaration of variables
--=============================================================================
DECLARE SQLCODE			INTEGER DEFAULT 0;
DECLARE v_sqlcode 		INTEGER ;

--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (SQLCODE) INTO v_sqlcode;

--=============================================================================
--	Inserting the data into the table  T_837_CLM_PCES_LOG 
--=============================================================================
	INSERT INTO EDIDB2A.T_837_CLM_PCES_LOG(MSG_TS,CLM_OBJ,CLM_ID,CLM_STU_CD) 
			VALUES (CURRENT TIMESTAMP,p_ClaimClob,p_ClaimID,p_Status);
	VALUES (SQLCODE) INTO v_sqlcode;

	IF (v_sqlcode = 0) THEN
	
	--=============================================================================
	--	Inserting the data into the table  T_837_CLM_CTRL_LOG 
	--=============================================================================

		INSERT INTO EDIDB2A.T_837_CLM_CTRL_LOG(
					IN_TRC_NUM,	CLM_STT_CD,		CLM_ID,		FILE_ID,
					ISA_ID,		GS_ID,			ST_ID,		PROV_ID,
					SUBS_ID,	PAT_ID,			CLM_AMT,	REN_PROV_NME,
					REN_PROV_ID,PAT_ACCT_NUM, REND_PROV_ENTITY_TYPE_QLFR,
					REND_PROV_ID_QLFR,REND_PROV_ID_CD,REND_PROV_COMMERCIAL_NUM,
					DEST_ID,PLC_SERV_CD,CLM_FRQ_CD,DIAG_CD,PAYR_CLM_CTRL_NUM,TEST_CD,CLM_TYPE_CD)
		VALUES
				(	p_TraceNum,p_stt_cd,		p_ClaimID,	p_FileId,
					P_ISA_Id,	p_GSId,			p_STId,		p_PROVID,
					p_SUBSID,	p_PATID,		p_CLM_AMT,	p_RenderingProvName,
					p_Rendering_Provider_Id,	p_Patient_Account_Number,
					p_REND_PROV_ENTITY_TYPE_QLFR,p_REND_PROV_ID_QLFR,p_REND_PROV_ID_CD,
					p_REND_PROV_COMMERCIAL_NUM,p_Destination_Id,
					p_PLC_SERV_CD,p_CLM_FRQ_CD,p_DIAG_CD,p_PAYR_CLM_CTRL_NUM,p_TEST_CD,p_CLAIM_TYPE_CD);

		IF (v_sqlcode = 0) THEN
			SET p_errcode = v_sqlcode;
			SET p_errdesc = ' INSERTED SUCESSFULLY IN T_837_CLM_PCES_LOG AND T_837_CLM_CTRL_LOG';
		ELSE
			SET p_errcode = v_sqlcode;
			SET p_errdesc = ' INSERTION FAILED IN T_837_CLM_CTRL_LOG';
		END IF;
	ELSE
		SET p_errcode = v_sqlcode;
		SET p_errdesc = ' INSERTION FAILED IN T_837_CLM_PCES_LOG';
	END IF;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_INSERT_EDITS5')@

CREATE PROCEDURE EDIDB2A.SP_837_INSERT_EDITS5( 
	IN P_CLM_ID BIGINT , 
	IN P_STRING VARCHAR(1000), 
	IN P_FSEPERATOR VARCHAR(1), 
	IN P_FELEMINATOR VARCHAR(1), 
	OUT	P_COUNT INT, 
	OUT p_ERR_CODE 	BIGINT, 
	OUT p_ERR_DESC 	VARCHAR(255) )
 BEGIN 
 
 --=============================================================================
--	Declaration of variables
--=============================================================================

 DECLARE v_string VARCHAR(6000);--
 DECLARE v_rstring VARCHAR(6000);
 DECLARE v_felm VARCHAR(1);
 DECLARE v_fsep VARCHAR(1);
 DECLARE v_substring VARCHAR(500);
 DECLARE v_substring1 VARCHAR(500);
 DECLARE v_substring2 VARCHAR(2000);
 DECLARE v_substring3 VARCHAR(1000);
 DECLARE v_substring4 VARCHAR(1000);
 DECLARE v_stringlength INT;
 DECLARE v_firststring VARCHAR(50);
 DECLARE v_secondstring VARCHAR(50);
 DECLARE v_thirdstring VARCHAR(50);
 DECLARE v_fourthstring VARCHAR(50);
 DECLARE v_fifthstring VARCHAR(50);
 DECLARE v_m INT default 1;
 DECLARE v_n INT;
 DECLARE v_count INT default 0 ;
 
 SET v_string	=P_STRING; SET v_felm		=P_FELEMINATOR;
 SET v_fsep		=P_FSEPERATOR;
 SET v_rstring = REPLACE(v_string,v_felm, '');
 SET v_n=(LENGTH(v_string) - LENGTH(v_rstring)); 
 
 WHILE (v_m<=v_n) DO
 
 SET v_substring=SUBSTR(v_string,1,(LOCATE(v_felm,v_string)-1)); 
 SET v_firststring=SUBSTR(v_substring,1,(LOCATE(v_fsep,v_substring)-1)); 
 SET v_stringlength=LENGTH(v_firststring);
 SET v_substring1=SUBSTR(v_substring,v_stringlength+2);
 SET v_secondstring =SUBSTR(v_substring1,1,(LOCATE(v_fsep,v_substring1)-1));
 SET v_stringlength=LENGTH(v_secondstring); 
 SET v_substring2=SUBSTR(v_substring1,v_stringlength+2); 
 SET v_thirdstring=SUBSTR(v_substring2,1,(LOCATE(v_fsep,v_substring2)-1)); 
 SET v_stringlength=LENGTH(v_thirdstring); 
 SET v_substring3=SUBSTR(v_substring2,v_stringlength+2); 
 SET v_fourthstring=SUBSTR(v_substring3,1,(LOCATE(v_fsep,v_substring3)-1)); 
 SET v_stringlength=LENGTH(v_fourthstring); 
 SET v_substring4=SUBSTR(v_substring3,v_stringlength+2); 
 SET v_fifthstring=SUBSTR(v_substring4,1,(LOCATE(v_fsep,v_substring4)-1));
 
--=============================================================================
--	Inserting the data into the table  T_837_EDIT 
--=============================================================================
 INSERT INTO EDIDB2A.T_837_EDIT (CLM_ID,SEG_NME,EDIT_CD,EDIT_STU_CD, CUST_ERR_TXT,EDIT_TS) 
 VALUES( P_CLM_ID,v_firststring,v_secondstring,	v_thirdstring, v_fourthstring,CURRENT TIMESTAMP); 
 
 SET v_count = v_count+1;
 SET v_stringlength=LENGTH(v_substring); 
 SET v_string=SUBSTR(v_string,v_stringlength+2);
 SET v_m = v_m+1; 
 END WHILE; 
 SET P_COUNT=v_count;
 END@



--=============================================================================
--	Function:	sp_cleanup_837()
--	Description:
--	Used to cleanup all the records in 837 Tables. 
--	PLEASE ENSURE THAT WE DONT EXECUTE THIS ON PRODUCTION DATABASE TABLES $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
--	Author:	Nanaji Veturi
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.sp_cleanup_837')@

CREATE PROCEDURE EDIDB2A.sp_cleanup_837()
BEGIN
	DELETE FROM  EDIDB2A.T_837_CLM_CTRL_LOG;
	DELETE FROM  EDIDB2A.T_837_FILE_PCES_LOG;
	DELETE FROM  EDIDB2A.T_837_PCES_TME_TRCK ;
	DELETE FROM  EDIDB2A.T_837_ISA ;
	DELETE FROM  EDIDB2A.T_837_ST ;
	DELETE FROM  EDIDB2A.T_837_GS ;
	DELETE FROM  EDIDB2A.T_837_PROV ;
	DELETE FROM  EDIDB2A.T_837_SUBS ;
	DELETE FROM  EDIDB2A.T_837_SERVLN ;
	DELETE FROM  EDIDB2A.T_837_PAT ;
	DELETE FROM  EDIDB2A.T_837_CLM_PCES_LOG ;
	DELETE FROM  EDIDB2A.T_837_EDIT ;
	DELETE FROM  EDIDB2A.T_TP_TRAN_DUP_CHK;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_CLAIM_SEQUENCE_NOS')@

CREATE PROCEDURE EDIDB2A.SP_837_GET_CLAIM_SEQUENCE_NOS(IN p_clm_cnt INTEGER, OUT p_seqnos CLOB)
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_seq_str CHAR(50);
	DECLARE v_seq_nextval BIGINT;
	DECLARE v_cnt INTEGER;
	
	SET p_seqnos = '';
	SET v_cnt = p_clm_cnt;
	WHILE (v_cnt > 0)
	DO
		set v_seq_nextval = NEXT VALUE FOR  EDIDB2A.CLAIM_SEQ;
		-- set v_seq_str = cast(v_seq_nextval as char(10) );
		--set p_seqnos = p_seqnos || cast(v_cnt as char) || '-' ||cast(v_seq_nextval as char);
		set p_seqnos = p_seqnos ||trim(cast(v_seq_nextval as char(15)));
		SET v_cnt = v_cnt - 1;
		if (v_cnt <> 0) THEN	set p_seqnos = p_seqnos || '|'; END IF;
	END WHILE;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GENERATE_REF_D9')@

CREATE PROCEDURE EDIDB2A.SP_837_GENERATE_REF_D9(
IN P_DESTINATION    VARCHAR(20),
OUT P_OUT_REF_02  VARCHAR(30),
OUT P_ERRCODE	INTEGER ,
OUT P_ERRDESC	VARCHAR(50)  )
  
LANGUAGE SQL
MODIFIES SQL DATA
  
BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
DECLARE SQLCODE	INTEGER DEFAULT 0;
DECLARE V_SQLCODE  INTEGER;
DECLARE V_REF_02   CHAR(3) ;
DECLARE V_SEQ_STR CHAR(7); 
DECLARE V_SEQ_STR1 CHAR(5);
DECLARE V_ERRCODE INTEGER DEFAULT 0;
DECLARE V_ERRDESC	VARCHAR(50) DEFAULT 'DESTINATION FOUND' ;
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (SQLCODE ) INTO V_SQLCODE;
    
 SET P_ERRCODE = V_ERRCODE;
 SET P_ERRDESC = V_ERRDESC;                                

                CASE P_DESTINATION 
                
                 WHEN '00953' THEN
			
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	  
                                SELECT SUBSTR(CHAR((NEXT VALUE FOR  REFD9_00953_SEQ) +10000000),2,7) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET P_OUT_REF_02 = V_REF_02 || V_SEQ_STR || 'WPS';
								
			   	WHEN '17003' THEN
								
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	  
                                SELECT SUBSTR(CHAR((NEXT VALUE FOR  REFD9_17003_SEQ) +10000000),2,7) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET P_OUT_REF_02 = V_REF_02 || V_SEQ_STR || 'CEDI';
								
				 WHEN  'FEP' THEN
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	  
                                SELECT CAST(NEXT VALUE FOR  REFD9_FEP_SEQ AS CHAR(7)) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET P_OUT_REF_02 = CHAR('0')|| V_REF_02 || V_SEQ_STR;
								
				
			    WHEN 'FEPX' THEN 
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	   
                                SELECT CAST(NEXT VALUE FOR  REFD9_FEPX_SEQ AS CHAR(7)) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET P_OUT_REF_02 = CHAR('0') || V_REF_02 || V_SEQ_STR;
							
										
				WHEN 'PPOM5010' THEN
				
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	   
                                SELECT SUBSTR(CHAR((NEXT VALUE FOR  REFD9_PPOM5010_SEQ) +10000000),2,7) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET P_OUT_REF_02 = V_REF_02 || V_SEQ_STR || 'COFIN';
				
				
				WHEN  'FACETSTHG' THEN	
								SELECT SUBSTR(CHAR((NEXT VALUE FOR  REFD9_FACETSTHG_SEQ) +100000),2,5) INTO V_SEQ_STR1 FROM SYSIBM.SYSDUMMY1;
								SET  P_OUT_REF_02 =  V_SEQ_STR1;				
						
								                                		
				WHEN 'FACETSTHGX' THEN	
				
								SELECT SUBSTR(CHAR((NEXT VALUE FOR  REFD9_FACETSTHGX_SEQ) +100000),2,5) INTO V_SEQ_STR1 FROM SYSIBM.SYSDUMMY1;
								SET  P_OUT_REF_02 =  V_SEQ_STR1;								
				
				
				WHEN 'BCMPGBAHEALT1' THEN
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	   
								SELECT CAST(NEXT VALUE FOR  REFD9_BCMPGBAHEALT1_SEQ AS CHAR(7)) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET  P_OUT_REF_02 =  CHAR('0') || V_REF_02 || V_SEQ_STR;	
								
								
				 WHEN  'DMENSIONS' THEN 
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	 
								SELECT CAST(NEXT VALUE FOR  REFD9_DMENSIONS_SEQ AS CHAR(7)) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET  P_OUT_REF_02 =  CHAR('0') || V_REF_02 || V_SEQ_STR;	
								
		
				WHEN 'MOS' THEN
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	 
								SELECT CAST(NEXT VALUE FOR  REFD9_MOS_SEQ AS CHAR(7)) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET  P_OUT_REF_02 = CHAR('0') || V_REF_02 ||  V_SEQ_STR;	
 
 
				WHEN 'MOSX' THEN
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	 
								SELECT CAST(NEXT VALUE FOR  REFD9_MOSX_SEQ AS CHAR(7)) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET  P_OUT_REF_02 =  CHAR('0') || V_REF_02 || V_SEQ_STR;	
								
												
				WHEN 'GLAKES5010'  THEN
				
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	   
                             	SELECT SUBSTR(CHAR((NEXT VALUE FOR  REFD9_GLAKES5010_SEQ) +10000000),2,7) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET P_OUT_REF_02 = V_REF_02 || V_SEQ_STR || 'ENS'; 
                                
                WHEN 'AUTONATIONAL'  THEN
				
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	   
                             	SELECT CAST(NEXT VALUE FOR  REFD9_AUTONATIONAL_SEQ AS CHAR(7)) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET P_OUT_REF_02 = CHAR('0')|| V_REF_02 || V_SEQ_STR;
                                
                WHEN 'AUTONATIONALX'  THEN
				
								SELECT SUBSTR(CHAR(DAYOFYEAR(CURRENT DATE)+1000),2,3)  INTO V_REF_02 FROM SYSIBM.SYSDUMMY1;	  
                             	SELECT CAST(NEXT VALUE FOR  REFD9_AUTONATIONALX_SEQ AS CHAR(7)) INTO V_SEQ_STR FROM SYSIBM.SYSDUMMY1;
                                SET P_OUT_REF_02 = CHAR('0') || V_REF_02 || V_SEQ_STR;  
                  
                
                ELSE 
                      SET P_ERRCODE = 100;
                      SET P_ERRDESC = 'DESTINATION NOT FOUND';
                         
                 END CASE;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UTIL_999_UPD_STT ')@

CREATE PROCEDURE "EDIDB2A"."SP_UTIL_999_UPD_STT" (
    IN "P_PARENTFILEID" VARCHAR(15),
    IN "P_FILEROOT"	VARCHAR(200),
    IN "P_FILESUBROOT" VARCHAR(100),
    IN "P_FILEIDS"	VARCHAR(500),
    IN "P_TRANNUM"	VARCHAR(5),
    IN "P_SOURCESTRING"	VARCHAR(500),
    IN "P_DELIMITER"	VARCHAR(1),
    OUT "P_ERR_CODE"	INTEGER,
    OUT "P_ERR_DESC"	VARCHAR(50) )
 
BEGIN
DECLARE v_fileIds VARCHAR(500);
DECLARE v_fileId VARCHAR(15);
DECLARE v_SourceString VARCHAR(500);
DECLARE v_fileNme VARCHAR(60);
DECLARE v_locate INTEGER DEFAULT 0;
DECLARE v_locate1 INTEGER DEFAULT 0;
DECLARE v_start INTEGER DEFAULT 1;
DECLARE v_Delimiter VARCHAR(2);
DECLARE v_FILEID_COUNT INTEGER default 0;
DECLARE v_SOURCESTRING_COUNT INTEGER DEFAULT 0;
DECLARE v_tranNum VARCHAR(5);
DECLARE v_rString VARCHAR(100);
DECLARE v_rootDir VARCHAR(100);
DECLARE v_subDir VARCHAR(100);
DECLARE v_rString1 VARCHAR(200);
DECLARE v_fileRoot VARCHAR(100);
DECLARE v_fileSubRoot VARCHAR(100);
DECLARE v_filePath VARCHAR(200);
DECLARE v_fIleStatus VARCHAR(5);
SET v_fileRoot = P_FILEROOT;
SET v_fileSubRoot = P_FILESUBROOT;
SET v_SourceString = P_SOURCESTRING;
SET v_fileids = P_FILEIDS;
SET v_tranNum = P_TRANNUM;
SET v_filePath = v_fileRoot||v_fileSubRoot;
SET v_fIleStatus = '16';
SET v_Delimiter = P_DELIMITER;


set v_SOURCESTRING_COUNT = length(v_SourceString);
set v_FILEID_COUNT = length(v_fileids);

-- ============================================================
-- TO FIND THE NUMBER OF FIELD TERMINATORS
-- ============================================================
--SET v_rString = REPLACE(v_SourceString,v_Delimiter,'');
--SET v_n=(LENGTH(v_SourceString) - LENGTH(v_rString));

--SET v_rString1 = REPLACE (P_FILEIDS, v_Delimiter, '');

-- ==============================================================
-- REPEAT LOOP FOR 'n' NUMBER OF OCCURENCES OF FIELD TERMINATOR
-- ==============================================================

WHILE (v_FILEID_COUNT > 0 and v_SOURCESTRING_COUNT > 0)
 
DO

	set v_locate  = locate(v_Delimiter,v_fileIds);
	SET v_fileId  = SUBSTR(v_fileIds,v_start,v_locate-1);
	
	set v_locate1 = locate(v_Delimiter,v_SourceString);
	SET v_fileNme = SUBSTR(v_SourceString,v_start,v_locate1-1);

	
	
	set v_fileids = substr(v_fileids,v_locate+1);
	set v_SourceString = substr(v_SourceString,v_locate1+1);

	set v_SOURCESTRING_COUNT = length(v_SourceString);
	set v_FILEID_COUNT = length(v_fileIds);

		
	IF v_tranNum = '837' THEN
  		INSERT INTO T_837_FILE_PCES_LOG(FILE_ID,FILE_NME,FILE_ROOT_DTRY_TXT,FILE_SUB_DTRY_TXT,PRNT_FILE_ID,FILE_STT_CD) VALUES(CAST(v_fileId AS BIGINT),v_fileNme,v_fileRoot,v_fileSubRoot,CAST(P_PARENTFILEID AS BIGINT),v_fIleStatus );
		
	ELSEIF v_tranNum = '834' THEN
		--INSERT INTO T_834_FILE_CTRL_LOG (FILE_ID,FILE_PATH_TXT,FILE_NME,PRNT_FILE_ID,FILE_STT_CD) VALUES(CAST(v_fileId AS BIGINT),v_filePath,v_fileNme,CAST(P_PARENTFILEID AS BIGINT),v_fIleStatus );
	ELSEIF v_tranNum = '835' THEN
	 INSERT INTO T_835_FILE_PCES_LOG (FILE_ID,FILE_NME,FILE_ROOT_DTRY_TXT,FILE_SUB_DTRY_TXT,PRNT_FILE_ID,FILE_STT_CD) VALUES(CAST(v_fileId AS BIGINT),v_fileNme,v_fileRoot,v_fileSubRoot,CAST(P_PARENTFILEID AS BIGINT),v_fIleStatus );
	ELSEIF v_tranNum = '820' THEN
	-- INSERT INTO T_820_FILE_CTRL_LOG (FILE_ID,FILE_NME,FILE_PATH_TXT,PRNT_FILE_ID,FILE_STT_CD) VALUES(CAST(v_INPUTFILEID AS BIGINT),v_filePath,v_INPUTFILENAME,CAST(P_PARENTFILEID AS BIGINT),v_fIleStatus );
	ELSE
	SET P_ERR_CODE = 100;
	SET P_ERR_DESC = 'Transaction Type Invalid';
	END IF;

set P_ERR_DESC = P_ERR_DESC ||'^'||v_fileNme;


END WHILE;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UTIL_GET_ACK_FILE_NAMES_FOR_TX')@

CREATE PROCEDURE EDIDB2A.SP_UTIL_GET_ACK_FILE_NAMES_FOR_TX (
    IN  P_TP_ID					VARCHAR(20),
		IN  P_TP_QLFR				CHARACTER(2),
    IN  P_FILE_TYPE_CD	CHARACTER(1),
    OUT P_FILES_LIST		CLOB(1M),
		OUT P_ERR_CODE 			BIGINT,
		OUT P_ERR_DESC 			VARCHAR(500))
  SPECIFIC SQL100919200655300
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN
	--=============================================================================
----DECLERATIOIN OF VARIABLES IN PROCEDURE   
--=============================================================================
	
	DECLARE SQLCODE	INTEGER DEFAULT 000;
	DECLARE SQLERRMC VARCHAR(500) DEFAULT '';
	DECLARE v_sqlcode INTEGER ;
	DECLARE v_837_count INTEGER;
	DECLARE v_835_count INTEGER;
	DECLARE v_file_name VARCHAR(30);
	DECLARE v_file_root_dir VARCHAR(30);
	DECLARE v_file_sub_dir VARCHAR(30);
	
	DECLARE FILES_LIST_837 CURSOR FOR SELECT FILE_NME,FILE_ROOT_DTRY_TXT,FILE_SUB_DTRY_TXT FROM T_837_FILE_PCES_LOG WHERE RECR_ID=P_TP_ID AND RECR_QLFR = P_TP_QLFR AND FILE_FMT_CD=P_FILE_TYPE_CD AND FILE_STT_CD='10';
	--=============================================================================
    --	Setup the EXIT HANDLER for all SQL EXCEPTIONS
    --=============================================================================
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_sqlcode ; 
	
	SELECT COUNT(FILE_NME) INTO v_837_count FROM T_837_FILE_PCES_LOG WHERE RECR_ID=P_TP_ID AND RECR_QLFR = P_TP_QLFR AND FILE_FMT_CD=P_FILE_TYPE_CD AND FILE_STT_CD='10';
	--SELECT COUNT(FILE_NME) INTO v_835_count FROM T_835_FILE_PCES_LOG WHERE RECR_ID=P_TP_ID AND RECR_QLFR = P_TP_QLFR AND FILE_FMT_CD=P_FILE_TYPE_CD AND FILE_STT_CD='10';
	SET v_sqlcode = SQLCODE;
	SET P_ERR_DESC = SQLERRMC;
	
	SET P_FILES_LIST = '';
	OPEN FILES_LIST_837;
		WHILE(v_837_count <> 0)
		DO
--=============================================================================
--  Fetch from the cursor into the variable declared                                    
--=============================================================================
			FETCH FROM FILES_LIST_837 INTO v_file_name,v_file_root_dir,v_file_sub_dir;
			SET v_sqlcode = SQLCODE;
			SET P_ERR_DESC = SQLERRMC;
			SET P_FILES_LIST = P_FILES_LIST||v_file_root_dir||v_file_sub_dir||v_file_name||',';
			SET v_837_count = v_837_count -1;
		END WHILE;
		SET P_FILES_LIST = P_FILES_LIST||'~';
	CLOSE FILES_LIST_837;
		
	/*OPEN FILES_LIST_835;
		WHILE(v_835_count <> 0)
		DO
			FETCH FROM FILES_LIST_835 INTO v_file_name,v_file_root_dir,v_file_sub_dir;
			SET v_sqlcode = SQLCODE;
			SET P_ERR_DESC = SQLERRMC;
			SET P_FILES_LIST = P_FILES_LIST||v_file_root_dir||v_file_sub_dir||v_file_name||',';
			SET v_837_count = v_835_count -1;
		END WHILE;	
		SET P_FILES_LIST = P_FILES_LIST||'~';
	CLOSE FILES_LIST_835;*/
		IF v_sqlcode <> 0 THEN
			SET P_ERR_CODE = 39930003;
		ELSE 
			SET P_ERR_CODE = 0;
		END IF;
END@



CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UTIL_GET_TP_LIST_FOR_ACK_TX')@


CREATE PROCEDURE EDIDB2A.SP_UTIL_GET_TP_LIST_FOR_ACK_TX (
    IN  P_BULKER_TYPE   CHARACTER(1),
	OUT P_TP_LIST		VARCHAR(100),
    OUT P_TP_COUNT		INTEGER,
    OUT P_ERR_CODE		BIGINT,
    OUT P_ERR_DESC		VARCHAR(255))
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE SQLCODE	INTEGER DEFAULT 000;
	DECLARE SQLERRMC VARCHAR(500) DEFAULT '';
	DECLARE v_sqlcode INTEGER ;
	DECLARE v_TP_list VARCHAR(1000); 
	DECLARE v_TP_ID VARCHAR(20);
	DECLARE v_TP_QLFR CHARACTER(2);
	DECLARE v_count_837 INTEGER;
	DECLARE v_count_835 INTEGER;
	
	DECLARE DEST_CURSR_837  CURSOR FOR SELECT DISTINCT RECR_ID,RECR_QLFR FROM T_837_FILE_PCES_LOG WHERE RECR_ID IS NOT NULL AND FIlE_FMT_CD=P_BULKER_TYPE AND FILE_STT_CD='10' ;
	--DECLARE DEST_CURSR_835  CURSOR FOR SELECT DISTINCT(RECR_ID,RECR_QLFR) FROM T_837_FILE_PCES_LOG WHERE RECR_ID IS NOT NULL AND FIlE_FMT_CD=P_BULKER_TYPE AND FILE_STT_CD='10' ;
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_sqlcode ; 
	
	SELECT COUNT(*) INTO v_count_837 FROM (SELECT DISTINCT RECR_ID,RECR_QLFR FROM T_837_FILE_PCES_LOG WHERE RECR_ID IS NOT NULL AND FIlE_FMT_CD=P_BULKER_TYPE AND FILE_STT_CD='10');
	--SELECT COUNT(DISTINCT(RECR_ID,RECR_QLFR)) INTO v_count_835 FROM T_837_FILE_PCES_LOG WHERE RECR_ID IS NOT NULL AND FIlE_FMT_CD=P_BULKER_TYPE AND FILE_STT_CD='10';
	SET v_sqlcode = SQLCODE;
	SET P_ERR_DESC = SQLERRMC;
	
	SET p_TP_count = v_count_837 + v_count_835;
	OPEN DEST_CURSR_837;
		SET v_TP_list= '';
		WHILE (v_count_837 <> 0) DO 
--=============================================================================
--  Fetch from the cursor into the variable declared        
--=============================================================================
			FETCH FROM DEST_CURSR_837 INTO v_TP_ID,v_TP_QLFR;
			SET v_sqlcode = SQLCODE;
			SET P_ERR_DESC = SQLERRMC;
			SET v_TP_list=v_TP_list||v_TP_ID||'#'||v_TP_QLFR||',';
			SET v_count_837=v_count_837-1;
		END WHILE;
		SET P_TP_LIST = v_TP_list || '~';
	CLOSE DEST_CURSR_837;
	UPDATE T_837_FILE_PCES_LOG SET FILE_STT_CD = '13' WHERE SUBM_ID IS NOT NULL AND FIlE_FMT_CD=P_BULKER_TYPE AND FILE_STT_CD='10';
	SET v_sqlcode = SQLCODE;
	SET P_ERR_DESC = SQLERRMC;
	
	IF v_sqlcode <> 0 THEN
		SET P_ERR_CODE = 39930003;
	ELSE
		SET P_ERR_CODE = 0;
	END IF;
			
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_GET_SEQUENCE_NOS')@

CREATE PROCEDURE "EDIDB2A"."SP_837_GET_SEQUENCE_NOS" (
    IN "P_ISA_CNT"	INTEGER,
    IN "P_GS_CNT"	INTEGER,
    IN "P_ST_CNT"	INTEGER,
    IN "P_PROV_CNT"	INTEGER,
    IN "P_SBR_CNT"	INTEGER,
    IN "P_PAT_CNT"	INTEGER,
    IN "P_CLM_CNT"	INTEGER,
    OUT "P_SEQNOS"	VARCHAR(12) )
	SPECIFIC "SQL100925153537202"
	LANGUAGE SQL
	NOT DETERMINISTIC
	EXTERNAL ACTION
	MODIFIES SQL DATA
	CALLED ON NULL INPUT
	INHERIT SPECIAL REGISTERS
BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE SQLCODE INTEGER ; 
	DECLARE v_cnt INTEGER; 
	DECLARE v_cur_no BIGINT; 
	DECLARE v_sqlcode INTEGER ; 
	DECLARE p_ERR_CODE INTEGER; 
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION VALUES (SQLCODE) INTO v_sqlcode; 

	SET p_seqnos = ''; 
	SET v_cnt = p_isa_cnt + p_gs_cnt + p_st_cnt + p_prov_cnt + p_sbr_cnt + p_pat_cnt + p_clm_cnt; 
	set v_cur_no = NEXT VALUE FOR  EDIDB2A.CLAIM_SEQ;
	SET p_seqnos = trim(cast(v_cur_no as char(12))); 
	WHILE (v_cnt > 0)
	DO
		set v_cur_no = NEXT VALUE FOR  EDIDB2A.CLAIM_SEQ,v_cnt = v_cnt  -1;
		-- SET v_cnt = v_cnt - 1;
	END WHILE;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_COMMERCIAL_PAYER_ID_VALIDATE')@

CREATE PROCEDURE EDIDB2A.SP_837_COMMERCIAL_PAYER_ID_VALIDATE ( 
IN p_PAYER_ID CHAR(5) , 
IN p_CLM_OFF_NO CHAR(4) , 
OUT p_OUT_PAYER_ID CHAR(5) , 
OUT p_OUT_CLM_OFF_NO CHAR(4), 
OUT p_EDIT_CODE CHAR(4), 
OUT p_error_cd INTEGER, 
OUT p_err_desc VARCHAR(255) ) 
LANGUAGE SQL 
BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
DECLARE v_PAYER_NAME CHAR(27) ; 
DECLARE SQLCODE INTEGER DEFAULT 0; 
DECLARE v_sqlcode INTEGER DEFAULT 0; 
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
VALUES (SQLCODE) INTO v_sqlcode ; 
--=============================================================================
--	Retrieving Data from Table PAYERID based on PAYER_ID and PAYER_CLM_OFF_NO
--=============================================================================
SELECT PAYER_NAME INTO v_PAYER_NAME FROM  EDIDB2A.PAYERID WHERE PAYER_ID = p_PAYER_ID AND PAYER_CLM_OFF_NO = p_CLM_OFF_NO; 
SELECT SQLCODE into v_sqlcode from sysibm.sysdummy1 ; 
IF (v_sqlcode = 0 ) THEN 
   SET p_OUT_PAYER_ID   = p_PAYER_ID ; 
   SET p_OUT_CLM_OFF_NO = p_CLM_OFF_NO ; 
ELSEIF (v_sqlcode = 100) THEN 
  	SELECT OUT_PAYER_ID,OUT_CLM_OFF_NO INTO p_OUT_PAYER_ID ,p_OUT_CLM_OFF_NO FROM EDIDB2A.T_LKP_COMM_PAYER WHERE IN_PAYER_ID = p_PAYER_ID AND IN_CLM_OFF_NO = p_CLM_OFF_NO ; 
	SELECT SQLCODE into v_sqlcode from sysibm.sysdummy1 ; 
		IF ( v_sqlcode = 0 ) THEN 
			SELECT PAYER_NAME INTO v_PAYER_NAME FROM EDIDB2A.PAYERID WHERE PAYER_ID = p_OUT_PAYER_ID  AND PAYER_CLM_OFF_NO = p_OUT_CLM_OFF_NO; 
			SELECT SQLCODE into v_sqlcode from sysibm.sysdummy1 ; 
			IF ( v_sqlcode = 100 ) THEN 
				SET p_EDIT_CODE = 'P017' ; 
				SET p_error_cd = v_sqlcode ;
			ELSEIF((v_sqlcode <>100) AND (v_sqlcode <>0)) THEN 
					SET p_error_cd = v_sqlcode ; 
					SET p_err_desc = 'DB2 ERROR  ' ; 
					SET p_OUT_PAYER_ID = ''; 
					SET p_OUT_CLM_OFF_NO = ''; 
			END IF ; 
		ELSEIF (v_sqlcode = 100)THEN 
			SET p_EDIT_CODE = 'P017' ; 
			SET p_OUT_PAYER_ID = ''; 
			SET p_OUT_CLM_OFF_NO = ''; 
			SET p_error_cd = v_sqlcode ;
		ELSE 
			SET p_error_cd = v_sqlcode ; 
			SET p_err_desc = 'DB2 ERROR  ' ; 
			SET p_OUT_PAYER_ID = ''; 
			SET p_OUT_CLM_OFF_NO = ''; 
		END IF ; 
ELSE 
	SET p_error_cd = v_sqlcode ; 
	SET p_err_desc = 'DB2 ERROR  ' ; 
	SET p_OUT_PAYER_ID = ''; 
	SET p_OUT_CLM_OFF_NO = ''; 
END IF ; 
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_LIST')@

CREATE PROCEDURE  EDIDB2A.SP_TP_LIST (
    OUT "P_TP_LIST"	VARCHAR(100),
    OUT "P_TP_COUNT"	INTEGER,
    OUT "P_ERR_CODE"	BIGINT,
    OUT "P_ERR_DESC"	VARCHAR(255) )
  
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_TP_list VARCHAR(1000); 
	DECLARE v_TP_ID VARCHAR(20);
	DECLARE v_count INTEGER;
	DECLARE DEST_CURSR  CURSOR FOR SELECT DISTINCT(SUBM_ID) FROM EDIDB2A.T_837_FILE_PCES_LOG where SUBM_ID <> '';
	
	SET v_TP_list= '';
	SELECT COUNT(DISTINCT(SUBM_ID)) INTO v_count FROM EDIDB2A.T_837_FILE_PCES_LOG where SUBM_ID <> '' ;
	SET p_TP_count=v_count;
	OPEN DEST_CURSR;
		WHILE (v_count <> 0) DO 
--=============================================================================
--  Fetch from the cursor into the variable declared           
--=============================================================================
			FETCH FROM DEST_CURSR INTO v_TP_ID;
			SET v_TP_list=v_TP_list||v_TP_ID||',';
			SET v_count=v_count-1;
		END WHILE;
		SET P_TP_LIST = v_TP_list;
	CLOSE DEST_CURSR;
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_837_EXTRACT_CLAIMS_OUTBOUND')@

CREATE PROCEDURE EDIDB2A.SP_837_EXTRACT_CLAIMS_OUTBOUND(
    IN 		p_DEST_ID			VARCHAR(30),
	IN 		p_CLAIM_TYPE		CHAR(1),
	IN		p_GRP_TYPE			CHAR(1),  
	IN		p_ST_THRESHOLD		INTEGER,
	IN  	p_TEST_CD       	CHAR(1),
	IN 		p_TP_QLFR_ID 		VARCHAR(02),
	IN 		p_TP_ID 			VARCHAR(40),
	IN 		p_TRAN_NUM 			VARCHAR(4),
	IN  	p_TRAN_VER_NUM  	VARCHAR(12),
	IN  	p_ELEMENT_DLM		CHAR(1),
	IN 		p_SEGMENT_DLM		CHAR(1),
	IN 		p_COMPOSITE_DLM		CHAR(1),
	IN		p_IN_USAGE_CD_ISA15	CHAR(1),
    OUT 	p_OUTBUFFER			CLOB(40M),
    OUT 	p_CLM_COUNT			INTEGER,
	OUT 	p_ERR_CODE 			BIGINT,
	OUT 	p_ERR_DESC 			VARCHAR(255)
	)
BEGIN

DECLARE v_SENDER_ID VARCHAR(15) ;
DECLARE v_prev_SENDER_ID VARCHAR(15) DEFAULT '';

DECLARE v_bpv_ID BIGINT; --### temp billing provider
DECLARE v_prev_bpv_ID BIGINT;

DECLARE v_subs_ID BIGINT; 
DECLARE v_prev_subs_ID BIGINT;

DECLARE v_pat_ID BIGINT ;
DECLARE v_prev_pat_ID BIGINT ; 

DECLARE v_clm_ID BIGINT;

DECLARE v_ISA_CTRL_NO VARCHAR(9);

DECLARE v_count INTEGER DEFAULT 0;
DECLARE v_cur_clm_cnt INTEGER;
DECLARE v_tot_clm_cnt INTEGER;

DECLARE v_bpv_outBuffer VARCHAR(4000);
DECLARE v_subs_outBuffer VARCHAR(3000);
DECLARE v_pat_outBuffer VARCHAR(3000) ;
DECLARE v_clm_outBuffer CLOB(5M);
DECLARE v_isa_outBuffer VARCHAR(3000);
DECLARE v_gs_outBuffer VARCHAR(3000) ;
DECLARE v_st_outBuffer VARCHAR(3000) ;

DECLARE v_PAYER_ID  VARCHAR(80) ;
DECLARE v_prev_PAYER_ID  VARCHAR(80) ;

DECLARE v_isa_ID BIGINT;
DECLARE v_gs_ID BIGINT ;
DECLARE v_st_ID BIGINT ;

DECLARE v_DIR_IND CHAR(1) DEFAULT 'O';

	DECLARE SQLCODE INTEGER DEFAULT 0;
	DECLARE v_SQLCODE INTEGER;


--==============================================================================
--	Declare a Cursor to retrieve all the Claims for the Local Destination (### This should be for all)
--	That are ready to be Bulked and group them by the Sender_ID and Payer_ID
--==============================================================================

DECLARE ClaimsCursor CURSOR FOR SELECT 			
			CLAIMS.SNDR_ID 	 AS SENDER_ID,
			CLAIMS.PAYR_ID 	 AS PAYER_ID,
			CLAIMS.ISA_ID 	 AS ISA_ID,	
			CLAIMS.GS_ID 	 AS GS_ID, 
			CLAIMS.ST_ID 	 AS ST_ID,
			CLAIMS.PROV_ID 	 AS PROV_ID, 
			CLAIMS.SUBS_ID 	 AS SUBS_ID,
			CLAIMS.PAT_ID 	 AS PAT_ID,
			CLAIMS.CLM_ID    AS CLAIM_ID
		FROM 	
			EDIDB2A.T_837_CLM_CTRL_LOG CLAIMS 
		WHERE	
			CLAIMS.DEST_ID = p_DEST_ID 
			AND CLAIMS.CLM_STT_CD = '10052' 
			AND CLAIMS.TEST_CD = p_TEST_CD
			AND CLAIMS.CLM_TYPE_CD = p_CLAIM_TYPE
		ORDER BY 
			CLAIMS.SNDR_ID,CLAIMS.PAYR_ID,CLAIMS.ISA_ID,CLAIMS.GS_ID, 
			CLAIMS.ST_ID, CLAIMS.PROV_ID, CLAIMS.SUBS_ID, CLAIMS.PAT_ID
		WITH UR;

--=============================================================================
-- Setup the EXIT handler for all SQL exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION	
	VALUES (SQLCODE) INTO v_SQLCODE;
			
	SET p_ERR_CODE = 0;
	SET p_ERR_DESC = '';
	SET p_OUTBUFFER = '';
	SET	v_prev_bpv_ID = 0;
	SET v_prev_subs_ID = 0;
	SET v_prev_pat_ID = 0;
	SET p_CLM_COUNT = 0;
	SET v_cur_clm_cnt = 0;

	--==============================================================================
	--  Open the ClaimsCursor and loop around all the claims in the cursor 
	--	to determine when to output the ISA Header and Payer Header or not.
	--==============================================================================
	SET p_ERR_DESC = 'BEFORE OPEN CLAIM';
	OPEN ClaimsCursor;
	VALUES (SQLCODE) INTO v_SQLCODE;
	IF (v_SQLCODE > 0) THEN
		SET p_ERR_DESC = 'ERROR CODE : =' || char(v_SQLCODE);
	END IF;
	
	--==============================================================================
	--	Now loop around the Claims Cursor until we consume all the claims found
	--	At the Start of the Loop initailize the 
	--		Previous SENDER ID and 
	--		Previous Payer ID
	--==============================================================================

	Set v_prev_SENDER_ID = '';
	--==============================================================================
	--	### Please make sure v_tot_clm_cnt and v_cur_clm_cnt are initialized
	--	p_GRP_TYPE =1 "1 ISA per submitter", 1 GS with multiple STs (max claims in ST=5000). 
	--	No multiple GS within an ISA.
	--==============================================================================
	SET v_SQLCODE = 0;
	IF (p_GRP_TYPE = '1') THEN 
		
		WHILE (v_SQLCODE = 0) 
		DO
			FETCH FROM ClaimsCursor INTO 
				v_SENDER_ID,v_PAYER_ID, v_isa_ID, v_gs_ID, v_st_ID, v_bpv_ID,v_subs_ID,v_pat_ID,v_clm_ID;
			VALUES (SQLCODE) INTO v_SQLCODE;
			IF (v_SQLCODE <> 0) THEN GOTO EXIT_PROC1; END IF;
			--==============================================================================
			--	Increase the No. of Processed Claims Count;
			--==============================================================================
			SET p_CLM_COUNT	= p_CLM_COUNT + 1;

		--==============================================================================
		--	Since this Record belongs to a Different SenderId or a Payer Id we need to 
		--	output the ISA GS and ST Records for this Claim
		--==============================================================================
		 
			--- Generate new Interchange, Group for every new senderID. so Check if the SenderId
			--	has changed
			IF (v_prev_SENDER_ID <> v_SENDER_ID) THEN
				SET v_cur_clm_cnt = 0;
				CALL EDIDB2A.SP_TP_GENERATE_ISA_SEGMENT(p_TP_QLFR_ID,p_TP_ID,p_ELEMENT_DLM,p_SEGMENT_DLM,p_COMPOSITE_DLM,p_IN_USAGE_CD_ISA15,v_ISA_CTRL_NO,v_isa_outBuffer,p_ERR_CODE,p_ERR_DESC);
				-- Error generating ISA so Exit Stored Proc
				IF (p_ERR_CODE <> 0) THEN	GOTO EXIT_PROC1;		END IF;
				
				--### The above stored proc should return the entire Built ISA segment. Recommended no hard coded values as in following 2 lines.			
				SET p_OUTBUFFER = p_OUTBUFFER || v_isa_outBuffer;
				SET p_OUTBUFFER = p_OUTBUFFER || chr(13) || chr(10);
				
				--### Same comments as for ISA (To discuss control number requirements)
				CALL EDIDB2A.SP_TP_GENERATE_GS_SEGMENT(p_TP_ID,p_TP_QLFR_ID,p_TRAN_NUM,p_TRAN_VER_NUM,v_DIR_IND,p_ELEMENT_DLM,v_gs_outBuffer,p_ERR_CODE,p_ERR_DESC);
				-- Error generating GS so Exit Stored Proc
				IF (p_ERR_CODE <> 0) THEN	GOTO EXIT_PROC1;		END IF;

				SET p_OUTBUFFER = p_OUTBUFFER || v_gs_outBuffer;
				SET p_OUTBUFFER = p_OUTBUFFER || p_SEGMENT_DLM || chr(13) || chr(10);
				
				--CALL EDIDB2A.SP_TP_GENERATE_ST_SEGMENT(p_TP_ID,p_TP_QLFR_ID,p_TRAN_NUM,p_TRAN_VER_NUM,p_ELEMENT_DLM,v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
				CALL EDIDB2A.SP_837_GET_EDI_ST(v_st_ID,v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
				IF (p_ERR_CODE <> 0) THEN	GOTO EXIT_PROC1;		END IF;
				
				SET p_OUTBUFFER = p_OUTBUFFER || 'ST' || p_ELEMENT_DLM || v_st_outBuffer;
				SET p_OUTBUFFER = p_OUTBUFFER || p_SEGMENT_DLM || chr(13) || chr(10);
			
			--==============================================================================
			--	Since this is a new ISA Header ensure that we also reset the PAYER_ID to 
			--	So that we also force the generation of the Claim Loops
			--==============================================================================
				SET v_prev_SENDER_ID = v_SENDER_ID;
				SET v_prev_bpv_ID = 0;
				SET v_prev_subs_ID = 0;
				SET v_prev_pat_ID = 0;
			ELSE
				SET v_cur_clm_cnt = v_cur_clm_cnt + 1;
			--	Check if we are going to exceed the Threshold for this Trading Partner
			-- SenderID is same so skip creating new ISA,GS, ST
				IF (mod(v_cur_clm_cnt,5000) = 0) THEN
					--CALL SP_TP_GENERATE_ST_SEGMENT(p_TP_ID,p_TP_QLFR_ID,p_TRAN_NUM,p_TRAN_VER_NUM,p_ELEMENT_DLM,v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
					CALL EDIDB2A.SP_837_GET_EDI_ST(v_st_ID,v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
					IF (p_ERR_CODE <> 0) THEN	GOTO EXIT_PROC1;		END IF;
					SET p_OUTBUFFER = p_OUTBUFFER || v_st_outBuffer;
					SET p_OUTBUFFER = p_OUTBUFFER || p_SEGMENT_DLM || chr(13) || chr(10);
					SET v_cur_clm_cnt = 0;
				END IF;
			END IF;
		
			--==============================================================================
			--	Retrieve the Billing Provider Loop / Subscriber Loop and the Patient Loop
			--	and send it to the Back End.
			--==============================================================================
			
			IF (v_prev_bpv_ID <> v_bpv_ID) THEN
				CALL EDIDB2A.SP_837_GET_EDI_BillingProvider(v_bpv_ID, v_bpv_outBuffer,p_ERR_CODE,p_ERR_DESC);
				IF (p_ERR_CODE <> 0) THEN	GOTO EXIT_PROC1;		END IF;
				SET p_OUTBUFFER = p_OUTBUFFER || 'PRV' || p_ELEMENT_DLM || v_bpv_outBuffer 	|| p_SEGMENT_DLM || chr(13) || chr(10);
				SET v_prev_bpv_ID = v_bpv_ID;
				SET v_prev_SUBS_ID = 0;
				SET v_prev_pat_ID = 0;
			END IF ;

			IF (v_prev_subs_ID <> v_subs_ID) THEN
				CALL EDIDB2A.SP_837_GET_EDI_Subscriber(v_subs_ID,v_subs_outBuffer,p_ERR_CODE,p_ERR_DESC);
				IF (p_ERR_CODE <> 0) THEN	GOTO EXIT_PROC1;		END IF;
				SET p_OUTBUFFER = p_OUTBUFFER || 'SBR' || p_ELEMENT_DLM || v_subs_outBuffer	|| p_SEGMENT_DLM || chr(13) || chr(10);
				SET v_prev_subs_ID = v_subs_ID;
				SET v_prev_pat_ID = 0;
			END IF ;
			
			--==============================================================================
			--	Checkf if the Claim has a Patient Loop or not and then Output that if
			--	That Loop exists
			--	The First Condition checks if the Patient Id is Null and it is null then we
			--	can ignore the generated of Patient Loop.
			--==============================================================================
			
			IF (COALESCE(v_pat_ID,-1) <> -1) THEN
				if (v_pat_ID <> 0) THEN
					IF (v_prev_pat_ID <> v_pat_ID) THEN
						CALL EDIDB2A.SP_837_GET_EDI_PATIENT(v_pat_ID,v_pat_outBuffer,p_ERR_CODE,p_ERR_DESC);
						IF (p_ERR_CODE <> 0) THEN	GOTO EXIT_PROC1;		END IF;
						SET p_OUTBUFFER = p_OUTBUFFER || 'PAT' || p_ELEMENT_DLM || v_pat_outBuffer	|| p_SEGMENT_DLM || chr(13) || chr(10);
						SET v_prev_pat_ID = v_pat_ID;
					END IF;
				END IF;
			END IF;
			
			--==============================================================================
			--	Retrieve the Claim Blob which contains the CLM Loop and Service Lines
			--	and output that to the Buffer
			--==============================================================================
			CALL EDIDB2A.SP_837_GET_EDI_Claims(v_clm_ID,v_clm_outBuffer,p_ERR_CODE,p_ERR_DESC);
			IF (p_ERR_CODE <> 0) THEN	GOTO EXIT_PROC1;		END IF;
			SET p_OUTBUFFER = p_OUTBUFFER || v_clm_outBuffer || chr(13) || chr(10); 

		END WHILE;
	ELSE
		SET p_ERR_DESC = 'BEFORE WHILE';
		WHILE (v_SQLCODE = 0)
		DO
			FETCH FROM ClaimsCursor INTO 
				v_SENDER_ID,v_PAYER_ID, v_isa_ID, v_gs_ID, v_st_ID, v_bpv_ID,v_subs_ID,v_pat_ID,v_clm_ID;
					SET p_ERR_DESC = 'AFTER FETCH';
			VALUES (SQLCODE) INTO v_SQLCODE;
			IF (v_SQLCODE <> 0) THEN GOTO EXIT_PROC1; END IF;
			--==============================================================================
			--	Increase the No. of Processed Claims Count;
			--==============================================================================
			SET p_CLM_COUNT	= p_CLM_COUNT + 1;
				
			--==============================================================================
			--	Since this Record belongs to a Different SenderId or a Payer Id we need to 
			--	output the ISA GS and ST Records for this Claim
			--==============================================================================
			 -- or (v_prev_PAYER_ID <> v_PAYER_ID )
			
			IF (v_prev_SENDER_ID <> v_SENDER_ID) THEN
					SET v_cur_clm_cnt = 0;
				--	If the Splitting needs to be done for Every Submitter at the ISA Level
				--	then Trigger the Generation of a New ISA Envelope
			
				--### Category 1
				--### This need not be checked for ever iteration because condition is 1 or 2 for a destination
					--	Generate an ISA Segment with Info Specific to the Destination TP
					--	also generate ISA Control No
					--### generate FileID for this file
					CALL EDIDB2A.SP_TP_GENERATE_ISA_SEGMENT(p_TP_QLFR_ID,p_TP_ID,p_ELEMENT_DLM,p_SEGMENT_DLM,p_COMPOSITE_DLM,p_IN_USAGE_CD_ISA15,v_ISA_CTRL_NO,v_isa_outBuffer,p_ERR_CODE,p_ERR_DESC);
					--### The above stored proc should return the entire Built ISA segment. Recommended no hard coded values as in following 2 lines.
					--### SET p_OUTBUFFER= p_OUTBUFFER|| v_isa_outBuffer;
					SET p_OUTBUFFER = p_OUTBUFFER || v_isa_outBuffer;
					SET p_OUTBUFFER = p_OUTBUFFER || chr(13) || chr(10);
					--### Same comments as for ISA (To discuss control number requirements)
					CALL EDIDB2A.SP_TP_GENERATE_GS_SEGMENT(p_TP_ID,p_TP_QLFR_ID,p_TRAN_NUM,p_TRAN_VER_NUM,v_DIR_IND,p_ELEMENT_DLM,v_gs_outBuffer,p_ERR_CODE,p_ERR_DESC);
					SET p_OUTBUFFER = p_OUTBUFFER || v_gs_outBuffer;
					SET p_OUTBUFFER = p_OUTBUFFER || p_SEGMENT_DLM || chr(13) || chr(10);
				
				---### did not understand END IF purpose and why ST generation should be after this. Looks switched
				--CALL EDIDB2A.SP_TP_GENERATE_ST_SEGMENT(p_TP_ID,p_TP_QLFR_ID,p_TRAN_NUM,p_TRAN_VER_NUM,p_ELEMENT_DLM,v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
					CALL EDIDB2A.SP_837_GET_EDI_ST(v_st_ID,v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
					SET p_OUTBUFFER = p_OUTBUFFER || 'ST' || p_ELEMENT_DLM || v_st_outBuffer;
					SET p_OUTBUFFER = p_OUTBUFFER || p_SEGMENT_DLM || chr(13) || chr(10);
				
				--==============================================================================
				--	Since this is a new ISA Header ensure that we also reset the PAYER_ID to 
				--	So that we also force the generation of the Claim Loops
				--==============================================================================
				SET v_prev_SENDER_ID 	= v_SENDER_ID;
				--SET v_prev_PAYER_ID		= v_PAYER_ID;
			ELSE
				SET v_cur_clm_cnt = v_cur_clm_cnt + 1;
				--	Check if we are going to exceed the Threshold for this Trading Partner
				IF (mod(v_cur_clm_cnt,5000) = 0) THEN
					CALL EDIDB2A.SP_837_GET_EDI_ST(v_st_ID,v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
					SET p_OUTBUFFER = p_OUTBUFFER || 'ST' || p_ELEMENT_DLM || v_st_outBuffer;
					SET p_OUTBUFFER = p_OUTBUFFER || p_SEGMENT_DLM || chr(13) || chr(10);
					SET v_cur_clm_cnt = 0;
				END IF;
			END IF;
			
			--==============================================================================
			--	Retrieve the Billing Provider Loop / Subscriber Loop and the Patient Loop
			--	and send it to the Back End.
			--==============================================================================
			CALL EDIDB2A.SP_837_GET_EDI_BillingProvider(v_bpv_ID, v_bpv_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_OUTBUFFER = p_OUTBUFFER || 'PRV' || p_ELEMENT_DLM || v_bpv_outBuffer 	|| p_SEGMENT_DLM || chr(13) || chr(10);

			CALL EDIDB2A.SP_837_GET_EDI_Subscriber(v_subs_ID,v_subs_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_OUTBUFFER = p_OUTBUFFER || 'SBR' || p_ELEMENT_DLM || v_subs_outBuffer	|| p_SEGMENT_DLM || chr(13) || chr(10);
			
			--==============================================================================
			--	Checkf if the Claim has a Patient Loop or not and then Output that if
			--	That Loop exists
			--==============================================================================
			IF (COALESCE(v_pat_ID,-1) <> -1) THEN
				if (v_pat_ID <> 0) THEN
					CALL EDIDB2A.SP_837_GET_EDI_PATIENT(v_pat_ID,v_pat_outBuffer,p_ERR_CODE,p_ERR_DESC);	
					SET p_OUTBUFFER = p_OUTBUFFER || 'PAT' || p_ELEMENT_DLM || v_pat_outBuffer	|| p_SEGMENT_DLM || chr(13) || chr(10);
				END IF;
			END IF;
			
			--==============================================================================
			--	Retrieve the Claim Blob which contains the CLM Loop and Service Lines
			--	and output that to the Buffer
			--==============================================================================
			CALL EDIDB2A.SP_837_GET_EDI_Claims(v_clm_ID,v_clm_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_OUTBUFFER = p_OUTBUFFER || v_clm_outBuffer || chr(13) || chr(10); 			
		END WHILE;
		
	END IF ;

EXIT_PROC1:
	CLOSE ClaimsCursor;

END@



/*
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE SP_837_EXTRACT_LOCAL_CLAIMS')@

CREATE PROCEDURE EDIDB2A.SP_837_EXTRACT_CLAIMS (
    IN 	p_DEST_ID		VARCHAR(30),
	IN	p_SPLIT_LEVEL	CHAR(1),
	IN	p_ST_THRESHOLD	INTEGER,
    OUT p_outBuffer		CLOB(20000000),
    OUT p_CLM_COUNT		INTEGER,
	OUT p_ERR_CODE 		BIGINT,
	OUT p_ERR_DESC 		VARCHAR(255)
	)
BEGIN
DECLARE v_bpv_ID BIGINT;
DECLARE v_subs_ID BIGINT;
DECLARE v_clm_ID BIGINT;
DECLARE c_clm_ID BIGINT;
DECLARE c_bpv_ID BIGINT;
DECLARE c_subs_ID BIGINT;
DECLARE v_count INTEGER default 0;
DECLARE v_cur_clm_cnt integer;
DECLARE v_tot_clm_cnt integer;
DECLARE v_pat_ID BIGINT ;
DECLARE c_pat_ID BIGINT ; 
DECLARE v_bpv_outBuffer VARCHAR(4000);
DECLARE v_subs_outBuffer VARCHAR(3000);
DECLARE v_pat_outBuffer VARCHAR(3000) ;
DECLARE v_clm_outBuffer CLOB(5M);
DECLARE v_isa_outBuffer VARCHAR(3000);
DECLARE v_gs_outBuffer VARCHAR(3000) ;
DECLARE v_st_outBuffer VARCHAR(3000) ;
DECLARE v_prev_SENDER_ID VARCHAR(15) ;
DECLARE v_SENDER_ID VARCHAR(15) ;
DECLARE v_prev_PAYER_ID  VARCHAR(80) ;
DECLARE v_PAYER_ID  VARCHAR(80) ;
DECLARE v_isa_ID BIGINT;
DECLARE v_gs_ID BIGINT ;
DECLARE v_st_ID BIGINT ;
--==============================================================================
--	Declare a Cursor to retrieve all the Claims for the Local Destination
--	That are ready to be Bulked and group them by the Sender_ID and Payer_ID
--==============================================================================

DECLARE ClaimsCursor CURSOR 
	FOR SELECT 	
			CLAIMS.SNDR_ID as SENDER_ID, 
			CLAIMS.PAYR_ID as PAYER_ID,
			CLAIMS.ISA_ID 	as ISA_ID,	
			CLAIMS.GS_ID 	as GS_ID, 
			CLAIMS.ST_ID 	as ST_ID,
			CLAIMS.PROV_ID 	as PROV_ID, 
			CLAIMS.SUBS_ID 	as SUBS_ID,
			CLAIMS.PAT_ID 	as PAT_ID,
			CLAIMS.CLM_ID as CLAIM_ID  
		FROM 	
			EDIDB2A.T_837_CLM_CTRL_LOG	CLAIMS 
		WHERE	
			CLAIMS.DEST_ID 		= p_DEST_ID 
			AND CLAIMS.CLM_STT_CD	= '10052'
		ORDER BY CLAIMS.SNDR_ID, CLAIMS.PAYR_ID;
			
			
	SET p_outBuffer=' ';
	SET c_bpv_ID = 0 ;
	SET c_subs_ID = 0 ;
	SET c_pat_ID = 0 ;
	SET p_clm_count =0;
	SET p_outBuffer='';
	SET v_cur_clm_cnt = 0;
	
--==============================================================================
--	Used to determine the No. of Claims to be Bundled for this Destination
--==============================================================================

	SELECT 
			COUNT(DEST_ID) INTO v_count 
	FROM 
			EDIDB2A.T_837_CLM_CTRL_LOG 
	WHERE 
			DEST_ID = p_DEST_ID 
			AND CLM_STT_CD='10052';

	SET v_tot_clm_cnt = v_count;

--==============================================================================
--  Open the ClaimsCursor and loop around all the claims in the cursor 
--	to determine when to output the ISA Header and Payer Header or not.
--==============================================================================
OPEN ClaimsCursor;

--==============================================================================
--	Now loop around the Claims Cursor until we consume all the claims found
--	At the Start of the Loop initailize the 
--		Previous SENDER ID and 
--		Previous Payer ID
--==============================================================================
Set v_prev_SENDER_ID = '';
Set v_prev_PAYER_ID = '';

-- Need to set the TP_ID for this Destination
v_TP_ID = ....
v_TP_ID_QUAL = ...

WHILE v_count <> 0
DO
	FETCH FROM ClaimsCursor INTO 
		v_SENDER_ID,v_PAYER_ID, v_isa_ID, v_gs_ID, v_st_ID, v_bpv_ID,v_subs_ID,v_pat_ID,v_clm_ID;
		
	--==============================================================================
	--	Since this Record belongs to a Different SenderId or a Payer Id we need to 
	--	output the ISA GS and ST Records for this Claim
	--==============================================================================
	 -- or (v_prev_PAYER_ID <> v_PAYER_ID )
	 
	IF (v_prev_SENDER_ID <> v_SENDER_ID) THEN
		--	If the Splitting needs to be done for Every Submitter at the ISA Level
		--	then Trigger the Generation of a New ISA Envelope
		IF (p_SPLIT_LEVEL = 'I') THEN
			--	Generate an ISA Segment with Info Specific to the Destination TP
			--	also generate ISA Control No
			CALL EDIDB2A.SP_TP_GENERATE_EDI_ISA(v_TP_ID,v_TP_ID_QUAL, v_isa_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_outBuffer = p_outBuffer || 'ISA' || '*' || v_isa_outBuffer;
			SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);

			CALL EDIDB2A.SP_TP_GENERATE_EDI_GS(v_TP_ID,v_TP_ID_QUAL,'837P', v_gs_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_outBuffer = p_outBuffer || 'GS' || '*' || v_gs_outBuffer;
			SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);
		END IF
			CALL EDIDB2A.SP_TP_GENERATE_EDI_ST(v_TP_ID,v_TP_ID_QUAL,'837P', v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_outBuffer = p_outBuffer || 'ST' || '*' || v_st_outBuffer;
			SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);
		
		--==============================================================================
		--	Since this is a new ISA Header ensure that we also reset the PAYER_ID to 
		--	So that we also force the generation of the Claim Loops
		--==============================================================================
		SET v_prev_SENDER_ID 	= v_SENDER_ID;
		--SET v_prev_PAYER_ID		= v_PAYER_ID;
	ELSE
		--	Check if we are going to exceed the Threshold for this Trading Partner
		if (v_tot_clm_cnt > 5000) and (v_cur_cnt = 5000) then
			CALL EDIDB2A.SP_TP_GENERATE_EDI_ST(v_TP_ID,v_TP_ID_QUAL,'837P', v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_outBuffer = p_outBuffer || 'ST' || '*' || v_st_outBuffer;
			SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);
			SET v_cur_clm_cnt = 0;
			SET v_tot_clm_cnt = v_tot_clm_cnt - 5000;
		end if
	END IF;
	
	--==============================================================================
	--	Retrieve the Billing Provider Loop / Subscriber Loop and the Patient Loop
	--	and send it to the Back End.
	--==============================================================================
	CALL EDIDB2A.SP_837_GET_EDI_BillingProvider(v_bpv_ID, 	v_bpv_outBuffer,p_ERR_CODE,p_ERR_DESC);
	SET p_outBuffer = p_outBuffer || 'PRV' || '*' || v_bpv_outBuffer 	|| '~' || chr(13) || chr(10);

	CALL EDIDB2A.SP_837_GET_EDI_Subscriber(v_subs_ID, 		v_subs_outBuffer,p_ERR_CODE,p_ERR_DESC);
	SET p_outBuffer = p_outBuffer || 'SBR' || '*' || v_subs_outBuffer	|| '~' || chr(13) || chr(10);
	
	--==============================================================================
	--	Checkf if the Claim has a Patient Loop or not and then Output that if
	--	That Loop exists
	--==============================================================================
	IF (COALESCE(v_pat_ID,-1) <> -1) THEN
		if (v_pat_ID <> 0) THEN
			CALL EDIDB2A.SP_837_GET_EDI_PATIENT(v_pat_ID, 			v_pat_outBuffer,p_ERR_CODE,p_ERR_DESC);	
			SET p_outBuffer = p_outBuffer || 'PAT' || '*' || v_pat_outBuffer	|| '~' || chr(13) || chr(10);
		END IF;
	END IF;
	
	--==============================================================================
	--	Retrieve the Claim Blob which contains the CLM Loop and Service Lines
	--	and output that to the Buffer
	--==============================================================================
	CALL EDIDB2A.SP_837_GET_EDI_Claims(v_clm_ID,	v_clm_outBuffer,p_ERR_CODE,p_ERR_DESC);
	SET p_outBuffer = p_outBuffer || v_clm_outBuffer || chr(13) || chr(10); 
	
	--==============================================================================
	--	Increase the No. of Processed Claims Count;
	--	Decrease the Total Claims Count which is used for the Loop Condition
	--==============================================================================
	SET p_CLM_COUNT	= p_CLM_COUNT + 1;
	SET v_cur_clm_cnt 	= v_cur_clm_cnt + 1;
	SET v_count		= v_count - 1;
END WHILE;--
CLOSE ClaimsCursor; 
END@ */
