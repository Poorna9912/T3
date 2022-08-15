--=======================================================================
--	Author:	Nanaji Veturi
--	Date:	Feb/08/2010
--	Description:
--	This Stored Procedure is used to determines providers to submit with data with
--      their  NPI or not. The date that at which all data submitted must contain an NPI.
--	Version: $VERSION$
--=======================================================================

--==========================================================
-- Drop Procedure PDNP0000.NPI_REF If exists 
--==========================================================

CREATE PROCEDURE PDNP0000.NPI_REF
(IN p_system_id_cd CHAR(8),
IN p_ref_cd CHAR(8),
IN p_ctrl_parm_cd CHAR(8),
OUT p_sqlcode INTEGER)

LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
--==========================================================
-- Declaration of variables in the Procedure
--==========================================================
DECLARE v_ref_dsc_text CHAR(80);
DECLARE SQLCODE  INTEGER DEFAULT 000;
--==========================================================
-- Setup the EXIT Handle to handle any SQL Exceptions
--==========================================================
DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (SQLCODE) INTO p_sqlcode;
--==========================================================
--	Retrieve the  NPI enforcement date from Database  
--==========================================================
SELECT REF_DSC_TEXT INTO v_ref_dsc_text
FROM PDNP0000.PTNP0020_NPI_REF
WHERE SYSTEM_ID_CD = p_system_id_cd
AND REF_CD = p_ref_cd
AND CTRL_PARM_CD = p_ctrl_parm_cd
AND EFF_BG_DATE  <=  CURRENT_DATE
AND EFF_END_DATE >=  CURRENT_DATE
AND (SUBSTR (REF_DSC_TEXT, 1, 10)  <= CHAR(CURRENT_DATE,ISO))
AND (SUBSTR (REF_DSC_TEXT, 1, 10))  > ' ' 
FETCH FIRST 1 ROWS ONLY WITH UR;
--==========================================================
-- Place the Value of Sqlcode into the variable p_sqlcode 
--==========================================================
VALUES (SQLCODE) INTO p_sqlcode;
END

