--=============================================================================
--	Filename:	procs.sql
--	Author:		Nanaji Veturi
--	Date:		OCT/13/2010
--	Description:
--	This file contains the Procedures  for the Transaction 835
--==============================================================================


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_835_GET_URI_VERSION ')@

CREATE PROCEDURE EDIDB2A.SP_835_GET_URI_VERSION 
(IN  p_RECV_ID_NUM   VARCHAR(15),
 IN  p_flag			CHAR(1),
 OUT p_VERSION      VARCHAR(12),
 OUT p_sqlcode      INTEGER,
 OUT p_errcode		INTEGER,
 OUT p_errdesc		VARCHAR(120) )
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
    DECLARE SQLCODE	            INTEGER ;
	DECLARE v_TP_ID             VARCHAR(40);
	DECLARE v_TP_QLFR			CHAR(2) ;
	DECLARE v_TRAN_NUM			VARCHAR(3);
	DECLARE v_TRAN_VER 			VARCHAR(12);
	DECLARE v_sqlcode			INTEGER ;
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION

VALUES (SQLCODE) INTO p_sqlcode;

IF(p_flag = '0' ) THEN 
--=============================================================================
--	Retrievint the Trading Partner ID and Qualifier ID from T_TP based on Receiver ID
--=============================================================================
SELECT TP_ID,TP_QLFR_ID INTO v_TP_ID,v_TP_QLFR 
FROM EDIDB2A.T_TP
WHERE TP_ID=p_RECV_ID_NUM FETCH FIRST 1 ROWS ONLY WITH UR;

--=============================================================================
--	Place the value of SQLCODE into the variable v_sqlcode  
--=============================================================================
SET p_sqlcode = SQLCODE ;
SET p_VERSION = '' ; 
SET p_errdesc = 'Receiver ID found in TP Table';

ELSE
--=============================================================================
--	Retrievint the Trading Partner ID and Qualifier ID from T_TP based on Receiver ID
--=============================================================================
       SELECT TP_ID,TP_QLFR_ID INTO v_TP_ID,v_TP_QLFR 
       FROM EDIDB2A.T_TP
       WHERE TP_ID=p_RECV_ID_NUM FETCH FIRST 1 ROWS ONLY WITH UR;

    
        SET p_sqlcode = SQLCODE ;
	    IF (p_sqlcode = 0) THEN
--=============================================================================
--	Retrievint the TRAN_VER_NUM from T_TP_TRAN_AUTH based on TP_ID and TP_QLFR_ID 
--  and TRAN_NUM
--=============================================================================
		SELECT TRAN_VER_NUM INTO p_VERSION FROM EDIDB2A.T_TP_TRAN_AUTH
		WHERE TP_ID =v_TP_ID  AND TP_QLFR_ID =v_TP_QLFR AND TRAN_NUM ='835'  FETCH FIRST 1 ROWS ONLY WITH UR;

		SET p_sqlcode = SQLCODE ;
		IF (p_sqlcode != 0) THEN
		SET p_errcode = 36030011;
	    SET p_errdesc = 'TRANS_VERSION NOT FOUND BASED ON TP_ID ';
	    ELSE
	    SET p_errcode = 0;
	    SET p_errdesc = 'Version Found in the Database'; 
	    END IF ;
	ELSE
		SET p_errcode  = 36030010;
		SET p_errdesc = 'TP_ID NOT FOUND BASED ON RECV_ID' ;		
	END IF ;

END IF ; 
		 
END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_835_EVCHR_GET_FILEPATH')@


CREATE PROCEDURE EDIDB2A.SP_835_EVCHR_GET_FILEPATH( 
OUT p_OUT_BUFFER CLOB(10M) ) 

LANGUAGE SQL
MODIFIES SQL DATA

BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
DECLARE v_FILENAME VARCHAR(255) DEFAULT ''; 
DECLARE v_FILE_ROOT_DTRY_TXT VARCHAR(75) DEFAULT '';
DECLARE v_FILE_SUB_DTRY_TXT VARCHAR(50) DEFAULT ''; 
DECLARE v_FILE_ID BIGINT; 
DECLARE v_COUNT INT DEFAULT 0 ; 
DECLARE v_OUT_BUFFER  CLOB(10M) DEFAULT '';
--=============================================================================
--  Declare the Cursor to get the values of file directory and file name based 
--  on the File status code from the Table Variables in the procedure
--=============================================================================
DECLARE c_FILENAME CURSOR FOR SELECT FILE_ID,FILE_ROOT_DTRY_TXT ,FILE_SUB_DTRY_TXT,FILE_NME FROM EDIDB2A.T_835_FILE_PCES_LOG WHERE FILE_STT_CD='07'; 
   
