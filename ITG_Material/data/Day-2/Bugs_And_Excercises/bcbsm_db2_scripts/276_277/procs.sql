--=============================================================================
--	Filename:	procs.sql
--	Author:		Nanaji Veturi
--	Date:		AUG/24/2010
--	Description:
--	This file contains the Procedures  for the Transaction 276-277
--=============================================================================

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_276_MSG_ACKN_INSERT')@

CREATE PROCEDURE EDIDB2A.SP_276_MSG_ACKN_INSERT( 
    IN p_tran_type CHAR(3),
    IN p_uu_id BIGINT ,
    IN p_seq_num INTEGER, 
	IN p_rcd_type CHAR(1),
	IN p_dir_ind CHAR(1),
	IN p_data  CLOB,
	IN p_sndrID CHAR(15),
    IN p_rcvrID VARCHAR(15),
    IN p_controlNum VARCHAR(9),
    IN p_acknCode CHAR(1),
    IN p_syntaxErrCode CHAR(3),
    IN p_updt_by  VARCHAR(30),
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
DECLARE v_SrcTranTs         TIMESTAMP;
--=============================================================================
--	Setup the EXIT handler for all SQL exceptions
--=============================================================================

DECLARE EXIT HANDLER FOR SQLEXCEPTION
VALUES (sqlcode) INTO v_sqlcode;
--=============================================================================
--	Getting the data from the database
--=============================================================================

select dayofyear(current date ) into v_msgday from sysibm.sysdummy1 ;
select  TRAN_BG_TS into v_SrcTranTs  from EDIDB2A.T_RT_270_CTRL_LOG where UU_ID = p_UU_ID;

--=============================================================================
--	Inserting the data into the table  T_RT_270_ACKN_MSG 
--=============================================================================


INSERT INTO EDIDB2A.T_RT_276_277_ACKN_MSG
	(UU_ID, RCD_TYPE_CD, DIR_IND, SEQ_NUM, SUBM_ID, RECR_ID, TRAN_TYPE_CD,MSG_OBJ, MSG_DAY, SRC_TRAN_CTRL_NUM, SRC_TRAN_TS, TRAN_SET_ACKN_CD, TRAN_TYPE_SYTX_ERR_CD,UPDT_BY,UPDT_TS)
VALUES 
	(p_uu_id,p_rcd_type, p_dir_ind,p_seq_num ,p_sndrID,p_rcvrID,p_tran_type, p_data, v_msgday, p_controlNum,v_srcTranTs ,p_acknCode,p_syntaxErrCode,p_updt_by,CURRENT TIMESTAMP );

SET v_sqlcode = sqlcode ;


		IF (v_sqlcode = 000) THEN 
			SET p_errcode = 0 ;
			SET p_errdesc= 'valid';
			
		ELSE
			SET p_errcode = 31030001;
			SET p_errdesc ='DB2:INSERT STMT FAILED';
		
		END IF;


END@

CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE EDIDB2A.SP_276_MSG_EDI_INSERT')@

CREATE PROCEDURE EDIDB2A.SP_276_MSG_EDI_INSERT( 
	IN p_tran_type CHAR(3),
    IN p_uu_id BIGINT,
    IN p_rcd_type CHAR(1) ,
    IN p_seq_num INTEGER,
	IN p_dir_ind CHAR(1),
	IN p_data CLOB,
	IN p_msg_ts TIMESTAMP,
	OUT P_errcode INTEGER,
    OUT P_errdesc VARCHAR(255))
	
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
--	Inserting the data into the table  T_RT_276_XML_MSG ,T_RT_276_ANSI_MSG
--Inserting the data into the table  T_RT_277_XML_MSG  , T_RT_277_ANSI_MSG
--=============================================================================

IF (p_rcd_type = '276' ) THEN 

     IF (p_rcd_type = 'L' or p_rcd_type = 'F' or p_rcd_type = 'R' ) THEN 
	 INSERT INTO EDIDB2A.T_RT_276_XML_MSG  (UU_ID,RCD_TYPE_CD,DIR_IND,SEQ_NUM,MSG_TS,MSG_OBJ,MSG_DAY)
	 VALUES (p_uu_id,p_rcd_type,p_dir_ind,p_seq_num,current timestamp,p_data,v_msgday) ;
	     SET v_sqlcode = sqlcode ;
	       IF (v_sqlcode = 000) THEN 
			  SET p_errcode = 0 ;
			  SET p_errdesc = 'valid';
			
		   ELSE
			 SET p_errcode = 32030007;
			 SET p_errdesc ='DB2:INSERT STMT FAILED';
			
		   END IF;
			
  ELSE 
  
	 INSERT INTO EDIDB2A.T_RT_276_ANSI_MSG (UU_ID,RCD_TYPE_CD,DIR_IND,SEQ_NUM,MSG_TS,MSG_OBJ,MSG_DAY)
	  VALUES (p_uu_id,p_rcd_type,p_dir_ind,p_seq_num,current timestamp,p_data,v_msgday ) ;
	     SET v_sqlcode = sqlcode ;
	       IF (v_sqlcode = 000) THEN 
			 SET p_errcode = 0 ;
			 SET p_errdesc = 'valid';
			
		   ELSE
			 SET p_errcode = 32030008;
			 SET p_errdesc ='DB2:INSERT STMT FAILED';
			 
	       END IF ; 
	 
 END IF ; 

ELSEIF  (p_rcd_type = '277' ) THEN 
     IF (p_rcd_type = 'L' or p_rcd_type = 'F' or p_rcd_type = 'R' ) THEN 
	 
	 INSERT INTO EDIDB2A.T_RT_277_XML_MSG (UU_ID,RCD_TYPE_CD,DIR_IND,SEQ_NUM,MSG_TS,MSG_OBJ,MSG_DAY)
	 VALUES (p_uu_id,p_rcd_type,p_dir_ind,p_seq_num,current timestamp,p_data,v_msgday ) ;
	     SET v_sqlcode = sqlcode ;
	       IF (v_sqlcode = 000) THEN 
			  SET p_errcode = 0 ;
			  SET p_errdesc = 'valid';
			
		   ELSE
			  SET p_errcode = 32530009;
			  SET p_errdesc ='DB2:INSERT STMT FAILED';
			
	       END IF;	
	       	
	 ELSE 
	  
	 INSERT INTO EDIDB2A.T_RT_277_ANSI_MSG (UU_ID,RCD_TYPE_CD,DIR_IND,SEQ_NUM,MSG_TS,MSG_OBJ,MSG_DAY)
	 VALUES (p_uu_id,p_rcd_type,p_dir_ind,p_seq_num,current timestamp,p_data,v_msgday ) ;
	     SET v_sqlcode = sqlcode ;
            IF (v_sqlcode = 000) THEN 
			   SET p_errcode = 0 ;
			   SET p_errdesc = 'valid';
			
		   ELSE
			   SET p_errcode = 32530010;
			   SET p_errdesc ='DB2:INSERT STMT FAILED';
	 
	       END IF ; 

END IF;

END IF;

END@