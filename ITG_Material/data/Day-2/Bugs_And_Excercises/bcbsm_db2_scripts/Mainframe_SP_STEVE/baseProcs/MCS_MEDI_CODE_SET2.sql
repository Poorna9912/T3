CREATE PROCEDURE MDHP0000.MCS_MEDI_CODE_SET2
(IN p_mcs_med_cd		CHAR(48),
IN p_mcs_type_cd  	CHAR(2),
IN p_mcs_eff_dt 		DATE,
IN p_mcs_trm_dt 		DATE,
IN p_mcs_del_ind 		CHAR(1),
IN p_mcs_grac_prd_dt  	DATE,
OUT p_sqlcode 		INTEGER)
LANGUAGE SQL
EXTERNAL NAME MEDICDE2
MODIFIES SQL DATA
BEGIN
--======================================================================
--	Declaration of variables in the Procedure
--======================================================================
DECLARE v_mcs_trm_dt 		DATE;
DECLARE v_mcs_grac_prd_dt 	DATE;
DECLARE SQLCODE			INTEGER DEFAULT 000;
--======================================================================
--	Setup the EXIT Handle for all SQL Exceptions
--======================================================================
DECLARE EXIT HANDLER FOR SQLEXCEPTION
SET p_sqlcode = SQLCODE;
--======================================================================
--	Checks if Medical Code Type is 'RC' or 'HC' or 'MO' or 'AD' or
--	'IP' or 'ID' are present in the database
--======================================================================
IF (p_mcs_type_cd ='RC') THEN
--======================================================================
--	Retrieve the  maximum of MCS_TRM_DT(date) from Database
--======================================================================
SELECT	MCS_TRM_DT
INTO 	v_mcs_trm_dt
FROM 	MDHP0000.MTHP0300_MCS_CODE
WHERE 	 	MCS_MED_CD 	=	p_mcs_med_cd
AND 	MCS_TYPE_CD	=	p_mcs_type_cd
AND 	MCS_EFF_DT 	<=	p_mcs_eff_dt
AND 	MCS_DEL_IND	=	p_mcs_del_ind
AND 	MCS_TRM_DT	>=	p_mcs_trm_dt
FETCH FIRST 1 ROWS ONLY WITH UR;
--======================================================================
--	Place the Value of Sqlcode retreived into the variable p_sqlcode
--======================================================================
SET p_sqlcode = SQLCODE;
ELSEIF (p_mcs_type_cd ='HC' OR p_mcs_type_cd ='MO' 
OR p_mcs_type_cd ='AD')
THEN
--======================================================================
--	Retrieve the maximum of MCS_GRAC_PRD_DT(date) from Database if
--	MCS_TYPE_CD =HC or MO or AD
--======================================================================
SELECT	MCS_GRAC_PRD_DT	INTO 	v_mcs_grac_prd_dt
FROM 	MDHP0000.MTHP0300_MCS_CODE
WHERE	MCS_MED_CD		=	p_mcs_med_cd
AND 	MCS_TYPE_CD		=	p_mcs_type_cd
AND 	MCS_EFF_DT		<=	p_mcs_eff_dt
AND 	MCS_DEL_IND		= 	p_mcs_del_ind
AND 	MCS_GRAC_PRD_DT >= 	p_mcs_grac_prd_dt
FETCH FIRST 1 ROWS ONLY WITH UR;
--======================================================================
--	Place the Value of Sqlcode into the variable p_sqlcode
--======================================================================
SET p_sqlcode = SQLCODE;
ELSEIF (p_mcs_type_cd ='IP' OR p_mcs_type_cd ='ID') THEN
--======================================================================
--	Retrieve the  maximum of MCS_TRM_DT(date) from Database if
--	MCS_TYPE_CD =IP or ID
--======================================================================
SELECT MCS_TRM_DT INTO v_mcs_trm_dt
FROM MDHP0000.MTHP0300_MCS_CODE
WHERE MCS_MED_CD	=	p_mcs_med_cd
AND MCS_TYPE_CD 	=	p_mcs_type_cd
AND MCS_EFF_DT 		<=	p_mcs_eff_dt
AND MCS_DEL_IND		=	p_mcs_del_ind
AND MCS_TRM_DT 		>=	p_mcs_trm_dt
FETCH FIRST 1 ROWS ONLY WITH UR;
--======================================================================
--	Place the Value of Sqlcode into the variable p_sqlcode
--======================================================================
SET p_sqlcode = SQLCODE;
IF ( p_sqlcode = 100 or p_sqlcode = -305) then
--======================================================================
--	Retrieve the maximum of MCS_GRAC_PRD_DT(date) from Database
--	if MCS_TYPE_CD is IP or ID
--======================================================================
SELECT MCS_GRAC_PRD_DT INTO v_mcs_grac_prd_dt
FROM MDHP0000.MTHP0300_MCS_CODE
WHERE	MCS_MED_CD = p_mcs_med_cd
AND MCS_TYPE_CD =p_mcs_type_cd
AND MCS_EFF_DT <= p_mcs_eff_dt
AND MCS_DEL_IND = p_mcs_del_ind
AND MCS_GRAC_PRD_DT >= p_mcs_grac_prd_dt
FETCH FIRST 1 ROWS ONLY WITH UR;
SET p_sqlcode = SQLCODE;
ELSE
SET p_sqlcode = SQLCODE;
END IF ;
ELSE
SET p_sqlcode = 100;
END IF ;
END
