--=============================================================================
--	Filename: sequence_numbers.sql
--	Author:	  Nanaji Veturi
--	Description:
--	This file contains the list of  stored procedures that
--  are related to the Sequence Numbers used by various processes related to
--  claims processing
--=============================================================================

--=============================================================================
--	Procedure: GETSEQUENCENO
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GETSEQUENCENO')@

CREATE PROCEDURE EDIDB2A.getSequenceNo (OUT seqno CHAR(9))
BEGIN
DECLARE seq_str CHAR(50);
DECLARE seq_nextval INTEGER;

set seq_nextval = NEXT VALUE FOR  EDIDB2A.EDI_MESSAGE_SEQ;
set seq_str = cast( seq_nextval as char(10) );
set seq_str = substr(seq_str,2,10);
set seqno = seq_str;
END@

--=============================================================================
--	Procedure: GET_FILE_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GET_FILE_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.get_file_seq_num (OUT seqno BIGINT)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
	DECLARE seq_nextval BIGINT;
	SET seq_nextval = NEXT VALUE FOR  EDIDB2A.FILE_SEQ ;
	SET seqno = seq_nextval ;
END@

--=============================================================================
--	Procedure: GET_ISA_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GET_ISA_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.get_isa_seq_num (OUT seqno BIGINT)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
	DECLARE seq_nextval BIGINT;
	SET seq_nextval = NEXT VALUE FOR  EDIDB2A.ISA_SEQ ;
	SET seqno = seq_nextval ;
END@

--=============================================================================
--	Procedure: GET_GS_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GET_GS_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.get_gs_seq_num (OUT seqno BIGINT)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
	DECLARE seq_nextval BIGINT;
	SET seq_nextval = NEXT VALUE FOR  EDIDB2A.GS_SEQ ;
	SET seqno = seq_nextval ;
END@

--=============================================================================
--	Procedure: GET_ST_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GET_ST_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.get_st_seq_num (OUT seqno BIGINT)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
	DECLARE seq_nextval BIGINT;
	SET seq_nextval = NEXT VALUE FOR  EDIDB2A.ST_SEQ ;
	SET seqno = seq_nextval ;
END@

--=============================================================================
--	Procedure: GET_PROVIDER_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GET_PROVIDER_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.get_provider_seq_num (OUT seqno BIGINT)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
DECLARE seq_nextval BIGINT;
SET seq_nextval = NEXT VALUE FOR  EDIDB2A.PROVIDER_SEQ ;
SET seqno = seq_nextval ;
END@

--=============================================================================
--	Procedure: GET_SUBSCRIBER_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GET_SUBSCRIBER_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.get_subscriber_seq_num (OUT seqno BIGINT)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
DECLARE seq_nextval BIGINT;

SET seq_nextval = NEXT VALUE FOR  EDIDB2A.SUBSCRIBER_SEQ ;
SET seqno = seq_nextval ;
END@

--=============================================================================
--	Procedure: GET_PATIENT_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GET_PATIENT_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.get_patient_seq_num (OUT seqno BIGINT)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
DECLARE seq_nextval BIGINT;
SET seq_nextval = NEXT VALUE FOR  EDIDB2A.PATIENT_SEQ ;
SET seqno = seq_nextval ;
END@

--=============================================================================
--	Procedure: GET_CLAIM_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GET_CLAIM_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.get_claim_seq_num (OUT seqno BIGINT)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN

DECLARE seq_nextval BIGINT;

SET seq_nextval = NEXT VALUE FOR  EDIDB2A.CLAIM_SEQ ;
SET seqno = seq_nextval ;
END@

--=============================================================================
--	Procedure: GET_SERVLINE_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.GET_SERVLINE_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.get_servline_seq_num (OUT seqno BIGINT)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
DECLARE seq_nextval BIGINT;
SET seq_nextval = NEXT VALUE FOR  EDIDB2A.SERV_LINE_SEQ ;
SET seqno = seq_nextval ;
END@
--=============================================================================
--	Procedure: SP_ALL_GET_SEQ_NUM
--=============================================================================
CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_ALL_GET_SEQ_NUM')@

CREATE PROCEDURE EDIDB2A.SP_ALL_GET_SEQ_NUM
(
	IN p_tran_num 			VARCHAR(5),
	OUT p_seq_nextval  		BIGINT,
	OUT p_sqlcode  			INTEGER
)

LANGUAGE SQL
EXTERNAL ACTION
MODIFIES SQL DATA

BEGIN
--=============================================================================
--	Declaration of variables in the Procedure
--=============================================================================

DECLARE v_tran_num 	    VARCHAR(5);
DECLARE v_sqlcode       INTEGER ; 
DECLARE SQLCODE			INTEGER DEFAULT 000;

--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (SQLCODE) INTO v_sqlcode;
 SET v_tran_num = p_tran_num ;   
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================

CASE  
 
 WHEN v_tran_num = '270' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_270 ;
  
WHEN v_tran_num = '271' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_271;
 
 WHEN v_tran_num = '276' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_276;
 
 WHEN v_tran_num = '277' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_277;
 
 WHEN v_tran_num =  '27812' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_27812;
 
 WHEN v_tran_num = '27813'  THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_27813;
 
  WHEN v_tran_num = '100' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_100;
 
 WHEN v_tran_num = '999' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_999;
 
  WHEN v_tran_num = '997' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_997;
 
  WHEN v_tran_num = '110' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_110;
 
  WHEN v_tran_num = '837' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_837;
 
  WHEN v_tran_num = '834' THEN
 --=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_834;
 
  WHEN v_tran_num = '820' THEN
--=============================================================================
--	Retrieve the Sequence num depending on the transaction
--============================================================================= 
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_820;
 
  WHEN v_tran_num = '835' THEN
 --=============================================================================
--	Retrieve the Sequence num depending on the transaction
--=============================================================================
 SET p_seq_nextval = NEXT VALUE FOR  EDIDB2A.SEQ_835; 
 
  ELSE
--======================================================================
--	Place the value of SQLCODE into the variable p_sqlcode  
--======================================================================
 SET p_sqlcode = 100 ; 

END CASE ;
  
END@