OPEN c_FILENAME; 
--=============================================================================
--  Find the number of rows retrieved from the cursor to loop the counter
--=============================================================================
SELECT COUNT(*) INTO v_COUNT FROM EDIDB2A.T_835_FILE_PCES_LOG WHERE FILE_STT_CD='07';
--FETCH FROM c_FILENAME INTO v_FILE_ID,v_FILEPATH,v_FILENAME;
WHILE ( v_COUNT <> 0 ) 
DO 
--=============================================================================
--  Fetch from the cursor into the variable declared --=============================================================================
FETCH FROM c_FILENAME INTO v_FILE_ID,v_FILE_ROOT_DTRY_TXT,v_FILE_SUB_DTRY_TXT,v_FILENAME; 

SET v_OUT_BUFFER = v_OUT_BUFFER ||  v_FILENAME ||  '*' || v_FILE_ROOT_DTRY_TXT  || v_FILE_SUB_DTRY_TXT|| '~'  ;

--=============================================================================
--  Update the Table with File status code 09 based on File Id
--=============================================================================

UPDATE EDIDB2A.T_835_FILE_PCES_LOG SET FILE_STT_CD='09' WHERE FILE_ID=v_FILE_ID;
SET v_COUNT = v_COUNT - 1 ; 

END WHILE; 

CLOSE c_FILENAME; 
--=============================================================================
--  Set the Output buffer to out put variable 
--=============================================================================
SET p_OUT_BUFFER = v_OUT_BUFFER;

END@


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_835_GET_EDI_ST')@


CREATE PROCEDURE EDIDB2A.SP_835_GET_EDI_ST (
    IN P_ST_ID						BIGINT,
    OUT P_OUTBUFFER					CLOB(20000000),
    OUT P_ERR_CODE					BIGINT,
    OUT P_ERR_DESC					VARCHAR(255) )
	
	LANGUAGE SQL
    MODIFIES SQL DATA
	
BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE SQLCODE INTEGER;
	DECLARE v_sqlcode INTEGER ;
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_sqlcode;
--=============================================================================
--  Retrieve The Clob data from the database based on the file Id 
--  and update indicator and assign out put variable 
--=============================================================================
	SELECT MSG_OBJ INTO P_OUTBUFFER FROM EDIDB2A.T_835_CHK_MSG WHERE ST_ID = P_ST_ID AND UPDT_IND = '2' ;
--=============================================================================
--	Place the value of SQLCODE into the variable v_sqlcode  
--=============================================================================
    VALUES (SQLCODE) INTO v_sqlcode;
    IF(v_sqlcode <>0) THEN
 	SET P_ERR_CODE = v_sqlcode ;
    SET P_ERR_DESC = 'THERE IS NO ST_ID FOUND IN THE DATABASE' ; 
    ELSE
    SET P_ERR_CODE = v_sqlcode ;
    SET P_ERR_DESC = 'SUCCESS' ;
    END IF ;
    
 END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_835_EXTRACT_ST_MSG')@ 
 
 CREATE PROCEDURE EDIDB2A.SP_835_EXTRACT_ST_MSG (
    IN P_URI				VARCHAR(12),
    IN P_GS02				VARCHAR(15),
    IN P_OTHER_PAYER_FLAG	VARCHAR(1),
	IN p_TEST_CD            CHAR(1) ,
    OUT P_OUT_BUFFER		CLOB(20000000),
    OUT P_ERR_CODE			INTEGER,
    OUT P_ERR_DESC			VARCHAR(255) )
  
  LANGUAGE SQL
  MODIFIES SQL DATA
  
BEGIN 
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_prev_GS02 VARCHAR(15);
	DECLARE v_GS02 VARCHAR(15);
	DECLARE v_ST_ID BIGINT; 
	DECLARE v_ST_outBuffer CLOB(5M); 
	DECLARE v_ISA16_CMPNT_ELE_SEPRT_IND CHAR(1);
    DECLARE v_ELE_DLM CHAR(1);
    DECLARE v_SEG_DLM VARCHAR(3);
	DECLARE v_count INTEGER;--
	DECLARE SQLCODE INTEGER;
	DECLARE v_sqlcode INTEGER ;
