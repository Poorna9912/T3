#!/bin/bash
echo on
#######################################################
#Script to delete data 837 Tables
#Author  : Nanaji Veturi
#Date    : jun/02/2010	
#Project : BCBSM
#Version : 0.1
#######################################################

# Checking Properties File exists or not

if [ -e bcbsm_db_delete.properties ] ; then

# Read the properties file
. ./bcbsm_db_delete.properties

# Connecting to Database
db2 connect to $database_name

# Creates Tables for the Database EDIDBD
db2 -tvf 835_delete.sql

else
	echo " ***** Properties file does not exist and your Script is Terminated ***** "
fi

db2 COMMIT WORK;
db2 CONNECT RESET;
db2 TERMINATE;
