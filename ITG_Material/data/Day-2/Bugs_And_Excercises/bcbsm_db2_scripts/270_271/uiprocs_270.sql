--=============================================================================
--	Filename:	uiprocs_270.sql
--	Author:	Nanaji Veturi
--	Date:		
--	Description:
--	This file contains the Procedures for the UI Reports
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS 
	(
    IN  err_cd  INTEGER,
    OUT p_h1 	INTEGER,
	OUT p_h2	INTEGER,
	OUT p_h3	INTEGER,
	OUT p_h4	INTEGER,
	OUT p_h5	INTEGER,
	OUT p_h6	INTEGER,
	OUT p_h7	INTEGER,
	OUT p_h8	INTEGER,
	OUT p_h9	INTEGER,
	OUT p_h10	INTEGER,
	OUT p_h11	INTEGER,
	OUT p_h12	INTEGER,
	OUT p_h13	INTEGER,
	OUT p_h14	INTEGER,
	OUT p_h15   INTEGER,
	OUT p_h16	INTEGER,
	OUT p_h17	INTEGER,
	OUT p_h18	INTEGER,
	OUT p_h19	INTEGER,
	OUT p_h20	INTEGER,
	OUT p_h21	INTEGER,
	OUT p_h22	INTEGER,
	OUT p_h23	INTEGER,
	OUT p_h24	INTEGER
	)
  
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_hour INTEGER;--
DECLARE v_count INTEGER;--
DECLARE v_h1  INTEGER DEFAULT 0 ; 
DECLARE v_h2  INTEGER DEFAULT 0 ; 
DECLARE v_h3  INTEGER DEFAULT 0 ; 
DECLARE v_h4  INTEGER DEFAULT 0 ; 
DECLARE v_h5  INTEGER DEFAULT 0 ; 
DECLARE v_h6  INTEGER DEFAULT 0 ; 
DECLARE v_h7  INTEGER DEFAULT 0 ; 
DECLARE v_h8  INTEGER DEFAULT 0 ;
DECLARE v_h9  INTEGER DEFAULT 0 ;
DECLARE v_h10 INTEGER DEFAULT 0 ;
DECLARE v_h11 INTEGER DEFAULT 0 ;
DECLARE v_h12 INTEGER DEFAULT 0 ;
DECLARE v_h13 INTEGER DEFAULT 0 ;
DECLARE v_h14 INTEGER DEFAULT 0 ;
DECLARE v_h15 INTEGER DEFAULT 0 ;
DECLARE v_h16 INTEGER DEFAULT 0 ;
DECLARE v_h17 INTEGER DEFAULT 0 ;
DECLARE v_h18 INTEGER DEFAULT 0 ;
DECLARE v_h19 INTEGER DEFAULT 0 ;
DECLARE v_h20 INTEGER DEFAULT 0 ;
DECLARE v_h21 INTEGER DEFAULT 0 ;
DECLARE v_h22 INTEGER DEFAULT 0 ;
DECLARE v_h23 INTEGER DEFAULT 0 ;
DECLARE v_h24 INTEGER DEFAULT 0 ;

--============================================================================
--  Declaring cursor HOUR_CURSR for T_UI_270_CTRL_LOG
--============================================================================

DECLARE HOUR_CURSR CURSOR FOR SELECT HOUR(TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG where TRAN_ERR_CD = err_cd and 
TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day));--

--=============================================================================
--	Retreiving the count of hour of TRAN_END_TS from the Table T_UI_270_CTRL_LOG based on TRAN_ERR_CD
--=============================================================================

SELECT COUNT(hour(TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG where TRAN_ERR_CD = err_cd and 
TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day));--

--=============================================================================
--	Opening cursor HOUR_CURSR
--=============================================================================

OPEN HOUR_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM HOUR_CURSR INTO v_hour;--
		
		CASE v_hour

		WHEN 1 THEN
		
		SET v_h1 = v_h1 +1 ;

		WHEN 2 THEN
		
        SET v_h2 = v_h2 +1 ;
		
		WHEN 3 THEN
		
		SET v_h3 = v_h3 +1 ;
		
		WHEN 4 THEN
		
		SET v_h4 = v_h4 +1 ;
		
		WHEN 5 THEN
		
		SET v_h5 = v_h5 +1 ;
		
		WHEN 6 THEN
		
		SET v_h6 = v_h6 +1 ;
		
		WHEN 7 THEN
		
		SET v_h7 = v_h7 +1 ;
		
		WHEN 8 THEN
		
		SET v_h8 = v_h8 +1 ;
		
		WHEN 9 THEN
		
		SET v_h9 = v_h9 +1 ;
		
		WHEN 10 THEN
		
		SET v_h10 = v_h10 +1 ;
		
		WHEN 11 THEN
		
		SET v_h11 = v_h11 +1 ;
		
		WHEN 12 THEN
		
		SET v_h12 = v_h12 +1 ;
		
		WHEN 13 THEN
		
		SET v_h13 = v_h13 +1 ;
		
		WHEN 14 THEN
		
		SET v_h14 = v_h14 +1 ;
		
		WHEN 15 THEN
		
		SET v_h15 = v_h15 +1 ;
		
		WHEN 16 THEN
		
		SET v_h16 = v_h16 +1 ;
		
		WHEN 17 THEN
		
		SET v_h17 = v_h17 +1 ;
		
		WHEN 18 THEN
		
		SET v_h18 = v_h18 +1 ;
		
		WHEN 19 THEN
		
		SET v_h19 = v_h19 +1 ;
		
		WHEN 20 THEN
		
		SET v_h20 = v_h20 +1 ;
		
		WHEN 21 THEN
		
		SET v_h21 = v_h21 +1 ;
		
		WHEN 22 THEN
		
		SET v_h22 = v_h22 +1 ;
		
		WHEN 23 THEN
		
		SET v_h23 = v_h23 +1 ;
		
	
		ELSE
		SET v_h24 = v_h24 +1 ;
					
		END CASE ;
		
	SET v_count=v_count-1;--	
		
	END WHILE;--

--=============================================================================
--	Closing cursor HOUR_CURSR
--=============================================================================

CLOSE HOUR_CURSR;--

SET p_h1  = v_h1  ;
SET p_h2  = v_h2  ;
SET p_h3  = v_h3  ;
SET p_h4  = v_h4  ;
SET p_h5  = v_h5  ;
SET p_h6  = v_h6  ;
SET p_h7  = v_h7  ;
SET p_h8  = v_h8  ;
SET p_h9  = v_h9  ;
SET p_h10 = v_h10 ;
SET p_h11 = v_h11 ;
SET p_h12 = v_h12 ;
SET p_h13 = v_h13 ;
SET p_h14 = v_h14 ;
SET p_h15 = v_h15 ;
SET p_h16 = v_h16 ;
SET p_h17 = v_h17 ;
SET p_h18 = v_h18 ;
SET p_h19 = v_h19 ;
SET p_h20 = v_h20 ;
SET p_h21 = v_h21 ;
SET p_h22 = v_h22 ;
SET p_h23 = v_h23 ;
SET p_h24 = v_h24 ;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_TOTAL')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_TOTAL 
	(
    OUT p_h1 	INTEGER,
	OUT p_h2	INTEGER,
	OUT p_h3	INTEGER,
	OUT p_h4	INTEGER,
	OUT p_h5	INTEGER,
	OUT p_h6	INTEGER,
	OUT p_h7	INTEGER,
	OUT p_h8	INTEGER,
	OUT p_h9	INTEGER,
	OUT p_h10	INTEGER,
	OUT p_h11	INTEGER,
	OUT p_h12	INTEGER,
	OUT p_h13	INTEGER,
	OUT p_h14	INTEGER,
	OUT p_h15   INTEGER,
	OUT p_h16	INTEGER,
	OUT p_h17	INTEGER,
	OUT p_h18	INTEGER,
	OUT p_h19	INTEGER,
	OUT p_h20	INTEGER,
	OUT p_h21	INTEGER,
	OUT p_h22	INTEGER,
	OUT p_h23	INTEGER,
	OUT p_h24	INTEGER
	)
  SPECIFIC SP_UI_270_DAILYERRORTRANSACTIONS_TOTAL
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_hour integer;--
DECLARE v_count integer;--
DECLARE v_h1  INTEGER DEFAULT 0 ; 
DECLARE v_h2  INTEGER DEFAULT 0 ; 
DECLARE v_h3  INTEGER DEFAULT 0 ; 
DECLARE v_h4  INTEGER DEFAULT 0 ; 
DECLARE v_h5  INTEGER DEFAULT 0 ; 
DECLARE v_h6  INTEGER DEFAULT 0 ; 
DECLARE v_h7  INTEGER DEFAULT 0 ; 
DECLARE v_h8  INTEGER DEFAULT 0 ;
DECLARE v_h9  INTEGER DEFAULT 0 ;
DECLARE v_h10 INTEGER DEFAULT 0 ;
DECLARE v_h11 INTEGER DEFAULT 0 ;
DECLARE v_h12 INTEGER DEFAULT 0 ;
DECLARE v_h13 INTEGER DEFAULT 0 ;
DECLARE v_h14 INTEGER DEFAULT 0 ;
DECLARE v_h15 INTEGER DEFAULT 0 ;
DECLARE v_h16 INTEGER DEFAULT 0 ;
DECLARE v_h17 INTEGER DEFAULT 0 ;
DECLARE v_h18 INTEGER DEFAULT 0 ;
DECLARE v_h19 INTEGER DEFAULT 0 ;
DECLARE v_h20 INTEGER DEFAULT 0 ;
DECLARE v_h21 INTEGER DEFAULT 0 ;
DECLARE v_h22 INTEGER DEFAULT 0 ;
DECLARE v_h23 INTEGER DEFAULT 0 ;
DECLARE v_h24 INTEGER DEFAULT 0 ;

--============================================================================
--  Declaring cursor HOUR_CURSR for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE HOUR_CURSR  CURSOR FOR SELECT hour(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day));

--=============================================================================
--	Retreiving the count of hour of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(hour(UI.TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day));

--=============================================================================
--	Opening cursor HOUR_CURSR
--=============================================================================