--=============================================================================
--Declare the cursor to retrieve the rows based on URI and check stt code=10053 
--=============================================================================	
	DECLARE GS_STCursor CURSOR FOR SELECT ST_ID,GS02_SNDR_CD FROM EDIDB2A.T_835_CHK_PCES_LOG WHERE UNQ_RECV_ID = P_URI AND    CHK_STT_CD = 10553 AND TEST_CD= p_TEST_CD GROUP BY GS02_SNDR_CD,ST_ID WITH UR ; 
--=============================================================================
--Declare the cursor to retrieve the rows based on URI GS02_SNDR_CD and 
-- check stt code=10053 from the table T_835_CHK_PCES_LOG
--=============================================================================	
	DECLARE STCursor CURSOR FOR SELECT ST_ID FROM EDIDB2A.T_835_CHK_PCES_LOG WHERE UNQ_RECV_ID = P_URI AND GS02_SNDR_CD =    P_GS02 AND CHK_STT_CD = 10552 AND TEST_CD= p_TEST_CD  WITH UR ;
--=============================================================================
--	Setup the EXIT HANDLER for all SQL Exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_sqlcode;
	
	SET P_OUT_BUFFER = P_URI||'|'; 
	SET P_ERR_CODE   = v_sqlcode ;
	SET v_prev_GS02  = ''; 
	SET v_GS02       = ''; 
	
	IF (P_OTHER_PAYER_FLAG = 'N') THEN 
--=============================================================================
--	Find the Number of ROWS from the T_835_CHK_PCES_LOG based on UNQ_RECV_ID 
--  and CHK_STT_CD
--=============================================================================
		SELECT COUNT(ST_ID) INTO v_count FROM EDIDB2A.T_835_CHK_PCES_LOG WHERE UNQ_RECV_ID = P_URI AND CHK_STT_CD=10553 AND TEST_CD= p_TEST_CD  WITH UR  ; 
		IF( v_count <> 0) THEN
				OPEN GS_STCursor;
					WHILE v_count <> 0 DO 
--=============================================================================
--  Fetch from the cursor into the variable declared
 --=============================================================================
						FETCH FROM GS_STCursor INTO v_ST_ID,v_GS02; 
						IF v_prev_GS02 <> v_GS02 THEN 
							SET P_OUT_BUFFER = P_OUT_BUFFER||v_GS02||'||'; 
							SET v_prev_GS02 = v_GS02; 
						END IF; 
						CALL EDIDB2A.SP_835_GET_EDI_ST(v_ST_ID,v_ST_outBuffer,P_ERR_CODE,P_ERR_DESC);
--=============================================================================
--	Retreiving the ISA16_CMPNT_ELE_SEPRT_IND,ELE_DLM and SEG_DLM from the Table
-- T_835_CHK_MSG based on ST_ID
--=============================================================================
						SELECT  ISA16_CMPNT_ELE_SEPRT_IND,ELE_DLM,SEG_DLM INTO v_ISA16_CMPNT_ELE_SEPRT_IND,v_ELE_DLM,v_SEG_DLM	FROM  EDIDB2A.T_835_CHK_MSG WHERE ST_ID= v_ST_ID   fetch first row only  ;
						
						IF v_count = 1 THEN
						
							SET P_OUT_BUFFER = P_OUT_BUFFER || v_ELE_DLM  || '|||' ||v_SEG_DLM || '|||' || v_ISA16_CMPNT_ELE_SEPRT_IND || '|||' || v_ST_outBuffer;
						ELSE 
							SET P_OUT_BUFFER = P_OUT_BUFFER || v_ELE_DLM  || '|||' ||v_SEG_DLM || '|||' || v_ISA16_CMPNT_ELE_SEPRT_IND || '|||' || v_ST_outBuffer ||'||'; 
						END IF;
