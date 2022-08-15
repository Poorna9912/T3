#!/bin/bash
echo on
#######################################################
#Script to install 276_277 Tables and stored procedures 
#Author  : Nanaji Veturi
#Date    : AUG/24/2010	
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
db2 -tvf $sourcepath/276_277/tables.sql


# Executes the Stored Precedures for the Database EDIDBD
db2 -td@ -vf $sourcepath/276_277/procs.sql
db2 -tvf  $sourcepath/276_277/grant.sql

sh $sourcepath/276_277/grant_properties.sh

else
	echo " ***** Properties file does not exist and your Script is Terminated ***** "
fi

db2 COMMIT WORK;
db2 CONNECT RESET;
db2 TERMINATE;