OPEN HOUR_CURSR;--

	WHILE (v_count <> 0)
	DO 
		FETCH FROM HOUR_CURSR INTO v_hour;--
		
		CASE v_hour

		WHEN 1 THEN
		
		SET v_h1 = v_h1 +1 ;

		WHEN 2 THEN
		
        SET v_h2 = v_h2 +1 ;
		
		WHEN 3 THEN
		
		SET v_h3 = v_h3 +1 ;
		
		WHEN 4 THEN
		
		SET v_h4 = v_h4 +1 ;
		
		WHEN 5 THEN
		
		SET v_h5 = v_h5 +1 ;
		
		WHEN 6 THEN
		
		SET v_h6 = v_h6 +1 ;
		
		WHEN 7 THEN
		
		SET v_h7 = v_h7 +1 ;
		
		WHEN 8 THEN
		
		SET v_h8 = v_h8 +1 ;
		
		WHEN 9 THEN
		
		SET v_h9 = v_h9 +1 ;
		
		WHEN 10 THEN
		
		SET v_h10 = v_h10 +1 ;
		
		WHEN 11 THEN
		
		SET v_h11 = v_h11 +1 ;
		
		WHEN 12 THEN
		
		SET v_h12 = v_h12 +1 ;
		
		WHEN 13 THEN
		
		SET v_h13 = v_h13 +1 ;
		
		WHEN 14 THEN
		
		SET v_h14 = v_h14 +1 ;
		
		WHEN 15 THEN
		
		SET v_h15 = v_h15 +1 ;
		
		WHEN 16 THEN
		
		SET v_h16 = v_h16 +1 ;
		
		WHEN 17 THEN
		
		SET v_h17 = v_h17 +1 ;
		
		WHEN 18 THEN
		
		SET v_h18 = v_h18 +1 ;
		
		WHEN 19 THEN
		
		SET v_h19 = v_h19 +1 ;
		
		WHEN 20 THEN
		
		SET v_h20 = v_h20 +1 ;
		
		WHEN 21 THEN
		
		SET v_h21 = v_h21 +1 ;
		
		WHEN 22 THEN
		
		SET v_h22 = v_h22 +1 ;
		
		WHEN 23 THEN
		
		SET v_h23 = v_h23 +1 ;
		
	
		ELSE
		SET v_h24 = v_h24 +1 ;
		
		END CASE ;
		
	SET v_count=v_count-1;--	
		
	END WHILE;--

--=============================================================================
--	Closing cursor HOUR_CURSR
--=============================================================================

CLOSE HOUR_CURSR;--

SET p_h1  = v_h1  ;
SET p_h2  = v_h2  ;
SET p_h3  = v_h3  ;
SET p_h4  = v_h4  ;
SET p_h5  = v_h5  ;
SET p_h6  = v_h6  ;
SET p_h7  = v_h7  ;
SET p_h8  = v_h8  ;
SET p_h9  = v_h9  ;
SET p_h10 = v_h10 ;
SET p_h11 = v_h11 ;
SET p_h12 = v_h12 ;
SET p_h13 = v_h13 ;
SET p_h14 = v_h14 ;
SET p_h15 = v_h15 ;
SET p_h16 = v_h16 ;
SET p_h17 = v_h17 ;
SET p_h18 = v_h18 ;
SET p_h19 = v_h19 ;
SET p_h20 = v_h20 ;
SET p_h21 = v_h21 ;
SET p_h22 = v_h22 ;
SET p_h23 = v_h23 ;
SET p_h24 = v_h24 ;

END@	

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_ECOUNT')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_ECOUNT 
	(
    OUT p_h1 	INTEGER,
	OUT p_h2	INTEGER,
	OUT p_h3	INTEGER,
	OUT p_h4	INTEGER,
	OUT p_h5	INTEGER,
	OUT p_h6	INTEGER,
	OUT p_h7	INTEGER,
	OUT p_h8	INTEGER,
	OUT p_h9	INTEGER,
	OUT p_h10	INTEGER,
	OUT p_h11	INTEGER,
	OUT p_h12	INTEGER,
	OUT p_h13	INTEGER,
	OUT p_h14	INTEGER,
	OUT p_h15   INTEGER,
	OUT p_h16	INTEGER,
	OUT p_h17	INTEGER,
	OUT p_h18	INTEGER,
	OUT p_h19	INTEGER,
	OUT p_h20	INTEGER,
	OUT p_h21	INTEGER,
	OUT p_h22	INTEGER,
	OUT p_h23	INTEGER,
	OUT p_h24	INTEGER
	)

  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_hour INTEGER;
DECLARE v_count INTEGER;
DECLARE v_h1  INTEGER DEFAULT 0 ; 
DECLARE v_h2  INTEGER DEFAULT 0 ; 
DECLARE v_h3  INTEGER DEFAULT 0 ; 
DECLARE v_h4  INTEGER DEFAULT 0 ; 
DECLARE v_h5  INTEGER DEFAULT 0 ; 
DECLARE v_h6  INTEGER DEFAULT 0 ; 
DECLARE v_h7  INTEGER DEFAULT 0 ; 
DECLARE v_h8  INTEGER DEFAULT 0 ;
DECLARE v_h9  INTEGER DEFAULT 0 ;
DECLARE v_h10 INTEGER DEFAULT 0 ;
DECLARE v_h11 INTEGER DEFAULT 0 ;
DECLARE v_h12 INTEGER DEFAULT 0 ;
DECLARE v_h13 INTEGER DEFAULT 0 ;
DECLARE v_h14 INTEGER DEFAULT 0 ;
DECLARE v_h15 INTEGER DEFAULT 0 ;
DECLARE v_h16 INTEGER DEFAULT 0 ;
DECLARE v_h17 INTEGER DEFAULT 0 ;
DECLARE v_h18 INTEGER DEFAULT 0 ;
DECLARE v_h19 INTEGER DEFAULT 0 ;
DECLARE v_h20 INTEGER DEFAULT 0 ;
DECLARE v_h21 INTEGER DEFAULT 0 ;
DECLARE v_h22 INTEGER DEFAULT 0 ;
DECLARE v_h23 INTEGER DEFAULT 0 ;
DECLARE v_h24 INTEGER DEFAULT 0 ;

--============================================================================
--  Declaring cursor HOUR_CURSR for T_UI_270_CTRL_LOG
--============================================================================

DECLARE HOUR_CURSR CURSOR FOR SELECT hour(UI.TRAN_END_TS) 
		FROM EDIDB2A.T_UI_270_CTRL_LOG UI 
			  JOIN EDIDB2A.T_EVNT_METADATA EVT 
		ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'E'
		and TRAN_END_TS <= (values(current timestamp)) and
		TRAN_END_TS >=(values(current timestamp - 1 day));

--=============================================================================
--	Retreiving the count of hour of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(hour(UI.TRAN_END_TS)) INTO v_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'E'
and TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day));

--=============================================================================
--	Opening cursor HOUR_CURSR
--=============================================================================

OPEN HOUR_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM HOUR_CURSR INTO v_hour;--
		
		CASE v_hour

		WHEN 1 THEN
		
		SET v_h1 = v_h1 +1 ;

		WHEN 2 THEN
		
        SET v_h2 = v_h2 +1 ;
		
		WHEN 3 THEN
		
		SET v_h3 = v_h3 +1 ;
		
		WHEN 4 THEN
		
		SET v_h4 = v_h4 +1 ;
		
		WHEN 5 THEN
		
		SET v_h5 = v_h5 +1 ;
		
		WHEN 6 THEN
		
		SET v_h6 = v_h6 +1 ;
		
		WHEN 7 THEN
		
		SET v_h7 = v_h7 +1 ;
		
		WHEN 8 THEN
		
		SET v_h8 = v_h8 +1 ;
		
		WHEN 9 THEN
		
		SET v_h9 = v_h9 +1 ;
		
		WHEN 10 THEN
		
		SET v_h10 = v_h10 +1 ;
		
		WHEN 11 THEN
		
		SET v_h11 = v_h11 +1 ;
		
		WHEN 12 THEN
		
		SET v_h12 = v_h12 +1 ;
		
		WHEN 13 THEN
		
		SET v_h13 = v_h13 +1 ;
		
		WHEN 14 THEN
		
		SET v_h14 = v_h14 +1 ;
		
		WHEN 15 THEN
		
		SET v_h15 = v_h15 +1 ;
		
		WHEN 16 THEN
		
		SET v_h16 = v_h16 +1 ;
		
		WHEN 17 THEN
		
		SET v_h17 = v_h17 +1 ;
		
		WHEN 18 THEN
		
		SET v_h18 = v_h18 +1 ;
		
		WHEN 19 THEN
		
		SET v_h19 = v_h19 +1 ;
		
		WHEN 20 THEN
		
		SET v_h20 = v_h20 +1 ;
		
		WHEN 21 THEN
		
		SET v_h21 = v_h21 +1 ;
		
		WHEN 22 THEN
		
		SET v_h22 = v_h22 +1 ;
		
		WHEN 23 THEN
		
		SET v_h23 = v_h23 +1 ;
			
		ELSE
		SET v_h24 = v_h24 +1 ;
				
		END CASE ;
		
	SET v_count=v_count-1;--	
		
	END WHILE;--

--=============================================================================
--	Closing cursor HOUR_CURSR
--=============================================================================

CLOSE HOUR_CURSR;--

