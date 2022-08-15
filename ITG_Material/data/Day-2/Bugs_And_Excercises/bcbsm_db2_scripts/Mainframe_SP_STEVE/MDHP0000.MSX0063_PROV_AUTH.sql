--======================================================================
--	Author: Nanaji Veeturi
--	Date:	07/01/2010
--	SP NAME:	MDHP0000.MSX00063_PROV_AUTH
--	Description: This Stored Procedure is used to check if a Provider
--	is already authenticated by BCBSM. Multiple records for the
--	provider will exist and this is specific to 837 Batch Process.
--	Version: $VERSION$
--======================================================================

CREATE PROCEDURE MDHP0000.MSX00063_PROV_AUTH (
 IN	p_prov_num			CHAR(30),
 IN	p_prov_type_code	CHAR(3),
 IN	p_subm_id_num		CHAR(15),
 IN	p_src_pmt_code		CHAR(2),
 OUT	p_sqlcode			INTEGER ,
 OUT p_errcode		 	INTEGER,
 OUT p_errdesc		    VARCHAR(120)
)
LANGUAGE SQL
EXTERNAL NAME MSX0063
STAY RESIDENT YES
MODIFIES SQL DATA
BEGIN

DECLARE v_emp_user_id_num 	CHAR(8);
DECLARE SQLCODE			INTEGER DEFAULT 000;

--======================================================================
--	Setup the EXIT Handle to handle any SQL Exceptions
--======================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (SQLCODE) INTO p_sqlcode ;

--======================================================================
--	Check if the line of Business is 'Professional'
--======================================================================

IF(p_prov_type_code = 'PRO') THEN
 IF (p_src_pmt_code IN ('BL','CI','HM')) THEN

  SELECT EMP_USER_ID_NUM
  	INTO v_emp_user_id_num
  	FROM MDHP0000.MTHP0030_PROV_AUTH
     WHERE PROV_NUM = p_prov_num
  	AND PROV_TYPE_CODE = p_prov_type_code
  	AND SUBM_ID_NUM  = p_subm_id_num
  	AND SRC_PMT_CODE = p_src_pmt_code
  	AND AUTH_DEL_IND = 'N' ;
  	
  	SET p_sqlcode= SQLCODE ;
  	
 ELSEIF (p_src_pmt_code IN ('FI','MD','MW')) THEN

   SET p_src_pmt_code = 'BL';
   SELECT EMP_USER_ID_NUM
  INTO v_emp_user_id_num
  FROM MDHP0000.MTHP0030_PROV_AUTH
      WHERE PROV_NUM         = p_prov_num
  AND PROV_TYPE_CODE   = p_prov_type_code
  AND SUBM_ID_NUM      = p_subm_id_num
  AND SRC_PMT_CODE     = p_src_pmt_code
  AND AUTH_DEL_IND     = 'N';

  SET p_sqlcode= SQLCODE ;

    ELSEIF(p_src_pmt_code = 'MB') THEN
    --	We want to handle this case as the same as Record not found
    --	so just set the p_sqlcode and let the logic be executed there
       SET p_sqlcode= 100;
       -- go to the IF p_SQLCODE = 100) then Logic

 ELSE
 --	Return an Error as the SOP is not handled by the Logic
   SET p_errcode =39935010;
   SET p_errdesc = 'Unhandled Source of Payment(SOP) for Professional
       Type Provider:' || p_src_pmt_code;
 END IF;
--======================================================================
--	If any of the SQL Statements failed in terms of Finding a Record
--  Then Perform the Following Logic
--======================================================================

 IF( p_sqlcode = 100 ) THEN
  SET p_src_pmt_code = 'MB';
  SELECT EMP_USER_ID_NUM
   INTO v_emp_user_id_num
  FROM MDHP0000.MTHP0030_PROV_AUTH
  WHERE PROV_NUM         = p_prov_num
   AND PROV_TYPE_CODE   = p_prov_type_code
   AND SRC_PMT_CODE     = p_src_pmt_code
   AND AUTH_DEL_IND     = 'N';

  SET p_sqlcode= SQLCODE ;
  IF (p_sqlcode = 100) THEN
  --	Return an Error as the Record was not Found in Even the Worst case
  SET p_errcode =39935015;
  SET p_errdesc = 'Record Not Found for SOP = MB:  and PROV_NUM='
  || p_prov_num;
  END IF;
 END IF;

--======================================================================
--	Check if the line of Business is 'Institutional'
--======================================================================
ELSEIF (p_prov_type_code = 'INS') THEN

 IF (p_src_pmt_code = 'MD') THEN

 SET p_src_pmt_code = 'BL';

  SELECT EMP_USER_ID_NUM
    INTO v_emp_user_id_num
    FROM MDHP0000.MTHP0030_PROV_AUTH
  WHERE PROV_NUM        = p_prov_num
    AND PROV_TYPE_CODE   = p_prov_type_code
    AND SRC_PMT_CODE     = p_src_pmt_code
    AND AUTH_DEL_IND     = 'N';

    SET p_sqlcode= SQLCODE ;

 ELSEIF (p_src_pmt_code = 'MA') THEN
    --	We want to handle this case as the same as Record not found
    --	so just set the p_sqlcode and let the logic be executed there
       SET p_sqlcode= 100;
       -- go to the IF p_SQLCODE = 100) then Logic
    ELSE
 --	Return an Error as the SOP is not handled by the Logic
 SET p_errcode = 39935030;
 SET p_errdesc = 'Unhandled Source of Payment(SOP) for Institutional Type Provid
er:'
        || p_src_pmt_code;

 END IF;

--======================================================================
--	If any of the SQL Statements failed in terms of Finding a Record
--  Then Perform the Following Logic
--======================================================================

 IF (p_sqlcode = 100) THEN
  SET p_src_pmt_code = 'MA';
  SELECT EMP_USER_ID_NUM
    INTO v_emp_user_id_num
    FROM MDHP0000.MTHP0030_PROV_AUTH
  WHERE PROV_NUM         		= p_prov_num
       AND PROV_TYPE_CODE   	= p_prov_type_code
    AND SRC_PMT_CODE    	= p_src_pmt_code
    AND AUTH_DEL_IND     	= 'N';

   SET p_sqlcode= SQLCODE ;

 IF (p_sqlcode = 100) then
 --	Return an Error as the Record was not Found in Even the Worst case
 SET p_errcode =39935015;
 SET p_errdesc = 'Record Not Found for SOP = MA and PROV_NUM=:'
 || p_prov_num;
  END IF ;

 END IF;
ELSE
	--	Return an Error as the Provider Type Code / Line of Business is Invalid
SET p_errcode =39935090;
SET p_errdesc = 'Invalid Provider Type Code(LOB):' || p_prov_type_code;
END IF;

END
