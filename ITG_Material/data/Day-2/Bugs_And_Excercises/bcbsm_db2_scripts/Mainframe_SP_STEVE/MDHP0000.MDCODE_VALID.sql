DROP PROCEDURE MDHP0000.MDCODE_VALID
@
CREATE PROCEDURE MDHP0000.MDCODE_VALID( IN P_STRING VARCHAR(5000),IN P_FSEPERATOR VARCHAR(1),IN P_FELEMINATOR VARCHAR(1),OUT P_RESULT_SET VARCHAR (1000))

BEGIN
DECLARE v_string VARCHAR(5000);
DECLARE v_rstring VARCHAR(5000);
DECLARE v_felm VARCHAR(1);
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
--DECLARE v_count INT default 0 ;
DECLARE v_result_set VARCHAR(500) DEFAULT ' ';
DECLARE v_MCS_MED_CD VARCHAR(30);
DECLARE p_sqlcode INTEGER ;
DECLARE SQLCODE	INTEGER DEFAULT 000;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
SET p_sqlcode = SQLCODE;
-- ===========================================================
--      ASSIGNING GLOBAL VARIABLES TO LOCAL VARIABLES
-- ===========================================================

SET v_string=P_STRING;
SET v_felm=P_FELEMINATOR;
SET v_fsep=P_FSEPERATOR;

-- ============================================================
--   TO FIND THE NUMBER OF FIELD ELEMINATORS   
-- ============================================================

SET v_rstring = REPLACE(v_string,v_felm, '');

SET v_n=(LENGTH(v_string) - LENGTH(v_rstring));
-- ==============================================================
--   REPEAT LOOP FOR 'n' NUMBER OF OCCURENCES OF FIELD ELEMINATOR
-- ==============================================================
WHILE (v_m <= v_n)
DO
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



-- =================================================================
-- checking the medical code set values in the database  
-- ================================================================
SELECT	MCS_MED_CD	INTO 	v_MCS_MED_CD
FROM 	MDHP0000.MTHP0300_MCS_CODE
WHERE	MCS_MED_CD		=	v_firststring
AND 	MCS_EFF_DT 		<=	date(v_secondstring)
AND 	MCS_TRM_DT		>= 	date(v_thirdstring)

FETCH FIRST 1 ROWS ONLY WITH UR;

SET p_sqlcode = SQLCODE;

IF (p_sqlcode = 0)then 
	SET v_result_set = (v_result_set||v_firststring||','||'000'||v_substring3 ||'~') ;
else 
	SET v_result_set = (v_result_set||v_firststring||','||'100' || v_substring3 || '~') ;
END IF ;
-- SET v_count = v_count + 1;
SET v_stringlength=LENGTH(v_substring);
SET v_string=SUBSTR(v_string,v_stringlength+2);
SET v_m = v_m + 1;
END WHILE;
--SET P_COUNT=v_count ;
SET p_result_set = v_result_set;
END
@