SET p_h1  = v_h1  ;
SET p_h2  = v_h2  ;
SET p_h3  = v_h3  ;
SET p_h4  = v_h4  ;
SET p_h5  = v_h5  ;
SET p_h6  = v_h6  ;
SET p_h7  = v_h7  ;
SET p_h8  = v_h8  ;
SET p_h9  = v_h9  ;
SET p_h10 = v_h10 ;
SET p_h11 = v_h11 ;
SET p_h12 = v_h12 ;
SET p_h13 = v_h13 ;
SET p_h14 = v_h14 ;
SET p_h15 = v_h15 ;
SET p_h16 = v_h16 ;
SET p_h17 = v_h17 ;
SET p_h18 = v_h18 ;
SET p_h19 = v_h19 ;
SET p_h20 = v_h20 ;
SET p_h21 = v_h21 ;
SET p_h22 = v_h22 ;
SET p_h23 = v_h23 ;
SET p_h24 = v_h24 ;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_OCOUNT')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_OCOUNT 
	(
    OUT p_h1 	INTEGER,
	OUT p_h2	INTEGER,
	OUT p_h3	INTEGER,
	OUT p_h4	INTEGER,
	OUT p_h5	INTEGER,
	OUT p_h6	INTEGER,
	OUT p_h7	INTEGER,
	OUT p_h8	INTEGER,
	OUT p_h9	INTEGER,
	OUT p_h10	INTEGER,
	OUT p_h11	INTEGER,
	OUT p_h12	INTEGER,
	OUT p_h13	INTEGER,
	OUT p_h14	INTEGER,
	OUT p_h15  INTEGER,
	OUT p_h16	INTEGER,
	OUT p_h17	INTEGER,
	OUT p_h18	INTEGER,
	OUT p_h19	INTEGER,
	OUT p_h20	INTEGER,
	OUT p_h21	INTEGER,
	OUT p_h22	INTEGER,
	OUT p_h23	INTEGER,
	OUT p_h24	INTEGER
	)
  
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_hour INTEGER;--
DECLARE v_count INTEGER;--
DECLARE v_h1  INTEGER DEFAULT 0 ; 
DECLARE v_h2  INTEGER DEFAULT 0 ; 
DECLARE v_h3  INTEGER DEFAULT 0 ; 
DECLARE v_h4  INTEGER DEFAULT 0 ; 
DECLARE v_h5  INTEGER DEFAULT 0 ; 
DECLARE v_h6  INTEGER DEFAULT 0 ; 
DECLARE v_h7  INTEGER DEFAULT 0 ; 
DECLARE v_h8  INTEGER DEFAULT 0 ;
DECLARE v_h9  INTEGER DEFAULT 0 ;
DECLARE v_h10 INTEGER DEFAULT 0 ;
DECLARE v_h11 INTEGER DEFAULT 0 ;
DECLARE v_h12 INTEGER DEFAULT 0 ;
DECLARE v_h13 INTEGER DEFAULT 0 ;
DECLARE v_h14 INTEGER DEFAULT 0 ;
DECLARE v_h15 INTEGER DEFAULT 0 ;
DECLARE v_h16 INTEGER DEFAULT 0 ;
DECLARE v_h17 INTEGER DEFAULT 0 ;
DECLARE v_h18 INTEGER DEFAULT 0 ;
DECLARE v_h19 INTEGER DEFAULT 0 ;
DECLARE v_h20 INTEGER DEFAULT 0 ;
DECLARE v_h21 INTEGER DEFAULT 0 ;
DECLARE v_h22 INTEGER DEFAULT 0 ;
DECLARE v_h23 INTEGER DEFAULT 0 ;
DECLARE v_h24 INTEGER DEFAULT 0 ;

--============================================================================
--  Declaring cursor HOUR_CURSR for T_UI_270_CTRL_LOG
--============================================================================

DECLARE HOUR_CURSR CURSOR FOR SELECT hour(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'O'
and TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day));

--=============================================================================
--	Retreiving the count of hour of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(hour(UI.TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'O'
and TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day));

--=============================================================================
--	Opening cursor HOUR_CURSR
--=============================================================================

OPEN HOUR_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM HOUR_CURSR INTO v_hour;--
		
		CASE v_hour

		WHEN 1 THEN
		
		SET v_h1 = v_h1 +1 ;

		WHEN 2 THEN
		
        SET v_h2 = v_h2 +1 ;
		
		WHEN 3 THEN
		
		SET v_h3 = v_h3 +1 ;
		
		WHEN 4 THEN
		
		SET v_h4 = v_h4 +1 ;
		
		WHEN 5 THEN
		
		SET v_h5 = v_h5 +1 ;
		
		WHEN 6 THEN
		
		SET v_h6 = v_h6 +1 ;
		
		WHEN 7 THEN
		
		SET v_h7 = v_h7 +1 ;
		
		WHEN 8 THEN
		
		SET v_h8 = v_h8 +1 ;
		
		WHEN 9 THEN
		
		SET v_h9 = v_h9 +1 ;
		
		WHEN 10 THEN
		
		SET v_h10 = v_h10 +1 ;
		
		WHEN 11 THEN
		
		SET v_h11 = v_h11 +1 ;
		
		WHEN 12 THEN
		
		SET v_h12 = v_h12 +1 ;
		
		WHEN 13 THEN
		
		SET v_h13 = v_h13 +1 ;
		
		WHEN 14 THEN
		
		SET v_h14 = v_h14 +1 ;
		
		WHEN 15 THEN
		
		SET v_h15 = v_h15 +1 ;
		
		WHEN 16 THEN
		
		SET v_h16 = v_h16 +1 ;
		
		WHEN 17 THEN
		
		SET v_h17 = v_h17 +1 ;
		
		WHEN 18 THEN
		
		SET v_h18 = v_h18 +1 ;
		
		WHEN 19 THEN
		
		SET v_h19 = v_h19 +1 ;
		
		WHEN 20 THEN
		
		SET v_h20 = v_h20 +1 ;
		
		WHEN 21 THEN
		
		SET v_h21 = v_h21 +1 ;
		
		WHEN 22 THEN
		
		SET v_h22 = v_h22 +1 ;
		
		WHEN 23 THEN
		
		SET v_h23 = v_h23 +1 ;
		
	
		ELSE
		SET v_h24 = v_h24 +1 ;
			
		
		END CASE ;
		
	SET v_count=v_count-1;--	
		
	END WHILE;--

--=============================================================================
--	Closing cursor HOUR_CURSR
--=============================================================================

CLOSE HOUR_CURSR;--

SET p_h1  = v_h1  ;
SET p_h2  = v_h2  ;
SET p_h3  = v_h3  ;
SET p_h4  = v_h4  ;
SET p_h5  = v_h5  ;
SET p_h6  = v_h6  ;
SET p_h7  = v_h7  ;
SET p_h8  = v_h8  ;
SET p_h9  = v_h9  ;
SET p_h10 = v_h10 ;
SET p_h11 = v_h11 ;
SET p_h12 = v_h12 ;
SET p_h13 = v_h13 ;
SET p_h14 = v_h14 ;
SET p_h15 = v_h15 ;
SET p_h16 = v_h16 ;
SET p_h17 = v_h17 ;
SET p_h18 = v_h18 ;
SET p_h19 = v_h19 ;
SET p_h20 = v_h20 ;
SET p_h21 = v_h21 ;
SET p_h22 = v_h22 ;
SET p_h23 = v_h23 ;
SET p_h24 = v_h24 ;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_WCOUNT')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_WCOUNT 
	(
    OUT p_h1 	INTEGER,
	OUT p_h2	INTEGER,
	OUT p_h3	INTEGER,
	OUT p_h4	INTEGER,
	OUT p_h5	INTEGER,
	OUT p_h6	INTEGER,
	OUT p_h7	INTEGER,
	OUT p_h8	INTEGER,
	OUT p_h9	INTEGER,
	OUT p_h10	INTEGER,
	OUT p_h11	INTEGER,
	OUT p_h12	INTEGER,
	OUT p_h13	INTEGER,
	OUT p_h14	INTEGER,
	OUT p_h15   INTEGER,
	OUT p_h16	INTEGER,
	OUT p_h17	INTEGER,
	OUT p_h18	INTEGER,
	OUT p_h19	INTEGER,
	OUT p_h20	INTEGER,
	OUT p_h21	INTEGER,
	OUT p_h22	INTEGER,
	OUT p_h23	INTEGER,
	OUT p_h24	INTEGER
	)

  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_hour INTEGER;--
DECLARE v_count INTEGER;--
DECLARE v_h1  INTEGER DEFAULT 0 ; 
DECLARE v_h2  INTEGER DEFAULT 0 ; 
DECLARE v_h3  INTEGER DEFAULT 0 ; 
DECLARE v_h4  INTEGER DEFAULT 0 ; 
DECLARE v_h5  INTEGER DEFAULT 0 ; 
DECLARE v_h6  INTEGER DEFAULT 0 ; 
DECLARE v_h7  INTEGER DEFAULT 0 ; 
DECLARE v_h8  INTEGER DEFAULT 0 ;
DECLARE v_h9  INTEGER DEFAULT 0 ;
DECLARE v_h10 INTEGER DEFAULT 0 ;
DECLARE v_h11 INTEGER DEFAULT 0 ;
DECLARE v_h12 INTEGER DEFAULT 0 ;
DECLARE v_h13 INTEGER DEFAULT 0 ;
DECLARE v_h14 INTEGER DEFAULT 0 ;
DECLARE v_h15 INTEGER DEFAULT 0 ;
DECLARE v_h16 INTEGER DEFAULT 0 ;
DECLARE v_h17 INTEGER DEFAULT 0 ;
DECLARE v_h18 INTEGER DEFAULT 0 ;
DECLARE v_h19 INTEGER DEFAULT 0 ;
DECLARE v_h20 INTEGER DEFAULT 0 ;
DECLARE v_h21 INTEGER DEFAULT 0 ;
DECLARE v_h22 INTEGER DEFAULT 0 ;
DECLARE v_h23 INTEGER DEFAULT 0 ;
DECLARE v_h24 INTEGER DEFAULT 0 ;

--============================================================================
--  Declaring cursor HOUR_CURSR for T_UI_270_CTRL_LOG
--============================================================================

DECLARE HOUR_CURSR CURSOR FOR SELECT hour(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'W'
and TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day));

--=============================================================================
--	Retreiving the count of hour of UI.TRAN_END_TS from the Table T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(hour(UI.TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'W'
and TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day));

--=============================================================================
--	Opening cursor HOUR_CURSR
--=============================================================================

