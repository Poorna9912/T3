1) Need to be defined CLAIM_TYPE = ATYPICAL / xOver / Regular
2) Claim State Code = 10051 / 10052 ..... Define LKP Table
CLAIM Level:

Rendering Provider @ Claim Level

2310B-NM101                                                    varchar(3)

2310B-NM102                                                    varchar(1)

2310B-NM108                                                    varchar(2)

2310B-NM109                                                    varchar(80)

2310B-REFG2                                                     varchar(50)




3) Need to add the Fields to T_837_CLM_CTRL_LOG for Rendering Provider(2310B) / Refering Provider(2310
	NM101,NM102,NM103,NM108,NM109
	REFG2
	REF0B
	Rendering Prov Name 2310A
	REN_PROV_NM101  varchar(3)   
	REN_PROV_NM102  varchar(1)
	REN_PROV_NM108  varchar(2) 
	REN_PROV_NM109  varchar(80)
	REN_PROV_REFG2  varchar(50)
	REN_PROV_REF0B
	Referring Prov Name 2420F
	REF_PROV_NM101
	NM102
	NM108
	NM109
	REFG2
	REF0B
	
4) Add the Following Fields to T_
	LX01
	SV101
	SV102
	SV103
	SV104
	SV105
	DTP472_FROM(DOS_FROM)
	DTP472_TO(DOS_FROM)
	Rendering Prov Name 2420A
	REN_PROV_NM101
	NM102
	NM108
	NM109
	REFG2
	REF0B
	Purchased Prov Name 2420B
	PUR_PROV_NM101
	NM102
	NM108
	NM109
	REFG2
	REF0B
	Supervising Prov Name 2420D
	SUP_PROV_NM101
	NM102
	NM108
	NM109
	REFG2
	REF0B
	Ordering Prov Name 2420E
	ORD_PROV_NM101
	NM102
	NM108
	NM109
	REFG2
	REF0B
	Referring Prov Name 2420F
	REF_PROV_NM101
	NM102
	NM108
	NM109
	REFG2
	REF0B
	