--=============================================================================
--  Update the Table with Check status code 10059 based on ST_ID --=============================================================================
						UPDATE EDIDB2A.T_835_CHK_PCES_LOG SET CHK_STT_CD=10059 where ST_ID = v_ST_ID ;
						SET v_count	=	v_count - 1; 
					END WHILE;--
				CLOSE GS_STCursor; 
		 ELSE
		 SET P_ERR_CODE   = 100 ;
		 SET P_ERR_DESC  = 'ST ID  IS NOT AVAILBLE IN TABLE - EDIDB2A.T_835_CHK_PCES_LOG' ; 
		 END IF ; 
	ELSEIF P_OTHER_PAYER_FLAG = 'Y' THEN 
--=============================================================================
--	Find the Number of rows from the Table T_835_CHK_PCES_LOG based on UNQ_RECV_ID
-- and CHK_STT_CD
--=============================================================================
				SELECT COUNT(ST_ID) INTO v_count FROM EDIDB2A.T_835_CHK_PCES_LOG WHERE UNQ_RECV_ID = P_URI AND CHK_STT_CD=10552; 
				IF (v_count <> 0) THEN 
				OPEN STCursor;
					SET P_OUT_BUFFER = P_OUT_BUFFER||P_GS02||'||'; 
					
					WHILE v_count <> 0 DO 
--=============================================================================
--  Fetch from the cursor into the variable declared 
--=============================================================================
						FETCH FROM STCursor INTO v_ST_ID;
						CALL EDIDB2A.SP_835_GET_EDI_ST(v_ST_ID,v_ST_outBuffer,P_ERR_CODE,P_ERR_DESC);
--=============================================================================
--	Retreiving the ISA16_CMPNT_ELE_SEPRT_IND,ELE_DLM and SEG_DLM from the Table
-- T_835_CHK_MSG based on ST_ID
--=============================================================================
						SELECT  ISA16_CMPNT_ELE_SEPRT_IND,ELE_DLM,SEG_DLM INTO v_ISA16_CMPNT_ELE_SEPRT_IND,v_ELE_DLM,v_SEG_DLM	FROM  EDIDB2A.T_835_CHK_MSG WHERE ST_ID= v_ST_ID   fetch first row only ;
						
						IF v_count = 1 THEN
						
							SET P_OUT_BUFFER = P_OUT_BUFFER || v_ELE_DLM  || '|||' ||v_SEG_DLM || '|||' || v_ISA16_CMPNT_ELE_SEPRT_IND || '|||' || v_ST_outBuffer;
						ELSE 
							SET P_OUT_BUFFER = P_OUT_BUFFER || v_ELE_DLM  || '|||' ||v_SEG_DLM || '|||' || v_ISA16_CMPNT_ELE_SEPRT_IND || '|||' || v_ST_outBuffer ||'||'; 
						END IF;
						
						
--=============================================================================
--  Update the Table with Check status code 10059 based on ST_ID --=============================================================================
						UPDATE EDIDB2A.T_835_CHK_PCES_LOG SET CHK_STT_CD=10059 where ST_ID = v_ST_ID ;
						SET v_count	=	v_count - 1; 
					END WHILE;--
				CLOSE GS_STCursor; 
		         ELSE
		         SET P_ERR_CODE   = 100 ;
		         SET P_ERR_DESC  = 'ST ID  IS NOT AVAILBLE IN TABLE - EDIDB2A.T_835_CHK_PCES_LOG' ; 
		         END IF ; 
			ELSE 
				SET P_ERR_CODE = 100;
				SET P_ERR_DESC = 'Invalid Other Payer Flag';
			END IF; 	
 END@
 
 
 
 
 CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_835_EXTRACT_URI')@ 
 
 
 CREATE PROCEDURE EDIDB2A.SP_835_EXTRACT_URI (
    IN P_OTHER_PAYER_FLAG	CHARACTER(1),
	IN p_TEST_CD  CHAR(1),
    OUT P_URI_LIST	VARCHAR(1000),
    OUT P_URI_COUNT	INTEGER,
    OUT P_ERR_CODE	BIGINT,
    OUT P_ERR_DESC	VARCHAR(255) )
 
  LANGUAGE SQL
  MODIFIES SQL DATA
  
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
	DECLARE v_uri_list VARCHAR(1000); --
	DECLARE v_uri VARCHAR(20);--
	DECLARE v_count INTEGER;--
	DECLARE v_gs02_sndr_cd VARCHAR(15);--
	DECLARE SQLCODE INTEGER DEFAULT 0;--
	
	DECLARE URI_CURSR  CURSOR FOR SELECT DISTINCT(UNQ_RECV_ID) FROM EDIDB2A.T_835_CHK_PCES_LOG WHERE CHK_STT_CD=10553 AND UNQ_RECV_ID <> ''  AND TEST_CD = p_TEST_CD WITH UR;--
	DECLARE URI_GS_CURSR CURSOR FOR SELECT DISTINCT UNQ_RECV_ID,GS02_SNDR_CD FROM EDIDB2A.T_835_CHK_PCES_LOG WHERE CHK_STT_CD=10552 AND UNQ_RECV_ID <> ''  AND TEST_CD = p_TEST_CD WITH UR;--
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES(SQLCODE) INTO P_ERR_CODE;--
	
	SET v_uri_list= '';--
	IF P_OTHER_PAYER_FLAG = 'N' THEN
