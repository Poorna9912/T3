#!/bin/bash
#echo on
#######################################################
#Script to install table spaces & buffer pools
#Author  : Nanaji Veturi
#Date    : jun/02/2010	
#Project : BCBSM
#Version : 0.1
#######################################################

# Read the properties file
. /home/edidb2a/db2_scripts/tablespaces/bcbsm_db_install.properties

# Checking Properties File exists or not

if [ -e $sourcepath/tablespaces/bcbsm_db_install.properties ] ; then

# Read the properties file
. $sourcepath/tablespaces/bcbsm_db_install.properties

# Creates DB2DS30 Database, Buffer Pools, Tablespaces
#db2 -z $sourcepath/Messages/db_creation.out -td@ -vf $sourcepath/bcbsm_db_script/BCBSM_DB_SCRIPT.sql

# Connecting to Database
db2 connect to $database_name
db2 set schema $schema_name

# Creates Tables for the Database EDIDBD
db2 -tvf $sourcepath/tablespaces/dbscript.sql
else
	echo " ***** Properties file does not exist and your Script is Terminated ***** "
fi

db2 COMMIT WORK;
db2 CONNECT RESET;
db2 TERMINATE;
