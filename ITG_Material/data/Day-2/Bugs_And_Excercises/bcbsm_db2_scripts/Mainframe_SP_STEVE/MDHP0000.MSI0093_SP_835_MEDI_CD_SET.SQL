DROP PROCEDURE MDHP0000.MSI0093_SP_835_MEDI_CD_SET@
CREATE PROCEDURE MDHP0000.MSI0093_SP_835_MEDI_CD_SET (
    IN P_MCS_MED_CD	CHARACTER(48),
    IN P_MCS_TYPE_CD	CHARACTER(2),
    IN P_MCS_EFF_DT	DATE,
    IN P_MCS_TRM_DT	DATE,
    OUT P_SQLCODE	INTEGER
    )
  LANGUAGE SQL
EXTERNAL NAME MSI0093   
STAY RESIDENT YES 
MODIFIES SQL DATA
BEGIN

--=============================================================================
--	Declaration of variables in the Procedure
--=============================================================================

DECLARE v_mcs_grac_prd_dt 	DATE;
DECLARE SQLCODE				INTEGER DEFAULT 000;

--=============================================================================
--	Setup the EXIT Handle for all SQL Exceptions
--=============================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION

VALUES(SQLCODE) INTO p_sqlcode;

--=============================================================================
--	Checks if Medical Code Type is 'RC' or 'HC' or 'MO' or 'AD' or
--	'IP' or 'ID' are present in the database
--=============================================================================

	IF (p_mcs_type_cd ='MO') THEN

--=============================================================================
--	Retrieve the  maximum of MCS_TRM_DT(date) from Database
--=============================================================================

		SELECT (MCS_GRAC_PRD_DT) 

		INTO v_mcs_grac_prd_dt

		FROM MDHP0000.MTHP0300_MCS_CODE                         

		WHERE 

		MCS_TYPE_CD      			= p_mcs_type_cd

		AND MCS_EFF_DT      	<= p_mcs_eff_dt

		AND MCS_DEL_IND 			= 'N'

		AND MCS_GRAC_PRD_DT 	>= p_mcs_trm_dt

		FETCH FIRST 1 ROWS ONLY WITH UR;

--=============================================================================
--	Place the Value of Sqlcode retreived into the variable p_sqlcode
--=============================================================================
		SET p_sqlcode = SQLCODE;

	END IF;

END@