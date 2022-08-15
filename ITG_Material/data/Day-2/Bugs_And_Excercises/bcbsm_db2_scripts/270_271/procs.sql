--=============================================================================
--	Filename:	procs.sql
--	Author:		Nanaji Veturi
--	Date:		AUG/24/2010
--	Description:
--	This file contains the Procedures  for the Transaction 270-271
--=============================================================================


CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_270_MSG_ACKN_INSERT')@


CREATE PROCEDURE EDIDB2A.SP_270_MSG_ACKN_INSERT(
 IN p_TRAN_TYPE CHAR(3),
 IN p_UU_ID BIGINT ,
 IN p_seq_num INTEGER,
 IN p_RCD_TYPE CHAR(1),
 IN p_DIR_IND CHAR(1), 
 IN p_DATA  CLOB, 
 IN p_SndrID CHAR(15),
 IN p_RcvrID VARCHAR(15),
 IN p_ControlNum VARCHAR(9),
 IN p_AcknCode CHAR(1),
 IN p_SyntaxErrCode CHAR(3),
 OUT p_sqlcode INTEGER ) 

 
LANGUAGE SQL 
MODIFIES SQL DATA 
BEGIN 
DECLARE SQLCODE	            INTEGER ;
 DECLARE v_sqlcode 			INTEGER;
 DECLARE v_seq_num1          char(9) ;
 DECLARE v_msgday            integer ;
 DECLARE v_SrcTranTs         TIMESTAMP;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION 
VALUES (SQLCODE) INTO p_sqlcode; 
select dayofyear(current date ) into v_msgday from sysibm.sysdummy1 ;
 select  TRAN_BG_TS into v_SrcTranTs  from T_RT_270_CTRL_LOG where UU_ID = p_UU_ID AND RCD_TYPE_CD = p_RCD_TYPE ;
 INSERT INTO EDIDB2A.T_RT_270_ACKN_MSG 
(UU_ID, RCD_TYPE_CD, DIR_IND, SEQ_NUM, SNDR_ID, RECR_ID, TRAN_TYPE_CD, TRAN_TS, MSG_OBJ, MSG_DAY, SRC_TRAN_CTRL_NUM, SRC_TRAN_TS, TRAN_SET_ACKN_IND, TRAN_SET_SYTX_ERR_CD)
 VALUES
 (p_UU_ID,p_RCD_TYPE, p_DIR_IND,p_seq_num ,p_SndrID,p_RcvrID,p_TRAN_TYPE,CURRENT TIMESTAMP , p_DATA, v_msgday, p_ControlNum,v_SrcTranTs ,p_AcknCode,p_SyntaxErrCode);
 SET p_sqlcode = SQLCODE ;
 END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_270_MSG_EDI_INSERT')@


CREATE PROCEDURE EDIDB2A.SP_270_MSG_EDI_INSERT( 
    IN  p_tran_type CHAR(3),
    IN  p_uu_id BIGINT ,
    IN p_seq_num INTEGER,
	IN p_rcd_type CHAR(1),
	IN p_dir_ind CHAR(1),
	IN p_data  CLOB,
	OUT p_errcode INTEGER,
    OUT p_errdesc VARCHAR(255))
	
LANGUAGE SQL
MODIFIES SQL DATA

BEGIN

--=============================================================================
--	Declaration of variables
--=============================================================================

DECLARE sqlcode	            INTEGER ;
DECLARE v_sqlcode 			INTEGER;
DECLARE v_msgday            integer ;
--======================================================================
--	Setup the EXIT handler for all SQL exceptions
--======================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (sqlcode) INTO v_sqlcode;

--=============================================================================
--	Getting the data from the database
--=============================================================================

select dayofyear(current date ) into v_msgday from sysibm.sysdummy1 ;

--=============================================================================
--	Inserting the data into the table T_RT_270_XML_MSG , T_RT_270_ANSI_MSG

--  Inserting the data into the table  T_RT_271_XML_MSG , T_RT_271_ANSI_MSG
--=============================================================================

IF (p_TRAN_TYPE = '270' ) THEN 

    IF (p_rcd_type = 'L' or p_rcd_type = 'F' or p_rcd_type = 'R' ) THEN 
	 INSERT INTO EDIDB2A.T_RT_270_XML_MSG (UU_ID,RCD_TYPE_CD,DIR_IND,SEQ_NUM,TRAN_TS,MSG_OBJ,MSG_DAY)
	 VALUES (p_uu_id,p_rcd_type,p_dir_ind,p_seq_num,current timestamp,p_data,v_msgday) ;
	 
	       SET v_sqlcode = sqlcode ;
	 	    IF (v_sqlcode = 000) THEN 
			  SET p_ERRCODE = 0 ;
			  SET p_errdesc= 'valid';
			ELSE
			  SET p_ERRCODE = 31030002;
			  SET p_errdesc ='DB2:INSERT STMT FAILED';
			
	        END IF;
	
	 ELSE 
	  
	   INSERT INTO EDIDB2A.T_RT_270_ANSI_MSG (UU_ID,RCD_TYPE_CD,DIR_IND,SEQ_NUM,TRAN_TS,MSG_OBJ,MSG_DAY)
	   VALUES (p_uu_id,p_rcd_type,p_dir_ind,p_seq_num,current timestamp,p_data,v_msgday ) ;
	   SET v_sqlcode = sqlcode ;
	 
	   IF (v_sqlcode = 000) THEN 
			SET p_ERRCODE = 0 ;
			SET p_errdesc= 'valid';
			
		ELSE
			SET p_ERRCODE = 31030003;
			SET p_errdesc ='DB2:INSERT STMT FAILED';

		END IF;
	END IF ;
		
     ELSEIF  (p_tran_type = '271' ) THEN 

     IF (p_RCD_TYPE = 'L' or p_RCD_TYPE = 'F' or p_RCD_TYPE = 'R' ) THEN 
	 INSERT INTO EDIDB2A.T_RT_271_XML_MSG (UU_ID,RCD_TYPE_CD,DIR_IND,SEQ_NUM,TRAN_TS,MSG_OBJ,MSG_DAY)
	 VALUES (p_uu_id,p_rcd_type,p_dir_ind,p_seq_num,current timestamp,p_data,v_msgday ) ;
	 SET v_sqlcode = sqlcode ;
	   
	   IF (v_sqlcode = 000) THEN 
			SET p_ERRCODE = 0 ;
			SET p_errdesc= 'valid';
			
		ELSE
			SET p_ERRCODE = 31530004;
			SET p_errdesc ='DB2:INSERT STMT FAILED';
		
		END IF;
	
	 ELSE  
	 INSERT INTO EDIDB2A.T_RT_271_ANSI_MSG (UU_ID,RCD_TYPE_CD,DIR_IND,SEQ_NUM,TRAN_TS,MSG_OBJ,MSG_DAY)
	 VALUES (p_uu_id,p_rcd_type,p_dir_ind,p_seq_num,current timestamp,p_data,v_msgday ) ;
	 SET v_sqlcode = sqlcode ;
	 
		IF (v_sqlcode = 000) THEN 
			SET p_ERRCODE = 0 ;
			SET p_errdesc= 'valid';
			
		ELSE
			SET p_ERRCODE = 31530005;
			SET p_errdesc ='DB2:INSERT STMT FAILED';
		
		END IF;
END IF ;		

END IF ;
	
END@

