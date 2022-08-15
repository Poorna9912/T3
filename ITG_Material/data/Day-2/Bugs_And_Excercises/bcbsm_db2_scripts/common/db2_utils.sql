--=============================================================================
--	Procedure	: EDIDB2A.SP_UTIL_DROP
--	Description	: Used to Drop any Database object
--	Author		: Jagadish Reddy Bommareddy
--=============================================================================
ECHO Creating Procedure::EDIDB2A.SP_UTIL_DROP@

DROP PROCEDURE EDIDB2A.SP_UTIL_DROP @

CREATE PROCEDURE EDIDB2A.SP_UTIL_DROP( IN statement VARCHAR(1000) ) 
LANGUAGE SQL 
BEGIN 
DECLARE SQLSTATE CHAR(5); 
DECLARE NotThere    CONDITION FOR SQLSTATE '42704'; 
DECLARE NotThereSig CONDITION FOR SQLSTATE '42883'; 
DECLARE EXIT HANDLER FOR NotThere, NotThereSig SET SQLSTATE = '     '; 
SET statement = 'DROP ' || statement; EXECUTE IMMEDIATE statement; 
END@
--=============================================================================
--	Function:	EDIDATE_CCYYMMDD
--	Description:
--		Used to convert a DATE Data type into ANSI X12 DATE FORMAT
--		as a STRING CCYYMMDD
--	Author:	Jagadish Reddy Bommareddy
--=============================================================================
ECHO Creating Function::EDIDATE_CCYYMMDD@
CALL EDIDB2A.SP_UTIL_DROP( 'FUNCTION EDIDB2A.EDIDATE_CCYYMMDD')@

create function EDIDB2A.EDIDATE_CCYYMMDD(p_Date DATE) RETURNS VARCHAR(8)
LANGUAGE SQL
BEGIN ATOMIC
	DECLARE strDate VARCHAR(20);
	DECLARE retDate VARCHAR(20);
	if (coalesce(p_Date,'3000-12-30') <> date('3000-12-30')) THEN
		set strDate = char(p_Date,ISO);
		set retDate = substr(strDate,1,4) || substr(strDate,6,2) || substr(strDate,9,2);
	else
		set retDate = '';
	end if;
	return(retDate);
END@
--=============================================================================
--	Function:	EDIDATE_YYMMDD
--	Description:
--		Used to convert a DATE Data type into ANSI X12 DATE FORMAT
--		as a STRING YYMMDD
--	Author:	Jagadish Reddy Bommareddy
--=============================================================================
ECHO Creating Function::EDIDATE_YYMMDD@

CALL EDIDB2A.SP_UTIL_DROP( 'FUNCTION EDIDB2A.EDIDATE_YYMMDD')@

create function EDIDB2A.EDIDATE_YYMMDD(p_Date DATE) RETURNS VARCHAR(6)
LANGUAGE SQL
BEGIN ATOMIC
	DECLARE strDate VARCHAR(20);
	DECLARE retDate VARCHAR(20);
	if (coalesce(p_Date,'3000-12-30') <> date('3000-12-30')) THEN
		set strDate = char(p_Date,ISO);
		set retDate = substr(strDate,3,2) || substr(strDate,6,2) || substr(strDate,9,2);
	else
		set retDate = '';
	end if;
	return(retDate);
END@

--=============================================================================
--	Function:	EDITIME_HHMM
--	Description:
--		Used to convert a TIME Data type into ANSI X12 TIME FORMAT
--		as a STRING HHMM
--	Author:	Jagadish Reddy Bommareddy
--=============================================================================
ECHO Creating Function:: EDITIME_HHMM@

CALL EDIDB2A.SP_UTIL_DROP( 'FUNCTION EDIDB2A.EDITIME_HHMM')@

create function EDIDB2A.EDITIME_HHMM(p_Time TIME) RETURNS VARCHAR(4)
LANGUAGE SQL
BEGIN ATOMIC
	DECLARE strTime VARCHAR(8);
	DECLARE retTime CHAR(4);
	if (coalesce(p_Time,'00:00:00') <> time('00:00:00')) THEN
		set strTime = char(p_TIME,ISO);
		set retTime = substr(strTime,1,2) || substr(strTime,4,2);
	else
		set retTime = '0000';
	end if;
	return(retTime);
END@



