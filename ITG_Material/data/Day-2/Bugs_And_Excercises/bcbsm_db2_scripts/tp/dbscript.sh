#!/bin/bash
echo on
#######################################################
#Script to install 837 Tables and stored procedures 
#Author  : Nanaji Veturi
#Date    : jun/02/2010	
#Project : BCBSM
#Version : 0.1
#######################################################

# Checking Properties File exists or not

if [ -e ../bcbsm_db_install.properties ] ; then

# Read the properties file
. ../bcbsm_db_install.properties

# Creates DB2DS30 Database, Buffer Pools, Tablespaces
#db2 -z $sourcepath/Messages/db_creation.out -td@ -vf $sourcepath/bcbsm_db_script/BCBSM_DB_SCRIPT.sql

# Connecting to Database
db2 connect to $database_name
db2 set schema $schema_name


# Creates Tables for the Database EDIDBD
db2 -tvf $sourcepath/tp/tp_tables.sql
#db2 -tvf $sourcepath/tp/t_tp_ins.sql
#db2 -tvf $sourcepath/tp/tran_auth_ins.sql
db2 -tvf $sourcepath/tp/ins_t_tp_sla.sql
#db2 -tvf $sourcepath/tp/t_tp_chnl.sql
db2 import from $sourcepath/tp/T_TP.del of del messages $sourcepath/tp/msg.out "insert into EDIDB2A.T_TP"
db2 import from $sourcepath/tp/T_TP_XREF.del of del messages $sourcepath/tp/msg1.out "insert into EDIDB2A.T_TP_XREF"
db2 import from $sourcepath/tp/T_TP_CHNL.del of del messages $sourcepath/tp/msg2.out "insert into EDIDB2A.T_TP_CHNL"
db2 import from $sourcepath/tp/T_TP_TRAN_AUTH.del of del messages $sourcepath/tp/msg3.out "insert into EDIDB2A.T_TP_TRAN_AUTH"

# Executes the Stored Precedures for the Database EDIDBD
db2 -td@ -vf $sourcepath/tp/tp_procs.sql

# Executes the Grant Statements for the Database EDIDBD
db2 -tvf $sourcepath/tp/grant.sql
else
	echo " ***** Properties file does not exist and your Script is Terminated ***** "
fi

db2 COMMIT WORK;
db2 CONNECT RESET;
db2 TERMINATE;
