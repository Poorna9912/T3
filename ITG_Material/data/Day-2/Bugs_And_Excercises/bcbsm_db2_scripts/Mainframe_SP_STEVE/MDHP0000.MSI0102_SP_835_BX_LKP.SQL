
DROP PROCEDURE MDHP0000.MSI0102_SP_835_BX_LKP@

CREATE PROCEDURE MDHP0000.MSI0102_SP_835_BX_LKP
(IN p_PROV_ID VARCHAR(10) , 
IN p_PROV_ID_IND VARCHAR(02), 
OUT p_sqlcode INTEGER,
OUT p_TRAN_VER VARCHAR(12) 
)
LANGUAGE SQL
EXTERNAL NAME MSI0102   
STAY RESIDENT YES 
MODIFIES SQL DATA

BEGIN

DECLARE SQLCODE			INTEGER DEFAULT 000;
 --============================================================================
--	Setup the EXIT Handle to handle any SQL Exceptions
 --============================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION 
VALUES (SQLCODE) INTO p_sqlcode ;                                   
--=============================================================================
--	Retrieve the HIPPA_VERSION from the table MTHP0450_MCAR_XREF
--=============================================================================
     
 SELECT HIPAA_VERSION INTO p_TRAN_VER
        FROM MDHP0000.MTHP0450_MCAR_XREF                        
        WHERE PROV_ID_IND  = p_PROV_ID_IND     
        AND PROV_ID = p_PROV_ID ;
--=============================================================================
--	Set the SQLCODE into the variable
--=============================================================================                     
        SET p_sqlcode= SQLCODE ;           
END@

