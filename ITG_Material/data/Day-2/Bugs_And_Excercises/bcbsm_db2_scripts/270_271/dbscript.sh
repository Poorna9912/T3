#!/bin/bash
echo on
#######################################################
#Script to install 270-271 Tables and stored procedures 
#Author  : Nanaji Veturi
#Date    : jun/02/2010	
#Project : BCBSM
#Version : 0.1
#######################################################

# Checking Properties File exists or not

if [ -e ./bcbsm_db_install.properties ] ; then

# Read the properties file
. ./bcbsm_db_install.properties



# Connecting to Database
db2 connect to $database_name
db2 set schema $schema_name

# Creates Tables for the Database EDIDBD
db2 -tvf $sourcepath/270_271/tables.sql>tables.log

# Executes the Stored Precedures for the Database EDIDBD
db2 -td@ -vf $sourcepath/270_271/procs.sql>procs.log
db2 -td@ -vf $sourcepath/270_271/uiprocs_270.sql>uiprocs.log
db2 -td@ -vf $sourcepath/270_271/tp_procs.sql>tpprocs.log
db2 -td@ -vf $sourcepath/270_271/util_procs.sql>utilprocs.log

#db2 -tvf $sourcepath/270_271/uigrant_270.sql
db2 -tvf $sourcepath/270_271/tpgrant.sql>tpgrant.log
db2 -tvf $sourcepath/270_271/grant.sql>grant.log

#sh $sourcepath/270_271/grant_properties.sh
else
	echo " ***** Properties file does not exist and your Script is Terminated ***** "
fi

db2 COMMIT WORK;
db2 CONNECT RESET;
db2 TERMINATE;