OPEN HOUR_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM HOUR_CURSR INTO v_hour;--
		
		CASE v_hour

		WHEN 1 THEN
		
		SET v_h1 = v_h1 +1 ;

		WHEN 2 THEN
		
        SET v_h2 = v_h2 +1 ;
		
		WHEN 3 THEN
		
		SET v_h3 = v_h3 +1 ;
		
		WHEN 4 THEN
		
		SET v_h4 = v_h4 +1 ;
		
		WHEN 5 THEN
		
		SET v_h5 = v_h5 +1 ;
		
		WHEN 6 THEN
		
		SET v_h6 = v_h6 +1 ;
		
		WHEN 7 THEN
		
		SET v_h7 = v_h7 +1 ;
		
		WHEN 8 THEN
		
		SET v_h8 = v_h8 +1 ;
		
		WHEN 9 THEN
		
		SET v_h9 = v_h9 +1 ;
		
		WHEN 10 THEN
		
		SET v_h10 = v_h10 +1 ;
		
		WHEN 11 THEN
		
		SET v_h11 = v_h11 +1 ;
		
		WHEN 12 THEN
		
		SET v_h12 = v_h12 +1 ;
		
		WHEN 13 THEN
		
		SET v_h13 = v_h13 +1 ;
		
		WHEN 14 THEN
		
		SET v_h14 = v_h14 +1 ;
		
		WHEN 15 THEN
		
		SET v_h15 = v_h15 +1 ;
		
		WHEN 16 THEN
		
		SET v_h16 = v_h16 +1 ;
		
		WHEN 17 THEN
		
		SET v_h17 = v_h17 +1 ;
		
		WHEN 18 THEN
		
		SET v_h18 = v_h18 +1 ;
		
		WHEN 19 THEN
		
		SET v_h19 = v_h19 +1 ;
		
		WHEN 20 THEN
		
		SET v_h20 = v_h20 +1 ;
		
		WHEN 21 THEN
		
		SET v_h21 = v_h21 +1 ;
		
		WHEN 22 THEN
		
		SET v_h22 = v_h22 +1 ;
		
		WHEN 23 THEN
		
		SET v_h23 = v_h23 +1 ;
		
	
		ELSE
		SET v_h24 = v_h24 +1 ;
			
		
		END CASE ;
		
	SET v_count=v_count-1;--	
		
	END WHILE;--

--=============================================================================
--	Closing cursor HOUR_CURSR
--=============================================================================

CLOSE HOUR_CURSR;--

SET p_h1  = v_h1  ;
SET p_h2  = v_h2  ;
SET p_h3  = v_h3  ;
SET p_h4  = v_h4  ;
SET p_h5  = v_h5  ;
SET p_h6  = v_h6  ;
SET p_h7  = v_h7  ;
SET p_h8  = v_h8  ;
SET p_h9  = v_h9  ;
SET p_h10 = v_h10 ;
SET p_h11 = v_h11 ;
SET p_h12 = v_h12 ;
SET p_h13 = v_h13 ;
SET p_h14 = v_h14 ;
SET p_h15 = v_h15 ;
SET p_h16 = v_h16 ;
SET p_h17 = v_h17 ;
SET p_h18 = v_h18 ;
SET p_h19 = v_h19 ;
SET p_h20 = v_h20 ;
SET p_h21 = v_h21 ;
SET p_h22 = v_h22 ;
SET p_h23 = v_h23 ;
SET p_h24 = v_h24 ;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_EOWCOUNT')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_DAILYERRORTRANSACTIONS_EOWCOUNT 
	(
    OUT p_h1 	INTEGER,
	OUT p_h2	INTEGER,
	OUT p_h3	INTEGER,
	OUT p_h4	INTEGER,
	OUT p_h5	INTEGER,
	OUT p_h6	INTEGER,
	OUT p_h7	INTEGER,
	OUT p_h8	INTEGER,
	OUT p_h9	INTEGER,
	OUT p_h10	INTEGER,
	OUT p_h11	INTEGER,
	OUT p_h12	INTEGER,
	OUT p_h13	INTEGER,
	OUT p_h14	INTEGER,
	OUT p_h15   INTEGER,
	OUT p_h16	INTEGER,
	OUT p_h17	INTEGER,
	OUT p_h18	INTEGER,
	OUT p_h19	INTEGER,
	OUT p_h20	INTEGER,
	OUT p_h21	INTEGER,
	OUT p_h22	INTEGER,
	OUT p_h23	INTEGER,
	OUT p_h24	INTEGER
	)
  
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_hour integer;--
DECLARE v_count integer;--
DECLARE v_h1  INTEGER DEFAULT 0 ; 
DECLARE v_h2  INTEGER DEFAULT 0 ; 
DECLARE v_h3  INTEGER DEFAULT 0 ; 
DECLARE v_h4  INTEGER DEFAULT 0 ; 
DECLARE v_h5  INTEGER DEFAULT 0 ; 
DECLARE v_h6  INTEGER DEFAULT 0 ; 
DECLARE v_h7  INTEGER DEFAULT 0 ; 
DECLARE v_h8  INTEGER DEFAULT 0 ;
DECLARE v_h9  INTEGER DEFAULT 0 ;
DECLARE v_h10 INTEGER DEFAULT 0 ;
DECLARE v_h11 INTEGER DEFAULT 0 ;
DECLARE v_h12 INTEGER DEFAULT 0 ;
DECLARE v_h13 INTEGER DEFAULT 0 ;
DECLARE v_h14 INTEGER DEFAULT 0 ;
DECLARE v_h15 INTEGER DEFAULT 0 ;
DECLARE v_h16 INTEGER DEFAULT 0 ;
DECLARE v_h17 INTEGER DEFAULT 0 ;
DECLARE v_h18 INTEGER DEFAULT 0 ;
DECLARE v_h19 INTEGER DEFAULT 0 ;
DECLARE v_h20 INTEGER DEFAULT 0 ;
DECLARE v_h21 INTEGER DEFAULT 0 ;
DECLARE v_h22 INTEGER DEFAULT 0 ;
DECLARE v_h23 INTEGER DEFAULT 0 ;
DECLARE v_h24 INTEGER DEFAULT 0 ;

--============================================================================
--  Declaring cursor HOUR_CURSR for T_UI_270_CTRL_LOG
--============================================================================

DECLARE HOUR_CURSR CURSOR FOR SELECT hour(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day  ))
and EVNT_TYPE = 'E' or EVNT_TYPE = 'O' or EVNT_TYPE = 'W';

--=============================================================================
--	Retreiving the count of hour of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(hour(UI.TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 day  ))
and EVNT_TYPE = 'E' or EVNT_TYPE = 'O' or EVNT_TYPE = 'W';

--=============================================================================
--	Opening cursor HOUR_CURSR
--=============================================================================

OPEN HOUR_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM HOUR_CURSR INTO v_hour;--
		
		CASE v_hour

		WHEN 1 THEN
		
		SET v_h1 = v_h1 +1 ;

		WHEN 2 THEN
		
        SET v_h2 = v_h2 +1 ;
		
		WHEN 3 THEN
		
		SET v_h3 = v_h3 +1 ;
		
		WHEN 4 THEN
		
		SET v_h4 = v_h4 +1 ;
		
		WHEN 5 THEN
		
		SET v_h5 = v_h5 +1 ;
		
		WHEN 6 THEN
		
		SET v_h6 = v_h6 +1 ;
		
		WHEN 7 THEN
		
		SET v_h7 = v_h7 +1 ;
		
		WHEN 8 THEN
		
		SET v_h8 = v_h8 +1 ;
		
		WHEN 9 THEN
		
		SET v_h9 = v_h9 +1 ;
		
		WHEN 10 THEN
		
		SET v_h10 = v_h10 +1 ;
		
		WHEN 11 THEN
		
		SET v_h11 = v_h11 +1 ;
		
		WHEN 12 THEN
		
		SET v_h12 = v_h12 +1 ;
		
		WHEN 13 THEN
		
		SET v_h13 = v_h13 +1 ;
		
		WHEN 14 THEN
		
		SET v_h14 = v_h14 +1 ;
		
		WHEN 15 THEN
		
		SET v_h15 = v_h15 +1 ;
		
		WHEN 16 THEN
		
		SET v_h16 = v_h16 +1 ;
		
		WHEN 17 THEN
		
		SET v_h17 = v_h17 +1 ;
		
		WHEN 18 THEN
		
		SET v_h18 = v_h18 +1 ;
		
		WHEN 19 THEN
		
		SET v_h19 = v_h19 +1 ;
		
		WHEN 20 THEN
		
		SET v_h20 = v_h20 +1 ;
		
		WHEN 21 THEN
		
		SET v_h21 = v_h21 +1 ;
		
		WHEN 22 THEN
		
		SET v_h22 = v_h22 +1 ;
		
		WHEN 23 THEN
		
		SET v_h23 = v_h23 +1 ;
			
		ELSE
		SET v_h24 = v_h24 +1 ;
				
		END CASE ;
		
	SET v_count=v_count-1;--	
		
	END WHILE;--

--=============================================================================
--	Closing cursor HOUR_CURSR
--=============================================================================

CLOSE HOUR_CURSR;--

SET p_h1  = v_h1  ;
SET p_h2  = v_h2  ;
SET p_h3  = v_h3  ;
SET p_h4  = v_h4  ;
SET p_h5  = v_h5  ;
SET p_h6  = v_h6  ;
SET p_h7  = v_h7  ;
SET p_h8  = v_h8  ;
SET p_h9  = v_h9  ;
SET p_h10 = v_h10 ;
SET p_h11 = v_h11 ;
SET p_h12 = v_h12 ;
SET p_h13 = v_h13 ;
SET p_h14 = v_h14 ;
SET p_h15 = v_h15 ;
SET p_h16 = v_h16 ;
SET p_h17 = v_h17 ;
SET p_h18 = v_h18 ;
SET p_h19 = v_h19 ;
SET p_h20 = v_h20 ;
SET p_h21 = v_h21 ;
SET p_h22 = v_h22 ;
SET p_h23 = v_h23 ;
SET p_h24 = v_h24 ;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_WEEKLYERRORTRANSACTIONS')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_WEEKLYERRORTRANSACTIONS 
	(
	IN  err_cd  INTEGER,
    OUT p_mon	INTEGER,
	OUT p_tue	INTEGER,
	OUT p_wed	INTEGER,
	OUT p_thu	INTEGER,
	OUT p_fri	INTEGER,
	OUT p_sat	INTEGER,
	OUT p_sun	INTEGER
    )
  
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_day VARCHAR(20);--
DECLARE v_count INTEGER;--
DECLARE v_mon INTEGER DEFAULT 0 ; 
DECLARE v_tue INTEGER DEFAULT 0 ; 
DECLARE v_wed INTEGER DEFAULT 0 ; 
DECLARE v_thu INTEGER DEFAULT 0 ; 
DECLARE v_fri INTEGER DEFAULT 0 ; 
DECLARE v_sat INTEGER DEFAULT 0 ; 
DECLARE v_sun INTEGER DEFAULT 0 ; 