--=============================================================================
--	Retreiving the UNQ_RECV_ID from the Table T_835_CHK_PCES_LOG based on UNQ_RECV_ID
-- and CHK_STT_CD
--=============================================================================
		SELECT COUNT(DISTINCT(UNQ_RECV_ID)) INTO v_count FROM EDIDB2A.T_835_CHK_PCES_LOG WHERE CHK_STT_CD=10553 AND UNQ_RECV_ID <> ''  AND TEST_CD = p_TEST_CD WITH UR;--
		SET P_ERR_CODE = SQLCODE ;
		SET P_URI_COUNT = v_count;--
		OPEN URI_CURSR;--
			WHILE (v_count <> 0) DO 
--=============================================================================
--  Fetch from the cursor into the variable declared 
--=============================================================================
			    	FETCH FROM URI_CURSR INTO v_uri;--
					SET P_ERR_CODE = SQLCODE ;
					SET v_uri_list = v_uri_list ||'^'|| v_uri;--
					SET v_count = v_count-1;--
			END WHILE;--
		CLOSE URI_CURSR;--
		SET v_uri_list = v_uri_list || '^';--
	ELSEIF P_OTHER_PAYER_FLAG = 'Y' THEN
		SELECT COUNT(DISTINCT UNQ_RECV_ID) INTO v_count FROM EDIDB2A.T_835_CHK_PCES_LOG WHERE CHK_STT_CD=10552 AND UNQ_RECV_ID <> ''      AND TEST_CD = p_TEST_CD    WITH UR;--
		SET P_ERR_CODE = SQLCODE ;
		SET P_URI_COUNT = v_count;--
		OPEN URI_GS_CURSR;--
			WHILE (v_count <> 0) DO 
-- =============================================================================
--  Fetch from the cursor into the variable declared 
-- =============================================================================
					FETCH FROM URI_GS_CURSR INTO v_uri,v_gs02_sndr_cd;--
					SET P_ERR_CODE = SQLCODE ;
					SET v_uri_list = v_uri_list ||'^'|| v_uri ||'*'||v_gs02_sndr_cd;--
					SET v_count = v_count-1;--
			END WHILE;--
		CLOSE URI_GS_CURSR;--
		SET v_uri_list = v_uri_list || '^';--
	ELSE
		SET P_ERR_CODE = 100 ;
		SET P_ERR_DESC = 'Input for Other payer is invalid';
	END IF;
	SET P_URI_LIST = v_uri_list;
END@
 
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_835_EXTRACT_ISAGS')@ 


CREATE PROCEDURE EDIDB2A.SP_835_EXTRACT_ISAGS 
(IN p_RECV_ID_NUM   VARCHAR(15),
 IN p_flag         CHAR(1) ,
 OUT p_QLFR        CHAR(2),
 OUT p_VERSION      VARCHAR(12),
 OUT p_EDDI_ID      VARCHAR(9) ,
 OUT P_TP_AUTH          XML, 
 OUT P_TP_PROF          XML,
 OUT p_sqlcode      INTEGER,
 OUT p_errcode		INTEGER,
 OUT p_errdesc		VARCHAR(120) )
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  Declare the Local Variables in the procedure
--=============================================================================
    DECLARE SQLCODE	            INTEGER ;
	DECLARE v_TP_ID             VARCHAR(40);
	DECLARE v_ALIAS_TP_ID       VARCHAR(40);
	DECLARE v_TP_QLFR			CHAR(2) ;
	DECLARE v_TRAN_NUM			VARCHAR(3);
	DECLARE v_TRAN_VER 			VARCHAR(12);
	DECLARE v_sqlcode			INTEGER ;
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================


