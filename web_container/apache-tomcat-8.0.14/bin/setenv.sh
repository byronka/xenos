CLASSPATH=$CATALINA_HOME/../../lib/mysql-connector-java-5.1.33-bin.jar
CATALINA_PID=$CATALINA_HOME/temp/pidfile
TOMCAT_TIMEZONE="-Duser.timezone=GMT"
CATALINA_OPTS="$CATALINA_OPTS $TOMCAT_TIMEZONE"
JAVA_OPTS="$JAVA_OPTS -Doracle.jdbc.defaultNChar=true -Xms128m -Xmx128m"