--============================================================================
--  Declaring cursor D_CURSR for T_UI_270_CTRL_LOG
--============================================================================

DECLARE D_CURSR CURSOR FOR SELECT DAYNAME(TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG where TRAN_ERR_CD = err_cd and 
TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 7 days));--

--=============================================================================
--	Retreiving the count of hour of UI.TRAN_END_TS from the Table 
--  T_UI_270_CTRL_LOG based on TRAN_ERR_CD
--=============================================================================

SELECT COUNT(DAYNAME(TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG where TRAN_ERR_CD = err_cd and 
TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 7 days));--

OPEN D_CURSR;--

	WHILE (v_count <> 0)

	DO 

		FETCH FROM D_CURSR INTO v_day;
		
		CASE v_day

		WHEN 'Monday' THEN
		
		SET v_mon = v_mon +1 ;

		WHEN 'Tuesday' THEN
        SET v_tue = v_tue +1 ;
		
		WHEN 'Wednesday' THEN
		
		SET v_wed = v_wed +1 ;
		
		WHEN 'Thursday' THEN
		
		SET v_thu = v_thu +1 ;
		
		WHEN 'Friday' THEN
		
		SET v_fri = v_fri +1 ;
		
		WHEN 'Saturday' THEN
		
		SET v_sat = v_sat +1 ;
		ELSE 
		SET v_sun = v_sun +1 ;
				
		END  CASE ;
		SET v_count=v_count-1;--				
	END WHILE ;

CLOSE D_CURSR ; 

SET p_mon = v_mon ;
SET p_tue = v_tue ;
SET p_wed = v_wed ;
SET p_thu = v_thu ;
SET p_fri = v_fri ;
SET p_sat = v_sat ;
SET p_sun = v_sun ;
END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_WEEKLYERRORTRANSACTIONS_TOTAL')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_WEEKLYERRORTRANSACTIONS_TOTAL 
	(
    OUT p_mon	INTEGER,
	OUT p_tue	INTEGER,
	OUT p_wed	INTEGER,
	OUT p_thu	INTEGER,
	OUT p_fri	INTEGER,
	OUT p_sat	INTEGER,
	OUT p_sun	INTEGER
     )
  
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_day VARCHAR(20);--
DECLARE v_count INTEGER;--
DECLARE v_mon INTEGER DEFAULT 0 ; 
DECLARE v_tue INTEGER DEFAULT 0 ; 
DECLARE v_wed INTEGER DEFAULT 0 ; 
DECLARE v_thu INTEGER DEFAULT 0 ; 
DECLARE v_fri INTEGER DEFAULT 0 ; 
DECLARE v_sat INTEGER DEFAULT 0 ; 
DECLARE v_sun INTEGER DEFAULT 0 ; 

--============================================================================
--  Declaring cursor D_CURSR for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D_CURSR CURSOR FOR SELECT DAYNAME(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 7 days )) ;--

--=============================================================================
--	Retreiving the count of DAYNAME of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(DAYNAME(UI.TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 7 days )) ;--

--=============================================================================
--	Opening cursor HOUR_CURSR
--=============================================================================

OPEN D_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM D_CURSR INTO v_day;
		
		CASE v_day

		WHEN 'Monday' THEN
		
		SET v_mon = v_mon +1 ;

		WHEN 'Tuesday' THEN
        SET v_tue = v_tue +1 ;
		
		WHEN 'Wednesday' THEN
		
		SET v_wed = v_wed +1 ;
		
		WHEN 'Thursday' THEN
		
		SET v_thu = v_thu +1 ;
		
		WHEN 'Friday' THEN
		
		SET v_fri = v_fri +1 ;
		
		WHEN 'Saturday' THEN
		
		SET v_sat = v_sat +1 ;
		ELSE 
		SET v_sun = v_sun +1 ;
				
		END  CASE ;
		SET v_count=v_count-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor HOUR_CURSR
--=============================================================================

CLOSE D_CURSR ; 

SET p_mon = v_mon ;
SET p_tue = v_tue ;
SET p_wed = v_wed ;
SET p_thu = v_thu ;
SET p_fri = v_fri ;
SET p_sat = v_sat ;
SET p_sun = v_sun ;
END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_WEEKLYERRORTRANSACTIONS_EOW')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_WEEKLYERRORTRANSACTIONS_EOW 
	(
    OUT p_mon	INTEGER,
	OUT p_tue	INTEGER,
	OUT p_wed	INTEGER,
	OUT p_thu	INTEGER,
	OUT p_fri	INTEGER,
	OUT p_sat	INTEGER,
	OUT p_sun	INTEGER,
	OUT p1_mon	INTEGER,
	OUT p1_tue	INTEGER,
	OUT p1_wed	INTEGER,
	OUT p1_thu	INTEGER,
	OUT p1_fri	INTEGER,
	OUT p1_sat	INTEGER,
	OUT p1_sun	INTEGER,
	OUT p2_mon	INTEGER,
	OUT p2_tue	INTEGER,
	OUT p2_wed	INTEGER,
	OUT p2_thu	INTEGER,
	OUT p2_fri	INTEGER,
	OUT p2_sat	INTEGER,
	OUT p2_sun	INTEGER,
	OUT p3_mon	INTEGER,
	OUT p3_tue	INTEGER,
	OUT p3_wed	INTEGER,
	OUT p3_thu	INTEGER,
	OUT p3_fri	INTEGER,
	OUT p3_sat	INTEGER,
	OUT p3_sun	INTEGER
     )
  
  LANGUAGE SQL
  
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_day VARCHAR(20);--
DECLARE v1_day VARCHAR(20);
DECLARE v2_day VARCHAR(20);
DECLARE v3_day VARCHAR(20);
DECLARE v_count INTEGER;
DECLARE v_count1 INTEGER ;--
DECLARE v_count2 INTEGER ;
DECLARE v_count3 INTEGER ;
DECLARE v_mon INTEGER DEFAULT 0 ; 
DECLARE v_tue INTEGER DEFAULT 0 ; 
DECLARE v_wed INTEGER DEFAULT 0 ; 
DECLARE v_thu INTEGER DEFAULT 0 ; 
DECLARE v_fri INTEGER DEFAULT 0 ; 
DECLARE v_sat INTEGER DEFAULT 0 ; 
DECLARE v_sun INTEGER DEFAULT 0 ; 
DECLARE v1_mon INTEGER DEFAULT 0 ; 
DECLARE v1_tue INTEGER DEFAULT 0 ; 
DECLARE v1_wed INTEGER DEFAULT 0 ; 
DECLARE v1_thu INTEGER DEFAULT 0 ; 
DECLARE v1_fri INTEGER DEFAULT 0 ; 
DECLARE v1_sat INTEGER DEFAULT 0 ; 
DECLARE v1_sun INTEGER DEFAULT 0 ;
DECLARE v2_mon INTEGER DEFAULT 0 ; 
DECLARE v2_tue INTEGER DEFAULT 0 ; 
DECLARE v2_wed INTEGER DEFAULT 0 ; 
DECLARE v2_thu INTEGER DEFAULT 0 ; 
DECLARE v2_fri INTEGER DEFAULT 0 ; 
DECLARE v2_sat INTEGER DEFAULT 0 ; 
DECLARE v2_sun INTEGER DEFAULT 0 ;
DECLARE v3_mon INTEGER DEFAULT 0 ; 
DECLARE v3_tue INTEGER DEFAULT 0 ; 
DECLARE v3_wed INTEGER DEFAULT 0 ; 
DECLARE v3_thu INTEGER DEFAULT 0 ; 
DECLARE v3_fri INTEGER DEFAULT 0 ; 
DECLARE v3_sat INTEGER DEFAULT 0 ; 
DECLARE v3_sun INTEGER DEFAULT 0 ;   

--============================================================================
--  Declaring cursor D_CURSR for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D_CURSR  CURSOR FOR SELECT DAYNAME(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'E' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 7 days  ));

--============================================================================
--  Declaring cursor D_CURSR1 for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D_CURSR1 CURSOR FOR SELECT DAYNAME(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'O' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 7 days  ));

--============================================================================
--  Declaring cursor D_CURSR2 for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D_CURSR2  CURSOR FOR SELECT DAYNAME(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'W' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 7 days));

--============================================================================
--  Declaring cursor D_CURSR3 for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D_CURSR3  CURSOR FOR SELECT DAYNAME(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where
TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 7 days))
and EVNT_TYPE = 'E' or EVNT_TYPE = 'O' or EVNT_TYPE = 'W';

--=============================================================================
--	Retreiving the count of DAYNAME of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(DAYNAME(UI.TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'E' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 7 days  ));

--=============================================================================
--	Opening cursor D_CURSR
--=============================================================================

OPEN D_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM D_CURSR INTO v_day;
		
		CASE v_day

		WHEN 'Monday' THEN
		
		SET v_mon = v_mon +1 ;

		WHEN 'Tuesday' THEN
        SET v_tue = v_tue +1 ;
		
		WHEN 'Wednesday' THEN
		
		SET v_wed = v_wed +1 ;
		
		WHEN 'Thursday' THEN
		
		SET v_thu = v_thu +1 ;
		
		WHEN 'Friday' THEN
		
		SET v_fri = v_fri +1 ;
		
		WHEN 'Saturday' THEN
		
		SET v_sat = v_sat +1 ;
		ELSE 
		SET v_sun = v_sun +1 ;
		END  CASE ;
		SET v_count=v_count-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor D_CURSR
--=============================================================================

CLOSE D_CURSR; 

SET p_mon = v_mon ;
SET p_tue = v_tue ;
SET p_wed = v_wed ;
SET p_thu = v_thu ;
SET p_fri = v_fri ;
SET p_sat = v_sat ;
SET p_sun = v_sun ;

--=============================================================================
--	Retreiving the count of DAYNAME of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(DAYNAME(UI.TRAN_END_TS)) into v_count1 FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'O' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 7 days));

--=============================================================================
--	Opening cursor D_CURSR1
--=============================================================================

