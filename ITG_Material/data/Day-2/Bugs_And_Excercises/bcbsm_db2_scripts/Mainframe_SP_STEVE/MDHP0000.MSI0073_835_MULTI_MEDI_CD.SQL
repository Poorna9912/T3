
DROP PROCEDURE MDHP0000.MSI0073_835_MULTI_MEDI_CD@

CREATE PROCEDURE MDHP0000.MSI0073_835_MULTI_MEDI_CD
( IN p_inputstring VARCHAR(5000),
IN p_fseperator VARCHAR(1),
IN p_feleminator VARCHAR(1),
IN p_mcs_type_cd VARCHAR(2),
OUT p_error_code INTEGER ,
OUT p_result_set VARCHAR (3000))

LANGUAGE SQL
EXTERNAL NAME MSI0073   
STAY RESIDENT YES 
MODIFIES SQL DATA
BEGIN
--=============================================================================
-- DECLARATION OF A VARIABLES 
--=============================================================================
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
DECLARE v_result_set VARCHAR(3000) ;
DECLARE v_mcs_med_cd VARCHAR(30);
DECLARE v_flag INTEGER ;
DECLARE v_sqlcode INTEGER ;
DECLARE SQLCODE INTEGER DEFAULT 000;

DECLARE EXIT HANDLER FOR SQLEXCEPTION

SET v_sqlcode = SQLCODE;--

--=============================================================================
-- ASSIGNING GLOBAL VARIABLES TO LOCAL VARIABLES
--=============================================================================
SET v_string = p_inputstring;
SET v_felm=p_feleminator;
SET v_fsep=p_fseperator;
SET v_m=1;
SET v_result_set='';
--=============================================================================
-- TO FIND THE NUMBER OF FIELD ELEMINATORS
--=============================================================================

SET v_rstring = REPLACE(v_string,v_felm,'');
SET v_n=(LENGTH(v_string) - LENGTH(v_rstring));

--=============================================================================
-- REPEAT LOOP FOR 'n' NUMBER OF OCCURENCES OF FIELD ELEMINATOR
--=============================================================================

WHILE (v_m <= v_n)

DO

SET v_substring=SUBSTR(v_string,1,(LOCATE(v_felm,v_string)-1));

SET v_firststring=SUBSTR(v_substring,1,(LOCATE(v_fsep,v_substring)-1));

SET v_stringlength=LENGTH(v_firststring);--

SET v_substring1=SUBSTR(v_substring,v_stringlength+2);

SET v_secondstring =SUBSTR(v_substring1,1,(LOCATE(v_fsep,v_substring1)-1));

SET v_stringlength=LENGTH(v_secondstring);

SET v_substring2=SUBSTR(v_substring1,v_stringlength+2);

SET v_thirdstring=SUBSTR(v_substring2,1,(LOCATE(v_fsep,v_substring2)-1));

SET v_stringlength=LENGTH(v_thirdstring);

SET v_substring3=SUBSTR(v_substring2,v_stringlength+2);

--=============================================================================
-- checking the medical code set values in the database
--=============================================================================

CALL MDHP0000.MSI0093_SP_835_MEDI_CD_SET(v_secondstring,'MO',v_thirdstring,v_substring3,v_sqlcode) ;

IF (v_sqlcode=0) THEN
     SET v_result_set =v_result_set || v_firststring ||'*'|| 'VALID' || '~' ;
  ELSE 
  SET v_result_set = v_result_set ||v_firststring ||'*' ||'INVALID' || '~' ;
 
END IF ;
 
SET v_stringlength=LENGTH(v_substring);
SET v_string=SUBSTR(v_string,v_stringlength+2);
SET v_m=v_m+1;

END WHILE ;

SET p_result_set = v_result_set ;
SET p_error_code = v_sqlcode ; 

END@