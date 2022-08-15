#!/bin/bash
echo on
#######################################################
#Script to install common Tables and stored procedures 
#Author  : Nanaji Veturi
#Date    : Oct/10/2010	
#Project : BCBSM
#Version : 0.1
#######################################################

# Checking Properties File exists or not
# Read the properties file
. ../bcbsm_db_install.properties

if [ -e ../bcbsm_db_install.properties ] ; then

# Connecting to Database
db2 connect to $database_name
db2 set schema $schema_name
# Creates Tables for the Database EDIDBD
db2 -td@ -vf $sourcepath/common/db2_utils.sql
db2 -tvf $sourcepath/common/common_tables.sql
db2 import from $sourcepath/common/T_EVNT_METADATA.del of del messages $sourcepath/common/msg.out "insert into EDIDB2A.T_EVNT_METADATA"

db2 -td@ -vf $sourcepath/common/procs.sql



# Executes the Stored Precedures for the Database EDIDBD
db2 -td@ -vf $sourcepath/common/sequence_numbers.sql
db2 -tvf $sourcepath/common/grant.sql
else
	echo " ***** Properties file does not exist and your Script is Terminated ***** "
fi

db2 COMMIT WORK;
db2 CONNECT RESET;
db2 TERMINATE;
