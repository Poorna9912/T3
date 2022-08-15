--=============================================================================
--	Filename:	tp_procs.sql
--	Author:		Nanaji Veturi
--	Date:		May/28/2010
--=============================================================================

--=============================================================================
--	Procedure:	EDIDB2A.SP_TP_EXIST()
--
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_EXIST')@

CREATE PROCEDURE  EDIDB2A.SP_TP_EXIST
	(
	IN	p_TP_ID 		VARCHAR(40),
	IN	p_TP_ID_QUAL	CHAR(2),
	OUT	p_FLAG 			INTEGER
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE v_TP_ID VARCHAR(40);
	DECLARE SQLCODE INTEGER DEFAULT 0;
	DECLARE v_SQLCODE INTEGER;

--=============================================================================
-- Setup the EXIT handler for all SQL exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION	
	VALUES (SQLCODE) INTO v_SQLCODE;

--=============================================================================
-- Retrieve the record corresponding to the TP Id
--=============================================================================
	SELECT TP_ID INTO v_TP_ID 
	FROM EDIDB2A.T_TP 
	WHERE TP_ID = p_TP_ID AND TP_QLFR_ID = p_TP_ID_QUAL;

--=============================================================================
-- Place the value of SQLCODE into the variable v_sqlcode
--=============================================================================
	VALUES (SQLCODE) INTO v_SQLCODE;

--=============================================================================
-- Place the value of p_flag value based on the v_sqlcode
--=============================================================================
	IF (v_SQLCODE = 0) THEN
		-- If the record exist for this Sender ID then set p_flag is 1
		SET p_FLAG = 1;
	ELSEIF (v_SQLCODE = 100) THEN
		-- If the record does not exist for this Sender Id then set p_flag is 0
		SET p_FLAG = 0;
	ELSE
		-- For any sqlexceptions set p_flag is sqlcode
	SET p_FLAG = v_SQLCODE;
	END IF;

END@


--=============================================================================
-- Procedure Name: EDIDB2A.SP_GET_ISA_SEQ_NUM()
--
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_GET_ISA_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.SP_GET_ISA_SEQ_NUM
	(
	IN	p_TP_ID		VARCHAR(40),
	IN	p_TP_QLFR	CHAR(2), 
	OUT	p_SEQ_NUM	VARCHAR(9), 
	OUT	p_SQLCODE	INTEGER
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE SQLCODE	INTEGER DEFAULT 0 ;
	DECLARE v_SEQ_NUM VARCHAR(9) ;
	DECLARE v_SEQ_NUM1 INTEGER ;

--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO p_SQLCODE;

	SELECT CHAR(ISA_CTRL_NUM) INTO v_SEQ_NUM
	FROM EDIDB2A.T_TP_ISA_CTRL_NUM
	WHERE TP_ID = p_TP_ID;

--=============================================================================
--	Place the value of SQLCODE into the variable p_sqlcode  
--=============================================================================
	SET p_SQLCODE = SQLCODE ;
	
	IF (p_SQLCODE = 0) THEN
		--	Increment the Last Sequence Number
		SET v_SEQ_NUM = CHAR(INT(v_SEQ_NUM) + 1) ;
		SELECT SUBSTR(CHAR(INT(v_SEQ_NUM) + 1000000000),2,9) INTO  p_SEQ_NUM FROM sysibm.sysdummy1 ;
		
		--	Update the Last Used Sequence Number into the Database Record
		UPDATE 	EDIDB2A.T_TP_ISA_CTRL_NUM
		SET 	ISA_CTRL_NUM = INT(p_SEQ_NUM)
		WHERE 	TP_ID = p_TP_ID;
		
		SET p_SQLCODE = SQLCODE ;
	ELSE
		INSERT INTO EDIDB2A.T_TP_ISA_CTRL_NUM
					(TP_ID,TP_QLFR_ID,ISA_CTRL_NUM)
			VALUES	(p_TP_ID,p_TP_QLFR,000000001);
		SET p_SEQ_NUM = '000000001';
		SET p_SQLCODE = SQLCODE ;
	END IF ; 
END@


--=============================================================================
--	Procedure Name:	EDIDB2A.SP_TP_DUP_CHECK()
--
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_DUP_CHECK')@

CREATE PROCEDURE  EDIDB2A.SP_TP_DUP_CHECK(
	IN	p_TP_ID			VARCHAR(40), 
	IN	p_TP_QLFR_ID	CHAR(2), 
	IN	p_CRC_CODE		VARCHAR(15), 
	OUT	p_ERR_CODE		BIGINT, 
	OUT	p_ERR_DESC		VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN 
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE SQLCODE INTEGER DEFAULT 0;
	DECLARE v_SQLCODE INTEGER DEFAULT 0;
	DECLARE v_COUNT INTEGER;
	DECLARE v_LOOP INTEGER DEFAULT 1;
	DECLARE v_CRC_CODES VARCHAR(3750);
	DECLARE v_CUR_INDEX_NUM INTEGER DEFAULT 1;
	DECLARE v_POS INTEGER;

--=============================================================================
-- SET UP EXIT HANDLER FOR ALL SQL QUERIES	
--=============================================================================	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION     
	SET p_ERR_DESC = 'EXECUTED SUCCESSFULLY';
	SET p_ERR_CODE = 0;
	
--=============================================================================
-- Pad the Incoming p_crc_code with Zeros to ensure 15 Digits
-- exist IN the CRC Code
--=============================================================================
	SET p_CRC_CODE = CONCAT(SUBSTR('000000000000000',1,(15 - LENGTH(p_CRC_CODE))),p_CRC_CODE);
	
--=============================================================================
-- Retrieve the DUP_CHECK Record corresponding to this Sender Id
--=============================================================================
	SELECT	CURR_INDX_NUM, CRC_CD 
	INTO 	v_CUR_INDEX_NUM, v_CRC_CODES
	FROM 	EDIDB2A.T_TP_TRAN_DUP_CHK
	WHERE	TP_ID = p_TP_ID AND	TP_QLFR_ID = p_TP_QLFR_ID;
		
	VALUES (SQLCODE) INTO v_SQLCODE;

--=============================================================================
-- If the Record does NOT exist for this Sender ID then CREATE One record
-- AND	INSERT it to the Database Table.
-- Each CRC Code IS assumed to be of 15 Digits paded with Zeros.
--=============================================================================
	
	IF (v_SQLCODE = 100) THEN
	
		SET v_CUR_INDEX_NUM = 1;
		SET v_CRC_CODES = p_CRC_CODE;
		SET v_LOOP = 1;
		
		WHILE (v_LOOP <= 249) DO
			SET v_CRC_CODES = CONCAT(v_CRC_CODES,'000000000000000');
			SET v_LOOP = v_LOOP + 1;
		END WHILE;
		
		INSERT INTO EDIDB2A.T_TP_TRAN_DUP_CHK
		VALUES(p_TP_ID,p_TP_QLFR_ID,v_CRC_CODES,v_CUR_INDEX_NUM);
		
		VALUES (SQLCODE) into v_SQLCODE;
		
		IF (v_SQLCODE = 0) THEN
			SET p_ERR_CODE = 0;
			SET P_ERR_DESC = 'SP_TP_DUP_CHECK::Successfully Inserted into T_TP_TRAN_DUP_CHK';
		ELSE
			SET p_ERR_CODE = 39912345;
			SET P_ERR_DESC = 'SP_TP_DUP_CHECK::Failed to Insert into T_TP_TRAN_DUP_CHK. DB2 Error::'|| CHAR(v_SQLCODE) ||' TP_ID:' || p_TP_ID || ' TP_QLFR_ID:' || p_TP_QLFR_ID;
		END IF;
	ELSE 
		-- Check if the crc_code IS present IN the v_crc_codes array of codes (String)
		SET v_POS = LOCATE(p_CRC_CODE,v_CRC_CODES,1);
		
--=============================================================================
-- The CRC Code does NOT exist IN the List of Codes
-- so put this INTO the string
--=============================================================================
		IF (v_POS = 0) THEN 
		
--=============================================================================
-- Check if we are already at the last position IN the CRC Codes then
-- Loop back to the begining of the Table
--=============================================================================
			IF (v_CUR_INDEX_NUM = 250) THEN
				SET v_CUR_INDEX_NUM = 0;
			END IF; 
			
			--OVERLAY only will be ON zLinux so use INSERT Function
			SET v_CRC_CODES = INSERT(v_CRC_CODES,(v_CUR_INDEX_NUM * 15) + 1,15,p_CRC_CODE);
			SET v_CUR_INDEX_NUM = v_CUR_INDEX_NUM + 1;
		
			UPDATE 	EDIDB2A.T_TP_TRAN_DUP_CHK
			SET 	CRC_CD = v_CRC_CODES, CURR_INDX_NUM = v_CUR_INDEX_NUM
			WHERE 	TP_ID = p_tp_id AND TP_QLFR_ID = p_TP_QLFR_ID;
				
			VALUES (SQLCODE) INTO v_SQLCODE;
			
			IF (v_SQLCODE = 0) THEN
				SET p_ERR_CODE = 0;
				SET P_ERR_DESC = 'SP_TP_DUP_CHECK::Successfully Updated into T_TP_TRAN_DUP_CHK';
			ELSE
				SET p_ERR_CODE = 39912345;
				SET P_ERR_DESC = 'SP_TP_DUP_CHECK::Failed to Update T_TP_TRAN_DUP_CHK. DB2 Error::' || CHAR(v_SQLCODE) 
						|| ' TP_ID:' || p_TP_ID || ' TP_QLFR:' || p_TP_QLFR_ID ;
			END IF;
			
		ELSE 
			-- The CRC Codes exists IN the LIST OF CRC CODES
			SET p_ERR_CODE = v_POS;
			SET P_ERR_DESC = 'SP_TP_DUP_CHECK::Failed as the CRC code already exists in T_TP_TRAN_DUP_CHK. TP_ID:' || p_TP_ID || ' TP_QLFR_ID:' || p_TP_QLFR_ID || ' CRC CODE:' ||p_CRC_CODE;
			
		END IF;	
	END IF;
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_GET_GS_SEQ_NUM()
--
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_GET_GS_SEQ_NUM')@

CREATE PROCEDURE  EDIDB2A.SP_GET_GS_SEQ_NUM(
	IN	p_TP_ID 	VARCHAR(40),
	IN	p_TP_QLFR 	CHAR(2), 
	IN	p_TRAN_NUM	VARCHAR(5), 
	OUT	p_SEQ_NUM 	VARCHAR(9), 
	OUT	p_SQLCODE 	INTEGER
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE SQLCODE	INTEGER DEFAULT 0;
	DECLARE v_SEQ_NUM VARCHAR(9);

--======================================================================
--	Setup the EXIT handler for all SQL exceptions
--======================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO p_SQLCODE;

	--	Retrieve the Last GS Control Number that was used for this TP and Transaction Type
	SELECT	CHAR(GS_CTRL_NUM) INTO v_SEQ_NUM
	FROM 	T_TP_GS_CTRL_NUM
	WHERE	TP_ID = p_TP_ID AND	TRAN_NUM = p_TRAN_NUM;
		
	--	Handle the case of No Data Found
	SET p_SQLCODE = SQLCODE ;		

	IF (p_SQLCODE = 0) THEN
		--	Increment the Last Sequence Number
        SET v_SEQ_NUM = CHAR(INT(v_SEQ_NUM) + 1) ;
		SELECT SUBSTR(CHAR(INT(v_SEQ_NUM) + 1000000000),2,9) INTO  p_SEQ_NUM FROM sysibm.sysdummy1 ;
			
		--	Update the Last Used Sequence Number into the Database Record
		UPDATE 	T_TP_GS_CTRL_NUM
			SET 	GS_CTRL_NUM = INT(p_SEQ_NUM)
			WHERE 	TP_ID = p_TP_ID AND	TRAN_NUM = p_TRAN_NUM;
			
		--	Define the error code as successfull
		SET p_SQLCODE = SQLCODE ;
	ELSE
		--	Since a record for this TP and Transaction Number does not exist
		--	Create a new Record.
		SET p_SEQ_NUM = '000000001';

		--	Insert the New Record for thie TP and Trasnaction Number into Table	
		INSERT INTO T_TP_GS_CTRL_NUM
					(TP_ID,TRAN_NUM,TP_QLFR_ID,GS_CTRL_NUM,ST_CTRL_NUM)
			VALUES	(p_TP_ID, p_TRAN_NUM,p_TP_QLFR,INT(p_SEQ_NUM),0);
			
		--	Define the error code as Data Not Found and hence 100
		SET p_SQLCODE = SQLCODE ;
		
	END IF ;
END@

--=============================================================================
--	 Procedure Name: EDIDB2A.SP_GET_ST_SEQ_NUM()
--
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_GET_ST_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.SP_GET_ST_SEQ_NUM(
	IN	p_TP_ID 	VARCHAR(40), 
	IN	p_TP_QLFR 	CHAR(2),
	IN	p_TRAN_NUM  VARCHAR(5), 
	OUT	p_SEQ_NUM 	VARCHAR(9), 
	OUT	p_SQLCODE 	INTEGER
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE SQLCODE INTEGER  DEFAULT 0;
	DECLARE v_SEQ_NUM VARCHAR(9) ;

--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO p_SQLCODE;

--	Retrieve the Last GS Control Number that was used for this TP and Transaction Type
	SELECT	CHAR(ST_CTRL_NUM) INTO v_SEQ_NUM
	FROM 	T_TP_GS_CTRL_NUM
	WHERE	TP_ID = p_TP_ID AND	TRAN_NUM = p_TRAN_NUM;

	--	Handle the case of No Data Found
	SET p_SQLCODE = SQLCODE ;		

	IF (p_SQLCODE = 0) THEN
		--	Increment the Last Sequence Number
		SET v_SEQ_NUM = CHAR(INT(v_SEQ_NUM) + 1) ;
		SELECT SUBSTR(CHAR(INT(v_SEQ_NUM) + 1000000000),2,9) into  p_SEQ_NUM FROM sysibm.sysdummy1 ;
		
		--	Update the Last Used Sequence Number into the Database Record
		UPDATE 	T_TP_GS_CTRL_NUM
		SET 	ST_CTRL_NUM = INT(p_SEQ_NUM)
		WHERE 	TP_ID = p_TP_ID AND	TRAN_NUM = p_TRAN_NUM;

		--	Define the error code as successfull
		SET p_SQLCODE = SQLCODE ;

	ELSE
		--	Since a record for this TP and Transaction Number does not exist
		--	Create a new Record.
		SET p_SEQ_NUM = '000000001';

		--	Insert the New Record for thie TP and Trasnaction Number into Table	
		INSERT INTO T_TP_GS_CTRL_NUM
					(TP_ID,TRAN_NUM,TP_QLFR_id,GS_CTRL_NUM,ST_CTRL_NUM)
			VALUES	(p_TP_ID, p_TRAN_NUM,p_TP_QLFR,0,INT(p_SEQ_NUM));

		--	Define the error code as Data Not Found and hence 100
		SET p_SQLCODE = SQLCODE ;

	END IF ;
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_GENERATE_ISA_SEGMENT()
--	 
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_GENERATE_ISA_SEGMENT')@

CREATE PROCEDURE  EDIDB2A.SP_TP_GENERATE_ISA_SEGMENT
	(
	IN		p_TP_QLFR_ID 		VARCHAR(02),
	IN		p_TP_ID 			VARCHAR(40),
	IN		p_ELEMENT_DLM		CHAR(1),
	IN		p_SEGMENT_DLM		CHAR(1),
	IN		p_COMPOSITE_DLM		CHAR(1),
	IN		p_IN_USAGE_CD_ISA15	CHAR(1),
	OUT	p_ISA_CTRL_NO 		VARCHAR(9),
	OUT	p_EDI_ISA			VARCHAR(500),
	OUT	p_ERR_CODE 			BIGINT,
	OUT	p_ERR_DESC 			VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE SQLCODE	INTEGER DEFAULT 0;
	DECLARE v_SQLCODE INTEGER DEFAULT 0;
	DECLARE v_ISA01_ATHR_INFO_QLFR_CD  VARCHAR(2);
	DECLARE v_ISA02_ATHR_INFO_ID  VARCHAR(10)  ;
	DECLARE v_ISA03_SEC_INFO_QLFR_CD  VARCHAR(2);
	DECLARE v_ISA04_SEC_INFO_ID  VARCHAR(10)  ;
	DECLARE v_ISA05_SNDR_QLFR_CD  VARCHAR(2) ;
	DECLARE v_ISA06_SNDR_ID  VARCHAR(15)  ;
	DECLARE v_ISA07_RECR_QLFR_CD  CHAR(2)  ;
	DECLARE v_ISA08_RECR_ID  VARCHAR(15) ;
	DECLARE v_ISA11_REPT_SEPRT_CD  CHAR(1) ;
	DECLARE v_ISA12_VER_NUM  VARCHAR(5)  ;
	DECLARE v_ISA14_ACKN_RQ_IND  CHAR(1)  ;
	DECLARE v_SND_TECH_ACKN1_IND  CHAR(1)  ;
	DECLARE v_ISA16_CMPNT_ELE_SEPRT_IND  CHAR(1) ;
	DECLARE v_ISA09 DATE ;
	DECLARE v_ISA10 TIMESTAMP ;
	DECLARE v_ISA_CTRL_NO VARCHAR(9);

--=============================================================================
--	SET UP EXIT HANDLER FOR ALL SQL QUERIES
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_SQLCODE ;
	
	SET p_ERR_DESC = '';
	SET p_ERR_CODE = 0 ;
	
--=============================================================================
---RETRIEVE DATA FROM TABLE
--=============================================================================
	SELECT
		COALESCE(ISA01_ATHR_INFO_QLFR_CD,'00'),
		COALESCE(ISA02_ATHR_INFO_ID,'          '),
		COALESCE(ISA03_SEC_INFO_QLFR_CD,'  '),
		COALESCE(ISA04_SEC_INFO_ID, '          '),
		COALESCE(ISA05_SNDR_QLFR_CD,'  '),
		COALESCE(ISA06_SNDR_ID ,'               '),
	    COALESCE(ISA07_RECR_QLFR_CD,'  '),
	    COALESCE(ISA08_RECR_ID ,'               '),
	    COALESCE(ISA11_REPT_SEPRT_CD ,' '),
	    COALESCE(ISA12_VER_NUM ,'     '),
	    COALESCE(ISA14_ACKN_RQ_IND ,' ')
	INTO
		v_ISA01_ATHR_INFO_QLFR_CD ,
		v_ISA02_ATHR_INFO_ID ,
		v_ISA03_SEC_INFO_QLFR_CD ,
		v_ISA04_SEC_INFO_ID  ,
		v_ISA05_SNDR_QLFR_CD  ,
		v_ISA06_SNDR_ID ,
		v_ISA07_RECR_QLFR_CD ,
		v_ISA08_RECR_ID ,
		v_ISA11_REPT_SEPRT_CD,
		v_ISA12_VER_NUM  ,
		v_ISA14_ACKN_RQ_IND 
	FROM
		EDIDB2A.T_TP 
	WHERE	
		TP_ID = p_TP_ID AND TP_QLFR_ID = p_TP_QLFR_ID ;
	
	VALUES(SQLCODE) INTO v_SQLCODE ;
	
	IF (v_SQLCODE = 0) THEN	
--=============================================================================
--	The Trading Partner is identifed in the T_TP Table
--	Formulate the ISA String Buffer with all the Variables and return that Buffer
--	The format of the ISA String is as PER THE ANSI X12 GUIDELINES
--	This is a Fixed Width String
--=============================================================================
	
		-- ISA13 [GENERATE ISA CONTROL NO]
		CALL EDIDB2A.SP_GET_ISA_SEQ_NUM (p_TP_ID,p_TP_QLFR_ID,v_ISA_CTRL_NO,v_SQLCODE);
		IF (v_SQLCODE = 0) THEN
			SET p_EDI_ISA = 'ISA' 	  							    || p_ELEMENT_DLM
							|| v_ISA01_ATHR_INFO_QLFR_CD						|| p_ELEMENT_DLM
							|| RIGHT('          ' ||v_ISA02_ATHR_INFO_ID,10)			|| p_ELEMENT_DLM
							|| v_ISA03_SEC_INFO_QLFR_CD							|| p_ELEMENT_DLM
							|| RIGHT('          ' || v_ISA04_SEC_INFO_ID,10) 			|| p_ELEMENT_DLM
							|| v_ISA05_SNDR_QLFR_CD 							|| p_ELEMENT_DLM
							|| LEFT(v_ISA06_SNDR_ID||'               ' ,15)  				|| p_ELEMENT_DLM
							|| v_ISA07_RECR_QLFR_CD 							|| p_ELEMENT_DLM
							|| LEFT(v_ISA08_RECR_ID|| '               ' ,15) 				|| p_ELEMENT_DLM
							|| EDIDB2A.EDIDATE_YYMMDD(CURRENT DATE) 			|| p_ELEMENT_DLM
							|| EDIDB2A.EDITIME_HHMM(CURRENT TIME)				|| p_ELEMENT_DLM
							|| v_ISA11_REPT_SEPRT_CD							|| p_ELEMENT_DLM
							|| RIGHT('     ' || v_ISA12_VER_NUM,5) 					|| p_ELEMENT_DLM 
							|| v_ISA_CTRL_NO 									|| p_ELEMENT_DLM
							|| v_ISA14_ACKN_RQ_IND  							|| p_ELEMENT_DLM
							|| p_IN_USAGE_CD_ISA15  							|| p_ELEMENT_DLM
							|| p_COMPOSITE_DLM  								|| p_SEGMENT_DLM;
							
			--	Set the Procedure Parameter so that the calling program has access to ISA Control No
			SET p_ISA_CTRL_NO = v_ISA_CTRL_NO;
			SET p_ERR_CODE = 0;	
		ELSE
			SET p_ERR_DESC = 'DB2.SP_TP_GENERATE_ISA:: Error Returned back from SP_GET_ISA_SEQ_NUM T_TP TP_ID:=' || p_TP_ID || ' TP_QUAL:=' ||p_TP_QLFR_ID || ';';
			SET p_ERR_CODE = 39230003;				
		END IF;
	ELSEIF (v_SQLCODE = 100) THEN
		-- The Trading Partner is not present in Either T_TP 
		SET p_ERR_DESC = 'DB2.SP_TP_GENERATE_ISA::TP NOT FOUND in T_TP TP_ID:=' || p_TP_ID || ' TP_QUAL:=' ||p_TP_QLFR_ID || ';';
		SET p_ERR_CODE = 39230001 ;	
	ELSE
		SET p_ERR_DESC = 'DB2.SP_TP_GENERATE_ISA::Unknown DB2 SQL Exception :=' || p_TP_ID || ' TP_QUAL:=' ||p_TP_QLFR_ID || 'SQL CODE=' || char(v_SQLCODE) || ';' ;
		SET p_ERR_CODE = 39230002 ;		
	END IF ;
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_GENERATE_TA1_SEGMENT()
--	 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_GENERATE_TA1_SEGMENT')@

CREATE PROCEDURE  EDIDB2A.SP_TP_GENERATE_TA1_SEGMENT
	(
	IN	p_IN_ISA_CTRL_NO_ISA13	INTEGER,
	IN	p_IN_ISA_DT_ISA09		VARCHAR(20),
	IN	p_IN_ISA_TME_ISA10		VARCHAR(6),
	IN	p_IN_TA1_ERROR_CD		VARCHAR(3),
	IN	p_ELEMENT_DLM			CHAR(1),
	IN	p_SEGMENT_DLM			CHAR(1),
	OUT	p_EDI_TA1				VARCHAR(125),
	OUT	p_ERR_CODE				BIGINT,
	OUT p_ERR_DESC				VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE v_OUTBUFFER VARCHAR(125);

	SET v_OUTBUFFER = 'TA1'
		|| p_ELEMENT_DLM || SUBSTR(CHAR(p_IN_ISA_CTRL_NO_ISA13 + 1000000000),2,9) 
		|| p_ELEMENT_DLM || p_IN_ISA_DT_ISA09
		|| p_ELEMENT_DLM || p_IN_ISA_TME_ISA10
		|| p_ELEMENT_DLM|| 'R'
		|| p_ELEMENT_DLM || p_IN_TA1_ERROR_CD
		|| p_SEGMENT_DLM;
		
	SET p_EDI_TA1 = RTRIM(v_OUTBUFFER);
	SET p_ERR_CODE =0 ;
    SET p_ERR_DESC = 'VALUE DISPLAYED';
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_GENERATE_IEA_SEGMENT()
--	 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_GENERATE_IEA_SEGMENT')@

CREATE PROCEDURE  EDIDB2A.SP_TP_GENERATE_IEA_SEGMENT
	(
	IN	p_ISA_CTRL_NO_ISA13	INTEGER,
	IN	p_ISA_SEGMENTS		VARCHAR(6),
	IN  p_ELEMENT_DLM		CHAR(1),
	IN 	p_SEGMENT_DLM		CHAR(1),
	OUT p_EDI_IEA	        VARCHAR(60),
	OUT p_ERR_CODE       	BIGINT,
	OUT p_ERR_DESC        	VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE v_OUTBUFFER VARCHAR(60);
	 
	SET v_OUTBUFFER = 'IEA'
		|| p_ELEMENT_DLM || p_ISA_SEGMENTS
		|| p_ELEMENT_DLM || SUBSTR(CHAR(p_ISA_CTRL_NO_ISA13  + 1000000000),2,9)
		|| p_SEGMENT_DLM; 
		
	SET p_EDI_IEA = RTRIM(v_OUTBUFFER);
	SET p_ERR_CODE = 0 ;
	SET p_ERR_DESC = 'VALUE DISPLAYED';
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_GENERATE_GS_SEGMENT()
--	 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_GENERATE_GS_SEGMENT')@

CREATE PROCEDURE EDIDB2A.SP_TP_GENERATE_GS_SEGMENT
	(
	IN 		p_TP_ID 		VARCHAR(40),
	IN 		p_TP_QLFR_ID 	CHAR(2),
	IN 		p_TRAN_NUM 		VARCHAR(4),
	IN  	p_TRAN_VER_NUM  VARCHAR(12),
	IN		p_DIR_IND		CHAR(1),
	IN 		p_ELEMENT_DLM	CHAR(1),
	OUT 	p_GS_OUT_BUFFER VARCHAR(255),
	OUT 	p_ERR_CODE 		INTEGER,
	OUT 	p_ERR_DESC 		VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE v_GS01_FUNCL_ID	CHAR(2);
	DECLARE v_GS02_SNDR_CD		VARCHAR(15);
	DECLARE v_GS03_RECR_CD		VARCHAR(15);
	DECLARE v_CTRL_NUM 		VARCHAR(9);
	DECLARE v_GS07_RSPB_AGY_CD CHAR(2);
	DECLARE v_GS_OUT_BUFFER 	VARCHAR(255) DEFAULT '';
	DECLARE v_SQLCODE			INTEGER;
	DECLARE SQLCODE 			INTEGER DEFAULT 0;

--=============================================================================
--	SET UP EXIT HANDLER FOR ALL SQL QUERIES
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_SQLCODE;

	SELECT GS01_FUNCL_ID,GS02_SNDR_CD,GS03_RECR_CD,GS07_RSPB_AGY_CD
	INTO v_GS01_FUNCL_ID,v_GS02_SNDR_CD,v_GS03_RECR_CD,v_GS07_RSPB_AGY_CD
	FROM T_TP_TRAN_AUTH 
	WHERE TP_ID = p_TP_ID AND TP_QLFR_ID = p_TP_QLFR_ID 
	AND TRAN_NUM = p_TRAN_NUM AND TRAN_VER_NUM = p_TRAN_VER_NUM ;
	--	Chad has aked us to not do this as per the tp Meeting on Oct/15/2010
	--AND DIR_IND = p_DIR_IND;

	VALUES (SQLCODE) INTO v_SQLCODE;
	SET p_ERR_CODE = v_SQLCODE;
	IF (v_SQLCODE = 0) THEN
		CALL EDIDB2A.SP_GET_GS_SEQ_NUM(p_TP_ID,p_TP_QLFR_ID,p_TRAN_NUM,v_CTRL_NUM,v_SQLCODE);
		SET p_ERR_CODE = v_SQLCODE;
		IF (v_SQLCODE = 0) THEN
			SET v_GS_OUT_BUFFER = 'GS' 								|| p_ELEMENT_DLM 
							|| v_GS01_FUNCL_ID 						|| p_ELEMENT_DLM 
							|| v_GS02_SNDR_CD 						|| p_ELEMENT_DLM 
							|| v_GS03_RECR_CD 						|| p_ELEMENT_DLM 
							|| EDIDB2A.EDIDATE_CCYYMMDD(CURRENT DATE) || p_ELEMENT_DLM 
							|| EDIDB2A.EDITIME_HHMM(CURRENT TIME)	|| p_ELEMENT_DLM 
							|| v_CTRL_NUM  							|| p_ELEMENT_DLM 
							|| RTRIM(v_GS07_RSPB_AGY_CD)			|| p_ELEMENT_DLM 
							|| p_TRAN_VER_NUM;
			SET p_GS_OUT_BUFFER = v_GS_OUT_BUFFER;
		ELSE
			SET p_ERR_DESC = 'DB2:DATA FOUND';
		END IF;
	ELSE
		SET p_ERR_DESC = 'DB2:SP_TP_GENERATE_GS_SEGMENT DATA NOT FOUND';
	END IF;	
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_GENERATE_ST_SEGMENT()
--	 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_GENERATE_ST_SEGMENT')@


CREATE PROCEDURE EDIDB2A.SP_TP_GENERATE_ST_SEGMENT
	(
	IN 	p_TP_ID 		VARCHAR(40),
	IN 	p_TP_QLFR_ID 	CHAR(2),
	IN 	p_TRAN_NUM 		CHAR(4),
	IN  p_TRAN_VER_NUM  VARCHAR(12),
	IN 	p_ELEMENT_DLM	CHAR(1),
	OUT p_ST_OUT_BUFFER VARCHAR(255),
	OUT p_ERR_CODE 		INTEGER,
	OUT p_ERR_DESC 		VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE v_TRAN_NUM_ST01  CHAR(4);
	DECLARE v_TRAN_VER_ST02  VARCHAR(12);
	DECLARE v_CTRL_NUM 		 VARCHAR(9);
	DECLARE v_ST_OUT_BUFFER VARCHAR(255) DEFAULT '';
	DECLARE v_SQLCODE INTEGER;
	DECLARE v_SQLCODE1 INTEGER;
	DECLARE SQLCODE INTEGER DEFAULT 0;

--=============================================================================
--	SET UP EXIT HANDLER FOR ALL SQL QUERIES
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_SQLCODE;

	SELECT TRAN_NUM,TRAN_VER_NUM 
	INTO v_TRAN_NUM_ST01,v_TRAN_VER_ST02 
	FROM T_TP_TRAN_AUTH 
	WHERE TP_ID = p_TP_ID AND TP_QLFR_ID = p_TP_QLFR_ID 
	AND TRAN_NUM = p_TRAN_NUM AND TRAN_VER_NUM = p_TRAN_VER_NUM;
--	Chad has aked us to not do this as per the tp Meeting on Oct/15/2010
	-- AND DIR_IND = 'O';
	
	VALUES (SQLCODE) INTO v_SQLCODE;

	IF (v_SQLCODE = 0) THEN

		CALL EDIDB2A.SP_GET_ST_SEQ_NUM(p_TP_ID,p_TP_QLFR_ID,p_TRAN_NUM,v_CTRL_NUM,v_SQLCODE1);

		IF (v_SQLCODE1 = 0) THEN
			SET v_ST_OUT_BUFFER = 'ST' 					|| p_ELEMENT_DLM 
				|| SUBSTR(v_TRAN_NUM_ST01,1,3)			|| p_ELEMENT_DLM 
				|| v_CTRL_NUM  					    	|| p_ELEMENT_DLM 
				|| v_TRAN_VER_ST02;

			SET p_ERR_CODE = v_SQLCODE;
			SET p_ERR_DESC = 'DB2:DATA FOUND';
		END IF;

	ELSE

		SET p_ERR_CODE = v_SQLCODE;
		SET p_ERR_DESC = 'DB2:SP_TP_GENERATE_ST_SEGMENT DATA NOT FOUND';

	END IF;
SET p_ST_OUT_BUFFER = v_ST_OUT_BUFFER;
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_GENERATE_TA1()
--	 The Parameters being passed to this Procedure are as follows:
--	p_TP_QLFR_ID and P_TP_ID identify the Trading Partner for whocm this TA1 is
--	being generated for.
--	p_IN_ISA_CTRL_NO_ISA13, P_IN_ISA_DT_ISA09, p_IN_ISA_TME_ISA10 are the Values
--	from the Inbound File That trigerred this TA1 Generation.
--	p_IN_TA1_ERROR_CD - this is the TA1 Error code that the application Module
--	wants to be sent as part of the TA1.
--
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_GENERATE_TA1')@

/*
Highlight and execute the following statement to drop the procedure
before executing the create statement.

DROP PROCEDURE EDIDB2A.SP_TP_GENERATE_TA1

*/

CREATE PROCEDURE  EDIDB2A.SP_TP_GENERATE_TA1
	(
	IN	p_TP_QLFR_ID      		VARCHAR(02),
	IN	p_TP_ID					VARCHAR(40),
	IN	p_IN_ISA_CTRL_NO_ISA13	INTEGER,
	IN	p_IN_ISA_DT_ISA09     	VARCHAR(6),
	IN	p_IN_ISA_TME_ISA10    	VARCHAR(4),
	IN	p_IN_TA1_ERROR_CD   	VARCHAR(3),
	IN	p_IN_USAGE_CD_ISA15		CHAR(1),
	OUT p_EDI_TA1	        	VARCHAR(500),
	OUT p_ERR_CODE       		BIGINT,
	OUT p_ERR_DESC        		VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE v_ISA_CTRL_NO VARCHAR(9);
	DECLARE v_OUTBUFFER VARCHAR(500);
	DECLARE v_ELEMENT_DLM CHAR(1) DEFAULT '*';
	DECLARE v_SEGMENT_DLM CHAR(1) DEFAULT '~';
	DECLARE v_COMPOSITE_DLM	CHAR(1) DEFAULT '>';
	
	SET p_EDI_TA1 = '';
	
	--	Check if the TP_ID is Blank and if so then it is an error and we cannot 
	--	generate a TA1.
	IF (coalesce(p_TP_ID,'') = '') THEN
		SET p_ERR_CODE = 3990123;
		SET p_ERR_DESC = 'SP_TP_GENERATE_TA1::TP_ID is NULL' ;
	ELSE
		
		--==============================================================================================
		-- Generate an ISA Segment specific to this Trading Partner and also retrieve the ISA Control No 
		-- Generated as part of this Segment and pass it to the IEA Segment generation
		--==============================================================================================
		CALL EDIDB2A.SP_TP_GENERATE_ISA_SEGMENT(p_TP_QLFR_ID, p_TP_ID, v_ELEMENT_DLM,v_SEGMENT_DLM,v_COMPOSITE_DLM,p_IN_USAGE_CD_ISA15,v_ISA_CTRL_NO, v_OUTBUFFER,p_ERR_CODE,p_ERR_DESC);
		
		IF (p_ERR_CODE = 0) THEN
			SET p_EDI_TA1 = p_EDI_TA1 || v_outBuffer;
			SET p_EDI_TA1 = p_EDI_TA1 || CHR(13) || CHR(10);
			
			CALL EDIDB2A.SP_TP_GENERATE_TA1_SEGMENT (p_IN_ISA_CTRL_NO_ISA13,p_IN_ISA_DT_ISA09,p_IN_ISA_TME_ISA10,p_IN_TA1_ERROR_CD,v_ELEMENT_DLM,v_SEGMENT_DLM,v_OUTBUFFER,p_ERR_CODE,p_ERR_DESC);
			
			IF (p_ERR_CODE = 0) THEN
				SET p_EDI_TA1 = p_EDI_TA1 || v_OUTBUFFER;
				SET p_EDI_TA1 = p_EDI_TA1 || CHR(13) || CHR(10);
				
				CALL EDIDB2A.SP_TP_GENERATE_IEA_SEGMENT (INT(v_ISA_CTRL_NO),'1',v_ELEMENT_DLM,v_SEGMENT_DLM,v_OUTBUFFER,p_ERR_CODE,p_ERR_DESC);
				
				IF (p_ERR_CODE = 0) THEN
					SET p_EDI_TA1 = p_EDI_TA1 || v_OUTBUFFER;
					SET p_EDI_TA1 = p_EDI_TA1 || CHR(13) || CHR(10);		
				ELSE
					SET p_ERR_DESC = 'DB2.SP_TP_GENERATE_TA1::' || p_ERR_DESC;
				END IF;
			ELSE
				SET p_ERR_DESC = 'DB2.SP_TP_GENERATE_TA1::'|| p_ERR_DESC;
			END IF;
		ELSE
			SET p_ERR_DESC = 'DB2.SP_TP_GENERATE_TA1::'|| p_ERR_DESC;
		END IF;
	END IF;
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_GENERATE_999()
--	 Description:
--	 This stored proc is used to generate the Content that goes into an Outbound 999
--	 When a TP Validation fails at the Transaction Authorization Level
--
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_GENERATE_999')@

CREATE PROCEDURE EDIDB2A.SP_TP_GENERATE_999
	(
	IN	p_TP_QLFR_ID			VARCHAR(02),
	IN	p_TP_ID					VARCHAR(40),
	IN	p_IN_GS01				VARCHAR(02),
	IN	p_IN_GS06				VARCHAR(9),
	IN	p_IN_GS08				VARCHAR(12),
	IN	p_IN_ISA_CTRL_NO_ISA13 	INT,
	IN	p_IN_ISA_DT_ISA09		VARCHAR(6),
	IN	p_IN_ISA_TME_ISA10		VARCHAR(4),
	IN	p_IN_FILE_ST_CNT       	VARCHAR(4),
	IN	P_IN_TRANS_ST_SEG_CNT  	VARCHAR(4),
	IN	p_IN_TA1_ERROR_CD   	VARCHAR(3),
	IN	p_IN_USAGE_CD_ISA15		CHAR(1),
	IN	p_TRAN_NUM				VARCHAR(4),
	IN	p_DIR_IND				CHAR(1),
	OUT	p_EDI_999_BUFFER	VARCHAR(1000),
	OUT	p_ERR_CODE			BIGINT,
	OUT	p_ERR_DESC			VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE v_OUTBUFFER VARCHAR(1000);
	DECLARE v_ISA_CTRL_NO VARCHAR(9);
	DECLARE v_ELEMENT_DLM	CHAR(1) DEFAULT '*';
	DECLARE v_SEGMENT_DLM	CHAR(1) DEFAULT '~';
	DECLARE v_COMPOSITE_DLM	CHAR(1) DEFAULT '>';
	DECLARE v_GS_CTRL_NUM VARCHAR(9) ;
	DECLARE v_SQLCODE BIGINT DEFAULT 0;
	
--===========================================================================================
--	Generating All the Segments
--===========================================================================================

	--	Generate the ISA Segment
	SET v_OUTBUFFER = '';
	CALL EDIDB2A.SP_TP_GENERATE_ISA_SEGMENT(p_TP_QLFR_ID, p_TP_ID, v_ELEMENT_DLM,v_SEGMENT_DLM,v_COMPOSITE_DLM,p_IN_USAGE_CD_ISA15,v_ISA_CTRL_NO, v_OUTBUFFER,p_ERR_CODE,p_ERR_DESC);
	SET p_EDI_999_BUFFER = v_OUTBUFFER;
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || CHR(13) || CHR(10);
	
	--	Generate the TA1 Segment
	CALL EDIDB2A.SP_TP_GENERATE_TA1_SEGMENT (p_IN_ISA_CTRL_NO_ISA13,p_IN_ISA_DT_ISA09,p_IN_ISA_TME_ISA10,p_IN_TA1_ERROR_CD,v_ELEMENT_DLM,v_SEGMENT_DLM,v_OUTBUFFER,p_ERR_CODE,p_ERR_DESC);
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || v_OUTBUFFER ;
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || CHR(13) || CHR(10);
	
	--	Generate the GS Segment
	CALL EDIDB2A.SP_TP_GENERATE_GS_SEGMENT(p_TP_ID,p_TP_QLFR_ID,'999','005010X231',p_DIR_IND,v_ELEMENT_DLM, v_OUTBUFFER, p_ERR_CODE,p_ERR_DESC); 
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || v_OUTBUFFER || '~';
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || CHR(13) || CHR(10);

	--	Generate the ST Segment	
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || 'ST*999*0001~';
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || CHR(13) || CHR(10);
	
	--	Generate the AK1 Segment	
	SET p_EDI_999_Buffer = p_EDI_999_BUFFER || 'AK1*' ||p_IN_GS01 ||'*'||p_IN_GS06||'*'||p_IN_GS08 ||'~';
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || CHR(13) || CHR(10);
							
	--	Generate the IK5 Segment	
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || 'IK5*R*' || p_IN_FILE_ST_CNT ||'~';
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || CHR(13) || CHR(10);
	
	--	Generate the AK9 Segment	
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || 'AK9*R*1*1*0~';
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || CHR(13) || CHR(10);
	
	--	Generate the SE Segment	
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || 'SE*' || P_IN_TRANS_ST_SEG_CNT || '*0001~';
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || CHR(13) || CHR(10);
	
	--	Generate the GE Segment
	CALL EDIDB2A.SP_GET_GS_SEQ_NUM(p_TP_ID,p_TP_QLFR_ID, '999',v_GS_CTRL_NUM,v_sqlcode);
	--	SELECT	CHAR(GS_CTRL_NUM) INTO v_GS_CTRL_NUM
	--	FROM 	T_TP_GS_CTRL_NUM
	--	WHERE	TP_ID = p_TP_ID AND	TP_QLFR_ID = p_TP_QLFR_ID 
	--	AND TRAN_NUM = p_TRAN_NUM ;
	-- 	SELECT SUBSTR(CHAR(INT(v_GS_CTRL_NUM) + 1000000000),2,9) INTO v_GS_CTRL_NUM FROM SYSIBM.SYSDUMMY1;
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || 'GE*' ||  '01*' || v_GS_CTRL_NUM || '~' ;
	SET p_EDI_999_BUFFER = p_EDI_999_BUFFER || CHR(13) || CHR(10);
	
	--	Generate the IEA Segment
	SET p_EDI_999_Buffer = p_EDI_999_Buffer || 'IEA*' ||  '0001*' || v_ISA_CTRL_NO || '~';
		
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_LOOKUP()
--	 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_LOOKUP')@

CREATE PROCEDURE EDIDB2A.SP_TP_LOOKUP
	(
    IN 	p_TP_QLFR		VARCHAR(2),
    IN 	p_TP_ID			VARCHAR(40),
    IN 	p_TP_TRAN_NUM	VARCHAR(4),
    IN 	p_TRAN_VER		VARCHAR(12),
    IN 	p_FLAG			CHARACTER(1),
    OUT p_TP_PROF		XML,
    OUT p_TP_AUTH		XML,
    OUT p_ERR_CODE		BIGINT,
    OUT p_ERR_DESC		VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN 
--=============================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=============================================================================
	DECLARE SQLCODE	INTEGER DEFAULT 0;
	DECLARE v_SQLCODE_TP_PROF INTEGER ;
	DECLARE v_SQLCODE_TP_AUTH INTEGER ;
	DECLARE v_TP_QLFR VARCHAR(2) ;
	DECLARE v_TP_ID VARCHAR(40);
	DECLARE v_TP_PROFILE VARCHAR(5000); 
	DECLARE v_TRANS_AUTH VARCHAR(2500) DEFAULT '0' ;

--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION  
	VALUES (SQLCODE) INTO v_SQLCODE_TP_PROF;

 IF (p_FLAG ='C' or p_FLAG ='c') THEN 
    SELECT  XMLROW(  TP_ID , TP_QLFR_ID AS TP_QLFR , ELE_DLTD_ID AS ELEMENT_DELIMITER,  SEG_DLTD_ID AS SEG_DELIMITER,  ISA01_ATHR_INFO_QLFR_CD AS ATHR_INFO_QLFR_ISA01,
    ISA02_ATHR_INFO_ID AS ATHR_INFO_ISA02, ISA03_SEC_INFO_QLFR_CD AS SEC_INFO_QLFR_ISA03, ISA04_SEC_INFO_ID AS SEC_INFO_ISA04, ISA05_SNDR_QLFR_CD AS SNDR_QLFR_ISA05, ISA06_SNDR_ID AS SNDR_ID_ISA06,
    ISA07_RECR_QLFR_CD AS RECR_QLFR_ISA07, ISA08_RECR_ID AS RECR_ID_ISA08, ISA11_REPT_SEPRT_CD AS REPT_SEPARATOR_ISA11,ISA12_VER_NUM AS VER_NUM_ISA12, ISA14_ACKN_RQ_IND AS ACKN_RQ_ISA14,
    ISA15_USE_IND AS USE_IND_ISA15, ISA16_CMPNT_ELE_SEPRT_IND AS CMPNT_ELE_SEPARATOR_ISA16, SND_TECH_ACKN1_IND AS SND_TA1_FLAG OPTION ROW  "tp_profile" ) 
    INTO p_TP_PROF FROM EDIDB2A.T_TP 
    WHERE TP_ID = p_TP_ID AND TP_QLFR_ID = p_TP_QLFR  ;
     
    SET v_SQLCODE_TP_PROF = SQLCODE;

    SELECT XMLROW( TP_ID , TP_QLFR_ID AS TP_QLFR, GS01_FUNCL_ID AS FUNCL_ID_CD_GS01, GS02_SNDR_CD AS GS_SNDR_CD_GS02, GS03_RECR_CD AS GS_RECR_CD_GS03, GS07_RSPB_AGY_CD AS RSPB_AGY_CD_GS07, 
    TRAN_VER_NUM AS TRAN_VER_GS08, TRAN_NUM AS TRAN_NUM_ST01, TECH_ACKN1_IND AS FLAG_TA1, C999_IND AS FLAG_999, CLM_ACKN277_IND AS FLAG_277CA, C997_IND AS FLAG_997 OPTION ROW "tp_tran_auth") 
    INTO  p_TP_AUTH FROM EDIDB2A.T_TP_TRAN_AUTH 
    WHERE TP_ID = p_TP_ID AND TP_QLFR_ID = p_TP_QLFR AND TRAN_NUM = p_TP_TRAN_NUM  AND  TRAN_VER_NUM = p_TRAN_VER  FETCH FIRST ROW ONLY; 
	 
    SET v_SQLCODE_TP_AUTH = SQLCODE;
 
 ELSE 
    SELECT  XMLROW(TP_ID as TP, TP_QLFR_ID as TP_TYPE, ELE_DLTD_ID as ELE_DLTD_ID, SEG_DLTD_ID,PRTNR_ADR_TXT,
    PRTNR_CY_NME,PRTNR_STT_CD,PRTNR_ZIP_CD,PRTNR_CNTC_NME ,PRTNR_CNTC_PH_NUM ,PRTNR_CNTC_PH_EXT_NUM,PRTNR_CNTC_EMAIL_ID, PRTNR_NME,EDDI_ID,ISA01_ATHR_INFO_QLFR_CD,ISA02_ATHR_INFO_ID,ISA03_SEC_INFO_QLFR_CD,ISA04_SEC_INFO_ID, ISA05_SNDR_QLFR_CD, ISA06_SNDR_ID,ISA07_RECR_QLFR_CD,ISA08_RECR_ID,ISA12_VER_NUM,ISA14_ACKN_RQ_IND, ISA15_USE_IND,SND_TECH_ACKN1_IND,EXPCT_TECH_ACKN1_IND,HIGH_LVL_ACKN_IND,TP_QLFR_ID,
    ISA11_REPT_SEPRT_CD,ISA16_CMPNT_ELE_SEPRT_IND OPTION ROW "tp_profile" )
    INTO p_TP_PROF FROM EDIDB2A.T_TP    
    WHERE TP_ID = p_TP_ID AND TP_QLFR_ID = p_TP_QLFR; 
 
	SET v_sqlcode_tp_prof = SQLCODE;
   
	SELECT XMLROW(TP_ID ,TP_QLFR_ID,TRAN_NUM,TRAN_VER_NUM,GS01_FUNCL_ID,DIR_IND,LOB_IND,TECH_ACKN1_IND,C999_IND,CLM_ACKN277_IND,C997_IND,   
	ACTV_IND,CMPL_LVL_CD,CMPL_RPT_IND,GS02_SNDR_CD,GS03_RECR_CD,GS07_RSPB_AGY_CD,UPDT_BY,UPDT_TS  OPTION ROW "tp_tran_auth")
	INTO  p_tp_auth FROM EDIDB2A.T_TP_TRAN_AUTH   
	WHERE TP_ID = p_TP_ID AND TP_QLFR_ID = p_TP_QLFR AND TRAN_NUM = p_TP_TRAN_NUM  AND  TRAN_VER_NUM = p_TRAN_VER  FETCH FIRST ROW ONLY; 
   
    SET v_SQLCODE_TP_AUTH = SQLCODE;

 END IF;
  
    IF (v_SQLCODE_TP_PROF = 0 AND v_SQLCODE_TP_AUTH <> 0) THEN
  
		SET p_ERR_CODE = v_SQLCODE_TP_AUTH ;
		SET p_ERR_DESC = 'ROW FOUND FROM TABLE T_TP AND ROW NOT FOUND FROM TABLE T_TP_TRAN_AUTH';
 	
 	ELSEIF (v_SQLCODE_TP_PROF <> 0 AND v_SQLCODE_TP_AUTH = 0) 	THEN
 
		SET p_ERR_CODE = v_SQLCODE_TP_PROF ;
		SET p_ERR_DESC = 'ROW NOT FOUND FROM TABLE T_TP AND ROW FOUND FROM TABLE T_TP_TRAN_AUTH';
      
    ELSEIF (v_SQLCODE_TP_PROF = 0 AND v_SQLCODE_TP_AUTH = 0) THEN
    
		SET p_ERR_CODE = v_SQLCODE_TP_PROF ;
		SET p_ERR_DESC = 'ROW FOUND';
     
    ELSEIF (v_SQLCODE_TP_PROF <> 0 AND v_SQLCODE_TP_AUTH <> 0) THEN
    
		SET p_ERR_CODE = v_sqlcode_tp_prof ;
		SET p_ERR_DESC = 'ROW NOT FOUND';
	END IF;
  
	IF ( p_TP_PROF IS NULL AND p_TP_AUTH IS NULL AND p_ERR_CODE IS NULL ) THEN
  
		SET p_ERR_CODE = v_SQLCODE_TP_PROF ;
		SET p_ERR_DESC = 'INVALID DATA IN DATABASE' ;
    END IF;
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_VALIDATE_FUNC_GRP_AND_TRANS()
--	 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_VALIDATE_FUNC_GRP_AND_TRANS')@

CREATE PROCEDURE  EDIDB2A.SP_TP_VALIDATE_FUNC_GRP_AND_TRANS
	(
	IN 	p_GS01 			VARCHAR(15),	
	IN 	p_GS08 			VARCHAR(15),	
	IN 	p_ST01 			VARCHAR(15),
	IN 	p_TP_ID_QUAL	VARCHAR(2),
	IN  p_TP_ID 		VARCHAR(40),
	OUT p_ERR_CODE 		BIGINT, 	
	OUT p_ERR_DESC 		VARCHAR(255)
)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
----DECLERATIOIN OF VARIABLES IN PROCEDURE   
--=============================================================================
	DECLARE v_TP_ID VARCHAR(40);
	DECLARE SQLCODE	INTEGER DEFAULT 0;
	DECLARE v_SQLCODE INTEGER ;

--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_SQLCODE ; 
	
--=============================================================================
---RETRIEVE DATA FROM TABLE----
--=============================================================================
	SELECT	TP_ID INTO v_TP_ID 
		FROM	EDIDB2A.T_TP_TRAN_AUTH 
		WHERE 	GS01_FUNCL_ID = p_GS01
		AND	TRIM(TRAN_VER_NUM) = p_GS08
		AND	TRIM(TRAN_NUM) = p_ST01
		AND	TP_ID= p_TP_ID
		AND	TP_QLFR_ID = p_TP_ID_QUAL
		AND	ACTV_IND = 'Y';
	--	Chad has aked us to not do this as per the tp Meeting on Oct/15/2010
	--	AND	     DIR_IND = 'I';
		
	SET v_SQLCODE = SQLCODE ;
	
	IF (v_SQLCODE = 0) THEN 
		SET p_ERR_DESC = 'EXECUTED SUCCESSFULLY';
		SET p_ERR_CODE = 0 ;
		
	ELSEIF (v_SQLCODE = 100) THEN 
		SET p_ERR_DESC = 'DB2.SP_VALIDATE_FUNC_GRP_AND_TRANS::TRANSACTION NOT AUTHORIZED TP_ID:=' ||p_TP_ID|| ' TP_QLFR_ID:=' || p_TP_ID_QUAL || ' GS01:=' || p_GS01 || ' GS08:=' || p_GS08 || ' ST01:=' || p_ST01 || ';';
		SET p_ERR_CODE = 39230007 ;
	
	ELSE
		SET p_ERR_DESC = 'DB2.SP_VALIDATE_FUNC_GRP_AND_TRANS::Unknown Exception'|| CHAR(v_SQLCODE) ||' While Selecting from T_TP TP_ID:=' ||p_TP_ID|| ' TP_QLFR_ID:=' || p_TP_ID_QUAL || ' GS01:=' || p_GS01 || ' GS08:=' || p_GS08 || ' ST01:=' || p_ST01 || ';' ; 
		SET p_ERR_CODE =39230008;
	END IF ; 
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_VALIDATE_GS_SUBMITTER_ID()
--	 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_VALIDATE_GS_SUBMITTER_ID')@

CREATE PROCEDURE  EDIDB2A.SP_TP_VALIDATE_GS_SUBMITTER_ID
	(
	IN		p_ISA05		VARCHAR(2),
	IN		p_GS02		VARCHAR(15),
	IN		p_TP_QLFR	VARCHAR(2),
	IN		p_TP_ID		VARCHAR(40),
	OUT	p_ERR_CODE	BIGINT,
	OUT	p_ERR_DESC	VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
--  DECLERATIOIN OF VARIABLES IN PROCEDURE    
--=============================================================================
	DECLARE SQLCODE	INTEGER DEFAULT 0;
	DECLARE v_SQLCODE 	INTEGER DEFAULT 0;
	DECLARE v_TP_QLFR 	VARCHAR(2);
	DECLARE v_TP_ID 	VARCHAR(40);

--=============================================================================
-- SET UP EXIT HANDLER FOR ALL SQL QUERIES	
--=============================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
     
	SET p_ERR_DESC = '';
	SET p_ERR_CODE = 0;
--=============================================================================
--  Try to Validate the GROUP Application ID against the T_TP Table
--=============================================================================
		
	SELECT	TP_ID	INTO v_TP_ID
	FROM	EDIDB2A.T_TP
	WHERE
		TP_ID = p_GS02 ;
	--	Dropped this condition as Chad on Oct/22/2010 concluded that this is not necessary
		--AND 	TP_QLFR_ID = p_ISA05;
	
	VALUES (SQLCODE) INTO v_SQLCODE;
	
	IF (v_SQLCODE = 0) THEN
		-- Found the Group Application Sender Id in T_TP
		SET p_TP_QLFR = p_ISA05 ;
	
	ELSE IF (v_SQLCODE = 100) THEN
		-- Search in TBL_XREF as the GS Sender Id is not found in T_TP
		SELECT TP_ID INTO v_TP_ID
		FROM EDIDB2A.T_TP_XREF
		WHERE
			ALIAS_TP_ID = p_GS02 	
			AND ALIAS_TP_QLFR_ID =  p_ISA05;
			
		VALUES (SQLCODE) INTO v_SQLCODE;
		
		IF (v_SQLCODE = 0) THEN
			--	The GS Sender Id is identifed in the T_XREF Table
			SET p_TP_QLFR = p_ISA05;
			
		ELSEIF (v_SQLCODE = 100) THEN
			-- The Trading Partner is not present in Either T_TP or T_TP_XREF
			SET p_ERR_DESC = 'DB2.SP_VALIDATE_GS_SUBMITTER_ID::TP NOT FOUND in T_TP or TP_XREF Tables.TP_ID:=' ||
				p_GS02|| ' TP_QUAL:=' || p_ISA05 || ';';
			SET p_ERR_CODE = 39230004 ;	
			
		ELSE
			-- Unknown exception occurred while executing the Select on T_TP_XREF
			SET p_ERR_DESC = 'DB2.SP_VALIDATE_GS_SUBMITTER_ID::Unknown SQL Exception while selecting from T_XREF for GS02:=' ||p_GS02 || ' TP_QUAL:=' || p_ISA05 || ';';
			SET p_ERR_CODE = 39230005 ;
		END IF	;	
	ELSE
		SET p_ERR_DESC = 'DB2.SP_VALIDATE_GS_SUBMITTER_ID::Unknow SQL Exception while selecting from T_TP:: GS02:=' ||p_GS02 || ' TP_QUAL:=' || p_ISA05 || ';';
		SET p_ERR_CODE = 39230006 ;
	END IF ;
END IF ;
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_VALIDATE_ISA_SENDER_ID()
--	 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_VALIDATE_ISA_SENDER_ID')@

CREATE PROCEDURE EDIDB2A.SP_TP_VALIDATE_ISA_SENDER_ID
	(
	IN p_ISA05 			VARCHAR(02), 
	IN p_ISA06 			VARCHAR(40), 
	OUT p_TP_QLFR 		VARCHAR(02),
	OUT p_TP_ID 		VARCHAR(40),
	OUT p_ERR_CODE 	BIGINT,
	OUT p_ERR_DESC 	VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=========================================================================
--	DECLERATIOIN OF VARIABLES IN PROCEDURE
--=========================================================================
    DECLARE SQLCODE		INTEGER DEFAULT 0;
	DECLARE  v_SQLCODE 	INTEGER DEFAULT 0;

--=========================================================================
--	SET UP EXIT HANDLER FOR ALL SQL QUERIES
--=========================================================================
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    VALUES (SQLCODE) INTO v_SQLCODE ;
	
	SET p_ERR_DESC = '';
	SET p_ERR_CODE = 0 ;
--=========================================================================
---RETRIEVE DATA FROM TABLE
--=========================================================================
	
	SELECT	TP_ID, TP_QLFR_ID INTO p_TP_ID, p_TP_QLFR
	FROM	EDIDB2A.T_TP 
	WHERE	TP_ID = p_ISA06 AND TP_QLFR_ID = p_ISA05;

	VALUES(SQLCODE) INTO v_SQLCODE ;
	
	IF (v_SQLCODE = 0) THEN	
		--	The Trading Partner is identifed in the TBL_TP Table
		 SET p_TP_QLFR = p_ISA05 ;
		 
	ELSE IF (v_SQLCODE = 100) THEN
		-- search for the Sender Id being present in the TP_XREF Table
		SELECT	TP_ID, TP_QLFR_ID INTO p_TP_ID, p_TP_QLFR
			FROM EDIDB2A.T_TP_XREF 
			WHERE 	ALIAS_TP_ID = p_ISA06 AND ALIAS_TP_QLFR_ID= p_ISA05;
			
		VALUES (SQLCODE) into v_SQLCODE;
		
		IF (v_SQLCODE = 0) THEN
			--	The Trading Partner is identifed in the TBL_XREF Table
			--	Commented this as part of discussions with CHAN on Oct./22/2010
			--  SET p_TP_QLFR = p_ISA05;
			SET p_ERR_CODE = 0;	
		ELSEIF (v_SQLCODE = 100) then
			-- The Trading Partner is not present in Either TBL_TP or TBP_XREF
			SET p_ERR_DESC = 'DB2.SP_VALIDATE_ISA_SENDER_ID::TP NOT FOUND in T_TP or TP_XREF Tables.TP_ID:=' ||
				p_ISA06 || ' TP_QUAL:=' || p_ISA05 || ';';
			SET p_ERR_CODE = 39230001 ;	
		ELSE
			-- Unknown exception occurred while executing the Select on TP_XREF
			SET p_ERR_DESC = 'DB2.SP_VALIDATE_ISA_SENDER_ID::Unknown SQL Exception while selecting from T_XREF for TP_ID:=' || p_ISA06|| ' TP_QUAL:=' || p_ISA05 || ';';
			SET p_ERR_CODE = 39230002 ;
		
		END IF ;
	ELSE
		SET p_ERR_DESC = 'DB2.SP_VALIDATE_ISA_SENDER_ID::Unknown SQL Exception while selecting from T_TP for TP_ID:=' || p_ISA06|| ' TP_QUAL:=' || p_ISA05 || ';';
		SET p_ERR_CODE = 39230003 ;
	END IF ;
END IF ;
END@


--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_VALIDATE_RT_CHANNEL()
-- 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_VALIDATE_RT_CHANNEL')@

CREATE PROCEDURE  EDIDB2A.SP_TP_VALIDATE_RT_CHANNEL
	(
	IN	p_CHANNEL_NAME	VARCHAR(80),	
	IN	p_CHANNEL_TYPE	CHAR(1),
	IN	p_ST01			VARCHAR(4),	
	IN	p_GS08 			VARCHAR(15),
	IN	p_TP_QLFR_ID 	VARCHAR(2),
	IN	p_TP_ID 		VARCHAR(40),	
	OUT p_ERR_CODE 		BIGINT, 	
	OUT p_ERR_DESC 		VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
----DECLERATIOIN OF VARIABLES IN PROCEDURE    
--=============================================================================
    DECLARE SQLCODE	INTEGER DEFAULT 0;
	DECLARE  v_CHANNEL_NAME VARCHAR(80);
	DECLARE  v_SQLCODE INTEGER DEFAULT 0;
    DECLARE  v_ERR_DESC VARCHAR(255) ;
    DECLARE  v_ERR_CODE BIGINT ;
   
--=============================================================================
--	SET UP EXIT HANDLER FOR ALL SQL QUERIES	
--=============================================================================
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	VALUES (SQLCODE) INTO v_SQLCODE ; 
	
   	SET v_ERR_DESC = '';
	SET v_ERR_CODE = 0; 
	
--=============================================================================
---RETRIEVE DATA FROM TABLE
--=============================================================================
	SELECT	CHNL_NME INTO v_CHANNEL_NAME  
	FROM	EDIDB2A.T_TP_CHNL 
	WHERE	TP_ID= p_TP_ID
		AND	TP_QLFR_ID = p_TP_QLFR_ID
		AND	TRAN_VER_NUM = p_GS08
		AND	TRAN_NUM = p_ST01
		AND	CHNL_TYPE_CD = p_CHANNEL_TYPE; 
	
	VALUES (SQLCODE) INTO v_SQLCODE ;
	
	IF (v_SQLCODE = 0) THEN
		IF (v_CHANNEL_NAME <> p_CHANNEL_NAME) THEN
			SET p_ERR_DESC = 'DB2.SP_VALIDATE_RT_CHANNEL::TRANSACTION CHANNEL NAME MISMATCH TP_ID:=' ||p_TP_ID|| ' TP_QUAL:=' || p_TP_QLFR_ID || 'ISA11:=' || p_ST01 || 'ISA12:=' || p_GS08 || 'CHANNEL TYPE:=' || p_CHANNEL_TYPE || 'CHANNEL NAME:=' || p_CHANNEL_NAME || 'IN RECORD NAME:=' ||  v_CHANNEL_NAME   ;
			SET p_ERR_CODE = 39230009 ;
		ELSE
			SET v_ERR_DESC = '';
			SET	v_ERR_CODE = 0; 	
		END IF ;
	
	ELSE IF (v_SQLCODE = 100) THEN
		SET p_ERR_DESC = 'DB2.SP_VALIDATE_RT_CHANNEL::TRANSACTION CHANNEL NOT AUTHORIZED TP_ID:=' ||p_TP_ID|| ' TP_QUAL:=' || p_TP_QLFR_ID || 'ISA11:=' || p_ST01 || 'ISA12:=' || p_GS08 || 'CHANNEL TYPE:=' || p_CHANNEL_TYPE  ;
		SET p_ERR_CODE = 39230010;
	ELSE
		SET p_ERR_DESC = 'DB2.SP_VALIDATE_RT_CHANNEL::Unknown Exception during select on TBL_TP_CHNLS TP_ID:=' ||p_TP_ID|| ' TP_QUAL:=' || p_TP_QLFR_ID || 'ISA11:=' || p_ST01 || 'ISA12:=' || p_GS08 || 'CHANNEL TYPE:=' || p_CHANNEL_TYPE || 'CHANNEL NAME:=' || p_CHANNEL_NAME || 'IN RECORD NAME:=' ||  v_CHANNEL_NAME   ;
		SET p_ERR_CODE = 39230011 ;
	END IF ;
	END IF;
END@

--=============================================================================
--	 Procedure Name: EDIDB2A.SP_TP_VALIDATE()
--	 
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_TP_VALIDATE')@

CREATE PROCEDURE  EDIDB2A.SP_TP_VALIDATE
	(
	IN	p_ISA05			VARCHAR(02), 
	IN	p_ISA06			VARCHAR(40), 
	IN	p_GS01			VARCHAR(15),	
	IN	p_GS02			VARCHAR(15),
	IN	p_GS08 			VARCHAR(15),	
	IN	p_ST01 			VARCHAR(15),
	IN	p_CHANNEL_NAME	VARCHAR(80),
	IN	p_CHANNEL_TYPE	CHAR(1),
	OUT	p_TP_ID_QUAL	VARCHAR(2),
	OUT p_TP_ID 		VARCHAR(40),
	OUT p_ERR_CODE 		BIGINT, 	
	OUT p_ERR_DESC 		VARCHAR(255)
	)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--=============================================================================
----DECLERATIOIN OF VARIABLES IN PROCEDURE    
--=============================================================================
	DECLARE v_TP_QLFR VARCHAR(2) ;
	DECLARE v_TP_ID	VARCHAR(40);

	CALL EDIDB2A.SP_TP_VALIDATE_ISA_SENDER_ID(	p_ISA05,p_ISA06,v_TP_QLFR,v_TP_ID,p_ERR_CODE,p_ERR_DESC);
		
	IF (p_ERR_CODE = 0) THEN
		CALL    EDIDB2A.SP_TP_VALIDATE_GS_SUBMITTER_ID(p_ISA05,p_GS02,v_TP_QLFR ,v_TP_ID,p_ERR_CODE ,p_ERR_DESC);
		
		IF (p_ERR_CODE = 0) then
			CALL	EDIDB2A.SP_TP_VALIDATE_FUNC_GRP_AND_TRANS(p_GS01,p_GS08,p_ST01,v_TP_QLFR,v_TP_ID,p_ERR_CODE,p_ERR_DESC);
			
			IF ( p_ERR_CODE = 0 ) THEN
			  IF (p_CHANNEL_TYPE = 'Q') THEN
				CALL EDIDB2A.SP_TP_VALIDATE_RT_CHANNEL (p_CHANNEL_NAME,p_CHANNEL_TYPE,p_ST01,p_GS08,v_TP_QLFR,v_TP_ID,p_ERR_CODE,p_ERR_DESC);
			  END IF ;
		    END IF;
			SET p_TP_ID_QUAL = v_TP_QLFR;
			SET p_TP_ID = v_TP_ID;
		END IF;
		SET p_TP_ID_QUAL = v_TP_QLFR;
		SET p_TP_ID = v_TP_ID;
	END IF;
END@