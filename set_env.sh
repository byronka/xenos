#!/bin/bash
echo
echo 'This is a script to assist with setting proper environment '
echo 'variables for use with this program.  You might put these  '
echo 'values into your ~/.bashrc or ~/.profile if they are handy  '
echo 'and do not conflict.'
echo
echo 'This command needs to be run from the top level of the qarma folder'
echo
echo 'searching for your OpenJdk 7 directory...'
echo 'This may take a while, we are searching the root down'
echo 

JAVA_HOME=$(readlink -f $(find / -name 'rt.jar' -type f -printf '%h\n' 2>/dev/null|egrep "1.7.0|7-openjdk")/../..)
echo 'JAVA_HOME='$JAVA_HOME
echo 'QARMA_HOME='$(pwd)
echo 'ANT_HOME='$(readlink -f ant/apache-ant-1.9.4)
echo 'CATALINA_HOME='$(readlink -f web_container/apache-tomcat-8.0.14/)
echo
echo 'set these into your .bashrc or .profile config files,'
echo 'and also set the path:'
echo
echo 'PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$CATALINA_HOME/bin:$PATH'
echo 'export JAVA_HOME ANT_HOME CATALINA_HOME PATH'
echo
