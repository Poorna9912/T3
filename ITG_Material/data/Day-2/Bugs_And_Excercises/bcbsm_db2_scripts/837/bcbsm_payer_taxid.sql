--=============================================================================
--	PayerId and TaxId Tables are populated and updated by Mainframe Cobol
--	programs on a regular basis. DONT MAKE ANY CHANGES TO THIS.
--	EDI 837 Outbound Data Enrichment Process used this Table for Claim
--	Data Enrichment.
--=============================================================================

CREATE TABLE EDIDB2A.PAYERID(	
	PAYER_ID               CHAR(5)  NOT NULL,
	PAYER_CLM_OFF_NO       CHAR(4)  NOT NULL,
	PAYER_NAME             CHAR(27) NOT NULL,
	PAYER_ADDR             CHAR(33) NOT NULL,
	PAYER_CITY             CHAR(16) NOT NULL,
	PAYER_STATE            CHAR(2)  NOT NULL,
	PAYER_ZIP              CHAR(9)  NOT NULL,
	PAYER_PROF_VEND_CODE   CHAR(2)  NOT NULL,
	PAYER_FAC_VEND_CODE    CHAR(2)  NOT NULL,
	PAYER_SRCE             CHAR(1)  NOT NULL,
	PAYER_CLEARING_HOUSE   CHAR(1)  NOT NULL,
	PAYER_INSURED_ID_EDIT  CHAR(9)  NOT NULL,
	PAYER_EDIT_FILLER      CHAR(9)  NOT NULL,
	PAYER_LAST_UPDATE      DATE     DEFAULT CURRENT DATE,
	PAYER_LAST_UPDATE_TYPE CHAR(1) NOT NULL WITH DEFAULT
);
	 
CREATE UNIQUE INDEX ON PAYERID(PAYER_ID  ASC,PAYER_CLM_OFF_NO  ASC) ;

CREATE TABLE EDIDB2A.TAXID(
	VENDOR_ID		CHAR(1)   NOT NULL,
	TAX_ID			CHAR(15)  NOT NULL,
	UPDATE_DATE		DATE    DEFAULT CURRENT DATE
);

CREATE UNIQUE INDEX1  ON TAXID(VENDOR_ID    ASC,TAX_ID ASC) ;
CREATE INDEX ON TAXID (TAX_ID   ASC);
