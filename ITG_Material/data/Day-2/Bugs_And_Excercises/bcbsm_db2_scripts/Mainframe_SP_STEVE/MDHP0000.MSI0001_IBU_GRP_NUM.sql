
DROP PROCEDURE MDHP0000.MSI0001_IBU_GRP_NUM@

CREATE PROCEDURE MDHP0000.MSI0001_IBU_GRP_NUM(
	
	IN  p_MONT_QUE_RULE_NME    CHAR(35),
	OUT p_ERR_CODE 		INTEGER,
	OUT p_ERR_DESC 		VARCHAR(255))

  LANGUAGE SQL
  EXTERNAL NAME MSI0001   
  STAY RESIDENT YES
  MODIFIES SQL DATA

BEGIN
--=============================================================================
--	Declaration of variables
--=============================================================================

    DECLARE SQLCODE	                 INTEGER DEFAULT 000;
    DECLARE v_sqlcode 	    		INTEGER;
	DECLARE v_MONT_QUE_RULE_NUM      SMALLINT ;

	
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================
	
DECLARE EXIT HANDLER FOR SQLEXCEPTION

VALUES (sqlcode) INTO v_sqlcode;


-- ============================================================================
-- Retrieving the PARM code from table 
--=============================================================================
	
		SELECT MONT_QUE_RULE_NME INTO p_MONT_QUE_RULE_NME                         
           FROM MDHP0000.MTHP0900_MONT_PARM                  
             WHERE MONT_QUE_RULE_NUM BETWEEN 1300 AND 1500 
                          AND 
               MONT_QUE_RULE_NME = p_MONT_QUE_RULE_NME ;

              SET v_sqlcode =SQLCODE;
-- ============================================================================
-- check the sql code and set the error description 
--=============================================================================
              IF (v_sqlcode = 0) THEN 
              
	              SET p_ERR_CODE = v_sqlcode ;
                  SET p_ERR_DESC ='row found' ;
                  
              ELSE 
                  SET p_ERR_CODE = v_sqlcode ;
                  SET p_ERR_DESC ='row not found' ;
              END IF ; 
	END@