DECLARE EXIT HANDLER FOR SQLEXCEPTION

VALUES (SQLCODE) INTO p_sqlcode;
--=============================================================================
--	Retreive the Trading Partner ID, Trading Partner Qualifier,EDDI_ID
--  From the Table TP_ID based on Receiver ID
--=============================================================================
SELECT TP_ID,TP_QLFR_ID,EDDI_ID INTO v_TP_ID,v_TP_QLFR ,p_EDDI_ID
FROM EDIDB2A.T_TP
WHERE TP_ID=p_RECV_ID_NUM FETCH FIRST 1 ROWS ONLY WITH UR;
SET p_QLFR = v_TP_QLFR;

--=============================================================================
--	Place the value of SQLCODE into the variable v_sqlcode  
--===========================================================================-=

SET p_sqlcode = SQLCODE ;
	
	IF (p_sqlcode = 0) THEN
		
--=============================================================================
--	Retreiving the TRAN_VER_NUM from the Table T_TP_TRAN_AUTH based on TP_ID
-- and TP_QLFR_ID and TRAN_NUM
--=============================================================================

		SELECT TRAN_VER_NUM INTO p_VERSION FROM EDIDB2A.T_TP_TRAN_AUTH
		WHERE TP_ID =v_TP_ID  AND TP_QLFR_ID =v_TP_QLFR AND TRAN_NUM ='835'  FETCH FIRST 1 ROWS ONLY WITH UR;
		
		SET p_sqlcode = SQLCODE ;
		IF (p_sqlcode != 0) THEN
		SET p_errcode = 36030011;
	    SET p_errdesc = 'TRANS_VERSION NOT FOUND BASED ON TP_ID '; 
	    END IF ;
	ELSE
		SET p_errcode  = 36030010;
		SET p_errdesc = 'TP_ID NOT FOUND BASED ON RECV_ID' ;		
	END IF ;
  
  IF (p_flag <>'V' )THEN 
--=============================================================================
--	Retreiving the XML Data By calling the Procedure  SP_TP_LOOKUP
--=============================================================================
  CALL EDIDB2A.SP_TP_LOOKUP(v_TP_QLFR,v_TP_ID,'835',p_VERSION,'C',P_TP_AUTH,P_TP_PROF,p_errcode,p_errdesc) ;
  
  
  END IF ;
  