OPEN D_CURSR1 ;--

	WHILE (v_count1 <> 0)
	DO 

		FETCH FROM D_CURSR1 INTO v1_day;
		
		CASE v1_day

		WHEN 'Monday' THEN
		
		SET v1_mon = v1_mon +1 ;

		WHEN 'Tuesday' THEN
        SET v1_tue = v1_tue +1 ;
		
		WHEN 'Wednesday' THEN
		
		SET v1_wed = v1_wed +1 ;
		
		WHEN 'Thursday' THEN
		
		SET v1_thu = v1_thu +1 ;
		
		WHEN 'Friday' THEN
		
		SET v1_fri = v1_fri +1 ;
		
		WHEN 'Saturday' THEN
		
		SET v1_sat = v1_sat +1 ;
		ELSE 
		SET v1_sun = v1_sun +1 ;
			
		END  CASE ;
		SET v_count1=v_count1-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor D_CURSR1
--=============================================================================

CLOSE D_CURSR1 ; 

SET p1_mon = v1_mon ;
SET p1_tue = v1_tue ;
SET p1_wed = v1_wed ;
SET p1_thu = v1_thu ;
SET p1_fri = v1_fri ;
SET p1_sat = v1_sat ;
SET p1_sun = v1_sun ;

--=============================================================================
--	Retreiving the count of DAYNAME of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(DAYNAME(UI.TRAN_END_TS)) into v_count2 FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'W' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 7 days  ));

--=============================================================================
--	Opening cursor D_CURSR2
--=============================================================================

OPEN D_CURSR2;--

	WHILE (v_count2 <> 0)

	DO 

		FETCH FROM D_CURSR2 INTO v2_day;
		
		CASE v2_day

		WHEN 'Monday' THEN
		
		SET v2_mon = v2_mon +1 ;

		WHEN 'Tuesday' THEN
        SET v2_tue = v2_tue +1 ;
		
		WHEN 'Wednesday' THEN
		
		SET v2_wed = v2_wed +1 ;
		
		WHEN 'Thursday' THEN
		
		SET v2_thu = v2_thu +1 ;
		
		WHEN 'Friday' THEN
		
		SET v2_fri = v2_fri +1 ;
		
		WHEN 'Saturday' THEN
		
		SET v2_sat = v2_sat +1 ;
		ELSE 
		SET v2_sun = v2_sun +1 ;
		
		
		END CASE ;
		SET v_count2=v_count2-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor D_CURSR2
--=============================================================================

CLOSE D_CURSR2 ; 

SET p2_mon = v2_mon ;
SET p2_tue = v2_tue ;
SET p2_wed = v2_wed ;
SET p2_thu = v2_thu ;
SET p2_fri = v2_fri ;
SET p2_sat = v2_sat ;
SET p2_sun = v2_sun ;

--=============================================================================
--	Retreiving the count of DAYNAME of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(DAYNAME(UI.TRAN_END_TS)) into v_count3 FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where 
TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 7 days  ))
and EVNT_TYPE = 'E' or EVNT_TYPE = 'O' or EVNT_TYPE = 'W';

--=============================================================================
--	Opening cursor D_CURSR3
--=============================================================================

OPEN D_CURSR3 ;--

	WHILE (v_count3 <> 0)
	DO 

		FETCH FROM D_CURSR3 INTO v3_day;
		
		CASE v3_day

		WHEN 'Monday' THEN
		
		SET v3_mon = v3_mon +1 ;

		WHEN 'Tuesday' THEN
        SET v3_tue = v3_tue +1 ;
		
		WHEN 'Wednesday' THEN
		
		SET v3_wed = v3_wed +1 ;
		
		WHEN 'Thursday' THEN
		
		SET v3_thu = v3_thu +1 ;
		
		WHEN 'Friday' THEN
		
		SET v3_fri = v3_fri +1 ;
		
		WHEN 'Saturday' THEN
		
		SET v3_sat = v3_sat +1 ;
		ELSE 
		SET v3_sun = v3_sun +1 ;
		
		END  CASE ;
		SET v_count3=v_count3-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor D_CURSR3
--=============================================================================

CLOSE D_CURSR3 ; 

SET p3_mon = v3_mon ;
SET p3_tue = v3_tue ;
SET p3_wed = v3_wed ;
SET p3_thu = v3_thu ;
SET p3_fri = v3_fri ;
SET p3_sat = v3_sat ;
SET p3_sun = v3_sun ;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_MONTHLYERRORTRANSACTIONS')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_MONTHLYERRORTRANSACTIONS 
	(
	IN  err_cd  INTEGER,
    OUT p_jan	INTEGER,
	OUT p_feb	INTEGER,
	OUT p_mar	INTEGER,
	OUT p_apr	INTEGER,
	OUT p_may	INTEGER,
	OUT p_june	INTEGER,
	OUT p_july	INTEGER,
	OUT p_aug	INTEGER,
	OUT p_sep	INTEGER,
	OUT p_oct	INTEGER,
	OUT p_nov	INTEGER,
	OUT p_dec	INTEGER	
    )
  
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_month INTEGER ;--
DECLARE v_count INTEGER;--
DECLARE v_jan  INTEGER DEFAULT 0 ; 
DECLARE v_feb  INTEGER DEFAULT 0 ; 
DECLARE v_mar  INTEGER DEFAULT 0 ; 
DECLARE v_apr  INTEGER DEFAULT 0 ; 
DECLARE v_may  INTEGER DEFAULT 0 ; 
DECLARE v_june INTEGER DEFAULT 0 ; 
DECLARE v_july INTEGER DEFAULT 0 ; 
DECLARE v_aug  INTEGER DEFAULT 0 ;
DECLARE v_sep  INTEGER DEFAULT 0 ;
DECLARE v_oct  INTEGER DEFAULT 0 ;
DECLARE v_nov  INTEGER DEFAULT 0 ;
DECLARE v_dec  INTEGER DEFAULT 0 ;

--============================================================================
--  Declaring cursor D_CURSR for T_UI_270_CTRL_LOG
--============================================================================

DECLARE D_CURSR CURSOR FOR SELECT month(TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG where TRAN_ERR_CD = err_cd and 
TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 month));

--=============================================================================
--	Retreiving the count of month of TRAN_END_TS from the Table T_UI_270_CTRL_LOG based on TRAN_ERR_CD
--=============================================================================

SELECT COUNT(month(TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG where TRAN_ERR_CD = err_cd and 
TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 month));--

--=============================================================================
--	Opening cursor D_CURSR
--=============================================================================

OPEN D_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM D_CURSR INTO v_month;
		
		CASE v_month

		WHEN 01 THEN
		
		SET v_jan = v_jan +1 ;

		WHEN 02 THEN
        
        SET v_feb = v_feb +1 ;
		
		WHEN 03 THEN
		
		SET v_mar = v_mar +1 ;
		
		WHEN 04  THEN
		
		SET v_apr = v_apr +1 ;
		
		WHEN 05 THEN
		
		SET v_may = v_may +1 ;
		
		WHEN 06 THEN
		
		SET v_june = v_june +1 ;
		
		WHEN 07 THEN
		
		SET v_july = v_july +1 ;
		
		WHEN 08 THEN
		
		SET v_aug = v_aug +1 ;
		
		WHEN 09 THEN
		
		SET v_sep = v_sep +1 ;
		
		WHEN 10 THEN
		
		SET v_oct = v_oct +1 ;
		
		WHEN 11 THEN
		
		SET v_nov = v_nov +1 ;
		
		ELSE 
		
		SET v_dec = v_dec +1 ;
		
		END  CASE ;
		SET v_count=v_count-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor D_CURSR
--=============================================================================
	
CLOSE D_CURSR ; 

SET p_jan  = v_jan  ;
SET p_feb  = v_feb  ;
SET p_mar  = v_mar  ;
SET p_apr  = v_apr  ;
SET p_may  = v_may  ;
SET p_june = v_june ;
SET p_july = v_july ;
SET p_aug  = v_aug  ;
SET p_sep  = v_sep  ;
SET p_oct  = v_oct  ;
SET p_nov  = v_nov  ;
SET p_dec  = v_dec  ;
END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_MONTHLYERRORTRANSACTIONS_TOTAL')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_MONTHLYERRORTRANSACTIONS_TOTAL 
	(
    OUT p_jan	INTEGER,
	OUT p_feb	INTEGER,
	OUT p_mar	INTEGER,
	OUT p_apr	INTEGER,
	OUT p_may	INTEGER,
	OUT p_june	INTEGER,
	OUT p_july	INTEGER,
	OUT p_aug	INTEGER,
	OUT p_sep	INTEGER,
	OUT p_oct	INTEGER,
	OUT p_nov	INTEGER,
	OUT p_dec	INTEGER	
     )
  
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_month INTEGER ;--
DECLARE v_count INTEGER;--
DECLARE v_jan  INTEGER DEFAULT 0 ; 
DECLARE v_feb  INTEGER DEFAULT 0 ; 
DECLARE v_mar  INTEGER DEFAULT 0 ; 
DECLARE v_apr  INTEGER DEFAULT 0 ; 
DECLARE v_may  INTEGER DEFAULT 0 ; 
DECLARE v_june INTEGER DEFAULT 0 ; 
DECLARE v_july INTEGER DEFAULT 0 ; 
DECLARE v_aug  INTEGER DEFAULT 0 ;
DECLARE v_sep  INTEGER DEFAULT 0 ;
DECLARE v_oct  INTEGER DEFAULT 0 ;
DECLARE v_nov  INTEGER DEFAULT 0 ;
DECLARE v_dec  INTEGER DEFAULT 0 ;

--============================================================================
--  Declaring cursor D_CURSR for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D_CURSR CURSOR FOR SELECT month(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 month));

