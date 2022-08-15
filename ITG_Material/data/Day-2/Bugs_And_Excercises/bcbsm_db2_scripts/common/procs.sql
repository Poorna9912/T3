--=============================================================================
--	Procedure:	EDIDB2A.SP_EDDI_REQ
--	Description:
--	Author:	
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_EDDI_REQ')@


CREATE PROCEDURE EDIDB2A.SP_EDDI_REQ
( IN p_TRANS_TYPE VARCHAR(10),
  IN p_RCD_TYPE  VARCHAR(3),
  OUT p_FILE_ID BIGINT, 
  OUT p_FILE_TYPE_CD CHAR(1),
  OUT p_FILE_NAME VARCHAR(60),
  OUT p_ERR_CODE BIGINT,
  OUT p_ERR_DESC VARCHAR(255)) 
  
  LANGUAGE SQL 

BEGIN
  DECLARE v_FILE_TYPE_CD CHAR(1);
  DECLARE v_file_name varchar(255);
  DECLARE SQLCODE INTEGER DEFAULT 0;
  DECLARE v_sqlcode INTEGER; 
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  VALUES (SQLCODE) INTO v_sqlcode;
  
select FILE_TYPE_CD into v_FILE_TYPE_CD from EDIDB2A.T_LKP_FILE_TYPE where SHORT_DSC = p_TRANS_TYPE;
 VALUES (SQLCODE) INTO v_sqlcode; 
  IF (v_sqlcode = 0) THEN
     
     set p_FILE_TYPE_CD = v_FILE_TYPE_CD; 

     select FILE_ID,FILE_NAME into p_FILE_ID,p_FILE_NAME from EDIDB2A.T_EDDI_FILES where FILE_TYPE=v_FILE_TYPE_CD AND STU_CD = 'O';
     VALUES (SQLCODE) INTO v_sqlcode;

        if (v_sqlcode <> 0) then
            insert into EDIDB2A.T_EDDI_FILES (FILE_TYPE,STU_CD,CREA_TS,TRA_FLAG) values(v_FILE_TYPE_CD,'O',current_timestamp,'E');

            set p_FILE_ID = IDENTITY_VAL_LOCAL();
            set v_file_name = RTRIM(char(p_FILE_ID)) || '.' || p_TRANS_TYPE ||  '.' || p_RCD_TYPE; 
            set p_FILE_NAME = v_file_name;
 
            update EDIDB2A.T_EDDI_FILES set FILE_NAME=v_file_name where FILE_ID = p_FILE_ID;
        end if;
  ELSE
     SET p_ERR_CODE = v_sqlcode;
  END IF; 
END@