END@
 
 
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_835_SAVE_FILE')@ 
 
 
CREATE PROCEDURE EDIDB2A.SP_835_SAVE_FILE (
IN p_ISA_CTRL_NUM 			INTEGER, 
IN	p_PRNT_FILE_ID 			BIGINT, 
IN	p_MAS_FILE_ID 			BIGINT, 
IN	p_FILE_NME 				VARCHAR(255), 
IN  p_SUBM_ID               VARCHAR(15), 
IN	p_FILE_STT_CD			VARCHAR(2), 
IN	p_FILE_CMT_TXT			VARCHAR(255), 
IN	p_FILE_FMT_CD			CHAR(1), 
IN	p_DIR_CD				CHAR(1), 
IN  p_FILE_ROOT_DTRY_TXT	VARCHAR(75), 
IN  p_FILE_SUB_DTRY_TXT	    VARCHAR(50), 
IN	p_FILE_VER_ID 			VARCHAR(12), 
IN  p_FILE_TYPE_CD			CHAR(1), 
IN  p_TEST_IND              CHAR(1), 
IN  p_RECR_ID               VARCHAR(18), 
IN	p_RECR_QLFR             CHAR(2), 
OUT	p_ERR_CD				INTEGER, 
OUT p_ERR_DSC				VARCHAR(255) ) 
LANGUAGE SQL 
MODIFIES SQL DATA 
BEGIN 
DECLARE SQLCODE  INTEGER DEFAULT 000;
DECLARE p_sqlcode INTEGER; 
DECLARE p_FILE_ID BIGINT; 
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
VALUES (SQLCODE) INTO p_ERR_CD; 
IF ((p_FILE_NME IS NOT NULL) and (p_FILE_NME <> '') )THEN 
CALL EDIDB2A.get_file_seq_num(p_FILE_ID); 
INSERT INTO EDIDB2A.T_835_FILE_PCES_LOG( FILE_ID,PRNT_FILE_ID,MAS_FILE_ID,FILE_NME,RECV_TS,PCES_TS,FILE_STT_CD,CMT_TXT, FILE_FMT_CD,FILE_DIR_IND,FILE_ROOT_DTRY_TXT ,FILE_SUB_DTRY_TXT, TRAN_VER_NUM,FILE_TYPE_CD,SUBM_ID,TEST_CD,RECR_ID,RECR_QLFR,ISA_CTRL_NUM) VALUES ( p_FILE_ID,p_PRNT_FILE_ID,p_MAS_FILE_ID,p_FILE_NME, current timestamp , current timestamp ,p_FILE_STT_CD,p_FILE_CMT_TXT, p_FILE_FMT_CD,p_DIR_CD,p_FILE_ROOT_DTRY_TXT ,p_FILE_SUB_DTRY_TXT,p_FILE_VER_ID,P_FILE_TYPE_CD,p_SUBM_ID,p_TEST_IND,p_RECR_ID,p_RECR_QLFR,p_ISA_CTRL_NUM); 
VALUES (SQLCODE) INTO p_sqlcode; 
SET p_ERR_CD = p_sqlcode; 
IF (p_ERR_CD <> 0) THEN 
SET p_ERR_DSC = 'SP_835_SAVE_FILE::Failed Inserting Data into the Table'; 
ELSE 
SET p_ERR_DSC = 'SP_835_SAVE_FILE::Successfully inserted records into the Table T_835_FILE_PCES_LOG';
 END IF; 
 ELSE
 SET p_ERR_CD = 9001248; 
 SET p_ERR_DSC = 'SP_835_SAVE_FILE::Could not Insert File into DB as File name is NULL';
 END IF ; 
 END@



CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_835_SAVE_COMP_FILES')@ 