--=============================================================================
--	Retreiving the count of month of UI.TRAN_END_TS from the Table 
--	T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(month(TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT 
ON UI.TRAN_ERR_CD = EVT.EVNT_CD where TRAN_END_TS <= (values(current timestamp)) and
TRAN_END_TS >=(values(current timestamp - 1 month));

--=============================================================================
--	Opening cursor D_CURSR
--=============================================================================

OPEN D_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM D_CURSR INTO v_month;
		
		CASE v_month

		WHEN 01 THEN
		
		SET v_jan = v_jan +1 ;

		WHEN 02 THEN
        
        SET v_feb = v_feb +1 ;
		
		WHEN 03 THEN
		
		SET v_mar = v_mar +1 ;
		
		WHEN 04  THEN
		
		SET v_apr = v_apr +1 ;
		
		WHEN 05 THEN
		
		SET v_may = v_may +1 ;
		
		WHEN 06 THEN
		
		SET v_june = v_june +1 ;
		
		WHEN 07 THEN
		
		SET v_july = v_july +1 ;
		
		WHEN 08 THEN
		
		SET v_aug = v_aug +1 ;
		
		WHEN 09 THEN
		
		SET v_sep = v_sep +1 ;
		
		WHEN 10 THEN
		
		SET v_oct = v_oct +1 ;
		
		WHEN 11 THEN
		
		SET v_nov = v_nov +1 ;
		
		ELSE 
		
		SET v_dec = v_dec +1 ;
		
		END  CASE ;
		SET v_count=v_count-1;--				
	END WHILE ;

--=============================================================================
--	Opening cursor D_CURSR
--=============================================================================

CLOSE D_CURSR ; 

SET p_jan  = v_jan  ;
SET p_feb  = v_feb  ;
SET p_mar  = v_mar  ;
SET p_apr  = v_apr  ;
SET p_may  = v_may  ;
SET p_june = v_june ;
SET p_july = v_july ;
SET p_aug  = v_aug  ;
SET p_sep  = v_sep  ;
SET p_oct  = v_oct  ;
SET p_nov  = v_nov  ;
SET p_dec  = v_dec  ;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_270_MONTHLYERRORTRANSACTIONS_EOW')@

CREATE PROCEDURE EDIDB2A.SP_UI_270_MONTHLYERRORTRANSACTIONS_EOW 
	(
    OUT p_jan	INTEGER,
	OUT p_feb	INTEGER,
	OUT p_mar	INTEGER,
	OUT p_apr	INTEGER,
	OUT p_may	INTEGER,
	OUT p_june	INTEGER,
	OUT p_july	INTEGER,
	OUT p_aug	INTEGER,
	OUT p_sep	INTEGER,
	OUT p_oct	INTEGER,
	OUT p_nov	INTEGER,
	OUT p_dec	INTEGER,	
	OUT p1_jan	INTEGER,
	OUT p1_feb	INTEGER,
	OUT p1_mar	INTEGER,
	OUT p1_apr	INTEGER,
	OUT p1_may	INTEGER,
	OUT p1_june	INTEGER,
	OUT p1_july	INTEGER,
	OUT p1_aug	INTEGER,
	OUT p1_sep	INTEGER,
	OUT p1_oct	INTEGER,
	OUT p1_nov	INTEGER,
	OUT p1_dec	INTEGER,	
	OUT p2_jan	INTEGER,
	OUT p2_feb	INTEGER,
	OUT p2_mar	INTEGER,
	OUT p2_apr	INTEGER,
	OUT p2_may	INTEGER,
	OUT p2_june	INTEGER,
	OUT p2_july	INTEGER,
	OUT p2_aug	INTEGER,
	OUT p2_sep	INTEGER,
	OUT p2_oct	INTEGER,
	OUT p2_nov	INTEGER,
	OUT p2_dec	INTEGER,	
	OUT p3_jan	INTEGER,
	OUT p3_feb	INTEGER,
	OUT p3_mar	INTEGER,
	OUT p3_apr	INTEGER,
	OUT p3_may	INTEGER,
	OUT p3_june	INTEGER,
	OUT p3_july	INTEGER,
	OUT p3_aug	INTEGER,
	OUT p3_sep	INTEGER,
	OUT p3_oct	INTEGER,
	OUT p3_nov	INTEGER,
	OUT p3_dec	INTEGER	
     )
  
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_month INTEGER ;--
DECLARE v_count INTEGER;--
DECLARE v_jan  INTEGER DEFAULT 0 ; 
DECLARE v_feb  INTEGER DEFAULT 0 ; 
DECLARE v_mar  INTEGER DEFAULT 0 ; 
DECLARE v_apr  INTEGER DEFAULT 0 ; 
DECLARE v_may  INTEGER DEFAULT 0 ; 
DECLARE v_june INTEGER DEFAULT 0 ; 
DECLARE v_july INTEGER DEFAULT 0 ; 
DECLARE v_aug  INTEGER DEFAULT 0 ;
DECLARE v_sep  INTEGER DEFAULT 0 ;
DECLARE v_oct  INTEGER DEFAULT 0 ;
DECLARE v_nov  INTEGER DEFAULT 0 ;
DECLARE v_dec  INTEGER DEFAULT 0 ;
DECLARE v1_month INTEGER ;--
DECLARE v1_count INTEGER;--
DECLARE v1_jan  INTEGER DEFAULT 0 ; 
DECLARE v1_feb  INTEGER DEFAULT 0 ; 
DECLARE v1_mar  INTEGER DEFAULT 0 ; 
DECLARE v1_apr  INTEGER DEFAULT 0 ; 
DECLARE v1_may  INTEGER DEFAULT 0 ; 
DECLARE v1_june INTEGER DEFAULT 0 ; 
DECLARE v1_july INTEGER DEFAULT 0 ; 
DECLARE v1_aug  INTEGER DEFAULT 0 ;
DECLARE v1_sep  INTEGER DEFAULT 0 ;
DECLARE v1_oct  INTEGER DEFAULT 0 ;
DECLARE v1_nov  INTEGER DEFAULT 0 ;
DECLARE v1_dec  INTEGER DEFAULT 0 ;
DECLARE v2_month INTEGER ;--
DECLARE v2_count INTEGER;--
DECLARE v2_jan  INTEGER DEFAULT 0 ; 
DECLARE v2_feb  INTEGER DEFAULT 0 ; 
DECLARE v2_mar  INTEGER DEFAULT 0 ; 
DECLARE v2_apr  INTEGER DEFAULT 0 ; 
DECLARE v2_may  INTEGER DEFAULT 0 ; 
DECLARE v2_june INTEGER DEFAULT 0 ; 
DECLARE v2_july INTEGER DEFAULT 0 ; 
DECLARE v2_aug  INTEGER DEFAULT 0 ;
DECLARE v2_sep  INTEGER DEFAULT 0 ;
DECLARE v2_oct  INTEGER DEFAULT 0 ;
DECLARE v2_nov  INTEGER DEFAULT 0 ;
DECLARE v2_dec  INTEGER DEFAULT 0 ;
DECLARE v3_month INTEGER ;--
DECLARE v3_count INTEGER;--
DECLARE v3_jan  INTEGER DEFAULT 0 ; 
DECLARE v3_feb  INTEGER DEFAULT 0 ; 
DECLARE v3_mar  INTEGER DEFAULT 0 ; 
DECLARE v3_apr  INTEGER DEFAULT 0 ; 
DECLARE v3_may  INTEGER DEFAULT 0 ; 
DECLARE v3_june INTEGER DEFAULT 0 ; 
DECLARE v3_july INTEGER DEFAULT 0 ; 
DECLARE v3_aug  INTEGER DEFAULT 0 ;
DECLARE v3_sep  INTEGER DEFAULT 0 ;
DECLARE v3_oct  INTEGER DEFAULT 0 ;
DECLARE v3_nov  INTEGER DEFAULT 0 ;
DECLARE v3_dec  INTEGER DEFAULT 0 ;

--============================================================================
--  Declaring cursor D_CURSR for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D_CURSR  CURSOR FOR SELECT hour(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'E' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 1 month));

--============================================================================
--  Declaring cursor D1_CURSR for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D1_CURSR  CURSOR FOR SELECT hour(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'O' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 1 month));

--============================================================================
--  Declaring cursor D2_CURSR for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D2_CURSR  CURSOR FOR SELECT hour(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'W' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 1 month));

--============================================================================
--  Declaring cursor D3_CURSR for T_UI_270_CTRL_LOG and T_EVNT_METADATA
--============================================================================

DECLARE D3_CURSR  CURSOR FOR SELECT hour(UI.TRAN_END_TS) FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where 
TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 1 month))
and EVNT_TYPE = 'E' or EVNT_TYPE = 'O' or EVNT_TYPE = 'W';

--=============================================================================
--	Retreiving the count of month of UI.TRAN_END_TS from the 
--	Table T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(month(TRAN_END_TS)) into v_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'E' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 1 month));

--=============================================================================
--	Opening cursor D_CURSR
--=============================================================================

OPEN D_CURSR;--

	WHILE (v_count <> 0)
	DO 

		FETCH FROM D_CURSR INTO v_month;
		
		CASE v_month

		WHEN 01 THEN
		
		SET v_jan = v_jan +1 ;

		WHEN 02 THEN
        
        SET v_feb = v_feb +1 ;
		
		WHEN 03 THEN
		
		SET v_mar = v_mar +1 ;
		
		WHEN 04  THEN
		
		SET v_apr = v_apr +1 ;
		
		WHEN 05 THEN
		
		SET v_may = v_may +1 ;
		
		WHEN 06 THEN
		
		SET v_june = v_june +1 ;
		
		WHEN 07 THEN
		
		SET v_july = v_july +1 ;
		
		WHEN 08 THEN
		
		SET v_aug = v_aug +1 ;
		
		WHEN 09 THEN
		
		SET v_sep = v_sep +1 ;
		
		WHEN 10 THEN
		
		SET v_oct = v_oct +1 ;
		
		WHEN 11 THEN
		
		SET v_nov = v_nov +1 ;
		
		ELSE 
		
		SET v_dec = v_dec +1 ;
		
		END  CASE ;
		SET v_count=v_count-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor D_CURSR
--=============================================================================

CLOSE D_CURSR ; 

SET p_jan  = v_jan  ;
SET p_feb  = v_feb  ;
SET p_mar  = v_mar  ;
SET p_apr  = v_apr  ;
SET p_may  = v_may  ;
SET p_june = v_june ;
SET p_july = v_july ;
SET p_aug  = v_aug  ;
SET p_sep  = v_sep  ;
SET p_oct  = v_oct  ;
SET p_nov  = v_nov  ;
SET p_dec  = v_dec  ;

--=============================================================================
--	Retreiving the count of month of UI.TRAN_END_TS from the 
--	Table T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(month(TRAN_END_TS)) into v1_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'O' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 1 month));

--=============================================================================
--	Opening cursor D1_CURSR
--=============================================================================

