CALL EDIDB2A.SP_UTIL_DROP( 'PROCEDURE SP_837_EXTRACT_LOCAL_CLAIMS')@

CREATE PROCEDURE EDIDB2A.SP_837_EXTRACT_CLAIMS (
    IN 	p_DEST_ID		VARCHAR(30),
	IN	p_SPLIT_LEVEL	CHAR(1),
	IN	p_ST_THRESHOLD	INTEGER,
    OUT p_outBuffer		CLOB(20000000),
    OUT p_CLM_COUNT		INTEGER,
	OUT p_ERR_CODE 		BIGINT,
	OUT p_ERR_DESC 		VARCHAR(255)
	)
BEGIN
DECLARE v_bpv_ID BIGINT;
DECLARE v_subs_ID BIGINT;
DECLARE v_clm_ID BIGINT;
DECLARE c_clm_ID BIGINT;
DECLARE c_bpv_ID BIGINT;
DECLARE c_subs_ID BIGINT;
DECLARE v_count INTEGER default 0;
DECLARE v_cur_clm_cnt integer;
DECLARE v_tot_clm_cnt integer;
DECLARE v_pat_ID BIGINT ;
DECLARE c_pat_ID BIGINT ; 
DECLARE v_bpv_outBuffer VARCHAR(4000);
DECLARE v_subs_outBuffer VARCHAR(3000);
DECLARE v_pat_outBuffer VARCHAR(3000) ;
DECLARE v_clm_outBuffer CLOB(5M);
DECLARE v_isa_outBuffer VARCHAR(3000);
DECLARE v_gs_outBuffer VARCHAR(3000) ;
DECLARE v_st_outBuffer VARCHAR(3000) ;
DECLARE v_prev_SENDER_ID VARCHAR(15) ;
DECLARE v_SENDER_ID VARCHAR(15) ;
DECLARE v_prev_PAYER_ID  VARCHAR(80) ;
DECLARE v_PAYER_ID  VARCHAR(80) ;
DECLARE v_isa_ID BIGINT;
DECLARE v_gs_ID BIGINT ;
DECLARE v_st_ID BIGINT ;
--==============================================================================
--	Declare a Cursor to retrieve all the Claims for the Local Destination
--	That are ready to be Bulked and group them by the Sender_ID and Payer_ID
--==============================================================================

DECLARE ClaimsCursor CURSOR 
	FOR SELECT 	
			CLAIMS.SNDR_ID as SENDER_ID, 
			CLAIMS.PAYR_ID as PAYER_ID,
			CLAIMS.ISA_ID 	as ISA_ID,	
			CLAIMS.GS_ID 	as GS_ID, 
			CLAIMS.ST_ID 	as ST_ID,
			CLAIMS.PROV_ID 	as PROV_ID, 
			CLAIMS.SUBS_ID 	as SUBS_ID,
			CLAIMS.PAT_ID 	as PAT_ID,
			CLAIMS.CLM_ID as CLAIM_ID  
		FROM 	
			EDIDB2A.T_837_CLM_CTRL_LOG	CLAIMS 
		WHERE	
			CLAIMS.DEST_ID 		= p_DEST_ID 
			AND CLAIMS.CLM_STT_CD	= '10052'
		ORDER BY CLAIMS.SNDR_ID, CLAIMS.PAYR_ID;
			
			
	SET p_outBuffer=' ';
	SET c_bpv_ID = 0 ;
	SET c_subs_ID = 0 ;
	SET c_pat_ID = 0 ;
	SET p_clm_count =0;
	SET p_outBuffer='';
	SET v_cur_clm_cnt = 0;
	
--==============================================================================
--	Used to determine the No. of Claims to be Bundled for this Destination
--==============================================================================

	SELECT 
			COUNT(DEST_ID) INTO v_count 
	FROM 
			EDIDB2A.T_837_CLM_CTRL_LOG 
	WHERE 
			DEST_ID = p_DEST_ID 
			AND CLM_STT_CD='10052';

	SET v_tot_clm_cnt = v_count;

--==============================================================================
--  Open the ClaimsCursor and loop around all the claims in the cursor 
--	to determine when to output the ISA Header and Payer Header or not.
--==============================================================================
OPEN ClaimsCursor;

--==============================================================================
--	Now loop around the Claims Cursor until we consume all the claims found
--	At the Start of the Loop initailize the 
--		Previous SENDER ID and 
--		Previous Payer ID
--==============================================================================
Set v_prev_SENDER_ID = '';
Set v_prev_PAYER_ID = '';

-- Need to set the TP_ID for this Destination
v_TP_ID = ....
v_TP_ID_QUAL = ...