CREATE PROCEDURE EDIDB2A.SP_835_SAVE_COMP_FILES ( 
IN	p_PRNT_FILE_ID 			BIGINT, 
IN	p_MAS_FILE_ID 			BIGINT, 
IN 	p_TA1_FILE_NME 			VARCHAR(255), 
IN	p_999_FILE_NME 			VARCHAR(255), 
IN	p_COMP_REP_FILE_NME		VARCHAR(255), 
IN  p_997_FILE_NME			VARCHAR(255), 
IN	p_SUBDIR_TA1 			VARCHAR(50), 
IN	p_SUBDIR_999 			VARCHAR(50), 
IN	p_SUBDIR_997			VARCHAR(50), 
IN	p_SUBDIR_COMP 			VARCHAR(50), 
IN  p_FILE_ROOT_DTRY_TXT	VARCHAR(75), 
IN	p_EDI_VER				VARCHAR(8), 
IN	p_FILE_STT_ID			VARCHAR(6), 
IN	p_DIR_ID				CHAR(1), 
IN  p_SUBM_ID               VARCHAR(15), 
IN  p_TEST_IND              CHAR(1), 
IN  p_RECR_ID               VARCHAR(18), 
IN	p_RECR_QLFR             CHAR(2),
IN p_ISA_CTRL_NUM 			INTEGER, 
OUT	p_ERR_CD			INTEGER, 
OUT	p_ERR_DSC			VARCHAR(255) ) 
LANGUAGE SQL 
MODIFIES SQL DATA 
BEGIN 
DECLARE v_FILE_TYP_ID CHAR(1); 
DECLARE v_FILE_FMT_ID CHAR(1); 
DECLARE v_FILE_ID BIGINT; 
DECLARE SQLCODE  INTEGER DEFAULT 000; 
DECLARE p_sqlcode INTEGER; 
DECLARE EXIT HANDLER FOR SQLEXCEPTION	
VALUES (SQLCODE) INTO p_sqlcode; 
IF ((p_TA1_FILE_NME IS NOT NULL) and (p_TA1_FILE_NME != ''))  THEN 
SET v_FILE_TYP_ID = 'T'; 
SET v_FILE_FMT_ID = 'A'; 
CALL EDIDB2A.SP_835_SAVE_FILE(p_ISA_CTRL_NUM,p_PRNT_FILE_ID,p_mas_file_id,p_TA1_FILE_NME, p_SUBM_ID, p_FILE_STT_ID, 
'TA1(ISAAcknowledgement)',v_FILE_FMT_ID,p_DIR_ID,p_FILE_ROOT_DTRY_TXT,p_SUBDIR_TA1,p_EDI_VER,v_FILE_TYP_ID,p_TEST_IND,p_RECR_ID,p_RECR_QLFR,p_ERR_CD,p_ERR_DSC); 
END IF ; 
IF ((p_997_FILE_NME IS NOT NULL) and (p_997_FILE_NME != ''))  THEN 
SET v_FILE_TYP_ID = 'U'; 
SET v_FILE_FMT_ID = 'A'; 
CALL EDIDB2A.SP_835_SAVE_FILE(p_ISA_CTRL_NUM,p_PRNT_FILE_ID,p_mas_file_id,p_TA1_FILE_NME,p_SUBM_ID, p_FILE_STT_ID, 'Funtional Group Acknowledgement', v_FILE_FMT_ID,p_DIR_ID,p_FILE_ROOT_DTRY_TXT,p_SUBDIR_997,p_EDI_VER,v_FILE_TYP_ID,			 p_TEST_IND,p_RECR_ID,p_RECR_QLFR,p_ERR_CD,p_ERR_DSC); END IF ; IF ((p_999_FILE_NME IS NOT NULL) and (p_999_FILE_NME <> '') )THEN SET v_FILE_TYP_ID = 'S'; SET v_FILE_FMT_ID = 'A'; 
CALL EDIDB2A.SP_835_SAVE_FILE(p_ISA_CTRL_NUM,p_PRNT_FILE_ID,p_mas_file_id,p_999_FILE_NME,p_SUBM_ID, p_FILE_STT_ID, 'Funtional Group Acknowledgement', v_FILE_FMT_ID,p_DIR_ID,p_FILE_ROOT_DTRY_TXT,p_SUBDIR_999,p_EDI_VER,v_FILE_TYP_ID,				 p_TEST_IND,p_RECR_ID,p_RECR_QLFR,p_ERR_CD,p_ERR_DSC); 
END IF ; 
IF ((p_COMP_REP_FILE_NME IS NOT NULL) and (p_COMP_REP_FILE_NME <> '')) THEN 
SET v_FILE_TYP_ID = 'C'; 
SET v_FILE_FMT_ID = 'H'; 
CALL EDIDB2A.SP_835_SAVE_FILE(p_ISA_CTRL_NUM,p_PRNT_FILE_ID,p_mas_file_id,p_COMP_REP_FILE_NME,p_SUBM_ID, p_FILE_STT_ID, 'Compliance Report ', v_FILE_FMT_ID,p_DIR_ID,p_FILE_ROOT_DTRY_TXT,p_SUBDIR_COMP,p_EDI_VER,v_FILE_TYP_ID,                p_TEST_IND,p_RECR_ID,p_RECR_QLFR,p_ERR_CD,p_ERR_DSC); 
END IF ; 
VALUES (SQLCODE) INTO p_ERR_CD; 
SET p_ERR_DSC = 'Done'; 
END@ 
 
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_835_GET_SEQUENCE_NOS')@
 
 CREATE PROCEDURE EDIDB2A.SP_835_GET_SEQUENCE_NOS (
       
       IN p_CNT	INTEGER,
      OUT P_SEQNOS	VARCHAR(12) )
         
          LANGUAGE SQL 
          NOT DETERMINISTIC EXTERNAL ACTION
          MODIFIES SQL DATA CALLED ON NULL 
          INPUT INHERIT SPECIAL REGISTERS 
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
          DECLARE EXIT HANDLER FOR SQLEXCEPTION 
          VALUES (SQLCODE) INTO v_sqlcode;
          SET p_seqnos = '';
          SET v_cnt = p_CNT ;
          SET v_cur_no = NEXT VALUE FOR  EDIDB2A.SEQ_835_CLAIM;
          SET p_seqnos = trim(cast(v_cur_no as char(12))); 
          WHILE (v_cnt > 0)
          DO 
          SET v_cur_no = NEXT VALUE FOR  EDIDB2A.SEQ_835_CLAIM,v_cnt = v_cnt  -1;
          END WHILE;
 END@