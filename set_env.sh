#!/bin/bash
#This is a script to assist with setting proper environment variables for use
#with this program.  You might put these values into your ~/.bashrc or ~/.profile
#if they are handy and don't conflict.

#To set these into your environment, you must run the following:
#
#source set_env.sh
#
QARMA_HOME=$(pwd)
JAVA_HOME=$(readlink -f $(find / -name 'rt.jar' -type f -printf '%h\n' 2>/dev/null|grep 1.7.0)/../..)
ANT_HOME=$(readlink -f ant/apache-ant-1.9.4)
CATALINA_HOME=$(readlink -f web_container/apache-tomcat-8.0.14/)
PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$CATALINA_HOME/bin:$PATH
export JAVA_HOME ANT_HOME CATALINA_HOME PATH