WHILE v_count <> 0
DO
	FETCH FROM ClaimsCursor INTO 
		v_SENDER_ID,v_PAYER_ID, v_isa_ID, v_gs_ID, v_st_ID, v_bpv_ID,v_subs_ID,v_pat_ID,v_clm_ID;
		
	--==============================================================================
	--	Since this Record belongs to a Different SenderId or a Payer Id we need to 
	--	output the ISA GS and ST Records for this Claim
	--==============================================================================
	 -- or (v_prev_PAYER_ID <> v_PAYER_ID )
	 
	IF (v_prev_SENDER_ID <> v_SENDER_ID) THEN
		--	If the Splitting needs to be done for Every Submitter at the ISA Level
		--	then Trigger the Generation of a New ISA Envelope
		IF (p_SPLIT_LEVEL = 'I') THEN
			--	Generate an ISA Segment with Info Specific to the Destination TP
			--	also generate ISA Control No
			CALL EDIDB2A.SP_TP_GENERATE_EDI_ISA(v_TP_ID,v_TP_ID_QUAL, v_isa_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_outBuffer = p_outBuffer || 'ISA' || '*' || v_isa_outBuffer;
			SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);

			CALL EDIDB2A.SP_TP_GENERATE_EDI_GS(v_TP_ID,v_TP_ID_QUAL,'837P', v_gs_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_outBuffer = p_outBuffer || 'GS' || '*' || v_gs_outBuffer;
			SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);
		END IF
			CALL EDIDB2A.SP_TP_GENERATE_EDI_ST(v_TP_ID,v_TP_ID_QUAL,'837P', v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_outBuffer = p_outBuffer || 'ST' || '*' || v_st_outBuffer;
			SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);
		
		--==============================================================================
		--	Since this is a new ISA Header ensure that we also reset the PAYER_ID to 
		--	So that we also force the generation of the Claim Loops
		--==============================================================================
		SET v_prev_SENDER_ID 	= v_SENDER_ID;
		--SET v_prev_PAYER_ID		= v_PAYER_ID;
	ELSE
		--	Check if we are going to exceed the Threshold for this Trading Partner
		if (v_tot_clm_cnt > 5000) and (v_cur_cnt = 5000) then
			CALL EDIDB2A.SP_TP_GENERATE_EDI_ST(v_TP_ID,v_TP_ID_QUAL,'837P', v_st_outBuffer,p_ERR_CODE,p_ERR_DESC);
			SET p_outBuffer = p_outBuffer || 'ST' || '*' || v_st_outBuffer;
			SET p_outBuffer = p_outBuffer || '~' || chr(13) || chr(10);
			SET v_cur_clm_cnt = 0;
			SET v_tot_clm_cnt = v_tot_clm_cnt - 5000;
		end if
	END IF;
	
	--==============================================================================
	--	Retrieve the Billing Provider Loop / Subscriber Loop and the Patient Loop
	--	and send it to the Back End.
	--==============================================================================
	CALL EDIDB2A.SP_837_GET_EDI_BillingProvider(v_bpv_ID, 	v_bpv_outBuffer,p_ERR_CODE,p_ERR_DESC);
	SET p_outBuffer = p_outBuffer || 'PRV' || '*' || v_bpv_outBuffer 	|| '~' || chr(13) || chr(10);

	CALL EDIDB2A.SP_837_GET_EDI_Subscriber(v_subs_ID, 		v_subs_outBuffer,p_ERR_CODE,p_ERR_DESC);
	SET p_outBuffer = p_outBuffer || 'SBR' || '*' || v_subs_outBuffer	|| '~' || chr(13) || chr(10);
	
	--==============================================================================
	--	Checkf if the Claim has a Patient Loop or not and then Output that if
	--	That Loop exists
	--==============================================================================
	IF (COALESCE(v_pat_ID,-1) <> -1) THEN
		if (v_pat_ID <> 0) THEN
			CALL EDIDB2A.SP_837_GET_EDI_PATIENT(v_pat_ID, 			v_pat_outBuffer,p_ERR_CODE,p_ERR_DESC);	
			SET p_outBuffer = p_outBuffer || 'PAT' || '*' || v_pat_outBuffer	|| '~' || chr(13) || chr(10);
		END IF;
	END IF;
	
	--==============================================================================
	--	Retrieve the Claim Blob which contains the CLM Loop and Service Lines
	--	and output that to the Buffer
	--==============================================================================
	CALL EDIDB2A.SP_837_GET_EDI_Claims(v_clm_ID,	v_clm_outBuffer,p_ERR_CODE,p_ERR_DESC);
	SET p_outBuffer = p_outBuffer || v_clm_outBuffer || chr(13) || chr(10); 
	
	--==============================================================================
	--	Increase the No. of Processed Claims Count;
	--	Decrease the Total Claims Count which is used for the Loop Condition
	--==============================================================================
	SET p_CLM_COUNT	= p_CLM_COUNT + 1;
	SET v_cur_clm_cnt 	= v_cur_clm_cnt + 1;
	SET v_count		= v_count - 1;
END WHILE;--
CLOSE ClaimsCursor; 
END@
