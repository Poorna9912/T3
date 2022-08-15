-- ============================================================================
--	Author: Nanaji Veturi	
--	Date:06/17/2010
--	Description:The purpose of this stored procedure to if the alpha prefix is
--  a Michigan  or out of state (BX HOST) alpha prefix.
--	Version: $VERSION$
--=============================================================================

--=============================================================================
--	Create procedure APFX_XREF
--=============================================================================

DROP PROCEDURE MDHP0000.APFX_XREF
@
CREATE PROCEDURE MDHP0000.APFX_XREF
	(IN p_alpha_pfx 		CHAR(3),
	IN p_rcp_incr_st_dt 	DATE, 
	IN p_rcp_incr_end_dt 	DATE, 
	IN p_clm_type 			CHAR(2), 
	OUT p_proc_ind 			CHAR(2), 
	OUT p_ctrl_plan_cd 		CHAR(3), 
	OUT p_proc_ind_desc_txt VARCHAR(50), 
	OUT p_status 			VARCHAR(50), 
	OUT p_status_sqlcode 	INTEGER, 
	OUT p_error_desc 		VARCHAR(30))

LANGUAGE SQL
MODIFIES SQL DATA
	
BEGIN 
--=============================================================================
--	Declaration of variables in the Procedure
--=============================================================================
DECLARE v_proc_ind CHAR(2) ;
DECLARE v_ctrl_plan_cd CHAR(3);
DECLARE v_proc_ind_desc_txt VARCHAR(50) ;
DECLARE SQLCODE	INTEGER DEFAULT 000;
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (SQLCODE) INTO p_status_sqlcode ;
--=============================================================================
--	Retrieve the values of control plan code,proc_ind_desc_txt
--     proc_ind  from the tables from  MTHP0460_APFX_XREF,MTHP0470_PRTE_XREF
--=============================================================================

SELECT B.PROC_IND  
,A.CTRL_PLAN_CD 
,B.PROC_IND_DESC_TXT
INTO v_proc_ind, v_ctrl_plan_cd, v_proc_ind_desc_txt 
FROM MDHP0000.MTHP0460_APFX_XREF A                
LEFT JOIN MDHP0000.MTHP0470_PRTE_XREF B          
ON  B.STA_CD   = A.PROC_SITE_STA_CD            
AND B.PLAN_CD  = A.PROC_SITE_PLAN_CD           
AND B.CLM_TYPE = A.CLM_TYPE                    
WHERE A.ALPHA_PFX 	=  p_alpha_pfx 	    
AND A.RCP_INCR_ST_DT 	<= p_rcp_incr_st_dt
AND A.RCP_INCR_END_DT 	>= p_rcp_incr_end_dt
AND A.CLM_TYPE 		=  p_clm_type ; 

--============================================================================
--	Place the value of SQLCODE into the variable p_sqlcode  
--=============================================================================
VALUES (SQLCODE) INTO p_status_sqlcode;
-- ============================================================================

SET p_ctrl_plan_cd = v_ctrl_plan_cd;
SET p_proc_ind = v_proc_ind;
SET p_proc_ind_desc_txt = v_proc_ind_desc_txt;
--=============================================================================
-- Based on the sql code checking the Proc_ind
-- ============================================================================
IF p_status_sqlcode = 0 THEN 
	IF v_proc_ind IS NULL THEN
		SET p_proc_ind  = 'BX';
	END IF;	 
ELSEIF  (p_status_sqlcode = 100) THEN 
    	SET p_error_desc  = 'Alpha Prefix Is Not found';
ELSE
     SET p_error_desc ='UNROUTABLE ERROR';
END IF ;
--=============================================================================
-- Based on the sql code checking the proc_ind_desc_txt
-- ============================================================================
IF p_status_sqlcode = 0 THEN 
	IF (v_proc_ind_desc_txt) IS NULL THEN 
		SET p_proc_ind_desc_txt = '  ';
	END IF;
ELSEIF  (p_status_sqlcode = 100) THEN 
    	 SET p_error_desc  = 'AlphaPrefix Is Not Found';
ELSE
	SET p_error_desc ='ERROR';
END IF ;
--=============================================================================
-- Based on the sql code set the status and error description
-- ============================================================================

CASE p_status_sqlcode	
	WHEN 0  THEN   -- SQL SELECT Statement Processed Successfully 
		SET p_status = 'Row Found' ;
		SET p_error_desc  = 'Alpha Prefix found';
	WHEN 100 THEN	-- Row not Found or End of Cursor
		SET p_status = 'Row Not Found' ;
	ELSE
		SET p_status = 'ERROR';		
END CASE;

END
@
