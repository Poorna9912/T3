user_name=$1
objects=(T_RT_270_ACKN_MSG T_RT_270_ANSI_MSG T_RT_270_CAREN_UN_MAP_CD T_RT_270_CTRL_LOG T_RT_270_XML_MSG T_RT_271_ANSI_MSG T_RT_271_XML_MSG T_UI_270_CTRL_LOG VIEW_RT_SEARCH VIEW_RT_ACK_SEARCH)
shift
for object in ${objects[*]}
do
	for permission in $*
	do

echo "db2 GRANT $permission ON TABLE "EDIDB2A"."$object" TO USER $user_name" >> grant_table.log
db2 GRANT $permission ON TABLE "EDIDB2A"."$object" TO USER $user_name >> grant_table.log

	done
done


