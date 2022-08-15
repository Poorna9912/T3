CREATE VIEW EDIDB2A.VIEW_ACK_SEARCH AS 
SELECT 
	'837' AS TRNTYPE,
    A.FILE_ID AS FILE_ID,

    A.FILE_TYPE_CD AS FILE_TYPE_CD,

    A.LOB_CD AS LOB,

    A.FILE_ORGN_CD AS FILE_ORGN_CD,

    A.FILE_STT_CD  AS FILE_STT_CD,

    A.PRNT_FILE_ID PRNT_FILE_ID,

    A.PCES_TS AS ProcessedTS,

    A.SUBM_ID AS SubmitterId,
	A.TEST_CD AS TestIndicator,
	A.ISA_CTRL_NUM AS ISACNTL,
    A.DIR_CD AS DIR,
    A.FILE_ROOT_DTRY_TXT AS FILEROOTDIR,
    A.FILE_SUB_DTRY_TXT AS FILESUBDIR,
    A.FILE_NME AS FILENAME,
    A.FILE_SIZE_CNT AS FILESIZECNT,
  	A.FILE_FMT_CD AS FILEFMTCD,
	A.FILE_VER_ID AS TRANVERNUM,
  	A.CMT_TXT as CMT_TXT,
  	A.RECV_TS

    FROM EDIDB2A.T_837_FILE_PCES_LOG A WHERE A.FILE_STT_CD='10'

    UNION ALL

    SELECT  
       
	'835' AS TRNTYPE,
    B.FILE_ID AS FILE_ID,

    B.FILE_TYPE_CD AS FILE_TYPE_CD,

    B.LOB_TXT AS LOB,

    B.FILE_ORGN_CD AS FILE_ORGN_CD,

    B.FILE_STT_CD  AS FILE_STT_CD,

    B.PRNT_FILE_ID PRNT_FILE_ID,

    B.PCES_TS AS ProcessedTS,

    B.SUBM_ID AS SubmitterId,

    B.TEST_CD AS TestIndicator,

    B.ISA_CTRL_NUM AS ISACNTL,
    
    B.FILE_DIR_IND AS DIR,
    
  	B.FILE_ROOT_DTRY_TXT AS FILEROOTDIR,
  	
  	B.FILE_SUB_DTRY_TXT AS FILESUBDIR,
  	
  	B.FILE_NME AS FILENAME,
  	B.FILE_SIZE_CNT AS FILESIZECNT,
  	B.FILE_FMT_CD AS FILEFMTCD,
  	B.TRAN_VER_NUM AS TRANVERNUM,
  	B.CMT_TXT as CMT_TXT,
  	B.RECV_TS
    FROM EDIDB2A.T_835_FILE_PCES_LOG B WHERE B.FILE_STT_CD='10';