
DROP PROCEDURE MDHP0000.MSI0112_SP_835_URI_LKP@

CREATE PROCEDURE MDHP0000.MSI0112_SP_835_URI_LKP
(IN p_PROV_NUM CHAR(30) , 
IN p_PROV_TYPE_CODE CHAR(03), 
IN p_SRC_PMT_CODE CHAR(02) ,
OUT p_sqlcode INTEGER,
OUT p_RECV_ID_NUM CHAR(15) 
)
LANGUAGE SQL
EXTERNAL NAME MSI0112  
STAY RESIDENT YES 
MODIFIES SQL DATA
LANGUAGE SQL
BEGIN

DECLARE SQLCODE		INTEGER DEFAULT 000;
--=============================================================================
--	Setup the EXIT Handle to handle any SQL Exceptions
--=============================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION 
VALUES (SQLCODE) INTO p_sqlcode ;                                   
--=============================================================================
--	Retrieve the Reciver Id num from the table MTHP0080_PROV_SOP
--=============================================================================
     
 SELECT RECV_ID_NUM INTO p_RECV_ID_NUM
        FROM MDHP0000.MTHP0080_PROV_SOP                        
        WHERE PROV_NUM       = p_PROV_NUM      
        AND PROV_TYPE_CODE = p_PROV_TYPE_CODE
        AND SRC_PMT_CODE   = p_SRC_PMT_CODE 
        AND DEL_IND = 'N' ;  
--=============================================================================
--	Set the SQLCODE into the variable
--=============================================================================                     
        SET p_sqlcode= SQLCODE ;           
END@

