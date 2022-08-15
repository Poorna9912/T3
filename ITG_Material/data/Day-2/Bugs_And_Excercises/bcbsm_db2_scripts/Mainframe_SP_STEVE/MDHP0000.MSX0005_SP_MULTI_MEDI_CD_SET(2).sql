DROP PROCEDURE MDHP0000.MSX0005_SP_MULTI_MEDI_CD_SET@

CREATE PROCEDURE MDHP0000.MSX0005_SP_MULTI_MEDI_CD_SET (
    IN P_STRING	VARCHAR(1000),
    IN P_DELIMITER	VARCHAR(1),
    IN P_TERMINATOR	VARCHAR(1),
    IN P_SRVT0DT	VARCHAR(10),
    IN P_SRVFRMDT	VARCHAR(10),
    OUT P_ERROR_CODE	BIGINT,
    OUT P_RESULT_SET	VARCHAR(500) )
LANGUAGE SQL
EXTERNAL NAME MSX0005  
STAY RESIDENT YES 
MODIFIES SQL DATA
LANGUAGE SQL
BEGIN
DECLARE v_string VARCHAR(1000);
DECLARE v_rstring VARCHAR(1000);
DECLARE v_fdel VARCHAR(1);
DECLARE v_fsep VARCHAR(1);
DECLARE v_substring VARCHAR(50);
DECLARE v_substring1 VARCHAR(50);
DECLARE v_substring2 VARCHAR(50) ;
DECLARE v_substring3 VARCHAR(50) ;
DECLARE v_stringlength INT;
DECLARE v_firststring VARCHAR(50);
DECLARE v_secondstring VARCHAR(50);
DECLARE v_thirdstring VARCHAR(50);
DECLARE v_m INT DEFAULT 1;
DECLARE v_n INT;
DECLARE v_valid_switch char(1) ;
DECLARE v_db2_err_switch char(1); 
--DECLARE v_count INT default 0 ;
DECLARE v_result_set VARCHAR(500) DEFAULT '';
DECLARE v_MCS_MED_CD VARCHAR(30);
DECLARE v_flag INTEGER DEFAULT 0;
DECLARE v_sqlcode INTEGER ;
DECLARE SQLCODE INTEGER DEFAULT 0;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES(SQLCODE) INTO v_sqlcode;

-- ===========================================================
-- ASSIGNING GLOBAL VARIABLES TO LOCAL VARIABLES
-- ===========================================================

SET v_string=P_STRING;
SET v_fdel=P_TERMINATOR;
SET v_fsep=P_DELIMITER;
-- ============================================================
-- TO FIND THE NUMBER OF FIELD TERMINATORS
-- ============================================================

SET v_rstring = REPLACE(v_string,v_fdel,'');
SET v_n = LENGTH(v_string) - LENGTH(v_rstring);
-- ==============================================================
-- REPEAT LOOP FOR 'n' NUMBER OF OCCURENCES OF FIELD ELEMINATOR
-- ==============================================================

WHILE (v_m <= v_n AND v_flag = 0)
	DO
	SET v_substring=SUBSTR(v_string,1,(LOCATE(v_fdel,v_string))-1);--
	SET v_firststring=SUBSTR(v_substring,1,(LOCATE(v_fsep,v_substring)-1));
	SET v_stringlength=LENGTH(v_firststring);
	SET v_substring1=SUBSTR(v_substring,v_stringlength+2);
	SET v_secondstring =SUBSTR(v_substring1,1,(LOCATE(v_fsep,v_substring1)-1));
	SET v_stringlength=LENGTH(v_secondstring);
	SET v_substring2=SUBSTR(v_substring1,v_stringlength+2);
	
	-- =================================================================
	-- checking the medical code set values in the database
	-- ================================================================
	
	CALL MDHP0000.MSX0004_SP_MCS_MEDI_CODE_SET_VALID(v_secondstring,v_firststring,date( substr(v_substring2,5,2) || '/' || substr(v_substring2,7,2) || '/' || substr(v_substring2,1,4) ),date( substr(P_SRVT0DT,5,2) || '/' || substr(P_SRVT0DT,7,2) || '/' || substr(P_SRVT0DT,1,4) ),date( substr(P_SRVFRMDT,5,2) || '/' || substr(P_SRVFRMDT,7,2) || '/' || substr(P_SRVFRMDT,1,4) ),v_valid_switch,v_db2_err_switch,v_sqlcode) ;
	
	IF (v_db2_err_switch <> 'N') THEN
		IF (v_valid_switch ='N') THEN 
		SET P_ERROR_CODE =32010099; 
		SET v_result_set = 'INVALID' ;
		SET v_flag = 1 ; 
		ELSE 
		SET P_ERROR_CODE =00000000; 
		SET v_result_set =  'VALID' ;
		END IF  ;
	ELSE 
		SET P_ERROR_CODE =3204004;
		SET v_result_set =  'INVALID' ;  
		SET v_flag = 1 ; 
	END IF ;  
	
	SET v_m = v_m + 1;
END WHILE;--

SET P_RESULT_SET = v_result_set;

END