OPEN D1_CURSR;--

	WHILE (v1_count <> 0)
	DO 

		FETCH FROM D1_CURSR INTO v1_month;
		
		CASE v1_month

		WHEN 01 THEN
		
		SET v1_jan = v2_jan +1 ;

		WHEN 02 THEN
        
        SET v1_feb = v1_feb +1 ;
		
		WHEN 03 THEN
		
		SET v1_mar = v1_mar +1 ;
		
		WHEN 04  THEN
		
		SET v1_apr = v1_apr +1 ;
		
		WHEN 05 THEN
		
		SET v1_may = v1_may +1 ;
		
		WHEN 06 THEN
		
		SET v1_june = v1_june +1 ;
		
		WHEN 07 THEN
		
		SET v1_july = v1_july +1 ;
		
		WHEN 08 THEN
		
		SET v1_aug = v1_aug +1 ;
		
		WHEN 09 THEN
		
		SET v1_sep = v1_sep +1 ;
		
		WHEN 10 THEN
		
		SET v1_oct = v1_oct +1 ;
		
		WHEN 11 THEN
		
		SET v1_nov = v1_nov +1 ;
		
		ELSE 
		
		SET v1_dec = v1_dec +1 ;
		
		END  CASE ;
		SET v1_count=v1_count-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor D1_CURSR
--=============================================================================

CLOSE D1_CURSR ; 

SET p1_jan  = v1_jan  ;
SET p1_feb  = v1_feb  ;
SET p1_mar  = v1_mar  ;
SET p1_apr  = v1_apr  ;
SET p1_may  = v1_may  ;
SET p1_june = v1_june ;
SET p1_july = v1_july ;
SET p1_aug  = v1_aug  ;
SET p1_sep  = v1_sep  ;
SET p1_oct  = v1_oct  ;
SET p1_nov  = v1_nov  ;
SET p1_dec  = v1_dec  ;

--=============================================================================
--	Retreiving the count of month of UI.TRAN_END_TS from the 
--	Table T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(month(TRAN_END_TS)) into v2_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where EVNT_TYPE = 'W' 
and TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 1 month  ));

--=============================================================================
--	Opening cursor D2_CURSR
--=============================================================================

OPEN D2_CURSR;--

	WHILE (v2_count <> 0)
	DO 

		FETCH FROM D2_CURSR INTO v2_month;
		
		CASE v2_month

		WHEN 01 THEN
		
		SET v2_jan = v2_jan +1 ;

		WHEN 02 THEN
        
        SET v2_feb = v2_feb +1 ;
		
		WHEN 03 THEN
		
		SET v2_mar = v2_mar +1 ;
		
		WHEN 04  THEN
		
		SET v2_apr = v2_apr +1 ;
		
		WHEN 05 THEN
		
		SET v2_may = v2_may +1 ;
		
		WHEN 06 THEN
		
		SET v2_june = v2_june +1 ;
		
		WHEN 07 THEN
		
		SET v2_july = v2_july +1 ;
		
		WHEN 08 THEN
		
		SET v2_aug = v2_aug +1 ;
		
		WHEN 09 THEN
		
		SET v2_sep = v2_sep +1 ;
		
		WHEN 10 THEN
		
		SET v2_oct = v2_oct +1 ;
		
		WHEN 11 THEN
		
		SET v2_nov = v2_nov +1 ;
		
		ELSE 
		
		SET v2_dec = v2_dec +1 ;
		
		END  CASE ;
		SET v2_count=v2_count-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor D2_CURSR
--=============================================================================

CLOSE D2_CURSR ; 

SET p2_jan  = v2_jan  ;
SET p2_feb  = v2_feb  ;
SET p2_mar  = v2_mar  ;
SET p2_apr  = v2_apr  ;
SET p2_may  = v2_may  ;
SET p2_june = v2_june ;
SET p2_july = v2_july ;
SET p2_aug  = v2_aug  ;
SET p2_sep  = v2_sep  ;
SET p2_oct  = v2_oct  ;
SET p2_nov  = v2_nov  ;
SET p2_dec  = v2_dec  ;

--=============================================================================
--	Retreiving the count of month of UI.TRAN_END_TS from the 
--	Table T_UI_270_CTRL_LOG UI AND T_EVNT_METADATA EVT based on UI.TRAN_ERR_CD,EVT.EVNT_CD
--=============================================================================

SELECT COUNT(month(TRAN_END_TS)) into v3_count FROM EDIDB2A.T_UI_270_CTRL_LOG UI JOIN EDIDB2A.T_EVNT_METADATA EVT ON UI.TRAN_ERR_CD = EVT.EVNT_CD where 
TRAN_END_TS <= (values(current timestamp)) and TRAN_END_TS >=(values(current timestamp - 1 month  ))
and EVNT_TYPE = 'E' or EVNT_TYPE = 'O' or EVNT_TYPE = 'W';

--=======================================================================7======
--	Opening cursor D3_CURSR
--=============================================================================

OPEN D3_CURSR;--

	WHILE (v3_count <> 0)
	DO 

		FETCH FROM D3_CURSR INTO v3_month;
		
		CASE v3_month

		WHEN 01 THEN
		
		SET v3_jan = v3_jan +1 ;

		WHEN 02 THEN
        
        SET v3_feb = v3_feb +1 ;
		
		WHEN 03 THEN
		
		SET v3_mar = v3_mar +1 ;
		
		WHEN 04  THEN
		
		SET v3_apr = v3_apr +1 ;
		
		WHEN 05 THEN
		
		SET v3_may = v3_may +1 ;
		
		WHEN 06 THEN
		
		SET v3_june = v3_june +1 ;
		
		WHEN 07 THEN
		
		SET v3_july = v3_july +1 ;
		
		WHEN 08 THEN
		
		SET v3_aug = v3_aug +1 ;
		
		WHEN 09 THEN
		
		SET v3_sep = v3_sep +1 ;
		
		WHEN 10 THEN
		
		SET v3_oct = v3_oct +1 ;
		
		WHEN 11 THEN
		
		SET v3_nov = v3_nov +1 ;
		
		ELSE 
		
		SET v3_dec = v3_dec +1 ;
		
		END CASE ;
		SET v3_count=v3_count-1;--				
	END WHILE ;

--=============================================================================
--	Closing cursor D3_CURSR
--=============================================================================

CLOSE D3_CURSR ; 

SET p3_jan  = v3_jan  ;
SET p3_feb  = v3_feb  ;
SET p3_mar  = v3_mar  ;
SET p3_apr  = v3_apr  ;
SET p3_may  = v3_may  ;
SET p3_june = v3_june ;
SET p3_july = v3_july ;
SET p3_aug  = v3_aug  ;
SET p3_sep  = v3_sep  ;
SET p3_oct  = v3_oct  ;
SET p3_nov  = v3_nov  ;
SET p3_dec  = v3_dec  ;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_WEEKLY_BATCH')@

CREATE PROCEDURE EDIDB2A.SP_UI_WEEKLY_BATCH 
	(
	OUT p_270count INTEGER,
	OUT p_276count INTEGER
    )
  SPECIFIC SP_UI_WEEKLY_BATCH
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_270count INTEGER DEFAULT 0 ; 
DECLARE v_276count INTEGER DEFAULT 0 ; 

--=============================================================================
--	Retreiving the count of RCD_TYPE_CD from the Table T_UI_270_CTRL_LOG based on RCD_TYPE_CD
--=============================================================================

SELECT COUNT(RCD_TYPE_CD) INTO v_270count FROM EDIDB2A.T_UI_270_CTRL_LOG WHERE RCD_TYPE_CD = 'Z' and 
TRAN_BG_TS <= (values current timestamp) and TRAN_BG_TS >= (values current timestamp-7 days);

--=============================================================================
--	Retreiving the count of RCD_TYPE_CD from the Table T_UI_276_CTRL_LOG based on RCD_TYPE_CD
--=============================================================================

SELECT COUNT(RCD_TYPE_CD) INTO v_276count FROM EDIDB2A.T_UI_276_CTRL_LOG WHERE RCD_TYPE_CD = 'Z' and 
TRAN_BG_TS <= (values current timestamp) and TRAN_BG_TS >= (values current timestamp-7 days);

SET p_270count = v_270count ;
SET p_276count = v_276count ;

END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_UI_MISSING_ICN')@

CREATE PROCEDURE EDIDB2A.SP_UI_MISSING_ICN 
	(
	OUT p_270count 	INTEGER,
	OUT p_276count	INTEGER,
	OUT p_278count	INTEGER,
	OUT p_total		INTEGER
    )
  SPECIFIC SP_UI_MISSING_ICN
  LANGUAGE SQL
  NOT DETERMINISTIC
  EXTERNAL ACTION
  MODIFIES SQL DATA
  CALLED ON NULL INPUT
  INHERIT SPECIAL REGISTERS
BEGIN

--============================================================================
--  Declare the Local Variables in the procedure
--============================================================================

DECLARE v_270count INTEGER DEFAULT 0 ; 
DECLARE v_276count INTEGER DEFAULT 0 ; 
DECLARE v_278count INTEGER DEFAULT 0 ; 
DECLARE v_total INTEGER DEFAULT 0 ; 

--=============================================================================
--	Retreiving the count of UU_ID from the Table T_UI_270_CTRL_LOG based on INB_ISA_CTRL_NUM and OUTB_ISA_CTRL_NUM
--=============================================================================

SELECT COUNT(UU_ID) INTO v_270count FROM EDIDB2A.T_UI_270_CTRL_LOG WHERE INB_ISA_CTRL_NUM IS NULL OR OUTB_ISA_CTRL_NUM IS NULL;

--=============================================================================
--	Retreiving the count of UU_ID from the Table T_UI_276_CTRL_LOG based on INB_ISA_CTRL_NUM and OUTB_ISA_CTRL_NUM
--=============================================================================

SELECT COUNT(UU_ID) INTO v_276count FROM EDIDB2A.T_UI_276_CTRL_LOG WHERE INB_ISA_CTRL_NUM IS NULL OR OUTB_ISA_CTRL_NUM IS NULL;

SET v_total =  v_270count + v_276count + v_278count ;
SET p_270count = v_270count ;
SET p_276count = v_276count ;
SET p_278count = v_278count ;
SET p_total = v_total ;
END@