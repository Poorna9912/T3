--======================================================================
--	Author: Nanaji Veturi
--	Date:	Feb/08/2010
--	Description:
--	This stored procedure is used to determine if a typical provider
--	submits with a valid NPI data vlaue or not NPI value must be
--	present on all data submitted. 
--	Version: $VERSION$
--======================================================================

--======================================================================
-- Drop Procedure PDNP0000.NPI_ATY_PROV If exists 
--======================================================================


CREATE PROCEDURE PDNP0000.NPI_ATY_PROV
(
	IN p_system_id_cd		CHAR(8),
	IN p_ref_cd 		CHAR(8),
	IN p_ctrl_parm_cd		CHAR(8),
	OUT p_sqlcode 		INTEGER
)

LANGUAGE SQL
EXTERNAL NAME NPIPROV
MODIFIES SQL DATA

BEGIN
--======================================================================
-- Declaration of variables in the Procedure
--======================================================================


DECLARE v_ref_cd_con 		CHAR(8);
DECLARE v_ref_dsc_text 		CHAR(80);
DECLARE SQLCODE			INTEGER DEFAULT 000;

--======================================================================
-- Setup the EXIT handler for all SQL Exceptions
--======================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (SQLCODE) INTO p_sqlcode;

--======================================================================
--	Concat Ref_cd with a string  ATYP 
--======================================================================

SET v_ref_cd_con = CONCAT('ATYP',p_ref_cd);

--======================================================================
--	Retrieve the  NPI enforcement date from datebase  
--======================================================================

SELECT REF_DSC_TEXT
INTO v_ref_dsc_text
FROM PDNP0000.PTNP0020_NPI_REF
WHERE SYSTEM_ID_CD = p_system_id_cd
AND REF_CD = v_ref_cd_con
AND CTRL_PARM_CD = p_ctrl_parm_cd
AND EFF_BG_DATE  <=  CURRENT_DATE
AND EFF_END_DATE >=  CURRENT_DATE FETCH FIRST 1 ROWS ONLY  WITH UR;

--======================================================================
-- Place the Value of SQLCODE into the variable p_sqlcode 
--======================================================================

VALUES (SQLCODE) INTO p_sqlcode;

END
