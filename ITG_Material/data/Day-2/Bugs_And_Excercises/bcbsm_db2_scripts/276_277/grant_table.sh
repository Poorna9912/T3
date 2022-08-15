#!/bin/bash

if [ -e ./bcbsm_db_install.properties ] ; then

# Read the properties file
. ./bcbsm_db_install.properties

fi
# Connecting to Database
db2 connect to $database_name
db2 set schema $schema_name

user_name=$1
objects=(T_RT_276_277_ACKN_MSG T_RT_276_ANSI_MSG T_RT_276_CTRL_LOG T_RT_SRC_TRAN_CTRL_AAA_ERR_CD T_RT_277_XML_MSG T_RT_277_ANSI_MSG T_RT_276_XML_MSG T_UI_276_CTRL_LOG)
shift
for object in ${objects[*]}
do
	for permission in $*
	do

echo "db2 GRANT $permission ON TABLE "EDIDB2A"."$object" TO USER $user_name" >> grant_table.log
db2 GRANT $permission ON TABLE "EDIDB2A"."$object" TO USER $user_name >> grant_table.log

	done
done

db2 CONNECT RESET
