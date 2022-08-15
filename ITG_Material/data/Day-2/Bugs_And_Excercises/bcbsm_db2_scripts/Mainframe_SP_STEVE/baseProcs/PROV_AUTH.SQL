--======================================================================
--	Author: Nanaji Veeturi
--	Date:	Feb/01/2010
--	Description: This Stored Procedure is used to check if a Provider
--	is already authenticated by BCBSM. Multiple records for the
--	provider will exist
--	Version: $VERSION$
--======================================================================

--======================================================================
--	Drop Procedure MDHP0000.PROV_AUTH If exists 
--======================================================================

CALL db2perf_quiet_drop('PROCEDURE MDHP0000.PROV_AUTH') ;

CREATE PROCEDURE MDHP0000.PROV_AUTH
(
	IN	p_subm_id_num		CHAR(15),
	IN	p_prov_num		    CHAR(30),
	OUT	p_sqlcode		    INTEGER
)

LANGUAGE SQL
EXTERNAL NAME PROVAUTH
MODIFIES SQL DATA

BEGIN

DECLARE v_emp_user_id_num 		CHAR(8);
DECLARE loopCount 			INTEGER DEFAULT 0;
DECLARE SQLCODE				INTEGER DEFAULT 0;

--======================================================================
--	Setup the EXIT Handle to handle any SQL Exceptions
--======================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION 
VALUES (SQLCODE) INTO p_sqlcode ;

--======================================================================
--	Loop for 10 Time until we get a successfull response
--======================================================================

RETRY_LOOP:
LOOP
--======================================================================
--	Check if the SUBMITTER and PROVIDER NUMBER are 
--	present in Database
--======================================================================

	SELECT EMP_USER_ID_NUM into v_emp_user_id_num 
	FROM 	MDHP0000.MTHP0030_PROV_AUTH 
	WHERE	SUBM_ID_NUM = p_subm_id_num 
		AND PROV_NUM = p_prov_num FETCH FIRST 1 ROWS ONLY WITH UR;

	set p_sqlcode=SQLCODE ;
 
	CASE p_sqlcode
		-- SQL SELECT Statement Processed Successfully

        	WHEN 0  THEN      
              		LEAVE RETRY_LOOP;

		-- Row not Found or End of Cursor
		WHEN 100 THEN		
			LEAVE RETRY_LOOP;
--======================================================================
--	More than one Row returned from the SELECT statement
-- 	This implies that the provider is valid so return 0
--======================================================================
		WHEN -811 THEN
			SET p_sqlcode = 0;		
			LEAVE RETRY_LOOP;
--======================================================================
--	Deadlock or timeout. Rollback has been done - so need to 
-- 	retry the Select statement.
--	Might even have to handle 904 and 913 SQLCODES.
--======================================================================
		WHEN -911 THEN
			IF loopCount<=10 THEN
				SET loopCount = loopCount+1;
				ITERATE RETRY_LOOP;
			ELSE 
		     		LEAVE RETRY_LOOP;
			END IF;
		ELSE
			LEAVE RETRY_LOOP;		

	END CASE;	
END LOOP RETRY_LOOP;

END
