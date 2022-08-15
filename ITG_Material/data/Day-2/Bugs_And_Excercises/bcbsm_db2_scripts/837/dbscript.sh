#!/bin/bash
echo on
###############################################################################
#	Description: Script to install 837 Tables and stored procedures 
#	Author  : Nanaji Veturi
#	Date    : Jun/02/2010	
#	Project : BCBSM
#	Version : 1.0
###############################################################################
# Read the properties file
. ../bcbsm_db_install.properties
# Checking Properties File exists or not

if [ -e ../bcbsm_db_install.properties ] ; then



# Creates DB2DS30 Database, Buffer Pools, Tablespaces
#db2 -z $sourcepath/Messages/db_creation.out -td@ -vf $sourcepath/bcbsm_db_script/BCBSM_DB_SCRIPT.sql

# Connecting to Database
db2 connect to $database_name
db2 set schema $schema_name

# Create the Payer and TAXID tables - these are necessary for BCBSM
db2 -tvf $sourcepath/837/bcbsm_payer_taxid.sql
# Creates Tables for the Database EDIDBD
db2 -tvf $sourcepath/837/837_sequences.sql
db2 -tvf $sourcepath/837/837_tables.sql
db2 import from $sourcepath/837/payerid.del of del messages msg.out "insert into EDIDB2A.PAYERID"
db2 import from $sourcepath/837/taxid.del of del messages msg1.out "insert into EDIDB2A.TAXID"
db2 import from $sourcepath/837/t_837_payerid.del of del messages msg.out "insert into EDIDB2A.T_837_PAYERID"
# Used for Inserting the Seed Data into the Various Dependant Tables
db2 -tvf $sourcepath/837/ins_t_lkp_comm_payer.sql
# Executes the Stored Precedures for the Database EDIDBD
db2 -td@ -vf $sourcepath/837/837_procs.sql
db2 -tvf $sourcepath/837/grant.sql
else
	echo " ***** Properties file does not exist and your Script is Terminated ***** "
fi

db2 COMMIT WORK;
db2 CONNECT RESET;
db2 TERMINATE;
