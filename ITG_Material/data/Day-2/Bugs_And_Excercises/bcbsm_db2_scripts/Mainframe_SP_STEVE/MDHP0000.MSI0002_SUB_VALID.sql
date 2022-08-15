
DROP PROCEDURE MDHP0000.MSI0002_SUB_VALID@

CREATE PROCEDURE MDHP0000.MSI0002_SUB_VALID 
(IN p_ISA06 VARCHAR(15),
 OUT p_ERR_CODE 		INTEGER,
 OUT p_ERR_DESC 		VARCHAR(255))


LANGUAGE SQL
EXTERNAL NAME MSI0002   
STAY RESIDENT YES 
MODIFIES SQL DATA
BEGIN
    DECLARE SQLCODE	            INTEGER DEFAULT 000;
	DECLARE v_sqlcode 			INTEGER;
    DECLARE v_sub_id_num        VARCHAR(15);
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION

VALUES (SQLCODE) INTO v_sqlcode;
--=============================================================================
--checking the submitters are allowed to submit the transactions to BCBSM
-- if submitter ID is found in the database then he is eligible to submit the 
-- transaction
--=============================================================================
	SELECT SUBM_ID_NUM           
       INTO v_sub_id_num              
       FROM MDHP0000.MTHP0020_SUBMITTER        
      WHERE SUBM_ID_NUM  = p_ISA06 
        AND PROV_DEL_IND = 'N'                 
     WITH UR ;          	
	SET v_sqlcode =SQLCODE;
	
	--	Handle the case of No Data Found
			
	  IF (v_sqlcode = 0) THEN 
              
	     SET p_ERR_CODE = v_sqlcode ;
         SET p_ERR_DESC ='row found' ;
            
      ELSE 
          SET p_ERR_CODE = v_sqlcode ;
          SET p_ERR_DESC ='row not found' ;
      END IF ; 
END@

