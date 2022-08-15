#!/bin/bash
echo on
###############################################################################
# Script to install 835 Tables and stored procedures 
# Author  : Nanaji Veturi
# Date    : jun/02/2010	
# Project : BCBSM
# Version : 0.1
###############################################################################
# Read the properties file
. ../bcbsm_db_install.properties
# Checking Properties File exists or not
###############################################################################
if [ -e   ../bcbsm_db_install.properties ] ; then
###############################################################################


###############################################################################
# Connecting to Database
###############################################################################
db2 connect to $database_name
db2 set schema $schema_name

###############################################################################
# Creates Tables for the Database EDIDBD/EDIDBT
###############################################################################
db2 -tvf $sourcepath/835/tables.sql

###############################################################################
# Executes the Stored Precedures for the Database EDIDBD
###############################################################################
db2 -td@ -vf $sourcepath/835/procs.sql 
db2 -tvf $sourcepath/835/Grant.sql
else
	echo " ***** Properties file does not exist and your Script is Terminated ***** "
fi

db2 COMMIT WORK;
db2 CONNECT RESET;
db2 TERMINATE;
