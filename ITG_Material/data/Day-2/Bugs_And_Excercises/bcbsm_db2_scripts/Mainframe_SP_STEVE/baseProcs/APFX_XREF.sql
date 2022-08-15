--======================================================================
--	Author: Nanaji Veturi
--	Date:	Feb/08/2010
--	Description: This Stored Procedure for determining 
--    alpha-prefix value is a Michigan or an out-of-state (BXHOST).
--	Version: $VERSION$
--======================================================================
--======================================================================
--	Create procedure MDHP0000.APFX_XREF
--======================================================================
	
DROP PROCEDURE MDHP0000.APFX_XREF
@
CREATE PROCEDURE MDHP0000.APFX_XREF
(
	IN p_alpha_pfx 		CHAR(3),
	IN p_rcp_incr_st_dt 	DATE,
	IN p_rcp_incr_end_dt  	DATE,
	IN p_clm_type  		CHAR(2),
	OUT p_sqlcode  		INTEGER,
	OUT p_contact  		CHAR(10)
)

LANGUAGE SQL
EXTERNAL NAME APFXXREF
MODIFIES SQL DATA

BEGIN
--======================================================================
--	Declaration of variables in the Procedure
--======================================================================

DECLARE v_proc_site_plan_cd 	CHAR(3);
DECLARE SQLCODE			INTEGER DEFAULT 000;

--======================================================================
--	Setup the EXIT handler for all SQL exceptions
--======================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (SQLCODE) INTO p_sqlcode;
     
--======================================================================
--	Retrieve the PROC_SITE_PLAN_CD
--======================================================================

SELECT PROC_SITE_PLAN_CD
INTO v_proc_site_plan_cd
FROM MDHP0000.MTHP0460_APFX_XREF
WHERE ALPHA_PFX = p_alpha_pfx AND CLM_TYPE = p_clm_type
AND RCP_INCR_ST_DT <= p_rcp_incr_st_dt
AND RCP_INCR_END_DT >= p_rcp_incr_end_dt FETCH FIRST 1 ROWS ONLY WITH UR;

--======================================================================
--	Place the value of SQLCODE into the variable p_sqlcode  
--======================================================================

VALUES (SQLCODE) INTO p_sqlcode;

--======================================================================
--	Based on PROC_SITE_PLAN_CD value determine whether the 
--	contract is MICHIGAN or BXHOST 
--======================================================================

IF (v_proc_site_plan_cd) IS NULL THEN 
	 SET p_contact  ='UNROUTABLE';

ELSEIF  (v_proc_site_plan_cd='210' OR v_proc_site_plan_cd='215' OR 
	v_proc_site_plan_cd='710') THEN 
    	SET p_contact  ='MICHIGAN';

ELSE
     SET p_contact ='BXHOST';

END IF ;

END
@
